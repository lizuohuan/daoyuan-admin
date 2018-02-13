<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加银行信息</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加银行信息</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">账户类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="radio" name="type" value="0" title="银行卡" checked lay-filter="type">
                <input type="radio" name="type" value="1" title="支付宝" lay-filter="type">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span id="accountNameHint">银行账户</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="accountName" lay-verify="required" placeholder="请输入银行账户" autocomplete="off" class="layui-input" maxlength="200">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span id="accountHint">银行账号</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="bankAccount" lay-verify="required" placeholder="请输入银行账号" autocomplete="off" class="layui-input" maxlength="200">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">开户行</label>
            <div class="layui-input-inline">
                <input type="text" name="bankName" placeholder="请输入开户行" autocomplete="off" class="layui-input" maxlength="200">
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
<%@include file="../common/public-js.jsp" %>
<script>
    layui.use(['form', 'layedit'], function() {
        var form = layui.form();
        var companyId = AM.getUrlParam("companyId");
        form.verify({
            isEmailOrIsMobile: function (value) {
                if (value.length > 0) {
                    if (!AM.isEmail.test(value) && !AM.isMobile.test(value)) {
                        return "请输入邮箱或者手机号";
                    }
                }
            },
            isNumber: function (value) {
                if (value.length > 0 && !AM.isNumber.test(value)) {
                    return "请输入正确的银行账号";
                }
            },
        });
        form.on('radio(type)', function(data){
            if (data.value == 0) {
                $("input[name='bankName']").parent().parent().show();
                $("input[name='accountName']").attr("placeholder", "请输入银行账户");
                $("input[name='bankAccount']").attr("placeholder", "请输入银行账号");
                $("input[name='bankAccount']").attr("lay-verify", "required");
                $("#accountNameHint").html("银行账户");
                $("#accountHint").html("银行账号");
            }
            else {
                $("input[name='bankName']").parent().parent().hide();
                $("input[name='accountName']").attr("placeholder", "请输入支付宝账户");
                $("input[name='bankAccount']").attr("placeholder", "请输入支付宝账号");
                $("input[name='bankAccount']").attr("lay-verify", "required|isEmailOrIsMobile");
                $("#accountNameHint").html("支付宝账户");
                $("#accountHint").html("支付宝账号");
            }
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.companyId = companyId;
            AM.ajaxRequestData("post", false, AM.ip + "/bankInfo/addBankInfo", data.field  , function(result) {
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index);
                window.parent.closeNodeIframe();
            });
            return false;
        });
    });
</script>
</body>
</html>
