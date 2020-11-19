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
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="bean.Score" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>


<html>
<head>
    <title>查看成绩</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <script type="text/javascript" src="js/jquery-3.5.1.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <script src="./js/jquery.growl.js"></script>
    <link rel="stylesheet" href="./css/jquery.growl.css">
</head>
<body>
<div class="box">
    <div class="left">
        <div id="head">
            <img class="photo" src="./img/student.png" alt="student">
        </div>
        <div id="menu">
            <ul class="menu">
                <li>
                    <a href="/myPage.jsp">我的信息</a>
                </li>
                <li>
                    <a href="#" style="color: #0057B3;">查看成绩</a>
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
            <%--jsp从数据库读出用户的成绩存到list动态数组中--%>
            <%
                request.setAttribute("temp", 0);

                String username = (String) request.getSession().getAttribute("username");
                request.setAttribute("username", username);
                List<Score> list = new ArrayList<>();
                //通过数据库连接池连接数据库
                //初始化查找命名空间
                Context ctx = new InitialContext();
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

                    String condition = "select * from score where username=? order by creatime";
                    sql = conn.prepareStatement(condition);
                    sql.setString(1, username);
                    res = sql.executeQuery();

                    while (res.next()) {
                        Score score = new Score();
                        score.setClassname(res.getString(1));
                        score.setScore(res.getString(2));
                        list.add(score);
//                        System.out.println(score.getClassname() + "///" + score.getScore());
                    }
                    request.setAttribute("list", list);
                    conn.close();
                } else {
                    System.out.println("数据库连接失败");
                }
            %>
            <table class="table table-hover" style="color: #666">
                <thead>
                <tr>
                    <th scope="col">课程ID</th>
                    <th scope="col">课程名称</th>
                    <th scope="col">课程分数</th>
                    <th scope="col">课程操作</th>
                </tr>
                </thead>
                <tbody>
                <%--注意得到list后，把list放到req中，再重req中取出，直接用${}是无法取出list的--%>
                <%--${}为el表达式，忘记了直接百度看一下资料回忆--%>
                <%--如果通过var遍历list里面的对象会出错，解决办法是：通过list[1]这样子去访问--%>
                <%--c:if是为了判断list里面的元素是否为空，如果为空的话则不遍历显示--%>

                <%--注意：循环出来的模态框id要不同，否则都会打开同一个模态框；同理，每个模态框中的input框的id也要不同--%>
                <%--不同的模态框可以通过onclick="function(xxx)"，来传参;获取不同模态框中input的内容，可以通过不同的id获取--%>
                <c:forEach items="<${list}>" var="score" varStatus="id">
                    <c:if test="${list[id.index]!=null}">
                        <tr>
                            <th scope="row">
                                    ${id.index + 1}
                            </th>
                            <td>
                                    ${temp = list[id.index].classname}
                            </td>
                            <td>
                                    ${list[id.index].score}
                            </td>
                            <td>
                                <button type="button" class="btn btn-outline-primary" data-toggle="modal"
                                        data-target="#update${list[id.index].classname}">修改
                                </button>
                                <div class="modal fade" id="update${list[id.index].classname}" tabindex="-1" role="dialog"
                                     aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">修改</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                <form>
                                                    <div class="form-group">
                                                        <label for="newclassname_${list[id.index].classname}" class="col-form-label">课程名称</label>
                                                        <input type="text" class="form-control" id="newclassname_${list[id.index].classname}">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="newscore_${list[id.index].classname}" class="col-form-label">课程分数</label>
                                                        <input type="text" class="form-control" id="newscore_${list[id.index].classname}">
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消
                                                </button>
                                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="update('${list[id.index].classname}')">确认</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-outline-danger" data-toggle="modal"
                                        data-target="#${list[id.index].classname}del">删除
                                </button>
                                <div class="modal fade" id="${list[id.index].classname}del" tabindex="-1" role="dialog"
                                     aria-labelledby="${list[id.index].classname}delTitle" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="${list[id.index].classname}delTitle">提示</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                是否确认删除这条记录
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">取消
                                                </button>
                                                <button type="button" class="btn btn-danger"  data-dismiss="modal" onclick="del('${list[id.index].classname}')">确认</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
<style>
    li {
        list-style: none;
    }

    a {
        cursor: pointer;
        text-decoration: none;
        color: #fff;
    }

    a:hover {
        text-decoration: none;
    }

    .box {
        width: 90%;
        height: 90%;
        margin: 0 auto;
        margin-top: 2.5%;
        border-radius: 20px;
        box-shadow: 4px 2px 16px #cbd3da;
        overflow: hidden;
    }

    .left {
        width: 20%;
        height: 100%;
        background-color: #3E83FE;
        float: left;
    }

    .right {
        width: 80%;
        height: 100%;
        /*background: #ffcccc;*/
        float: left;
    }

    #head {
        width: 120px;
        height: 120px;
        margin: 0px auto;
        margin-top: 100px;
    }

    .photo {
        width: 120px;
        height: 120px;
    }

    .menu {
        font-size: 32px;
        color: #fff;
        text-align: center;
        margin-right: 50px;
        margin-top: 90px;
    }

    .menu > li {
        margin: 50px 0;
    }

    .main {
        height: 90%;
        width: 90%;
        margin: 0 auto;
        margin-top: 5%;
    }

</style>
<script>
    function del(classname) {
        var username = "${username}"
        var classname = classname
        // console.log(classname)
        if (username && classname) {
            $.ajax({
                url: "http://localhost:8080/deleteScore",
                type: "post",
                data: {
                    username: username,
                    classname: classname
                },
                dataType: "json",
                success: function (result) {
                    var flag = result.flag;
                    if (flag == true) {
                        //验证成功
                        $.growl.notice({title: "提示", message: "删除成功!"});
                        setTimeout(function(){
                            window.location.reload();
                        },1000)
                    } else {
                        //验证失败
                        $.growl.error({title: "提示", message: "删除失败!"});
                    }
                }
            })
        } else {
            $.growl.warning({title: "提示", message: "出错了！"});
        }
    }

    function update(classname) {
        var username = "${username}"
        var classname = classname
        var newclassname = $("#newclassname_" + classname).val()
        var newscore = $("#newscore_"    + classname).val()
        // console.log(username,classname,newclassname,newscore)
        if (username && classname && newclassname && newscore) {
            $.ajax({
                url: "http://localhost:8080/updateScore",
                type: "post",
                data: {
                    username: username,
                    classname: classname,
                    newclassname: newclassname,
                    newscore: newscore,

                },
                dataType: "json",
                success: function (result) {
                    var flag = result.flag;
                    if (flag == true) {
                        //验证成功
                        $.growl.notice({title: "提示", message: "修改成功!"});
                        setTimeout(function(){
                            window.location.reload();
                        },1000)
                    } else {
                        //验证失败
                        $.growl.error({title: "提示", message: "修改失败!"});
                    }
                }
            })
        } else {
            $.growl.warning({title: "提示", message: "课程名和分数不能为空！"});
        }
    }

    $("#add").click(function () {
        var username = "${username}"
        var classname = $("#classname").val()
        var score = $("#score").val()
        // console.log(username,classname,score)
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



