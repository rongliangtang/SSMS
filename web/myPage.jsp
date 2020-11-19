<%--
  Created by IntelliJ IDEA.
  User: liang
  Date: 2020/10/1
  Time: 11:39 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- prefix属性用于指定库前缀 --> <!-- uri属性用于指定库的标识 -->
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="utils.getAvgScore" %>
<%@ page import="utils.getTotalScore" %>

<html>
<head>
    <title>我的信息</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <script type="text/javascript" src="js/jquery-3.5.1.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <script src="./js/jquery.growl.js"></script>
    <link rel="stylesheet" href="./css/jquery.growl.css">
</head>
<body>
<%
    String username = (String) request.getSession().getAttribute("username");
    double averageScore = new getAvgScore().getResult(username);;
    double totalScore = new getTotalScore().getResult(username);;

    request.setAttribute("username",username);
    request.setAttribute("avg",averageScore);
    request.setAttribute("total",totalScore);


//    request.setAttribute("totalScore",totalScore);
//    request.setAttribute("averageScore",averageScore);

%>
<div class="box">
    <div class="left">
        <div id="head">
            <img class="photo" src="./img/student.png" alt="student">
        </div>
        <div id="menu">
            <ul class="menu">
                <li>
                    <a href="#" style="color: #0057B3;">我的信息</a>
                </li>
                <li>
                    <a href="/mainPage.jsp">查看成绩</a>
                </li>
                <li>
                    <a href="#" data-toggle="modal" data-target="#exampleModalAdd">添加成绩</a>
                </li>
                <li>
                    <a href="/exitSystem">退出系统</a>
                </li>
            </ul>
            <%--            bootstrap模态框放在ul标签内无效，拿出让其不在ul内即可解决问题--%>
            <div class="modal fade" id="exampleModalAdd" tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalLabelAdd" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">

                            <h5 class="modal-title" id="exampleModalLabelAdd">添加</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="form-group">
                                    <label for="classname" class="col-form-label">课程名称</label>
                                    <input type="text" class="form-control" id="classname">
                                </div>
                                <div class="form-group">
                                    <label for="score" class="col-form-label">课程分数</label>
                                    <input type="text" class="form-control" id="score">
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" id="add">确认</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="right">
        <div class="main">
<%--            <div class="user">--%>
<%--                <img src="./img/user.png" alt="用户头像">--%>
<%--            </div>--%>
            <div class="userCard">
                <div class="card" style="width: 32rem;color: #666;">
                    <div class="card-header">
                        用户信息
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            用户名:
                            <p>${username}</p>
                        </li>
                        <li class="list-group-item">
                            总成绩:
                            <p>${total}</p>
                        </li>
                        <li class="list-group-item">
                            平均分:
                            <p>${avg}</p>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
<style>
    li{
        list-style: none;
    }
    a{
        cursor: pointer;
        text-decoration: none;
        color: #fff;
    }
    a:hover{
        text-decoration: none;
    }
    .box{
        width: 90%;
        height: 90%;
        margin: 0 auto;
        margin-top: 2.5%;
        border-radius: 20px;
        box-shadow: 4px 2px 16px #cbd3da;
        overflow: hidden;
    }
    .left{
        width:20%;
        height: 100%;
        background-color: #3E83FE;
        float: left;
    }
    .right{
        width:80%;
        height: 100%;
        /*background: #ffcccc;*/
        float: left;
    }

    #head{
        width: 120px;
        height: 120px;
        margin: 0px auto;
        margin-top: 100px;
    }

    .photo{
        width: 120px;
        height: 120px;
    }

    .menu{
        font-size: 32px;
        color: #fff;
        text-align: center;
        margin-right: 50px;
        margin-top: 90px;
    }

    .menu > li{
        margin: 50px 0;
    }

    .main{
        height: 90%;
        width: 90%;
        margin:0 auto;
        margin-top:5%;
    }

    .user{
        width: 128px;
        margin: 0 auto;
        margin-top: 120px;
        color: #666;
        font-size: 32px;
    }

    .user>img{
        display: block;
    }

    .userCard{
        width: 32rem;
        margin: 0 auto;
        margin-top: 250px;
        text-align: center;
        font-size: 26px;
    }

    li > p{
        display: inline;
    }


</style>
<script>
    $("#add").click(function () {
        var username = "${username}"
        var classname = $("#classname").val()
        var score = $("#score").val()
        console.log(username,classname,score)
        if (username && classname && score) {
            $.ajax({
                url: "http://localhost:8080/addScore",
                type: "post",
                data: {
                    classname: classname,
                    score: score,
                    username: username
                },
                dataType: "json",
                success: function (result) {
                    var flag = result.flag;
                    if (flag == true) {
                        //验证成功
                        $.growl.notice({title: "提示", message: "添加成功!"});
                        setTimeout(function(){
                            window.location.reload();
                        },1000)
                    } else {
                        //验证失败
                        $.growl.error({title: "提示", message: "添加失败!"});
                    }
                }
            })
        } else {
            $.growl.warning({title: "提示", message: "课程名和分数不能为空！"});
        }
    });
</script>
</html>



