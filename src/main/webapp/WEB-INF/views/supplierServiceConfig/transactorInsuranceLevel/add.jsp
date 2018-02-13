<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加险种档次</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加险种档次</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item ">
            <label class="layui-form-label">选择险种档次<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="payTheWayId" lay-verify="required" lay-filter="insuranceLevelId">
                    <option value="">请选择险种档次</option>
                </select>
            </div>
        </div>

        <div class="layui-container hide" id="gradeInfo">
            <div class="layui-row">
                <div class="layui-col-xs6" style="float: left;width: 50%">
                    <fieldset class="layui-elem-field">
                        <legend>公司缴纳</legend>
                        <div class="layui-field-box">

                            <div class="layui-form-item">
                                <label class="layui-form-label">缴纳类型<span class="font-red">*</span></label>
                                <div class="layui-input-block">
                                    <input type="radio" name="coPayType" value="1" title="比例" checked lay-filter="coPayType">
                                    <input type="radio" name="coPayType" value="0" title="金额" lay-filter="coPayType">
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <label class="layui-form-label">缴纳<span id="coPayTypeHtml">比例</span><span class="font-red">*</span></label>
                                <div class="layui-input-inline">
                                    <input type="text" name="coPayPrice" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                                <div class="layui-form-mid layui-word-aux" id="coUnit">%</div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label">计算规则</label>
                                <div class="layui-input-inline">
                                    <select id="coComputationRule">
                                        <option value="">请选择</option>
                                        <option value="0">四舍五入</option>
                                        <option value="1">升角省分（精度为0）</option>
                                        <option value="2">去尾</option>
                                        <option value="3">进一</option>
                                    </select>
                                </div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label">计算精度</label>
                                <div class="layui-input-inline">
                                    <select id="coComputationalAccuracy">
                                        <option value="">请选择</option>
                                        <option value="3">3</option>
                                        <option value="2">2</option>
                                        <option value="1">1</option>
                                        <option value="0">0</option>
                                        <option value="-1">-1</option>
                                        <option value="-2">-2</option>
                                    </select>
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <div class="layui-inline">
                                    <label class="layui-form-label">基数填写精度</label>
                                    <div class="layui-input-inline">
                                        <input type="number" id="coPrecision" autocomplete="off" class="layui-input" maxlength="10">
                                    </div>
                                </div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label"><span>基数范围</span><span class="font-red">*</span></label>
                                <div class="layui-input-inline" style="width: 150px;">
                                    <input type="number" id="coMinScope" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                                <div class="layui-form-mid">-</div>
                                <div class="layui-input-inline" style="width: 150px;">
                                    <input type="number" id="coMaxScope" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                            </div>

                        </div>
                    </fieldset>
                </div>
                <div class="layui-col-xs6" style="float: left;width: 50%">
                    <fieldset class="layui-elem-field">
                        <legend>个人缴纳</legend>
                        <div class="layui-field-box">

                            <div class="layui-form-item">
                                <label class="layui-form-label">缴纳类型<span class="font-red">*</span></label>
                                <div class="layui-input-block">
                                    <input type="radio" name="mePayType" value="1" title="比例" checked lay-filter="mePayType">
                                    <input type="radio" name="mePayType" value="0" title="金额" lay-filter="mePayType">
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <label class="layui-form-label">缴纳<span id="mePayTypeHtml">比例</span><span class="font-red">*</span></label>
                                <div class="layui-input-inline">
                                    <input type="text" name="mePayPrice" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                                <div class="layui-form-mid layui-word-aux" id="meUnit">%</div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label">计算规则</label>
                                <div class="layui-input-inline">
                                    <select id="meComputationRule">
                                        <option value="">请选择</option>
                                        <option value="0">四舍五入</option>
                                        <option value="1">升角省分（精度为0）</option>
                                        <option value="2">去尾</option>
                                        <option value="3">进一</option>
                                    </select>
                                </div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label">计算精度</label>
                                <div class="layui-input-inline">
                                    <select id="meComputationalAccuracy">
                                        <option value="">请选择</option>
                                        <option value="3">3</option>
                                        <option value="2">2</option>
                                        <option value="1">1</option>
                                        <option value="0">0</option>
                                        <option value="-1">-1</option>
                                        <option value="-2">-2</option>
                                    </select>
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <label class="layui-form-label">基数填写精度</label>
                                <div class="layui-input-inline">
                                    <input type="number" id="mePrecision" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                            </div>

                            <div class="layui-form-item ">
                                <label class="layui-form-label"><span>基数范围</span><span class="font-red">*</span></label>
                                <div class="layui-input-inline" style="width: 150px;">
                                    <input type="number" id="meMinScope" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                                <div class="layui-form-mid">-</div>
                                <div class="layui-input-inline" style="width: 150px;">
                                    <input type="number" id="meMaxScope" autocomplete="off" class="layui-input" maxlength="10">
                                </div>
                            </div>

                        </div>
                    </fieldset>
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
<%@include file="../../common/public-js.jsp" %>
<script>
    function getOnlyTransactor (payPlaceId,transactorId, selectId) {
        AM.ajaxRequestData("POST", false, AM.ip + "/insurance/getOnlyTransactor", {payPlaceId : payPlaceId,transactorId : transactorId} , function(result){
            var optgroup = "<option value=\"\">请选择险种档次</option>";
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                var option = "";
                for (var j = 0; j < obj.payTheWays.length; j++) {
                    var payTheWays = obj.payTheWays[j];
                    var object = JSON.stringify(payTheWays);
                    if (payTheWays.id == selectId) {
                        option += '<option payTheWay=\'' + object + '\' selected="selected"  value="' + payTheWays.id + '">' + payTheWays.insuranceLevelName + '</option>';
                    }
                    else {
                        option += '<option payTheWay=\'' + object + '\' value="' + payTheWays.id + '">' + payTheWays.insuranceLevelName + '</option>';
                    }
                }
                optgroup += "<optgroup label=\"" + obj.insuranceName + "\">" + option + "</optgroup>";
            }
            if (result.data.length == 0) {
                optgroup += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='payTheWayId']").html(optgroup);
        });
    }
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope, $timeout){

        $scope.insuranceLevel = null;

        layui.use(['form'], function() {
            var form = layui.form();
            getOnlyTransactor(AM.getUrlParam("payPlaceId"),AM.getUrlParam("transactorId"), 0);
            form.render();
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !AM.isDouble.test(value)) {
                        return "请输入一个大于0的小数或整数";
                    }
                },
            });
            //监听选择档次
            form.on('select(insuranceLevelId)', function(data) {
                var payTheWay = JSON.parse(data.elem[data.elem.selectedIndex].getAttribute("payTheWay"));
                AM.log(payTheWay);
                $("input[name=coPayType]").each(function () {if ($(this).val() == payTheWay.coPayType) {$(this).click();}});
                //公司缴纳
                if (payTheWay.coPayType == 0) {
                    $("#coPayTypeHtml").html("金额");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入金额");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("元");
                    $("input[name=coPayPrice]").val(payTheWay.coPayPrice);
                }
                else if (payTheWay.coPayType == 1) {
                    $("#coPayTypeHtml").html("比例");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("%");
                    $("input[name=coPayPrice]").val(payTheWay.coPayPrice);
                }
                $("#coComputationalAccuracy").attr("disabled", true);
                $("#coComputationalAccuracy option").each(function () {
                    if ($(this).val() == payTheWay.coComputationalAccuracy) {$(this).attr("selected", true);}
                });
                $("#coComputationRule").attr("disabled", true);
                $("#coComputationRule option").each(function () {
                    if ($(this).val() == payTheWay.coComputationRule) {$(this).attr("selected", true);}
                });
                $("#coPrecision").val(payTheWay.coPrecision).attr("disabled", true);
                $("#coMinScope").val(payTheWay.coMinScope).attr("disabled", true);
                $("#coMaxScope").val(payTheWay.coMaxScope).attr("disabled", true);

                //个人缴纳
                $("input[name=mePayType]").each(function () {if ($(this).val() == payTheWay.mePayType) {$(this).click();}});
                if (payTheWay.isMeTransactor == 0) {
                    $("#mePayTypeHtml").html("金额");
                    $("input[name=mePayPrice]").attr("placeholder", "请输入金额");
                    $("input[name=mePayPrice]").parent().parent().show();
                    $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                    $("#meUnit").html("元");
                    $("input[name=mePayPrice]").val(payTheWay.mePayPrice);
                }
                else {
                    $("#mePayTypeHtml").html("比例");
                    $("input[name=mePayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=mePayPrice]").parent().parent().show();
                    $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                    $("#meUnit").html("%");
                    $("input[name=mePayPrice]").val(payTheWay.mePayPrice);
                }
                $("#meComputationalAccuracy").attr("disabled", true);
                $("#meComputationalAccuracy option").each(function () {
                    if ($(this).val() == payTheWay.meComputationalAccuracy) {$(this).attr("selected", true);}
                });
                $("#meComputationRule").attr("disabled", true);
                $("#meComputationRule option").each(function () {
                    if ($(this).val() == payTheWay.meComputationRule) {$(this).attr("selected", true);}
                });
                $("#mePrecision").val(payTheWay.mePrecision).attr("disabled", true);
                $("#meMinScope").val(payTheWay.meMinScope).attr("disabled", true);
                $("#meMaxScope").val(payTheWay.meMaxScope).attr("disabled", true);
                $("#gradeInfo").show();
                form.render();
            });
            //监听公司缴纳类型
            form.on('radio(coPayType)', function(data) {
                if (data.value == 0) {
                    $("#coPayTypeHtml").html("金额");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入金额");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("元");

                    //隐藏
                    $("#coComputationRule").parent().parent().hide();
                    $("#coComputationalAccuracy").parent().parent().hide();
                    $("#coPrecision").parent().parent().hide();
                    $("#coMinScope").parent().parent().hide();
                }
                else {
                    $("#coPayTypeHtml").html("比例");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("%");

                    //显示
                    $("#coComputationRule").parent().parent().show();
                    $("#coComputationalAccuracy").parent().parent().show();
                    $("#coPrecision").parent().parent().show();
                    $("#coMinScope").parent().parent().show();
                }
            });
            //监听个人缴纳类型
            form.on('radio(mePayType)', function(data) {
                if (data.value == 0) {
                    $("#mePayTypeHtml").html("金额");
                    $("input[name=mePayPrice]").attr("placeholder", "请输入金额");
                    $("input[name=mePayPrice]").parent().parent().show();
                    $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                    $("#meUnit").html("元");

                    //隐藏
                    $("#meComputationRule").parent().parent().hide();
                    $("#meComputationalAccuracy").parent().parent().hide();
                    $("#mePrecision").parent().parent().hide();
                    $("#meMinScope").parent().parent().hide();
                }
                else {
                    $("#mePayTypeHtml").html("比例");
                    $("input[name=mePayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=mePayPrice]").parent().parent().show();
                    $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                    $("#meUnit").html("%");

                    //显示
                    $("#meComputationRule").parent().parent().show();
                    $("#meComputationalAccuracy").parent().parent().show();
                    $("#mePrecision").parent().parent().show();
                    $("#meMinScope").parent().parent().show();
                }
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.transactorId = AM.getUrlParam("transactorId");
                AM.log(data.field);

                AM.ajaxRequestData("post", false, AM.ip + "/transactorInsuranceLevel/save", data.field  , function(result) {
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
