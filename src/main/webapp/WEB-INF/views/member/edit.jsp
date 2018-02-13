<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改员工</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        input[type=number][readonly]{
            background: #EEEEEE;
        }
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改员工</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-col-xs6" style="float: left;width: 50%">
            <fieldset class="layui-elem-field">
                <legend>基本信息</legend>
                <div class="layui-field-box">
                    <div class="layui-form-item">
                        <label class="layui-form-label">公司<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select id="companyId" name="companyId" lay-verify="required" lay-search
                                    lay-filter="companyId">
                                <option value="">请选择公司</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">部门</label>
                        <div class="layui-input-inline">
                            <input value="{{member.department}}" type="text" name="department" placeholder="请输入部门"
                                   autocomplete="off" class="layui-input" maxlength="50">
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">员工名<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{member.userName}}" type="text" name="userName" lay-verify="required" placeholder="请输入员工名"
                                   autocomplete="off" class="layui-input" maxlength="50">
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">证件类型<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="certificateType" value="0" title="身份证" checked lay-filter="certificateType">
                            <input type="radio" name="certificateType" value="1" title="护照" lay-filter="certificateType">
                            <input type="radio" name="certificateType" value="2" title="港澳台通行证" lay-filter="certificateType">
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">证件编号<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{member.certificateNum}}" type="text" name="certificateNum" lay-verify="required|isIdCard" placeholder="请输入证件编号"
                                   autocomplete="off" class="layui-input" maxlength="20">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">手机号<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{member.phone}}" type="text" name="phone" lay-verify="required|isPhone" placeholder="请输入手机号"
                                   autocomplete="off" class="layui-input" maxlength="11">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">工作地点<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select id="cityId" name="cityId" lay-verify="required" lay-search>
                                <option value="">请选择或搜索</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">学历<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select id="education" name="education" lay-verify="required" lay-search>
                                <option value="">请选择</option>
                                <option value="0">博士</option>
                                <option value="1">硕士</option>
                                <option value="2">本科</option>
                                <option value="3">大专</option>
                                <option value="4">高中及以下</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">合作状态<span class="font-red">*</span></label>
                        <div class="layui-input-block">
                            <input type="radio" name="stateCooperation" value="0" title="离职" lay-filter="stateCooperation">
                            <input type="radio" name="stateCooperation" value="1" title="在职" checked lay-filter="stateCooperation">
                        </div>
                    </div>
                    <div class="layui-form-item ">
                        <label class="layui-form-label">离职时间</label>
                        <div class="layui-input-inline">
                            <input value="{{member.leaveOfficeTime | date : 'yyyy-MM-dd'}}" type="text" id="leaveOfficeTime" name="leaveOfficeTime"
                                   onclick="layui.laydate({elem: this})"
                                   placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input" maxlength="20"
                                   readonly>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">合作方式<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <select id="waysOfCooperation" name="waysOfCooperation" lay-verify="required" lay-filter="waysOfCooperation">
                                <option value="">请选择</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item hide">
                        <label class="layui-form-label">合同执行日期<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{member.contractStartTime | date : 'yyyy-MM-dd'}}" type="text" id="startTime" name="contractStartTime"
                                   onclick="layui.laydate({elem: this})"
                                   placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input" maxlength="20"
                                   readonly>
                        </div>
                    </div>
                    <div class="layui-form-item hide">
                        <label class="layui-form-label">合同结束日期<span class="font-red">*</span></label>
                        <div class="layui-input-inline">
                            <input value="{{member.contractEndTime | date : 'yyyy-MM-dd'}}" type="text" id="endTime" name="contractEndTime"
                                   onclick="layui.laydate({elem: this})"
                                   placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input" maxlength="20"
                                   readonly>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="layui-col-xs6" style="float: left;width: 50%">
            <fieldset class="layui-elem-field">
                <legend>业务信息</legend>
                <div class="layui-field-box">
                    <div class="layui-form-item layui-hide" id="businessBigDiv">
                        <label class="layui-form-label">选择业务<span class="font-red">*</span></label>
                        <div class="layui-input-inline" id="businessDiv">

                        </div>
                    </div>

                    <!-- 社保 -->
                    <div id="sheBaoDiv" class="layui-hide">
                        <fieldset class="layui-elem-field">
                            <legend>社保信息</legend>
                            <div class="layui-field-box">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">社保服务方式<span class="font-red">*</span></label>
                                    <div class="layui-input-inline" id="SSServiceDiv">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">纳入应收<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="radio" value="0"  name="isReceivable" title="否" checked>
                                        <input type="radio" value="1" name="isReceivable" title="是">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label"><span id="payPlaceHintSB">选择缴金地</span><span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="payPlaceId" id="payPlace" lay-filter="payPlaceFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">选择经办机构<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="organizationId" id="organization"
                                                lay-filter="organizationFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">选择办理方<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="transactorId" id="transactor" lay-filter="transactorFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">选择档次<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="insuranceLevelId" id="insuranceLevel" lay-filter="insuranceLevel">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">基数<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="radio" value="0"  name="baseNumberRadio" title="最低基数" checked lay-filter="baseNumberRadio">
                                        <input type="radio" value="1" name="baseNumberRadio" title="最高基数" lay-filter="baseNumberRadio">
                                        <input type="radio" value="2" name="baseNumberRadio" title="基数填写" lay-filter="baseNumberRadio">
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">基数填写<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="number" required placeholder="填写基数" class="layui-input" name="baseNumber" >
                                    </div>
                                    <div class="layui-form-mid layui-word-aux">请输入(<span id="baseNumberMin"></span>-<span id="baseNumberMax"></span>)之间</div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">服务起始月<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="serviceStartTime" name="serviceStartTime"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">服务结束月</label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="serviceEndTime" name="serviceEndTime"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">账单起始月<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="billStartTime" name="billStartTime"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">所属的子账单<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="companySonBillIdSB" id="companySonBillIdSB">
                                            <option value="">请选择</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <!-- 公积金 -->
                    <div id="GJDiv" class="layui-hide">
                        <fieldset class="layui-elem-field">
                            <legend>公积金信息</legend>
                            <div class="layui-field-box">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">公积金服务方式<span class="font-red">*</span></label>
                                    <div class="layui-input-inline" id="GJJServiceDiv">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">纳入应收<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="radio" value="0" name="isReceivableGJ" title="否" checked>
                                        <input type="radio" value="1" name="isReceivableGJ" title="是">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label"><span id="payPlaceHintGJ">选择缴金地</span><span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="payPlaceGJId" id="payPlaceGJ" lay-filter="payPlaceGJFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">选择经办机构<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="organizationGJId" id="organizationGJ"
                                                lay-filter="organizationGJFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">选择办理方<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="transactorGJId" id="transactorGJ"
                                                lay-filter="transactorGJFilter">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">比例<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="number" name="ratioGJ"
                                               placeholder="请输入比例" autocomplete="off" class="layui-input">
                                    </div>
                                    <div class="layui-form-mid layui-word-aux">请输入(<span id="ratioMinGJ"></span>-<span id="ratioMaxGJ"></span>)之间</div>
                                    <div class="layui-form-mid layui-word-aux">%</div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">基数<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="radio" value="0"  name="baseNumberRadioGJ" title="最低基数" lay-filter="baseNumberRadioGJ" disabled>
                                        <input type="radio" value="1" name="baseNumberRadioGJ" title="最高基数" lay-filter="baseNumberRadioGJ" disabled>
                                        <input type="radio" value="2" name="baseNumberRadioGJ" title="基数填写" lay-filter="baseNumberRadioGJ" checked>
                                    </div>
                                </div>
                                <div class="layui-form-item hide">
                                    <label class="layui-form-label">基数填写<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="number" required placeholder="基数填写" class="layui-input" name="baseNumberGJ" >
                                    </div>
                                    <div class="layui-form-mid layui-word-aux">请输入(<span id="baseNumberMinGJ"></span>-<span id="baseNumberMaxGJ"></span>)之间</div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">服务起始月<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="serviceStartTimeGJ" name="serviceStartTimeGJ"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">服务结束月</label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="serviceEndTimeGJ" name="serviceEndTimeGJ"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">账单起始月<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" placeholder="yyyyMM" class="layui-input"
                                               id="billStartTimeGJ" name="billStartTimeGJ"
                                               onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})">
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">所属的子账单<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="companySonBillIdGJ" id="companySonBillIdGJ">
                                            <option value="">请选择</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <!-- 工资 -->
                    <div id="GZDiv" class="layui-hide">
                        <fieldset class="layui-elem-field">
                            <legend>工资信息</legend>
                            <div class="layui-field-box">

                                <div class="layui-form-item">
                                    <label class="layui-form-label">国籍<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="nationality" id="nationality">
                                            <option value="1">中国大陆</option>
                                            <option value="0">非中国大陆</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">开户行<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="bankName"
                                               placeholder="请输入" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">银行卡号<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <input type="text" name="bankAccount"
                                               placeholder="请输入" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <%--<div class="layui-form-item">
                                    <label class="layui-form-label">联系电话<span class="font-red"></span></label>
                                    <div class="layui-input-inline">
                                        <input type="number" name="phoneNumber" placeholder="请输入" autocomplete="off"
                                               class="layui-input">
                                    </div>
                                </div>--%>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">报税地<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select id="cityIdGZ" name="cityIdGZ" lay-search>
                                            <option value="">请选择或搜索</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-form-item ">
                                    <label class="layui-form-label">所属的子账单<span class="font-red">*</span></label>
                                    <div class="layui-input-inline">
                                        <select name="companySonBillIdGZ" id="companySonBillIdGZ">
                                            <option value="">请选择</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <!-- 商业险 -->
                    <div id="SYXDiv" class="layui-hide">
                        <fieldset class="layui-elem-field">
                            <legend>商业险</legend>
                            <div class="layui-field-box">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选择商业险<span class="font-red">*</span></label>
                                    <div class="layui-input-block" id="SYXDivInline">
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>

                    <!-- 一次性业务 -->
                    <div id="YCXDiv" class="layui-hide">
                        <fieldset class="layui-elem-field">
                            <legend>一次性业务</legend>
                            <div class="layui-field-box">
                                <div class="layui-form-item">
                                    <label class="layui-form-label">选择业务<span class="font-red">*</span></label>
                                    <div class="layui-input-block" id="YCXDivInline">
                                    </div>
                                </div>
                            </div>
                        </fieldset>
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
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.member = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/member/info", {id : $scope.id} , function(result) {
            $scope.member = result.data;
        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            var start = {
                min: '2010-01-01 00:00:00'
                , max: '2099-06-16 23:59:59'
                , istoday: false
                , choose: function (datas) {
                    end.min = datas; //开始日选好后，重置结束日的最小日期
                    end.start = datas //将结束日的初始值设定为开始日
                    var date = new Date(datas);
                    $("#endTime").val(new Date((date.getFullYear() + 2) + "-" + (date.getMonth() + 1) + "-" + date.getDate()).format("yyyy-MM-dd"));
                }
            };
            var end = {
                min: laydate.now()
                , max: '2099-06-16 23:59:59'
                , istoday: false
                , choose: function (datas) {
                    start.max = datas; //结束日选好后，重置开始日的最大日期
                }
            };
            document.getElementById('startTime').onclick = function () {
                $("#startTime").val(12);
                start.elem = this;
                laydate(start);
            }
            document.getElementById('endTime').onclick = function () {
                end.elem = this
                laydate(end);
            }
            form.verify({
                isIdCard: function (value) {
                    if (value.length > 0 && !AM.isIHCIard.test(value)) {
                        return "请输入正确的身份证号码";
                    }
                },
                isPhone: function (value) {
                    if (value.length > 0 && !AM.isMobile.test(value)) {
                        return "请输入正确的手机号";
                    }
                },
            });
            // 初始化学历

            $("#education option").each(function(){
                if($(this).val() == $scope.member.education){
                    $(this).attr("selected",true);
                }
            })

            /**初始化基本信息**/
            selectProvinceAndCity($scope.member.cityId, "cityId"); //省
            queryAllCompany($scope.member.companyId, "companyId", null, 0); //公司下拉
            //证件类型
            $("input[name=certificateType]").each(function () {
                if ($(this).val() == $scope.member.certificateType) { $(this).click(); }
                if ($scope.member.certificateType != 0) {
                    $("input[name=certificateNum]").attr("lay-verify", "required");
                }
            });
            //合作状态
            $("input[name=stateCooperation]").each(function () { if ($(this).val() == $scope.member.stateCooperation) { $(this).click(); } });
            //合作方式

            getBaseCooperationMethod($scope.member.waysOfCooperation, "waysOfCooperation", $scope.member.companyId);
            if ($scope.member.waysOfCooperation == 0) {
                $("#startTime").removeAttr("lay-verify").parent().parent().hide();
                $("#endTime").removeAttr("lay-verify").parent().parent().hide();
            }
            else {
                $("#startTime").attr("lay-verify", "required").parent().parent().show();
                $("#endTime").attr("lay-verify", "required").parent().parent().show();
            }

            /**业务信息**/
            $("#businessBigDiv").show("fast"); //显示
            buildBusinessInputByCompany(0, "businessDiv", "post", null, $scope.member.companyId);// 显示
            for (var i = 0; i < $scope.member.businessList.length; i++) {
                var business = $scope.member.businessList[i];
                console.log("&&&&&&&&&&&")
                console.log("business : ")
                console.log(business)
                console.log("&&&&&&&&&&&")
                if (business.id == 3) { // 社保
                    //必填社保
                    $("#sheBaoDiv").find("select").attr("lay-verify", "required");
                    $("#sheBaoDiv").find("input[type=text]").attr("lay-verify", "required");
                    $("#sheBaoDiv").find("input[type=number]").attr("lay-verify", "required");
                    $("#sheBaoDiv").find("input[name=serviceEndTime]").removeAttr("lay-verify");

                    $("input[name=businessArr]").each(function () {
                        if ($(this).val() == business.id) {
                            $(this).click();
                            var obj = JSON.parse($(this).attr("objstr"));
                            // 设置社保服务方式
                            if(null != obj.businessMethod){
                                var html = "";
                                if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan != null){
                                    //代理情况
                                    if (business.memberBusinessItem.serveMethod == 0) {
                                        html += '<input type="radio" lay-filter="radioFilter" value="0" name="businessMethodSS" title="代理" checked>';
                                        html += '<input type="radio" lay-filter="radioFilter" value="1" name="businessMethodSS" title="托管">';
                                        getPayPlaceByType(business.memberBusinessItem.payPlaceId, "payPlace", "post", null, 0);
                                        getOrganizationByPayPlace(business.memberBusinessItem.organizationId, "organization", "post", 0, business.memberBusinessItem.payPlaceId);
                                        getInsuranceLevelByPayPlace(business.memberBusinessItem.insuranceLevelId, "insuranceLevel", "post", 0, business.memberBusinessItem.payPlaceId, 0);
                                        getTransactorByOrganization(business.memberBusinessItem.transactorId, "transactor", "post", null, business.memberBusinessItem.organizationId);
                                        AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/countPayTheWay", {levelId : business.memberBusinessItem.insuranceLevelId} , function(result) {
                                            $("input[name=baseNumber]").attr("min", result.data.min);
                                            $("input[name=baseNumber]").attr("max", result.data.max);
                                            $("#baseNumberMin").html(result.data.min);
                                            $("#baseNumberMax").html(result.data.max);
                                            if (business.memberBusinessItem.baseType < 2) {
                                                $("input[name=baseNumber]").prop("readonly", true);
                                            }
                                            $("input[name=baseNumberRadio]").eq(business.memberBusinessItem.baseType).prop("checked", true);

                                            if (business.memberBusinessItem.baseType == 0) {
                                                $("input[name=baseNumber]").val(result.data.min);
                                            }
                                            else if (business.memberBusinessItem.baseType == 1) {
                                                $("input[name=baseNumber]").val(result.data.max);
                                            }
                                            else {
                                                $("input[name=baseNumber]").val(business.memberBusinessItem.baseNumber);
                                            }

                                            $("input[name=baseNumber]").on("blur", function () {
                                                /*if ($(this).val() > Number($("input[name=baseNumber]").attr("max"))) {
                                                    $(this).val(Number($("input[name=baseNumber]").attr("max")));
                                                }
                                                else if ($(this).val() < Number($("input[name=baseNumber]").attr("min"))) {
                                                    $(this).val(Number($("input[name=baseNumber]").attr("min")));
                                                }*/
                                            });
                                        });
                                        $("input[name=baseNumberRadio]").parent().parent().show();
                                        $("input[name=baseNumber]").parent().parent().show();
                                        $("#insuranceLevel").parent().parent().show();
                                        $("#organization").parent().parent().show();
                                        $("#transactor").parent().parent().show();

                                        $("input[name='isReceivable']").each(function(){
                                            if($(this).val() == 0){
                                                $(this).attr("checked",false);
                                                $(this).attr("disabled",true);
                                            }
                                            if($(this).val() == 1){
                                                $(this).attr("checked","checked");
                                            }
                                        })


                                    }
                                    //托管情况
                                    else {
                                        $("#payPlaceHintSB").html("选择办理方");
                                        html += '<input type="radio" lay-filter="radioFilter" value="0" name="businessMethodSS" title="代理">';
                                        html += '<input type="radio" lay-filter="radioFilter" value="1" name="businessMethodSS" title="托管" checked>';
                                        // 获取 客户 缴金地
                                        getCompanyPayPlaceByType(business.memberBusinessItem.payPlaceId,"payPlace","post",0,0, $scope.member.companyId);
                                        AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/info", {id : business.memberBusinessItem.payPlaceId} , function(result) {
                                            getInsuranceLevelByPayPlace(business.memberBusinessItem.insuranceLevelId, "insuranceLevel", "post", 0, result.data.payPlaceId, 1);
                                        });
                                        AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/countPayTheWay", {levelId : business.memberBusinessItem.insuranceLevelId} , function(result) {
                                            $("input[name=baseNumber]").attr("min", result.data.min);
                                            $("input[name=baseNumber]").attr("max", result.data.max);
                                            $("#baseNumberMin").html(result.data.min);
                                            $("#baseNumberMax").html(result.data.max);
                                            if (business.memberBusinessItem.baseType < 2) {
                                                $("input[name=baseNumber]").prop("readonly", true);
                                            }
                                            $("input[name=baseNumberRadio]").eq(business.memberBusinessItem.baseType).prop("checked", true);

                                            if (business.memberBusinessItem.baseType == 0) {
                                                $("input[name=baseNumber]").val(result.data.min);
                                            }
                                            else if (business.memberBusinessItem.baseType == 1) {
                                                $("input[name=baseNumber]").val(result.data.max);
                                            }
                                            else {
                                                $("input[name=baseNumber]").val(business.memberBusinessItem.baseNumber);
                                            }

                                            $("input[name=baseNumber]").on("blur", function () {
                                                /*if ($(this).val() > Number($("input[name=baseNumber]").attr("max"))) {
                                                    $(this).val(Number($("input[name=baseNumber]").attr("max")));
                                                }
                                                else if ($(this).val() < Number($("input[name=baseNumber]").attr("min"))) {
                                                    $(this).val(Number($("input[name=baseNumber]").attr("min")));
                                                }*/
                                            });
                                        });
                                        $("input[name=baseNumberRadio]").parent().parent().show();
                                        $("input[name=baseNumber]").parent().parent().show();
                                        $("#insuranceLevel").parent().parent().show();

                                        $("#sheBaoDiv").find("select[name=organizationId]").removeAttr("lay-verify");
                                        $("#sheBaoDiv").find("select[name=transactorId]").removeAttr("lay-verify");

                                        $("input[name='isReceivable']").each(function(){
                                            if(business.memberBusinessItem.isReceivable == 0){
                                                if($(this).val() == 0){
                                                    $(this).attr("checked","checked");
                                                }
                                            }
                                            if(business.memberBusinessItem.isReceivable == 1){
                                                if($(this).val() == 1){
                                                    $(this).attr("checked","checked");
                                                }
                                            }
                                        })

                                    }





                                }
                                else if(obj.businessMethod.daiLi == null && obj.businessMethod.tuoGuan != null){
                                    $("#payPlaceHintSB").html("选择办理方");
                                    html += '<input type="radio" lay-filter="radioFilter" value="1" name="businessMethodSS" title="托管" checked>';
                                    getCompanyPayPlaceByType(business.memberBusinessItem.payPlaceId,"payPlace","post",0,0, $scope.member.companyId);
                                    AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/info", {id : business.memberBusinessItem.payPlaceId} , function(result) {
                                        getInsuranceLevelByPayPlace(business.memberBusinessItem.insuranceLevelId, "insuranceLevel", "post", 0, result.data.payPlaceId, 1);
                                    });
                                    $("input[name='isReceivable']").each(function(){
                                        $(this).attr("disabled",false);
                                        // 代理 选择是  且不可修改
                                        if($(this).val() == business.memberBusinessItem.isReceivable){
                                            $(this).attr("checked","checked");
                                        }
                                    })
                                    AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/countPayTheWay", {levelId : business.memberBusinessItem.insuranceLevelId} , function(result) {
                                        $("input[name=baseNumber]").attr("min", result.data.min);
                                        $("input[name=baseNumber]").attr("max", result.data.max);
                                        $("#baseNumberMin").html(result.data.min);
                                        $("#baseNumberMax").html(result.data.max);
                                        if (business.memberBusinessItem.baseType < 2) {
                                            $("input[name=baseNumber]").prop("readonly", true);
                                        }
                                        $("input[name=baseNumberRadio]").eq(business.memberBusinessItem.baseType).prop("checked", true);

                                        if (business.memberBusinessItem.baseType == 0) {
                                            $("input[name=baseNumber]").val(result.data.min);
                                        }
                                        else if (business.memberBusinessItem.baseType == 1) {
                                            $("input[name=baseNumber]").val(result.data.max);
                                        }
                                        else {
                                            $("input[name=baseNumber]").val(business.memberBusinessItem.baseNumber);
                                        }

                                        $("input[name=baseNumber]").on("blur", function () {
                                            /*if ($(this).val() > Number($("input[name=baseNumber]").attr("max"))) {
                                                $(this).val(Number($("input[name=baseNumber]").attr("max")));
                                            }
                                            else if ($(this).val() < Number($("input[name=baseNumber]").attr("min"))) {
                                                $(this).val(Number($("input[name=baseNumber]").attr("min")));
                                            }*/
                                        });
                                    });
                                    $("input[name=baseNumberRadio]").parent().parent().show();
                                    $("input[name=baseNumber]").parent().parent().show();
                                    $("#insuranceLevel").parent().parent().show();

                                    $("#sheBaoDiv").find("select[name=organizationId]").removeAttr("lay-verify");
                                    $("#sheBaoDiv").find("select[name=transactorId]").removeAttr("lay-verify");
                                }
                                else if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan == null){
                                    html += '<input type="radio" lay-filter="radioFilter" value="0" name="businessMethodSS" title="代理" checked>';
                                    getPayPlaceByType(business.memberBusinessItem.payPlaceId, "payPlace", "post", null, 0);
                                    getOrganizationByPayPlace(business.memberBusinessItem.organizationId, "organization", "post", 0, business.memberBusinessItem.payPlaceId);
                                    getInsuranceLevelByPayPlace(business.memberBusinessItem.insuranceLevelId, "insuranceLevel", "post", 0, business.memberBusinessItem.payPlaceId, 0);
                                    getTransactorByOrganization(business.memberBusinessItem.transactorId, "transactor", "post", null, business.memberBusinessItem.organizationId);
                                    AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/countPayTheWay", {levelId : business.memberBusinessItem.insuranceLevelId} , function(result) {
                                        $("input[name=baseNumber]").attr("min", result.data.min);
                                        $("input[name=baseNumber]").attr("max", result.data.max);
                                        $("#baseNumberMin").html(result.data.min);
                                        $("#baseNumberMax").html(result.data.max);
                                        if (business.memberBusinessItem.baseType < 2) {
                                            $("input[name=baseNumber]").prop("readonly", true);
                                        }
                                        $("input[name=baseNumberRadio]").eq(business.memberBusinessItem.baseType).prop("checked", true);

                                        if (business.memberBusinessItem.baseType == 0) {
                                            $("input[name=baseNumber]").val(result.data.min);
                                        }
                                        else if (business.memberBusinessItem.baseType == 1) {
                                            $("input[name=baseNumber]").val(result.data.max);
                                        }
                                        else {
                                            $("input[name=baseNumber]").val(business.memberBusinessItem.baseNumber);
                                        }

                                        $("input[name=baseNumber]").on("blur", function () {
                                            /*if ($(this).val() > Number($("input[name=baseNumber]").attr("max"))) {
                                                $(this).val(Number($("input[name=baseNumber]").attr("max")));
                                            }
                                            else if ($(this).val() < Number($("input[name=baseNumber]").attr("min"))) {
                                                $(this).val(Number($("input[name=baseNumber]").attr("min")));
                                            }*/
                                        });
                                    });
                                    $("input[name=baseNumberRadio]").parent().parent().show();
                                    $("input[name=baseNumber]").parent().parent().show();
                                    $("#organization").parent().parent().show();
                                    $("#insuranceLevel").parent().parent().show();
                                    $("#transactor").parent().parent().show();
                                    $("input[name='isReceivable']").each(function(){
                                        // 代理 选择是  且不可修改
                                        if($(this).val() == 0){
                                            $(this).attr("checked",false);
                                            $(this).attr("disabled",true);
                                        }
                                        if($(this).val() == 1){
                                            $(this).attr("checked","checked");
                                        }
                                    })
                                }
                                $("#SSServiceDiv").html(html);
                            }
                        }
                    });
                    getCompanySonBillByCompany(business.companySonBillId, "companySonBillIdSB", 0, $scope.member.companyId); // 获取子账单

                    $("#serviceStartTime").val(new Date(business.memberBusinessItem.serviceStartTime).format("yyyyMM"));
                    if (business.memberBusinessItem.serviceEndTime != null && business.memberBusinessItem.serviceEndTime != "") {
                        $("#serviceEndTime").val(new Date(business.memberBusinessItem.serviceEndTime).format("yyyyMM"));
                    }
                    $("#billStartTime").val(new Date(business.memberBusinessItem.billStartTime).format("yyyyMM"));

                    $("#sheBaoDiv").show("fast");
                    form.render();

                }
                else if (business.id == 4) { // 公积金

                    //必填公积金
                    $("#GJDiv").find("select").attr("lay-verify", "required");
                    $("#GJDiv").find("input[type=text]").attr("lay-verify", "required");
                    $("#GJDiv").find("input[type=number]").attr("lay-verify", "required");
                    $("#GJDiv").find("input[name=serviceEndTimeGJ]").removeAttr("lay-verify");

                    $("input[name=businessArr]").each(function () {
                        if ($(this).val() == business.id) {
                            $(this).click();
                            var obj = JSON.parse($(this).attr("objstr"));
                            // 设置社保服务方式
                            if(null != obj.businessMethod){
                                $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                var html = "";
                                if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan != null){
                                    //代理情况
                                    if (business.memberBusinessItem.serveMethod == 0) {
                                        html += '<input type="radio" lay-filter="radioFilterGJJ" value="0" name="businessMethodGJJ" title="代理" checked>';
                                        html += '<input type="radio" lay-filter="radioFilterGJJ" value="1" name="businessMethodGJJ" title="托管">';
                                        getPayPlaceByType(business.memberBusinessItem.payPlaceId, "payPlaceGJ", "post", null, 1);
                                        getOrganizationByPayPlace(business.memberBusinessItem.organizationId, "organizationGJ", "post", null, business.memberBusinessItem.payPlaceId);
                                        $("#organizationGJ").parent().parent().show();
                                        getTransactorByOrganization(business.memberBusinessItem.transactorId, "transactorGJ", "post", null, business.memberBusinessItem.organizationId);
                                        $("#transactorGJ").parent().parent().show();
                                        AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : business.memberBusinessItem.organizationId} , function(result) {
                                            $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                                            $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                                            $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                                            $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                                            if (business.memberBusinessItem.baseType < 2) {
                                                $("input[name=baseNumberGJ]").prop("readonly", true);
                                            }
                                            $("input[name=baseNumberRadioGJ]").eq(business.memberBusinessItem.baseType).prop("checked", true);
                                            $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                                            $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);

                                            if (business.memberBusinessItem.baseType == 0) {
                                                $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                                            }
                                            else if (business.memberBusinessItem.baseType == 1) {
                                                $("input[name=baseNumberGJ]").val(result.data.maxCardinalNumber);
                                            }
                                            else {
                                                $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                            }

                                            $("input[name=baseNumberGJ]").on("blur", function () {
                                                /*if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                                                    $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                                                }
                                                else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                                                    $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                                                }*/
                                                var precision = $(this).attr("precision");
                                                calculate($(this), precision);
                                                if (precision == 3) {
                                                    $(this).attr("lay-verify", "required|three");
                                                }
                                                else if (data.value == 2) {
                                                    $(this).attr("lay-verify", "required|two");
                                                }
                                                else if (data.value == 1) {
                                                    $(this).attr("lay-verify", "required|one");
                                                }
                                                else if (data.value == 0) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                }
                                                else if (data.value == -1) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                    $(this).attr("step", 10);
                                                }
                                                else if (data.value == -2) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                    $(this).attr("step", 100);
                                                }
                                            });
                                        });
                                        $("input[name=baseNumberRadioGJ]").parent().parent().show();
                                        $("input[name=baseNumberGJ]").parent().parent().show();
                                        $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                        $("input[name='isReceivableGJ']").each(function(){
                                            // 代理 选择是  且不可修改
                                            if($(this).val() == 0){
                                                $(this).attr("checked",false);
                                                $(this).attr("disabled",true);
                                            }
                                            if($(this).val() == 1){
                                                $(this).attr("checked","checked");
                                                $(this).removeAttr("disabled");
                                            }
                                        })

                                        AM.ajaxRequestData("post", false, AM.ip + "/organization/countByOrganization", {organizationId : business.memberBusinessItem.organizationId} , function(result) {
                                            if (result.data != undefined) {
                                                $("input[name=ratioGJ]").attr("min", result.data.min);
                                                $("input[name=ratioGJ]").attr("max", result.data.max);
                                                $("#ratioMinGJ").html(result.data.min);
                                                $("#ratioMaxGJ").html(result.data.max);
                                                /*$("input[name=ratioGJ]").on("blur", function () {
                                                    if ($(this).val() > Number($("input[name=ratioGJ]").attr("max"))) {
                                                        $(this).val(Number($("input[name=ratioGJ]").attr("max")));
                                                    }
                                                    else if ($(this).val() < Number($("input[name=ratioGJ]").attr("min"))) {
                                                        $(this).val(Number($("input[name=ratioGJ]").attr("min")));
                                                    }
                                                });*/
                                            }
                                        });
                                        $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").show();

                                    }
                                    //托管情况
                                    else {
                                        $("#payPlaceHintGJ").html("选择办理方");
                                        html += '<input type="radio" lay-filter="radioFilterGJJ" value="0" name="businessMethodGJJ" title="代理">';
                                        html += '<input type="radio" lay-filter="radioFilterGJJ" value="1" name="businessMethodGJJ" title="托管" checked>';
                                        getCompanyPayPlaceByType(business.memberBusinessItem.payPlaceId,"payPlaceGJ","post",0,1, $scope.member.companyId);
                                        AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/info", {id : business.memberBusinessItem.payPlaceId} , function(result) {
                                            AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : result.data.organizationId} , function(result) {
                                                $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                                                $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                                                $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                                                if (business.memberBusinessItem.baseType < 2) {
                                                    $("input[name=baseNumberGJ]").prop("readonly", true);
                                                }
                                                $("input[name=baseNumberRadioGJ]").eq(business.memberBusinessItem.baseType).prop("checked", true);
                                                $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                                                $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);
                                                if (business.memberBusinessItem.baseType == 0) {
                                                    $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                                                }
                                                else if (business.memberBusinessItem.baseType == 1) {
                                                    $("input[name=baseNumberGJ]").val(result.data.maxCardinalNumber);
                                                }
                                                else {
                                                    $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                                }
                                                $("input[name=baseNumberGJ]").on("blur", function () {
                                                    /*if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                                                        $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                                                    }
                                                    else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                                                        $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                                                    }*/
                                                    var precision = $(this).attr("precision");
                                                    calculate($(this), precision);
                                                    if (precision == 3) {
                                                        $(this).attr("lay-verify", "required|three");
                                                    }
                                                    else if (data.value == 2) {
                                                        $(this).attr("lay-verify", "required|two");
                                                    }
                                                    else if (data.value == 1) {
                                                        $(this).attr("lay-verify", "required|one");
                                                    }
                                                    else if (data.value == 0) {
                                                        $(this).attr("lay-verify", "required|isNumber");
                                                    }
                                                    else if (data.value == -1) {
                                                        $(this).attr("lay-verify", "required|isNumber");
                                                        $(this).attr("step", 10);
                                                    }
                                                    else if (data.value == -2) {
                                                        $(this).attr("lay-verify", "required|isNumber");
                                                        $(this).attr("step", 100);
                                                    }
                                                });
                                            });
                                        });

                                        $("input[name=ratioGJ]").on("blur", function () {
                                            if(!(/^[0-9]+$/.test($(this).val()))){
                                                $(this).val("");
                                            }
                                            /*if ($(this).val() <= 0) {
                                                $(this).val(1);
                                            }*/
                                        });
                                        $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").hide();

                                        $("input[name=baseNumberRadioGJ]").parent().parent().show();
                                        $("input[name=baseNumberGJ]").parent().parent().show();

                                        $("#GJDiv").find("select[name=organizationGJId]").removeAttr("lay-verify");
                                        $("#GJDiv").find("select[name=transactorGJId]").removeAttr("lay-verify");

                                        $("input[name='isReceivableGJ']").each(function(){
                                            if(business.memberBusinessItem.isReceivable == 0){
                                                if($(this).val() == 0){
                                                    $(this).attr("checked","checked");
                                                }
                                            }
                                            if(business.memberBusinessItem.isReceivable == 1){
                                                if($(this).val() == 1){
                                                    $(this).attr("checked","checked");
                                                }
                                            }
                                        })

                                    }

                                }
                                else if(obj.businessMethod.daiLi == null && obj.businessMethod.tuoGuan != null){
                                    $("#payPlaceHintGJ").html("选择办理方");
                                    html += '<input type="radio" lay-filter="radioFilterGJJ" value="1" name="businessMethodGJJ" title="托管" checked>';
                                    getCompanyPayPlaceByType(business.memberBusinessItem.payPlaceId,"payPlaceGJ","post",0,1, $scope.member.companyId);
                                    AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/info", {id : business.memberBusinessItem.payPlaceId} , function(result) {
                                        AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : result.data.organizationId} , function(result) {
                                            $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                                            $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                                            $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                                            if (business.memberBusinessItem.baseType < 2) {
                                                $("input[name=baseNumberGJ]").prop("readonly", true);
                                            }
                                            $("input[name=baseNumberRadioGJ]").eq(business.memberBusinessItem.baseType).prop("checked", true);
                                            $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                                            $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);
                                            if (business.memberBusinessItem.baseType == 0) {
                                                $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                                            }
                                            else if (business.memberBusinessItem.baseType == 1) {
                                                $("input[name=baseNumberGJ]").val(result.data.maxCardinalNumber);
                                            }
                                            else {
                                                $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                            }
                                            $("input[name=baseNumberGJ]").on("blur", function () {
                                                /*if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                                                    $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                                                }
                                                else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                                                    $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                                                }*/
                                                var precision = $(this).attr("precision");
                                                calculate($(this), precision);
                                                if (precision == 3) {
                                                    $(this).attr("lay-verify", "required|three");
                                                }
                                                else if (data.value == 2) {
                                                    $(this).attr("lay-verify", "required|two");
                                                }
                                                else if (data.value == 1) {
                                                    $(this).attr("lay-verify", "required|one");
                                                }
                                                else if (data.value == 0) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                }
                                                else if (data.value == -1) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                    $(this).attr("step", 10);
                                                }
                                                else if (data.value == -2) {
                                                    $(this).attr("lay-verify", "required|isNumber");
                                                    $(this).attr("step", 100);
                                                }
                                            });
                                        });
                                    });
                                    $("input[name='isReceivableGJ']").each(function(){
                                        $(this).removeAttr("disabled");
                                        // 代理 选择是  且不可修改
                                        if($(this).val() == business.memberBusinessItem.isReceivable){
                                            $(this).attr("checked","checked");
                                        }
                                    })

                                    $("input[name=ratioGJ]").on("blur", function () {
                                        if(!(/^[0-9]+$/.test($(this).val()))){
                                            $(this).val("");
                                        }
                                        /*if ($(this).val() <= 0) {
                                            $(this).val(1);
                                        }*/
                                    });
                                    $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").hide();

                                    $("input[name=baseNumberRadioGJ]").parent().parent().show();
                                    $("input[name=baseNumberGJ]").parent().parent().show();

                                    $("#GJDiv").find("select[name=organizationGJId]").removeAttr("lay-verify");
                                    $("#GJDiv").find("select[name=transactorGJId]").removeAttr("lay-verify");
                                }
                                else if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan == null){
                                    $("#GJDiv").find("select[name=transactorGJId]").attr("lay-verify", "required");
                                    html += '<input type="radio" lay-filter="radioFilterGJJ" value="0" name="businessMethodGJJ" title="代理" checked>';
                                    getPayPlaceByType(business.memberBusinessItem.payPlaceId, "payPlaceGJ", "post", null, 1);
                                    getOrganizationByPayPlace(business.memberBusinessItem.organizationId, "organizationGJ", "post", null, business.memberBusinessItem.payPlaceId);
                                    $("#organizationGJ").parent().parent().show();
                                    getTransactorByOrganization(business.memberBusinessItem.transactorId, "transactorGJ", "post", null, business.memberBusinessItem.organizationId);
                                    $("#transactorGJ").parent().parent().show();
                                    AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : business.memberBusinessItem.organizationId} , function(result) {
                                        $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                                        $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                                        $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                                        if (business.memberBusinessItem.baseType < 2) {
                                            $("input[name=baseNumberGJ]").prop("readonly", true);
                                        }
                                        $("input[name=baseNumberRadioGJ]").eq(business.memberBusinessItem.baseType).prop("checked", true);
                                        $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                                        $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);
                                        if (business.memberBusinessItem.baseType == 0) {
                                            $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                                        }
                                        else if (business.memberBusinessItem.baseType == 1) {
                                            $("input[name=baseNumberGJ]").val(result.data.maxCardinalNumber);
                                        }
                                        else {
                                            $("input[name=baseNumberGJ]").val(business.memberBusinessItem.baseNumber);
                                        }
                                        $("input[name=baseNumberGJ]").on("blur", function () {
                                            /*if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                                                $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                                            }
                                            else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                                                $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                                            }*/
                                            var precision = $(this).attr("precision");
                                            calculate($(this), precision);
                                            if (precision == 3) {
                                                $(this).attr("lay-verify", "required|three");
                                            }
                                            else if (data.value == 2) {
                                                $(this).attr("lay-verify", "required|two");
                                            }
                                            else if (data.value == 1) {
                                                $(this).attr("lay-verify", "required|one");
                                            }
                                            else if (data.value == 0) {
                                                $(this).attr("lay-verify", "required|isNumber");
                                            }
                                            else if (data.value == -1) {
                                                $(this).attr("lay-verify", "required|isNumber");
                                                $(this).attr("step", 10);
                                            }
                                            else if (data.value == -2) {
                                                $(this).attr("lay-verify", "required|isNumber");
                                                $(this).attr("step", 100);
                                            }
                                        });
                                    });
                                    $("input[name=baseNumberRadioGJ]").parent().parent().show();
                                    $("input[name=baseNumberGJ]").parent().parent().show();
                                    $("input[name='isReceivableGJ']").each(function(){
                                        // 代理 选择是  且不可修改
                                        if($(this).val() == 0){
                                            $(this).attr("checked",false);
                                            $(this).attr("disabled",true);
                                        }
                                        if($(this).val() == 1){
                                            $(this).attr("checked","checked");
                                            $(this).removeAttr("disabled");
                                        }
                                    })
                                    AM.ajaxRequestData("post", false, AM.ip + "/organization/countByOrganization", {organizationId : business.memberBusinessItem.organizationId} , function(result) {
                                        if (result.data != undefined) {
                                            $("input[name=ratioGJ]").attr("min", result.data.min);
                                            $("input[name=ratioGJ]").attr("max", result.data.max);
                                            $("#ratioMinGJ").html(result.data.min);
                                            $("#ratioMaxGJ").html(result.data.max);
                                           /* $("input[name=ratioGJ]").on("blur", function () {
                                                if ($(this).val() > Number($("input[name=ratioGJ]").attr("max"))) {
                                                    $(this).val(Number($("input[name=ratioGJ]").attr("max")));
                                                }
                                                else if ($(this).val() < Number($("input[name=ratioGJ]").attr("min"))) {
                                                    $(this).val(Number($("input[name=ratioGJ]").attr("min")));
                                                }
                                            });*/
                                        }
                                    });
                                    $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").show();
                                }
                                $("#GJJServiceDiv").html(html);
                            }
                        }
                    });
                    $("input[name=ratioGJ]").val(business.memberBusinessItem.ratio);

                    getCompanySonBillByCompany(business.companySonBillId, "companySonBillIdGJ", 0, $scope.member.companyId); // 获取子账单

                    $("#serviceStartTimeGJ").val(new Date(business.memberBusinessItem.serviceStartTime).format("yyyyMM"));
                    if (business.memberBusinessItem.serviceEndTime != null && business.memberBusinessItem.serviceEndTime != "") {
                        $("#serviceEndTimeGJ").val(new Date(business.memberBusinessItem.serviceEndTime).format("yyyyMM"));
                    }
                    $("#billStartTimeGJ").val(new Date(business.memberBusinessItem.billStartTime).format("yyyyMM"));

                    $("#GJDiv").show("fast");
                    form.render();

                }
                else if (business.id == 6) { // 商业险
                    $("input[name=businessArr]").each(function () {
                        if ($(this).val() == business.id) {
                            $(this).click();
                            var businessList = JSON.parse($(this).attr("objstr"));
                            AM.log(businessList);
                            var html = "";
                            for (var i = 0; i < businessList.businessItems.length; i++) {
                                var items = businessList.businessItems[i];
                                var optionHtml = "";
                                for (var j = 0; j < business.businessItems.length; j++) {
                                    var obj = business.businessItems[j];
                                    if (items.id == obj.id) {
                                        optionHtml = getCompanySonBillByCompanyHTML(obj.companySonBillId, $("#companyId").val());
                                        break;
                                    }
                                    else {
                                        optionHtml = getCompanySonBillByCompanyHTML(0, $("#companyId").val());
                                    }
                                }
                                var msg = items.chargeMethod == 0 ? "按年" : "按月";
                                html += '<div class="layui-form-item">' +
                                        '   <div class="layui-input-block" style="margin-left: 10px;">' +
                                        '       <input type="checkbox" value="' + items.id + '" name="business" title="' + items.itemName + '" lay-filter="radioFilterSY">' +
                                        '       <span style="color: red;padding: 5px;">价格：' + items.price + '</span>' +
                                        '       <span style="padding: 5px;color: #666;" class="layui-badge layui-bg-gray">' + msg + '</span>' +
                                        '   </div>' +
                                        '   <div class="layui-input-block" style="padding-top: 10px;margin-left: -150px">' +
                                        '       <div class="layui-form-item">' +
                                        '           <label class="layui-form-label">所属子账单<span class="font-red">*</span></label>' +
                                        '           <div class="layui-input-inline" style="width: 200px;">' +
                                        '               <select name="businessCompanySonBillIdSY">' +
                                        '                   <option value="">请选择</option>' +
                                        optionHtml +
                                        '               </select>' +
                                        '           </div>' +
                                        '       </div>' +
                                        '   </div>' +
                                        '</div>';
                            }
                            if (businessList.businessItems.length != 0) {
                                $("#SYXDiv").find("#SYXDivInline").html(html);
                                $("#SYXDiv").find("input[name=business]").each(function () {
                                    for (var j = 0; j < business.businessItems.length; j++) {
                                        var obj = business.businessItems[j];
                                        if ($(this).val() == obj.id) {
                                            $(this).prop("checked", true);
                                        }
                                    }
                                });
                            }
                            else {
                                $("#SYXDiv").find("#SYXDivInline").html("暂无");
                            }
                        }
                    });
                    $("#SYXDiv").show("fast");
                    form.render();

                }
                else if (business.id == 7) { // 一次性业务
                    $("input[name=businessArr]").each(function () {
                        if ($(this).val() == business.id) {
                            $(this).click();
                            var businessList = JSON.parse($(this).attr("objstr"));
                            AM.log(businessList);
                            var html = "";
                            for (var i = 0; i < businessList.businessItems.length; i++) {
                                var items = businessList.businessItems[i];
                                var optionHtml = "";
                                for (var j = 0; j < business.businessItems.length; j++) {
                                    var obj = business.businessItems[j];
                                    if (items.id == obj.id) {
                                        optionHtml = getCompanySonBillByCompanyHTML(obj.companySonBillId, $("#companyId").val());
                                        break;
                                    }
                                    else {
                                        optionHtml = getCompanySonBillByCompanyHTML(0, $("#companyId").val());
                                    }
                                }
                                if (items.isCompany == 1) {
                                    html += '<div class="layui-form-item">' +
                                            '   <div class="layui-input-block" style="margin-left: 10px;">' +
                                            '       <input type="checkbox" value="' + items.id + '" name="business" title="' + items.itemName + '" lay-filter="radioFilterYCX">' +
                                            '       <span style="color: red;padding: 5px;">价格：' + items.price + '</span>' +
                                            '   </div>' +
                                            '   <div class="layui-input-block" style="padding-top: 10px;margin-left: -150px">' +
                                            '       <div class="layui-form-item">' +
                                            '           <label class="layui-form-label">所属子账单<span class="font-red">*</span></label>' +
                                            '           <div class="layui-input-inline" style="width: 200px;">' +
                                            '               <select name="businessCompanySonBillIdYCX">' +
                                            '                   <option value="">请选择</option>' +
                                            optionHtml  +
                                            '               </select>' +
                                            '           </div>' +
                                            '       </div>' +
                                            '   </div>' +
                                            '</div>';
                                }
                            }
                            if (businessList.businessItems.length != 0) {
                                $("#YCXDiv").find("#YCXDivInline").html(html);
                                $("#YCXDiv").find("input[name=business]").each(function () {
                                    for (var j = 0; j < business.businessItems.length; j++) {
                                        var obj = business.businessItems[j];
                                        if ($(this).val() == obj.id) {
                                            $(this).prop("checked", true);
                                        }
                                    }
                                });

                            }
                            else {
                                $("#YCXDiv").find("#YCXDivInline").html("暂无");
                            }
                        }
                    });
                    $("#YCXDiv").show("fast");
                    form.render();
                }
            }

            /**工资**/
            if ($scope.member.memberSalary != null) {
                selectProvinceAndCity($scope.member.memberSalary.cityId, "cityIdGZ"); //省
                $("input[name=businessArr]").each(function () {
                    if ($(this).val() == 5) {
                        $(this).click();
                    }
                });
                getCompanySonBillByCompany($scope.member.memberSalary.companySonBillId, "companySonBillIdGZ", 0, $scope.member.companyId); // 获取子账单
                $("select[name=nationality] option").each(function () {
                    if ($(this).val() == $scope.member.memberSalary.nationality) {
                        $(this).prop("selected", true);
                    }
                });
                $("#GZDiv").find("input[name=bankName]").val($scope.member.memberSalary.bankName);
                $("#GZDiv").find("input[name=bankAccount]").val($scope.member.memberSalary.bankAccount);
                //$("#GZDiv").find("input[name=phoneNumber]").val($scope.member.memberSalary.phoneNumber);
                //必填工资
                $("#GZDiv").find("select[name=nationality]").attr("lay-verify", "required");
//                $("#GZDiv").find("select[name=cityIdGZ]").attr("lay-verify", "required");
                $("#GZDiv").find("input[name=bankAccount]").attr("lay-verify", "required");
                $("#GZDiv").find("input[name=bankName]").attr("lay-verify", "required");
                $("#GZDiv").show("fast");
            }
            form.render();

            /**监听合作状态**/
            form.on('radio(stateCooperation)', function (data) {
                if (data.value == 0) {
                    $("#businessBigDiv").find("input[name=businessArr]").prop("checked", false);
                    // 如果是社保
                    $("#sheBaoDiv").hide("fast");
                    // 如果是 公积金
                    $("#GJDiv").hide("fast");
                    // 如果是工资
                    $("#GZDiv").hide("fast");
                    //商业险
                    $("#SYXDiv").hide("fast");
                    //一次性业务
                    $("#YCXDiv").hide("fast");

                    //删除社保
                    $("#sheBaoDiv").find("select").removeAttr("lay-verify");
                    $("#sheBaoDiv").find("input[type=text]").removeAttr("lay-verify");
                    $("#sheBaoDiv").find("input[type=number]").removeAttr("lay-verify");
                    //删除公积金
                    $("#GJDiv").find("select").removeAttr("lay-verify");
                    $("#GJDiv").find("input[type=text]").removeAttr("lay-verify");
                    $("#GJDiv").find("input[type=number]").removeAttr("lay-verify");
                    //删除工资
                    $("#GZDiv").find("select[name=nationality]").removeAttr("lay-verify");
                    $("#GZDiv").find("input[name=bankAccount]").removeAttr("lay-verify");
                    $("#GZDiv").find("input[name=bankName]").removeAttr("lay-verify");

                    form.render();
                }
            });
            //监听合作方式
            form.on('select(waysOfCooperation)', function (data) {
                if (data.value == 0) {
                    $("#startTime").removeAttr("lay-verify").parent().parent().hide();
                    $("#endTime").removeAttr("lay-verify").parent().parent().hide();
                }
                else {
                    $("#startTime").attr("lay-verify", "required").parent().parent().show();
                    $("#endTime").attr("lay-verify", "required").parent().parent().show();
                }
                form.render();

            });
            /**监听方法**/
            //监听公司
            form.on('select(companyId)', function (data) {
                buildBusinessInputByCompany(0, "businessDiv", "post", null, data.value);
                getCompanySonBillByCompany(0, "companySonBillIdSB", 0, data.value); // 获取子账单
                getCompanySonBillByCompany(0, "companySonBillIdGJ", 0, data.value); // 获取子账单
                getCompanySonBillByCompany(0, "companySonBillIdGZ", 0, data.value); // 获取子账单
                $("#businessBigDiv").show("fast");
                // 如果是社保
                $("#sheBaoDiv").hide("fast");
                // 如果是 公积金
                $("#GJDiv").hide("fast");
                // 如果是工资
                $("#GZDiv").hide("fast");
                //商业险
                $("#SYXDiv").hide("fast");
                //一次性业务
                $("#YCXDiv").hide("fast");

                //删除社保
                $("#sheBaoDiv").find("select").removeAttr("lay-verify");
                $("#sheBaoDiv").find("input[type=text]").removeAttr("lay-verify");
                $("#sheBaoDiv").find("input[type=number]").removeAttr("lay-verify");
                //删除公积金
                $("#GJDiv").find("select").removeAttr("lay-verify");
                $("#GJDiv").find("input[type=text]").removeAttr("lay-verify");
                $("#GJDiv").find("input[type=number]").removeAttr("lay-verify");
                //删除工资
                $("#GZDiv").find("select[name=nationality]").removeAttr("lay-verify");
                $("#GZDiv").find("input[name=bankAccount]").removeAttr("lay-verify");
                $("#GZDiv").find("input[name=bankName]").removeAttr("lay-verify");

                form.render();
            });

            //监听缴金地 -- 社保
            form.on('select(payPlaceFilter)', function (data) {
                var businessMethodSS = $("input[name='businessMethodSS']:checked").val();
                if(businessMethodSS == 0){
                    // 代理
                    getOrganizationByPayPlace(0, "organization", "post", 0, data.value);
                    getInsuranceLevelByPayPlace(0, "insuranceLevel", "post", 0, data.value, 0);

                    $("#organization").parent().parent().show();
                    $("#insuranceLevel").parent().parent().show();

                    $("input[name=baseNumberRadio]").parent().parent().hide();
                    $("input[name=baseNumber]").parent().parent().hide();
                    $("#transactor").parent().parent().hide();
                }else{
                    // 托管
                    getInsuranceLevelByPayPlace(0, "insuranceLevel", "post", 0, $(data.elem[data.elem.selectedIndex]).attr("payplaceid"), 1);
                    $("#insuranceLevel").parent().parent().show();
                }
                form.render();
            });
            //监听经办机构 -- 社保
            form.on('select(organizationFilter)', function (data) {
                getTransactorByOrganization(0, "transactor", "post", null, data.value);
                $("#transactor").parent().parent().show();
                form.render();
            });
            //监听档次--社保
            form.on('select(insuranceLevel)', function (data) {
                AM.ajaxRequestData("post", false, AM.ip + "/payTheWay/countPayTheWay", {levelId : data.value} , function(result) {
                    $("input[name=baseNumber]").val(result.data.min);
                    $("input[name=baseNumber]").attr("min", result.data.min);
                    $("input[name=baseNumber]").attr("max", result.data.max);
                    $("#baseNumberMin").html(result.data.min);
                    $("#baseNumberMax").html(result.data.max);
                    $("input[name=baseNumberRadio]").eq(0).prop("checked", true);

                    $("input[name=baseNumber]").on("blur", function () {
                        /*if ($(this).val() > Number($("input[name=baseNumber]").attr("max"))) {
                            $(this).val(Number($("input[name=baseNumber]").attr("max")));
                        }
                        else if ($(this).val() < Number($("input[name=baseNumber]").attr("min"))) {
                            $(this).val(Number($("input[name=baseNumber]").attr("min")));
                        }*/
                    });

                });
                $("input[name=baseNumberRadio]").parent().parent().show();
                $("input[name=baseNumber]").parent().parent().show();
                $("input[name=baseNumber]").prop("readonly", true);
                form.render();
            });
            //监听基数选择--社保
            form.on('radio(baseNumberRadio)', function (data) {
                if (data.value == 0) {
                    $("input[name=baseNumber]").val($("input[name=baseNumber]").attr("min")).prop("readonly", true);
                }
                else if (data.value == 1) {
                    $("input[name=baseNumber]").val($("input[name=baseNumber]").attr("max")).prop("readonly", true);
                }
                else if (data.value == 2) {
                    $("input[name=baseNumber]").prop("readonly", false);
                    $("input[name=baseNumber]").val("");
                }
                form.render();
            });
            //监听基数选择--公积金
            form.on('radio(baseNumberRadioGJ)', function (data) {
                if (data.value == 0) {
                    $("input[name=baseNumberGJ]").val($("input[name=baseNumberGJ]").attr("min")).prop("readonly", true);
                }
                else if (data.value == 1) {
                    $("input[name=baseNumberGJ]").val($("input[name=baseNumberGJ]").attr("max")).prop("readonly", true);
                }
                else if (data.value == 2) {
                    $("input[name=baseNumberGJ]").prop("readonly", false);
                    $("input[name=baseNumberGJ]").val("");
                }
                form.render();
            });

            //监听公积金缴金地
            form.on('select(payPlaceGJFilter)', function (data) {
                var businessMethodGJJ = $("input[name='businessMethodGJJ']:checked").val();
                if(businessMethodGJJ == 0){
                    // 代理
                    getOrganizationByPayPlace(0, "organizationGJ", "post", null, data.value);
                    $("#organizationGJ").parent().parent().show();
                    $("input[name=baseNumberRadioGJ]").parent().parent().hide();
                    $("input[name=baseNumberGJ]").parent().parent().hide();
                    $("#transactorGJ").parent().parent().hide();
                    $("#ratioMinGJ").html("");
                    $("#ratioMaxGJ").html("");
                }else{
                    // 托管
                    AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : $(data.elem[data.elem.selectedIndex]).attr("organizationId")} , function(result) {
                        $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                        $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                        $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                        $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                        $("input[name=baseNumberRadioGJ]").eq(0).prop("checked", true);
                        $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                        $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);
                        $("input[name=baseNumberGJ]").on("blur", function () {
                           /* if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                                $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                            }
                            else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                                $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                            }*/
                            var precision = $(this).attr("precision");
                            calculate($(this), precision);
                            if (precision == 3) {
                                $(this).attr("lay-verify", "required|three");
                            }
                            else if (data.value == 2) {
                                $(this).attr("lay-verify", "required|two");
                            }
                            else if (data.value == 1) {
                                $(this).attr("lay-verify", "required|one");
                            }
                            else if (data.value == 0) {
                                $(this).attr("lay-verify", "required|isNumber");
                            }
                            else if (data.value == -1) {
                                $(this).attr("lay-verify", "required|isNumber");
                                $(this).attr("step", 10);
                            }
                            else if (data.value == -2) {
                                $(this).attr("lay-verify", "required|isNumber");
                                $(this).attr("step", 100);
                            }
                        });
                    });
                    $("input[name=baseNumberRadioGJ]").parent().parent().show();
                    $("input[name=baseNumberGJ]").parent().parent().show();

                    //托管的比例
                    AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/info", {id : data.value} , function(result) {
                        console.log("-=-=-=-=-=-=");
                        console.log(result);
                        console.log("-=-=-=-=-=-=");
                        $("input[name=ratioGJ]").val(result.data.mePayPrice);
                        $("input[name=ratioGJ]").prop("readonly", true);
                    });

                    $("#ratioMinGJ").html("");
                    $("#ratioMaxGJ").html("");
                    $("input[name=ratioGJ]").removeAttr("min");
                    $("input[name=ratioGJ]").removeAttr("max");
                    $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").hide();
                    $("input[name=ratioGJ]").on("blur", function () {
                        if(!(/^[0-9]+$/.test($(this).val()))){
                            $(this).val("");
                        }
                        /*if ($(this).val() <= 0) {
                            $(this).val(1);
                        }*/
                    });

                    /*AM.ajaxRequestData("post", false, AM.ip + "/organization/countByOrganization", {organizationId : $(data.elem[data.elem.selectedIndex]).attr("organizationId")} , function(result) {
                        if (result.data != undefined) {
                            $("input[name=ratioGJ]").attr("min", result.data.min);
                            $("input[name=ratioGJ]").attr("max", result.data.max);
                            $("#ratioMinGJ").html(result.data.min);
                            $("#ratioMaxGJ").html(result.data.max);
                            $("input[name=ratioGJ]").on("blur", function () {
                                if ($(this).val() > Number($("input[name=ratioGJ]").attr("max"))) {
                                    $(this).val(Number($("input[name=ratioGJ]").attr("max")));
                                }
                                else if ($(this).val() < Number($("input[name=ratioGJ]").attr("min"))) {
                                    $(this).val(Number($("input[name=ratioGJ]").attr("min")));
                                }
                            });
                        }
                    });*/
                    $("input[name=ratioGJ]").parent().parent().show();
                }

                form.render();
            });
            //监听公积金经办机构
            form.on('select(organizationGJFilter)', function (data) {
                getTransactorByOrganization(0, "transactorGJ", "post", null, data.value);
                AM.ajaxRequestData("post", false, AM.ip + "/organization/getOrganizationById", {id : data.value} , function(result) {
                    $("input[name=baseNumberGJ]").val(result.data.minCardinalNumber);
                    $("input[name=baseNumberGJ]").attr("min", result.data.minCardinalNumber);
                    $("input[name=baseNumberGJ]").attr("max", result.data.maxCardinalNumber);
                    $("input[name=baseNumberGJ]").attr("precision", result.data.precision);
                    $("input[name=baseNumberRadioGJ]").eq(0).prop("checked", true);
                    $("#baseNumberMinGJ").html(result.data.minCardinalNumber);
                    $("#baseNumberMaxGJ").html(result.data.maxCardinalNumber);
                    $("input[name=baseNumberGJ]").on("blur", function () {
                        /*if ($(this).val() > Number($("input[name=baseNumberGJ]").attr("max"))) {
                            $(this).val(Number($("input[name=baseNumberGJ]").attr("max")));
                        }
                        else if ($(this).val() < Number($("input[name=baseNumberGJ]").attr("min"))) {
                            $(this).val(Number($("input[name=baseNumberGJ]").attr("min")));
                        }*/
                        var precision = $(this).attr("precision");
                        calculate($(this), precision);
                        if (precision == 3) {
                            $(this).attr("lay-verify", "required|three");
                        }
                        else if (data.value == 2) {
                            $(this).attr("lay-verify", "required|two");
                        }
                        else if (data.value == 1) {
                            $(this).attr("lay-verify", "required|one");
                        }
                        else if (data.value == 0) {
                            $(this).attr("lay-verify", "required|isNumber");
                        }
                        else if (data.value == -1) {
                            $(this).attr("lay-verify", "required|isNumber");
                            $(this).attr("step", 10);
                        }
                        else if (data.value == -2) {
                            $(this).attr("lay-verify", "required|isNumber");
                            $(this).attr("step", 100);
                        }

                    });
                });


                var businessMethodGJJ = $("input[name='businessMethodGJJ']:checked").val();
                if(businessMethodGJJ == 0){
                    AM.ajaxRequestData("post", false, AM.ip + "/organization/countByOrganization", {organizationId : data.value} , function(result) {
                        if (result.data != undefined) {
                            $("input[name=ratioGJ]").attr("min", result.data.min);
                            $("input[name=ratioGJ]").attr("max", result.data.max);
                            $("#ratioMinGJ").html(result.data.min);
                            $("#ratioMaxGJ").html(result.data.max);
                            $("input[name=ratioGJ]").on("blur", function () {
                                if(!(/^[0-9]+$/.test($(this).val()))){
                                    $(this).val("");
                                }
                                /*if ($(this).val() > Number($("input[name=ratioGJ]").attr("max"))) {
                                    $(this).val(Number($("input[name=ratioGJ]").attr("max")));
                                }
                                else if ($(this).val() < Number($("input[name=ratioGJ]").attr("min"))) {
                                    $(this).val(Number($("input[name=ratioGJ]").attr("min")));
                                }*/
                            });
                        }
                    });
                    $("input[name=ratioGJ]").prop("readonly", false);
                    $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").show();
                }
                else {
                    $("input[name=ratioGJ]").val("");
                    $("#ratioMinGJ").html("");
                    $("#ratioMaxGJ").html("");
                    $("input[name=ratioGJ]").removeAttr("min");
                    $("input[name=ratioGJ]").removeAttr("max");
                    $("input[name=ratioGJ]").parent().parent().find(".layui-word-aux").hide();
                    $("input[name=ratioGJ]").on("blur", function () {
                        if(!(/^[0-9]+$/.test($(this).val()))){
                            $(this).val("");
                        }
                        /*if ($(this).val() <= 0) {
                            $(this).val(1);
                        }*/
                    });
                }

                $("input[name=ratioGJ]").parent().parent().show();
                $("#transactorGJ").parent().parent().show();
                $("input[name=baseNumberRadioGJ]").parent().parent().show();
                $("input[name=baseNumberGJ]").parent().parent().show();
                form.render();
            });
            //监听业务选择
            form.on('checkbox(boxChecked)', function (data) {

                if (data.elem.checked) {
                    $("input[name=stateCooperation]").eq(1).prop("checked", true);
                    // 如果选中
                    var obj = JSON.parse($(data.elem).attr("objStr"));
                    if (data.value == 3) {
                        // 如果是社保
                        //必填社保
                        $("#sheBaoDiv").find("select").attr("lay-verify", "required");
                        $("#sheBaoDiv").find("input[type=text]").attr("lay-verify", "required");
                        $("#sheBaoDiv").find("input[type=number]").attr("lay-verify", "required");
                        $("#sheBaoDiv").find("input[name=serviceEndTime]").removeAttr("lay-verify");
                        // 设置社保服务方式
                        if(null != obj.businessMethod){
                            var html = "";
                            if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan != null){
                                html += '<input type="radio" lay-filter="radioFilter" value="0" name="businessMethodSS" title="代理" checked>';
                                html += '<input type="radio" lay-filter="radioFilter" value="1" name="businessMethodSS" title="托管">';
                                $("input[name='isReceivable']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked",false);
                                        $(this).attr("disabled",true);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked","checked");
                                    }
                                })
                                // 获取缴金地
                                getPayPlaceByType(0, "payPlace", "post", null, 0);
                            }
                            else if(obj.businessMethod.daiLi == null && obj.businessMethod.tuoGuan != null){
                                html += '<input type="radio" lay-filter="radioFilter" value="1" name="businessMethodSS" title="托管" checked>';
                                $("input[name='isReceivable']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked","checked");
                                        $(this).attr("disabled",false);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked",false);
                                    }
                                })
                                // 获取缴金地
                                getCompanyPayPlaceByType(0,"payPlace","post",0,0,$("#companyId").val());
                                $("#sheBaoDiv").find("select[name=organizationId]").removeAttr("lay-verify");
                                $("#sheBaoDiv").find("select[name=transactorId]").removeAttr("lay-verify");
                            }
                            else if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan == null){
                                html += '<input type="radio" lay-filter="radioFilter" value="0" name="businessMethodSS" title="代理" checked>';
                                $("input[name='isReceivable']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked",false);
                                        $(this).attr("disabled",true);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked","checked");
                                    }
                                })
                                // 获取缴金地
                                getPayPlaceByType(0, "payPlace", "post", null, 0);
                            }
                            $("#SSServiceDiv").html(html);
                        }

                        $("#sheBaoDiv").show("fast");
                        getCompanySonBillByCompany(0, "companySonBillIdSB", 0, $("#companyId").val()); // 获取子账单
                    } else if (data.value == 4) {
                        // 如果是 公积金
                        //必填公积金
                        $("#GJDiv").find("select").attr("lay-verify", "required");
                        $("#GJDiv").find("input[type=text]").attr("lay-verify", "required");
                        $("#GJDiv").find("input[type=number]").attr("lay-verify", "required");
                        $("#GJDiv").find("input[name=serviceEndTimeGJ]").removeAttr("lay-verify");
                        // 设置社保服务方式
                        if(null != obj.businessMethod){
                            var html = "";
                            if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan != null){
                                html += '<input type="radio" lay-filter="radioFilterGJJ" value="0" name="businessMethodGJJ" title="代理" checked>';
                                html += '<input type="radio" lay-filter="radioFilterGJJ" value="1" name="businessMethodGJJ" title="托管">';
                                $("input[name='isReceivableGJ']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked",false);
                                        $(this).attr("disabled",true);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked","checked");
                                    }
                                })
                                getPayPlaceByType(0, "payPlaceGJ", "post", null, 1);
                            }
                            else if(obj.businessMethod.daiLi == null && obj.businessMethod.tuoGuan != null){
                                html += '<input type="radio" lay-filter="radioFilterGJJ" value="1" name="businessMethodGJJ" title="托管" checked>';
                                $("input[name='isReceivableGJ']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked","checked");
                                        $(this).attr("disabled",false);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked",false);
                                    }
                                })
                                // 获取缴金地
                                getCompanyPayPlaceByType(0,"payPlaceGJ","post",0,1,$("#companyId").val());
                                $("#GJDiv").find("select[name=organizationGJId]").removeAttr("lay-verify");
                                $("#GJDiv").find("select[name=transactorGJId]").removeAttr("lay-verify");
                            }
                            else if(obj.businessMethod.daiLi != null && obj.businessMethod.tuoGuan == null){
                                html += '<input type="radio" lay-filter="radioFilterGJJ" value="0" name="businessMethodGJJ" title="代理" checked>';
                                $("input[name='isReceivableGJ']").each(function(){
                                    // 代理 选择是  且不可修改
                                    if($(this).val() == 0){
                                        $(this).attr("checked",false);
                                        $(this).attr("disabled",true);
                                    }
                                    if($(this).val() == 1){
                                        $(this).attr("checked","checked");
                                    }
                                })
                                getPayPlaceByType(0, "payPlaceGJ", "post", null, 1);
                            }
                            $("#GJJServiceDiv").html(html);
                            getCompanySonBillByCompany(0, "companySonBillIdGJ", 0, $("#companyId").val()); // 获取子账单
                        }

                        $("#GJDiv").show("fast");
                    } else if (data.value == 5) {
                        // 如果是工资
                        selectProvinceAndCity(0, "cityIdGZ"); //省
                        //必填工资
                        $("#GZDiv").find("select[name=nationality]").attr("lay-verify", "required");
//                        $("#GZDiv").find("select[name=cityIdGZ]").attr("lay-verify", "required");
                        $("#GZDiv").find("input[name=bankAccount]").attr("lay-verify", "required");
                        $("#GZDiv").find("input[name=bankName]").attr("lay-verify", "required");

                        $("#GZDiv").show("fast");
                        getCompanySonBillByCompany(0, "companySonBillIdGZ", 0, $("#companyId").val()); // 获取子账单
                    } else if (data.value == 6) {
                        // 如果是商业险
                        var businessList = JSON.parse(data.elem.getAttribute("objstr"));
                        AM.log("------");
                        AM.log(businessList);
                        AM.log("-----------");
                        var html = "";
                        for (var i = 0; i < businessList.businessItems.length; i++) {
                            var business = businessList.businessItems[i];
                            var msg = business.chargeMethod == 0 ? "按年" : "按月";
                            html += '<div class="layui-form-item">' +
                                    '   <div class="layui-input-block" style="margin-left: 0px;">' +
                                    '       <input type="checkbox" value="' + business.id + '" name="business" title="' + business.itemName + '" lay-filter="radioFilterSY">' +
                                    '       <span style="color: red;padding: 5px;">价格：' + business.price + '</span>' +
                                    '       <span style="padding: 5px;color: #666;" class="layui-badge layui-bg-gray">' + msg + '</span>' +
                                    '   </div>' +
                                    '   <div class="layui-input-block" style="padding-top: 10px;margin-left: -150px">' +
                                    '       <div class="layui-form-item">' +
                                    '           <label class="layui-form-label">所属子账单<span class="font-red">*</span></label>' +
                                    '           <div class="layui-input-inline" style="width: 200px;">' +
                                    '               <select name="businessCompanySonBillIdSY">' +
                                    '                   <option value="">请选择</option>' +
                                    getCompanySonBillByCompanyHTML(0, $("#companyId").val()) +
                                    '               </select>' +
                                    '           </div>' +
                                    '       </div>' +
                                    '   </div>' +
                                    '</div>';
                        }
                        if (businessList.businessItems.length != 0) {
                            $("#SYXDiv").find("#SYXDivInline").html(html);
                        }
                        else {
                            $("#SYXDiv").find("#SYXDivInline").html("暂无");
                        }

                        $("#SYXDiv").show("fast");
                    } else if (data.value == 7) {
                        // 如果是一次性业务
                        var businessList = JSON.parse(data.elem.getAttribute("objstr"));
                        AM.log(businessList);
                        var html = "";
                        for (var i = 0; i < businessList.businessItems.length; i++) {
                            var business = businessList.businessItems[i];
                            if (business.isCompany == 1) {
                                html += '<div class="layui-form-item">' +
                                        '   <div class="layui-input-block" style="margin-left: 0px;">' +
                                        '       <input type="checkbox" value="' + business.id + '" name="business" title="' + business.itemName + '" lay-filter="radioFilterYCX">' +
                                        '       <span style="color: red;padding: 5px;">价格：' + business.price + '</span>' +
                                        '   </div>' +
                                        '   <div class="layui-input-block" style="padding-top: 10px;margin-left: -150px">' +
                                        '       <div class="layui-form-item">' +
                                        '           <label class="layui-form-label">所属子账单<span class="font-red">*</span></label>' +
                                        '           <div class="layui-input-inline" style="width: 200px;">' +
                                        '               <select name="businessCompanySonBillIdYCX">' +
                                        '                   <option value="">请选择</option>' +
                                        getCompanySonBillByCompanyHTML(0, $("#companyId").val()) +
                                        '               </select>' +
                                        '           </div>' +
                                        '       </div>' +
                                        '   </div>' +
                                        '</div>';
                            }
                        }
                        if (businessList.businessItems.length != 0) {
                            $("#YCXDiv").find("#YCXDivInline").html(html);
                        }
                        else {
                            $("#YCXDiv").find("#YCXDivInline").html("暂无");
                        }
                        $("#YCXDiv").show("fast");
                    }
                } else {
                    // 如果取消选中
                    if (data.value == 3) {
                        // 如果是社保
                        $("#sheBaoDiv").hide("fast");
                        $("#sheBaoDiv").find("select").removeAttr("lay-verify");
                        $("#sheBaoDiv").find("input[type=text]").removeAttr("lay-verify");
                        $("#sheBaoDiv").find("input[type=number]").removeAttr("lay-verify");
                    } else if (data.value == 4) {
                        // 如果是 公积金
                        $("#GJDiv").hide("fast");
                        $("#GJDiv").find("select").removeAttr("lay-verify");
                        $("#GJDiv").find("input[type=text]").removeAttr("lay-verify");
                        $("#GJDiv").find("input[type=number]").removeAttr("lay-verify");
                    } else if (data.value == 5) {
                        // 如果是工资
                        $("#GZDiv").hide("fast");
                        $("#GZDiv").find("select[name=nationality]").removeAttr("lay-verify");
                        $("#GZDiv").find("select[name=cityIdGZ]").removeAttr("lay-verify");
                        $("#GZDiv").find("input[name=bankAccount]").removeAttr("lay-verify");
                        $("#GZDiv").find("input[name=bankName]").removeAttr("lay-verify");
                    } else if (data.value == 6) {
                        // 如果是商业险
                        $("#SYXDiv").hide("fast");
                    } else if (data.value == 7) {
                        // 如果是一次性业务
                        $("#YCXDiv").hide("fast");
                    }

                    var bool = false;
                    $("input[name=businessArr]").each(function () {
                        if ($(this).is(":checked")) {
                            bool = true;
                        }
                    });
                    if (!bool) {
                        $("input[name=stateCooperation]").eq(0).prop("checked", true);
                    }
                }


                form.render();
            });

            //社保--社保服务方式
            form.on('radio(radioFilter)', function(data){
                if(data.value == 0){
                    $("#payPlaceHintSB").html("选择缴金地");
                    // 代理
                    $("input[name='isReceivable']").each(function(){
                        // 代理 选择是  且不可修改
                        if($(this).val() == 0){
                            $(this).attr("checked",false);
                            $(this).attr("disabled",true);
                        }
                        if($(this).val() == 1){
                            $(this).prop("checked",true);
                        }
                    })
                    // 获取 供应商 缴金地
                    getPayPlaceByType(0, "payPlace", "post", null, 0);
                }else{
                    $("#payPlaceHintSB").html("选择办理方");
                    $("input[name='isReceivable']").each(function(){
                        if($(this).val() == 0){
                            $(this).prop("checked",true);
                            $(this).attr("disabled",false);
                        }
                        if($(this).val() == 1){
                            $(this).attr("checked",false);
                        }
                    })
                    // 获取 客户 缴金地
                    getCompanyPayPlaceByType(0,"payPlace","post",0,0,$("#companyId").val());
                    // 其他下拉框隐藏
                    $("#organization").parent().parent().hide("fast");
                    $("#transactor").parent().parent().hide("fast");
                    $("#organization").removeAttr("lay-verify");
                    $("#transactor").removeAttr("lay-verify");

                }
                $("#insuranceLevel").parent().parent().hide("fast");
                $("#insuranceLevel").removeAttr("lay-verify");
                $("input[name=baseNumberRadio]").parent().parent().hide();
                $("input[name=baseNumber]").parent().parent().hide();
                $("input[name=baseNumber]").removeAttr("lay-verify");
                form.render();
            });

            //公积金--社保服务方式
            form.on('radio(radioFilterGJJ)', function(data){
                if(data.value == 0){
                    $("#payPlaceHintGJ").html("选择缴金地");
                    // 代理
                    $("input[name='isReceivableGJ']").each(function(){
                        // 代理 选择是  且不可修改
                        if($(this).val() == 0){
                            $(this).attr("checked",false);
                            $(this).attr("disabled",true);
                        }
                        if($(this).val() == 1){
                            $(this).prop("checked",true);
                        }
                    })
                    // 获取 供应商 缴金地
                    getPayPlaceByType(0, "payPlaceGJ", "post", null, 1);
                }else{
                    $("#payPlaceHintGJ").html("选择办理方");
                    $("input[name='isReceivableGJ']").each(function(){
                        if($(this).val() == 0){
                            $(this).prop("checked",true);
                            $(this).attr("disabled",false);
                        }
                        if($(this).val() == 1){
                            $(this).attr("checked",false);
                        }
                    })
                    // 获取 客户 缴金地
                    getCompanyPayPlaceByType(0,"payPlaceGJ","post",0,1,$("#companyId").val());
                    // 其他下拉框隐藏
                    $("#organizationGJ").parent().parent().hide("fast");
                    $("#transactorGJ").parent().parent().hide("fast");
                    $("#organizationGJ").removeAttr("lay-verify");
                    $("#transactorGJ").removeAttr("lay-verify");
                }
                $("input[name=ratioGJ]").removeAttr("lay-verify");
                $("input[name=ratioGJ]").parent().parent().hide();
                $("input[name=baseNumberRadioGJ]").parent().parent().hide("fast");
                $("input[name=baseNumberGJ]").parent().parent().hide("fast");
                $("input[name=baseNumberGJ]").removeAttr("lay-verify");
                form.render();
            });

            //监听省
            form.on('select(province)', function (data) {
                selectCity(data.value);
                form.render();
            });

            form.on("radio(certificateType)", function (data) {
                if (data.value == 0) {
                    $("input[name=certificateNum]").attr("lay-verify", "required|isIdCard");
                }
                else {
                    $("input[name=certificateNum]").attr("lay-verify", "required");
                }
            });

            //商业业务勾选监听器
            form.on("checkbox(radioFilterSY)", function (data) {
                if (data.elem.checked) {
                    $(data.elem).parent().parent().find("select[name=businessCompanySonBillIdSY]").attr("lay-verify", "required");
                }
                else {
                    $(data.elem).parent().parent().find("select[name=businessCompanySonBillIdSY]").remove("lay-verify");
                }
            });

            //一次性业务勾选监听器
            form.on("checkbox(radioFilterYCX)", function (data) {
                if (data.elem.checked) {
                    $(data.elem).parent().parent().find("select[name=businessCompanySonBillIdYCX]").attr("lay-verify", "required");
                }
                else {
                    $(data.elem).parent().parent().find("select[name=businessCompanySonBillIdYCX]").remove("lay-verify");
                }
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.id = $scope.id;
                if (data.field.leaveOfficeTime == "" || data.field.leaveOfficeTime == null) {
                    delete data.field.leaveOfficeTime;
                }
                else {
                    data.field.leaveOfficeTime = new Date(data.field.leaveOfficeTime);
                }
                if (data.field.waysOfCooperation != 0) {
                    data.field.contractStartTime = new Date(data.field.contractStartTime);
                    data.field.contractEndTime = new Date(data.field.contractEndTime);
                }
                else {
                    delete data.field.contractStartTime;
                    delete data.field.contractEndTime;
                }

                var jsonArr = [];
                if ($("#sheBaoDiv").find("input[name=baseNumber]").attr("lay-verify") == "required") {
                    if ($("#sheBaoDiv").find("input[name=baseNumber]").val() > Number($("#sheBaoDiv").find("input[name=baseNumber]").attr("max"))) {
                        layer.msg('基数填写不能大于最高基数', {icon: 2, anim: 6});
                        return false;
                    }
                    else if ($("#sheBaoDiv").find("input[name=baseNumber]").val() < Number($("#sheBaoDiv").find("input[name=baseNumber]").attr("min"))) {
                        layer.msg('基数填写不能小于最低基数', {icon: 2, anim: 6});
                        return false;
                    }
                }

                if ($("#GJDiv").find("input[name=baseNumberGJ]").attr("lay-verify") == "required") {
                    if ($("#GJDiv").find("input[name=baseNumberGJ]").val() > Number($("#GJDiv").find("input[name=baseNumberGJ]").attr("max"))) {
                        layer.msg('基数填写不能小于最低基数', {icon: 2, anim: 6});
                        return false;
                    }
                    else if ($("#GJDiv").find("input[name=baseNumberGJ]").val() < Number($("#GJDiv").find("input[name=baseNumberGJ]").attr("min"))) {
                        layer.msg('基数填写不能大于最高基数', {icon: 2, anim: 6});
                        return false;
                    }
                }
                if ($("#GJDiv").find("input[name=ratioGJ]").attr("lay-verify") == "required") {
                    if ($("#GJDiv").find("input[name=ratioGJ]").val() > Number($("#GJDiv").find("input[name=ratioGJ]").attr("max"))) {
                        layer.msg('请输入(' + $("#ratioMinGJ").html() + '-' + $("#ratioMaxGJ").html() + ')之间', {icon: 2, anim: 6});
                        return false;
                    }
                    else if ($("#GJDiv").find("input[name=ratioGJ]").val() < Number($("#GJDiv").find("input[name=ratioGJ]").attr("min"))) {
                        layer.msg('请输入(' + $("#ratioMinGJ").html() + '-' + $("#ratioMaxGJ").html() + ')之间', {icon: 2, anim: 6});
                        return false;
                    }
                }

                $("input[name=businessArr]").each(function () {
                    var value = $(this).val();
                    var checked = $(this).is(':checked');
                    if (value == 3 && checked) {// 如果是社保
                        var $sheBaoDiv = $("#sheBaoDiv");
                        var organizationId = $sheBaoDiv.find("select[name=organizationId]").val()
                        var transactorId = $sheBaoDiv.find("select[name=transactorId]").val()
                        if ($sheBaoDiv.find("input[name=businessMethodSS]:checked").val() == 1) {
                            organizationId = null;
                            transactorId = null;
                        }
                        var serviceStartTime = $sheBaoDiv.find("input[name=serviceStartTime]").val().substring(0, 4);
                        serviceStartTime = serviceStartTime + "-" + $sheBaoDiv.find("input[name=serviceStartTime]").val().substring(4, 6) + "-01";
                        var serviceEndTime = "";
                        if ($sheBaoDiv.find("input[name=serviceEndTime]").val() != "") {
                            serviceEndTime = $sheBaoDiv.find("input[name=serviceEndTime]").val().substring(0, 4);
                            serviceEndTime = serviceEndTime + "-" + $sheBaoDiv.find("input[name=serviceEndTime]").val().substring(4, 6) + "-01";
                        }
                        var billStartTime = $sheBaoDiv.find("input[name=billStartTime]").val().substring(0, 4);
                        billStartTime = billStartTime + "-" + $sheBaoDiv.find("input[name=billStartTime]").val().substring(4, 6) + "-01";
                        jsonArr.push({
                            id : 3,
                            data : {
                                serviceMethod : $sheBaoDiv.find("input[name=businessMethodSS]:checked").val(),
                                isReceivable : $sheBaoDiv.find("input[name=isReceivable]:checked").val(),
                                payPlaceId : $sheBaoDiv.find("select[name=payPlaceId]").val(),
                                organizationId : organizationId,
                                transactor : transactorId,
                                other : $sheBaoDiv.find("select[name=insuranceLevelId]").val(),
                                baseNumber : $sheBaoDiv.find("input[name=baseNumber]").val(),
                                baseType : $sheBaoDiv.find("input[name=baseNumberRadio]:checked").val(),
                                serviceStartTime : AM.getTimeStamp(serviceStartTime),
                                serviceEndTime : serviceEndTime == "" ? null : AM.getTimeStamp(serviceEndTime),
                                billStartTime : AM.getTimeStamp(billStartTime),
                            },
                            companySonBillId : $sheBaoDiv.find("select[name=companySonBillIdSB]").val(),
                        });
                    } else if (value == 4 && checked) { // 如果是 公积金
                        var $GJDiv = $("#GJDiv");
                        var organizationId = $GJDiv.find("select[name=organizationGJId]").val()
                        var transactorId = $GJDiv.find("select[name=transactorGJId]").val()
                        if ($GJDiv.find("input[name=businessMethodGJJ]:checked").val() == 1) {
                            organizationId = null;
                            transactorId = null;
                        }
                        var serviceStartTimeGJ = $GJDiv.find("input[name=serviceStartTimeGJ]").val().substring(0, 4);
                        serviceStartTimeGJ = serviceStartTimeGJ + "-" + $GJDiv.find("input[name=serviceStartTimeGJ]").val().substring(4, 6) + "-01";
                        var serviceEndTimeGJ = "";
                        if ($GJDiv.find("input[name=serviceEndTimeGJ]").val() != "") {
                            serviceEndTimeGJ = $GJDiv.find("input[name=serviceEndTimeGJ]").val().substring(0, 4);
                            serviceEndTimeGJ = serviceEndTimeGJ + "-" + $GJDiv.find("input[name=serviceEndTimeGJ]").val().substring(4, 6) + "-01";
                        }
                        var billStartTimeGJ = $GJDiv.find("input[name=billStartTimeGJ]").val().substring(0, 4);
                        billStartTimeGJ = billStartTimeGJ + "-" + $GJDiv.find("input[name=billStartTimeGJ]").val().substring(4, 6) + "-01";
                        jsonArr.push({
                            id : 4,
                            data : {
                                serviceMethod : $GJDiv.find("input[name=businessMethodGJJ]:checked").val(),
                                isReceivable : $GJDiv.find("input[name=isReceivableGJ]:checked").val(),
                                payPlaceId : $GJDiv.find("select[name=payPlaceGJId]").val(),
                                organizationId : organizationId,
                                transactor : transactorId,
                                other : $GJDiv.find("input[name=ratioGJ]").val(),
                                baseNumber : $GJDiv.find("input[name=baseNumberGJ]").val(),
                                baseType : $GJDiv.find("input[name=baseNumberRadioGJ]:checked").val(),
                                serviceStartTime : AM.getTimeStamp(serviceStartTimeGJ),
                                serviceEndTime : serviceEndTimeGJ == "" ? null : AM.getTimeStamp(serviceEndTimeGJ),
                                billStartTime : AM.getTimeStamp(billStartTimeGJ),
                            },
                            companySonBillId : $GJDiv.find("select[name=companySonBillIdGJ]").val(),
                        });
                    } else if (value == 5 && checked) { // 如果是工资
                        var $GZDiv = $("#GZDiv");
                        jsonArr.push({
                            id : 5,
                            data : {
                                nationality : $GZDiv.find("select[name=nationality]").val(),
                                bankAccount : $GZDiv.find("input[name=bankAccount]").val(),
                                bankName : $GZDiv.find("input[name=bankName]").val(),
                                //phoneNumber : $GZDiv.find("input[name=phoneNumber]").val(),
                                cityId : $GZDiv.find("select[name=cityIdGZ]").val(),
                            },
                            companySonBillId : $GZDiv.find("select[name=companySonBillIdGZ]").val(),
                        });
                    } else if (value == 6 && checked) { // 如果是商业险
                        var $SYXDiv = $("#SYXDiv");
                        var business = [];
                        $SYXDiv.find("input[name=business]").each(function () {
                            var companySonBillId = $(this).parent().parent().find("select[name=businessCompanySonBillIdSY]").val();
                            if ($(this).is(':checked')) {
                                business.push({
                                    itemId : $(this).val(),
                                    companySonBillId : companySonBillId,
                                });
                            }
                        });
                        jsonArr.push({
                            id : 6,
                            data : business,
                            companySonBillId : null,
                        });
                    } else if (value == 7 && checked) { // 如果是一次性业务
                        var $YCXDiv = $("#YCXDiv");
                        var business = [];
                        $YCXDiv.find("input[name=business]").each(function () {
                            var companySonBillId = $(this).parent().parent().find("select[name=businessCompanySonBillIdYCX]").val();
                            if ($(this).is(':checked')) {
                                business.push({
                                    itemId : $(this).val(),
                                    companySonBillId : companySonBillId,
                                });
                            }
                        });
                        jsonArr.push({
                            id : 7,
                            data : business,
                            companySonBillId : null,
                        });
                    }
                });
                data.field.businessArr = JSON.stringify(jsonArr);
                delete data.field.city;
                AM.log(data.field);
                AM.ajaxRequestData("post", false, AM.ip + "/member/update", data.field , function(result) {
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
