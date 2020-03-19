package service;

import java.sql.*;

public class Database {
    private static Connection connectionPostgre;
    private static Connection connectionOracle;
    private static Statement stmtPostgre;
    private static Statement stmtOracle;

    static final String USER = "kzn";
    static final String PASS = "lFg$zNum";

    public static Connection getConnectionPostgre() {
        return connectionPostgre;
    }

    public static Statement getStmtPostgre() {
        return stmtPostgre;
    }
    public static Statement getStmtOracle() {
        return stmtOracle;
    }

    public static void connectPostgre() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        connectionPostgre = DriverManager.getConnection("jdbc:postgresql://192.168.100.120:5432/kzn?currentSchema=kzn", USER, PASS);
        //connectionPostgre = DriverManager.getConnection("jdbc:postgresql://192.168.102.120:5432/kzn?currentSchema=kzn", USER, PASS);
        stmtPostgre = connectionPostgre.createStatement();
        System.out.println("Connected to database Postgre");
    }

    public static void connectOracle() throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        connectionOracle = DriverManager.getConnection("jdbc:oracle:thin:@192.168.100.150:1521:orcl", USER, PASS);
        //connectionOracle = DriverManager.getConnection("jdbc:oracle:thin:@192.168.102.150:1521:orcl", USER, PASS);
        stmtOracle = connectionOracle.createStatement();
        System.out.println("Connected to database Oracle");
    }

    public static void closePostgre(){
        try {
            stmtPostgre.close();
            connectionPostgre.close();
            System.out.println("Disconnected from database Postgre");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeOracle(){
        try {
            stmtOracle.close();
            connectionOracle.close();
            System.out.println("Disconnected from database Oracle");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}