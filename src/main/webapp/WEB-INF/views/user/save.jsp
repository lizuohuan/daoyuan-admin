<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加用户</title>
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
        <legend>添加用户</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">用户角色<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="roleId" id="roleId" lay-filter="roleId" lay-verify="required" lay-search>
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>姓名</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="userName" id="userName" lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>账号</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="account" id="account" lay-verify="required|isAccount" placeholder="请输入账号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>email</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="email" id="email" lay-verify="required|isEmail" placeholder="请输入邮箱" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>工作手机号</span><span class="font-red"></span></label>
            <div class="layui-input-inline">
                <input type="text" name="workPhone" id="workPhone"
                       onkeydown=if(event.keyCode==13)event.keyCode=9 onkeyup="value=value.replace(/[^0-9- ]/g,'');"
                       lay-verify="isPhone" placeholder="请输入工作手机号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>


        <div class="layui-form-item ">
            <label class="layui-form-label"><span>私人手机号</span><span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="homePhone" id="homePhone" lay-verify="required|isPhone" placeholder="请输入工作手机号" autocomplete="off" class="layui-input" maxlength="50">
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
                layer = layui.layer,
                layedit = layui.layedit
                ,$ = layui.jquery,
                laydate = layui.laydate;

        getRoleList(0); //角色列表


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
            },
            isAccount: function(value) {
                if(value.length < 3 || value.length > 16) {
                    return "请输入（3-16）位";
                }
            }

        });
        form.render();


        //监听提交
        form.on('submit(demo1)', function(data) {


            data.field.pwd = $.md5("111111");
            data.field.loginUrl = AM.ip + "/page/login";

            AM.ajaxRequestData("post", false, AM.ip + "/user/add", data.field  , function(result) {
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

    $("#homePhone").keyup(function(){
        if($("#homePhone").val().length > 11){
            $("#homePhone").val($("#homePhone").val().substring(0,$("#homePhone").val().length-1))
        }
    });
    $("#workPhone").keyup(function(){
        if($("#workPhone").val().length > 11){
            $("#workPhone").val($("#workPhone").val().substring(0,$("#workPhone").val().length-1))
        }
        $("#homePhone").val($("#workPhone").val());
    });

</script>
</body>
</html>
