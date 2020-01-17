package service;

import java.sql.*;

public class Database {
    private static Connection connection;
    private static Statement stmt;

    static final String DB_URL = "jdbc:postgresql://192.168.100.120:5432/kzn?currentSchema=kzn";
    static final String USER = "kzn";
    static final String PASS = "lFg$zNum";

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
}