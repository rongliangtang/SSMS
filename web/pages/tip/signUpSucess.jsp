<%--
  Created by IntelliJ IDEA.
  User: liang
  Date: 2020/10/1
  Time: 11:40 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--登录成功，显示提示1秒后跳到主界面--%>
<meta http-equiv="refresh" content="1;url=mainPage.jsp"/>
<html>
<head>
    <title>注册成功</title>
</head>
<body>
    <div class="box">
        <%--图片路径加载有坑：需要先在tomcat上deploy图片文件夹（到服务器上），deply的path即为图片路径path--%>
        <img src="../../img/sucess.png" alt="signUpSucess">
        <p>
            注册成功
        </p>
    </div>


</body>
<style>
    .box {
        margin: 0 auto;
        margin-top: 120px;
        text-align: center;
    }

    img {
        height: 128px;
        width: 128px;
    }

    div > p {
        color: #9B9B9B;
    }

</style>


</html>
