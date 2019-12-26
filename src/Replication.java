import service.Database;
import service.Mail;
import service.Utils;
import java.sql.*;
import java.util.*;

public class Replication{
    private Statement stmt;
    private Map<String , ArrayList<String>> states;

    public Replication() {
        this.stmt = Database.getStmt();
        this.states = new TreeMap<>();
    }

    public void startReplication() throws SQLException {
        String[][] tablesArray = Utils.getTables();
        String mainTable;
        boolean mainTableDownloaded = true;

        for (String[] tables : tablesArray) {
            // нулевой элемент массива - таблица-владелец. алгоритм ее загрузки отличается - ее гружу не по строчно, а пачкой
            // есть массив с неструктурированными таблицами (не имеют таблицы-владельца), тогда нулевой элемент - пустая строка
            mainTable = tables[0];
            boolean isMainTableUnstructured = mainTable.equals("unstructured");

            // подгружаю все данные на обмен по текущим таблицам
            uploadDataForReplication(tables, isMainTableUnstructured);

            // если основная таблица имеет значение unstructured - означает, что загружать ее не надо. имя ей присвоино, чтобы открыть файлы из соответствующей папки
            if (!isMainTableUnstructured) {
                mainTableDownloaded = replicateMainTable(mainTable);
            }

            // если ложь, значит загрузка завершилась ошибкой и дальше не продолжаю
            if (!mainTableDownloaded) {
                return;
            }

            // загружаю подчиненные (или неструктурированные) таблицы
            for (int i = 1; i < tables.length; i++) {
                replicateTable(mainTable, tables[i]);
            }

        }
    }

    private void uploadDataForReplication(String[] tables, boolean isMainTableUnstructured) throws SQLException {
        states.clear();
        String sql;
        int startIndex = 0;
        // если нулевой элемент равен unstructured (таблица владелец не задана), то обход массива начинаю с первого элемента
        if (isMainTableUnstructured) {
            startIndex = 1;
        }

        for (int i = startIndex; i < tables.length; i++) {
            sql = Utils.getReplicationLog(tables[i], "S");

            ResultSet rs = stmt.executeQuery(sql);
            ArrayList<String> listUpdateInsert = new ArrayList<>();
            while (rs.next()) {
                if (i == 0) {
                    listUpdateInsert.add("'" + rs.getString("r_table") + "'");
                }else {
                    listUpdateInsert.add(rs.getString("r_table"));
                }
            }

            states.put(tables[i], listUpdateInsert);
        }
    }

    private boolean replicateMainTable(String table) throws SQLException {
        // на сколько я понимаю, здесь манипуляции с коммитом тоже не нужны. по умолчанию автокоммит = истина, т.е. после каждого апдейта
        // изменения сохраняются в БД, ну а в случае ошибки во время выполнения инсерта/апдейта происходит откат и ничего не записывается, так что комментирую
        boolean replicationSuccess = true;

        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(table);
        // задаю лимит на загрузку
        int limit = 1000;
        int numberIterations = (int)Math.ceil(listUpdateInsert.size()/(double)limit);
        //подгружаю текст sql запроса
        String sql = Utils.readSqlQuery("scripts/" + table + "/s/" + table + ".sql");
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
                listToString = Utils.changeBrackets(listToString);

                sql = String.format(sql, listToString, listToString);
                stmt.executeUpdate(sql);

            }
        }catch (Exception e) {
            // оповещение об ошибке
            Mail mail = new Mail();
            mail.send("Ошибка загрузки таблицы " + table, e.getMessage(), "support@t-project.com", "moskaletsandrey@yandex.ru");

            replicationSuccess = false;
        }

        return replicationSuccess;
    }

    private void replicateTable(String mainTable, String currentTable) throws SQLException {
        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(currentTable);
        //подгружаю текст sql запроса
        String sql = Utils.readSqlQuery("scripts/" + mainTable.toLowerCase() + "/s/" + currentTable.toLowerCase() + ".sql");
        String errorSql = "";
        for (String code: listUpdateInsert) {
            // построчная обработка данных
            try {
                // инсерт/апдейт строки в базу и удаление из replog
                sql = String.format(sql, code, code);
                stmt.executeUpdate(sql);
            } catch (Exception e) {
                // запись в БД информации об ошибке
                errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage());
                // проверяю, что не содержит коды ошибок связанных транзакциями
                if (!(errorSql.contains("08177") || errorSql.contains("01555"))) {
                    stmt.executeUpdate(errorSql);
                }
            }
        }
    }
}