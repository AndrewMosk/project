import service.Database;
import service.Mail;
import service.Utils;

import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    public static void main(String[] args) {

//        try {
//            Database.connect();
//            Statement stmt = Database.getStmt();
//
//            // в запросе задать переменую! и использовать дважды
//
//            //String sql = String.format(Utils.readSqlQuery("scripts/cl/s/cl.sql"), "('100065086')", "('100065086')");
//            //String sql = String.format(Utils.readSqlQuery("scripts/cl/s/cl_address.sql"), "100064249", "100064249");
//            String sql = String.format(Utils.readSqlQuery("scripts/cl/s/cl_mv.sql"), "1710011870", "1710011870");
//            System.out.println(sql);
//            stmt.executeUpdate(sql);
//
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//        Database.close();

        String mainTable = "unstructured";
        boolean isMainTableEmpty = mainTable.equals("unstructured");
        System.out.println(isMainTableEmpty);
    }

}
