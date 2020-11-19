package servlets;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import javax.naming.*;
import java.sql.*;
import org.json.JSONObject;
import utils.MD5Utils;

public class LoginCheckServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("text/html;charset=UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        //将密码进行加密后到数据库验证
        password = MD5Utils.str2MD5(password);

        boolean flag = false;

//        //从cookie中取出值
//        Cookie[] cs=req.getCookies();
//        String v=null;
//        if(cs!=null) {
//            for (int i = 0; i < cs.length; i++) {//获取名称为username的Cookie对象值
//                if (cs[i].getName().equals("JSESSIONID")) {
//                    v = cs[i].getValue();
//                }
//            }
//        }
//        System.out.println(v);


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

                String condition = "select * from user where username=? and password=?";
                sql = conn.prepareStatement(condition);
                sql.setString(1, username);
                sql.setString(2, password);
                res = sql.executeQuery();

                if (res.next()) {
                    flag = true;
                    //servlet中不需要使用cookie存session的方式，登录的时候，不管成功失败，servlet会自动存放一个cookie，其中存放session的id
                    //每次访问session都是通过现在cookie中存放的这个sessionid来访问session
                    //当登录成功我们可以通过在这个session中存放标志来记录用户的登录状态
                    req.getSession().setAttribute("username", username);
                    //控制session自动失效的时间，以秒为单位，这里设为三天
                    req.getSession().setMaxInactiveInterval(60 * 60 * 24 * 3);

//                        //登录成功后，保存名称为JSESSIONID的id的cookie，值为session的id
//                        Cookie c = new Cookie("JSESSIONID",req.getSession().getId());
//                        c.setMaxAge(60);
//                        c.setPath("/");
//                        resp.addCookie(c);
                }
                conn.close();
            } else {
                System.out.println("数据库连接失败");
            }
        } catch (NamingException | SQLException e) {
            e.printStackTrace();
        }

        //接口返回json
        JSONObject jsonObject = null;

        if (flag) {
            jsonObject = new JSONObject("{flag:true}");
//            req.getRequestDispatcher("/pages/tip/loginSucess.jsp").forward(req, resp);
        } else {
            jsonObject = new JSONObject("{flag:false}");
//            req.getRequestDispatcher("/pages/tip/loginFail.jsp").forward(req, resp);
        }

        resp.getOutputStream().write(jsonObject.toString().getBytes("utf-8"));
    }

}
