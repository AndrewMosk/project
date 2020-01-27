import service.Database;
import service.Utils;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ErrorHandling {
    //private String n_table;
    private Statement stmt;

    public ErrorHandling() {
        this.stmt = Database.getStmt();
        //this.n_table = n_table;
    }

    public void tryFixErrors() throws SQLException, IOException {
        // получаю имена таблиц с ошибками
        ArrayList<String> n_tables = getN_tables();

        for (String n_table : n_tables) {
            ArrayList<String> errorCodes = getErrorCodes(n_table);
            String sqlQuery = getSqlQuery(n_table);

            int fixed = tryToFix(sqlQuery, errorCodes, n_table);
            System.out.println("Таблица "+ n_table+". Исправлено " + fixed + " строк.");
        }

//        int a = 1;
    }

    private ArrayList<String> getN_tables() throws SQLException {
        ArrayList<String> n_tables = new ArrayList<>();
        String sqlQuery = getSqlQueryN_tables();
        ResultSet rs = stmt.executeQuery(sqlQuery);

        while (rs.next()) {
            n_tables.add(rs.getString("r"));
        }
        return n_tables;
    }

    private String getSqlQueryN_tables() {
        return "SELECT \"table\" as r FROM error_repl_log GROUP BY \"table\"";
    }

    private int tryToFix(String sqlQuery, ArrayList<String> errorCodes, String n_table) {
        String string;
        String string1;
        int counter = 0;
        for (String errorCode : errorCodes) {
            string = String.format(sqlQuery, errorCode, errorCode);
            string1 = getSqlRemoveFromErrorLog("'" + errorCode + "'", n_table);
            try {
                stmt.executeUpdate(string);
                stmt.execute(string1);
                counter++;
            } catch (SQLException e) {
                if (Utils.ownerError(e.getMessage())) {
                    try {
                        // пытаюсь прогрузить владельца
                        String errorSql = Utils.generateLoadOwnerSql(e.getMessage());
                        stmt.executeUpdate(errorSql);
                        //еще раз пытаюсь исправить ошибку
                        stmt.executeUpdate(string);
                        stmt.execute(string1);
                        counter++;
                    } catch (IOException | SQLException ex) {
                        System.out.println("ошибка не исправлена. Код: " + errorCode);
                    }
                }
            }
        }
        return counter;
    }

    private String  getSqlQuery(String n_table) throws IOException {
        String dir = n_table.split("_",2)[0].toLowerCase();
        return Utils.readSqlQuery("scripts/" + dir + "/s/" + n_table.toLowerCase() + ".sql");
    }

    private ArrayList<String> getErrorCodes(String n_table) throws SQLException {
        ResultSet rs;
        ArrayList<String> list = new ArrayList<>();
        String sqlQuery = getSqlQueryError(n_table);

        rs = stmt.executeQuery(sqlQuery);
        while (rs.next()) {
            list.add(rs.getString("r"));
        }

        return list;
    }

    private String getSqlQueryError(String n_table) {
        return String.format("SELECT r FROM error_repl_log WHERE \"table\" = '%s'", n_table);
    }

    private String getSqlRemoveFromErrorLog(String code, String n_table) {
        return String.format("DELETE FROM error_repl_log WHERE \"table\" = '%s' AND r = %s", n_table, code);
    }
}
