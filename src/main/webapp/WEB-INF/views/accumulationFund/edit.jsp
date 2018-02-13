<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改公积金配置</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改公积金配置</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="payPlaceId" name="payPlaceId" lay-verify="required" lay-search lay-filter="payPlaceFilter">
                    <option value="">请选择或搜索缴金地</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择经办机构<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="organizationId" id="organizationId" lay-search>
                    <option value="">选择或搜索</option>
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux">公积金中心</div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">公司名字<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="transactorName" value="{{companyPayPlace.transactorName}}" lay-verify="required" placeholder="请输入公司名字" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">缴纳比例<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="mePayPrice" value="{{companyPayPlace.mePayPrice}}" lay-verify="required|isDouble" placeholder="请输入缴纳比例" autocomplete="off" class="layui-input" maxlength="50">
            </div>
            <div class="layui-form-mid layui-word-aux">%</div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">单位编码</label>
            <div class="layui-input-inline">
                <input type="text" name="coding" value="{{companyPayPlace.coding}}" placeholder="请输入单位编码" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <input type="hidden" name="type" value="1">
        <input type="hidden" name="companyId" value="{{companyPayPlace.companyId}}">

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

        $scope.companyPayPlace = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/companyPayPlace/info", {id : $scope.id} , function(result) {
            $scope.companyPayPlace = result.data;
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            getPayPlaceByType($scope.companyPayPlace.payPlaceId, "payPlaceId", "post", 0, 1);
            getOrganizationByPayPlace($scope.companyPayPlace.organizationId, "organizationId", "post", 0, $scope.companyPayPlace.payPlaceId);

            form.render();
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !AM.isDouble.test(value)) {
                        return "请输入一个小数";
                    }
                },
            });

            //监听缴金地
            form.on('select(payPlaceFilter)', function (data) {
                getOrganizationByPayPlace(0, "organizationId", "post", 0, data.value);
                form.render();
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = $scope.id;
                AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/update", data.field , function(result) {
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
