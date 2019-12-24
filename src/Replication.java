import db.Database;
import email.Mail;
import java.sql.*;
import java.util.*;

public class Replication{
    private Connection connection;
    private Statement stmt;
    private Map<String , ArrayList<String>> states;
    //private PreparedStatement preparedStatement;

    public Replication() {
        this.connection = Database.getConnection();
        this.stmt = Database.getStmt();
        this.states =  new TreeMap<String, ArrayList<String>>();
    }

    public void startReplication() throws SQLException {
        String[][] tablesArray = getTables();
        int updatedRows;

        for (String[] tables : tablesArray) {
            updatedRows = 0;
            // нулевой элемент массива - таблица-владелец. алгоритм ее загрузки отличается - ее гружу не по строчно, а пачкой
            // есть массив с неструктурированными таблицами (не имеют таблицы-владельца), тогда нулевой элемент - пустая строка
            boolean isMainTableEmpty = tables[0].isEmpty();
            uploadDataForReplication(tables, isMainTableEmpty);

            if (isMainTableEmpty) {
                updatedRows = replicateMainTable(tables[0]);
            }

            // отправка оповещения об ошибке загрузки таблицы-владельца. -1 вернется только из блока catch, если будет выброшено исключение
            // если загружено 0 строк или таблица-владелец отсутствует, то сюда придет 0 и алгоритм пойдет по ветке else
            if (updatedRows == -1) {
                // в загрузке главной таблицы ошибок быть не должно. потому если вернулся код ошибки (-1), работу прекращаю и оповещаю об ошибке.
                Mail mail = new Mail();
                mail.send("Ошибка загрузки таблицы " + tables[0], "Ошибка!", "support@t-project.com", "moskaletsandrey@yandex.ru");
            }else {
                // если родительская таблица загружена без ошибок, начинаю загрузку подчиненных
                System.out.println("Загружена таблица " + tables[0] +" Изменено " + updatedRows + " строк.");

                for (int i = 1; i < tables.length; i++) {
                    //replicateTable(tables[0], tables[i]);
                    // ЗАГРУЗКА ПОДЧИНЕННОЙ ТАБЛИЦЫ ПОСТРОЧНО!
                    // и как загружать построчно? а загружать нужно следующим образом - тот же самый скрипт, что и для основной таблицы, только в массиве будет 1 элемент
                    // нужно проверить, есть ли разница между (r = %s) и (r IN (%s)) при условии, что в массиве один элемент
                    // хотя, наверное, лучше все таки переделать
                    // ЗАПИСЬ ОШИБКИ В БД - ПАРСИТЬ СТРОКУ, ЧТОБ ВЫЧЛЕНИТЬ КОД - коды записывать уже с кавычками! ' '
                    // ЧТЕНИЕ ИЗ ФАЙЛА ОДНОГО СКРИПТА ДЕЛАТЬ 1 РАЗ!!! В СТРОКУ СЧИТЫВАТЬ, ПОТОМ ТОЛЬКО ЗНАЧЕНИЯ ПОДСТАВЛЯТЬ

                    String t = tables[i];
                }
            }

        }

    }

    private void uploadDataForReplication(String[] tables, boolean isMainTableEmpty) throws SQLException {
        states.clear();
        String sql;
        String errors = "";
        int startIndex = 0;
        // если нулевой элемент пуст (таблица владелец не задана), то обход массива начинаю с первого элемента
        if (isMainTableEmpty) {
            startIndex = 1;
        }

        for (int i = startIndex; i < tables.length; i++) {
            // не включаю в выгрузку строки, по текущей таблице из лога ошибок
            errors = uploadErrorRows(tables[i]);
            sql = getReplicationLog(tables[i], "S", errors);

            ResultSet rs = stmt.executeQuery(sql);
            ArrayList<String> listUpdateInsert = new ArrayList<>();
            while (rs.next()) {
                listUpdateInsert.add("'" + rs.getString("r_table") +"'");
            }

            states.put(tables[i], listUpdateInsert);
        }
    }

    private String  uploadErrorRows(String table) throws SQLException {
        ArrayList<String> errorRows = new ArrayList<>();
        String errorRowsString = "";
        String sql = gerError(table);

        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            errorRows.add("'" + rs.getString("r") +"'");
        }
        if (errorRows.size() > 0) {
            errorRowsString = errorRows.toString();
            errorRowsString = changeBrackets(errorRowsString);
        }
        return errorRowsString;
    }

    private int replicateMainTable(String table) throws SQLException {
        int updatedRows = 0;
        connection.setAutoCommit(false);

        ArrayList<String> listUpdateInsert = states.get(table);
        int limit = 1000;
        int numberIterations = (int)Math.ceil(listUpdateInsert.size()/(double)limit);
        String sql;
        String listToString;

        List<String> listUpdateInsertLimited;
        try {

            for (int i = 0; i < numberIterations; i++) {
                int upperLimit = (i + 1) * limit;

                if (upperLimit > listUpdateInsert.size()) {
                    upperLimit = listUpdateInsert.size();
                }

                listUpdateInsertLimited = listUpdateInsert.subList(i * limit, upperLimit);

                listToString = listUpdateInsertLimited.toString();
                listToString = changeBrackets(listToString);

                sql = String.format(Database.readSqlQuery("scripts/" + table + "/s/" + table + ".sql"), listToString);
                updatedRows += stmt.executeUpdate(sql);

                sql = deleteFromReplicationLog(table, listToString);
                stmt.executeUpdate(sql);

                connection.commit();
            }
        }catch (Exception e) {
            e.printStackTrace();
            connection.rollback();
            // оповещение об ошибке
            Mail mail = new Mail();
            mail.send("Ошибка загрузки таблицы " + table, e.getMessage(), "support@t-project.com", "moskaletsandrey@yandex.ru");

            updatedRows = -1;
        }

        return updatedRows;
    }

    private void replicateTable(String mainTable, String currentTable) throws SQLException {
        // коды ошибок добавляю сразу в запрос к реплогу!
        // но не здесь!! этот фильтр нужно ставить на момент, когда я из базы в программу подкачиваю все коды из реплога!

        ResultSet rs = stmt.executeQuery(getReplicationLog(currentTable, "S", "")); // ДОБАВИТЬ КОДЫ ОШИБОК!
        ArrayList<String> list = new ArrayList<>();
        while (rs.next()) {
            list.add(rs.getString("r_table"));
        }

        StringBuilder listString = new StringBuilder(list.toString());
        listString.replace(0,1,"(");
        listString.replace(listString.length()-1,listString.length(),")");

        String sql = String.format(Database.readSqlQuery("scripts/" + mainTable.toLowerCase() + "/s/" + currentTable.toLowerCase() + ".sql"), listString);

        int updatedRows = stmt.executeUpdate(sql);

        // запуск в цикле, пока не вернтеся 0

//        // массив как параметр запроса
//        String sql = String.format("select c_client from cl where c_client in %s", listString);
//        rs = null;
//        rs = stmt.executeQuery(sql);
//
//        ArrayList<String> list1 = new ArrayList<>();
//        while (rs.next()) {
//            list1.add(rs.getString("c_client"));
//        }
//        int i = 1;
//        System.out.println(list1);
    }

    // служебные
    private String changeBrackets(String string) {
        string = string.replace("[", "(");
        string = string.replace("]", ")");

        return string;
    }

    private String getReplicationLog(String n_table, String operation, String errorCodes) {
        if (errorCodes.isEmpty()) {
            return String.format("SELECT ora_replog999.\"R_TABLE\" FROM ora_replog999 WHERE \"N_TABLE\" = '%s' AND \"OPER\" = '%s' ", n_table, operation);
        } else {
            return String.format("SELECT ora_replog999.\"R_TABLE\" FROM ora_replog999 WHERE \"N_TABLE\" = '%s' AND \"OPER\" = '%s' AND \"R_TABLE\" NOT IN %s", n_table, operation, errorCodes);
        }
    }

    private String deleteFromReplicationLog(String n_table, String codes) {
        return String.format("DELETE FROM ora_replog999 WHERE \"N_TABLE\" = '%s' AND \"R_TABLE\" IN %s", n_table, codes);
    }

    private String getCount(String n_table, String operation) {
        return String.format("SELECT COUNT(*) FROM ora_replog999 WHERE \"N_TABLE\" = '%s' AND \"OPER\" = '%s'", n_table, operation);
    }

    private String gerError(String table) {
        return String.format("SELECT r FROM error_repl_log WHERE table = '%s'", table);
    }

    private String[][] getTables() {
        return new  String[][]  {
                {"CL", "CL_ADDRESS", "CL_BANK", "CL_CONTACT", "CL_OKVED", "CL_P", "CL_POTR", "CL_POTRV", "CL_PSPIS", "CL_REZ", "CL_MV", "CL_MVNP", "CL_MVPERS", "CL_MVRAB",
                        "CL_MVSPIS", "CL_Z", "CL_ZSPIS", "CL_ZV", "CL_ZVSPIS", "CL_SR"}

//                {"PERS", "PERS_BOLN", "PERS_BOOK", "PERS_DEF", "PERS_LANG", "PERS_OR", "PERS_PCL", "PERS_POOR", "PERS_PROF", "PERS_PROFIL", "PERS_REZ", "PERS_SIELEV", "PERS_SPEC",
//                        "PERS_SPEN", "PERS_STAJ"}
        };
    }



}
