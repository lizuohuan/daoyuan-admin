<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>客户详情</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview {
            height: 250px;
            width: 400px;
            margin-right: 10px;
            margin-bottom: 10px;
            float: left;
            text-align: center
        }
        table td, table th {
            padding-top: 4px !important;
            text-align: center !important;
        }

        .preview img {
            width: 100%;
            height: 210px;
            border: 1px solid #eee;
        }

        #edui1 {
            z-index: 9 !important;
        }

        .check-input {
            width: 150px;
        }

        .check-input-span {
            color: darkgrey;
            position: absolute;
            top: 0;
            left: 155px;
        }
        .row{clear: both;}
        .col-xs-4{width: 33.33%;float: left;position: relative;padding-bottom: 15px;}
        .col-xs-6{width: 50%;float: left;position: relative;padding-bottom: 15px;}
        input[disabled], select[disabled], input[disabled]:hover, select[disabled]:hover{color: #666 !important;}
        .layui-select-disabled .layui-disabled{color: #666 !important;}
        .layui-disabled, .layui-disabled:hover{color: #666 !important;}
        .display{border: 1px solid #e2e2e2;}
        .display td{padding: 6px 10px;font-size: 12px;}
    </style>
</head>
<body ng-app="webApp" ng-controller="editBannerCtr" ng-cloak>
<div style="margin: 15px;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;客户详情</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">公司名称 </label>
            <div class="layui-input-inline">
                <input type="text" name="companyName" value="{{company.companyName}}" lay-verify="required"
                       placeholder="请输入公司名称" autocomplete="off"
                       class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">到款日</label>
            <div class="layui-input-inline">
                <input lay-verify="required"  type="text" class="layui-input" id="payTime" name="payTime"
                       onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">行业</label>
            <div class="layui-input-inline">
                <select name="tradeId" id="tradeId" lay-verify="required" >
                    <option value="">请选择行业</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客服</label>
            <div class="layui-input-inline">
                <select name="beforeService" id="beforeService" lay-verify="required" >
                    <option value="">请选择客服</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item" id="salesDiv">
            <label class="layui-form-label">销售</label>
            <div class="layui-input-inline">
                <select name="sales" id="sales" lay-verify="required" >
                    <option value="">请选择客服</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item " >
            <label class="layui-form-label">合作状态</label>
            <div class="layui-input-inline">
                <select name="cooperationStatus" id="cooperationStatus" >
                    <option value="1">合作</option>
                    <option value="0">空户/终止</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item " >
            <label class="layui-form-label">关联公司<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <select name="relevanceCompanyId" id="relevanceCompanyId" >
                    <option value="">选择关联公司</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item " >
            <label class="layui-form-label">推荐客户<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <select name="recommendCompanyId" id="recommendCompanyId" >
                    <option value="">选择推荐客户</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">同行客户</label>
            <div class="layui-input-block">
                <input type="radio" name="isPeer" value="0" title="否" checked>
                <input type="radio" name="isPeer" value="1" title="是">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">票款顺序</label>
            <div class="layui-input-block">
                <input type="radio" name="isFirstBill" id="isFirstBillNO" value="0" title="先款后票">
                <input type="radio" name="isFirstBill" id="isFirstBillYes" value="1" title="先票后款">
            </div>
        </div>



        <fieldset class="layui-elem-field">
            <legend>服务&nbsp;</legend>
            </legend>
            <div class="layui-field-box layui-form">
                <div class="layui-form-item">
                    <label class="layui-form-label">服务</label>
                    <div class="layui-input-block" id="businessId">

                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="businessMethodSSDiv">
                    <div class="layui-form-item " >
                        <label class="layui-form-label">社保</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" lay-filter="ssCheckBoxFilter" value="0" name="businessMethodSS"
                                   title="代理">

                        </div>
                        <div class="layui-hide" id="daiLiSS">
                            <label class="layui-form-label ">代理账单制作</label>
                            <div class="layui-input-inline">
                                <input type="radio" name="dailiSS" checked="checked" value="0" title="预收型">
                                <input type="radio" name="dailiSS" value="1" title="实做型">
                            </div>
                        </div>
                    </div>

                    <div class="layui-form-item ">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-inline">
                            <input type="checkbox" lay-filter="ssCheckBoxFilter" value="1" name="businessMethodSS"
                                   title="托管">
                        </div>
                        <div class="layui-hide" id="tuoGuanSS">
                            <label class="layui-form-label ">托管账单制作</label>
                            <div class="layui-input-inline">
                                <input type="radio" name="tuoGuanSS" value="0" title="预收型">
                                <input type="radio" name="tuoGuanSS" value="1" title="实做型" checked>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="layui-form-item layui-hide" id="businessMethodPfDiv">
                    <div class="layui-form-item" >
                        <label class="layui-form-label">公积金</label>
                        <div class="layui-input-inline">
                            <input type="checkbox" value="0" lay-filter="boxCheckedPf" name="businessMethodPf" title="代理">
                        </div>
                        <div class="layui-hide" id="daiLiPf">
                            <label class="layui-form-label ">代理账单制作</label>
                            <div class="layui-input-inline">
                                <input type="radio" name="dailiPf" checked="checked" value="0" title="预收型">
                                <input type="radio" name="dailiPf" value="1" title="实做型">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item " >
                        <label class="layui-form-label"></label>
                        <div class="layui-input-inline">
                            <input type="checkbox" value="1" lay-filter="boxCheckedPf" name="businessMethodPf" title="托管">
                        </div>
                        <div class="layui-hide" id="tuoGuanPf">
                            <label class="layui-form-label ">托管账单制作</label>
                            <div class="layui-input-inline">
                                <input type="radio" name="tuoGuanPf" value="0" title="预收型" >
                                <input type="radio" name="tuoGuanPf" value="1" title="实做型" checked>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="businessMethodGzDiv">
                    <label class="layui-form-label">工资发放日期</label>
                    <div class="layui-input-inline">
                        <input type="text" class="layui-input salaryDate" id="salaryDate"
                               onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})">
                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="businessMethodSyDiv">
                    <label class="layui-form-label">其他周期性服务</label>
                    <div class="layui-input-inline" id="billMadeMethodSyDDIV" style="width: 700px;">

                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="businessMethodTjDiv">
                    <label class="layui-form-label">一次性服务<span class="font-red"></span></label>
                    <div class="layui-input-block" id="billMadeMethodTjDDIV" style="width: 700px;">
                    </div>
                </div>


                <div class="layui-form-item">
                    <label class="layui-form-label">业务月序开始时间</label>
                    <div class="layui-input-inline">
                        <input type="text" id="businessStartTime" name="businessStartTime" readonly lay-verify=""
                               placeholder="请输入业务月序开始时间" autocomplete="off" class="layui-input" maxlength="20">
                    </div>
                </div>

                <div class="layui-form-item layui-hide" id="businessCycleDiv">
                    <label class="layui-form-label">业务月序周期(月)</label>
                    <div class="layui-input-inline">
                        <input type="text" value="{{company.businessCycle}}" id="businessCycle" name="businessCycle"
                               onblur="businessCycleBlur(this)" lay-verify="required|isNumber"
                               placeholder="请输入月序周期(大于0的整数) " autocomplete="off" class="layui-input"
                               onkeydown=if(event.keyCode==13)event.keyCode=9;
                               onkeyup="value=value.replace(/[^0-9- ]/g,'');">
                    </div>
                </div>
                <div class="layui-form-item layui-hide " id="showBusinessCycleDiv">
                    <label class="layui-form-label">未来业务费账单周期</label>
                    <div class="layui-input-inline" style="width: 600px">
                        <table class="layui-table" lay-size="sm">
                            <thead>
                            <tr>
                                <th>账单月</th>
                                <th>所包含服务月</th>
                            </tr>
                            </thead>
                            <tbody id="businessDataBody">


                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </fieldset>



        <!-- 合作方式 ...开始  -->
        <fieldset class="layui-elem-field">
            <legend>合作方式&nbsp;</legend>
            </legend>

            <div class="layui-form-item">
                <label class="layui-form-label">合作方式</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="cooperationMethod" lay-filter="cooperationMethodFilter" value="0" title="普通">
                    <input type="checkbox" name="cooperationMethod" lay-filter="cooperationMethodFilter" value="1" title="派遣" >
                    <input type="checkbox" name="cooperationMethod" lay-filter="cooperationMethodFilter" value="2" title="外包">
                </div>
            </div>
        </fieldset>
        <!-- 合作方式 ...结束  -->



        <!-- 普通合作方式开始  -->
        <div class="layui-hide" id="cooperationMethodDiv">
            <fieldset class="layui-elem-field">
                <legend>普通合作服务费&nbsp;</legend>
                </legend>
                <div class="layui-field-box layui-form" >
                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费月序开始时间</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodPTServiceFeeStartTime" name="cooperationMethodPTServiceFeeStartTime" readonly
                                   placeholder="请输入服务费月序开始时间" autocomplete="off" class="layui-input" maxlength="20">
                        </div>
                    </div>
                    <div class="layui-form-item layui-hide" id="cooperationMethodPTServiceFeeCycleDiv">
                        <label class="layui-form-label">服务费月序周期(月)</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodPTServiceFeeCycle" name="cooperationMethodPTServiceFeeCycle" onblur="cooperationMethodServiceFeeCycleBlur(this,'cooperationMethodPTDataBody','cooperationMethodPTServiceFeeStartTime','cooperationMethodPTShowServiceFeeCycleDiv')"
                                   placeholder="请输入月序周期"
                                   autocomplete="off" class="layui-input"
                                   onkeydown=if(event.keyCode==13)event.keyCode=9
                                   onkeyup="value=value.replace(/[^0-9- ]/g,'');">
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide " id="cooperationMethodPTShowServiceFeeCycleDiv">
                        <label class="layui-form-label">未来服务费账单周期</label>
                        <div class="layui-input-inline" style="width: 600px">
                            <table class="layui-table" lay-size="sm">
                                <thead>
                                <tr>
                                    <th>账单月</th>
                                    <th>所包含服务月</th>
                                </tr>
                                </thead>
                                <tbody id="cooperationMethodPTDataBody">


                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费配置</label>
                        <div class="layui-input-inline">
                            <select name="cooperationMethodPTServiceFeeConfigId" id="cooperationMethodPTServiceFeeConfigId" lay-filter="cooperationMethodPTChangeServiceFeeConfig"
                                    >
                                <option value="">请选择服务费配置</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide" id="cooperationMethodPTServiceFeeDiv">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPTServiceFee" id="cooperationMethodPTServiceFee" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodPTAssist"></div>
                    </div>


                    <div class="layui-form-item layui-hide" id="cooperationMethodPTBaseDiv">
                        <label class="layui-form-label">基础服务费</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPTBase" id="cooperationMethodPTBase" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodPTBaseAssist">元</div>
                    </div>



                    <div class="layui-hide cooperationMethodPTServiceFeePlaceDiv" id="cooperationMethodPTServiceFeePlaceDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">选择缴金地</label>
                            <div class="layui-input-inline">
                                <select id="cooperationMethodPTServiceFeePlace" class="cooperationMethodPTServiceConfigFeePlace" name="cooperationMethodPTServiceConfigFeePlace" >
                                    <option value="">请选择</option>
                                </select>
                            </div>
                            <label class="layui-form-label">服务费</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPTServiceConfigFeePlacePrice" class="layui-input cooperationMethodPTServiceConfigFeePlacePrice" name="cooperationMethodPTServiceConfigFeePlacePrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux "> 元/人*服务月</div>
                        </div>
                    </div>

                    <div class="layui-hide" id="cooperationMethodPTExtentDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">人数低于</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPTExtentNum" class="layui-input cooperationMethodPTExtentNum" lay-verify="isNumber"
                                       placeholder="请输入"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux cooperationMethodPTUnitId"></div>
                            <label class="layui-form-label">服务费：</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPTExtentPrice" class="layui-input cooperationMethodPTExtentPrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                        </div>
                    </div>


                    <div class="layui-hide" id="cooperationMethodPTServiceFeeForType">

                    </div>

                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">服务费区间<span class="font-red"></span></label>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text" id="cooperationMethodPTServiceFeeMin"  name="cooperationMethodPTServiceFeeMin" class="layui-input"
                                       lay-verify="isDouble" value="0"
                                       placeholder="输入服务费最低收费,默认为 0"/>
                            </div>
                            <div class="layui-form-mid">-</div>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text" id="cooperationMethodPTServiceFeeMax"  name="cooperationMethodPTServiceFeeMax" class="layui-input"
                                       lay-verify="isDouble"
                                       placeholder="输入服务费最高收费,默认为无上限"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux"> 元</div>
                        </div>
                    </div>

                    <div class="layui-form-item" >
                        <label class="layui-form-label">纳入百分比</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPTPercent" id="cooperationMethodPTPercent" class="layui-input"
                                   value="0" lay-verify="isDouble"
                                   placeholder="默认为 0"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux"> %</div>
                        <label class="layui-form-label">服务费纳入百分比计算</label>
                        <div class="layui-input-inline">
                            <input type="radio" name="cooperationMethodPTIsPercent" value="0" title="否" checked>
                            <input type="radio" name="cooperationMethodPTIsPercent" value="1" title="是" >
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
        <!-- 普通合作方式结束  -->

        <!-- 派遣合作方式开始  -->
        <div class="layui-hide" id="cooperationMethodPQDiv">
            <fieldset class="layui-elem-field">
                <legend>派遣合作服务费&nbsp;</legend>
                </legend>
                <div class="layui-field-box layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费月序开始时间</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodPQServiceFeeStartTime" name="cooperationMethodPQServiceFeeStartTime" readonly
                                   placeholder="请输入服务费月序开始时间" autocomplete="off" class="layui-input" maxlength="20">
                        </div>
                    </div>
                    <div class="layui-form-item layui-hide" id="cooperationMethodPQServiceFeeCycleDiv">
                        <label class="layui-form-label">服务费月序周期(月)</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodPQServiceFeeCycle" name="cooperationMethodPQServiceFeeCycle" onblur="cooperationMethodServiceFeeCycleBlur(this,'cooperationMethodPQDataBody','cooperationMethodPQServiceFeeStartTime','cooperationMethodPQShowServiceFeeCycleDiv')"
                                   placeholder="请输入月序周期"
                                   autocomplete="off" class="layui-input"
                                   onkeydown=if(event.keyCode==13)event.keyCode=9
                                   onkeyup="value=value.replace(/[^0-9- ]/g,'');">
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide " id="cooperationMethodPQShowServiceFeeCycleDiv">
                        <label class="layui-form-label">未来服务费账单周期</label>
                        <div class="layui-input-inline" style="width: 600px">
                            <table class="layui-table" lay-size="sm">
                                <thead>
                                <tr>
                                    <th>账单月</th>
                                    <th>所包含服务月</th>
                                </tr>
                                </thead>
                                <tbody id="cooperationMethodPQDataBody">


                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费配置</label>
                        <div class="layui-input-inline">
                            <select name="cooperationMethodPQServiceFeeConfigId" id="cooperationMethodPQServiceFeeConfigId" lay-filter="cooperationMethodPQChangeServiceFeeConfig"
                                    >
                                <option value="">请选择服务费配置</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide" id="cooperationMethodPQServiceFeeDiv">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPQServiceFee" id="cooperationMethodPQServiceFee" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodPQAssist"></div>
                    </div>


                    <div class="layui-form-item layui-hide" id="cooperationMethodPQBaseDiv">
                        <label class="layui-form-label">基础服务费</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPQBase" id="cooperationMethodPQBase" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodPQBaseAssist">元</div>
                    </div>


                    <div class="layui-hide cooperationMethodPQServiceFeePlaceDiv" id="cooperationMethodPQServiceFeePlaceDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">选择缴金地</label>
                            <div class="layui-input-inline">
                                <select id="cooperationMethodPQServiceFeePlace" class="cooperationMethodPQServiceConfigFeePlace" name="cooperationMethodPQServiceConfigFeePlace" >
                                    <option value="">请选择</option>
                                </select>
                            </div>
                            <label class="layui-form-label">服务费</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPQServiceConfigFeePlacePrice" class="layui-input cooperationMethodPQServiceConfigFeePlacePrice" name="cooperationMethodPQServiceConfigFeePlacePrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux "> 元/人*服务月</div>
                        </div>
                    </div>

                    <div class="layui-hide" id="cooperationMethodPQExtentDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">人数低于</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPQExtentNum" class="layui-input cooperationMethodPQExtentNum" lay-verify="isNumber"
                                       placeholder="请输入"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux cooperationMethodPQUnitId"></div>
                            <label class="layui-form-label">服务费：</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodPQExtentPrice" class="layui-input cooperationMethodPQExtentPrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                        </div>
                    </div>


                    <div class="layui-hide" id="cooperationMethodPQServiceFeeForType">

                    </div>

                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">服务费区间<span class="font-red"></span></label>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text"  name="cooperationMethodPQServiceFeeMin" id="cooperationMethodPQServiceFeeMin" class="layui-input"
                                       lay-verify="isDouble" value="0"
                                       placeholder="输入服务费最低收费,默认为 0"/>
                            </div>
                            <div class="layui-form-mid">-</div>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text"  name="cooperationMethodPQServiceFeeMax" id="cooperationMethodPQServiceFeeMax" class="layui-input"
                                       lay-verify="isDouble"
                                       placeholder="输入服务费最高收费,默认为无上限"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux"> 元</div>
                        </div>
                    </div>
                    <div class="layui-form-item" >
                        <label class="layui-form-label">纳入百分比</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodPQPercent" id="cooperationMethodPQPercent" class="layui-input"
                                   value="0" lay-verify="isDouble"
                                   placeholder="默认为 0"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux"> %</div>
                        <label class="layui-form-label">服务费纳入百分比计算</label>
                        <div class="layui-input-inline">
                            <input type="radio" name="cooperationMethodPQIsPercent" value="0" title="否" checked>
                            <input type="radio" name="cooperationMethodPQIsPercent" value="1" title="是" >
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
        <!-- 派遣合作方式结束  -->




        <!-- 外包合作方式开始  -->
        <div class="layui-hide" id="cooperationMethodWBDiv">
            <fieldset class="layui-elem-field">
                <legend>外包合作服务费&nbsp;</legend>
                </legend>
                <div class="layui-field-box layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费月序开始时间</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodWBServiceFeeStartTime" name="cooperationMethodWBServiceFeeStartTime" readonly
                                   placeholder="请输入服务费月序开始时间" autocomplete="off" class="layui-input" maxlength="20">
                        </div>
                    </div>
                    <div class="layui-form-item layui-hide" id="cooperationMethodWBServiceFeeCycleDiv">
                        <label class="layui-form-label">服务费月序周期(月)</label>
                        <div class="layui-input-inline">
                            <input type="text" id="cooperationMethodWBServiceFeeCycle" name="cooperationMethodWBServiceFeeCycle" onblur="cooperationMethodServiceFeeCycleBlur(this,'cooperationMethodWBDataBody','cooperationMethodWBServiceFeeStartTime','cooperationMethodWBShowServiceFeeCycleDiv')"
                                   placeholder="请输入月序周期"
                                   autocomplete="off" class="layui-input"
                                   onkeydown=if(event.keyCode==13)event.keyCode=9
                                   onkeyup="value=value.replace(/[^0-9- ]/g,'');">
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide " id="cooperationMethodWBShowServiceFeeCycleDiv">
                        <label class="layui-form-label">未来服务费账单周期</label>
                        <div class="layui-input-inline" style="width: 600px">
                            <table class="layui-table" lay-size="sm">
                                <thead>
                                <tr>
                                    <th>账单月</th>
                                    <th>所包含服务月</th>
                                </tr>
                                </thead>
                                <tbody id="cooperationMethodWBDataBody">


                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="layui-form-item">
                        <label class="layui-form-label">服务费配置</label>
                        <div class="layui-input-inline">
                            <select id="cooperationMethodWBServiceFeeConfigId" name="cooperationMethodWBServiceFeeConfigId"  lay-filter="cooperationMethodWBChangeServiceFeeConfig"
                                    >
                                <option value="">请选择服务费配置</option>
                            </select>
                        </div>
                    </div>

                    <div class="layui-form-item layui-hide" id="cooperationMethodWBServiceFeeDiv">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodWBServiceFee" id="cooperationMethodWBServiceFee" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodWBAssist"></div>
                    </div>


                    <div class="layui-form-item layui-hide" id="cooperationMethodWBBaseDiv">
                        <label class="layui-form-label">基础服务费</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodWBBase" id="cooperationMethodWBBase" class="layui-input"
                                   lay-verify="isDouble"
                                   placeholder="请输入"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux" id="cooperationMethodWBBaseAssist">元</div>
                    </div>



                    <div class="layui-hide cooperationMethodWBServiceFeePlaceDiv" id="cooperationMethodWBServiceFeePlaceDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">选择缴金地</label>
                            <div class="layui-input-inline">
                                <select id="cooperationMethodWBServiceFeePlace" class="cooperationMethodWBServiceConfigFeePlace" name="cooperationMethodWBServiceConfigFeePlace" >
                                    <option value="">请选择</option>
                                </select>
                            </div>
                            <label class="layui-form-label">服务费</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodWBServiceConfigFeePlacePrice" class="layui-input cooperationMethodWBServiceConfigFeePlacePrice" name="cooperationMethodWBServiceConfigFeePlacePrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux "> 元/人*服务月</div>
                        </div>
                    </div>

                    <div class="layui-hide" id="cooperationMethodWBExtentDiv">
                        <div class="layui-form-item">
                            <label class="layui-form-label">人数低于</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodWBExtentNum" class="layui-input cooperationMethodWBExtentNum" lay-verify="isNumber"
                                       placeholder="请输入"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux cooperationMethodWBUnitId"></div>
                            <label class="layui-form-label">服务费：</label>
                            <div class="layui-input-inline">
                                <input type="number" id="cooperationMethodWBExtentPrice" class="layui-input cooperationMethodWBExtentPrice" lay-verify="isDouble"
                                       placeholder="请输入服务费"/>
                            </div>
                        </div>
                    </div>


                    <div class="layui-hide" id="cooperationMethodWBServiceFeeForType">

                    </div>

                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">服务费区间<span class="font-red"></span></label>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text" id="cooperationMethodWBServiceFeeMin" name="cooperationMethodWBServiceFeeMin" class="layui-input"
                                       lay-verify="isDouble" value="0"
                                       placeholder="输入服务费最低收费,默认为 0"/>
                            </div>
                            <div class="layui-form-mid">-</div>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="text" id="cooperationMethodWBServiceFeeMax"  name="cooperationMethodWBServiceFeeMax" class="layui-input"
                                       lay-verify="isDouble"
                                       placeholder="输入服务费最高收费,默认为无上限"/>
                            </div>
                            <div class="layui-form-mid layui-word-aux"> 元</div>
                        </div>
                    </div>
                    <div class="layui-form-item" >
                        <label class="layui-form-label">纳入百分比</label>
                        <div class="layui-input-inline">
                            <input type="text" name="cooperationMethodWBPercent" id="cooperationMethodWBPercent" class="layui-input"
                                   value="0" lay-verify="isDouble"
                                   placeholder="默认为 0"/>
                        </div>
                        <div class="layui-form-mid layui-word-aux"> %</div>
                        <label class="layui-form-label">服务费纳入百分比计算</label>
                        <div class="layui-input-inline">
                            <input type="radio" name="cooperationMethodWBIsPercent" value="0" title="否" checked>
                            <input type="radio" name="cooperationMethodWBIsPercent" value="1" title="是" >
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">营业执照正本</label>
            <div class="layui-input-block" id="previewApp">

            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">营业执照副本</label>
            <div class="layui-input-block" id="previewPC">

            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">一般纳税人证明</label>
            <div class="layui-input-block" id="taxpayerProvePreview">
            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">稳岗补贴情况</label>
            <div class="layui-input-block" id="subsidyProvePreview">

            </div>
        </div>

        <div class="layui-form-item layui-hide">
            <label class="layui-form-label">其他情况说明</label>
            <div class="layui-input-block" id="otherProvePreview">
            </div>
        </div>

    </form>


    <fieldset class="layui-elem-field">
        <legend>快递列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>快递单号</th>
                    <th>快递公司</th>
                    <th>内容</th>
                    <th>客户名称</th>
                    <th>收件人</th>
                    <th>是否收到</th>
                    <th>收件时间</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in expressageList">
                        <td>{{data.orderNumber == null || data.orderNumber == "" ? "--" : data.orderNumber}}</td>
                        <td>{{data.expressCompanyName == null || data.expressCompanyName == "" ? "--" : data.expressCompanyName}}</td>
                        <td>{{data.content == null || data.content == "" ? "--" : data.content}}</td>
                        <td>{{data.companyName == null || data.companyName == "" ? "--" : data.companyName}}</td>
                        <td>{{data.expressPersonName == null || data.expressPersonName == "" ? "--" : data.expressPersonName}}</td>
                        <td>{{data.isReceive == 0 ? "未收到" : "收到"}}</td>
                        <td>{{data.receiveDate | date : "yyyy-MM-dd hh:mm:ss"}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="expressageList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>联系人列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>联系人</th>
                    <th>所属公司</th>
                    <th>固定电话</th>
                    <th>手机号</th>
                    <th>QQ</th>
                    <th>邮箱</th>
                    <th>微信</th>
                    <th>部门</th>
                    <th>职位</th>
                    <th>账单接受人</th>
                    <th>状态</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in linkmanContactsList">
                        <td>{{data.contactsName == null || data.contactsName == "" ? "--" : data.contactsName}}</td>
                        <td>{{data.companyName == null || data.companyName == "" ? "--" : data.companyName}}</td>
                        <td>{{data.landLine == null || data.landLine == "" ? "--" : data.landLine}}</td>
                        <td>{{data.phone == null || data.phone == "" ? "--" : data.phone}}</td>
                        <td>{{data.qq == null || data.qq == "" ? "--" : data.qq}}</td>
                        <td>{{data.email == null || data.email == "" ? "--" : data.email}}</td>
                        <td>{{data.weChat == null || data.weChat == "" ? "--" : data.weChat}}</td>
                        <td>{{data.departmentName == null || data.departmentName == "" ? "--" : data.departmentName}}</td>
                        <td>{{data.jobTitle == null || data.jobTitle == "" ? "--" : data.jobTitle}}</td>
                        <td>{{data.isReceiver == 0 ? "否" : "是"}}</td>
                        <td>{{data.isValid == 0 ? "无效" : "有效"}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="linkmanContactsList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>票据列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>票据名称</th>
                    <th>票据类型</th>
                    <th>发票抬头</th>
                    <th>税号</th>
                    <th>地址</th>
                    <th>电话</th>
                    <th>开户行</th>
                    <th>银行帐号</th>
                    <th>是否启用</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in billList">
                        <td>{{data.name == null || data.name == "" ? "--" : data.name}}</td>
                        <td>
                            <span ng-if="data.billType == 0">专票</span>
                            <span ng-if="data.billType == 1">普票</span>
                            <span ng-if="data.billType == 2">收据</span>
                        </td>
                        <td>{{data.title == null || data.title == "" ? "--" : data.title}}</td>
                        <td>{{data.taxNumber == null || data.taxNumber == "" ? "--" : data.taxNumber}}</td>
                        <td>{{data.address == null || data.address == "" ? "--" : data.address}}</td>
                        <td>{{data.phone == null || data.phone == "" ? "--" : data.phone}}</td>
                        <td>{{data.accountName == null || data.accountName == "" ? "--" : data.accountName}}</td>
                        <td>{{data.bankAccount == null || data.bankAccount == "" ? "--" : data.bankAccount}}</td>
                        <td>{{data.isEnabled == 0 ? "否" : "是"}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="billList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>子账单配置列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>所属公司</th>
                    <th>子账单名称</th>
                    <th>账单接收人</th>
                    <th>所属票据</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in companySonBillList">
                        <td>{{data.companyName == null || data.companyName == "" ? "--" : data.companyName}}</td>
                        <td>{{data.sonBillName == null || data.sonBillName == "" ? "--" : data.sonBillName}}</td>
                        <td>{{data.contactsName == null || data.contactsName == "" ? "--" : data.contactsName}}</td>
                        <td>{{data.companyBillInfoName == null || data.companyBillInfoName == "" ? "--" : data.companyBillInfoName}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="companySonBillList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>付款列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>银行账户</th>
                    <th>银行账号</th>
                    <th>开户行</th>
                    <th>账户类型</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in bankInfoList">
                        <td>{{data.accountName == null || data.accountName == "" ? "--" : data.accountName}}</td>
                        <td>{{data.bankAccount == null || data.bankAccount == "" ? "--" : data.bankAccount}}</td>
                        <td>{{data.bankName == null || data.bankName == "" ? "--" : data.bankName}}</td>
                        <td>
                            <span ng-if="data.type == null">--</span>
                            <span ng-if="data.type == 0">银行卡</span>
                            <span ng-if="data.type == 1">支付宝</span>
                        </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="bankInfoList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>邮寄列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>收件人</th>
                    <th>所属公司</th>
                    <th>电话</th>
                    <th>地址</th>
                    <th>单位名称</th>
                    <th>邮编</th>
                    <th>默认收件人</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in mailList">
                        <td>{{data.personName == null || data.personName == "" ? "--" : data.personName}}</td>
                        <td>{{data.companyName == null || data.companyName == "" ? "--" : data.companyName}}</td>
                        <td>{{data.phone == null || data.phone == "" ? "--" : data.phone}}</td>
                        <td>{{data.address == null || data.address == "" ? "--" : data.address}}</td>
                        <td>{{data.unitName == null || data.unitName == "" ? "--" : data.unitName}}</td>
                        <td>{{data.zipcode == null || data.zipcode == "" ? "--" : data.zipcode}}</td>
                        <td>{{data.isDefault == 0 ? "否" : "是"}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="mailList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>合同列表</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>合同编号</th>
                    <th>合同起始日期</th>
                    <th>合同截止日期</th>
                    <th>备注</th>
                    <th>客户名称</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in contractList">
                        <td>{{data.serialNumber == null || data.serialNumber == "" ? "--" : data.serialNumber}}</td>
                        <td>{{data.startTime | date : "yyyy-MM-dd hh:mm:ss"}}</td>
                        <td>{{data.endTime | date : "yyyy-MM-dd hh:mm:ss"}}</td>
                        <td>{{data.remarks == null || data.remarks == "" ? "--" : data.remarks}}</td>
                        <td>{{data.companyName == null || data.companyName == "" ? "--" : data.companyName}}</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr ng-if="contractList.length == 0">
                        <td colspan="99" align="center">暂无</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/ue/ueditor.config.js"></script>
<!-- 编辑器源码文件 -->
<script type="text/javascript" src="<%=request.getContextPath()%>/ue/ueditor.all.js"></script>
<script src="<%=request.getContextPath()%>/ue/lang/zh-cn/zh-cn.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/company-plus/edit.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/ue/themes/default/css/ueditor.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/ue/themes/default/css/ueditor.min.css"/>
<script>
    var arrImg = [];
    var form = null;
    var webApp = angular.module('webApp', []);
    webApp.controller("editBannerCtr", function ($scope, $http, $timeout) {
        $scope.company = null; //公司信息
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("post", false, AM.ip + "/company/getCompany", {companyId: $scope.id}, function (result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.company = result.data;
                console.log("/company/getCompany");
                console.log(result.data);
            }
        });

        /**联系人列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/contacts/getContactsByItems", {companyId: $scope.id}, function (result) {
            $scope.linkmanContactsList = result.data;
        });

        /**快递列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/express/queryExpressInfo", {companyId: $scope.id}, function (result) {
            $scope.expressageList = result.data;
        });

        /**票据列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/billInfo/queryBillInfo", {companyId: $scope.id}, function (result) {
            $scope.billList = result.data;
        });

        /**子账单配置列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/list", {companyId: $scope.id}, function (result) {
            $scope.companySonBillList = result.data;
        });

        /**付款列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/bankInfo/getBankInfo", {companyId: $scope.id}, function (result) {
            $scope.bankInfoList = result.data;
        });

        /**邮寄列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/expressPersonInfo/queryExpressPersonInfo", {companyId: $scope.id}, function (result) {
            $scope.mailList = result.data;
        });

        /**合同列表**/
        AM.ajaxRequestData("post", false, AM.ip + "/contract/queryContract", {companyId: $scope.id}, function (result) {
            $scope.contractList = result.data;
        });






        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function () {
            form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    , $ = layui.jquery,
                    laydate = layui.laydate;
            // 初始化票款顺序
            if($scope.company.isFirstBill == 1){
                $("#isFirstBillYes").attr("checked",true);
            }else{
                $("#isFirstBillNO").attr("checked",true);
            }
            $("#payTime").val(new Date($scope.company.payTime).format("yyyy-MM-dd"));
            $("#businessStartTime").val(new Date($scope.company.businessStartTime).format("yyyy-MM-dd"));
//            $("#serviceFeeStartTime").val(new Date($scope.company.serviceFeeStartTime).format("yyyy-MM-dd"));
            // 行业初始化
            buildTradeOption($scope.company.tradeId, "tradeId", "post", 0);
            // 初始化 服务费配置
            buildServiceFeeOption($scope.company.serviceFeeConfigId, "serviceFeeConfigId", "post", 0);


            var views = new Array();
            views.push("cooperationMethodWBServiceFeeConfigId");
            views.push("cooperationMethodPQServiceFeeConfigId");
            views.push("cooperationMethodPTServiceFeeConfigId");
            buildOtherServiceFeeOption(0,views,"post");



            var placeViews = new Array();
            placeViews.push("cooperationMethodPTServiceFeePlace");
            placeViews.push("cooperationMethodPQServiceFeePlace");
            placeViews.push("cooperationMethodWBServiceFeePlace");
            queryOtherAllPayPlace(0,placeViews,"post");


            // 初始化业务
            buildBusinessInput(0, "businessId", "POST", 0);
            // 初始化合作状态
            $("#cooperationStatus").val($scope.company.cooperationStatus);
            // 初始化推荐客户
            queryAllCompany($scope.company.relevanceCompanyId,"relevanceCompanyId",null,$scope.company.id);
            queryAllCompany($scope.company.recommendCompanyId,"recommendCompanyId",null,$scope.company.id);

            // 初始化客服
            queryUserByRoles($scope.company.beforeService, "beforeService", 0, 0);
            queryUserByRoles($scope.company.sales, "sales", 0, 1);

            // 初始化商业险以及一次性业务复选框
            getAllYc(0, "billMadeMethodTjDDIV", 1, 7,AM.getUrlParam("id"));
            getAllSy(0, "billMadeMethodSyDDIV", 1, 6);
            // 初始化缴金地
            queryAllPayPlace(0,"serviceFeePlace","post",0);

            // 设置业务选项
            $("input[name='businessArr']").each(function () {
                for (var i = 0; i < $scope.company.businesses.length; i++) {
                    var obj = $scope.company.businesses[i];
                    if ($(this).val() == obj.id) {
                        $(this).attr("checked", true);
                        if (obj.id == 1) {
                            // 派遣
                            $("input[name='billMadeMethodPq']").each(function () {
                                if ($(this).val() == obj.billMadeMethod) {
                                    $(this).attr("checked", true);
                                }
                            });
                            $("#businessMethodPqDiv").show("slow");
                        }
                        else if (obj.id == 2) {
                            // 外包
                            $("input[name='billMadeMethodWb']").each(function () {
                                if ($(this).val() == obj.billMadeMethod) {
                                    $(this).attr("checked", true);
                                }
                            });
                            $("#businessMethodWbDiv").show("slow");
                        }
                        else if (obj.id == 3) {
                            // 社保
                            $("#businessMethodSSDiv").show();

                            $("input[name='businessMethodSS']").each(function () {
                                if (null != obj.businessMethod.daiLi && $(this).val() == 0) {
                                    $(this).attr("checked", true);
                                    $("#daiLiSS").show();
                                    $("input[name='dailiSS']").each(function () {
                                        if ($(this).val() == obj.businessMethod.daiLi) {
                                            $(this).attr("checked", true);
                                        }
                                    })
                                }
                                if (null != obj.businessMethod.tuoGuan && $(this).val() == 1) {
                                    $(this).attr("checked", true);
                                    $("#tuoGuanSS").show();
                                    $("input[name='tuoGuanSS']").each(function () {
                                        if ($(this).val() == obj.businessMethod.tuoGuan) {
                                            $(this).attr("checked", true);
                                        }
                                    })
                                }
                            });

//                            $("#businessMethodSS").val(obj.businessMethod);
//                            $("#businessMethodSSDiv").show("slow");
                        }
                        else if (obj.id == 4) {
                            // 公积金
                            $("#businessMethodPfDiv").show();

                            $("input[name='businessMethodPf']").each(function () {
                                if (null != obj.businessMethod.daiLi && $(this).val() == 0) {
                                    $(this).attr("checked", true);
                                    $("#daiLiPf").show();
                                    $("input[name='dailiPf']").each(function () {
                                        if ($(this).val() == obj.businessMethod.daiLi) {
                                            $(this).attr("checked", true);
                                        }
                                    })
                                }
                                if (null != obj.businessMethod.tuoGuan != '' && $(this).val() == 1) {
                                    $(this).attr("checked", true);
                                    $("#tuoGuanPf").show();
                                    $("input[name='tuoGuanPf']").each(function () {
                                        if ($(this).val() == obj.businessMethod.tuoGuan) {
                                            $(this).attr("checked", true);
                                        }
                                    })
                                }
                            });
                        }
                        else if (obj.id == 5) {
                            // 工资
                            var salaryArr = $scope.company.salaryDateList;
                            if ('' != salaryArr && salaryArr.length > 0) {
                                var html = "";
                                for (var j = 0; j < salaryArr.length; j++) {

                                    var dateStr = new Date(salaryArr[j].grantDate).format("yyyy-MM-dd");
                                    if (j == 0) {
                                        $("#salaryDate").val(dateStr);
                                    } else {
                                        html += '<div class="layui-form-item " style="margin-top: 5px" >' +
                                                '<label class="layui-form-label"><span class="font-red"></span></label>' +
                                                '<div class="layui-input-inline">' +
                                                '<input type="text" value="' + dateStr + '" class="layui-input salaryDate" onfocus="WdatePicker({dateFmt:\'yyyy-MM-dd\',readOnly:true})">' +
                                                '</div>' +
                                                '</div>';
                                    }
                                }
                                $("#businessMethodGzDiv").append(html);
                            }

                            $("#businessMethodGzDiv").show("slow");
                        }
                        else if (obj.id == 6) {
                            $("#businessMethodSyDiv").show();
                            // 商业险
                            $("input[name='billMadeMethodSy']").each(function () {
                                for (var j = 0; j < obj.businessItems.length; j++) {
                                    if ($(this).val() == obj.businessItems[j].id) {
                                        $(this).attr("checked", true);
                                        $(this).parent().find("input[type=number]").val(obj.businessItems[j].price).show("fast");
                                    }
                                }
                            })
                        }
                        else if (obj.id == 7) {
                            // 一次性业务
                            $("#businessMethodTjDiv").show();
                            $("input[name='billMadeMethodYc']").each(function () {
                                for (var j = 0; j < obj.businessItems.length; j++) {
                                    if ($(this).val() == obj.businessItems[j].id) {
                                        $(this).attr("checked", true);
                                        $(this).parent().next().find("input[type=number]").val(obj.businessItems[j].price).removeAttr("disabled");
                                        $(this).parent().next().next().show("fast");
                                    }
                                }
                            })
                        }
                        break;
                    }
                }
            });
            // 业务月序周期
            businessCycleBlur(null, $scope.company.businessCycle);
            $("#businessCycleDiv").show("slow");
            // 服务费月序周期
//            serviceFeeCycleBlur(null, $scope.company.serviceFeeCycle);
            $("#serviceFeeCycleDiv").show("slow");
            // 初始化合作方式
            initData($scope.company);
            form.on('checkbox(businessItemChecked)', function (data) {
                if(undefined == $(data.elem).attr("isCompany")){
                    return;
                }
                if (data.elem.checked) {
                    $(data.elem).parent().parent().find(".check-input").prop("disabled", false);
                    $(data.elem).parent().next().next().show("fast");
                } else {
                    $(data.elem).parent().parent().find(".check-input").prop("disabled", true);
                    $(data.elem).parent().next().next().hide("fast");
                }

            });

            // 图片文本初始化
            if (null != $scope.company.license && '' != $scope.company.license) {
                var htmls = '<div class="preview">' +
                        '<img src="' + AM.ip + '/' + $scope.company.license + '"><br>' +
                        "</div>";
                $("#previewApp").append(htmls);
                $("#previewApp").parent().show("slow");
            }
            if (null != $scope.company.licenseTranscript && '' != $scope.company.licenseTranscript) {
                var htmls = '<div class="preview">' +
                        '<img src="' + AM.ip + '/' + $scope.company.licenseTranscript + '"><br>' +
                        "</div>";
                $("#previewPC").append(htmls);
                $("#previewPC").parent().show("slow");
            }
            if (null != $scope.company.taxpayerProve && '' != $scope.company.taxpayerProve) {
                var htmls = '<div class="preview">' +
                        '<img src="' + AM.ip + '/' + $scope.company.taxpayerProve + '"><br>' +
                        "</div>";
                $("#taxpayerProvePreview").append(htmls);
                $("#taxpayerProvePreview").parent().show("slow");
            }
            if (null != $scope.company.subsidyProve && '' != $scope.company.subsidyProve) {
                var htmls = '<div class="preview">' +
                        '<img src="' + AM.ip + '/' + $scope.company.subsidyProve + '"><br>' +
                        "</div>";
                $("#subsidyProvePreview").append(htmls);
                $("#subsidyProvePreview").parent().show("slow");
            }

            if (null != $scope.company.otherProve) {
                var others = $scope.company.otherProve.split(",");
                var html = "";
                for (var i = 0; i < others.length; i++) {
                    if (others[i] == "") {
                        continue;
                    }
                    html += '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + others[i] + '"><br>' +
                            "</div>";
                    arrImg.push(others[i]);
                }
                $("#otherProvePreview").append(html);
                $("#otherProvePreview").parent().show("slow");
            }


            form.on('checkbox(ssCheckBoxFilter)', function (data) {
                if (data.elem.checked) {
                    // 如果选中
                    if (data.value == 1) {
                        // 如果选择了托管 则禁用预收
                        $("#tuoGuanSS").show();
                    } else {
                        $("#daiLiSS").show();
                    }
                } else {
                    if (data.value == 1) {
                        // 如果选择了托管 则禁用预收
                        $("#tuoGuanSS").hide();
                    } else {
                        $("#daiLiSS").hide();
                    }
                }
            });
            form.on('checkbox(boxCheckedPf)', function (data) {
                if (data.elem.checked) {
                    // 如果选中
                    if (data.value == 1) {
                        // 如果选择了托管 则禁用预收
                        $("#tuoGuanPf").show();
                    } else {
                        $("#daiLiPf").show();
                    }
                } else {
                    if (data.value == 1) {
                        // 如果选择了托管 则禁用预收
                        $("#tuoGuanPf").hide();
                    } else {
                        $("#daiLiPf").hide();
                    }
                }
            });


            //其他情况说明
            layui.upload({
                url: AM.ip + "/res/upload" //上传接口
                , elem: '#otherProveImg'
                , before: function () {
                    uploadMsg = layer.msg('上传中，请不要刷新页面', {icon: 16, shade: 0.5, time: 100000000})
                }
                , success: function (res) { //上传成功后的回调
                    arrImg.push(res.data.url);
                    console.info("上传");
                    console.info(arrImg);
                    var html = '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + res.data.url + '"><br>' +
                            "</div>";
                    $("#otherProvePreview").append(html);
                    $("#otherProvePreview").parent().show("slow");
                    layer.close(uploadMsg);
                    form.render();
                }
            });

            //稳岗补贴情况
            layui.upload({
                url: AM.ip + "/res/upload" //上传接口
                , elem: '#subsidyProveImg'
                , before: function () {
                    uploadMsg = layer.msg('上传中，请不要刷新页面', {icon: 16, shade: 0.5, time: 100000000})
                }
                , success: function (res) { //上传成功后的回调
                    $("#subsidyProve").val(res.data.url);
                    var html = '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + res.data.url + '"><br>' +
                            "</div>";
                    $("#subsidyProvePreview").append(html);
                    $("#subsidyProvePreview").parent().show("slow");
                    $("#subsidyProveDiv").hide("slow");
                    layer.close(uploadMsg);
                    form.render();
                }
            });

            //一般纳税人证明
            layui.upload({
                url: AM.ip + "/res/upload" //上传接口
                , elem: '#taxpayerProveImg'
                , before: function () {
                    uploadMsg = layer.msg('上传中，请不要刷新页面', {icon: 16, shade: 0.5, time: 100000000})
                }
                , success: function (res) { //上传成功后的回调
                    $("#taxpayerProve").val(res.data.url);
                    var html = '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + res.data.url + '"><br>' +
                            "</div>";
                    $("#taxpayerProvePreview").append(html);
                    $("#taxpayerProvePreview").parent().show("slow");
                    $("#taxpayerProveDiv").hide("slow");
                    layer.close(uploadMsg);
                    form.render();
                }
            });

            //上传营业执照正本
            layui.upload({
                url: AM.ip + "/res/upload" //上传接口
                , elem: '#fileAppImg'
                , before: function () {
                    uploadMsg = layer.msg('上传中，请不要刷新页面', {icon: 16, shade: 0.5, time: 100000000})
                }
                , success: function (res) { //上传成功后的回调
                    $("#license").val(res.data.url);
                    var html = '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + res.data.url + '"><br>' +
                            "</div>";
                    $("#previewApp").append(html);
                    $("#previewApp").parent().show("slow");
                    $("#uploadImgDivApp").hide("slow");
                    layer.close(uploadMsg);
                    form.render();
                }
            });


            //上传营业执照副本
            layui.upload({
                url: AM.ip + "/res/upload" //上传接口
                , elem: '#filePCImg'
                , before: function () {
                    uploadMsg = layer.msg('上传中，请不要刷新页面', {icon: 16, shade: 0.5, time: 100000000})
                }
                , success: function (res) {
                    console.log(res.data.url);
                    $("#licenseTranscript").val(res.data.url);
                    var html = '<div class="preview">' +
                            '<img src="' + AM.ip + '/' + res.data.url + '"><br>' +
                            "</div>";
                    $("#previewPC").append(html);
                    $("#previewPC").parent().show("slow");
                    layer.close(uploadMsg);
                    $("#uploadImgDivPC").hide("slow");
                }
            });
            //自定义验证规则
            form.verify({
                isNumber: function (value) {
                    if (value.length > 0 && !AM.isNumber.test(value)) {
                        return "请输入一个整数";
                    }
                },
            });


//            var serviceFeeId = $scope.company.serviceFeeConfigId;
            var serviceFeeId = 1000;
            if (serviceFeeId == 1
                    || serviceFeeId == 5 || serviceFeeId == 6 || serviceFeeId == 8) {
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

                $("#serviceFeePlaceDiv").hide("fast");
                $("#addServiceConfig").hide("fast");
                $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");
                // 初始化参数
                if (null != $scope.company.feeList) {
                    $("#serviceFee").val($scope.company.feeList[0].price);
                }

            } else if (serviceFeeId == 3) {

                var serviceFeeList = $scope.company.serviceFeeList;
//                var businessObj = [];
//                var businessArray = [3,4,5];
//
//                var resultArr = [];
//                resultArr[resultArr.length] = "3,4,5";
//                for (var  i = 0 ; i < businessArray.length ; i++){
//                    for (var  j = i + 1; j < businessArray.length; j++){
//                        resultArr[resultArr.length] = businessArray[i]+","+businessArray[j];
//                    }
//                }
//                for(var  i = 0 ; i < businessArray.length ; i++){
//                    resultArr[resultArr.length] = businessArray[i]+"";
//                }
                var businessObj = new Array();
                var str = "";
                $("input[name='businessArr']:checked").each(function(){
                    var o = $(this).val();
                    // 设置业务
                    if(o == 3 || o == 4 || o == 5){
                        businessObj.push(o);
                        str += o + ",";
                    }
                });
                var businessArray = businessObj;
                var resultArr = [];
                resultArr[resultArr.length] = str.substring(0,str.length - 1);
                for (var i = 0; i < businessArray.length; i++) {
                    for (var j = i + 1; j < businessArray.length; j++) {
                        var isExist = false;
                        var obj = businessArray[i] + "," + businessArray[j];
                        for(var k = 0; k < resultArr.length; k++){
                            if(obj == resultArr[k]){
                                isExist = true;
                                break;
                            }
                        }
                        if(!isExist){
                            resultArr[resultArr.length] = obj;
                        }

                    }
                }
                for (var i = 0; i < businessArray.length; i++) {
                    var isExist = false;
                    for(var j = 0; j < resultArr.length; j++){
                        if(businessArray[i] == resultArr[j]){
                            isExist = true;
                            break;
                        }
                    }
                    if(!isExist){
                        resultArr[resultArr.length] = businessArray[i];
                    }
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

                $("#serviceFeePlaceDiv").hide("fast");
                $("#addServiceConfig").hide("fast");
                $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");

            }else if (serviceFeeId == 4) {

                // 初始化缴金地
                queryAllPayPlace($scope.company.servicePayPlaceList[0].cityId, "serviceFeePlace","post",0);
                $("#serviceConfigFeePlacePrice").val($scope.company.servicePayPlaceList[0].price);
                if ($scope.company.servicePayPlaceList.length > 0) {
                    // 服务区
                    $("#serviceFeePlaceDiv").show("fast");
                    $("#addServiceConfig").show("fast");
                    $(".serviceConfigFeePlace").attr("lay-verify", "required");
                    $(".serviceConfigFeePlacePrice").attr("lay-verify", "required");
                }
                //服务费区间
                for (var i = 1; i < $scope.company.servicePayPlaceList.length; i++) {
                    var obj = $scope.company.servicePayPlaceList[i];
                    addServiceConfig(obj.cityId, obj.price, "addServiceConfig_" + obj.cityId);
                }

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

                $("#serviceFeePlaceDiv").hide("fast");
                $("#addServiceConfig").hide("fast");
                $("#serviceFeePlaceDiv").find("select[name=serviceConfigFeePlace]").removeAttr("lay-verify");
                $("#serviceFeePlaceDiv").find("input[name=serviceConfigFeePlacePrice]").removeAttr("lay-verify");
                // 初始化参数
                var msg = "";
                if(serviceFeeId == 2){
                    msg = "单位:元/人*服务月";
                }
                if (null != $scope.company.feeList) {
                    var html = "";
                    for (var i = 0; i < $scope.company.feeList.length; i++) {
                        if (i == 0) {
                            $("#firstExtentNum").val($scope.company.feeList[i].extent);
                            $("#firstExtentPrice").val($scope.company.feeList[i].price);
                        } else {
                            html +=
                                    '<div class="layui-form-item">' +
                                    '<label class="layui-form-label">人数低于</label>' +
                                    '<div class="layui-input-inline">' +
                                    '<input type="text" value="' + $scope.company.feeList[i].extent + '" class="layui-input extentNum" lay-verify="required|isNumber"' +
                                    'placeholder="请输入"/>' +
                                    '</div>' +
                                    '<div class="layui-form-mid layui-word-aux unitId">'+msg+'</div>' +
                                    '<div class="layui-input-inline">' +
                                    '<input type="text" value="' + $scope.company.feeList[i].price + '" class="layui-input extentPrice" lay-verify="required|isDouble"' +
                                    'placeholder="请输入服务费"/>' +
                                    '</div>' +
                                    '</div>';
                        }
                    }
                    $("#extentDiv").append(html);

                }


            }


            form.render();



            <!-- cooperationMethodFilter 合作方式  开始  -->

            form.on('checkbox(cooperationMethodFilter)', function (data) {
                if (data.elem.checked) {
                    // 如果选中
                    if (data.value == 0) {
                        // 选中普通
                        $("#cooperationMethodDiv").show("fast")
                        // 增加验证
                        $("#cooperationMethodPTServiceFeeStartTime").attr("lay-verify","required");
                        $("#cooperationMethodPTServiceFeeCycle").attr("lay-verify","required");
                        $("#cooperationMethodPTServiceFeeConfigId").attr("lay-verify","required");



                    }else if (data.value == 1){
                        // 选中派遣
                        $("#cooperationMethodPQDiv").show("fast");
                        $("#cooperationMethodPQServiceFeeStartTime").attr("lay-verify","required");
                        $("#cooperationMethodPQServiceFeeCycle").attr("lay-verify","required");
                        $("#cooperationMethodPQServiceFeeConfigId").attr("lay-verify","required");
                    } else if(data.value == 2) {
                        // 选中外包
                        $("#cooperationMethodWBDiv").show("fast")
                        $("#cooperationMethodWBServiceFeeStartTime").attr("lay-verify","required");
                        $("#cooperationMethodWBServiceFeeCycle").attr("lay-verify","required");
                        $("#cooperationMethodWBServiceFeeConfigId").attr("lay-verify","required");
                    }
                } else {
                    if (data.value == 0) {
                        // 取消普通
                        $("#cooperationMethodDiv").hide("fast")
                        $("#cooperationMethodPTServiceFeeStartTime").removeAttr("lay-verify");
                        $("#cooperationMethodPTServiceFeeCycle").removeAttr("lay-verify");
                        $("#cooperationMethodPTServiceFeeConfigId").removeAttr("lay-verify");
                    }else if (data.value == 1){
                        // 取消派遣
                        $("#cooperationMethodPQDiv").hide("fast")
                        $("#cooperationMethodPQServiceFeeStartTime").removeAttr("lay-verify");
                        $("#cooperationMethodPQServiceFeeCycle").removeAttr("lay-verify");
                        $("#cooperationMethodPQServiceFeeConfigId").removeAttr("lay-verify");
                    } else if(data.value == 2) {
                        // 取消外包
                        $("#cooperationMethodWBDiv").hide("fast")
                        $("#cooperationMethodWBServiceFeeStartTime").removeAttr("lay-verify");
                        $("#cooperationMethodWBServiceFeeCycle").removeAttr("lay-verify");
                        $("#cooperationMethodWBServiceFeeConfigId").removeAttr("lay-verify");
                    }
                }
            });


            <!-- cooperationMethodFilter 合作方式  结束  -->


            <!-- 普通合作方式监听服务费配置选择    开始 -->
            form.on('select(cooperationMethodPTChangeServiceFeeConfig)', function (data) {
                if (data.value == 8) {
                    $("#cooperationMethodPTAssist").html(" %");
                }else if(data.value == 1){
                    $("#cooperationMethodPTAssist").html(" 元/人*服务月");
                } else if(data.value == 5) {
                    $("#cooperationMethodPTAssist").html("元/次");
                } else if(data.value == 6) {
                    $("#cooperationMethodPTAssist").html("元");
                }else {
                    $("#cooperationMethodPTAssist").html("");
                }

                if(data.value == 5){
                    $("#cooperationMethodPTBaseDiv").show("fast");
                    $("#cooperationMethodPTBase").attr("lay-verify","required");
                }
                else{
                    $("#cooperationMethodPTBaseDiv").hide("fast");
                    $("#cooperationMethodPTBase").removeAttr("lay-verify");
                }
                if (data.value == 1
                        || data.value == 5 || data.value == 6 || data.value == 8) {
                    $("#cooperationMethodPTServiceFeeDiv").show("fast");
                    $("#cooperationMethodPTServiceFee").attr("lay-verify", "required");
                    $("#cooperationMethodPTExtentDiv").hide("fast");
                    $(".cooperationMethodPTExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPTExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodPTAddConfigBtn").hide("fast");
                    $("#cooperationMethodPTServiceFeeForType").hide("fast");
                    $("#cooperationMethodPTServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPTAddServiceConfig").hide("fast");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("select[name=cooperationMethodPTServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("input[name=cooperationMethodPTServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if (data.value == 3) {
                    // 按服务类别收费 如社保、公积金、工资等
                    // 获取已经选择了的(社保、公积金、工资)业务
                    //如果没有选择以上 业务， 则不显示其他组件
                    var html = getServiceConfigHtml();
                    $("#cooperationMethodPTServiceFeeForType").html(html);
                    $("#cooperationMethodPTServiceFeeForType").show("fast");
                    $("#cooperationMethodPTServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPTServiceFee").removeAttr("lay-verify");

                    $("#cooperationMethodPTExtentDiv").hide("fast");
                    $(".cooperationMethodPTExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPTExtentPrice").removeAttr("lay-verify");

                    $("#cooperationMethodPTAddConfigBtn").hide("fast");


                    $("#cooperationMethodPTServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPTAddServiceConfig").hide("fast");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("select[name=cooperationMethodPTServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("input[name=cooperationMethodPTServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if(data.value == 4){
                    // 服务区
                    $("#cooperationMethodPTServiceFeePlaceDiv").show("fast");
                    $("#cooperationMethodPTAddServiceConfig").show("fast");
                    $(".cooperationMethodPTServiceConfigFeePlace").attr("lay-verify", "required");
                    $(".cooperationMethodPTServiceConfigFeePlacePrice").attr("lay-verify", "required");

                    $("#cooperationMethodPTServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPTServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodPTExtentDiv").hide("fast");
                    $(".cooperationMethodPTExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPTExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodPTAddConfigBtn").hide("fast");
                    $("#cooperationMethodPTServiceFeeForType").hide("fast");

                }else {

                    if(data.value == 2){
                        $(".cooperationMethodPTUnitId").each(function(){
                            $(this).html(" 元/人*服务月")
                        })
                    }
                    if(data.value == 7){
                        $(".cooperationMethodPTUnitId").each(function(){
                            $(this).html("")
                        })
                    }

                    $("#cooperationMethodPTAddConfigBtn").show("fast");
                    $("#cooperationMethodPTServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPTServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodPTServiceFeeForType").hide("fast");

                    $("#cooperationMethodPTExtentDiv").show("fast");
                    $(".cooperationMethodPTExtentNum").attr("lay-verify", "required");
                    $(".cooperationMethodPTExtentPrice").attr("lay-verify", "required");

                    $("#cooperationMethodPTServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPTAddServiceConfig").hide("fast");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("select[name=cooperationMethodPTServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPTServiceFeePlaceDiv").find("input[name=cooperationMethodPTServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                }
            });
            <!-- 普通合作方式监听服务费配置选择    结束 -->




            <!-- 派遣合作方式监听服务费配置选择    开始 -->
            form.on('select(cooperationMethodPQChangeServiceFeeConfig)', function (data) {
                if (data.value == 8) {
                    $("#cooperationMethodPQAssist").html(" %");
                }else if(data.value == 1){
                    $("#cooperationMethodPQAssist").html(" 元/人*服务月");
                } else if(data.value == 5) {
                    $("#cooperationMethodPTAssist").html("元/次");
                } else if(data.value == 6) {
                    $("#cooperationMethodPTAssist").html("元");
                }else {
                    $("#cooperationMethodPQAssist").html("");
                }

                if(data.value == 5){
                    $("#cooperationMethodPQBaseDiv").show("fast");
                    $("#cooperationMethodPQBase").attr("lay-verify","required");
                }
                else{
                    $("#cooperationMethodPQBaseDiv").hide("fast");
                    $("#cooperationMethodPQBase").removeAttr("lay-verify");
                }
                if (data.value == 1
                        || data.value == 5 || data.value == 6 || data.value == 8) {
                    $("#cooperationMethodPQServiceFeeDiv").show("fast");
                    $("#cooperationMethodPQServiceFee").attr("lay-verify", "required");
                    $("#cooperationMethodPQExtentDiv").hide("fast");
                    $(".cooperationMethodPQExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPQExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodPQAddConfigBtn").hide("fast");
                    $("#cooperationMethodPQServiceFeeForType").hide("fast");
                    $("#cooperationMethodPQServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPQAddServiceConfig").hide("fast");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("select[name=cooperationMethodPQServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("input[name=cooperationMethodPQServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if (data.value == 3) {
                    // 按服务类别收费 如社保、公积金、工资等
                    // 获取已经选择了的(社保、公积金、工资)业务
                    //如果没有选择以上 业务， 则不显示其他组件
                    var html = getServiceConfigHtml();
                    $("#cooperationMethodPQServiceFeeForType").html(html);
                    $("#cooperationMethodPQServiceFeeForType").show("fast");
                    $("#cooperationMethodPQServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPQServiceFee").removeAttr("lay-verify");

                    $("#cooperationMethodPQExtentDiv").hide("fast");
                    $(".cooperationMethodPQExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPQExtentPrice").removeAttr("lay-verify");

                    $("#cooperationMethodPQAddConfigBtn").hide("fast");


                    $("#cooperationMethodPQServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPQAddServiceConfig").hide("fast");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("select[name=cooperationMethodPQServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("input[name=cooperationMethodPQServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if(data.value == 4){
                    // 服务区
                    $("#cooperationMethodPQServiceFeePlaceDiv").show("fast");
                    $("#cooperationMethodPQAddServiceConfig").show("fast");
                    $(".cooperationMethodPQServiceConfigFeePlace").attr("lay-verify", "required");
                    $(".cooperationMethodPQServiceConfigFeePlacePrice").attr("lay-verify", "required");

                    $("#cooperationMethodPQServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPQServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodPQExtentDiv").hide("fast");
                    $(".cooperationMethodPQExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodPQExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodPQAddConfigBtn").hide("fast");
                    $("#cooperationMethodPQServiceFeeForType").hide("fast");

                }else {

                    if(data.value == 2){
                        $(".cooperationMethodPQUnitId").each(function(){
                            $(this).html(" 元/人*服务月")
                        })
                    }
                    if(data.value == 7){
                        $(".cooperationMethodPQUnitId").each(function(){
                            $(this).html("")
                        })
                    }

                    $("#cooperationMethodPQAddConfigBtn").show("fast");
                    $("#cooperationMethodPQServiceFeeDiv").hide("fast");
                    $("#cooperationMethodPQServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodPQServiceFeeForType").hide("fast");

                    $("#cooperationMethodPQExtentDiv").show("fast");
                    $(".cooperationMethodPQExtentNum").attr("lay-verify", "required");
                    $(".cooperationMethodPQExtentPrice").attr("lay-verify", "required");

                    $("#cooperationMethodPQServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodPQAddServiceConfig").hide("fast");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("select[name=cooperationMethodPQServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodPQServiceFeePlaceDiv").find("input[name=cooperationMethodPQServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                }
            });
            <!-- 派遣合作方式监听服务费配置选择    结束 -->




            <!-- 外包合作方式监听服务费配置选择    开始 -->
            form.on('select(cooperationMethodWBChangeServiceFeeConfig)', function (data) {
                if (data.value == 8) {
                    $("#cooperationMethodWBAssist").html(" %");
                }else if(data.value == 1){
                    $("#cooperationMethodWBAssist").html(" 元/人*服务月");
                } else if(data.value == 5) {
                    $("#cooperationMethodPTAssist").html("元/次");
                } else if(data.value == 6) {
                    $("#cooperationMethodPTAssist").html("元");
                }else {
                    $("#cooperationMethodWBAssist").html("");
                }


                if(data.value == 5){
                    $("#cooperationMethodWBBaseDiv").show("fast");
                    $("#cooperationMethodWBBase").attr("lay-verify","required");
                }
                else{
                    $("#cooperationMethodWBBaseDiv").hide("fast");
                    $("#cooperationMethodWBBase").removeAttr("lay-verify");
                }
                if (data.value == 1
                        || data.value == 5 || data.value == 6 || data.value == 8) {
                    $("#cooperationMethodWBServiceFeeDiv").show("fast");
                    $("#cooperationMethodWBServiceFee").attr("lay-verify", "required");
                    $("#cooperationMethodWBExtentDiv").hide("fast");
                    $(".cooperationMethodWBExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodWBExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodWBAddConfigBtn").hide("fast");
                    $("#cooperationMethodWBServiceFeeForType").hide("fast");
                    $("#cooperationMethodWBServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodWBAddServiceConfig").hide("fast");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("select[name=cooperationMethodWBServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("input[name=cooperationMethodWBServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if (data.value == 3) {
                    // 按服务类别收费 如社保、公积金、工资等
                    // 获取已经选择了的(社保、公积金、工资)业务
                    //如果没有选择以上 业务， 则不显示其他组件
                    var html = getServiceConfigHtml();
                    $("#cooperationMethodWBServiceFeeForType").html(html);
                    $("#cooperationMethodWBServiceFeeForType").show("fast");
                    $("#cooperationMethodWBServiceFeeDiv").hide("fast");
                    $("#cooperationMethodWBServiceFee").removeAttr("lay-verify");

                    $("#cooperationMethodWBExtentDiv").hide("fast");
                    $(".cooperationMethodWBExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodWBExtentPrice").removeAttr("lay-verify");

                    $("#cooperationMethodWBAddConfigBtn").hide("fast");


                    $("#cooperationMethodWBServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodWBAddServiceConfig").hide("fast");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("select[name=cooperationMethodWBServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("input[name=cooperationMethodWBServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                } else if(data.value == 4){
                    // 服务区
                    $("#cooperationMethodWBServiceFeePlaceDiv").show("fast");
                    $("#cooperationMethodWBAddServiceConfig").show("fast");
                    $(".cooperationMethodWBServiceConfigFeePlace").attr("lay-verify", "required");
                    $(".cooperationMethodWBServiceConfigFeePlacePrice").attr("lay-verify", "required");

                    $("#cooperationMethodWBServiceFeeDiv").hide("fast");
                    $("#cooperationMethodWBServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodWBExtentDiv").hide("fast");
                    $(".cooperationMethodWBExtentNum").removeAttr("lay-verify");
                    $(".cooperationMethodWBExtentPrice").removeAttr("lay-verify");
                    $("#cooperationMethodWBAddConfigBtn").hide("fast");
                    $("#cooperationMethodWBServiceFeeForType").hide("fast");

                }else {

                    if(data.value == 2){
                        $(".cooperationMethodWBUnitId").each(function(){
                            $(this).html(" 元/人*服务月")
                        })
                    }
                    if(data.value == 7){
                        $(".cooperationMethodWBUnitId").each(function(){
                            $(this).html("")
                        })
                    }

                    $("#cooperationMethodWBAddConfigBtn").show("fast");
                    $("#cooperationMethodWBServiceFeeDiv").hide("fast");
                    $("#cooperationMethodWBServiceFee").removeAttr("lay-verify");
                    $("#cooperationMethodWBServiceFeeForType").hide("fast");

                    $("#cooperationMethodWBExtentDiv").show("fast");
                    $(".cooperationMethodWBExtentNum").attr("lay-verify", "required");
                    $(".cooperationMethodWBExtentPrice").attr("lay-verify", "required");

                    $("#cooperationMethodWBServiceFeePlaceDiv").hide("fast");
                    $("#cooperationMethodWBAddServiceConfig").hide("fast");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("select[name=cooperationMethodWBServiceConfigFeePlace]").removeAttr("lay-verify");
                    $("#cooperationMethodWBServiceFeePlaceDiv").find("input[name=cooperationMethodWBServiceConfigFeePlacePrice]").removeAttr("lay-verify");
                }
            });
            <!-- 外包合作方式监听服务费配置选择    结束 -->


            var cooperationMethodPTServiceFeeStartTime = {
                max: '2099-12-30'
                , format: 'YYYY-MM-DD'
                , istoday: false
                , choose: function (datas) {
                }
            };

            document.getElementById('cooperationMethodPTServiceFeeStartTime').onclick = function () {
                cooperationMethodPTServiceFeeStartTime.elem = this;
                laydate(cooperationMethodPTServiceFeeStartTime);
                $("#cooperationMethodPTServiceFeeCycleDiv").show("slow");
            }


            var cooperationMethodPQServiceFeeStartTime = {
                max: '2099-12-30'
                , format: 'YYYY-MM-DD'
                , istoday: false
                , choose: function (datas) {
                }
            };

            document.getElementById('cooperationMethodPQServiceFeeStartTime').onclick = function () {
                cooperationMethodPQServiceFeeStartTime.elem = this;
                laydate(cooperationMethodPQServiceFeeStartTime);
                $("#cooperationMethodPQServiceFeeCycleDiv").show("slow");
            }
            var cooperationMethodWBServiceFeeStartTime = {
                max: '2099-12-30'
                , format: 'YYYY-MM-DD'
                , istoday: false
                , choose: function (datas) {
                }
            };

            document.getElementById('cooperationMethodWBServiceFeeStartTime').onclick = function () {
                cooperationMethodWBServiceFeeStartTime.elem = this;
                laydate(cooperationMethodWBServiceFeeStartTime);
                $("#cooperationMethodWBServiceFeeCycleDiv").show("slow");
            }
            var businessStartTime = {
                max: '2099-12-30'
                , format: 'YYYY-MM-DD'
                , istoday: false
                , choose: function (datas) {
//                validityEndTimes.start = datas //将结束日的初始值设定为开始日
                }
            };
            document.getElementById('businessStartTime').onclick = function () {
                businessStartTime.elem = this;
                laydate(businessStartTime);
                $("#businessCycleDiv").show("slow");
            }



            // 监听服务费配置选择
            form.on('select(changeServiceFeeConfig)', function (data) {
                if (data.value == 1
                        || data.value == 5 || data.value == 6 || data.value == 8) {
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

                    // 生成文本框
                    var html = getServiceConfigHtml();
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
                } else if (data.value == 4) {
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
                    $("#serviceFeeSBDIV").hide("fast");
                    $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                    $("#serviceFeeGJJDIV").hide("fast");
                    $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                    $("#serviceFeeGZDIV").hide("fast");
                    $("input[name='serviceFeeGZ']").removeAttr("lay-verify");
                    $("#serviceFeeForType").hide("fast");
                }
                else {

                    if(data.value == 2){
                        $(".unitId").each(function(){
                            $(this).html(" 元/人*服务月")
                        })
                    }
                    if(data.value == 7){
                        $(".unitId").each(function(){
                            $(this).html("")
                        })
                    }

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
            //监听类型


            form.on('checkbox(boxChecked)', function (data) {
                var serviceFeeConfigId = $("#serviceFeeConfigId").val();
                if (data.elem.checked) {
                    // 如果选中，判断业务规则
                    var array = [];
                    $("input[name='businessArr']:checked").each(function () {
                        var val = $(this).val();
                        array.push(val);
                    });
                    // 判断业务规则
                    if(data.value == 1){
                        for (var i = 0; i < array.length; i++) {
                            if (array[i] == 2 ) {
                                layer.msg('派遣外包只能选择其一', {icon: 2, anim: 6});
                                $(data.elem).attr("checked", false);
                                form.render();
                                return;
                            }
                        }
                    }
                    if(data.value == 2){
                        for (var i = 0; i < array.length; i++) {
                            if (array[i] ==1 ) {
                                layer.msg('派遣外包只能选择其一', {icon: 2, anim: 6});
                                $(data.elem).attr("checked", false);
                                form.render();
                                return;
                            }
                        }
                    }

                    if (data.value == 3) {
                        // 选择社保
                        $("#businessMethodSSDiv").show("fast");
                        $("#businessMethodSS").attr("lay-verify", "required");
                        // 配置管理
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeSBDIV").show("fast");
                            $("input[name='serviceFeeSB']").attr("lay-verify", "required");
                        }
                    }
                    if (data.value == 4) {
                        // 选择公积金
                        $("#businessMethodPfDiv").show("fast");
                        $("#businessMethodPf").attr("lay-verify", "required");
                        // 配置管理
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeGJJDIV").show("fast");
                            $("input[name='serviceFeeGJJ']").attr("lay-verify", "required");
                        }
                    }
                    if (data.value == 1) {
                        // 派遣
                        $("#businessMethodPqDiv").show("fast")
                    }
                    if (data.value == 2) {
                        // 外包
                        $("#businessMethodWbDiv").show("fast")
                    }
                    if (data.value == 5) {
                        // 工资
                        $("#businessMethodGzDiv").show("fast");
                        // 配置管理
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeGZDIV").show("fast");
                            $("input[name='serviceFeeGZ']").attr("lay-verify", "required");
                        }
                    }
                    if (data.value == 6) {
                        // 商业险
                        $("#businessMethodSyDiv").show("fast")
                    }
                    if (data.value == 7) {
                        // 体检
                        $("#businessMethodTjDiv").show("fast")
                    }

                } else {
                    if (data.value == 3) {
                        // 选择社保
                        $("#businessMethodSSDiv").hide("fast");
                        $("#businessMethodSS").removeAttr("lay-verify");
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeSBDIV").hide("fast");
                            $("input[name='serviceFeeSB']").removeAttr("lay-verify");
                        }
                    }
                    if (data.value == 4) {
                        // 选择公积金
                        $("#businessMethodPfDiv").hide("fast");
                        $("#businessMethodPf").removeAttr("lay-verify");
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeGJJDIV").hide("fast");
                            $("input[name='serviceFeeGJJ']").removeAttr("lay-verify");
                        }
                    }

                    if (data.value == 1) {
                        // 派遣
                        $("#businessMethodPqDiv").hide("fast")
                    }
                    if (data.value == 2) {
                        // 外包
                        $("#businessMethodWbDiv").hide("fast")
                    }
                    if (data.value == 5) {
                        // 工资
                        $("#businessMethodGzDiv").hide("fast");
                        if (serviceFeeConfigId == 3) {
                            $("#serviceFeeGZDIV").hide("fast");
                            $("input[name='serviceFeeGZ']").removeAttr("lay-verify");
                        }
                    }
                    if (data.value == 6) {
                        // 商业险
                        $("#businessMethodSyDiv").hide("fast")
                    }
                    if (data.value == 7) {
                        // 体检
                        $("#businessMethodTjDiv").hide("fast")
                    }
                }

                var pt = $("#cooperationMethodPTServiceFeeConfigId").val();
                var pq = $("#cooperationMethodPQServiceFeeConfigId").val();
                var wb = $("#cooperationMethodWBServiceFeeConfigId").val();
                if(pt == 3){
                    var html = getServiceConfigHtml();
                    $("#cooperationMethodPTServiceFeeForType").html(html);
                    $("#cooperationMethodPTServiceFeeForType").show("fast");
                } if(pq == 3){
                    var html = getServiceConfigHtml();
                    $("#cooperationMethodPQServiceFeeForType").html(html);
                    $("#cooperationMethodPQServiceFeeForType").show("fast");
                }
                if(wb == 3){
                    $("#cooperationMethodWBServiceFeeForType").html(html);
                    $("#cooperationMethodWBServiceFeeForType").show("fast");
                }
            });


            $("select, input").prop("disabled", true);
            form.render();

        });
    });

    // 点击新增配置
    function addConfig(obj) {
        var val = $("#serviceFeeConfigId").val();
        var msg = "";
        if(val == 2){
            msg = " 元/人*服务月";
        }
        var html =
                '<div class="layui-form-item">' +
                '<label class="layui-form-label">人数低于</label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" class="layui-input extentNum" lay-verify="required|isNumber"' +
                'placeholder="请输入"/>' +
                '</div>' +
                '<div class="layui-form-mid layui-word-aux unitId">'+msg+'</div>' +
                '<div class="layui-input-inline">' +
                '<input type="text" class="layui-input extentPrice" lay-verify="required|isDouble"' +
                'placeholder="请输入服务费"/>' +
                '</div>' +
                '</div>';
        $("#extentDiv").append(html);
    }
    function delConfig(obj) {
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
                '   <label class="layui-form-label">选择缴金地</label>' +
                '   <div class="layui-input-inline">' +
                '       <select ' + selectedId + ' class="serviceConfigFeePlace" lay-verify="required" name="serviceConfigFeePlace">' +
                serviceConfigFeePlace +
                '       </select>' +
                '   </div>' +
                '   <label class="layui-form-label" >服务费</label>' +
                '   <div class="layui-input-inline">' +
                '       <input type="text" value="' + price + '" class="layui-input extentPrice" name="serviceConfigFeePlacePrice" lay-verify="required|isDouble" placeholder="请输入服务费"/>' +
                '   </div>' +
                '<div class="layui-form-mid layui-word-aux placeAux"> 元/人*服务月</div>' +
                '</div>';
        $("#serviceFeePlaceDiv").append(html);
        $("#" + id + " option").each(function () {
            if ($(this).val() == cityId) {
                $(this).attr("selected", true);
            }
        });
        form.render();
    }

    function addSalaryDate() {

        var html = '<div class="layui-form-item " style="margin-top: 5px" >' +
                '<label class="layui-form-label"><span class="font-red"></span></label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" class="layui-input salaryDate" onfocus="WdatePicker({dateFmt:\'yyyy-MM-dd\',readOnly:true})">' +
                '</div>' +
                '</div>';
        $("#businessMethodGzDiv").append(html);
    }
    function delSalaryDate(obj) {
        $(obj).parent().parent().remove();
    }

    //删除图片
    //删除图片
    function deleteImg(object, uploadView, urlValue) {
        $(object).parent().parent().parent().hide("slow");
        $(object).parent().remove();
        $("#" + uploadView + "").show("hide");
        $("#" + urlValue + "").val("");
    }
    function addSalaryDate() {

        var html = '<div class="layui-form-item " style="margin-top: 5px" >' +
                '<label class="layui-form-label"><span class="font-red"></span></label>' +
                '<div class="layui-input-inline">' +
                '<input type="text" class="layui-input salaryDate" onfocus="WdatePicker({dateFmt:\'yyyy-MM-dd\',readOnly:true})">' +
                '</div>' +
                '</div>';
        $("#businessMethodGzDiv").append(html);
    }
    function delSalaryDate(obj) {
        $(obj).parent().parent().remove();
    }

    //删除图片
    function deleteOtherImg(object, uploadView) {
        var url = $(object).attr("apiImage");
        for (var i = 0; i < arrImg.length; i++) {
            if (arrImg[i] == url) {
                arrImg.splice(i, 1);
            }
        }
        $(object).parent().remove();
        console.info(arrImg);
    }

    // 设置服务费月序周期 失去焦点事件
    function serviceFeeCycleBlur(obj, cc) {

        var date = $("#serviceFeeStartTime").val(); //服务费开始时间
        if (null != date && date != '') {
            var cycle = null == obj ? cc : $(obj).val(); // 周期月
            if (null == cycle || cycle == '') {
                $("#showServiceFeeCycleDiv").hide("slow");
                return;
            }
            var startTime = new Date(date);
            var arr = {
                cycle: cycle,
                time: startTime.getTime()
            };
            AM.ajaxRequestData("post", false, AM.ip + "/company/countTime", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    var html = "";
                    for (var i = 0; i < result.data.length; i++) {
                        var dateStr = result.data[i].split(",");
                        html += "<tr><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                    }
                    $("#dataBody").html(html);
                    $("#showServiceFeeCycleDiv").show("slow");
                }
            });
        } else {
            $("#showServiceFeeCycleDiv").hide("slow");
        }

    }

    function businessCycleBlur(obj, cc) {

        var date = $("#businessStartTime").val(); //服务费开始时间
        if (null != date && date != '') {
            var cycle = null == obj ? cc : $(obj).val(); // 周期月
            if(cycle <= 0){
                $(obj).val("");
                $("#businessDataBody").html("");
                $("#showBusinessCycleDiv").hide("fast");
                layer.msg('请输入一个正整数', {icon: 2, anim: 6});
                return;
            }
            if (null == cycle || cycle == '') {
                $("#showBusinessCycleDiv").hide("slow");
                return;
            }
            var startTime = new Date(date);
            var arr = {
                cycle: cycle,
                time: startTime.getTime()
            };
            AM.ajaxRequestData("post", false, AM.ip + "/company/countTime", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    var html = "";
                    for (var i = 0; i < result.data.length; i++) {
                        var dateStr = result.data[i].split(",");
                        html += "<tr><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                    }
                    $("#businessDataBody").html(html);
                    $("#showBusinessCycleDiv").show("slow");
                }
            });
        } else {
            $("#showBusinessCycleDiv").hide("slow");
        }

    }
</script>
</body>
</html>
