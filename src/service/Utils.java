package service;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Date;
import java.util.Scanner;

public class Utils {

    public static String readSqlQuery(String path) {
        StringBuilder result = new StringBuilder();
        try {
            Scanner sc = new Scanner(new File(path));

            while(sc.hasNext()){
                result.append(sc.nextLine()).append("\n");
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return result.toString();
    }

    public static String changeBrackets(String string) {
        string = string.replace("[", "(");
        string = string.replace("]", ")");

        return string;
    }

    public static String insertToErrorLog(String code, String currentTable, String errorMessage) {
        return String.format("INSERT INTO error_repl_log (\"r\", \"table\", \"text\", \"time\") values ('%s', '%s', '%s', '%s')",
                code, currentTable, errorMessage, new Date(System.currentTimeMillis()));
    }

    public static String getReplicationLog(String n_table, String operation) {
        String sql = "SELECT ora_replog999.\"R_TABLE\" FROM ora_replog999 WHERE \"N_TABLE\" = '%s' AND \"OPER\" = '%s' AND \"R_TABLE\" NOT IN " +
                "(SELECT r FROM error_repl_log WHERE \"table\" = '%s')";

        return String.format(sql, n_table, operation, n_table);
    }

    public static String[][] getTables() {
        return new  String[][]  {
                {"CL", "CL_ADDRESS", "CL_BANK", "CL_CONTACT", "CL_OKVED", "CL_P", "CL_POTR", "CL_POTRV", "CL_PSPIS", "CL_REZ", "CL_MV", "CL_MVNP", "CL_MVPERS", "CL_MVRAB",
                        "CL_MVSPIS", "CL_Z", "CL_ZSPIS", "CL_ZV", "CL_ZVSPIS", "CL_SR"},

                {"PERS", "PERS_BOLN", "PERS_BOOK", "PERS_DEF", "PERS_LANG", "PERS_OR", "PERS_PCL", "PERS_POOR", "PERS_PROF", "PERS_PROFIL", "PERS_REZ", "PERS_SIELEV", "PERS_SPEC",
                        "PERS_SPEN", "PERS_STAJ"},

                {"VAC", "VAC_AGR", "VAC_CNT", "VAC_CR", "VAC_DEF", "VAC_DISTR", "VAC_FAIR", "VAC_FAIR_CL", "VAC_FAIR_DEF", "VAC_FAIR_PERS", "VAC_FAIR_PROF", "VAC_FREE_PACK", "VAC_FREE_VAC",
                        "VAC_HISTORY", "VAC_KVOT", "VAC_KVOT_CONFIRM", "VAC_KVOT_DOC", "VAC_KVOT_RM", "VAC_KVOT_TRUD", "VAC_LANG", "VAC_LG", "VAC_ONV", "VAC_PC", "VAC_SPAR", "VAC_TRV"},

                // ДОБАВИТЬ S В ИСКЛЮЧЕНИЯ КАК И unstructured И ПОДУМАТЬ, НЕ СТОИТ ЛИ ИМ СДЕЛАТЬ ЗАГРУЗКУ ПАЧКОЙ, А НЕ ПОСТРОЧНО?!
                {"S", "S_ADEP", "S_ALG", "S_APERIOD", "S_APERIODM", "S_ARABN", "S_ARABU", "S_ARABV", "S_ASPIS", "S_ASPISD", "S_DEP", "S_FIL", "S_FPERS", "S_OTD", "S_PERIOD", "S_PERIODM", "S_PPS",
                        "S_RABDN", "S_RABDU", "S_RABN", "S_RABU", "S_RABV", "S_SPIS", "S_SPISD", "S_SPNU", "S_SPPROC", "S_STAT", "S_SVODN", "S_SVODU", "S_SVODV", "S_VOZV"},

                {"unstructured", "JOB_DIR", "JOB_REZ"},
        };
    }
}
