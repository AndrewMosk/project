import org.postgresql.core.SqlCommand;
import service.Database;
import service.Utils;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    private static Statement stmt;

    public static void main(String[] args) throws SQLException, ClassNotFoundException, IOException {
        Database.connect();
        stmt = Database.getStmt();
        String sqlQuery = Utils.getReplicationLogOperI("VAC_CNT");

        ResultSet rs = stmt.executeQuery(sqlQuery + "limit 100");

        String r_table;
        String n_field;
        String delta;

        // отладил - можно прикручивать к продакшн :-)
        // ОООО!! в срипт (vac_cnt.sql) нужно добавить удаление из реплога строки! и тут опять упираюсь в то, что из реплога не удалить :-(


        // ну и продумать как выполнить первоначальную синхронизцию с ораклом.
        // думаю не стоит все полностью стриать... нужно прогнать oper S и D - супер будет,
        // если после этой процедуры количество строк в разных БД станет одинаковым...
        // а потом запустить скрипт, который пачкой добавляет все, что есть,
        // а при конфликте апдейтит
        String[] tablesToIncrement = Utils.getTablesOpertaionI();
        String dir = tablesToIncrement[0];
        for (int i = 1; i < tablesToIncrement.length; i++) {
            String sql = Utils.readSqlQuery("scripts/" + dir + "/i/" + tablesToIncrement[i].toLowerCase() + ".sql");
            while (rs.next()) {
                r_table = rs.getString("R_TABLE");
                n_field = rs.getString("N_FIELD");
                delta = rs.getString("sum").split("\\.")[0];

                String currentSql = String.format(sql, n_field, n_field, delta, r_table);

                System.out.println(currentSql);
                //stmt.executeUpdate(currentSql);
                break;
            }

        }


//        ----------------------------------------------------------------------------------------------------------------------------------
//        удаление вложенных цепочек битых ссылок - пока делал, такая ошибка пропала, так что на боевую пока не переношу
//        StringBuilder sql = new StringBuilder("DO $$\n" +
//                "BEGIN\n" +
//                "DELETE FROM cl WHERE c_client IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = 'CL' and \"OPER\" = 'D');\n" +
//                "DELETE FROM ora_replog999 WHERE \"N_TABLE\" = 'CL' AND \"OPER\" = 'D';\n" +
//                "END;\n" +
//                "$$ LANGUAGE plpgsql;");
//
//
//
//        boolean continueLoad = true;
//        while (continueLoad) {
//            continueLoad = deleteRows(sql, "CL");
//        }
//        ----------------------------------------------------------------------------------------------------------------------------------

        Database.close();
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
        String error = "ERROR: update or delete on table \"cl\" violates foreign key constraint \"cl_address_fk\" on table \"cl_address\"\n" +
                "  Подробности: Key (c_client)=(704094) is still referenced from table \"cl_address\".\n" +
                "  Где: SQL statement \"DELETE FROM cl WHERE c_client IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = 'CL' and \"OPER\" = 'D')\"\n" +
                "PL/pgSQL function inline_code_block line 3 at SQL statement";
        String part1 = error.split("ERROR: update or delete on table \"", 2)[1];
        String part2 = part1.split("\" violates foreign key constraint", 2)[0];

        return part2;
    }
}