<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加邮寄信息</title>
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
        <legend>添加邮寄信息</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">收件人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select  id="quickPersonName"  lay-filter="quickPersonNameFilter" >
                    <option value="">快捷选择收件人</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label"><span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" name="personName" id="personName" onblur="personNameOnblur()" lay-verify="required" placeholder="请输入收件人" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>



        <div class="layui-form-item ">
            <label class="layui-form-label">电话号码<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="phone" id="phone"  lay-verify="required" placeholder="请输入电话号码" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>
        <div class="layui-form-item ">
            <label class="layui-form-label">地址<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="address" id="address" lay-verify="required"  placeholder="请输入地址" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">单位名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="unitName" value="${companyName}" id="unitName" lay-verify="required" placeholder="请输入单位名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>邮编</span></label>
            <div class="layui-input-inline">
                <input type="text" name="zipcode" id="zipcode"  placeholder="请输入邮编" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>
        <div class="layui-form-item ">
            <label class="layui-form-label">默认收件人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="radio" name="isDefault" value="1" title="是">
                <input type="radio" name="isDefault" value="0" title="否" checked>
            </div>
        </div>



        <input type="hidden" value="${companyId}" id="companyId">


        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" id="reset" class="layui-btn layui-btn-primary">重置</button>
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
                layer = layui.layer,
                layedit = layui.layedit
                ,$ = layui.jquery,
                laydate = layui.laydate;

//        getRoleList(0); //角色列表
        // 获取联系人列表
        var companyId = $("#companyId").val();
        getContactsByCompany(0,"quickPersonName","post",0,companyId);

        //自定义验证规则
        form.verify({
            isNumber: function(value) {
                if(value.length > 0 && !AM.isNumber.test(value)) {
                    return "请输入一个整数";
                }
            },
            isPhone: function(value) {
                if(value.length > 0 && !AM.isMobile.test(value)) {
                    return "请输入一个正确的手机号";
                }
            },
            isEmail: function(value) {
                if(value.length > 0 && !AM.isEmail.test(value)) {
                    return "请输入一个正确的邮箱";
                }
            },
            isNumberChar: function(value) {
                if(value.length > 0 && !AM.isNumberChar.test(value)) {
                    return "只能为数字和字母";
                }
            }

        });
        form.render();

        form.on('select(quickPersonNameFilter)', function(data){
            $("#personName").val(data.elem[data.elem.selectedIndex].text);
            $("#phone").val($(data.elem[data.elem.selectedIndex]).attr("phone"));
        });

        //监听提交
        form.on('submit(demo1)', function(data) {

            data.field.companyId = $("#companyId").val();

            AM.ajaxRequestData("post", false, AM.ip + "/expressPersonInfo/addExpressPersonInfo", data.field  , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    //关闭iframe页面
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

    function personNameOnblur(){
        $("#quickPersonName option:selected").each(function(){
            if($(this).text() != '' && $("#personName").val() != $(this).text()){
                $("#phone").val("");
            }
        })
    }


</script>
</body>
</html>
