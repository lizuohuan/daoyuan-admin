<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>社保明细</title>
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
    <a class="layui-btn layui-btn-normal">导出Excel</a>
    <br>
    <br>
    <table border="1" borderColor="#e1e1e1" cellspacing="0">
        <tr>
            <th rowspan="2" scope="col">序号</th>
            <th rowspan="2" scope="col">姓名</th>
            <th rowspan="2" scope="col">证件编号</th>
            <th rowspan="2" scope="col">社保编码</th>
            <th rowspan="2" scope="col">缴金地-经办机构</th>
            <th rowspan="2" scope="col">档次</th>
            <th rowspan="2" scope="col">开始缴纳月</th>
            <th rowspan="2" scope="col">本次服务年月</th>
            <th rowspan="2" scope="col">缴纳基数</th>
            <th colspan="{{dataList.companyNumber}}" scope="col">公司缴纳部分</th>
            <th colspan="{{dataList.personNumber}}" scope="col">个人缴纳部分</th>
            <th colspan="3" scope="col">汇总</th>
        </tr>
        <tr>
            <td ng-repeat="type in dataList.companyType">{{type.insuranceName}}</td>
            <td ng-repeat="type in dataList.personType">{{type.insuranceName}}</td>
            <td>公司</td>
            <td>个人</td>
            <td>合计</td>
        </tr>
        <tr ng-repeat="data in dataList">
            <td>{{$index + 1}}</td>
            <td>{{data.userName}}</td>
            <td>{{data.idCard}}</td>
            <td>{{data.socialSecurityNum}}</td>
            <td>{{data.payPlaceOrganizationName}}</td>
            <td>{{data.insuranceLevelName}}</td>
            <td>{{data.beginPayYM | date : "yyyyMM"}}</td>
            <td>{{data.serviceNowYM | date : "yyyyMM"}}</td>
            <td>{{data.payCardinalNumber}}</td>
            <td ng-repeat="type in dataList.companyType">{{type.payPrice}}</td>
            <td ng-repeat="type in dataList.personType">{{type.payPrice}}</td>
            <td>{{data.companyTotalPay}}</td>
            <td>{{data.memberTotalPay}}</td>
            <td>{{data.companyTotalPay + data.memberTotalPay}}</td>
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
            AM.ajaxRequestData("post", false, AM.ip + "/socialSecurityInfo/list", {
                page : page,
                pageSize : pageSize,
                companySonBillItemId : AM.getUrlParam("companySonBillItemId")
            }, function (result) {
                if (!$scope.isFirst) {
                    $scope.isFirst = true;
                    $scope.dataList = result.data;
                    $scope.dataList.companyNumber = 0;
                    $scope.dataList.personNumber = 0;
                    $scope.dataList.companyType = null;
                    $scope.dataList.personType = null;
                    for (var i = 0; i < $scope.dataList.length; i++) {
                        var obj = $scope.dataList[i];
                        obj.companyNumber = 0;
                        obj.personNumber = 0;
                        obj.companyType = [];
                        obj.personType = [];
                        for (var j = 0; j < obj.socialSecurityInfoItems.length; j++) {
                            var item = obj.socialSecurityInfoItems[j];
                            if (item.type == 0) {
                                obj.companyNumber ++;
                                obj.companyType.push(item);
                            }
                            else if (item.type == 1) {
                                obj.personNumber ++;
                                obj.personType.push(item);
                            }
                        }
                    }
                    for (var i = 0; i < $scope.dataList.length; i++) {
                        var obj = $scope.dataList[i];
                        if (obj.companyNumber > $scope.dataList.companyNumber) {
                            $scope.dataList.companyNumber = obj.companyNumber;
                            $scope.dataList.companyType = obj.companyType;
                        }
                        if (obj.personNumber > $scope.dataList.personNumber) {
                            $scope.dataList.personNumber = obj.personNumber;
                            $scope.dataList.personType = obj.personType;
                        }
                    }
                    $scope.initData(result.recordsTotal);
                }
                else {
                    $timeout(function () {
                        $scope.dataList = result.data;
                        $scope.dataList.companyNumber = 0;
                        $scope.dataList.personNumber = 0;
                        $scope.dataList.companyType = null;
                        $scope.dataList.personType = null;
                        for (var i = 0; i < $scope.dataList.length; i++) {
                            var obj = $scope.dataList[i];
                            obj.companyNumber = 0;
                            obj.personNumber = 0;
                            obj.companyType = [];
                            obj.personType = [];
                            for (var j = 0; j < obj.socialSecurityInfoItems.length; j++) {
                                var item = obj.socialSecurityInfoItems[j];
                                if (item.type == 0) {
                                    obj.companyNumber ++;
                                    obj.companyType.push(item);
                                }
                                else if (item.type == 1) {
                                    obj.personNumber ++;
                                    obj.personType.push(item);
                                }
                            }
                        }
                        for (var i = 0; i < $scope.dataList.length; i++) {
                            var obj = $scope.dataList[i];
                            if (obj.companyNumber > $scope.dataList.companyNumber) {
                                $scope.dataList.companyNumber = obj.companyNumber;
                                $scope.dataList.companyType = obj.companyType;
                            }
                            if (obj.personNumber > $scope.dataList.personNumber) {
                                $scope.dataList.personNumber = obj.personNumber;
                                $scope.dataList.personType = obj.personType;
                            }
                        }
                    });
                }
            });
        }
        $scope.getList(0, 20);
    });

</script>
</body>
</html>
