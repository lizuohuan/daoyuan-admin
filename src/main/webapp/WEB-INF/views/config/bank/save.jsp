<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加银行</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .preview {
            height: 250px;
            width: 400px;
            margin-right: 10px;
            margin-bottom: 10px;
            float: left;
            text-align: center
        }

        .preview img {
            width: 100%;
            height: 210px;
            border: 1px solid #eee;
        }

    </style>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span
            class="font-red">“*”</span> 号的为必填项.
    </blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加银行</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">



        <div class="layui-form-item ">
            <label class="layui-form-label"><span>银行名称</span></label>
            <div class="layui-input-inline">
                <input type="text" name="bankName" id="bankName" required lay-verify="required" placeholder="请输入" autocomplete="off"
                       class="layui-input" maxlength="100">
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>

    <form id="newUpload" method="post" enctype="multipart/form-data">
        <input id="File" type="file" name="File" accept="application/file" class="hide">
        <input type="hidden" name="type" value="1">
    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>
    //上传的类型 0：头像 1：营业执照/介绍信
    var type = 0;
    var attachments = new Array();

    function uploadAttachment() {
        $('#File').click();
    }

    $('#File').change(function () {
        $("body").append(AM.showShade("正在上传,请稍等..."));
        var file = this.files[0];
        var fileName = file.name;
        var fr = new FileReader();
        if (window.FileReader) {
            fr.onloadend = function (e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: AM.ip + '/res/upload',
                    success: function (result) {
                        if (result.code == 200) {
                            $('#File').val("");
                            AM.hideShade();
                            var html = '<div class="layui-form-item">' +
                                    '   <label class="layui-form-label"></label>' +
                                        '<div class="layui-input-inline">' +
                                            '<div>' +
                                            '<input type="text" placeholder="请输入附件备注" value="'+fileName+'" dataurl="'+result.data.url+'" autocomplete="off" class="layui-input attachment" maxlength="100">' +
                                            '</div>' +
                                        '</div>' +
                                    '<button type="button" onclick="checkAttachment(\''+result.data.url+'\')" class="layui-btn layui-btn-danger">查看</button>' +
                                        '<button type="button" onclick="delAttachment(this)" class="layui-btn layui-btn-danger">删除</button>' +
                                    '</div>';
                            $("#otherAttachmentDiv").append(html);
                        } else {
                            AM.hideShade();
                            $('#File').val("");
                            layer.alert(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    });

    function checkAttachment(url){
        window.open(AM.ip + "/" + url,"_blank");
    }

    function delAttachment(obj){
        $(obj).parent().hide("slow");
        $(obj).parent().remove();
    }

    layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function () {
        var form = layui.form(),
                layer = layui.layer,
                layedit = layui.layedit
                , $ = layui.jquery,
                laydate = layui.laydate,
                upload = layui.upload;





        //自定义验证规则
        form.verify({
            isNumber: function (value) {
                if (value.length > 0 && !AM.isNumber.test(value)) {
                    return "请输入一个整数";
                }
            },
            isPhone: function (value) {
                if (value.length > 0 && !AM.isMobile.test(value)) {
                    return "请输入一个正确的手机号";
                }
            },
            isEmail: function (value) {
                if (value.length > 0 && !AM.isEmail.test(value)) {
                    return "请输入一个正确的邮箱";
                }
            },
            isNumberChar: function (value) {
                if (value.length > 0 && !AM.isNumberChar.test(value)) {
                    return "只能为数字和字母";
                }
            }

        });
        form.render();


        //监听提交
        form.on('submit(demo1)', function (data) {

            AM.ajaxRequestData("post", false, AM.ip + "/bank/add", data.field, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    //关闭iframe页面
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                } else {
                    layer.msg(result.msg, {icon: 2, anim: 6});
                    return false;
                }
            });
            return false;
        });
    });


</script>
</body>
</html>
