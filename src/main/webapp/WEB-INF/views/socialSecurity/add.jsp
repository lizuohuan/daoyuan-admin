<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加社保配置</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加社保配置</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="payPlaceId" name="payPlaceId" lay-verify="required" lay-search lay-filter="payPlace">
                    <option value="">请选择或搜索缴金地</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">经办机构<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="organizationName"  lay-verify="required" placeholder="请输入经办机构" autocomplete="off" class="layui-input" maxlength="50">
            </div>
            <div class="layui-form-mid layui-word-aux">社保局</div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">公司名字<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="transactorName"  lay-verify="required" placeholder="请输入公司名字" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">单位编码</label>
            <div class="layui-input-inline">
                <input type="text" name="coding" id="coding" placeholder="请输入单位编码" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>险种</legend>
        </fieldset>
        <div id="typesOfInsuranceHtml"></div>

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

    layui.use(['form', 'layedit'], function() {
        var form = layui.form();

        getPayPlaceByType(0, "payPlaceId", "post", 0, 0);
        $("input[name=transactorName]").val(sessionStorage.getItem("companyName"));
        form.render();

        form.verify({
            isDouble: function(value) {
                if(value.length > 0 && !AM.isDouble.test(value)) {
                    return "请输入一个小数";
                }
            },
        });

        //监听缴金地
        form.on('select(payPlace)', function(data) {
            getInsurance(data.value);
            form.render();
        });

        //监听单选
        form.on('radio(insurance)', function(data) {
            var payTheWaysId = data.elem.getAttribute("payTheWaysId");
            var insuranceId = data.elem.getAttribute("insuranceId");
            var isCompany = data.elem.getAttribute("isCompany");
            var value = data.value;
            if (isCompany == 1 && value == 1) {
                $("input[name=coPayPrice_" + payTheWaysId + "_" + insuranceId + "]").attr("placeholder", "请输入比例");
                $("input[name=coPayPrice_" + payTheWaysId + "_" + insuranceId + "]").parent().next().html("%");
            }
            else if (isCompany == 1 && value == 0) {
                $("input[name=coPayPrice_" + payTheWaysId + "_" + insuranceId + "]").attr("placeholder", "请输入金额");
                $("input[name=coPayPrice_" + payTheWaysId + "_" + insuranceId + "]").parent().next().html("元");
            }
            if (isCompany == 0 && value == 1) {
                $("input[name=mePayPrice_" + payTheWaysId + "_" + insuranceId + "]").attr("placeholder", "请输入比例");
                $("input[name=mePayPrice_" + payTheWaysId + "_" + insuranceId + "]").parent().next().html("%");
            }
            else if (isCompany == 0 && value == 0) {
                $("input[name=mePayPrice_" + payTheWaysId + "_" + insuranceId + "]").attr("placeholder", "请输入金额");
                $("input[name=mePayPrice_" + payTheWaysId + "_" + insuranceId + "]").parent().next().html("元");
            }
            form.render();
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            var dataArray = [];
            $("#typesOfInsuranceHtml .insuranceLevel").each(function () {
                var insuranceId = $(this).find("input[name=insuranceId]").val();
                var payTheWaysId = $(this).find("input[name=payTheWaysId]").val();
                var coPayType = $("input[name=companyInsurance_" + payTheWaysId + "_" + insuranceId + "]:checked").val(); //公司缴纳类型 0：金额  1：比例
                var coPayPrice = $("input[name=coPayPrice_" + payTheWaysId + "_" + insuranceId + "]").val();
                var mePayType = $("input[name=personInsurance_" + payTheWaysId + "_" + insuranceId + "]:checked").val(); //个人缴纳类型 0：金额  1：比例
                var mePayPrice = $("input[name=mePayPrice_" + payTheWaysId + "_" + insuranceId + "]").val();
                dataArray.push({
                    companyId : AM.getUrlParam("companyId"),
                    insuranceId : insuranceId,
                    insuranceLevelId : payTheWaysId,
                    coPayType : coPayType,
                    coPayPrice : coPayPrice,
                    mePayType : mePayType,
                    mePayPrice : mePayPrice,
                });
            });
            var parameter = {
                companyId : AM.getUrlParam("companyId"),
                payPlaceId : data.field.payPlaceId,
                organizationName : data.field.organizationName,
                transactorName : data.field.transactorName,
                type : 0,
                coding : $("#coding").val(),
                companyInsuranceJsonAry : JSON.stringify(dataArray)
            }
            AM.log(parameter);
            AM.ajaxRequestData("post", false, AM.ip + "/companyPayPlace/save", parameter  , function(result) {
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index);
                window.parent.closeNodeIframe();
            });
            return false;
        });
    });

    /**获取险种**/
    function getInsurance (payPlaceId) {
        AM.ajaxRequestData("post", false, AM.ip + "/insurance/getByPayPlaceId", {payPlaceId : payPlaceId}  , function(result) {
            var html = '';
            for (var i = 0; i < result.data.length; i++) {
                var insurance = result.data[i];
                var sonCoHtml = "",sonMeHtml = "";
                for (var j = 0; j < insurance.payTheWays.length; j++) {
                    var payTheWays = insurance.payTheWays[j];
                    var companyInsurance = "companyInsurance_" + payTheWays.insuranceLevelId + "_" + insurance.id;
                    var personInsurance = "personInsurance_" + payTheWays.insuranceLevelId + "_" + insurance.id;
                    var coPayPrice = "coPayPrice_" + payTheWays.insuranceLevelId + "_" + insurance.id;;
                    var mePayPrice = "mePayPrice_" + payTheWays.insuranceLevelId + "_" + insurance.id;;
                    if (payTheWays.coPayType == 2) {
                        sonCoHtml += '<section class="insuranceLevel">' +
                                '   <input type="hidden" name="insuranceId" value="' + insurance.id + '">' +
                                '   <input type="hidden" name="payTheWaysId" value="' + payTheWays.insuranceLevelId + '">' +
                                '   <div class="layui-field-box" style="margin-bottom: 30px;">' +
                                '       <label class="layui-form-label" style="width: 70px;">' + payTheWays.insuranceLevelName + '</label>' +
                                '       <div class="layui-input-inline" style="width: 170px;">' +
                                '           <input type="radio" isCompany="1" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + companyInsurance + '" value="1" lay-filter="insurance" title="比例" checked>' +
                                '           <input type="radio" isCompany="1" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + companyInsurance + '" value="0" lay-filter="insurance" title="金额">' +
                                '       </div>' +
                                '       <div class="layui-input-inline" style="width: 170px;">' +
                                '           <input type="text" name="' + coPayPrice + '" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="8">' +
                                '       </div>' +
                                '       <div class="layui-form-mid layui-word-aux">%</div>' +
                                '   </div></section>';
                    }
                    else {
                        sonCoHtml += '<section class="insuranceLevel" style="display: none;">' +
                                '   <input type="hidden" name="insuranceId" value="' + insurance.id + '">' +
                                '   <input type="hidden" name="payTheWaysId" value="' + payTheWays.insuranceLevelId + '">' +
                                '   <div class="layui-field-box" style="margin-bottom: 30px;">' +
                                '       <label class="layui-form-label" style="width: 70px;">' + payTheWays.insuranceLevelName + '</label>' +
                                '       <div class="layui-input-inline" style="width: 170px;">' +
                                '           <input type="radio" isCompany="1" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + companyInsurance + '" value="1" lay-filter="insurance" title="比例">' +
                                '           <input type="radio" isCompany="1" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + companyInsurance + '" value="0" lay-filter="insurance" title="金额" checked>' +
                                '       </div>' +
                                '       <div class="layui-input-inline" style="width: 170px;">' +
                                '           <input type="text" name="' + coPayPrice + '" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="8">' +
                                '       </div>' +
                                '       <div class="layui-form-mid layui-word-aux">%</div>' +
                                '   </div></section>';
                    }
                    if (payTheWays.mePayType == 2) {
                        sonMeHtml += '<div class="layui-field-box" style="margin-bottom: 30px;">' +
                                '         <label class="layui-form-label" style="width: 70px;">' + payTheWays.insuranceLevelName + '</label>' +
                                '           <div class="layui-input-inline" style="width: 170px;">' +
                                '               <input type="radio" isCompany="0" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + personInsurance + '" value="1" lay-filter="insurance" title="比例" checked>' +
                                '               <input type="radio" isCompany="0" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + personInsurance + '" value="0" lay-filter="insurance" title="金额">' +
                                '           </div>' +
                                '           <div class="layui-input-inline" style="width: 170px">' +
                                '                <input type="text" name="' + mePayPrice + '" lay-verify="required|isDouble" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="8">' +
                                '            </div>' +
                                '            <div class="layui-form-mid layui-word-aux">%</div>' +
                                '       </div>';
                    }
                    else {
                        sonMeHtml += '<div class="layui-field-box" style="margin-bottom: 30px;display: none;">' +
                                '         <label class="layui-form-label" style="width: 70px;">' + payTheWays.insuranceLevelName + '</label>' +
                                '           <div class="layui-input-inline" style="width: 170px;">' +
                                '               <input type="radio" isCompany="0" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + personInsurance + '" value="1" lay-filter="insurance" title="比例">' +
                                '               <input type="radio" isCompany="0" insuranceId="' + insurance.id + '" payTheWaysId="' + payTheWays.insuranceLevelId + '" name="' + personInsurance + '" value="0" lay-filter="insurance" title="金额" checked>' +
                                '           </div>' +
                                '           <div class="layui-input-inline" style="width: 170px">' +
                                '                <input type="text" name="' + mePayPrice + '" placeholder="请输入比例" autocomplete="off" class="layui-input" maxlength="8">' +
                                '            </div>' +
                                '            <div class="layui-form-mid layui-word-aux">%</div>' +
                                '       </div>';
                    }
                }
                
                html += '   <div class="layui-form-item">' +
                        '       <label class="layui-form-label">' + insurance.insuranceName + '<span class="font-red">*</span></label>' +
                        '       <div class="layui-input-block">' +
                        '           <fieldset class="layui-elem-field" style="float: left; width: 48%;padding-bottom: 15px;">' +
                        '               <legend>公司</legend>' +
                        sonCoHtml +
                        '           </fieldset>' +
                        '           <fieldset class="layui-elem-field" style="float: left; width: 48%;padding-bottom: 15px;">' +
                        '               <legend>个人</legend>' +
                        sonMeHtml +
                        '           </fieldset>' +
                        '       </div>' +
                        '   </div>';
            }
            $("#typesOfInsuranceHtml").html(result.data.length == 0 ? "<div style='padding-left: 200px;padding-bottom: 50px;'>暂无险种</div>" : html);
        });
    }

</script>
</body>
</html>
