import service.Database;
import service.Mail;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args)  {

        try {
            Database.connect();

            Replication replication = new Replication();
            replication.startReplication();

        } catch (SQLException | ClassNotFoundException e) {
            Mail mail = new Mail();
            mail.send("Ошибка старта репликации", e.getMessage(), "support@t-project.com", "moskaletsandrey@yandex.ru");
        }
        Database.close();
    }
}
