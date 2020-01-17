import service.Database;
import service.Mail;
import service.Utils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Test {
    public static void main(String[] args) {

    String str ="ERROR: insert or update on table \"cl_address\" violates foreign key constraint \"cl_address_fk\"\n" +
            "  Подробности: Key (c_client)=(1310050054) is not present in table \"cl\".\n" +
            "  Где: SQL statement \"INSERT INTO\n" +
            "\tcl_address (\"c_address\", \"pr_addr\", \"c_client\", \"c_post\", \"aoid_j\", \"houseid\", \"c_country\", \"c_town\", \"c_street\", \"home\", \"crp\", \"kv\", \"lit\", \"prim_addr\", \"txt_addr\", \n" +
            "\t\t\"p_modi\", \"d_modi\")\n" +
            "SELECT \"c_address\", \"pr_addr\", \"c_client\", \"c_post\", \"aoid_j\", \"houseid\", \"c_country\", \"c_town\", \"c_street\", \"home\", \"crp\", \"kv\", \"lit\",\t\"prim_addr\", \"txt_addr\", \n" +
            "\t\t\"pers_modi\" AS \"p_modi\", \"d_modi\"\n" +
            "FROM ora_cl_address WHERE ora_cl_address.c_address = '1310048889'\n" +
            "ON CONFLICT (\"c_address\") DO UPDATE SET \"pr_addr\" = EXCLUDED.pr_addr, \"c_client\" = EXCLUDED.c_client, \"c_post\" = EXCLUDED.c_post, \"aoid_j\" = EXCLUDED.aoid_j, \n" +
            "\t\t\"houseid\" = EXCLUDED.houseid, \"c_country\" = EXCLUDED.c_country, \"c_town\" = EXCLUDED.c_town, \"c_street\" = EXCLUDED.c_street, \"home\" = EXCLUDED.home, \n" +
            "\t\t\"crp\" = EXCLUDED.crp, \"kv\" = EXCLUDED.kv, \"lit\" = EXCLUDED.lit, \"prim_addr\" = EXCLUDED.prim_addr, \"txt_addr\" = EXCLUDED.txt_addr, \"p_modi\" = EXCLUDED.p_modi, \n" +
            "\t\t\"d_modi\" = EXCLUDED.d_modi\"\n" +
            "PL/pgSQL function inline_code_block line 3 at SQL statement', 'Sun Dec 29 18:32:46 MSK 2019";

        System.out.println(str.replace("'",""));

    }

}
