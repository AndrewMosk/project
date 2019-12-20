
import db.Database;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class Main {
    public static void main(String[] args)  {

        try {
            Database.connect();

            Replication replication = new Replication();
            replication.startReplication();

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        Database.close();

    }
}
