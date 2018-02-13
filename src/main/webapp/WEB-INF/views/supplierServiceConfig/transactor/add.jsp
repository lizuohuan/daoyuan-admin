<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加办理方</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend><span id="organizationName"></span>添加办理方</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">选择供应商<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="supplierId" lay-verify="required" lay-filter="supplierId">
                    <option value="">请选择</option>
                </select>
            </div>
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
                    <span id="cityName">XX</span>本月社保变动将于<span id="day">XX</span>号<span id="dot">XX</span>点截止，请及时提交变动，避免影响<span id="operationTypeText">XX</span>账单，谢谢。
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"><span>账单类型</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="checkbox" name="isReceive" value="1" title="预收">
                <input type="checkbox" name="isImplements" value="1" title="实做">
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
    $("#organizationName").html(sessionStorage.getItem("organizationName") + "-");
    function getSupplier (organizationId, selectId) {
        AM.ajaxRequestData("get", false, AM.ip + "/supplier/getNOBindToSelect", {organizationId : organizationId, supplierId : selectId} , function(result){
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].supplierName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].supplierName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='supplierId']").html(html);
        });
    }

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
                if (value != "") {
                    if(value < 1 || value > 31) {
                        return "请输入(1-31)的值";
                    }
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
        getSupplier(AM.getUrlParam("organizationId"), 0);
        form.render();
        //监听供应商
        form.on('select(supplierId)', function(data) {
            $("#cityName").html(sessionStorage.getItem("mergerName") + "--" + data.elem[data.elem.selectedIndex].text);
            form.render();
        });

        //监听操作方式
        form.on('select(operationType)', function(data) {
            $("#operationTypeText").html(data.elem[data.elem.selectedIndex].text);
            form.render();
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            if (data.field.isReceive == undefined && data.field.isImplements == undefined) {
                layer.msg('至少选择一个账单类型', {icon: 2, anim: 6});
                return false;
            }
            if (data.field.isReceive == undefined) {
                data.field.isReceive = 0;
            }
            if (data.field.isImplements == undefined) {
                data.field.isImplements = 0;
            }
            data.field.organizationId = AM.getUrlParam("organizationId");
            if (data.field.remindTime != "" && $("select[name=operationType]").val() != "") {
                data.field.remindContent = $("#remindContent").html();
            }
            data.field.type = 0;
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/transactor/save", data.field  , function(result) {
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

</script>
</body>
</html>
