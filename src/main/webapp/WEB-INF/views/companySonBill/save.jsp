<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加子账单</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{height: 250px;width: 400px;margin-right: 10px;margin-bottom: 10px;float: left;text-align: center}
        .preview img{width: 100%;height:210px;border: 1px solid #eee;}

    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加子账单</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">选择公司<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select id="companyId" name="companyId" lay-filter="companyId" lay-search>
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">子账单名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="sonBillName" id="sonBillName" lay-verify="required" placeholder="请输入子账单名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>


        <div class="layui-form-item hide">
            <label class="layui-form-label">票据<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select  id="companyBillInfoId" lay-verify="required"  name="companyBillInfoId" >
                    <option value="">选择票据</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label">账单接收人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select  id="contactsId" lay-verify="required" name="contactsId" >
                    <option value="">选择账单接收人</option>
                </select>
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
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
<script>
    //上传的类型 0：头像 1：营业执照/介绍信
    var type = 0;
    layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
        var form = layui.form(),
                layer = layui.layer;
        var companyId = null;
        if (AM.getUrlParam("companyId") != "" && AM.getUrlParam("companyId") != undefined && AM.getUrlParam("companyId") != null) {
            companyId = AM.getUrlParam("companyId");
            $("#companyId").attr("disabled",true);
        }

        queryAllCompany(companyId, "companyId", null, 0);

        if (companyId != null) { //监听公司

            $("#companyId option").each(function(){
                if($(this).val() == companyId){
                    $(this).prop("checked",true);
                }
            })

            queryContactsByIsReceiver(0,"contactsId","post",1,companyId,1); // 账单接受人列表
            queryBillInfoByCompany(0,"companyBillInfoId","post",1,companyId); // 账单接受人列表
        }

        form.render();

        //监听公司
        form.on('select(companyId)', function (data) {
            queryContactsByIsReceiver(0,"contactsId","post",1,data.value,1); // 账单接受人列表
            queryBillInfoByCompany(0,"companyBillInfoId","post",1,data.value); // 账单接受人列表
            form.render();
        });


        //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.companyId = $("#companyId").val();
            AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/save", data.field  , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                } else {
                    layer.msg(result.msg, {icon: 2,anim: 6});
                    return false;
                }
            });
            return false;
        });
    });



</script>
</body>
</html>
