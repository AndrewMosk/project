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
        this.stmt = Database.getStmtPostgre();
        //this.n_table = n_table;
    }

    public void tryFixErrors() throws SQLException, IOException {
        // получаю имена таблиц с ошибками
        ArrayList<String> n_tables = getN_tables();
        int fixed = 0;
        int fixedAll = 0;

        for (String n_table : n_tables) {
            ArrayList<String> errorCodes = getErrorCodes(n_table);
//            ArrayList<String> errorCodes = new ArrayList<>();
//            errorCodes.add("JOB_DIR");
            String sqlQuery = getSqlQuery(n_table);

            System.out.println("Таблица " + n_table + ". Начинаю работу.");
            fixed = tryToFix(sqlQuery, errorCodes, n_table);
            System.out.println("Таблица " + n_table + ". Исправлено " + fixed + " строк.");
            fixedAll += fixed;
        }
        System.out.println("Всего исправлено " + fixedAll + " строк.");
    }

    private ArrayList<String> getN_tables() throws SQLException {
        ArrayList<String> n_tables = new ArrayList<>();
        String sqlQuery = getSqlQueryN_tables();
        ResultSet rs = stmt.executeQuery(sqlQuery);

        while (rs.next()) {
            n_tables.add(rs.getString("s"));
        }
        return n_tables;
    }

    private int tryToFix(String sqlQuery, ArrayList<String> errorCodes, String n_table) throws SQLException {
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
                        System.out.println("Таблица " + n_table + ". Ошибка не исправлена. Код строки: " + errorCode);
                        String s = "UPDATE error_repl_log SET checked = true WHERE \"table\" = '" + n_table + "' AND r = '" + errorCode + "'";
                        stmt.executeUpdate(s);
                    }
                }
            }
        }
        return counter;
    }

    private String getSqlQuery(String n_table) throws IOException {
        String dir;
        if (isUnstructured(n_table)) {
            dir = "unstructured";
        }else {
            dir = n_table.split("_", 2)[0].toLowerCase();
        }
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

    private boolean isUnstructured(String n_table) {
        return "CONS, JOB_DIR, JOB_REZ, RK_LIST, RK_REZ".contains(n_table);
    }

    private String getSqlQueryError(String n_table) {
        return String.format("SELECT r FROM error_repl_log WHERE \"table\" = '%s' AND checked = false", n_table);
    }

    private String getSqlRemoveFromErrorLog(String code, String n_table) {
        return String.format("DELETE FROM error_repl_log WHERE \"table\" = '%s' AND r = %s", n_table, code);
    }

    private String getSqlQueryN_tables() {
        return "SELECT \"table\" as s FROM error_repl_log WHERE r != 'D' AND checked = false GROUP BY \"table\"";
    }
}
