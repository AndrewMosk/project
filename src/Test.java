import service.Database;
import service.Utils;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    private static class ErrorData {
        public String r;
        public String n_table;
    }

    private static Statement stmt;

    public static void main(String[] args) throws IOException {
        String initialSql = "";
        stmt = Database.getStmt();

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

        if (error.contains("violates foreign key constraint")) {
//            String[] errorData = parseError(error);
//            String sql = generateSql(errorData[0], errorData[1]);
            String sql = generateSql(error);

//            try {
//                stmt.executeUpdate(sql);
//            } catch (SQLException e) {
//                e.printStackTrace();
//                // нужен текст ошибки, что в оракловой таблице нет такого ключа - а ошибки то и не будет! значит возможна ошибка транзакционности, если она - запускаю еще раз, если нет, пробую еще раз
//                //скрипт, который упал по ошибке. если снова ошибка - пропускаю и удаляю из реплога - сука! костыль на костыле (
//
//            }

            System.out.println(sql);
        }

    }



    private static String generateSql(String error) throws IOException {
        ErrorData errorData = parseError(error);

        // имена всех таблиц, имеют префик, совпадающий с именем папки, в которой они хранятся - кроме неструктурированных! - может им добавить?
        String folderName = errorData.n_table.split("_")[0];

        String dir = "scripts/" + folderName + "/s/" + errorData.n_table + ".sql";
        String sqlQuery = Utils.readSqlQuery(dir);

        return String.format(sqlQuery, errorData.r, errorData.r);
    }

    private static ErrorData parseError(String error) {
        ErrorData result = new ErrorData();

        int index1 = error.indexOf("Подробности:", 0);
        int index2 = error.indexOf("Где:", 0);
        error = error.substring(index1, index2);

        String[] split = error.split("=");
        index1 = split[1].indexOf("(") + 1;
        index2 = split[1].indexOf(")");
        result.r = split[1].substring(index1, index2);

        index1 = split[1].indexOf("table") + 7;
        index2 = split[1].length() - 5;
        result.n_table = split[1].substring(index1, index2);

        return result;
    }

}
