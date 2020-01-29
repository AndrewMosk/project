import service.Database;
import service.Mail;
import service.Utils;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class Replication {
    private Statement stmt;
    private Map<String, ArrayList<String>> states;
    private Mail mail;

    private class LoadResult {
        private boolean continueLoad;
        private boolean attemptLoadOwner;

        public LoadResult() {
            this.continueLoad = true;
            this.attemptLoadOwner = false;
        }

        public void setDefault() {
            this.continueLoad = true;
            this.attemptLoadOwner = false;
        }
    }

    public Replication() {
        this.stmt = Database.getStmt();
        this.states = new TreeMap<>();
        this.mail = new Mail();
    }

    private boolean deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
        //LoadResult loadResult = new LoadResult();
        String errorSql;
        try {
            stmt.executeUpdate(sqlQuery.toString());
        } catch (SQLException e) {
            // если ошибка связана с транзакционностью вызываю метод удаления еще раз
            if (Utils.transactionError(e.getMessage())) {
                //loadResult.continueLoad = true;
                return true;
            } else {
                // если какая-то другая ошибка (синтаксис или скажем неверный порядок вызова скрипта удаления) тогда запись в лог ошибок и переход к следующему
                errorSql = Utils.insertToErrorLog("D", table, e.getMessage().replace("'", ""));
                stmt.executeUpdate(errorSql);
            }
        }

        return false;
    }

    public void startReplication() throws SQLException, IOException {
//        -----------------------------------------------------------------
//        lineByLineLoad("vac", "VAC_KVOT_RM");
//        -----------------------------------------------------------------

        System.out.println("start replication");
//        //удаление данных
        String[][] tablesArrayD = Utils.getTablesOperationD();
        boolean continueLoad;
        for (String[] tables : tablesArrayD) {
            String dir = tables[0];

            for (int i = 1; i < tables.length; i++) {
                StringBuilder sqlQuery = new StringBuilder(Utils.readSqlQuery("scripts/" + dir + "/d/" + tables[i].toLowerCase() + ".sql"));
                continueLoad = true;

                while (continueLoad) {
                    System.out.println("Deleting table " + tables[i]);
                    continueLoad = deleteRows(sqlQuery, tables[i]);
                }
            }
        }

        // добавление/изменение данных
        String[][] tablesArray = Utils.getTables();
        boolean loadSuccessful;

        for (String[] tables : tablesArray) {
            String dir = tables[0];

            // подгружаю все данные на обмен по текущим таблицам
            uploadDataForReplication(tables);

            for (int i = 1; i < tables.length; i++) {

                if (tables[i].startsWith("*")) {
                    loadSuccessful = packageLoad(dir, tables[i]);

                    // loadSuccessful ложь только в том случае, когда произошла ошибка загрузки родительской таблицы
                    // в этом случае загрузку таблиц-наследников тоже прерываю и перехожу к следующему блоку таблиц
                    if (!loadSuccessful) {
                        break;
                    }
                } else {
                    System.out.println("start lineByLineLoad " + tables[i]);

                    lineByLineLoad(dir, tables[i]);

                    System.out.println("finish lineByLineLoad " + tables[i]);
                }
            }
        }
    }

    private void uploadDataForReplication(String[] tables) {
        states.clear();
        String sql;
        boolean continueLoad;

        for (int i = 1; i < tables.length; i++) {
            continueLoad = true;
            sql = Utils.getReplicationLog(tables[i].replace("*", ""), "S");

            while (continueLoad) {
                continueLoad = loadCurrentTable(sql, tables[i]);
            }

        }
    }

    private boolean loadCurrentTable(String sql, String table) {
        ArrayList<String> listUpdateInsert = new ArrayList<>();
        ResultSet rs;
        boolean startsWithStar;
        try {
            rs = stmt.executeQuery(sql);
            startsWithStar = table.startsWith("*");

            while (rs.next()) {
                if (startsWithStar) {
                    listUpdateInsert.add("'" + rs.getString("r_table") + "'");
                } else {
                    listUpdateInsert.add(rs.getString("r_table"));
                }
            }
        } catch (SQLException e) {
            // здесь могут быть только два типа ошибок - либо транзакционная либо нарушена связь с БД. первый случай - загружаю еще раз, второй - выход из программы и оповещение на email.
            if (Utils.transactionError(e.getMessage())) {
                return true;
            }
        }

        states.put(table, listUpdateInsert);
        return false;
    }

    private boolean packageLoad(String dir, String table) throws SQLException, IOException {
        System.out.println("start packageLoad " + table);
        String errorSql;
        boolean continueLoad;

        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(table);
        table = table.replace("*", "");

        // задаю лимит на загрузку
        int limit = 1000;
        int numberIterations = (int) Math.ceil(listUpdateInsert.size() / (double) limit);
        //подгружаю текст sql запроса
        String sqlQuery = Utils.readSqlQuery("scripts/" + dir + "/s/" + table.toLowerCase() + ".sql");
        String sql;
        String listToString;

        List<String> listUpdateInsertLimited;
        for (int i = 0; i < numberIterations; i++) {
            int upperLimit = (i + 1) * limit;

            if (upperLimit > listUpdateInsert.size()) {
                upperLimit = listUpdateInsert.size();
            }

            listUpdateInsertLimited = listUpdateInsert.subList(i * limit, upperLimit);

            listToString = listUpdateInsertLimited.toString();
            listToString = Utils.changeBrackets(listToString);

            if (table.equals("PERS") || table.equals("PERS_DOP")) {
                // в скрипте PERS параметр нужно задать трижды
                sql = String.format(sqlQuery, listToString, listToString, listToString);
            } else {
                sql = String.format(sqlQuery, listToString, listToString);
            }

            continueLoad = true;
            try {
                while (continueLoad) {
                    continueLoad = loadPack(sql);
                }
            } catch (Exception e) {
                if (dir.equals(table.toLowerCase())) {
                    // ошибка в загрузке родительской таблицы - прерывание цикла загрузки подчиненных и оповещение на email
                    mail.send("Ошибка загрузки таблицы " + table, e.getMessage());

                    return false;
                }

                // запись в БД информации об ошибке
                errorSql = Utils.insertToErrorLog("", table, e.getMessage());
                stmt.executeUpdate(errorSql);
            }
        }
        System.out.println("finish packageLoad " + table);
        return true;
    }

    private boolean loadPack(String sql) throws RuntimeException {
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            if (Utils.transactionError(e.getMessage())) {
                return true;
            } else {
                // если ошибка не транзакционного характера, бросаю исключение и прекращаю загрузку таблицы и ее дочерних
                throw new RuntimeException();
            }
        }
        return false;
    }

    private void lineByLineLoad(String dir, String currentTable) throws SQLException, IOException {
        LoadResult loadResult = new LoadResult();

        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(currentTable);
//        -----------------------------------------------------------------
//        ArrayList<String> listUpdateInsert = new ArrayList<>();
//        listUpdateInsert.add("2130022706"); // нет
//        listUpdateInsert.add("2130022705"); // нет
//        listUpdateInsert.add("9910363515"); // есть в ора, нет в постгри
//        -----------------------------------------------------------------

        //подгружаю общий текст sql запроса
        String sqlQuery = Utils.readSqlQuery("scripts/" + dir + "/s/" + currentTable.toLowerCase() + ".sql");

        for (String code : listUpdateInsert) {
            loadResult.setDefault();
            // формирую запрос с кодом строки
            String sql = String.format(sqlQuery, code, code);
            // пока строка не будет загружена или не будут обработаны возможные ошибки, пытаюсь ее загрузить
            while (loadResult.continueLoad) {
                loadLine(sql, code, currentTable, loadResult);
            }
        }
    }

    private void loadLine(String sql, String code, String currentTable, LoadResult loadResult) throws IOException, SQLException {
        String errorSql;
        try {
            // инсерт/апдейт строки в базу и удаление из replog
            stmt.executeUpdate(sql);
        } catch (Exception e) {
            // если ошибка транзакционная, пробую загрузить строку еще раз
            if (Utils.transactionError(e.getMessage())) {
                return;
            }

            // если у строки отсутсвует владелец, пытаюсь загрузить его; если попытка загрузки уже была, а владелец так и не найден (несогласованность данных в БД)
            // записываю ошибку в лог ошибок и удаляю строку из реплога
            if (Utils.ownerError(e.getMessage())) {
                // проверяю пробовал ли уже загружать владельца
                if (!loadResult.attemptLoadOwner) {
                    // генерериую запрос для загрузки владельца
                    errorSql = Utils.generateLoadOwnerSql(e.getMessage());
                    try {
                        stmt.executeUpdate(errorSql);
                    } catch (Exception e1) {
                        // ловлю ошибку просто, чтоб программа не упала. вообще, тут ошибки быть не должно, разве что транзакционная
                    }
                    // ставлю флаг истина, что попытка загрузки владельца состоялась и отправляю строку наследника на загрузку еще раз
                    loadResult.attemptLoadOwner = true;
                    return;
                } else {
                    // попытка загрузки владельца была, но ошибка осталась - удаление из реплога
                    stmt.executeUpdate(Utils.deleteFromOraReplog(currentTable, code));
                }
            }

            // если программа пришла сюда, значит встретилась ошибка, для которой алгоритм обработки не предусмотрен. или владелец так и не был найден;
            // записываю ее в лог ошибок и перехожу к следующей строке
            errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage().replace("'", ""));
            stmt.executeUpdate(errorSql);
        }
        loadResult.continueLoad = false;
    }
}