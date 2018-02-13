<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>工资明细</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>

        .detail-div{padding: 15px;}
        table{width: 100%}
        table tr td, th {
            padding: 15px;
        }
        .paging{

        }
        .not-data{text-align: center;color: #999999;padding: 30px;}

    </style>
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>

<div class="detail-div">
    <table border="1" borderColor="#e1e1e1" cellspacing="0">
        <tr>
            <th>序号</th>
            <th>姓名</th>
            <th>国籍</th>
            <th>证件编号</th>
            <th>报税地</th>
            <th>银行卡号</th>
            <th>开户行</th>
            <th>所属月份</th>
            <th>工资类型</th>
            <th>应发工资</th>
            <th>应扣工资</th>
            <th>税前工资</th>
            <th>个税</th>
            <th>实发工资</th>
        </tr>
        <tr ng-repeat="data in dataList">
            <td>{{$index + 1}}</td>
            <td>{{data.userName}}</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>{{data.bankCard}}</td>
            <td>&nbsp;</td>
            <td>{{data.month | date : "yyyyMM"}}</td>
            <td>{{data.salaryTypeId}}</td>
            <td>{{data.shouldSendSalary}}</td>
            <td>{{data.shouldBeDeductPay}}</td>
            <td>{{data.salaryBeforeTax}}</td>
            <td>{{data.individualIncomeTax}}</td>
            <td>{{data.takeHomePay}}</td>
        </tr>
        <tfoot ng-show="dataList.length == 0"><tr><td colspan="99" class="not-data">暂无数据</td></tr></tfoot>
    </table>

    <div class="paging" id="pageContainer"></div>

</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp = angular.module('webApp', []);
    webApp.controller("controller", function ($scope, $timeout) {
        $scope.dataList = null;
        $scope.isFirst = false; //是否加载过第一次了
        layui.use(['laypage', 'layer'], function(){
            var laypage = layui.laypage
                    ,layer = layui.layer
                    ,form = layui.form();
            $scope.initData = function (totalPage) {
                laypage({
                    cont: 'pageContainer'
                    ,pages: Math.ceil(totalPage / 20)
                    ,skip: true
                    ,jump: function(obj, first){
                        if(!first){
                            $scope.getList(obj.curr - 1, 20);
                        }
                    }
                });
                form.render();
            }
        });

        $scope.getList = function (page, pageSize) {
            AM.ajaxRequestData("post", false, AM.ip + "/salaryInfo/getSalaryInfo", {
                page : page,
                pageSize : pageSize,
                companySonBillItemId : AM.getUrlParam("companySonBillItemId")
            }, function (result) {
                if (!$scope.isFirst) {
                    $scope.isFirst = true;
                    $scope.dataList = result.data;
                    $scope.initData(result.recordsTotal);
                }
                else {
                    $timeout(function () {
                        $scope.dataList = result.data;
                    });
                }
            });
        }
        $scope.getList(0, 20);
    });

</script>
</body>
</html>
