import org.postgresql.core.SqlCommand;
import service.Database;
import service.Mail;
import service.Utils;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Test {
    private static Statement stmt;
    private static Statement stmtOracle;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {

//        test_processing_VAC_CNT();

        testDeleteChainBrokenLinks();
    }

    private static void test_processing_VAC_CNT() throws SQLException, ClassNotFoundException {
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
        Database.connectPostgre();
        stmt = Database.getStmtPostgre();

        Database.connectOracle();
        stmtOracle = Database.getStmtOracle();
        Connection connectionPostgres = Database.getConnectionPostgre();

        try {
            // отладил
            load_VAC_CNT(connectionPostgres);

            // отладил
            increment_VAC_CNT(connectionPostgres);
        } catch (IOException e) {
            e.printStackTrace();
        }


        stmt.close();
        stmtOracle.close();
        Database.closePostgre();
        Database.closeOracle();
    }

    private static void load_VAC_CNT(Connection connectionPostgres) throws SQLException, IOException {
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

    private static void clearCode(StringBuilder r) {
        if (r.length() > 0) {
            r.delete(0, r.length());
        }
    }

    private static void increment_VAC_CNT(Connection connectionPostgres) throws SQLException, ClassNotFoundException {
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

//        // запрос для получения всех строк VAC_CNT, уже сгруппированных по колонке и полю Дельта
//        String sqlQuery = Utils.getReplicationLogVacCntOperI();
//        // результат запроса
//        ResultSet rs = null;
//        try {
//            rs = stmt.executeQuery(sqlQuery + " limit 100");
//
//            String r_table;
//            String n_field;
//            String delta;
//
//            // по одной вакансии может придти две строки (две колонки может быть инкрементировано), а может и одна.
//            // как это обработать - в смысле удалить из оракла? да так же буду делать...
//            // в оракловом запросе буду еще ставить условие на N_FIELD!
//            String string1;
//            String string2;
//
//            while (rs.next()) {
//                r_table = rs.getString("R_TABLE");
//                n_field = rs.getString("N_FIELD");
//                delta = rs.getString("sum").split("\\.")[0];
//
//                string1 = String.format("UPDATE vac_cnt SET %s = %s + '%s' where vac_num = '%s';", n_field, n_field, delta, r_table);
//                string2 = String.format("DELETE FROM replog801 where n_table = 'VAC_CNT' and oper = 'I' and n_field = '%s' and r_table = '%s'", n_field, r_table);
//                System.out.println(string1);
//                System.out.println(string2);
//
//                // апдейт строки в постгри
//                //stmt.executeUpdate(String.format("UPDATE vac_cnt SET %s = %s + '%s' where vac_num = '%s';", n_field, n_field, delta, r_table));
//                // удаление из таблицы репликации в оракл - ПРОВЕРИТЬ ЗАПРОС!
//                //stmtOracle.execute(String.format("DELETE FROM replog801 where n_table = 'VAC_CNT' and n_field = '%s' and r_table = '%s'", n_field, r_table));
//
//
//                //System.out.println(currentSql);
//                //stmt.executeUpdate(currentSql);
//                //break;
//            }
//
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
    }

    // методы удаления битых ссылок по цепочке ----------------------------------------------------------------------------------
    private static void testDeleteChainBrokenLinks() throws SQLException, ClassNotFoundException {
        Database.connectPostgre();
        stmt = Database.getStmtPostgre();

        // удаление вложенных цепочек битых ссылок - пока делал, такая ошибка пропала, так что на боевую пока не переношу
        StringBuilder sql = new StringBuilder("DO $$\n" +
                "BEGIN\n" +
                "DELETE FROM cl WHERE c_client IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = 'CL' and \"OPER\" = 'D');\n" +
                "DELETE FROM ora_replog999 WHERE \"N_TABLE\" = 'CL' AND \"OPER\" = 'D';\n" +
                "END;\n" +
                "$$ LANGUAGE plpgsql;");


        boolean continueLoad = true;
        while (continueLoad) {
            continueLoad = deleteRows(sql, "CL");
        }

        stmt.close();
        Database.closePostgre();
    }

    private static boolean deleteRows(StringBuilder sqlQuery, String table) throws SQLException {
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

    private static void deleteForeignKeyConstraint(String errorMessage) throws SQLException {
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

    private static String getTableFromErrorMessage(String errorMessage) {
//        String error = "ERROR: update or delete on table \"cl\" violates foreign key constraint \"cl_address_fk\" on table \"cl_address\"\n" +
//                "  Подробности: Key (c_client)=(704094) is still referenced from table \"cl_address\".\n" +
//                "  Где: SQL statement \"DELETE FROM cl WHERE c_client IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = 'CL' and \"OPER\" = 'D')\"\n" +
//                "PL/pgSQL function inline_code_block line 3 at SQL statement";
        String part1 = errorMessage.split("ERROR: update or delete on table \"", 2)[1];
        String part2 = part1.split("\" violates foreign key constraint", 2)[0];

        return part2;
    }
    // методы удаления битых ссылок по цепочке ----------------------------------------------------------------------------------
}