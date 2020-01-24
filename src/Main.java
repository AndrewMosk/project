import service.Database;
import service.Mail;

import java.io.IOException;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        // ЧТО СДЕЛАТЬ
        // создать скрипты для таблиц sl
        long starTime = System.currentTimeMillis();

        try {
            Database.connect();

            ErrorHandling errorHandling = new ErrorHandling("PERS_REZDOC");
            errorHandling.tryFixErrors();


//            Replication replication = new Replication();
//            replication.startReplication();

        } catch (SQLException | ClassNotFoundException | IOException e) {
            e.printStackTrace();
            Mail mail = new Mail();
            mail.send("Ошибка старта репликации", e.getMessage());
        }
        Database.close();

        System.out.println((System.currentTimeMillis() - starTime) / 1000);
    }
}
