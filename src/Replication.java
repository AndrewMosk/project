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

    public Replication() {
        this.stmt = Database.getStmt();
        this.states = new TreeMap<>();
        this.mail = new Mail();
    }

    private boolean deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
        String errorSql;
        try {
            stmt.executeUpdate(sqlQuery.toString());
        } catch (SQLException e) {
            // если ошибка связана с транзакционностью вызываю метод удаления еще раз
            if (transactionError(e.getMessage())) {
                return true;
            } else {
                // если какая-то другая ошибка (синтаксис или скажем неверный порядок вызова скрипта удаления) тогда запись в лог ошибок и перехол к следующему
                errorSql = Utils.insertToErrorLog("D", table, e.getMessage().replace("'", ""));
                stmt.executeUpdate(errorSql);
            }
        }

        return false;
    }

    public void startReplication() throws SQLException, IOException {
        System.out.println("start replication");
        // удаление данных
        String[][] tablesArrayD = Utils.getTablesOperationD();
        for (String[] tables : tablesArrayD) {
            String dir = tables[0];

            for (int i = 1; i < tables.length; i++) {
                StringBuilder sqlQuery = new StringBuilder(Utils.readSqlQuery("scripts/" + dir + "/d/" + tables[i].toLowerCase() + ".sql"));

                boolean fail = true;
                while (fail) {
                    fail = deleteRows(sqlQuery, tables[i]);
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

                    // loadSuccessful ложь только в том случае, когда произошлоа ошибка загрузки родительской таблицы
                    // в этом случае загрузку таблиц-наследников тоже прерываю и перехожу к следующему блоку таблиц
                    if (!loadSuccessful) {
                        break;
                    }
                } else {
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
                if (!transactionError(e.getMessage())) {
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
        System.out.println("start lineByLineLoad " + currentTable);
        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(currentTable);
        //подгружаю текст sql запроса
        String sqlQuery = Utils.readSqlQuery("scripts/" + dir + "/s/" + currentTable.toLowerCase() + ".sql");
        String sql;
        String errorSql;
        int counter = 0;
        for (String code : listUpdateInsert) {
            // построчная обработка данных
            try {
                // инсерт/апдейт строки в базу и удаление из replog
                sql = String.format(sqlQuery, code, code);
                stmt.executeUpdate(sql);
            } catch (Exception e) {
                // проверяю, что не содержит коды ошибок связанных транзакциями
                if (!transactionError(e.getMessage())) {
                    // запись в БД информации об ошибке
                    errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage().replace("'", ""));

                    stmt.executeUpdate(errorSql);
                }
            }
            counter++;
        }
        System.out.println("finish lineByLineLoad " + currentTable);
    }

    private boolean transactionError(String message) {
        // перенести в Utils
        boolean result = false;

        if ((message.contains("08177") || message.contains("01555"))) {
            result = true;
        }

        return result;
    }
}