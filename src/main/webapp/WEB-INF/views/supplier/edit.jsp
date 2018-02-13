<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改供应商</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        table td, table th {
            padding-top: 4px !important;
            text-align: center !important;
        }
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改供应商</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

            <div class="layui-form-item " >
                <label class="layui-form-label"><span >供应商名字</span><span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="supplierName" value="{{supplier.supplierName}}"  lay-verify="required" autocomplete="off" class="layui-input" maxlength="50">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">出票顺序<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="radio" name="drawABillOrder" value="1" title="先款后票" checked>
                    <input type="radio" name="drawABillOrder" value="0" title="先票后款">
                </div>
            </div>

        <fieldset class="layui-elem-field">
            <legend>成本价&nbsp;</legend>
            </legend>
            <div class="layui-field-box layui-form">
                <div class="layui-form-item">
                    <label class="layui-form-label">成本价月序开始时间</label>
                    <div class="layui-input-inline">
                        <input type="text" id="serviceFeeStartTime" name="serviceFeeStartTime" readonly lay-verify=""
                               placeholder="请输入成本价月序开始时间" autocomplete="off" class="layui-input" maxlength="20">
                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="serviceFeeCycleDiv">
                    <label class="layui-form-label">成本价月序周期(月)</label>
                    <div class="layui-input-inline">
                        <input type="number" value="{{supplier.serviceFeeCycle}}" name="serviceFeeCycle"
                               onblur="serviceFeeCycleBlur(this)" lay-verify="required" placeholder="请输入月序周期"
                               autocomplete="off" class="layui-input"
                               onkeydown=if(event.keyCode==13)event.keyCode=9
                               onkeyup="value=value.replace(/[^0-9- ]/g,'');">
                    </div>
                </div>

                <div class="layui-form-item layui-hide " id="showServiceFeeCycleDiv">
                    <label class="layui-form-label">未来成本价账单周期</label>
                    <div class="layui-input-inline" style="width: 600px">
                        <table class="layui-table" lay-size="sm">
                            <thead>
                            <tr>
                                <th>账单月</th>
                                <th>所包含服务月</th>
                            </tr>
                            </thead>
                            <tbody id="dataBody">


                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">成本价配置<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <select name="serviceFeeConfigId" id="serviceFeeConfigId" lay-filter="changeServiceFeeConfig"
                                lay-verify="required" lay-search>
                            <option value="">请选择成本价配置</option>
                        </select>
                    </div>
                    <div class="layui-input-inline" style="display: none;" id="addConfigBtn">
                        <button type="button" class="layui-btn layui-btn-normal" onclick="addConfig(this)">新增配置</button>
                    </div>
                    <div class="layui-input-inline hide" id="addServiceConfig">
                        <button type="button" class="layui-btn layui-btn-normal" onclick="addServiceConfig(0, '', 0)">新增配置
                        </button>
                    </div>

                </div>
                <div class="layui-form-item layui-hide" id="serviceFeeDiv">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-inline">
                        <input type="text" name="serviceFee" id="serviceFee" class="layui-input"
                               lay-verify="required|isDouble"
                               placeholder="输入服务费收费"/>
                    </div>
                    <div class="layui-form-mid layui-word-aux" id="assist"></div>
                </div>


                <div class="layui-hide" id="serviceFeePlaceDiv">
                    <div class="layui-form-item">
                        <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select id="serviceFeePlace" class="serviceConfigFeePlace" name="serviceConfigFeePlace" lay-search>
                                <option value="">请选择</option>
                            </select>
                        </div>
                        <label class="layui-form-label">服务费<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input type="number" class="layui-input serviceConfigFeePlacePrice" id="serviceConfigFeePlacePrice" name="serviceConfigFeePlacePrice" lay-verify="isDouble"
                                   placeholder="请输入服务费"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux "> 元/人*服务月</div>
                    </div>
                </div>


                <div class="layui-hide" id="extentDiv">
                    <div class="layui-form-item">
                        <label class="layui-form-label">人数低于</label>
                        <div class="layui-input-inline">
                            <input type="number" id="firstExtentNum" class="layui-input extentNum" lay-verify="isNumber"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux"> 人</div>
                        <label class="layui-form-label">服务费：</label>
                        <div class="layui-input-inline">
                            <input type="number" id="firstExtentPrice" class="layui-input extentPrice"
                                   lay-verify="isDouble"
                                   placeholder="请输入服务费"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux"> 元</div>
                    </div>
                </div>


                <div class="layui-hide" id="serviceFeeForType">

                </div>


                <div class="layui-form-item layui-hide" id="serviceFeeSBDIV">
                    <label class="layui-form-label">社保服务费<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="serviceFeeSB" class="layui-input" lay-verify="isDouble"
                               placeholder="输入社保服务费"/>
                    </div>
                </div>


                <div class="layui-form-item layui-hide" id="serviceFeeGJJDIV">
                    <label class="layui-form-label">公积金服务费<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="serviceFeeGJJ" class="layui-input" lay-verify="isDouble"
                               placeholder="输入公积金服务费"/>
                    </div>
                </div>


                <div class="layui-form-item layui-hide" id="serviceFeeGZDIV">
                    <label class="layui-form-label">工资服务费<span class="font-red">*</span></label>
                    <div class="layui-input-inline">
                        <input type="text" name="serviceFeeGZ" class="layui-input" lay-verify="isDouble"
                               placeholder="输入工资服务费"/>
                    </div>
                </div>


                <%--<div class="layui-form-item">--%>
                    <%--<label class="layui-form-label">服务费区间<span class="font-red"></span></label>--%>
                    <%--<div class="layui-input-inline" style="width: 120px;">--%>
                        <%--<input type="text" value="{{supplier.serviceFeeMin}}" name="serviceFeeMin" class="layui-input"--%>
                               <%--lay-verify="isDouble"--%>
                               <%--placeholder="服务费最低收费"/>--%>
                    <%--</div>--%>
                    <%--<div class="layui-form-mid">-</div>--%>
                    <%--<div class="layui-input-inline" style="width: 120px;">--%>
                        <%--<input type="text" value="{{supplier.serviceFeeMax}}" name="serviceFeeMax" class="layui-input"--%>
                               <%--lay-verify="isDouble"--%>
                               <%--placeholder="服务费最高收费"/>--%>
                    <%--</div>--%>
                    <%--<div class="layui-form-mid layui-word-aux">元</div>--%>
                <%--</div>--%>
                <div class="layui-form-item">
                    <label class="layui-form-label">纳入百分比</label>
                    <div class="layui-input-inline">
                        <input type="text" value="{{supplier.percent}}" name="percent" id="percent" class="layui-input"
                               lay-verify="isDouble"
                               placeholder="请输入"/>
                    </div>
                    <div class="layui-form-mid layui-word-aux"> %</div>
                    <label class="layui-form-label">服务费纳入百分比计算</label>
                    <div class="layui-input-inline">
                        <input type="radio" name="isPercent" value="0" title="否">
                        <input type="radio" name="isPercent" value="1" title="是">
                    </div>
                </div>
            </div>
        </fieldset>

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
    var form = null;
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.supplier = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/supplier/info", {id : $scope.id} , function(result) {
            $scope.supplier = result.data;
        });
        layui.use(['form', 'layedit'], function() {
            form = layui.form();

            $("input[name=drawABillOrder]").each(function () {
                if ($(this).val() == $scope.supplier.drawABillOrder) {
                    $(this).click();
                }
            });

            $("input[name='isPercent']").each(function(){
                if($(this).val() == $scope.supplier.isPercent){
                    $(this).prop("checked",true);
                }
            })

            $("#serviceFeeStartTime").val(new Date($scope.supplier.serviceFeeStartTime).format("yyyy-MM-dd"));
            // 初始化 服务费配置
            buildServiceFeeOption($scope.supplier.serviceFeeConfigId, "serviceFeeConfigId", "post", 0);
            // 服务费月序周期
            serviceFeeCycleBlur(null, $scope.supplier.serviceFeeCycle)
            // 初始化缴金地
            queryAllPayPlace(0,"serviceFeePlace","post",0);
            $("#serviceFeeCycleDiv").show("slow");
            var serviceFeeId = $scope.supplier.serviceFeeConfigId;
            if (serviceFeeId == 1 ||serviceFeeId == 5 || serviceFeeId == 6 || serviceFeeId == 8) {

                if( serviceFeeId == 8){
                    $("#assist").html(" %");
                }else if(serviceFeeId == 1){
                    $("#assist").html(" 元")
                } else if(serviceFeeId == 5) {
                    $("#assist").html("元/次");
                } else if(serviceFeeId == 6) {
                    $("#assist").html("元");
                }else{
                    $("#assist").html("");
                }
                $("#serviceFeeDiv").show("fast");
                $("#serviceFee").attr("lay-verify", "required");

                $("#extentDiv").hide("fast");
                $(".extentNum").removeAttr("lay-verify");
                $(".extentPrice").removeAttr("lay-verify");

                $("#addConfigBtn").hide("fast");


                $("#serviceFeeForType").hide("fast");
                $("#serviceFeeSBDIV").hide("fast");
                $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                $("#serviceFeeGJJDIV").hide("fast");
                $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                $("#serviceFeeGZDIV").hide("fast");
                $("input[name='serviceFeeGZ']").removeAttr("lay-verify");

                // 初始化参数
                if (null != $scope.supplier.feeList) {
                    $("#serviceFee").val($scope.supplier.feeList[0].price);
                }

            } else if (serviceFeeId == 3) {

                var serviceFeeList = $scope.supplier.serviceFeeList;
                var businessObj = new Array();
                var businessArray = [3,4,5];

                var resultArr = [];
                resultArr[resultArr.length] = "3,4,5";
                for (var  i = 0 ; i < businessArray.length ; i++){
                    for (var  j = i + 1; j < businessArray.length; j++){
                        resultArr[resultArr.length] = businessArray[i]+","+businessArray[j];
                    }
                }
                for(var  i = 0 ; i < businessArray.length ; i++){
                    resultArr[resultArr.length] = businessArray[i]+"";
                }
                // 生成文本框
                var html = "";
                for (var i = 0; i < resultArr.length; i++){
                    var msg = "";
                    var names =  resultArr[i].split(",");
                    for(var j = 0 ; j < names.length; j++){
                        msg += getBusiness(names[j]) +"、";
                    }
                    msg = msg.substring(0,msg.length - 1);
                    var v = 0.0;
                    for (var  j = 0 ; j < serviceFeeList.length; j++){
                        if(serviceFeeList[j].businessIds == resultArr[i]){
                            v = serviceFeeList[j].price;
                            break;
                        }
                    }


                    html += '<div class="layui-form-item">' +
                            '<label class="layui-form-label">'+msg+'</label>' +
                            '<div class="layui-input-inline">' +
                            '<input type="number" class="layui-input service_fee" value="'+v+'" ids="'+resultArr[i]+'" lay-verify="isDouble" placeholder="请输入服务费"/>' +
                            '</div>' +
                            '</div>';
                }
                $("#serviceFeeForType").html(html);
                $("#serviceFeeForType").show("fast");


                $("#serviceFeeDiv").hide("fast");
                $("#serviceFee").removeAttr("lay-verify");

                $("#extentDiv").hide("fast");
                $(".extentNum").removeAttr("lay-verify");
                $(".extentPrice").removeAttr("lay-verify");

                $("#addConfigBtn").hide("fast");


                $("#serviceFeeSBDIV").hide("fast");
                $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                $("#serviceFeeGJJDIV").hide("fast");
                $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                $("#serviceFeeGZDIV").hide("fast");
                $("input[name='serviceFeeGZ']").removeAttr("lay-verify");


            } else if(serviceFeeId == 4){

                // 初始化缴金地
                queryAllPayPlace($scope.supplier.servicePayPlaceList[0].cityId, "serviceFeePlace","post",0);
                $("#serviceConfigFeePlacePrice").val($scope.supplier.servicePayPlaceList[0].price);
                if ($scope.supplier.servicePayPlaceList.length > 0) {
                    // 服务区
                    $("#serviceFeePlaceDiv").show("fast");
                    $("#addServiceConfig").show("fast");
                    $(".serviceConfigFeePlace").attr("lay-verify", "required");
                    $(".serviceConfigFeePlacePrice").attr("lay-verify", "required");
                }
                //服务费区间
                for (var i = 1; i < $scope.supplier.servicePayPlaceList.length; i++) {
                    var obj = $scope.supplier.servicePayPlaceList[i];
                    addServiceConfig(obj.cityId, obj.price, "addServiceConfig_" + obj.cityId);
                }


                $("#serviceFeeDiv").hide("fast");
                $("#serviceFee").removeAttr("lay-verify");

                $("#extentDiv").hide("fast");
                $(".extentNum").removeAttr("lay-verify");
                $(".extentPrice").removeAttr("lay-verify");

                $("#addConfigBtn").hide("fast");


                $("#serviceFeeSBDIV").hide("fast");
                $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                $("#serviceFeeGJJDIV").hide("fast");
                $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                $("#serviceFeeGZDIV").hide("fast");
                $("input[name='serviceFeeGZ']").removeAttr("lay-verify");

            } else {
                $("#addConfigBtn").show("fast");
                $("#serviceFeeDiv").hide("fast");
                $("#serviceFee").removeAttr("lay-verify");
                $("#serviceFeeForType").hide("fast");

                $("#extentDiv").show("fast");
                $(".extentNum").attr("lay-verify", "required");
                $(".extentPrice").attr("lay-verify", "required");


                $("#serviceFeeSBDIV").hide("fast");
                $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                $("#serviceFeeGJJDIV").hide("fast");
                $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                $("#serviceFeeGZDIV").hide("fast");
                $("input[name='serviceFeeGZ']").removeAttr("lay-verify");

                // 初始化参数
                if (null != $scope.supplier.feeList) {
                    var html = "";
                    for (var i = 0; i < $scope.supplier.feeList.length; i++) {
                        if (i == 0) {
                            $("#firstExtentNum").val($scope.supplier.feeList[i].extent);
                            $("#firstExtentPrice").val($scope.supplier.feeList[i].price);
                        } else {
                            html +=
                                    '<div class="layui-form-item">' +
                                    '<label class="layui-form-label">人数低于</label>' +
                                    '<div class="layui-input-inline">' +
                                    '<input type="text" value="' + $scope.supplier.feeList[i].extent + '" class="layui-input extentNum" lay-verify="required|isNumber"' +
                                    'placeholder="请输入"/>' +
                                    '</div>' +
                                    '<div class="layui-input-inline">' +
                                    '<input type="text" value="' + $scope.supplier.feeList[i].price + '" class="layui-input extentPrice" lay-verify="required|isDouble"' +
                                    'placeholder="请输入服务费"/>' +
                                    '</div>' +
                                    '<div class="layui-input-inline" >' +
                                    '<button type="button" class="layui-btn layui-btn-danger" onclick="delConfig(this)">删除配置</button>' +
                                    '</div>' +
                                    '</div>';
                        }
                    }
                    $("#extentDiv").append(html);

                }


            }


            form.render();


            // 监听服务费配置选择
            form.on('select(changeServiceFeeConfig)', function (data) {

                if( data.value == 8){
                    $("#assist").html(" %");
                }else if(data.value == 1){
                    $("#assist").html(" 元")
                } else if(data.value == 5) {
                    $("#assist").html("元/次");
                } else if(data.value == 6) {
                    $("#assist").html("元");
                }else{
                    $("#assist").html("");
                }

                if (data.value == 1 || data.value == 5 || data.value == 6 || data.value == 8) {
                    $("#serviceFeeDiv").show("slow");
                    $("#serviceFee").attr("lay-verify", "required");

                    $("#extentDiv").hide("slow");
                    $(".extentNum").removeAttr("lay-verify");
                    $(".extentPrice").removeAttr("lay-verify");

                    $("#addConfigBtn").hide("slow");

                    $("#serviceFeeSBDIV").hide("fast");
                    $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                    $("#serviceFeeGJJDIV").hide("fast");
                    $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                    $("#serviceFeeGZDIV").hide("fast");
                    $("input[name='serviceFeeGZ']").removeAttr("lay-verify");
                    $("#serviceFeeForType").hide("fast");
                    $("#serviceFeePlaceDiv").hide("fast");
                    $("#addServiceConfig").hide("fast");
                    $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                    $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");

                } else if (data.value == 3) {
                    // 按服务类别收费 如社保、公积金、工资等
                    // 获取已经选择了的(社保、公积金、工资)业务
                    //如果没有选择以上 业务， 则不显示其他组件
                    // 3、4、5
                    var businessObj = new Array();
                    var businessArray = [3,4,5];

                    var resultArr = [];
                    resultArr[resultArr.length] = "3,4,5";
                    for (var  i = 0 ; i < businessArray.length ; i++){
                        for (var  j = i + 1; j < businessArray.length; j++){
                            resultArr[resultArr.length] = businessArray[i]+","+businessArray[j];
                        }
                    }
                    for(var  i = 0 ; i < businessArray.length ; i++){
                        resultArr[resultArr.length] = businessArray[i]+"";
                    }
                    // 生成文本框
                    var html = "";
                    for (var i = 0; i < resultArr.length; i++){
                        var msg = "";
                        var names =  resultArr[i].split(",");
                        for(var j = 0 ; j < names.length; j++){
                            msg += getBusiness(names[j]) +"、";
                        }
                        msg = msg.substring(0,msg.length - 1);
                        html += '<div class="layui-form-item">' +
                                '<label class="layui-form-label">'+msg+'</label>' +
                                '<div class="layui-input-inline">' +
                                '<input type="number" class="layui-input service_fee" value="0" ids="'+resultArr[i]+'" lay-verify="isDouble" placeholder="请输入服务费"/>' +
                                '</div>' +
                                '</div>';
                    }
                    $("#serviceFeeForType").html(html);
                    $("#serviceFeeForType").show("fast");



                    $("#serviceFeeDiv").hide("fast");
                    $("#serviceFee").removeAttr("lay-verify");

                    $("#extentDiv").hide("fast");
                    $(".extentNum").removeAttr("lay-verify");
                    $(".extentPrice").removeAttr("lay-verify");

                    $("#addConfigBtn").hide("fast");


                    $("#serviceFeeSBDIV").hide("fast");
                    $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                    $("#serviceFeeGJJDIV").hide("fast");
                    $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                    $("#serviceFeeGZDIV").hide("fast");
                    $("input[name='serviceFeeGZ']").removeAttr("lay-verify");
                    $("#serviceFeePlaceDiv").hide("fast");
                    $("#addServiceConfig").hide("fast");
                    $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                    $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");

                } else if( data.value == 4){

                    // 服务区
                    $("#serviceFeePlaceDiv").show("fast");
                    $("#addServiceConfig").show("fast");
                    $(".serviceConfigFeePlace").attr("lay-verify", "required");
                    $(".serviceConfigFeePlacePrice").attr("lay-verify", "required");

                    $("#serviceFeeDiv").hide("fast");
                    $("#serviceFee").removeAttr("lay-verify");
                    $("#extentDiv").hide("fast");
                    $(".extentNum").removeAttr("lay-verify");
                    $(".extentPrice").removeAttr("lay-verify");
                    $("#addConfigBtn").hide("fast");
                    $("#serviceFeeForType").hide("fast");

                }  else {
                    $("#addConfigBtn").show("slow");
                    $("#serviceFeeDiv").hide("slow");
                    $("#serviceFee").removeAttr("lay-verify");
                    $("#serviceFeeForType").hide("fast");

                    $("#extentDiv").show("slow");
                    $(".extentNum").attr("lay-verify", "required");
                    $(".extentPrice").attr("lay-verify", "required");

                    $("#serviceFeeSBDIV").hide("fast");
                    $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                    $("#serviceFeeGJJDIV").hide("fast");
                    $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                    $("#serviceFeeGZDIV").hide("fast");
                    $("input[name='serviceFeeGZ']").removeAttr("lay-verify");
                    $("#serviceFeePlaceDiv").hide("fast");
                    $("#addServiceConfig").hide("fast");
                    $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                    $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");
                }

            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                //  封装服务费配置
                var price = null;
                var extent = null;
                var configId = $("#serviceFeeConfigId").val();
                var extentArr = new Array();
                if (configId == 1 ||  configId == 5 || configId == 6 || configId == 8){
                    var extentObj = {
                        price : $("#serviceFee").val(),
                        extent : 0
                    }
                    extentArr.push(JSON.stringify(extentObj));
                }else if (configId == 3){
                    // 按服务类别收费
                    $(".service_fee").each(function(){
                        var price = $(this).val();
                        if('' == price){
                            price = 0.0;
                        }
                        var businessIds = $(this).attr("ids");
                        var extentObj = {
                            price : price,
                            businessIds : businessIds
                        }
                        extentArr.push(JSON.stringify(extentObj));
                    });
                }else if(configId == 4){
                    var serviceFeeArr = [];
                    $("#serviceFeePlaceDiv").find(".layui-form-item").each(function () {
                        serviceFeeArr.push({
                            cityId : $(this).find("select[name=serviceConfigFeePlace]").val(),
                            price : $(this).find("input[name=serviceConfigFeePlacePrice]").val(),
                        });
                    });
                    data.field.serviceFeeArr = JSON.stringify(serviceFeeArr);
                } else{
                    var extentNumArr = [];
                    var extentPriceArr = [];
                    $('.extentNum').each(function () {
                        extentNumArr[extentNumArr.length] = $(this).val();
                    });
                    $('.extentPrice').each(function () {
                        extentPriceArr[extentPriceArr.length] = $(this).val();
                    });
                    if(extentNumArr.length != extentPriceArr.length){
                        layer.msg('请完善服务费配置', {icon: 2, anim: 6});
                        return false;
                    }
                    for(var i = 0; i <extentNumArr.length ; i++ ){
                        var temp = {
                            price : extentPriceArr[i],
                            extent : extentNumArr[i]
                        }
                        extentArr.push(JSON.stringify(temp));
                    }
                }
                data.field.extentArr = extentArr.toString();
                data.field.serviceFeeStartTime = new Date($("#serviceFeeStartTime").val());
                data.field.id = $scope.id;
                AM.ajaxRequestData("post", false, AM.ip + "/supplier/update", data.field , function(result) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });
        });
    });


    // 设置服务费月序周期 失去焦点事件
    function serviceFeeCycleBlur(obj){

        var date = $("#serviceFeeStartTime").val(); //服务费开始时间
        if(null != date && date != ''){
            var cycle = $(obj).val(); // 周期月
            if(null == cycle || cycle == ''){
                $("#showServiceFeeCycleDiv").hide("slow");
                return;
            }
            var startTime = new Date(date);
            var arr = {
                cycle : cycle,
                time : startTime.getTime()
            };
            AM.ajaxRequestData("post", false, AM.ip + "/company/countTime", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    var html = "";
                    for (var i = 0; i < result.data.length; i++) {
                        var dateStr = result.data[i].split(",");
                        html += "<tr><td>"+dateStr[0]+"</td><td>"+dateStr[1]+"</td></tr>";
                    }
                    $("#dataBody").html(html);
                    $("#showServiceFeeCycleDiv").show("slow");
                }
            });
        }else{
            $("#showServiceFeeCycleDiv").hide("slow");
        }

    }

    // 点击新增配置
    function addConfig(obj) {
        var html =
                '<div class="layui-form-item">'+
                '<label class="layui-form-label">人数低于</label>'+
                '<div class="layui-input-inline">'+
                '<input type="text" class="layui-input extentNum" lay-verify="required|isNumber"'+
                'placeholder="请输入"/>'+
                '</div>'+
                '<div class="layui-form-mid layui-word-aux"> 人</div>' +
                '<label class="layui-form-label" >服务费：</label>'+
                '<div class="layui-input-inline">'+
                '<input type="text" class="layui-input extentPrice" lay-verify="required|isDouble"'+
                'placeholder="请输入服务费"/>'+
                '</div>'+
                '<div class="layui-form-mid layui-word-aux"> 元</div>' +
                '<div class="layui-input-inline" >'+
                '<button type="button" class="layui-btn layui-btn-danger" onclick="delConfig(this)">删除配置</button>'+
                '</div>'+
                '</div>';
        $("#extentDiv").append(html);
    }

    function delConfig(obj){
        $(obj).parent().parent().remove();
    }


    /**新增服务区配置**/
    function addServiceConfig(cityId, price, id) {
        var serviceConfigFeePlace = $("#serviceFeePlace").html();
        var selectedId = "";
        if (id != 0) {
            selectedId = "id='" + id + "'";
        }
        var html =
                '<div class="layui-form-item">' +
                '   <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>' +
                '   <div class="layui-input-inline">' +
                '       <select ' + selectedId + ' class="serviceConfigFeePlace" lay-verify="required" name="serviceConfigFeePlace">' +
                serviceConfigFeePlace +
                '       </select>' +
                '   </div>' +
                '   <label class="layui-form-label" >服务费<span class="font-red">*</span></label>' +
                '   <div class="layui-input-inline">' +
                '       <input type="text" value="' + price + '" class="layui-input extentPrice" name="serviceConfigFeePlacePrice" lay-verify="required|isDouble" placeholder="请输入服务费"/>' +
                '   </div>' +
                '<div class="layui-form-mid layui-word-aux placeAux"> 元/人*服务月</div>' +
                '   <div class="layui-input-inline" >' +
                '       <button type="button" class="layui-btn layui-btn-danger" onclick="$(this).parent().parent().remove()">删除配置</button>' +
                '   </div>' +
                '</div>';
        $("#serviceFeePlaceDiv").append(html);
        $("#" + id + " option").each(function () {
            if ($(this).val() == cityId) {
                $(this).attr("selected", true);
            }
        });
        form.render();
    }



</script>
</body>
</html>
