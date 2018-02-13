<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加工单</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
</head>
<body>
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加工单</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData">

        <div class="layui-form-item">
            <label class="layui-form-label">公司</label>
            <div class="layui-input-inline">
                <select name="companyId" id="companyId" lay-filter="companyId" lay-search>
                    <option value="">请选择或者搜索</option>
                </select>
            </div>
            <label class="layui-form-label">员工</label>
            <div class="layui-input-inline">
                <select name="memberId" id="memberId" lay-search>
                    <option value="">请选择或者搜索</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">客户编号</label>
            <div class="layui-input-inline">
                <input type="text" name="number" placeholder="客户编号" autocomplete="off" class="layui-input" maxlength="50" readonly>
            </div>

            <label class="layui-form-label">账单月</label>
            <div class="layui-input-inline">
                <select name="theBillingMonth" id="theBillingMonth">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">服务类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="serviceType" lay-verify="required" lay-filter="serviceName">
                    <option value="">请选择</option>
                    <option value="0">社保特殊补缴</option>
                    <option value="1">社保特殊减少</option>
                    <option value="2">社保紧急制卡</option>
                    <option value="3">当月参保类型修改</option>
                    <option value="4">公积金退费</option>
                    <option value="5">公积金特殊修改基数</option>
                    <option value="6">公积金个人收入证明</option>
                    <option value="7">自由流程</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item hide">
            <label class="layui-form-label">服务名称<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="text" name="serviceName" lay-verify="required" placeholder="请输入服务名称" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item hide" id="higherUp">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <div class="layui-inline layui-upload-choose"></div>
            </div>
        </div>

        <div class="layui-form-item temp hide">
            <label class="layui-form-label">经办类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="radio" name="type" value="0" title="用户" checked lay-filter="type">
                <input type="radio" name="type" value="1" title="角色" lay-filter="type">
            </div>
        </div>

        <div class="layui-form-item temp hide">
            <label class="layui-form-label">经办人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="userId" lay-verify="required">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item temp hide">
            <label class="layui-form-label">经办人<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="roleId">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">上传附件</label>
            <div class="layui-input-block">
                <button type="button" onclick="$('#File').click();" class="layui-btn layui-btn-small layui-btn-normal">选择文件</button>
                <span class="layui-inline layui-upload-choose" id="kaoPanFile"></span>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">最晚处理时间<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input class="layui-input" onclick="layui.laydate({elem: this, festival: true,min: laydate.now()})" name="latestTime" readonly placeholder="请选择最晚处理时间" lay-verify="required"/>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-block">
                <textarea name="remark" style="width: 600px;" placeholder="请输入备注"></textarea>
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

<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" class="hide" onchange="onChangeFile(this)">
    <input type="hidden" name="type" value="1">
</form>

<input type="hidden" id="fileUrl">

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>

    //获取所有的公司账单年月
    function queryAllCompanyBill (oldCompany) {
        AM.ajaxRequestData("get", false, AM.ip + "/company/getOtherCompany", {
            page : 0,
            pageSize : 99999
        } , function(result){
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < result.data.length; i++) {
                if(oldCompany == result.data[i].id){
                    continue;
                }
                var obj = result.data[i].dateList;
                html += "<option serialNumber=\"" + result.data[i].serialNumber + "\" title=" + JSON.stringify(obj) + " value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name=companyId]").html(html);
            $("select[name=companyId]").parent().parent().show();
        });
    }

    function getCompanyMember (companyId) {
        AM.ajaxRequestData("get", false, AM.ip + "/member/getCompanyMember", {
            companyId : companyId
        } , function(result){
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < result.data.length; i++) {
                html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name=memberId]").html(html);
            $("select[name=memberId]").parent().parent().show();
        });
    }

    layui.use(['form', 'layedit'], function() {
        var form = layui.form();
        queryAllCompanyBill(0);
        queryAllCompany(0, "memberId", null, 0);
        form.render();
        form.verify({
            isDouble: function(value) {
                if(value.length > 0 && !AM.isDouble.test(value)) {
                    return "请输入一个小数";
                }
            },
        });

        form.on("radio(type)", function (data) {
            if (data.value == 0) {
                $("select[name=roleId]").val("");
                $("select[name=userId]").parent().parent().show();
                $("select[name=roleId]").parent().parent().hide();
                $("select[name=userId]").attr("lay-verify", "required");
                $("select[name=roleId]").removeAttr("lay-verify");
            }
            else {
                $("select[name=userId]").val("");
                $("select[name=userId]").parent().parent().hide();
                $("select[name=roleId]").attr("lay-verify", "required");
                $("select[name=userId]").removeAttr("lay-verify");
                getRoleList(0);
                form.render();
            }
        });

        form.on("select(serviceName)", function (data) {
            if (data.value == 7) {
                getUserList(0);
                $(".temp").show();
                $("input[name=serviceName]").attr("lay-verify", "required");
                $("input[name=serviceName]").parent().parent().show();
                $("select[name=userId]").attr("lay-verify", "required");
                $("select[name=roleId]").parent().parent().hide();
                $("input[name=type]").eq(0).prop("checked", true);
                $("#higherUp").hide();
            }
            else {
                $(".temp").hide();
                $("select[name=userId]").removeAttr("lay-verify");
                $("select[name=roleId]").removeAttr("lay-verify");
                $("input[name=serviceName]").parent().parent().hide();
                $("input[name=serviceName]").removeAttr("lay-verify");
            }

            if (data.value == 0 || data.value == 1 || data.value == 3 || data.value == 4 || data.value == 5) {
                $("#higherUp").show().find(".layui-inline").html("下一个经办人：前道主管");
            }
            else if (data.value == 2 || data.value == 6) {
                $("#higherUp").show().find(".layui-inline").html("下一个经办人：前道组长");
            }

            form.render();
        });

        form.on("select(companyId)", function (data) {
            getCompanyMember (data.value);
            var dataList = JSON.parse(data.elem[data.elem.selectedIndex].title);
            $("input[name=number]").val($(data.elem[data.elem.selectedIndex]).attr("serialNumber"));
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < dataList.length; i++) {
                var obj = dataList[i];
                html += "<option value=\"" + obj + "\">" + new Date(obj).format('yyyy-MM') + "</option>";
            }
            $("#theBillingMonth").html(html);
            form.render();
        });

        //监听提交
        form.on('submit(demo1)', function(data) {
            if (data.field.serviceType < 7) {
                if (AM.getUserInfo().roleId != 9) {
                    layer.msg("此流程只能前道人员申请");
                    return false;
                }
                if (data.field.serviceType == 0 || data.field.serviceType == 1 || data.field.serviceType == 3 || data.field.serviceType == 4 || data.field.serviceType == 5) {
                    data.field.roleId = 4;
                }
                else if (data.field.serviceType == 2 || data.field.serviceType == 6) {
                    data.field.roleId = 5;
                }
            }
            data.field.status = 0;
            if (data.field.theBillingMonth == "") {
                delete data.field.theBillingMonth;
            }
            else {
                data.field.theBillingMonth = new Date(Number(data.field.theBillingMonth));
            }
            data.field.latestTime = new Date(data.field.latestTime);
            data.field.accessory = $("#fileUrl").val();
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/workOrder/add", data.field, function(result) {
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index);
                window.parent.closeNodeIframe();
            });
            return false;
        });
    });

    /**上传文件获取地址**/
    function onChangeFile (obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
        $("#kaoPanFile").html(file.name);
        var fr = new FileReader();
        if(window.FileReader) {
            fr.onloadend = function(e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: AM.ip + '/res/upload',
                    success: function(result) {
                        AM.log(result);
                        if (result.code == 200) {
                            $('#File').val("");
                            layer.close(index);
                            $("#fileUrl").val(result.data.url);
                        } else {
                            layer.close(index);
                            $('#File').val("");
                            layer.msg(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    }

</script>
</body>
</html>
