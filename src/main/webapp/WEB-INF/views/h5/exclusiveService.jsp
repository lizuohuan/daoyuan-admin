<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>专项服务明细</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>

        .detail-div{padding: 15px;}
        table{width: 100%}
        table tr td, th {
            padding: 15px;
        }

    </style>
</head>
<body>

<div class="detail-div">
    <table border="1" borderColor="#e1e1e1" cellspacing="0">
        <tr>
            <th>序号</th>
            <th>姓名</th>
            <th>证件编号</th>
            <th>服务起始月</th>
            <th>本次服务时长</th>
            <th>险种名称1</th>
            <th>险种名称1</th>
            <th>险种名称1</th>
            <th>险种名称1</th>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>

    </table>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>



</script>
</body>
</html>
