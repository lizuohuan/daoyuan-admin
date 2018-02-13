<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>实做子类详情</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{height: 250px;width: 400px;margin-right: 10px;margin-bottom: 10px;float: left;text-align: center}
        .preview img{width: 100%;height:210px;border: 1px solid #eee;}
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>实做子类详情</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">缴金地名</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.payPlaceName}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">经办机构名</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.organizationName}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">办理方名</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.transactorName}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">档次</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.insuranceLevelName}}</div>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">基数</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.baseNumber}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">服务时间</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.serviceMonth | date : "yyyy-MM"}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">创建时间</label>
                <div class="layui-input-inline">
                    <div class="layui-input">{{memberBusinessUpdateRecordItem.createTime | date : "yyyy-MM-dd"}}</div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">增减变状态</label>
                <div class="layui-input-inline">
                    <div class="layui-input">
                        <span ng-if="memberBusinessUpdateRecordItem.serviceStatus == 0">增员</span>
                        <span ng-if="memberBusinessUpdateRecordItem.serviceStatus == 1">减员</span>
                        <span ng-if="memberBusinessUpdateRecordItem.serviceStatus == 2">变更</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-inline">
                    <div class="layui-input">
                        <!-- 0：待申请 1：待反馈  2：成功  3: 失败 4: 取消 -->
                        <span ng-if="memberBusinessUpdateRecordItem.status == 0">待申请</span>
                        <span ng-if="memberBusinessUpdateRecordItem.status == 1">待反馈</span>
                        <span ng-if="memberBusinessUpdateRecordItem.status == 2">成功</span>
                        <span ng-if="memberBusinessUpdateRecordItem.status == 3">失败</span>
                        <span ng-if="memberBusinessUpdateRecordItem.status == 4">失效</span>
                    </div>
                </div>
            </div>
        </div>


        <div class="layui-form-item">
            <div class="layui-block">
                <label class="layui-form-label">原因</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" readonly>{{memberBusinessUpdateRecordItem.reason}}</textarea>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-block">
                <label class="layui-form-label">变更内容</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" readonly>{{memberBusinessUpdateRecordItem.updateContent}}</textarea>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-block">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea class="layui-textarea" readonly>{{memberBusinessUpdateRecordItem.remark}}</textarea>
                </div>
            </div>
        </div>


    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.memberBusinessUpdateRecordItem = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/memberBusinessUpdateRecordItem/info", {id : $scope.id} , function(result) {
            $scope.memberBusinessUpdateRecordItem = result.data;
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form();
        });
    });







</script>
</body>
</html>
