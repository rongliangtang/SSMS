package com.mysql;

import java.sql.*;

/*
坑：
project struct中dependencies中需要加入mysqlDriver的路径包
*/


public class connectMysql<conn> {
    public static Connection connect(){
        try{
            //注册加载驱动
            String driver = "com.mysql.cj.jdbc.Driver";
            Class.forName(driver);
            String url = "jdbc:mysql://localhost:3306/javaweb?&useSSL=false&serverTimezone=UTC";
            Connection conn =DriverManager.getConnection(url,"root","6610176trl");
            return conn;
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public static void closeResultSet(ResultSet rs){
        try{
            rs.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void closePreparedStatement(PreparedStatement ps){
        try{
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void closeConnection(Connection conn){
        try{
            conn.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws SQLException {
        Connection conn = connect();
        if(conn != null){
            System.out.println("数据库连接成功");
            //进行查询操作
            boolean flag=false;    //判断登录成功与否
            PreparedStatement sql;
            ResultSet res;
            String condition = "insert into user values (?,?)";
            sql=conn.prepareStatement(condition);
            sql.setString(1,"username1");
            sql.setString(2,"password");
            System.out.println(sql);
            if (sql.execute())
                flag=true;
                System.out.println(11111);
            closeConnection(conn);
        }else{
            System.out.println("数据库连接失败");
        }
    }


}