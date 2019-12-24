
import db.Database;


import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class Main {
    public static void main(String[] args)  {

        try {
            Database.connect();

//            Replication replication = new Replication();
//            replication.startReplication();

            // вставляю в базу заведомо неправиьлную строку, чтоб текст ошибки посмотреть :-)
            //
            //ERROR: insert or update on table "cl_address" violates foreign key constraint "cl_address_fk"
            // Подробности: Key (c_client)=(888) is not present in table "cl".
            //
            // создать сервисный класс со статическими методами и перенести в него readSqlQuery из DataBase
            // и методы после комментария 'служебные' в классе Replication
            //

            Date date = new Date(System.currentTimeMillis());
            System.out.println(date);

            //String sql = "insert into CL_ADDRESS (\"c_address\", \"c_client\", \"p_modi\", \"d_modi\") values ('777', '888', '999', '2019.12.23')";
            String sql = String.format("insert into error_repl_log (\"r\", \"table\", \"text\", \"time\") values ('777', 'CL_ADDRESS', 'fucking error', '%s')", date);
            Statement stmt = Database.getStmt();
            int updatedRows = stmt.executeUpdate(sql);
            System.out.println(updatedRows);


        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            //System.out.println(e.getMessage());
        }
        Database.close();

    }

}
