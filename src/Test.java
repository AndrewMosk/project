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
        // значения результата запроса буду записывать в HashMap. ключ - номер ваканасии...
        // или нафиг надо?

        String sqlQuery = Utils.getReplicationLogOperI("VAC_CNT");

        ResultSet rs = stmt.executeQuery(sqlQuery + "limit 100");

        String r_table;
        String n_field;
        String delta;

        // вот тут читаю файл с диска ----> "UPDATE %s SET %s = %s + %s where vac_num = '%s'" вот такой
        // UPDATE vac_cnt SET cur_spr = cur_spr + '69' where vac_num = '100167824'

        // ОТЛАДИТЬ!!!
        String[] tablesToIncrement = Utils.getTablesOpertaionI();
        String dir = tablesToIncrement[0];
        for (int i = 1; i < tablesToIncrement.length; i++) {
            String sql = Utils.readSqlQuery("scripts/" + dir + "/s/" + tablesToIncrement[i].toLowerCase() + ".sql");
            while (rs.next()) {
                r_table = rs.getString("R_TABLE");
                n_field = rs.getString("N_FIELD");
                delta = rs.getString("sum");

                String currentSql = String.format(sql, n_field, n_field, delta, r_table);
            }

        }


        Database.close();
    }
}