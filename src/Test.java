import service.Database;
import service.Mail;
import service.Utils;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Test {
    public static void main(String[] args) throws IOException {

        // взял первый пример сразу удачно - PERS_CLOSE - там ссылка на sl_pers - у меня таких не создано!  нужно добавить!!!

        String error = "ERROR: insert or update on table \"pers_rezdoc\" violates foreign key constraint \"pers_rezdoc_fk\"\n" +
                "  Подробности: Key (r_rez)=(1805797767) is not present in table \"pers_rez\".\n" +
                "  Где: SQL statement \"INSERT INTO\n" +
                "\tpers_rezdoc (\"r\", \"r_rez\", \"c_order\", \"hex\", \"status\", \"p_modi\", \"d_modi\")\n" +
                "SELECT \"r\", \"r_rez\", \"c_order\", \"hex\", \"status\", \"p_modi\", \"d_modi\"\n" +
                "FROM ora_pers_rezdoc WHERE ora_pers_rezdoc.r = 1805797767_18\n" +
                "ON CONFLICT (\"r\") DO UPDATE SET \"r_rez\" = EXCLUDED.r_rez, \"c_order\" = EXCLUDED.c_order, \"hex\" = EXCLUDED.hex, \"status\" = EXCLUDED.status, \n" +
                "\t\t\"p_modi\" = EXCLUDED.p_modi, \"d_modi\" = EXCLUDED.d_modi\"\n" +
                "PL/pgSQL function inline_code_block line 3 at SQL statement";

        String[] errorData = parseError(error);
        String sql = generateSql(errorData[0], errorData[1], errorData[2]);

        System.out.println(sql);

//        for (String s : array) {
//            System.out.println(s);
//        }

    }

    private static String generateSql(String r_table, String r, String n_table) throws IOException {
        // имена всех таблиц, имеют префик, совпадающий с именем папки, в которой они хранятся
        String folderName = n_table.split("_")[0];

        String dir = "scripts/" + folderName + "/s/" + n_table + ".sql";
        String sqlQuery = Utils.readSqlQuery(dir);

        return String.format(sqlQuery, r, r);
    }

    private static String[] parseError(String error) {
        String[] result = new String[3];

        int index1 = error.indexOf("Подробности:", 0);
        int index2 = error.indexOf("Где:", 0);
        error = error.substring(index1, index2);

        String[] split = error.split("=");
        index1 = split[0].indexOf("(") + 1;
        index2 = split[0].indexOf(")");
        result[0] = split[0].substring(index1, index2);

        index1 = split[1].indexOf("(") + 1;
        index2 = split[1].indexOf(")");
        result[1] = split[1].substring(index1, index2);

        index1 = split[1].indexOf("table") + 7;
        index2 = split[1].length() - 5;
        result[2] = split[1].substring(index1, index2);

        return result;
    }

}
