import service.Database;
import service.Utils;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ErrorHandling {
    private String n_table;
    private Statement stmt;

    public ErrorHandling(String n_table) {
        this.stmt = Database.getStmt();
        this.n_table = n_table;
    }

    public void tryFixErrors() throws SQLException, IOException {
        ArrayList<String> errorCodes = getErrorCodes();
        String sqlQuery = getSqlQuery();

        int fixed = tryToFix(sqlQuery, errorCodes);
        System.out.println("Исправлено " + fixed + " строк");
        int a = 1;
    }

    private int tryToFix(String sqlQuery, ArrayList<String> errorCodes) {
        String string;
        String string1;
        int counter = 0;
        for (String errorCode : errorCodes) {
            string = String.format(sqlQuery, errorCode, errorCode);
            string1 = getSqlRemoveFromErrorLog("'" + errorCode + "'");
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

    private String  getSqlQuery() throws IOException {
        String dir = n_table.split("_",2)[0].toLowerCase();
        return Utils.readSqlQuery("scripts/" + dir + "/s/" + n_table.toLowerCase() + ".sql");
    }

    private ArrayList<String> getErrorCodes() throws SQLException {
        ResultSet rs;
        ArrayList<String> list = new ArrayList<>();
        String sqlQuery = getSqlQueryError();

        rs = stmt.executeQuery(sqlQuery);
        while (rs.next()) {
            list.add(rs.getString("r"));
        }

        return list;
    }

    private String getSqlQueryError() {
        return String.format("SELECT r FROM error_repl_log WHERE \"table\" = '%s'", n_table);
    }

    private String getSqlRemoveFromErrorLog(String code) {
        return String.format("DELETE FROM error_repl_log WHERE \"table\" = '%s' AND r = %s", n_table, code);
    }
}
