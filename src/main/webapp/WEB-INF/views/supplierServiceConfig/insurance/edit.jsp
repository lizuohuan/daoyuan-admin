<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改险种</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改险种</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>险种名称</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{insurance.insuranceName}}" name="insuranceName" lay-verify="required" placeholder="请输入险种名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="remark" class="layui-textarea" placeholder="请输入备注" rows="5" maxlength="200">{{insurance.remark}}</textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.insurance = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/insurance/getInsuranceById", {id : $scope.id} , function(result) {
            $scope.insurance = result.data;
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = Number($scope.id);
                AM.log(data.field);
                AM.ajaxRequestData("post", false, AM.ip + "/insurance/update", data.field , function(result) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });
        });
    });







</script>
</body>
</html>
