<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改快递信息</title>
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
        <legend>修改快递信息</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editUserCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">快递单号<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="orderNumber" value="{{expressInfo.orderNumber}}" id="orderNumber" lay-verify="required" placeholder="请输入快递单号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label">收件人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="expressPersonId" id="expressPersonId" lay-verify="required">
                    <option value="">请选择收件人</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>快递公司</span></label>
            <div class="layui-input-inline">
                <select name="expressCompanyId" id="expressCompanyId" lay-verify="required" lay-search>
                    <option value="">请选择快递公司</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>所含物品</span></label>
            <div class="layui-input-inline">
                <textarea name="content" id="content"  placeholder="请输入所含物品" class="layui-textarea"></textarea>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>是否收到</span></label>
            <div class="layui-input-inline">
                <input type="radio" id="no" name="isReceive" value="0" title="否" disabled >
                <input type="radio" id="yes" name="isReceive" value="1" title="是" disabled>
            </div>
        </div>



        <input type="hidden" value="${id}" id="id">
        <input type="hidden" value="{{expressInfo.companyId}}" id="companyId" name="companyId">

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                    <%--<button type="reset" class="layui-btn layui-btn-primary">重置</button>--%>
                </div>
            </div>
        </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("editUserCtr", function($scope,$http,$timeout){

        $scope.expressInfo = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/express/queryExpressInfoById", {id : $scope.id} , function(result) {
            $scope.expressInfo = result.data;
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;

        $("#content").val($scope.expressInfo.content);
        getExpressCompanyList($scope.expressInfo.expressCompanyId);
        getExpressPersonInfoList($scope.expressInfo.expressPersonId,$scope.expressInfo.companyId); // 收货人列表
        if($scope.expressInfo.isReceive == 0){
            $("#no").attr("checked",true);
        }else{
            $("#yes").attr("checked",true);
            $("#content").attr("disabled",true);
            $("#orderNumber").attr("disabled",true);
            $("#expressPersonId").attr("disabled",true);
            $("#expressCompanyId").attr("disabled",true);
        }


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
                }

            });


            form.render();



            //监听提交
            form.on('submit(demo1)', function(data) {

                data.field.id = $("#id").val();
                AM.ajaxRequestData("post", false, AM.ip + "/express/updateExpressInfo", data.field , function(result) {
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
