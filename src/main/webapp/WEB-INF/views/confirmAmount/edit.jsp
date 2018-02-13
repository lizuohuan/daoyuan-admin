<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>手动认款</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>手动认款</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>


        <div class="layui-form-item">
            <label class="layui-form-label">对方银行帐号<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.bankAccount}}" disabled="disabled"   autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">交易时间<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.transactionTime | date:'yyyy-MM-dd hh:mm:ss'}}" disabled="disabled"   autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">到款金额<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.amount}}" disabled="disabled"  autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">对方单位名称<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.companyName}}" disabled="disabled"  autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">摘要<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.digest}}" disabled="disabled"  autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">备注<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" value="{{record.remark}}" disabled="disabled"  autocomplete="off" class="layui-input">
            </div>
        </div>



        <div class="layui-form-item ">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <button type="button" class="layui-btn layui-btn-normal" ng-click="addCompany()">添加公司</button>
            </div>
            <div class="layui-input-inline">
                <span style="font-size: 18px;">总金额：{{confirmAmount.amount}}</span>
            </div>
        </div>


        <div class="layui-form-item" ng-repeat="company in confirmAmount.confirmMoneyCompanyList">
            <label class="layui-form-label">公司名字</label>
            <div class="layui-input-inline">
                <div class="layui-input">{{company.companyName}}</div>
                <input type="hidden" name="companyId" value="{{company.companyId}}">
            </div>
            <label class="layui-form-label">金额<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="companyMoney" lay-verify="required|isDouble" class="layui-input" placeholder="请输入金额">
            </div>
        </div>
        <div id="addCompany">
            <div class="layui-form-item hide">
                <label class="layui-form-label">公司名字</label>
                <div class="layui-input-inline">
                    <select name="companyId" id="companyId" lay-search>
                        <option value="">请选择或搜索</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
            </div>
        </div>
    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>
    var form = null;
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.confirmAmount = JSON.parse(sessionStorage.getItem("confirmAmount"));

        $scope.record = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("post", false, AM.ip + "/confirmAmount/getConfirMoneyRecord", {id : $scope.id} , function(result) {
            $scope.record = result.data;
        });

        $scope.addCompany = function () {
            var options = $("#companyId").html();
            var html = '<div class="layui-form-item">' +
                    '       <label class="layui-form-label">公司名字</label>' +
                    '       <div class="layui-input-inline">' +
                    '           <select name="companyId" lay-search>' +
                    options +
                    '           </select>' +
                    '       </div>' +
                    '       <label class="layui-form-label">金额<span class="font-red">*</span></label>' +
                    '       <div class="layui-input-inline">' +
                    '           <input type="text" name="companyMoney" lay-verify="required|isDouble" class="layui-input" placeholder="请输入金额">' +
                    '       </div>' +
                    '       <div class="layui-input-inline">' +
                    '           <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="delGroup(this)"><i class="layui-icon">&#xe640;</i> </button>' +
                    '       </div>' +
                    '   </div>';
            $("#addCompany").append(html);
            form.render();
        }
        layui.use(['form'], function() {
            form = layui.form();
            //自定义验证规则
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !AM.isDouble.test(value)) {
                        return "请输入一个整数或者小数";
                    }
                },
            });
            queryAllCompany(0, "companyId", 0, 0);
            form.render();
            //监听提交
            form.on('submit(demo1)', function(data) {

                var dataArr = [];
                var totalMoney = 0;
                $("input[name=companyMoney]").each(function () {
                    dataArr.push({
                        companyId : $(this).parent().parent().find("[name=companyId]").val(),
                        amount : $(this).val(),
                    });
                    totalMoney += Number($(this).val());
                });
                if (dataArr.length == 0) {
                    layer.msg("请添加公司");
                    return false;
                }
                if (totalMoney != $scope.confirmAmount.amount) {
                    layer.msg("输入金额相加必须等于到款金额");
                    return false;
                }
                var arr = {
                    confirmMoneyRecordId : $scope.confirmAmount.id,
                    dataArr : JSON.stringify(dataArr),
                }
                AM.log(arr);
                AM.ajaxRequestData("post", false, AM.ip + "/confirmAmount/confirmAmount", arr , function(result){
                    //关闭iframe页面
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });
        });
    });

    function delGroup(obj) {
        $(obj).parent().parent().remove();
    }

</script>
</body>
</html>
