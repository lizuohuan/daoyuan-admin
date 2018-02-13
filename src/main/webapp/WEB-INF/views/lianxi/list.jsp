<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>联系人列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>

<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">联系人</label>
                            <div class="layui-input-inline">
                                <input type="text" name="contactsName" id="contactsName" lay-verify=""
                                       placeholder="按联系人搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">座机</label>
                            <div class="layui-input-inline">
                                <input type="text" id="landLine" name="landLine" lay-verify="" placeholder="请输入座机" autocomplete="off"
                                       class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="phone" name="phone" lay-verify="" placeholder="请输入手机号" autocomplete="off"
                                       class="layui-input" maxlength="20">
                            </div>
                        </div>

                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">QQ</label>
                            <div class="layui-input-inline">
                                <input type="text" name="qq" id="qq" lay-verify=""
                                       placeholder="按QQ号搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">邮箱</label>
                            <div class="layui-input-inline">
                                <input type="text" name="email" id="email" lay-verify=""
                                       placeholder="按邮箱搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">微信号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="weChat" id="weChat" lay-verify=""
                                       placeholder="按微信号搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>

                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" id="search"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field">
        <legend>联系人列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_56"><i
                        class="layui-icon">
                    &#xe608;</i> 添加联系人
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>联系人</th>
                    <th>所属公司</th>
                    <th>固定电话</th>
                    <th>手机号</th>
                    <th>QQ</th>
                    <th>邮箱</th>
                    <th>微信</th>
                    <th>部门</th>
                    <th>职位</th>
                    <th>账单接受人</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
    <input type="hidden" id="companyId" value="${companyId}">
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
<script>

    var form = null;
    var dataTable = null;
    $(document).ready(function () {
        dataTable = $('#dataTable').DataTable({
            "searching": false, "bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
            "processing": true,
            "serverSide": true,
            "bLengthChange": false, "bSort": false, //关闭排序功能
            //"pagingType": "bootstrap_full_number",
            'language': {
                'emptyTable': '没有数据',
                'loadingRecords': '加载中...',
                'processing': '查询中...',
                'search': '全局搜索:',
                'lengthMenu': '每页 _MENU_ 件',
                'zeroRecords': '没有您要搜索的内容',
                'paginate': {
                    'first': '第一页',
                    'last': '最后一页',
                    'next': '下一页',
                    'previous': '上一页'
                },
                'info': '第 _PAGE_ 页 / 总 _PAGES_ 页',
                'infoEmpty': '没有数据',
                'infoFiltered': '(过滤总件数 _MAX_ 条)'
            },
            //dataTable 加载加载完成回调函数
            "fnDrawCallback": function (sName, oData, sExpires, sPath) {
                checkJurisdiction(); //调用权限
                form.render();
            },
            "ajax": {
                url: AM.ip + "/contacts/getContactsByItems",
                data:{
                    companyId : $("#companyId").val()
                },
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.contactsName = $("#contactsName").val();
                    data.landLine = $("#landLine").val();
                    data.phone = $("#phone").val();
                    data.qq = $("#qq").val();
                    data.email = $("#email").val();
                    data.weChat = $("#weChat").val();
                    data.companyId = $("#companyId").val();
                    data.type = 0;
                }
            },
            "columns":[
                {"data": "contactsName"},
                {"data": "companyName"},
                {"data": "landLine"},
                {"data": "phone"},
                {"data": "qq"},
                {"data": "email"},
                {"data": "weChat"},
                {"data": "departmentName"},
                {"data": "jobTitle"},
                {"data": "isReceiver"},
                {"data": "isValid"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return 0 == data ? "否" : "是";
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                        return 0 == data ? "无效" : "有效";
                    },
                    "targets": 10
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isValid == 1) {
                            btn += "<button onclick='updateStatus(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-danger hide checkBtn_57'><i class='fa fa-list fa-edit'></i>&nbsp;设置无效</button>";
                        }
                        else{
                            btn += "<button onclick='updateStatus(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_57'><i class='fa fa-list fa-edit'></i>&nbsp;设置有效</button>";
                        }
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_58'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>";
                        return  btn;
                    },
                    "targets": 11
                },
            ]
        });

        $("#search").click(function () {
            dataTable.ajax.reload();
            return false;
        });

    });

    //提供给子页面
    var closeNodeIframe = function () {
        dataTable.ajax.reload();
        var index = layer.load(1, {shade: [0.5, '#eee']});
        setTimeout(function () {
            layer.close(index);
        }, 600);
    }

    //添加
    function addData() {
        var companyId = $("#companyId").val();
        var index = layer.open({
            type: 2,
            title: '添加联系人',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/lianxi/add?companyId="+companyId
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改课程',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/lianxi/edit?id=" + id
        });
        layer.full(index);
    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "";
        if (status == 0) {
            statusMsg = "是否设置联系人为无效?";
        }
        else{
            statusMsg = "是否设置联系人为有效?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/contacts/updateContacts", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5, '#eee']});
                    setTimeout(function () {
                        layer.close(index);
                    }, 600);
                }
            });
            layer.close(index);
        });

    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
    });




</script>
</body>
</head>
</html>
