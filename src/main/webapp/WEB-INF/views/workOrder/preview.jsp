<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>预览</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        html,body{width: 100%;}
    </style>
</head>
<body>
<div style="margin: 15px;">
    <img id="previewImg">
</div>



<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>

<script>
   var url = AM.getUrlParam("url");
    $("#previewImg").attr("src", AM.ip + "/" + url);
</script>
</body>
</html>
