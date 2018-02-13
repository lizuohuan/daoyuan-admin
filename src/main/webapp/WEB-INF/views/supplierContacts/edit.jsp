<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改联系人</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改联系人</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label"><span>联系人名字</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.contactsName}}" name="contactsName" lay-verify="required" placeholder="请输入联系人名字" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>部门</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.departmentName}}" name="departmentName" lay-verify="required" placeholder="请输入部门" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>职位</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.jobTitle}}" name="jobTitle" lay-verify="required" placeholder="请输入职位" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>手机号码</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.phone}}" name="phone" lay-verify="required|isNumber" placeholder="请输入手机号码" autocomplete="off" class="layui-input" maxlength="11">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>固定电话</span></label>
            <div class="layui-input-inline">
                <input type="number" value="{{supplierContacts.landLine}}" name="landLine" placeholder="请输入固定电话" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>


        <div class="layui-form-item ">
            <label class="layui-form-label"><span>QQ</span></label>
            <div class="layui-input-inline">
                <input type="number" value="{{supplierContacts.qq}}" name="qq" placeholder="请输入QQ" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>E-mail</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.email}}" name="email" lay-verify="isEmail" placeholder="请输入E-mail" autocomplete="off" class="layui-input" maxlength="20">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>微信号</span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{supplierContacts.weChat}}" name="weChat" placeholder="请输入微信号" autocomplete="off" class="layui-input" maxlength="20">
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
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.supplierContacts = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/supplierContacts/info", {id : $scope.id} , function(result) {
            $scope.supplierContacts = result.data;
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            form.verify({
                isNumber: function(value) {
                    if(value.length > 0 && !AM.isNumber.test(value)) {
                        return "请输入一个整数";
                    }
                },
                isEmail: function(value) {
                    if(value.length > 0 && !AM.isEmail.test(value)) {
                        return "请输入一个正确的邮箱";
                    }
                },
            });
            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = $scope.id;
                AM.ajaxRequestData("post", false, AM.ip + "/supplierContacts/update", data.field , function(result) {
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
