package db;

import org.postgresql.util.PSQLException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.*;
import java.util.Scanner;

public class Database {
    private static Connection connection;
    private static Statement stmt;

    static final String DB_URL = "jdbc:postgresql://192.168.100.120:5432/kzn?currentSchema=kzn";
    static final String USER = "kzn";
    static final String PASS = "lFg$zNum";

    public static Connection getConnection() {
        return connection;
    }

    public static Statement getStmt() {
        return stmt;
    }

    public static void connect() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        connection = DriverManager.getConnection(DB_URL, USER, PASS);
        stmt = connection.createStatement();
        System.out.println("Connected to database");
    }

    public static void close(){
        try {
            stmt.close();
            connection.close();
            System.out.println("Disconnected from database");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
        return String.valueOf(result);
    }


//    static void getItem(String name, String cod) throws SQLException {
//        String sql = String.format(readSqlQuery("sql_queries/CL/test/select.sql"), name, cod);
//        ResultSet rs = stmt.executeQuery(sql);
//        while (rs.next()) {
//            System.out.println(rs.getString("r_table"));
//        }
//    }
//
//    static int insertLine(String name, String cod) {
//        int insertedLines = 0;
//        try {
//            String sql = String.format(readSqlQuery("sql_queries/CL/test/insert.sql"), name, cod);
//            insertedLines = stmt.executeUpdate(sql);
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return insertedLines;
//    }
//
//    static int deleteLine(String name, String cod) {
//        int insertedLines = 0;
//        try {
//            String sql = String.format(readSqlQuery("sql_queries/CL/test/delete.sql"), name, cod);
//            insertedLines = stmt.executeUpdate(sql);
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return insertedLines;
//    }

}
