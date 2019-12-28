import service.Database;
import service.Mail;
import service.Utils;
import java.sql.*;
import java.util.*;

public class Replication{
    private Statement stmt;
    private Map<String , ArrayList<String>> states;
    private Mail mail;

    public Replication() {
        this.stmt = Database.getStmt();
        this.states = new TreeMap<>();
        this.mail = new Mail();
    }

    public void startReplication() throws SQLException {
        String[][] tablesArray = Utils.getTables();
        boolean loadSuccessful;
        //String mainTable;
        //boolean mainTableDownloaded = true;

        // алгоритм требует имзменения
        // пачкой буду загружать не только родительские таблицы, но и неструктурированные и S
        // как тогда будет выглядеть алгоритм?
        // как вариант - просто добавить звездочку * в начало строки, которую нужно грузить пачкой

        // осталось учесть следующее - ошибка в packageLoad родительской таблице должна прерывать весь цикл загрузки текущего массива таблиц, а в в случае загрузки неструктурированных таблиц
        // или S просто переходить на следующую. даже не на следующую таблицу, а на следующую пачку! если, к примеру, грузится миллион по 100 тысяч
        // думаю, сделать так: если нулевой элемент массива равен привдененному к нижнему регистру и лишенному звездочки второму элементу (например "cl" и "*CL") - равны, значит
        // "*CL" - родительская таблица и ошибка в ее загрузке завершает цикл. если же "s" не равн "*S_ADEP"

        for (String[] tables : tablesArray) {
            String dir = tables[0];

            // подгружаю все данные на обмен по текущим таблицам
            uploadDataForReplication(tables);

            for (int i = 1; i < tables.length; i++) {

                if (tables[i].startsWith("*")) {
                    loadSuccessful = packageLoad(dir, tables[i].replace("*",""));

                    // loadSuccessful ложь только в том случае, когда произошлоа ошибка загрузки родительской таблицы
                    // в этом случае загрузку таблиц-наследников тоже прерываю и перехожу к следующему блоку таблиц
                    if (!loadSuccessful) {
                        break;
                    }
                }else {
                    lineByLineLoad(dir, tables[i]);
                }
            }
        }
    }

    private void uploadDataForReplication(String[] tables) throws SQLException {
        states.clear();
        String sql;

        for (int i = 1; i < tables.length; i++) {
            sql = Utils.getReplicationLog(tables[i].replace("*", ""), "S");

            ResultSet rs = stmt.executeQuery(sql);
            ArrayList<String> listUpdateInsert = new ArrayList<>();
            while (rs.next()) {
                if (tables[i].startsWith("*")) {
                    listUpdateInsert.add("'" + rs.getString("r_table") + "'");
                }else {
                    listUpdateInsert.add(rs.getString("r_table"));
                }
            }

            states.put(tables[i], listUpdateInsert);
        }
    }

    private boolean packageLoad(String dir, String table) throws SQLException {
        // на сколько я понимаю, здесь манипуляции с коммитом тоже не нужны. по умолчанию автокоммит = истина, т.е. после каждого апдейта
        // изменения сохраняются в БД, ну а в случае ошибки во время выполнения инсерта/апдейта происходит откат и ничего не записывается, так что комментирую
        String errorSql;

        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(table);
        // задаю лимит на загрузку
        int limit = 100000;
        int numberIterations = (int)Math.ceil(listUpdateInsert.size()/(double)limit);
        //подгружаю текст sql запроса
        String sql = Utils.readSqlQuery("scripts/" + table + "/s/" + table + ".sql");
        String listToString;


        List<String> listUpdateInsertLimited;
        for (int i = 0; i < numberIterations; i++) {
            try {
                int upperLimit = (i + 1) * limit;

                if (upperLimit > listUpdateInsert.size()) {
                    upperLimit = listUpdateInsert.size();
                }

                listUpdateInsertLimited = listUpdateInsert.subList(i * limit, upperLimit);

                listToString = listUpdateInsertLimited.toString();
                listToString = Utils.changeBrackets(listToString);

                if (table.equals("PERS")) {
                    // в скрипте PERS параметр нужно задать трижды
                    sql = String.format(sql, listToString, listToString, listToString);
                } else {
                    sql = String.format(sql, listToString, listToString);
                }
                stmt.executeUpdate(sql);
            }catch (Exception e) {
                if (dir.equals(table.toLowerCase())) {
                    // ошибка в загрузке родительской таблицы - прерывание цикла загрузки подчиненных и оповещение на email
                    mail.send("Ошибка загрузки таблицы " + table, e.getMessage());

                    return false;
                }

                // если ошибка не связана с блокировкой транзакций, тогда записываю ее в лог ошибок и продолжаю загрузку
                if (!transactionError(e.getMessage())) {
                    // запись в БД информации об ошибке
                    errorSql = Utils.insertToErrorLog("", table, e.getMessage());

                    stmt.executeUpdate(errorSql);
                }
            }
        }

        return true;
    }

    private void lineByLineLoad(String dir, String currentTable) throws SQLException {
        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(currentTable);
        //подгружаю текст sql запроса
        String sql = Utils.readSqlQuery("scripts/" + dir + "/s/" + currentTable.toLowerCase() + ".sql");
        String errorSql;
        for (String code: listUpdateInsert) {
            // построчная обработка данных
            try {
                // инсерт/апдейт строки в базу и удаление из replog
                sql = String.format(sql, code, code);
                stmt.executeUpdate(sql);
            } catch (Exception e) {
                // проверяю, что не содержит коды ошибок связанных транзакциями
                if (!transactionError(e.getMessage())) {
                    // запись в БД информации об ошибке
                    errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage());

                    stmt.executeUpdate(errorSql);
                }
            }
        }
    }

    private boolean transactionError(String message) {
        boolean result = false;

        if ((message.contains("08177") || message.contains("01555"))) {
            result = true;
        }

        return result;
    }
}