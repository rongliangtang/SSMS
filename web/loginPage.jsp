<%--
  Created by IntelliJ IDEA.
  User: liang
  Date: 2020/10/1
  Time: 11:39 上午
  To change this template use File | Settings | File Templates.
--%>
<%--
待解决：
如何解决登录后，再去登录页面输什么都能登录成功的问题
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
    <script src="./js/jquery-3.5.1.min.js"></script>
    <script src="./js/jquery.growl.js"></script>
    <link rel="stylesheet" href="./css/jquery.growl.css">
</head>
<body>
<div class="buttomBlue"></div>
<div class="box">
    <div class="welcome">
        <p class="one">欢迎使用</p>
        <p class="two">个人成绩管理系统</p>
    </div>
    <%--input行使用两栏布局--%>
    <input type="username" class="input-box" name="username" id="username" placeholder="请输入用户名">
    <input type="password" class="input-box" name="password" id="password" placeholder="请输入密码">
    <div class="jump">
        <a href="signUpPage.jsp">还没有账号？快去注册</a>
    </div>
    <button type="button" class="btn-box" id="login">登&nbsp&nbsp&nbsp录</button>

</div>

</body>
<style>
    /*css 初始化 */
    html, body, ul, li, ol, dl, dd, dt, p, h1, h2, h3, h4, h5, h6, form, fieldset, legend, img {
        margin: 0;
        padding: 0;
    }

    /*解决position和margin-top同时使用，margin-top崩塌的问题*/
    body {
        border-top: 1px solid #3E83FE;
    }

    .buttomBlue {
        width: 100%;
        height: 60%;
        background-color: #3E83FE;
        position: fixed;
        z-index: -1;
    }

    .box {
        width: 460px;
        height: 550px;
        margin: 0 auto;
        margin-top: 10%;
        background-color: white;
        border-radius: 6px;
        box-shadow: 4px 2px 16px #555555;
    }

    .welcome {
        width: 100%;
        padding-top: 50px;
        text-align: center;
    }

    .welcome > .one {
        display: inline;
        margin-top: 20px;
        font-size: 40px;
        color: #3E83FE;
        cursor: pointer;
    }

    .welcome > .two {
        display: inline;
        margin-top: 20px;
        font-size: 20px;
        color: #9B9B9B;
        cursor: pointer;
    }

    .input-box {
        display: block;
        height: 50px;
        width: 360px;
        font-weight: lighter;
        font-size: 20px;
        color: #9B9B9B;
        margin-top: 60px;
        margin-left: 45px;
        border-width: 0px;
        border-bottom-width: 1px;
        border-color: #979797;
        outline: none;

    }

    .jump {
        /*display: inline;*/
        margin-top: 60px;
        font-size: 18px;
        text-align: center;
        position: relative;
        bottom: 2px;
    }

    .jump > a {
        font-weight: lighter;
        color: #9B9B9B;
        cursor: pointer;
        text-decoration: none;
    }

    .btn-box {
        width: 340px;
        height: 46px;
        font-size: 26px;
        color: #fff;
        margin-top: 20px;
        margin-bottom: 20px;
        margin-left: 60px;
        background-color: #3E83FE;
        border-radius: 12px;
        border: none;
        border-width: 0px;
        outline: none;
        cursor: pointer;
        transition: 0.8s;
    }

</style>
<script>
    $("#login").click(function () {
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        if (username && password) {
            $.ajax({
                url: "http://localhost:8080/loginCheck",
                type: "post",
                data: {
                    username: username,
                    password: password
                },
                dataType: "json",
                success: function (result) {
                    var flag = result.flag;
                    if (flag == true) {
                        //验证成功
                        $.growl.notice({title: "提示", message: "登录成功!"});
                        setTimeout(function(){
                            window.location.href = "http://localhost:8080/mainPage.jsp";
                        },1000)
                    } else {
                        //验证失败
                        $.growl.error({title: "提示", message: "用户名或者密码不正确!"});
                    }
                }
            })

        } else {
            $.growl.warning({title: "提示", message: "用户名和密码不能为空！"});
        }
    });

</script>
</html>
