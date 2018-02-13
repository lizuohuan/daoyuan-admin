<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加知识库</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加知识库</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">标题<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="title"  lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input" maxlength="100">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">类型<span class="font-red">*</span></label>
            <div class="layui-input-inline" style="width: 240px;" id="typeHint">
                <input type="radio" name="type" value="0" title="HT" id="HT" checked>
                <input type="radio" name="type" value="1" title="TS" id="TS">
                <input type="radio" name="type" value="2" title="SOP" id="SOP">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">关键词<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="antistop" lay-verify="required" placeholder="请输入关键词" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">有效期限</label>
            <div class="layui-input-inline">
                <input class="layui-input" name="startValidity" placeholder="开始日" id="start" readonly>
            </div>
            <div class="layui-input-inline">
                <input class="layui-input" name="endValidity" placeholder="截止日" id="end" readonly>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">可查看角色<span class="font-red">*</span></label>
            <div class="layui-input-block" id="roleIds">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">内部信息<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <script id="interiorInfoEditor" style="height:500px" name="interiorInfo" type="text/plain"></script>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">外部信息<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <script id="externalInfoEditor" style="height:500px" name="externalInfo" type="text/plain"></script>
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
<script src="<%=request.getContextPath()%>/ue/ueditor.config.js"></script>
<script src="<%=request.getContextPath()%>/ue/ueditor.all.js"></script>
<script src="<%=request.getContextPath()%>/ue/lang/zh-cn/zh-cn.js"></script>
<script>

    var externalInfoEditor = UE.getEditor('externalInfoEditor');
    var interiorInfoEditor = UE.getEditor('interiorInfoEditor');

    function getRoleListHtml () {
        var html = "";
        AM.ajaxRequestData("get", false, AM.ip + "/role/list", {} , function(result){
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == AM.getUserInfo().roleId) {
                    html += '<input checked type="checkbox" name="roleIds" title="'+ result.data[i].roleName +'" value=' + result.data[i].id + '>';
                }
                else {
                    html += '<input type="checkbox" name="roleIds" title="'+ result.data[i].roleName +'" value=' + result.data[i].id + '>';
                }
            }
        });
        return html;
    }

    layui.use(['form', 'layedit'], function() {
        var form = layui.form()
                ,laydate = layui.laydate
                ,layedit = layui.layedit;
        $("#roleIds").html(getRoleListHtml());
        var start = {
            min: laydate.now()
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            min: laydate.now()
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('start').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        document.getElementById('end').onclick = function(){
            end.elem = this
            laydate(end);
        }

        $(function () {
            $("#HT").next().on("mouseover", function (){
                layer.tips('How To（操作方式），即正常业务如何办理，例如：如何增员，含条件、所需文档资料等', '#typeHint',{
                    tips: [2, '#78BA32'],time:3000
                });
            });
            $("#TS").next().on("mouseover", function (){
                layer.tips('Trouble Shouting（故障排查），即当发生某种意外应如何处理，类似Q&A，例如：增员失败该如何处理，含失败原因及对应的处理方案', '#typeHint',{
                    tips: [2, '#78BA32'],time:3000
                });
            });
            $("#SOP").next().on("mouseover", function (){
                layer.tips('Standard Operating Procedure（标准操作程序），即标准流程，通常为内部流程，例如：缴费服务流程，含步骤及说明', '#typeHint',{
                    tips: [2, '#78BA32'],time:3000
                });
            });
        })

        form.render();
        form.verify({
            isDouble: function(value) {
                if(value.length > 0 && !AM.isDouble.test(value)) {
                    return "请输入一个小数";
                }
            },
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            if (data.field.startValidity != "" && data.field.endValidity != "") {
                data.field.startValidity = new Date(data.field.startValidity);
                data.field.endValidity = new Date(data.field.endValidity);
            }
            if (data.field.startValidity == "") {
                delete data.field.startValidity;
            }
            if (data.field.endValidity == "") {
                delete data.field.endValidity;
            }
            data.field.externalInfo = externalInfoEditor.getContent();
            data.field.interiorInfo = interiorInfoEditor.getContent();
            if (data.field.interiorInfo == "") {
                layer.msg("内部信息不能为空");
                return false;
            }
            if (data.field.externalInfo == "") {
                layer.msg("外部信息不能为空");
                return false;
            }
            var roleIds = [];
            $("#roleIds").find("input[type=checkbox]").each(function () {
                if ($(this).is(":checked")) {
                    roleIds.push($(this).val());
                }
            });
            if (roleIds.length == 0) {
                layer.msg("请选择可查看角色");
                return false;
            }
            data.field.roleIds = roleIds.toString();
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/repository/add", data.field, function(result) {
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
