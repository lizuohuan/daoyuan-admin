<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>修改合同</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{height: 250px;width: 400px;margin-right: 10px;margin-bottom: 10px;float: left;text-align: center}
        .preview img{width: 100%;height:210px;border: 1px solid #eee;}
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>修改合同</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editUserCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">合同起始日期<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" id="startTime" placeholder="合同起始日期">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">合同截止日期<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" class="layui-input" id="endTime" placeholder="合同截止日期">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label"><span>备注</span></label>
            <div class="layui-input-inline">
                <input type="text" name="remarks" value="{{contract.remarks}}" id="remarks" placeholder="请输入备注" autocomplete="off"
                       class="layui-input" maxlength="100">
            </div>
        </div>

        <div class="layui-form-item" id="otherAttachmentDiv">
            <label class="layui-form-label">合同附件<span class="font-red"></span></label>
            <div class="layui-input-inline">
                <div>
                    <button type="button" onclick="uploadAttachment()" class="layui-btn layui-btn-normal"
                            id="otherAttachment">
                        <i class="layui-icon">&#xe67c;</i>上传合同附件
                    </button>
                </div>
            </div>
        </div>

        <input type="hidden" value="${id}" id="id">

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
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("editUserCtr", function($scope,$http,$timeout){

        $scope.contract = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/contract/queryContractById", {contractId : $scope.id} , function(result) {
            $scope.contract = result.data;
            console.log(result.data)
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;
            var start = {
                min: '2010-01-01 00:00:00'
                , max: '2099-06-16 23:59:59'
                , istoday: false
                , choose: function (datas) {
                    end.min = datas; //开始日选好后，重置结束日的最小日期
                    end.start = datas //将结束日的初始值设定为开始日
                }
            };
            var end = {
                min: laydate.now()
                , max: '2099-06-16 23:59:59'
                , istoday: false
                , choose: function (datas) {
                    start.max = datas; //结束日选好后，重置开始日的最大日期
                }
            };
            document.getElementById('startTime').onclick = function () {
                start.elem = this;
                laydate(start);
            }
            document.getElementById('endTime').onclick = function () {
                end.elem = this;
                laydate(end);
            }

            // 设置时间
            $("#startTime").val(new Date($scope.contract.startTime).format("yyyy-MM-dd"));
            $("#endTime").val(new Date($scope.contract.endTime).format("yyyy-MM-dd"));

            var html = "";
            for (var i = 0; i < $scope.contract.attachments.length; i++){
                 html += '<div class="layui-form-item">' +
                        '   <label class="layui-form-label"></label>' +
                        '<div class="layui-input-inline">' +
                        '<div>' +
                        '<input type="text" placeholder="请输入附件备注" value="'+$scope.contract.attachments[i].attachmentName+'" dataurl="'+$scope.contract.attachments[i].url+'" autocomplete="off" class="layui-input attachment" maxlength="100">' +
                        '</div>' +
                        '</div>' +
                         '<button type="button" onclick="checkAttachment(\''+$scope.contract.attachments[i].url+'\')" class="layui-btn layui-btn-danger">查看</button>' +
                         '<button type="button" onclick="delAttachment(this)" class="layui-btn layui-btn-danger">删除</button>' +
                        '</div>';
            }
            $("#otherAttachmentDiv").append(html);



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




            //监听提交
            form.on('submit(demo1)', function(data) {

                if($("#startTime").val() == ''){
                    layer.msg("没有选择开始日期");
                    return false;
                }
                if($("#endTime").val() == ''){
                    layer.msg("没有选择截至日期");
                    return false;
                }

                var attachmentArr = new Array();
                // 获取合同 附件集合
                $(".attachment").each(function () {
                    var obj = {
                        attachmentName : $(this).val(),
                        url : $(this).attr("dataurl")
                    };
                    attachmentArr.push(JSON.stringify(obj));
                });
                data.field.attachmentArr = attachmentArr.toString();
                data.field.startTime = new Date($("#startTime").val());
                data.field.endTime = new Date($("#endTime").val());
                data.field.id = $("#id").val();
                AM.ajaxRequestData("post", false, AM.ip + "/contract/updateContract", data.field , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
                return false;
            });
        });
    });

    function checkAttachment(url){
        window.open(AM.ip + "/" + url,"_blank");
    }
    function delAttachment(obj){
        $(obj).parent().hide("slow");
        $(obj).parent().remove();
    }



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
//                            attachments.push(result.data.url);

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





</script>
</body>
</html>
