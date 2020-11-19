package utils;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class getTotalScore {


    public double getResult(String username){
        {
            double result = 0;

            //通过数据库连接池连接数据库
            //初始化查找命名空间s
            Context ctx = null;
            try {
                ctx = new InitialContext();
                //参数java:/comp/env为固定路径
                Context envContext = (Context) ctx.lookup("java:/comp/env");
                //参数jdbc/mysqlds为数据源和JNDI绑定的名字
                DataSource ds = (DataSource) envContext.lookup("jdbc/mysqlds");
                Connection conn = ds.getConnection();

                //Connection conn = connectMysql.connect();
                if (conn != null) {
                    System.out.println("数据库连接成功");
                    //进行查询操作select * from user where username='admin'and password='123456'
                    PreparedStatement sql;
                    ResultSet res;

                    String condition = "select sum(score) from score where username = ?";
                    sql = conn.prepareStatement(condition);
                    sql.setString(1, username);
                    res = sql.executeQuery();

                    if (res.next()) {
                        result = res.getDouble(1);

                    }
                    conn.close();
                } else {
                    System.out.println("数据库连接失败");
                }
            } catch (NamingException | SQLException e) {
                e.printStackTrace();
            }

            String  temp = String.format("%.2f",result);
            result = Double.parseDouble(temp);

            return result;
        }

    }


}
