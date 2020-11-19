package servlets;

import org.json.JSONObject;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AddScoreServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        //接口返回json
        JSONObject jsonObject = null;

        //如果服务器上的session找不到则返回未登录json提示给用户并return
        if (req.getSession().getAttribute("username") == null){
            jsonObject = new JSONObject("{message:'请先登录后再操作'}");
            resp.getOutputStream().write(jsonObject.toString().getBytes("utf-8"));

            return;
        }

        String classname = req.getParameter("classname");
        String score = req.getParameter("score");
        String username = req.getParameter("username");

        boolean flag = false;

        //通过数据库连接池连接数据库
        //初始化查找命名空间
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
                int res;

                String condition = "insert into score (`classname`,`score`,`username`) values (?,?,?);";
                sql = conn.prepareStatement(condition);
                sql.setString(1, classname);
                sql.setString(2, score);
                sql.setString(3, username);
                res = sql.executeUpdate();
                //使用sql.execute()无效，使用sql.executeUpdate()代替
                //System.out.println(res);

                if (res > 0) {
                    flag = true;
                }
                conn.close();
            } else {
                System.out.println("数据库连接失败");
            }
        } catch (NamingException | SQLException e) {
            e.printStackTrace();
        }


        //接口返回json
        if (flag) {
            jsonObject = new JSONObject("{flag:true}");
        } else {
            jsonObject = new JSONObject("{flag:false}");
        }

        resp.getOutputStream().write(jsonObject.toString().getBytes("utf-8"));

    }
}
