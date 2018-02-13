<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改用户</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{height: 250px;width: 400px;margin-right: 10px;margin-bottom: 10px;float: left;text-align: center}
        .preview img{width: 100%;height:210px;border: 1px solid #eee;}
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改用户</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editUserCtr" ng-cloak>

            <div class="layui-form-item">
                <label class="layui-form-label">用户角色<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="roleId" <%--disabled--%> id="roleId" lay-filter="roleId" lay-verify="required" lay-search>
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item " >
                <label class="layui-form-label"><span >账号</span><span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="account" value="{{user.account}}"  lay-verify="required" disabled autocomplete="off" class="layui-input" maxlength="50">
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label"><span >姓名</span><span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="userName" value="{{user.userName}}"  lay-verify="required"  autocomplete="off" class="layui-input" maxlength="50">
                </div>
            </div>

            <div class="layui-form-item " >
                <label class="layui-form-label"><span id="email">email</span><span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="email" value="{{user.email}}"  lay-verify="required|isEmail"  autocomplete="off" class="layui-input" maxlength="50">
                </div>
            </div>

            <div class="layui-form-item " >
                <label class="layui-form-label"><span >工作手机号</span><span class="font-red"></span></label>
                <div class="layui-input-inline">
                    <input type="text" name="workPhone" value="{{user.workPhone}}"  lay-verify="isPhone" placeholder="请输入手机号" autocomplete="off" class="layui-input" maxLength="11">
                </div>
            </div>
            <div class="layui-form-item " >
                <label class="layui-form-label"><span >私人手机号</span><span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="homePhone" value="{{user.homePhone}}"   lay-verify="required|isPhone" placeholder="请输入手机号" autocomplete="off" class="layui-input" maxLength="11">
                </div>
            </div>

            <input type="hidden" name="id" value="{{user.id}}">

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
    webApp.controller("editUserCtr", function($scope,$http,$timeout){

        $scope.user = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/user/getUserById", {id : $scope.id} , function(result) {
            $scope.user = result.data;
        });
        console.log($scope.user);
        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;
            getRoleList($scope.user.roleId); //角色列表
            //选中是否可用
            $("input[name='isValid']").each(function () {
                if (Number($(this).val()) == Number($scope.user.isValid)) {
                    $(this).click();
                }
            });

            //监听角色
            form.on('select(roleId)', function(data) {
                form.render();
            });







            //自定义验证规则
            form.verify({
                isNumber: function(value) {
                    if(value.length > 0 && !AM.isNumber.test(value)) {
                        return "请输入一个整数";
                    }
                },
                isPhone: function(value) {
                    if(value.length > 0 && !AM.isMobile.test(value)) {
                        return "请输入一个正确的手机号";
                    }
                },
                isEmail: function(value) {
                    if(value.length > 0 && !AM.isEmail.test(value)) {
                        return "请输入一个正确的邮箱";
                    }
                },
                isNumberChar: function(value) {
                    if(value.length > 0 && !AM.isNumberChar.test(value)) {
                        return "只能为数字和字母";
                    }
                },
                isAccount: function(value) {
                    if(value.length < 3 || value.length > 16) {
                        return "请输入（3-16）位";
                    }
                }

            });


            form.render();




            //监听提交
            form.on('submit(demo1)', function(data) {
                AM.ajaxRequestData("post", false, AM.ip + "/user/updateUser", data.field , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
                return false;
            });
        });
    });







</script>
</body>
</html>
