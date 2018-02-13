<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>工单进度</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">
    <style>
        html,body{width: 100%;}
    </style>
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<fieldset class="layui-elem-field">
    <legend>工单进度&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
    </legend>
    <div class="layui-field-box layui-form">
        <div class="intro-flow">
            <div class="intro-list" ng-repeat="order in workOrderScheduleList">
                <div class="intro-list-left">
                    <%--业务受理--%>
                </div>
                <div class="intro-list-right">
                    <span>{{ workOrderScheduleList.length - $index }}</span>
                    <div class="intro-list-content">
                        <img class="intro-img" ng-if="detail.avatar == null" src="<%=request.getContextPath()%>/resources/img/0.jpg" >
                        <div class="content">
                            <p>申请人：{{order.proposerName}}</p>
                            <p ng-if="order.status != 0">经办人：{{order.userName == null ? order.roleName : order.userName}}</p>
                            <p>状态：
                                <span ng-if="order.status == 0" style="color: green">已申请</span>
                                <span ng-if="order.status == 1" style="color: orange">已处理</span>
                                <span ng-if="order.status == 2" style="color: red">不同意</span>
                                <span ng-if="order.status == 3">完成</span>
                                <span ng-if="order.status == 4" style="color: #666">作废</span>
                                <span ng-if="order.status == 5" style="color: #666">待确认</span>
                            </p>
                            <p ng-if="order.status == 0">申请时间：{{order.createTime | date : "yyyy-MM-dd hh:mm:ss"}}</p>
                            <p ng-if="order.status != 0">处理时间：{{order.createTime | date : "yyyy-MM-dd hh:mm:ss"}}</p>
                            <p ng-if="order.accessory != null && order.accessory != ''">附件：
                                <a ng-if="!order.isContains" style="color: #1E9FFF;" href="<%=request.getContextPath()%>/{{order.accessory}}" target="_blank">下载</a>
                                <a ng-if="order.isContains" style="color: #1E9FFF;" href="<%=request.getContextPath()%>/page/workOrder/preview?url={{order.accessory}}" target="_blank">查看预览</a>
                            </p>
                            <p ng-if="order.status == 0">申请内容：{{order.remark}}</p>
                            <p ng-if="order.status != 0">处理意见：{{order.remark}}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</fieldset>



<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>

<script>
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope){
        $scope.id = AM.getUrlParam("id");
        /**获取工单进度**/
        AM.ajaxRequestData("get", false, AM.ip + "/workOrderSchedule/list", {workOrderId : $scope.id} , function(result) {
            $scope.workOrderScheduleList = result.data;
            for (var i = 0; i < $scope.workOrderScheduleList.length; i++) {
                var obj = $scope.workOrderScheduleList[i];
                obj.isContains = false;
                if (obj.accessory.indexOf(".png") != -1 ||
                        obj.accessory.indexOf(".gif") != -1 ||
                        obj.accessory.indexOf(".jpg") != -1
                ) {
                    obj.isContains = true;
                }
            }
        });
    });
</script>
</body>
</html>
