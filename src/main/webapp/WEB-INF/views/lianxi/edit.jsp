<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改联系人</title>
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
        <legend>修改联系人</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editUserCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">联系人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="contactsName" id="contactsName" value="{{contacts.contactsName}}" lay-verify="required|isSpace" placeholder="请输入联系人" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>固定电话</span></label>
            <div class="layui-input-inline" style="width: 100px">
                <input type="text" id="areaCode" lay-verify="isSpace" placeholder="请输入区号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
            <div class="layui-form-mid">-</div>
            <div class="layui-input-inline">
                <input type="text" id="landLine" lay-verify="isSpace" placeholder="请输入固定电话" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>手机号</span></label>
            <div class="layui-input-inline">
                <input type="text" name="phone" lay-verify="isNumber|isSpace" id="phone" value="{{contacts.phone}}"  placeholder="请输入手机号" autocomplete="off" class="layui-input" maxlength="11">
            </div>
        </div>
        <div class="layui-form-item ">
            <label class="layui-form-label"><span>QQ</span></label>
            <div class="layui-input-inline">
                <input type="text" name="qq" id="qq" lay-verify="isSpace" value="{{contacts.qq}}"   placeholder="请输入QQ" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>email</span></label>
            <div class="layui-input-inline">
                <input type="text" name="email" id="email" value="{{contacts.email}}"  lay-verify="isEmail|isSpace" placeholder="请输入邮箱" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>微信号</span></label>
            <div class="layui-input-inline">
                <input type="text" name="weChat" id="weChat" lay-verify="isSpace" value="{{contacts.weChat}}"  placeholder="请输入微信号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>
        <div class="layui-form-item ">
            <label class="layui-form-label"><span>部门</span></label>
            <div class="layui-input-inline">
                <input type="text" name="departmentName" lay-verify="isSpace" value="{{contacts.departmentName}}"   placeholder="请输入部门" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>职位</span></label>
            <div class="layui-input-inline">
                <input type="text" name="jobTitle" lay-verify="isSpace" value="{{contacts.jobTitle}}"   placeholder="请输入职位" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">账单接收人<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="radio" name="isReceiver" id="yes" value="1"   title="是">
                <input type="radio" name="isReceiver" id="no" value="0"  title="否">
            </div>
        </div>

        <input type="hidden" value="${id}" id="id">

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

        $scope.contacts = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/contacts/getContacts", {id : $scope.id} , function(result) {
            $scope.contacts = result.data;
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;


            if($scope.contacts.isReceiver == 1){
                $("#yes").attr("checked",true);
            }else{
                $("#no").attr("checked",true);
            }

            if(null != $scope.contacts.landLine && '' != $scope.contacts.landLine){
                var lands = $scope.contacts.landLine.split("-");
                if(lands.length = 2){
                    $("#areaCode").val(lands[0]);
                    $("#landLine").val(lands[1]);
                }
            }




            //自定义验证规则
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
                isNumberChar: function(value) {
                    if(value.length > 0 && !AM.isNumberChar.test(value)) {
                        return "只能为数字和字母";
                    }
                },
                isSpace: function(value) {
                    if(value.indexOf(" ") >= 0) {
                        return "输入框不能存在空格";
                    }
                }

            });


            form.render();




            //监听提交
            form.on('submit(demo1)', function(data) {
                if(data.field.isReceiver == 1 && $("#phone").val() == "" && $("#email").val() == ""){
                    layer.msg('手机号和邮箱必须填写其中一个');
                    return false;
                }
                data.field.landLine = $("#areaCode").val() + "-" + $("#landLine").val();
                data.field.id = $("#id").val();
                AM.ajaxRequestData("post", false, AM.ip + "/contacts/updateContacts", data.field , function(result) {
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
