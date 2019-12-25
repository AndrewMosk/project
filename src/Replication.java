import service.Database;
import service.Mail;
import service.Utils;
import java.sql.*;
import java.util.*;

public class Replication{
    //private Connection connection;
    private Statement stmt;
    private Map<String , ArrayList<String>> states;
    //private PreparedStatement preparedStatement;

    public Replication() {
        //Connection connection = Database.getConnection();
        this.stmt = Database.getStmt();
        this.states =  new TreeMap<String, ArrayList<String>>();
    }

    public void startReplication() throws SQLException {
        String[][] tablesArray = Utils.getTables();
        String mainTable;
        int updatedRows;

        for (String[] tables : tablesArray) {
            updatedRows = 0;
            // нулевой элемент массива - таблица-владелец. алгоритм ее загрузки отличается - ее гружу не по строчно, а пачкой
            // есть массив с неструктурированными таблицами (не имеют таблицы-владельца), тогда нулевой элемент - пустая строка
            mainTable = tables[0];
            boolean isMainTableEmpty = mainTable.isEmpty();

            // подгружаю все данные на обмен по текущим таблицам
            uploadDataForReplication(tables, isMainTableEmpty);

            // если основная таблица не пуста, загружаю ее
            if (!isMainTableEmpty) {
                updatedRows = replicateMainTable(mainTable);
            }

            //  -1 вернется только из блока catch, если будет выброшено исключение, во всех остальных случаях продолжаю загрузку
            if (updatedRows != -1) {
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
        //String errors = "";
        int startIndex = 0;
        // если нулевой элемент пуст (таблица владелец не задана), то обход массива начинаю с первого элемента
        if (isMainTableEmpty) {
            startIndex = 1;
        }

        for (int i = startIndex; i < tables.length; i++) {
            sql = Utils.getReplicationLog(tables[i], "S");

            ResultSet rs = stmt.executeQuery(sql);
            ArrayList<String> listUpdateInsert = new ArrayList<>();
            while (rs.next()) {
                listUpdateInsert.add("'" + rs.getString("r_table") +"'");
            }

            states.put(tables[i], listUpdateInsert);
        }
    }

    private int replicateMainTable(String table) throws SQLException {
        // на сколько я понимаю, здесь манипуляции с коммитом тоже не нужны. по умолчанию автокоммит = истина, т.е. после каждого апдейта
        // изменения сохраняются в БД, ну а в случае ошибки во время выполнения инсерта/апдейта происходит откат и ничего не записывается, так что комментирую
        int updatedRows = 0;
        //connection.setAutoCommit(false);

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
                listToString = Utils.changeBrackets(listToString);

                sql = String.format(Utils.readSqlQuery("scripts/" + table + "/s/" + table + ".sql"), listToString);
                updatedRows += stmt.executeUpdate(sql);

                sql = Utils.deleteFromReplicationLog(table, listToString);
                stmt.executeUpdate(sql);

                //connection.commit();
            }
        }catch (Exception e) {
            //connection.rollback();
            // оповещение об ошибке
            Mail mail = new Mail();
            mail.send("Ошибка загрузки таблицы " + table, e.getMessage(), "support@t-project.com", "moskaletsandrey@yandex.ru");

            updatedRows = -1;
        }

        return updatedRows;
    }

    private void replicateTable(String mainTable, String currentTable) throws SQLException {
        int updatedRows = 0;
        // нужен ли тут автокиммит фолс? думаю, что не нужен! почему? да потому что пройденная строка должна
        // тут зависит от того, как именно будут записыаться данные.
        // а записываться они будут построчно в блоке try catch.
        // получается так: есть массив кодов, прохожу его в цикле, инсерт/апдейт прошел - хорошо, удаляется строка из реплога и коммит
        // след итерация: инсерт/апдейт не прошел - ошибка! идет запись в БД ошибки, коммита нет, идет следующая итерация
        // а в следующую репликацию строка уже не попадет - отсеится по отбору (не в селекте из лога ошибок)

        //  и вопрос - нужен ли в итоге автокоммит? думается мне, что не нужен! автокомиит - тру, это когда каждый вызов инсерта/апдейта происходит в отдельной транзакции
        // что по логике моего алгортима как раз мне и требуется!

        //connection.setAutoCommit(false);

        ArrayList<String> listUpdateInsert = states.get(mainTable);

        for (String code: listUpdateInsert) {
            // инсерт/апдейт строки в базу
            try {
                String sql = String.format(Utils.readSqlQuery("scripts/" + mainTable.toLowerCase() + "/s/" + currentTable.toLowerCase() + ".sql"), code);
                updatedRows += stmt.executeUpdate(sql);

                // удаление строки из реплога
                //...
            } catch (Exception e) {
                // запись в БД информации об ошибке
                String sql = Utils.insertToErrorLog(code, currentTable, e.getMessage());
                stmt.executeUpdate(sql);
            }


        }


    }
}