<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加经办机构</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加经办机构</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>机构名称</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="organizationName" lay-verify="required" placeholder="请输入机构名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
            <div class="layui-form-mid layui-word-aux">公积金中心</div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">本月实做影响<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="operationType" lay-filter="operationType" lay-verify="required">
                    <option value="">请选择</option>
                    <option value="0">本月</option>
                    <option value="1">次月</option>
                    <option value="2">上月</option>
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux">账单</div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"><span>最晚实做日期</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="inTheEndTime" lay-verify="required|isValue" placeholder="请输入最晚实做日期" autocomplete="off" class="layui-input" maxlength="2">
            </div>
            <div class="layui-form-mid layui-word-aux">填写1-31日</div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>提醒日期</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="remindTime" lay-verify="required|isValue" onkeyup="onRemindTime(this)" placeholder="请输入提醒日期" autocomplete="off" class="layui-input" maxlength="2">
            </div>
            <div class="layui-form-mid layui-word-aux">填写1-31日，时间默认是最后一天的24点</div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>提醒内容</span><span class="font-red">*</span></label>
            <div class="layui-input-block">
                <div style="width: 400px;cursor: not-allowed;background: #EEEEEE" id="remindContent" class="layui-textarea">
                    <span id="cityName">XX</span>公积金中心本月变动将于<span id="day">XX</span>号<span id="dot">XX</span>点截止，请及时提交变动，避免影响<span id="operationTypeText">XX</span>账单，谢谢。
                </div>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>计算规则</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="computationRule" lay-filter="computationRule" lay-verify="required">
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
                <select name="computationalAccuracy" lay-verify="required">
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
                <select name="precision" lay-filter="precision" lay-verify="required">
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
                <input type="number" name="minCardinalNumber" placeholder="基数下限" autocomplete="off" class="layui-input" maxlength="10">
            </div>
            <div class="layui-form-mid">-</div>
            <div class="layui-input-inline" style="width: 150px;">
                <input type="number" name="maxCardinalNumber" placeholder="基数上限" autocomplete="off" class="layui-input" maxlength="10">
            </div>
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
    layui.use(['form', 'layedit'], function() {
        var form = layui.form();
        $("#cityName").html(sessionStorage.getItem("mergerName"));
        form.verify({
            isDouble: function(value) {
                if(value.length > 0 && !AM.isDouble.test(value)) {
                    return "请输入一个小数";
                }
            },
            isValue: function(value) {
                if(value < 1 || value > 31) {
                    return "请输入(1-31)的值";
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
        /**失去焦点验证**/
        $(function () {
            $("input[name=inTheEndTime]").on("blur", function () {
                if ($(this).val() < 1 || $(this).val() > 31) {
                    layer.msg('请输入(1-31)的值.', {icon: 2, anim: 6});
                    $(this).focus();
                }
            });
            $("input[name=remindTime]").on("blur", function () {
                if ($(this).val() < 1 || $(this).val() > 31) {
                    layer.msg('请输入(1-31)的值.', {icon: 2, anim: 6});
                    $(this).focus();
                }
            });
            $("input[name=organizationName]").bind('input propertychange',function(){
                $("#cityName").html(sessionStorage.getItem("mergerName") + "--" + $("input[name=organizationName]").val());
            });
        })

        //监听操作方式
        form.on('select(operationType)', function(data) {
            $("#operationTypeText").html(data.elem[data.elem.selectedIndex].text);
            form.render();
        });

        //监听计算规则
        form.on('select(computationRule)', function(data) {
            if (data.value == 1) {
                $("select[name=computationalAccuracy] option").each(function () {
                    if ($(this).val() == 0) {
                        $(this).prop("selected", true);
                        form.render();
                    }
                });
                $("select[name=computationalAccuracy]").attr("disabled", true);
                form.render();
            }
            else {
                $("select[name=computationalAccuracy]").removeAttr("disabled");
                form.render();
            }
        });

        //监听计算规则
        form.on('select(precision)', function(data) {
            if (data.value == 3) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|three");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|three");
            }
            else if (data.value == 2) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|two");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|two");
            }
            else if (data.value == 1) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|one");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|one");
            }
            else if (data.value == 0) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|isNumber");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|isNumber");
            }
            else if (data.value == -1) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|isNumber");
                $("input[name=minCardinalNumber]").attr("step", 10);
                $("input[name=minCardinalNumber]").val("");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|isNumber");
                $("input[name=maxCardinalNumber]").attr("step", 10);
                $("input[name=maxCardinalNumber]").val("");
            }
            else if (data.value == -2) {
                $("input[name=minCardinalNumber]").attr("lay-verify", "required|isNumber");
                $("input[name=minCardinalNumber]").attr("step", 100);
                $("input[name=minCardinalNumber]").val("");
                $("input[name=maxCardinalNumber]").attr("lay-verify", "required|isNumber");
                $("input[name=maxCardinalNumber]").attr("step", 100);
                $("input[name=maxCardinalNumber]").val("");
            }
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            if (Number(data.field.maxCardinalNumber) < Number(data.field.minCardinalNumber)) {
                layer.msg("基数上限不能小于下限");
                $("input[name=minCardinalNumber]").focus();
                return false;
            }
            data.field.payPlaceId = AM.getUrlParam("payPlaceId");
            data.field.remindContent = $("#remindContent").html();
            data.field.type = 0;
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/organization/addOrganization", data.field  , function(result) {
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index);
                window.parent.closeNodeIframe();
            });
            return false;
        });
    });

    function onRemindTime (obj) {
        $("#day").html(Number($(obj).val()));
        $("#dot").html(24);
    }

    function checkNumber (obj) {
        var accuracy = $("select[name=precision]").val();
        calculate(obj, accuracy);
    }
    $(function () {
        $("input[name=minCardinalNumber]").on("blur", function () {
            var precision = $("select[name=precision]").val();
            calculate($(this), precision);
            var value = $(this).val();
            if (value != "" && precision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && precision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }

            if ($("input[name=maxCardinalNumber]").val() != "" && value != "" && Number($(this).val()) > Number($("input[name=maxCardinalNumber]").val())) {
                layer.msg("基数上限不能小于下限");
                $(this).focus();
            }
        });
        $("input[name=maxCardinalNumber]").on("blur", function () {
            var precision = $("select[name=precision]").val();
            calculate($(this), precision);
            var value = $(this).val();
            if (value != "" && precision == -1) {
                var str = value.substring(value.length - 1, value.length);
                if (str != 0) {
                    var val = value.substring(0, value.length - 1);
                    $(this).val(val + "0");
                }
            }
            if (value != "" && precision == -2){
                var str = value.substring(value.length - 2, value.length);
                if (str == "00") {
                    var val = value.substring(0, value.length - 2);
                    $(this).val(val + "00");
                }
            }
            if ($("input[name=minCardinalNumber]").val() != "" && value != "" && Number($(this).val()) < Number($("input[name=minCardinalNumber]").val())) {
                layer.msg("基数上限不能小于下限");
                $(this).focus();
            }
        });
    })

</script>
</body>
</html>
