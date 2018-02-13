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
                            <label class="layui-form-label">部门</label>
                            <div class="layui-input-inline">
                                <input type="text" name="departmentName" id="departmentName" placeholder="部门" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">职位</label>
                            <div class="layui-input-inline">
                                <input type="text" name="jobTitle" id="jobTitle" placeholder="职位" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">手机号码</label>
                            <div class="layui-input-inline">
                                <input type="text" name="phone" id="phone" placeholder="手机号码" autocomplete="off" class="layui-input" maxlength="20">
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
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_83"><i
                        class="layui-icon">
                    &#xe608;</i> 添加联系人
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>联系人名字</th>
                    <th>部门</th>
                    <th>职位</th>
                    <th>手机号码</th>
                    <th>固定电话</th>
                    <th>QQ</th>
                    <th>E-mail</th>
                    <th>微信号</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
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
                url: AM.ip + "/supplierContacts/list",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.jobTitle = $("#jobTitle").val();
                    data.departmentName = $("#departmentName").val();
                    data.phone = $("#phone").val();
                    data.supplierId = AM.getUrlParam("supplierId");
                }
            },
            "columns":[
                {"data": "contactsName"},
                {"data": "departmentName"},
                {"data": "jobTitle"},
                {"data": "phone"},
                {"data": "landLine"},
                {"data": "qq"},
                {"data": "email"},
                {"data": "weChat"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_84'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        return  btn;
                    },
                    "targets": 8
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
        var index = layer.open({
            type: 2,
            title: '添加联系人',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierContacts/add?supplierId=" + AM.getUrlParam("supplierId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改联系人',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierContacts/edit?id=" + id
        });
        layer.full(index);
    }

    layui.use(['form'], function () {
        form = layui.form();
    });

</script>
</body>
</head>
</html>
