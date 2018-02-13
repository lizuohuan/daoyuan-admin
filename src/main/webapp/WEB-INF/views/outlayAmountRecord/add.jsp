<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>申请出款</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>申请出款</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="radio" name="type" value="0" title="供应商" checked lay-filter="type">
                <input type="radio" name="type" value="1" title="非供应商" lay-filter="type">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择供应商<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="supplierId" lay-verify="required" lay-filter="supplierId">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">选择收款信息<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="supplierAccountToBeCreditedId" lay-filter="supplierAccountToBeCreditedId" lay-verify="required">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">账户名<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="accountName"  lay-verify="required" placeholder="请输入账户名" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">开户行<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="bankName"  lay-verify="required" placeholder="请输入开户行" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">银行账号<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="bankAccount" lay-verify="required" placeholder="请输入银行账号" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">金额<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="number" name="amount" lay-verify="required|isDouble" placeholder="请输入金额" autocomplete="off" class="layui-input" maxlength="10">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">是否加急<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="radio" name="isUrgent" value="0" title="否" checked>
                <input type="radio" name="isUrgent" value="1" title="是">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="remark" placeholder="请输入备注"></textarea>
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

    //获取供应商
    function getSupplier (selectId) {
        AM.ajaxRequestData("get", false, AM.ip + "/supplier/getAllList", {} , function(result){
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

    //根据供应商获取收款信息
    function getBySupplierId (selectId, supplierId) {
        AM.ajaxRequestData("get", false, AM.ip + "/supplierAccountToBeCredited/getBySupplierId", {
            supplierId : supplierId
        } , function(result){
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" info="+JSON.stringify(result.data[i])+" value=\"" + result.data[i].id + "\">" + result.data[i].accountName + "</option>";
                }
                else {
                    html += "<option info="+JSON.stringify(result.data[i])+" value=\"" + result.data[i].id + "\">" + result.data[i].accountName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='supplierAccountToBeCreditedId']").html(html);
        });
    }

    layui.use(['form', 'layedit'], function() {
        var form = layui.form();
        getSupplier(0);
        form.render();
        form.verify({
            isDouble: function(value) {
                if(value.length > 0 && !AM.isDouble.test(value)) {
                    return "请输入一个小数";
                }
            },
        });

        form.on('radio(type)', function(data) {
            if (data.value == 0) {
                $("select[name=supplierId]").attr("lay-verify", "required");
                $("select[name=supplierId]").parent().parent().show();
                $("select[name=supplierAccountToBeCreditedId]").attr("lay-verify", "required");
                $("select[name=supplierAccountToBeCreditedId]").parent().parent().show();
            }
            else {
                $("select[name=supplierId]").removeAttr("lay-verify");
                $("select[name=supplierId]").parent().parent().hide();
                $("select[name=supplierAccountToBeCreditedId]").removeAttr("lay-verify");
                $("select[name=supplierAccountToBeCreditedId]").parent().parent().hide();
            }
        });

        form.on('select(supplierId)', function(data) {
            getBySupplierId (0, data.value);
            $("input[name='accountName']").val("");
            $("input[name='bankName']").val("");
            $("input[name='bankAccount']").val("");
            form.render();
        });


        form.on('select(supplierAccountToBeCreditedId)', function(data) {
            var info = $(data.elem).find("option:selected").attr("info");
            info = JSON.parse(info);
            $("input[name='accountName']").val(info.accountName);
            $("input[name='bankName']").val(info.bankName);
            $("input[name='bankAccount']").val(info.account);
            form.render();
        });

            //监听提交
        form.on('submit(demo1)', function(data) {
            data.field.status = 2001;
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/outlayAmountRecord/add", data.field, function(result) {
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
