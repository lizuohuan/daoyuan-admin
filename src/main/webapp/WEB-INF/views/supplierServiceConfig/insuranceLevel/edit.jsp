<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改档次</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend><span id="insuranceName"></span>--修改档次</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label"><span>选择档次</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="insuranceLevelId" lay-verify="required" class="layui-input">
                    <option value="">请选择或搜索档次</option>
                </select>
            </div>
        </div>

        <div style="float: left;width: 50%">
            <fieldset class="layui-elem-field">
                <legend>公司缴纳</legend>
                <div class="layui-field-box">
                    <div class="layui-form-item">
                        <label class="layui-form-label">缴纳类型<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="coPayType" value="1" title="比例" checked lay-filter="coPayType">
                            <input type="radio" name="coPayType" value="0" title="金额" lay-filter="coPayType">
                            <input type="radio" name="coPayType" value="2" title="跟随办理方" lay-filter="coPayType">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">缴纳<span id="coPayTypeHtml">比例</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{insuranceLevel.coPayPrice}}" type="text" name="coPayPrice" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="coUnit">%</div>
                    </div>

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>计算规则</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="coComputationRule" lay-verify="required" lay-filter="coComputationRule">
                                <option value="">请选择</option>
                                <option value="0">四舍五入</option>
                                <option value="1">升角省分（精度为0）</option>
                                <option value="2">去尾</option>
                                <option value="3">进一</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>计算精度</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="coComputationalAccuracy" lay-verify="required" lay-filter="coComputationalAccuracy">
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

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>基数填写精度</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="coPrecision" lay-filter="coPrecision" lay-verify="required">
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

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>基数下上限</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline" style="width: 150px;">
                            <input value="{{insuranceLevel.coMinScope}}" type="number" name="coMinScope" lay-verify="required|isDouble" placeholder="基数下限" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px;">
                            <input value="{{insuranceLevel.coMaxScope}}" type="number" name="coMaxScope" lay-verify="required|isDouble" placeholder="基数上限" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">年度调基是否补差<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="isCMakeASupplementaryPayment" value="0" title="否" checked>
                            <input type="radio" name="isCMakeASupplementaryPayment" value="1" title="是">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">是否离职补差<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="isCDimissionSupplementaryPay" value="0" title="否" checked>
                            <input type="radio" name="isCDimissionSupplementaryPay" value="1" title="是">
                        </div>
                    </div>

                </div>
            </fieldset>
        </div>

        <div style="float: left;width: 50%">
            <fieldset class="layui-elem-field">
                <legend>个人缴纳</legend>
                <div class="layui-field-box">

                    <div class="layui-form-item">
                        <label class="layui-form-label">缴纳类型<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="mePayType" value="1" title="比例" checked lay-filter="mePayType">
                            <input type="radio" name="mePayType" value="0" title="金额" lay-filter="mePayType">
                            <input type="radio" name="mePayType" value="2" title="跟随办理方" lay-filter="mePayType">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">缴纳<span id="mePayTypeHtml">比例</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{insuranceLevel.mePayPrice}}" type="text" name="mePayPrice" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="meUnit">%</div>
                    </div>

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>计算规则</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="meComputationRule" lay-verify="required" lay-filter="meComputationRule">
                                <option value="">请选择</option>
                                <option value="0">四舍五入</option>
                                <option value="1">升角省分（精度为0）</option>
                                <option value="2">去尾</option>
                                <option value="3">进一</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>计算精度</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="meComputationalAccuracy" lay-verify="required">
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

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>基数填写精度</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select name="mePrecision" lay-filter="mePrecision" lay-verify="required">
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

                    <div class="layui-form-item ">
                        <label class="layui-form-label"><span>基数下上限</span><span class="font-red">*</span></label>
                        <div class="layui-input-inline" style="width: 150px;">
                            <input value="{{insuranceLevel.meMinScope}}" type="number" name="meMinScope" lay-verify="required|isDouble" placeholder="基数下限" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                        <div class="layui-form-mid">-</div>
                        <div class="layui-input-inline" style="width: 150px;">
                            <input value="{{insuranceLevel.meMaxScope}}" type="number" name="meMaxScope" lay-verify="required|isDouble" placeholder="基数上限" autocomplete="off" class="layui-input" maxlength="10">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">年度调基是否补差<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="isMMakeASupplementaryPayment" value="0" title="否" checked>
                            <input type="radio" name="isMMakeASupplementaryPayment" value="1" title="是">
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">是否离职补差<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="isMDimissionSupplementaryPay" value="0" title="否" checked>
                            <input type="radio" name="isMDimissionSupplementaryPay" value="1" title="是">
                        </div>
                    </div>

                </div>
            </fieldset>
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

    var insuranceId = null;
    var insuranceLevelId = null;
    /**获取档次**/
    function getInsuranceLevel(selectId, payPlaceId) {
        AM.ajaxRequestData("post", false, AM.ip + "/insuranceLevel/getInsuranceLevel", {
            payPlaceId : payPlaceId,
            insuranceId:insuranceId,
            insuranceLevelId:insuranceLevelId,
            page : 0, pageSize : 1000} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索档次</option>';
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].levelName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].levelName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name=insuranceLevelId]").html(html);
            }
        });
    }
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){
        $("#insuranceName").html(sessionStorage.getItem("insuranceName"));
        $scope.insuranceLevel = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/payTheWay/info", {id : $scope.id} , function(result) {
            $scope.insuranceLevel = result.data;
            insuranceId = $scope.insuranceLevel.insuranceId;
            insuranceLevelId = $scope.insuranceLevel.insuranceLevelId;
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            getInsuranceLevel($scope.insuranceLevel.insuranceLevelId, AM.getUrlParam("payPlaceId"));
            $("input[name=coPayType]").each(function () {
                if ($(this).val() == $scope.insuranceLevel.coPayType) {
                    $(this).click();
                }
            });
            if ($scope.insuranceLevel.coPayType == 0) {
                $("#coPayTypeHtml").html("金额");
                $("input[name=coPayPrice]").attr("placeholder", "请输入金额");
                $("input[name=coPayPrice]").parent().parent().show();
                $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                $("#coUnit").html("元");

                $("select[name=coComputationRule]").parent().parent().hide();
                $("select[name=coComputationRule]").removeAttr("lay-verify");
                $("select[name=coComputationalAccuracy]").parent().parent().hide();
                $("select[name=coComputationalAccuracy]").removeAttr("lay-verify");
                $("select[name=coPrecision]").parent().parent().hide();
                $("select[name=coPrecision]").removeAttr("lay-verify");
                $("input[name=coMinScope]").parent().parent().hide();
                $("input[name=coMinScope]").removeAttr("lay-verify");
                $("input[name=coMaxScope]").removeAttr("lay-verify");
            }
            else if ($scope.insuranceLevel.coPayType == 1) {
                $("#coPayTypeHtml").html("比例");
                $("input[name=coPayPrice]").attr("placeholder", "请输入比例");
                $("#coUnit").html("%");
            }
            else {
                $("input[name=coPayPrice]").parent().parent().hide();
                $("input[name=coPayPrice]").removeAttr("lay-verify");
            }
            $("select[name='coComputationalAccuracy'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.coComputationalAccuracy) {
                    $(this).attr("selected", true);
                }
            });
            $("select[name='coPrecision'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.coPrecision) {
                    $(this).attr("selected", true);
                }
                if ($scope.insuranceLevel.coPayType == 1) {
                    if ($scope.insuranceLevel.coPrecision == 3) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|three");
                        $("input[name=coMaxScope]").attr("lay-verify", "required|three");
                    }
                    else if ($scope.insuranceLevel.coPrecision == 2) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|two");
                        $("input[name=coMaxScope]").attr("lay-verify", "required|two");
                    }
                    else if ($scope.insuranceLevel.coPrecision == 1) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|one");
                        $("input[name=coMaxScope]").attr("lay-verify", "required|one");
                    }
                    else if ($scope.insuranceLevel.coPrecision == 0) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                    }
                    else if ($scope.insuranceLevel.coPrecision == -1) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=coMinScope]").attr("step", 10);
                        $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=coMaxScope]").attr("step", 10);
                    }
                    else if ($scope.insuranceLevel.coPrecision == -2) {
                        $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=coMinScope]").attr("step", 100);
                        $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=coMaxScope]").attr("step", 100);
                    }
                }

            });
            $("select[name='coComputationRule'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.coComputationRule) {
                    $(this).attr("selected", true);
                    if ($(this).val() == 1) {
                        $("select[name=coComputationalAccuracy]").attr("disabled", true);
                    }
                }
            });
            $("input[name=mePayType]").each(function () {
                if ($(this).val() == $scope.insuranceLevel.mePayType) {
                    $(this).click();
                }
            });
            if ($scope.insuranceLevel.mePayType == 0) {
                $("#mePayTypeHtml").html("金额");
                $("input[name=mePayPrice]").attr("placeholder", "请输入金额");
                $("input[name=mePayPrice]").parent().parent().show();
                $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                $("#meUnit").html("元");

                $("select[name=meComputationRule]").parent().parent().hide();
                $("select[name=meComputationRule]").removeAttr("lay-verify");
                $("select[name=meComputationalAccuracy]").parent().parent().hide();
                $("select[name=meComputationalAccuracy]").removeAttr("lay-verify");
                $("select[name=mePrecision]").parent().parent().hide();
                $("select[name=mePrecision]").removeAttr("lay-verify");
                $("input[name=meMinScope]").parent().parent().hide();
                $("input[name=meMinScope]").removeAttr("lay-verify");
                $("input[name=meMaxScope]").removeAttr("lay-verify");
            }
            else if ($scope.insuranceLevel.mePayType == 1) {
                $("#mePayTypeHtml").html("比例");
                $("input[name=mePayPrice]").attr("placeholder", "请输入比例");
                $("#meUnit").html("%");
            }
            else {
                $("input[name=mePayPrice]").parent().parent().hide();
                $("input[name=mePayPrice]").removeAttr("lay-verify");
            }
            $("select[name='meComputationalAccuracy'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.meComputationalAccuracy) {
                    $(this).attr("selected", true);
                }
            });
            $("select[name='mePrecision'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.mePrecision) {
                    $(this).attr("selected", true);
                }
                if ($scope.insuranceLevel.mePayType == 1) {
                    if ($scope.insuranceLevel.mePrecision == 3) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|three");
                        $("input[name=meMaxScope]").attr("lay-verify", "required|three");
                    }
                    else if ($scope.insuranceLevel.mePrecision == 2) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|two");
                        $("input[name=meMaxScope]").attr("lay-verify", "required|two");
                    }
                    else if ($scope.insuranceLevel.mePrecision == 1) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|one");
                        $("input[name=meMaxScope]").attr("lay-verify", "required|one");
                    }
                    else if ($scope.insuranceLevel.mePrecision == 0) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    }
                    else if ($scope.insuranceLevel.mePrecision == -1) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=meMinScope]").attr("step", 10);
                        $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=meMaxScope]").attr("step", 10);
                    }
                    else if ($scope.insuranceLevel.mePrecision == -2) {
                        $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=meMinScope]").attr("step", 100);
                        $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                        $("input[name=meMaxScope]").attr("step", 100);
                    }
                }
            });
            $("select[name='meComputationRule'] option").each(function () {
                if ($(this).val() == $scope.insuranceLevel.meComputationRule) {
                    $(this).attr("selected", true);
                    if ($(this).val() == 1) {
                        $("select[name=meComputationalAccuracy]").attr("disabled", true);
                    }
                }
            });
            $("input[name='isCMakeASupplementaryPayment']").each(function () {
                if (Number($(this).val()) == Number($scope.insuranceLevel.isCMakeASupplementaryPayment)) {
                    $(this).click();
                }
            });
            $("input[name='isMMakeASupplementaryPayment']").each(function () {
                if (Number($(this).val()) == Number($scope.insuranceLevel.isMMakeASupplementaryPayment)) {
                    $(this).click();
                }
            });
            $("input[name='isCDimissionSupplementaryPay']").each(function () {
                if (Number($(this).val()) == Number($scope.insuranceLevel.isCDimissionSupplementaryPay)) {
                    $(this).click();
                }
            });
            $("input[name='isMDimissionSupplementaryPay']").each(function () {
                if (Number($(this).val()) == Number($scope.insuranceLevel.isMDimissionSupplementaryPay)) {
                    $(this).click();
                }
            });
            form.render();
            form.verify({
                isDouble: function(value) {
                    if(value.length > 0 && !AM.isDouble.test(value)) {
                        return "请输入一个大于0的小数或整数";
                    }
                },
                isNumber: function(value) {
                    if(value.length > 0 && !AM.isNumber.test(value) && value > 0) {
                        return "请输入一个正整数";
                    }
                },
                three: function (value) {
                    var len = value.split(".");
                    if(len.length < 2 || len[1].length != 3) {
                        return "请保留三位小数";
                    }
                },
                two: function (value) {
                    var len = value.split(".");
                    if(len.length < 2 || len[1].length != 2) {
                        return "请保留二位小数";
                    }
                },
                one: function (value) {
                    var len = value.split(".");
                    if(len.length < 2 || len[1].length != 1) {
                        return "请保留一位小数";
                    }
                },
            });

            //监听公司缴纳类型
            form.on('radio(coPayType)', function(data) {
                if (data.value == 1) {
                    $("#coPayTypeHtml").html("比例");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("%");

                    $("select[name=coComputationRule]").parent().parent().show();
                    $("select[name=coComputationRule]").attr("lay-verify", "required");
                    $("select[name=coComputationalAccuracy]").parent().parent().show();
                    $("select[name=coComputationalAccuracy]").attr("lay-verify", "required");
                    $("select[name=coPrecision]").parent().parent().show();
                    $("select[name=coPrecision]").attr("lay-verify", "required");
                    $("input[name=coMinScope]").parent().parent().show();
                    $("input[name=coMinScope]").attr("lay-verify", "required|isDouble");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|isDouble");
                }
                else if (data.value == 0) {
                    $("#coPayTypeHtml").html("金额");
                    $("input[name=coPayPrice]").attr("placeholder", "请输入金额");
                    $("input[name=coPayPrice]").parent().parent().show();
                    $("input[name=coPayPrice]").attr("lay-verify", "required|isDouble");
                    $("#coUnit").html("元");

                    $("select[name=coComputationRule]").parent().parent().hide();
                    $("select[name=coComputationRule]").removeAttr("lay-verify");
                    $("select[name=coComputationalAccuracy]").parent().parent().hide();
                    $("select[name=coComputationalAccuracy]").removeAttr("lay-verify");
                    $("select[name=coPrecision]").parent().parent().hide();
                    $("select[name=coPrecision]").removeAttr("lay-verify");
                    $("input[name=coMinScope]").parent().parent().hide();
                    $("input[name=coMinScope]").removeAttr("lay-verify");
                    $("input[name=coMaxScope]").removeAttr("lay-verify");

                    $("select[name=coComputationRule] option").removeAttr("selected");
                    $("select[name=coComputationalAccuracy] option").removeAttr("selected").removeAttr("disabled");
                    $("select[name=coComputationalAccuracy]").removeAttr("disabled");
                    $("select[name=coPrecision] option").removeAttr("selected");
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else {
                    $("input[name=coPayPrice]").parent().parent().hide();
                    $("input[name=coPayPrice]").removeAttr("lay-verify");
                    $("input[name=coPayPrice]").val("");

                    $("select[name=coComputationRule]").parent().parent().show();
                    $("select[name=coComputationRule]").attr("lay-verify", "required");
                    $("select[name=coComputationalAccuracy]").parent().parent().show();
                    $("select[name=coComputationalAccuracy]").attr("lay-verify", "required");
                    $("select[name=coPrecision]").parent().parent().show();
                    $("select[name=coPrecision]").attr("lay-verify", "required");
                    $("input[name=coMinScope]").parent().parent().show();
                    $("input[name=coMinScope]").attr("lay-verify", "required|isDouble");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|isDouble");
                }
                form.render();
            });

            //监听计算规则
            //监听计算规则
            form.on('select(coComputationRule)', function(data) {
                if (data.value == 1) {
                    $("select[name=coComputationalAccuracy] option").each(function () {
                        if ($(this).val() == 0) {
                            $(this).prop("selected", true);
                            form.render();
                        }
                    });
                    $("select[name=coComputationalAccuracy]").attr("disabled", true);
                }
                else {
                    $("select[name=coComputationalAccuracy]").removeAttr("disabled");
                }

                $("select[name='meComputationRule'] option").each(function () {
                    if ($(this).val() == data.value) {
                        $(this).attr("selected", true);
                        if (data.value == 1) {
                            $("select[name=meComputationalAccuracy]").attr("disabled", true);
                            $("select[name=meComputationalAccuracy] option").each(function () {
                                if ($(this).val() == 0) {
                                    $(this).prop("selected", true);
                                }
                            });
                        }
                        else {
                            $("select[name=meComputationalAccuracy]").attr("disabled", false);
                        }
                    }
                });
                form.render();
            });

            //监听计算精度
            form.on('select(coComputationalAccuracy)', function(data) {
                $("select[name=meComputationalAccuracy] option").each(function () {
                    if ($(this).val() == data.value) {
                        $(this).prop("selected", true);
                    }
                });
                form.render();
            });

            //监听公司精度填写
            form.on('select(coPrecision)', function(data) {
                $("select[name=mePrecision] option").each(function () {
                    if ($(this).val() == data.value) {
                        $(this).prop("selected", true);
                    }
                });
                form.render();
                if (data.value == 3) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|three");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|three");
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else if (data.value == 2) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|two");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|two");
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else if (data.value == 1) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|one");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|one");
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else if (data.value == 0) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else if (data.value == -1) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMinScope]").attr("step", 10);
                    $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMaxScope]").attr("step", 10);
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").val("");
                }
                else if (data.value == -2) {
                    $("input[name=coMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMinScope]").attr("step", 100);
                    $("input[name=coMinScope]").val("");
                    $("input[name=coMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=coMaxScope]").attr("step", 100);
                    $("input[name=coMaxScope]").val("");
                }

                //个人的
                if (data.value == 3) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|three");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|three");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 2) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|two");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|two");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 1) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|one");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|one");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 0) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == -1) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").attr("step", 10);
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("step", 10);
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == -2) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").attr("step", 100);
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("step", 100);
                    $("input[name=meMaxScope]").val("");
                }
            });

            //监听计算规则
            form.on('select(meComputationRule)', function(data) {
                if (data.value == 1) {
                    $("select[name=meComputationalAccuracy] option").each(function () {
                        if ($(this).val() == 0) {
                            $(this).prop("selected", true);
                            form.render();
                        }
                    });
                    $("select[name=meComputationalAccuracy]").attr("disabled", true);
                    form.render();
                }
                else {
                    $("select[name=meComputationalAccuracy]").removeAttr("disabled");
                    form.render();
                }
            });

            //监听个人精度填写
            form.on('select(mePrecision)', function(data) {
                if (data.value == 3) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|three");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|three");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 2) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|two");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|two");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 1) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|one");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|one");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 0) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == -1) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").attr("step", 10);
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("step", 10);
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == -2) {
                    $("input[name=meMinScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMinScope]").attr("step", 100);
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isNumber");
                    $("input[name=meMaxScope]").attr("step", 100);
                    $("input[name=meMaxScope]").val("");
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

                    $("select[name=meComputationRule]").parent().parent().hide();
                    $("select[name=meComputationRule]").removeAttr("lay-verify");
                    $("select[name=meComputationalAccuracy]").parent().parent().hide();
                    $("select[name=meComputationalAccuracy]").removeAttr("lay-verify");
                    $("select[name=mePrecision]").parent().parent().hide();
                    $("select[name=mePrecision]").removeAttr("lay-verify");
                    $("input[name=meMinScope]").parent().parent().hide();
                    $("input[name=meMinScope]").removeAttr("lay-verify");
                    $("input[name=meMaxScope]").removeAttr("lay-verify");

                    $("select[name=meComputationRule] option").removeAttr("selected");
                    $("select[name=meComputationalAccuracy] option").removeAttr("selected").removeAttr("disabled");
                    $("select[name=meComputationalAccuracy]").removeAttr("disabled");
                    $("select[name=mePrecision] option").removeAttr("selected");
                    $("input[name=meMinScope]").val("");
                    $("input[name=meMaxScope]").val("");
                }
                else if (data.value == 1) {
                    $("#mePayTypeHtml").html("比例");
                    $("input[name=mePayPrice]").attr("placeholder", "请输入比例");
                    $("input[name=mePayPrice]").parent().parent().show();
                    $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                    $("#meUnit").html("%");

                    $("select[name=meComputationRule]").parent().parent().show();
                    $("select[name=meComputationRule]").attr("lay-verify", "required");
                    $("select[name=meComputationalAccuracy]").parent().parent().show();
                    $("select[name=meComputationalAccuracy]").attr("lay-verify", "required");
                    $("select[name=mePrecision]").parent().parent().show();
                    $("select[name=mePrecision]").attr("lay-verify", "required");
                    $("input[name=meMinScope]").parent().parent().show();
                    $("input[name=meMinScope]").attr("lay-verify", "required|isDouble");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isDouble");
                }
                else {
                    $("input[name=mePayPrice]").parent().parent().hide();
                    $("input[name=mePayPrice]").removeAttr("lay-verify");
                    $("input[name=mePayPrice]").val("");

                    $("select[name=meComputationRule]").parent().parent().show();
                    $("select[name=meComputationRule]").attr("lay-verify", "required");
                    $("select[name=meComputationalAccuracy]").parent().parent().show();
                    $("select[name=meComputationalAccuracy]").attr("lay-verify", "required");
                    $("select[name=mePrecision]").parent().parent().show();
                    $("select[name=mePrecision]").attr("lay-verify", "required");
                    $("input[name=meMinScope]").parent().parent().show();
                    $("input[name=meMinScope]").attr("lay-verify", "required|isDouble");
                    $("input[name=meMaxScope]").attr("lay-verify", "required|isDouble");
                }
                form.render();
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                if (data.field.coPayType == 1) {
                    if (Number(data.field.coMaxScope) < Number(data.field.coMinScope)) {
                        layer.msg("基数上限不能小于下限");
                        $("input[name=coMinScope]").focus();
                        return false;
                    }
                }
                if (data.field.mePayType) {
                    if (Number(data.field.meMaxScope) < Number(data.field.meMinScope)) {
                        layer.msg("基数上限不能小于下限");
                        $("input[name=meMinScope]").focus();
                        return false;
                    }
                }
                data.field.id = Number($scope.id);
                AM.log(data.field);
                AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/update", data.field , function(result) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });
        });
    });

    $(function () {
        $("input[name=coMaxScope]").on("blur", function () {
            var coPrecision = $("select[name=coPrecision]").val();
            calculate($(this), coPrecision);
            calculate($("input[name=meMaxScope]"), coPrecision);
            var value = $(this).val();
            if (value != "" && coPrecision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && coPrecision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }
            if ($("input[name=coMinScope]").val() != "" && value != "" && Number($(this).val()) < Number($("input[name=coMinScope]").val())) {
                layer.msg("基数下限不能大于上限");
                $(this).focus();
            }
        });
        $("input[name=coMinScope]").on("blur", function () {
            var coPrecision = $("select[name=coPrecision]").val();
            calculate($(this), coPrecision);
            calculate($("input[name=meMinScope]"), coPrecision);
            var value = $(this).val();
            if (value != "" && coPrecision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && coPrecision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }
            if ($("input[name=coMaxScope]").val() != "" && value != "" && Number($(this).val()) > Number($("input[name=coMaxScope]").val())) {
                layer.msg("基数上限不能小于下限");
                $(this).focus();
            }
        });
        $("input[name=meMaxScope]").on("blur", function () {
            var mePrecision = $("select[name=mePrecision]").val();
            calculate($(this), mePrecision);
            var value = $(this).val();
            if (value != "" && mePrecision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && mePrecision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }
            if ($("input[name=meMinScope]").val() != "" && value != "" && Number($(this).val()) < Number($("input[name=meMinScope]").val())) {
                layer.msg("基数下限不能大于上限");
                $(this).focus();
            }
        });

        $("input[name=meMinScope]").on("blur", function () {
            var mePrecision = $("select[name=mePrecision]").val();
            calculate($(this), mePrecision);
            var value = $(this).val();
            if (value != "" && mePrecision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && mePrecision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }
            if ($("input[name=meMaxScope]").val() != "" && value != "" && Number($(this).val()) > Number($("input[name=meMaxScope]").val())) {
                layer.msg("基数上限不能小于下限");
                $(this).focus();
            }
        });

        $("input[name=mePayPrice]").on("blur", function () {
            if ($("input[name=mePayType]:checked").val() == 1) {
                if ($(this).val() == 0) {
                    $("input[name=mePayType]").each(function () {
                        if ($(this).val() == 0) {
                            $(this).prop("checked", true);
                            $("#mePayTypeHtml").html("金额");
                            $("input[name=mePayPrice]").attr("placeholder", "请输入金额");
                            $("input[name=mePayPrice]").parent().parent().show();
                            $("input[name=mePayPrice]").attr("lay-verify", "required|isDouble");
                            $("#meUnit").html("元");

                            $("select[name=meComputationRule]").parent().parent().hide();
                            $("select[name=meComputationRule]").removeAttr("lay-verify");
                            $("select[name=meComputationalAccuracy]").parent().parent().hide();
                            $("select[name=meComputationalAccuracy]").removeAttr("lay-verify");
                            $("select[name=mePrecision]").parent().parent().hide();
                            $("select[name=mePrecision]").removeAttr("lay-verify");
                            $("input[name=meMinScope]").parent().parent().hide();
                            $("input[name=meMinScope]").removeAttr("lay-verify");
                            $("input[name=meMaxScope]").removeAttr("lay-verify");
                            form.render();
                        }
                    });
                }
            }
        });

        $("input[name=coPayPrice]").bind('input propertychange', function() {
            $("input[name=mePayPrice]").val($("input[name=coPayPrice]").val());
        });

        $("input[name=coMinScope]").bind('input propertychange', function() {
            $("input[name=meMinScope]").val($("input[name=coMinScope]").val());
        });

        $("input[name=coMaxScope]").bind('input propertychange', function() {
            $("input[name=meMaxScope]").val($("input[name=coMaxScope]").val());
        });

    })


</script>
</body>
</html>
