<%@ page import="com.mysql.connectMysql" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %><%--
  Created by IntelliJ IDEA.
  User: liang
  Date: 2020/10/3
  Time: 3:51 下午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%--将req中的参数写入到bean中，多个jsp页面同时访问一个JavaBean，则需要将scope设置为session--%>
    <jsp:useBean id="user" class="bean.User" scope="page">
        <jsp:setProperty name="user" property="username" param="username"/>
        <jsp:setProperty name="user" property="password" param="password"/>
    </jsp:useBean>


    <%
        String username = user.getUsername();
        String password = user.getPassword();
        //System.out.println(username);
        //System.out.println(password);

        boolean flag = false;

        //通过数据库连接池连接数据库
        //初始化查找命名空间
        Context ctx = new InitialContext();
        //参数java:/comp/env为固定路径
        Context envContext = (Context)ctx.lookup("java:/comp/env");
        //参数jdbc/mysqlds为数据源和JNDI绑定的名字
        DataSource ds = (DataSource)envContext.lookup("jdbc/mysqlds");
        Connection conn = ds.getConnection();

        //Connection conn = connectMysql.connect();
        if(conn != null){
            System.out.println("数据库连接成功");
            //进行查询操作select * from user where username='admin'and password='123456'
            PreparedStatement sql;
            ResultSet res;

            String condition="select * from user where username=? and password=?";
            sql=conn.prepareStatement(condition);
            sql.setString(1,username);
            sql.setString(2,password);
            res=sql.executeQuery();

            if (res.next()) {
                flag=true;
            }

            connectMysql.closeConnection(conn);
        }else{
            System.out.println("数据库连接失败");
        }

        if (flag){
            //跳转登录成功页面
            response.sendRedirect("signUpSucess.jsp");
        }else {
            response.sendRedirect("signUpFail.jsp");
        }
    %>　

</body>
<style>

</style>
<script>

</script>
</html>