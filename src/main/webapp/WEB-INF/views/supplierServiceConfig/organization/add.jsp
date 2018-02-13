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
        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.payPlaceId = AM.getUrlParam("payPlaceId");
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
</script>
</body>
</html>
