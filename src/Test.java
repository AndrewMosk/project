import service.Database;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    private static Statement stmt;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        // взял первый пример сразу удачно - PERS_CLOSE - там ссылка на sl_pers - у меня таких не создано!  нужно добавить!!!

        String parentTable = "cl_mv";
        Database.connect();
        stmt = Database.getStmt();

        String error = "ERROR: update or delete on table \"cl_mv\" violates foreign key constraint \"cl_mvrab_fk\" on table \"cl_mvrab\"\n" +
                "Подробности: Key (r)=(1310010956) is still referenced from table \"cl_mvrab\".\n" +
                "Где: SQL statement \"DELETE FROM cl_mv WHERE r IN (select \"R_TABLE\"::bigint from ora_replog999 WHERE \"N_TABLE\" = CL_MV and \"OPER\" = D)\"\n" +
                "PL/pgSQL function inline_code_block line 3 at SQL statement\n";

        if (error.contains("violates foreign key constraint")) {
            // генерирую текст запроса для поиска foreign key
            String foreignKeySql = getForeignKeySql(parentTable, parseErrorGetChildTable(error));
            ResultSet rs = stmt.executeQuery(foreignKeySql);
            rs.next();
            String foreignKey = rs.getString("t_column");
            String childTable = rs.getString("t_table");
            // получаю код строки для удаления
            foreignKey = foreignKey.substring(1, foreignKey.length() - 1);

            // удаляются ВСЕ строки дочерней таблицы, у которых владелец уже удален в оракл и должен быть удален в постгри
            String sqlDelete = generateSqlDelete(error, childTable, foreignKey);
            int deletedRow = 0;

            try {
                deletedRow = stmt.executeUpdate(sqlDelete);
            } catch (SQLException e) {
                // обработка ошибки тут не требуется, т.к. удаляемая строка ТОЧНО есть в базе (иначе бы не упало удаление)
            }

            System.out.println("Была удалена " + deletedRow + " строка.");
            Database.close();
        }

    }

    private static String generateSqlDelete(String error, String childTable, String foreignKey) {
        String errorCode = parseErrorGetCodeDelete(error);

        // генерирую текст запроса для удаления строки в дочерней таблице с битой ссылкой
        String sqlDelete = getSqlDelete(childTable, foreignKey, errorCode);
        return sqlDelete;
    }

    private static String getSqlDelete(String childTable, String foreignKey, String errorCode) {
        return String.format("DELETE FROM %s WHERE %s = '%s'", childTable, foreignKey, errorCode);
    }

    private static String parseErrorGetCodeDelete(String error) {
        int index1 = error.indexOf(")=(", 0);
        int index2 = error.indexOf(") is still referenced from table", 0);
        error = error.substring(index1 + 3, index2);
        return error;
    }

    private static String parseErrorGetChildTable(String error) {
        int index1 = error.indexOf("referenced from table", 0);
        int index2 = error.indexOf("Где: SQL statement", 0);
        error = error.substring(index1 + 23, index2 - 3);

        return error;
    }

    private static String getForeignKeySql(String parentTable, String childTable) {
        String sql = "SELECT\n" +
                "    y.table_name    AS f_table,\n" +
                "    x.table_name    AS t_table,\n" +
                "    array_agg(x.column_name::text) AS t_column\n" +
                "FROM information_schema.referential_constraints c \n" +
                "JOIN information_schema.key_column_usage x\n" +
                "    ON x.constraint_name = c.constraint_name\n" +
                "    AND x.constraint_schema = c.constraint_schema\n" +
                "JOIN information_schema.key_column_usage y\n" +
                "    ON y.ordinal_position = x.position_in_unique_constraint\n" +
                "    AND y.constraint_schema = c.unique_constraint_schema\n" +
                "    AND y.constraint_name = c.unique_constraint_name \n" +
                "WHERE y.table_name = '%s' AND x.table_name = '%s'\n" +
                "GROUP BY   t_table,  f_table";

        return String.format(sql, parentTable, childTable);
    }
}