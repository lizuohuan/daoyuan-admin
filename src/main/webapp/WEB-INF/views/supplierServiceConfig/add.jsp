<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加缴金地</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加缴金地</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required" lay-filter="type">
                    <option value="">请选择</option>
                    <option value="0">社保</option>
                    <option value="1">公积金</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item" id="cityDiv">
            <label class="layui-form-label">选择地区<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select id="provinceId" name="province" lay-verify="required" lay-search lay-filter="province">
                    <option value="">请选择或搜索省</option>
                </select>
            </div>
            <div class="layui-input-inline">
                <select id="cityId" name="city" lay-verify="required" lay-search lay-filter="city">
                    <option value="">请选择或搜索市</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">年度调基月份</label>
            <div class="layui-input-inline">
                <input type="text" name="yearAlterMonth" lay-verify="isValue2" class="layui-input" placeholder="请输入年度调基月份">
            </div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label">实做影响</label>
            <div class="layui-input-inline">
                <select name="operationType" lay-filter="operationType">
                    <option value="">请选择</option>
                    <option value="0">本月</option>
                    <option value="1">次月</option>
                    <option value="2">上月</option>
                </select>
            </div>
            <div class="layui-form-mid layui-word-aux">账单</div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label"><span>最晚实做日期</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="inTheEndTime" lay-verify="required|isValue" placeholder="请输入最晚实做日期" autocomplete="off" class="layui-input" maxlength="2">
            </div>
            <div class="layui-form-mid layui-word-aux">填写1-31日</div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label"><span>提醒日期</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="remindTime" lay-verify="required|isValue" onkeyup="onRemindTime(this)" placeholder="请输入提醒日期" autocomplete="off" class="layui-input" maxlength="2">
            </div>
            <div class="layui-form-mid layui-word-aux">填写1-31日，时间默认是最后一天的24点</div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label"><span>提醒内容</span><span class="font-red">*</span></label>
            <div class="layui-input-block">
                <div style="width: 400px;cursor: not-allowed;background: #EEEEEE" id="remindContent" class="layui-textarea">
                    <span id="cityName">XX</span>本月社保变动将于<span id="day">XX</span>号<span id="dot">XX</span>点截止，请及时提交变动，避免影响<span id="operationTypeText">XX</span>账单，谢谢。
                </div>
            </div>
        </div>

        <input type="hidden" name="cityId">

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

        selectProvince(0); //默认调用省
        form.render();

        form.verify({
            isValue: function(value) {
                if(value < 1 || value > 31) {
                    return "请输入(1-31)的值";
                }
                else if (value != "" && !AM.isNumber.test(value)) {
                    return "请输入正整数";
                }
            },
            isValue2: function(value) {
                if(value != "" && (value < 1 || value > 12)) {
                    return "请输入(1-12)的值";
                }
                else if (value != "" && !AM.isNumber.test(value)) {
                    return "请输入正整数";
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
        })

        //监听省
        form.on('select(province)', function(data) {
            $("select[name='district']").html("<option value=\"\">请选择或搜索县/区</option>");
            $("input[name='cityId']").val("");
            selectCity(data.value);
            form.render();
        });

        //监听市
        form.on('select(city)', function(data) {
            $("input[name='cityId']").val(data.value);
            $("#cityName").html(data.elem.options[data.elem.options.selectedIndex].text);
            form.render();
        });

        //监听类型
        form.on('select(type)', function(data) {
            if (data.value == 0) {
                $("input[name='cityId']").val($("#cityId").val());
                $("select[name='operationType']").parent().parent().show();
                $("input[name='operationType']").attr("lay-verify", "required");
                $("input[name='inTheEndTime']").parent().parent().show();
                $("input[name='inTheEndTime']").attr("lay-verify", "required|isValue");
                $("input[name='remindTime']").parent().parent().show();
                $("input[name='remindTime']").attr("lay-verify", "required|isValue");
                $("#remindContent").parent().parent().show();
            }
            else {
                $("select[name='operationType']").parent().parent().hide();
                $("input[name='operationType']").removeAttr("lay-verify");
                $("input[name='inTheEndTime']").parent().parent().hide();
                $("input[name='inTheEndTime']").removeAttr("lay-verify");
                $("input[name='remindTime']").parent().parent().hide();
                $("input[name='remindTime']").removeAttr("lay-verify");
                $("#remindContent").parent().parent().hide();
            }
            form.render();
        });

        //监听操作方式
        form.on('select(operationType)', function(data) {
            $("#operationTypeText").html(data.elem[data.elem.selectedIndex].text);
            form.render();
        });

        //监听提交
        form.on('submit(demo1)', function(data) {

            if (Number(data.field.remindTime) > Number(data.field.inTheEndTime)) {
                layer.msg("提醒日期必须小于最晚实做日期");
                return false;
            }

            delete data.field.city;
            if (data.field.type == 0) {
                data.field.remindContent = $("#remindContent").html();
            }
            else {
                delete data.field.inTheEndTime;
                delete data.field.remindTime;
            }
            AM.log(data.field);

            AM.ajaxRequestData("post", false, AM.ip + "/payPlace/add", data.field  , function(result) {
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

    $(function () {
        document.onkeydown = function(event) {
            if (event.keyCode == 13) {
                var placeholder = $(event.target).attr("placeholder");
                if (placeholder == "请选择或搜索省") {
                    var cityName = $("#provinceId").next().find(".layui-select-title").find(".layui-unselect").val();
                    $("#provinceId").next().find(".layui-anim-upbit").find("dd").each(function () {
                        if ($(this).html().indexOf(cityName) != -1) {
                            $(this).click();
                        }
                    });
                }
                if (placeholder == "请选择或搜索市") {
                    var townName = $("#cityId").next().find(".layui-select-title").find(".layui-unselect").val();
                    $("#cityId").next().find(".layui-anim-upbit").find("dd").each(function () {
                        if ($(this).html().indexOf(townName) != -1) {
                            $(this).click();
                        }
                    });
                }
            }
        };
    });



</script>
</body>
</html>
