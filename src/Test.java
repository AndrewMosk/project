import service.Database;
import service.Mail;
import service.Utils;

import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    public static void main(String[] args) {

        String errorSql = "ERROR: error fetching result: OCIStmtFetch2 failed to fetch next result row\n" +
                "  Подробности: ORA-08177: can't serialize access for this transaction";
//        String errorSql = "ORA-01555 snapshot too old: rollback segment number string with name \"string\" too small.";
//        String errorSql = "ERROR:  insert or update on table \"cl_address\" violates foreign key constraint \"cl_address_fk\"\n" +
//                "DETAIL:  Key (c_client)=(1310050053) is not present in table \"cl\".";

        System.out.println(errorSql.contains("08177"));
        System.out.println(errorSql.contains("01555"));

        System.out.println (!(errorSql.contains("08177") || errorSql.contains("01555")));

    }

}
