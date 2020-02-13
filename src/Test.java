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


        Database.close();
    }
}