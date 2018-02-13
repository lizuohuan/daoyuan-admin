<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加票据信息</title>
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
        <legend>添加票据信息</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">票据名称<span class="font-red" id="titleIcon"></span></label>
            <div class="layui-input-inline">
                <input type="text" name="name" placeholder="请输入票据名称" autocomplete="off" class="layui-input" maxlength="255">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">票据类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="billType" id="billType" lay-verify="required" lay-filter="changeBillType" lay-search>
                    <option value="">请选择票据类型</option>
                    <option value="0">专票</option>
                    <option value="1">普票</option>
                    <option value="2">收据</option>
                </select>
            </div>
        </div>
        <div id="billTypeDiv">
            <div class="layui-form-item">
                <label class="layui-form-label">发票抬头<span class="font-red" id="titleIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="title" name="title" placeholder="请输入发票抬头" autocomplete="off" class="layui-input"
                           maxlength="255">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">税号<span class="font-red" id="taxNumberIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="taxNumber" name="taxNumber" placeholder="请输入税号" autocomplete="off" class="layui-input"
                           maxlength="255">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">地址<span class="font-red" id="addressIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="address" name="address" placeholder="请输入地址" autocomplete="off" class="layui-input"
                           maxlength="255">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电话<span class="font-red" id="phoneIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="phone" name="phone" placeholder="请输入电话" autocomplete="off" class="layui-input"
                           maxlength="20">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">开户行<span class="font-red" id="accountNameIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="accountName" name="accountName" placeholder="请输入开户行" autocomplete="off" class="layui-input"
                           maxlength="255">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">银行账号<span class="font-red" id="bankAccountIcon"></span></label>
                <div class="layui-input-inline">
                    <input type="text" id="bankAccount" name="bankAccount" placeholder="请输入银行帐号" autocomplete="off" class="layui-input"
                           maxlength="255">
                </div>
            </div>

            <div class="layui-form-item layui-hide" id="isPartBillDiv">
                <label class="layui-form-label">服务费与业务费分别开票<span class="font-red">*</span></label>
                <div class="layui-input-block">
                    <input type="radio" name="isPartBill" value="0" title="否" checked>
                    <input type="radio" name="isPartBill" value="1" title="是" >
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">是否启用<span class="font-red">*</span></label>
                <div class="layui-input-block">
                    <input type="radio" name="isEnabled" value="0" title="否">
                    <input type="radio" name="isEnabled" value="1" title="是" checked>
                </div>
            </div>

            <%--<div class="layui-form-item">--%>
                <%--<label class="layui-form-label">先票后款<span class="font-red">*</span></label>--%>
                <%--<div class="layui-input-block">--%>
                    <%--<input type="radio" name="isFirstBill" value="0" title="否" checked>--%>
                    <%--<input type="radio" name="isFirstBill" value="1" title="是">--%>
                <%--</div>--%>
            <%--</div>--%>
        </div>

        <input type="hidden" value="${companyId}" id="companyId">
        <input type="hidden" value="${companyName}" id="companyName">


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

        $("#title").val($("#companyName").val());

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

        form.on('select(changeBillType)', function (data) {
            if (data.value == 0) {
                $("#title").attr("lay-verify", "required");
                $("#taxNumber").attr("lay-verify", "required");
                $("#address").attr("lay-verify", "required");
                $("#phone").attr("lay-verify", "required");
                $("#accountName").attr("lay-verify", "required");
                $("#bankAccount").attr("lay-verify", "required");
                // 添加 * 号
                $("#titleIcon").html("*")
                $("#taxNumberIcon").html("*")
                $("#addressIcon").html("*")
                $("#phoneIcon").html("*")
                $("#accountNameIcon").html("*")
                $("#bankAccountIcon").html("*")
                $("#isPartBillDiv").show("fast")

            } else if (data.value == 1) {
                $("#title").attr("lay-verify", "required");
                $("#taxNumber").attr("lay-verify", "required");

                $("#address").removeAttr("lay-verify");
                $("#phone").removeAttr("lay-verify");
                $("#accountName").removeAttr("lay-verify");
                $("#bankAccount").removeAttr("lay-verify");
                // 添加 * 号
                $("#titleIcon").html("*")
                $("#taxNumberIcon").html("*")

                $("#addressIcon").html("")
                $("#phoneIcon").html("")
                $("#accountNameIcon").html("")
                $("#bankAccountIcon").html("")
                $("#isPartBillDiv").hide("fast")
            }
            else if (data.value == 2) {
                $("#title").attr("lay-verify", "required");
                $("#taxNumber").removeAttr("lay-verify");

                $("#address").removeAttr("lay-verify");
                $("#phone").removeAttr("lay-verify");
                $("#accountName").removeAttr("lay-verify");
                $("#bankAccount").removeAttr("lay-verify");
                // 添加 * 号
                $("#titleIcon").html("*")
                $("#taxNumberIcon").html("")

                $("#addressIcon").html("")
                $("#phoneIcon").html("")
                $("#accountNameIcon").html("")
                $("#bankAccountIcon").html("")
                $("#isPartBillDiv").hide("fast")
            }
//            else{}
            form.render();
        });


        //监听提交
        form.on('submit(demo1)', function(data) {

            data.field.companyId = $("#companyId").val();

            AM.ajaxRequestData("post", false, AM.ip + "/billInfo/addBillInfo", data.field  , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    layer.alert('添加成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    });
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
