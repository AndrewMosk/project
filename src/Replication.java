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

    private LoadResult deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
        LoadResult loadResult = new LoadResult();
        String errorSql;
        try {
            stmt.executeUpdate(sqlQuery.toString());
        } catch (SQLException e) {
            // если ошибка связана с транзакционностью вызываю метод удаления еще раз
            if (Utils.transactionError(e.getMessage())) {
                loadResult.continueLoad = true;
                return loadResult;
            } else {
                // если какая-то другая ошибка (синтаксис или скажем неверный порядок вызова скрипта удаления) тогда запись в лог ошибок и переход к следующему
                errorSql = Utils.insertToErrorLog("D", table, e.getMessage().replace("'", ""));
                stmt.executeUpdate(errorSql);
            }
        }

        return loadResult;
    }

    public void startReplication() throws SQLException, IOException {
        // !!!РАЗОБРАТЬСЯ С НЕСТРУКТУРИРОВАННЫМИ!!!
//        -----------------------------------------------------------------
        lineByLineLoad("vac", "VAC_KVOT_RM");

//        -----------------------------------------------------------------

//        System.out.println("start replication");
//        //удаление данных
//        String[][] tablesArrayD = Utils.getTablesOperationD();
//        for (String[] tables : tablesArrayD) {
//            String dir = tables[0];
//
//            for (int i = 1; i < tables.length; i++) {
//                StringBuilder sqlQuery = new StringBuilder(Utils.readSqlQuery("scripts/" + dir + "/d/" + tables[i].toLowerCase() + ".sql"));
//
//                boolean continueLoad = true;
//                while (continueLoad) {
//                    System.out.println("Deleting table " + tables[i]);
//                    continueLoad = deleteRows(sqlQuery, tables[i]).continueLoad;
//                }
//            }
//
//        }
//
////        // добавление/изменение данных
//        String[][] tablesArray = Utils.getTables();
//        boolean loadSuccessful;
//
//        for (String[] tables : tablesArray) {
//            String dir = tables[0];
//
//            // подгружаю все данные на обмен по текущим таблицам
//            uploadDataForReplication(tables);
//
//            for (int i = 1; i < tables.length; i++) {
//
//                if (tables[i].startsWith("*")) {
//                    loadSuccessful = packageLoad(dir, tables[i]);
//
//                    // loadSuccessful ложь только в том случае, когда произошлоа ошибка загрузки родительской таблицы
//                    // в этом случае загрузку таблиц-наследников тоже прерываю и перехожу к следующему блоку таблиц
//                    if (!loadSuccessful) {
//                        break;
//                    }
//                } else {
//                    System.out.println("start lineByLineLoad " + tables[i]);
//
//                    lineByLineLoad(dir, tables[i], loadResult);
//
//                    System.out.println("finish lineByLineLoad " + tables[i]);
//                }
//            }
//        }
    }

    private void uploadDataForReplication(String[] tables) throws SQLException {
        states.clear();
        String sql;

        for (int i = 1; i < tables.length; i++) {
            sql = Utils.getReplicationLog(tables[i].replace("*", ""), "S");

            ResultSet rs = stmt.executeQuery(sql);
            ArrayList<String> listUpdateInsert = new ArrayList<>();
            boolean startsWithStar = tables[i].startsWith("*");

            while (rs.next()) {
                if (startsWithStar) {
                    listUpdateInsert.add("'" + rs.getString("r_table") + "'");
                } else {
                    listUpdateInsert.add(rs.getString("r_table"));
                }
            }

            states.put(tables[i], listUpdateInsert);
        }
    }

    private boolean packageLoad(String dir, String table) throws SQLException, IOException {
        System.out.println("start packageLoad " + table);
        // на сколько я понимаю, здесь манипуляции с коммитом тоже не нужны. по умолчанию автокоммит = истина, т.е. после каждого апдейта
        // изменения сохраняются в БД, ну а в случае ошибки во время выполнения инсерта/апдейта происходит откат и ничего не записывается, так что комментирую
        String errorSql;

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
            try {
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
                stmt.executeUpdate(sql);
            } catch (Exception e) {
                if (dir.equals(table.toLowerCase())) {
                    // ошибка в загрузке родительской таблицы - прерывание цикла загрузки подчиненных и оповещение на email
                    mail.send("Ошибка загрузки таблицы " + table, e.getMessage());

                    return false;
                }

                // если ошибка не связана с блокировкой транзакций, тогда записываю ее в лог ошибок и продолжаю загрузку
                if (!Utils.transactionError(e.getMessage())) {
                    // запись в БД информации об ошибке
                    errorSql = Utils.insertToErrorLog("", table, e.getMessage());

                    stmt.executeUpdate(errorSql);
                }
            }
        }
        System.out.println("finish packageLoad " + table);
        return true;
    }

    private void lineByLineLoad(String dir, String currentTable) throws SQLException, IOException {
        LoadResult loadResult = new LoadResult();

        // получаю список кодов по текущей таблице
        //ArrayList<String> listUpdateInsert = states.get(currentTable);
//        -----------------------------------------------------------------
        ArrayList<String> listUpdateInsert = new ArrayList<>();
        listUpdateInsert.add("2130022706"); // нет
        listUpdateInsert.add("2130022705"); // нет
        listUpdateInsert.add("9910363515"); // есть в ора, нет в постгри
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
                }
            }

            // если программа пришла сюда, значит встретилась ошибка, для которой алгоритм обработки не предусмотрен. или владелец так и не был найден;
            // записываю ее в лог ошибок и перехожу к следующей строке
            errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage().replace("'", ""));
            stmt.executeUpdate(errorSql);

            // удаление из реплога
            stmt.executeUpdate(Utils.deleteFromOraReplog(currentTable, code));

        }

        loadResult.continueLoad = false;
    }
}