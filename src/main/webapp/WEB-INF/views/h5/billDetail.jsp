<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>账单明细</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>

        .bill-div{
            width: 500px;
            border: 1px solid #e1e4e9;
            margin: 50px auto;
        }
        table{width: 100%}
        table tr{
            height: 50px;
            border-bottom: 1px solid #e1e4e9;
        }
        table tr:last-child{border-bottom: none}
        .left{text-align: left !important;padding-left: 15px;width: 150px;}
        .right{text-align: right !important;padding-right: 15px;}
        .align-left{text-align: left !important;padding: 15px;}
        .commonSeal{text-align: right}
        .commonSeal img{width: 150px;height: 150px;}
        .date{text-align: right;font-size: 18px;}

    </style>
</head>
<body>

<div class="bill-div">
    <table>
        <tr>
            <td class="left">社保款</td>
            <td class="right">￥999</td>
            <td class="left">我们的收款信息</td>
            <td></td>
        </tr>
        <tr>
            <td class="left">公积金款</td>
            <td class="right">￥999</td>
            <td class="left">账户名：</td>
            <td class="right">张三</td>
        </tr>
        <tr>
            <td class="left">工资款</td>
            <td class="right">￥999</td>
            <td class="left">银行账号：</td>
            <td class="right">64564564545645465465</td>
        </tr>
        <tr>
            <td class="left">服务费</td>
            <td class="right">￥999</td>
            <td class="left">开户行：</td>
            <td class="right">高新区支行</td>
        </tr>
        <tr>
            <td class="left">商业险</td>
            <td class="right">￥999</td>
            <td class="left">or 支付宝</td>
            <td></td>
        </tr>
        <tr>
            <td class="left">*体检</td>
            <td class="right">￥999</td>
            <td class="left">支付宝名称：</td>
            <td class="right">张三</td>
        </tr>
        <tr>
            <td class="left">*法律服务</td>
            <td class="right">￥999</td>
            <td class="left">支付宝账号：</td>
            <td class="right">15215456456</td>
        </tr>
        <tr>
            <td class="left">*合计</td>
            <td class="right">￥999</td>
            <td class="left">账单制作人：</td>
            <td class="right">张三</td>
        </tr>
        <tr>
            <td class="left">上月余额</td>
            <td class="right">￥999</td>
            <td class="left">账单制作日期：</td>
            <td class="right">2017-10-16</td>
        </tr>
        <tr>
            <td class="left">本月仍应到款</td>
            <td class="right">￥999</td>
            <td class="left">联系方式：</td>
            <td class="right">15215456456</td>
        </tr>
        <tr>
            <td colspan="4" class="align-left">
                若您确认此账单无疑问，请在右下方点击“确认账单”，并按照贵我双方约定的到款日为每月XX号，请在此日期之前付款，感谢您对我们的支持！
            </td>
        </tr>
        <tr>
            <td colspan="4" class="align-left">
                <p class="commonSeal">
                    <img src="<%=request.getContextPath()%>/resources/img/5.jpg">
                </p>
                <p class="date">2017-10-16</p>
            </td>
        </tr>
    </table>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>



</script>
</body>
</html>
