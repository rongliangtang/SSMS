<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>循环标签</title>
    <style type="text/css">
        body {
            background: #d7c7e9;
            align-items: center;
            text-align: center;
        }
    </style>
</head>
<body>
<h2>1、&lt;c:forEach&gt;</h2>
<%
    List<String> list = new ArrayList<>();
    list.add("Everybody only can living once");
    list.add("Life is the most precious");
    list.add("we should be kind to life");
    list.add("Hoping to have a good love");
    request.setAttribute("list", list);
%>
<b>遍历集合元素</b>
<c:forEach items="${requestScope.list}" var="listitem" varStatus="id">
    ${id.index}&nbsp;:${listitem}<br>
</c:forEach>
<b>遍历集合下标为1之后的元素</b>
<c:forEach items="${requestScope.list}" var="listitem" varStatus="id" begin="1">
    ${id.index}&nbsp;:${listitem}<br>
</c:forEach>
<b>遍历 10 以内的偶数</b>
<c:forEach var="i" begin="2" end="10" step="2">
    ${i}&nbsp;&nbsp;
</c:forEach>
</body>
</html>