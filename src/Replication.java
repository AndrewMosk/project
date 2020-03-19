import service.Database;
import service.Mail;
import service.Utils;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class Replication {
    private Statement stmt;
    private Statement stmtOracle;
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
        this.stmt = Database.getStmtPostgre();
        this.states = new TreeMap<>();
        this.mail = new Mail();
    }

    //    private boolean deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
//        String errorSql;
//        try {
//            stmt.executeUpdate(sqlQuery.toString());
//        } catch (SQLException e) {
//
//            if (e.getMessage().contains("violates foreign key constraint")) {
//                // генерирую текст запроса для поиска foreign key
//                String foreignKeySql = Utils.getForeignKeySql(table.toLowerCase(), Utils.parseErrorGetChildTable(e.getMessage()));
//                ResultSet rs = stmt.executeQuery(foreignKeySql);
//                rs.next();
//                String foreignKey = rs.getString("t_column");
//                String childTable = rs.getString("t_table");
//                // получаю код строки для удаления
//                foreignKey = foreignKey.substring(1, foreignKey.length() - 1);
//
//                // удаляются ВСЕ строки дочерней таблицы, у которых владелец уже удален в оракл и должен быть удален в постгри
//                String sqlDelete = Utils.generateSqlDelete(e.getMessage(), childTable, foreignKey);
//                stmt.executeUpdate(sqlDelete);
//
//                // ошибка битой ссылки устранена, снова пытаюсь удалить все строки данной таблицы
//                return true;
//            } else if (Utils.transactionError(e.getMessage())) {
//                // если ошибка связана с транзакционностью вызываю метод удаления еще раз
//                return true;
//            } else {
//                // если какая-то другая ошибка (синтаксис или скажем неверный порядок вызова скрипта удаления) тогда запись в лог ошибок и переход к следующему
//                errorSql = Utils.insertToErrorLog("D", table, e.getMessage().replace("'", ""));
//                stmt.executeUpdate(errorSql);
//            }
//        }
//
//        return false;
//    }
    private boolean deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
        String errorSql;

        try {
            stmt.executeUpdate(sqlQuery.toString());
        } catch (SQLException e) {
//            int a = 1;

            if (e.getMessage().contains("violates foreign key constraint")) {
                deleteForeignKeyConstraint(e.getMessage());

                // ошибка битой ссылки устранена, снова пытаюсь удалить все строки данной таблицы
                return true;
            } else if (Utils.transactionError(e.getMessage())) {
                // если ошибка связана с транзакционностью вызываю метод удаления еще раз
                return true;
            } else {
                // если какая-то другая ошибка (синтаксис или скажем неверный порядок вызова скрипта удаления) тогда запись в лог ошибок и переход к следующему
                errorSql = Utils.insertToErrorLog("D", table, e.getMessage().replace("'", ""));
                stmt.executeUpdate(errorSql);
            }
        }

        return false;
    }

    private void deleteForeignKeyConstraint(String errorMessage) throws SQLException {
        // распарсить имя таблицы из текста ошибки!
        String table = getTableFromErrorMessage(errorMessage);
        // генерирую текст запроса для поиска foreign key
        String foreignKeySql = Utils.getForeignKeySql(table, Utils.parseErrorGetChildTable(errorMessage));
        ResultSet rs = stmt.executeQuery(foreignKeySql);
        rs.next();
        String foreignKey = rs.getString("t_column");
        String childTable = rs.getString("t_table");
        // получаю код строки для удаления
        foreignKey = foreignKey.substring(1, foreignKey.length() - 1);

        String sqlDelete = Utils.generateSqlDelete(errorMessage, childTable, foreignKey);
        try {
            stmt.executeUpdate(sqlDelete);
        } catch (SQLException e) {
            deleteForeignKeyConstraint(e.getMessage());
        }
    }

    private String getTableFromErrorMessage(String errorMessage) {
//        String error = "ERROR: update or delete on table \"cl\" violates foreign key constraint \"cl_address_fk\" on table \"cl_address\"\n" +
//                "  Подробности: Key (c_client)=(704094) is still referenced from table \"cl_address\".\n" +
//                "  Где: SQL statement \"DELETE FROM cl WHERE c_client IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = 'CL' and \"OPER\" = 'D')\"\n" +
//                "PL/pgSQL function inline_code_block line 3 at SQL statement";
        String part1 = errorMessage.split("ERROR: update or delete on table \"", 2)[1];
        String part2 = part1.split("\" violates foreign key constraint", 2)[0];

        return part2;
    }

    public void startReplication() throws SQLException, IOException, ClassNotFoundException {
        System.out.println("start replication");
        //удаление данных
        String[][] tablesArrayD = Utils.getTablesOperationD();
        boolean continueLoad;
        for (String[] tables : tablesArrayD) {
            String dir = tables[0];

            for (int i = 1; i < tables.length; i++) {
                StringBuilder sqlQuery = new StringBuilder(Utils.readSqlQuery("scripts/" + dir + "/d/" + tables[i].toLowerCase() + ".sql"));
                continueLoad = true;

                System.out.println("Deleting table " + tables[i]);
                while (continueLoad) {
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
//                    System.out.println("start lineByLineLoad " + tables[i]);
                    //lineByLineLoad(dir, tables[i]);
                    if (!tables[i].equals("VAC_CNT")) {
                        System.out.println("start lineByLineLoad " + tables[i]);
                        lineByLineLoad(dir, tables[i]);
                    } else {
                        System.out.println("start lineByLineLoad VAC_CNT");
                        // VAC_CNT абсолютно уникальный случай и дело даже не в том, что только по этой таблице встречается операция инкремент,
                        // а в том, что данные по этой таблице в replog не удалить и приходится подключаться к базе оракл и удалять от туда данные напрямую
                        processing_VAC_CNT();
                    }
                    System.out.println("finish lineByLineLoad " + tables[i]);
                }
            }
        }
    }

    private void processing_VAC_CNT() throws SQLException, ClassNotFoundException {
        // алгоритм инкремента (единственная на данный момент таблица VAC_CNT - счетчик вакансий; содержит два инкрементируемых поля)
        // единственный алгоритм (обработки данной таблицы), который напямую воздействует на обе базы: постгри и оракл.
        // получается, что переделать нужно все скрипты по данной таблице. Оооо! может и вообще убрать чтение из файла и просто "захардкодить",
        // потому что не нужно do begin и прочий огород городить... один sql запрос к постгри - на инкремент, один в оракл - на удаление из обмена
        // таблица одна, команда (update/delete) тоже одна. в принипе, чтение из файла и не требуется...
        // речь, кстати, идет не только об инкременте, но и об удалении и об добавлении-апдейте.
        // думаю я вот что... сделать для VAC_CNT - отдельный элемент моего двумерного массива и отдельную же ей обработку прикрутить

        // отладил - можно прикручивать к продакшн :-)

        // ну и продумать как выполнить первоначальную синхронизцию с ораклом.
        // думаю не стоит все полностью стриать... нужно прогнать oper S и D - супер будет,
        // если после этой процедуры количество строк в разных БД станет одинаковым...
        // а потом запустить скрипт, который пачкой добавляет все, что есть,
        // а при конфликте апдейтит ----> этот скрипт в папке vac\i

        // часто падает по этой ошибке!
        //Exception in thread "main" org.postgresql.util.PSQLException: ERROR: error fetching result: OCIStmtFetch2 failed to fetch next result row
        //  Подробности: ORA-08177: can't serialize access for this transaction

        Database.connectOracle();
        Statement stmtOracle = Database.getStmtOracle();
        Connection connectionPostgres = Database.getConnectionPostgre();

        try {
            // отладил
            load_VAC_CNT(connectionPostgres);

            // отладил
            increment_VAC_CNT(connectionPostgres);
        } catch (IOException e) {
            e.printStackTrace();
        }

        stmtOracle.close();
        Database.closeOracle();
    }

    private void load_VAC_CNT(Connection connectionPostgres) throws SQLException, IOException {
        ResultSet rs;
        // operation S
        String sql_replog = Utils.getReplicationLogOperS("VAC_CNT");

        while (true) {
            // пытаюсь прочитать данные до тех пор, пока не получится, если ошибка не 'ORA-08177: can't serialize access for this transaction', бросаю исключение
            try {
                rs = stmt.executeQuery(sql_replog);
                break;
            } catch (SQLException e) {
                if (!Utils.transactionError(e.getMessage())) {
                    throw new RuntimeException(e);
                }
            }
        }

        ArrayList<String> arrayList = new ArrayList<>();
        while (rs.next()) {
            arrayList.add(rs.getString(1));
        }

        String sqlUpdateInsert = "INSERT INTO vac_cnt (\"vac_num\", \"cur_free\", \"cur_dir\", \"cur_spr\", \"att_f\")\n" +
                "SELECT \"vac_num\", \"cur_free\", \"cur_dir\", \"cur_spr\", \"att_f\"\n" +
                "FROM ora_vac_cnt WHERE ora_vac_cnt.vac_num = '%s'\n" +
                "ON CONFLICT (\"vac_num\") DO UPDATE SET \"cur_free\" = EXCLUDED.cur_free, \"cur_dir\" = EXCLUDED.cur_dir, \"cur_spr\" = EXCLUDED.cur_spr, \"att_f\" = EXCLUDED.att_f";

        String sqlDeleteFromOracleS = "DELETE FROM replog801 where n_table = 'VAC_CNT' and oper = 'S' and r_table = '%s'";

        StringBuilder sqlUpdateInsertBuilder = new StringBuilder();
        StringBuilder sqlDeleteFromOracleSBuilder = new StringBuilder();
        // отменяю авто коммит
        connectionPostgres.setAutoCommit(false);
        boolean attemptOwnerLoad = false;

        for (String r : arrayList) {
            clearCode(sqlUpdateInsertBuilder);
            clearCode(sqlDeleteFromOracleSBuilder);

            sqlUpdateInsertBuilder.append(String.format(sqlUpdateInsert, r));
            sqlDeleteFromOracleSBuilder.append(String.format(sqlDeleteFromOracleS, r));

            // две эти команды должны быть выполнены в одной транзакции, т.к. вызываются они в разных БД, целостность данных нарушена быть не должна
            // беру строку из реплога, выполняю апдейт/инсерт в постгрис, удаляю из реплога, фиксирую апдейт в постгрис
            while (true) {
                try {
                    stmt.execute(sqlUpdateInsertBuilder.toString());
                    stmtOracle.execute(sqlDeleteFromOracleSBuilder.toString());
                    connectionPostgres.commit();
                    attemptOwnerLoad = false;
                    break;
                } catch (Exception e) {
                    connectionPostgres.rollback();
                    if (Utils.ownerError(e.getMessage())) {
                        // ошибка отсутсвтия владельца. если влад. не найден, пробую его загрузить.
                        if (!attemptOwnerLoad) {
                            String errorSql = Utils.readSqlQuery("scripts/vac/s/vac.sql");
                            errorSql = String.format(errorSql, "('" + r + "')", "('" + r + "')");

                            stmt.executeUpdate(errorSql);
                            connectionPostgres.commit();
                            // ставлю флаг, что попытка загрузки влад. состоялась
                            attemptOwnerLoad = true;
                        } else {
                            // одна попытка загрузки влад. была, но ошибка осталась, сбрасываю флаг (для работы со след. кодом)
                            // записываю информацию об ошибке и прерываю цикл
                            attemptOwnerLoad = false;
                            String errorSql = Utils.insertToErrorLog(r, "VAC_CNT", e.getMessage().replace("'", ""));
                            stmt.executeUpdate(errorSql);
                            connectionPostgres.commit();
                            break;
                        }
                    } else if (!Utils.transactionError(e.getMessage())) {
                        // если ошибка транзакционная, цикл продолжается и снова пытается загрузить строку
                        // если любая другая ошибка, пишу в лог ошибок и перехожу к следующему коду
                        String errorSql = Utils.insertToErrorLog(r, "VAC_CNT", e.getMessage().replace("'", ""));
                        stmt.executeUpdate(errorSql);
                        connectionPostgres.commit();
                        break;
                    }
                }
            }
        }
        connectionPostgres.setAutoCommit(true);
    }

    private void clearCode(StringBuilder r) {
        if (r.length() > 0) {
            r.delete(0, r.length());
        }
    }

    private void increment_VAC_CNT(Connection connectionPostgres) throws SQLException, ClassNotFoundException {
        ResultSet rs;

        // operation I (запрос для получения всех строк VAC_CNT, уже сгруппированных по колонке и полю Дельта)
        String sql_replog = Utils.getReplicationLogVacCntOperI();

        while (true) {
            // пытаюсь прочитать данные до тех пор, пока не получится, если ошибка не 'ORA-08177: can't serialize access for this transaction', бросаю исключение
            try {
                rs = stmt.executeQuery(sql_replog);
                break;
            } catch (SQLException e) {
                if (!Utils.transactionError(e.getMessage())) {
                    throw new RuntimeException(e);
                }
            }
        }

        ArrayList<String[]> arrayList = new ArrayList<>();
        while (rs.next()) {
            arrayList.add(new String[]{rs.getString("R_TABLE"), rs.getString("N_FIELD"), rs.getString("sum").split("\\.")[0]});
        }

        String sqlUpdateUpdate = "UPDATE vac_cnt SET %s = %s + '%s' where vac_num = '%s'";

        String sqlDeleteFromOracleS = "DELETE FROM replog801 where n_table = 'VAC_CNT' and oper = 'I' and n_field = '%s' and r_table = '%s'";

        StringBuilder sqlUpdateInsertBuilder = new StringBuilder();
        StringBuilder sqlDeleteFromOracleSBuilder = new StringBuilder();
        // отменяю авто коммит
        connectionPostgres.setAutoCommit(false);
        boolean attemptOwnerLoad = false;
        int counter = 0;
        for (String[] arr : arrayList) {
            System.out.println(counter);
            counter++;
            clearCode(sqlUpdateInsertBuilder);
            clearCode(sqlDeleteFromOracleSBuilder);

            sqlUpdateInsertBuilder.append(String.format(sqlUpdateUpdate, arr[1], arr[1], arr[2], arr[0]));
            sqlDeleteFromOracleSBuilder.append(String.format(sqlDeleteFromOracleS, arr[1], arr[0]));

            // две эти команды должны быть выполнены в одной транзакции, т.к. вызываются они в разных БД, целостность данных нарушена быть не должна
            // беру строку из реплога, выполняю апдейт/инсерт в постгрис, удаляю из реплога, фиксирую апдейт в постгрис
            while (true) {
                try {
                    stmt.execute(sqlUpdateInsertBuilder.toString());
                    stmtOracle.execute(sqlDeleteFromOracleSBuilder.toString());
                    connectionPostgres.commit();
                    //attemptOwnerLoad = false;
                    break;
                } catch (Exception e) {
                    connectionPostgres.rollback();
                    if (!Utils.transactionError(e.getMessage())) {
                        // если ошибка транзакционная, цикл продолжается и снова пытается загрузить строку
                        // если любая другая ошибка, пишу в лог ошибок и перехожу к следующему коду
                        String errorSql = Utils.insertToErrorLog(arr[0], "VAC_CNT", e.getMessage().replace("'", ""));
                        stmt.executeUpdate(errorSql);
                        connectionPostgres.commit();
                        break;
                    }
                }
            }
        }
        connectionPostgres.setAutoCommit(true);
    }


    private void uploadDataForReplication(String[] tables) {
        states.clear();
        String sql;
        boolean continueLoad;

        for (int i = 1; i < tables.length; i++) {
            continueLoad = true;
            sql = Utils.getReplicationLogOperS(tables[i].replace("*", ""));

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
                throw new RuntimeException(e.getMessage());
            }
        }
        return false;
    }

    private void lineByLineLoad(String dir, String currentTable) throws SQLException, IOException {
        LoadResult loadResult = new LoadResult();

        // получаю список кодов по текущей таблице
        ArrayList<String> listUpdateInsert = states.get(currentTable);

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
            } else if (Utils.duplicateError(e.getMessage())) {
                // ошибка дублирования строк. в оракл ошибочно созданы две строки с одинаковыми парамтерами, в случае, когда логика предусматривает только одну с троку с такими параметрами
                // например, навык человека. нет смысла в двух строках "код пользователя" -- "код навыка" - в данном случае уникальный ключ образуют именно эти два параметра.
                // если такая ошибка перехвачена, значит одна строка с данными параметрами уже загружена в постгри и эту ошибку я просто игнорирую, удаляя строку из реплога
                stmt.executeUpdate(Utils.deleteFromOraReplog(currentTable, code));
                // ошибку в лог не записываю, сразу перехожу к следующей строке
                loadResult.continueLoad = false;
                return;
            }

            // если программа пришла сюда, значит встретилась ошибка, для которой алгоритм обработки не предусмотрен
            // записываю ее в лог ошибок и перехожу к следующей строке
            errorSql = Utils.insertToErrorLog(code, currentTable, e.getMessage().replace("'", ""));
            stmt.executeUpdate(errorSql);
        }
        loadResult.continueLoad = false;
    }
}