<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>办理方列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>

<body>

<div class="admin-main">
    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">办理方名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="transactorName" placeholder="办理方名称" autocomplete="off" class="layui-input" maxlength="20">
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
        <legend><span id="organizationName"></span>办理方列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_103"><i
                        class="layui-icon">
                    &#xe608;</i>添加办理方
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>办理方名称</th>
                    <th>操作方式</th>
                    <th>最晚实做日期</th>
                    <th>提醒时间</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script>
    $("#organizationName").html(sessionStorage.getItem("organizationName") + "-");
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
                url: AM.ip + "/transactor/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.organizationId = AM.getUrlParam("organizationId");
                    data.transactorName = $("#transactorName").val();
                }
            },
            "columns":[
                {"data": "transactorName"},
                {"data": "operationType"},
                {"data": "inTheEndTime"},
                {"data": "remindTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                       if (data == 0) {
                           return "本月";
                       }
                       else if (data == 1) {
                           return "次月";
                       }
                       else if (data == 2) {
                           return "上月";
                       }
                       else {
                           return "--";
                       }
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (data != null) {
                            return data + "日";
                        }
                        return "--";
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        if (data != null) {
                            return data + "日24点";
                        }
                        return "--";
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_104'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        btn += "<button onclick='insuranceLevel(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_105'><i class='fa fa-list fa-edit'></i>&nbsp;查看档次</button>";
                        return  btn;
                    },
                    "targets": 4
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
            title: '添加办理方',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/transactor/add?organizationId=" + AM.getUrlParam("organizationId")
        });
        layer.full(index);
    }

    //查看档次
    function insuranceLevel(id) {
        var index = layer.open({
            type: 2,
            title: '查看档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/transactorInsuranceLevel/list?transactorId=" + id + "&payPlaceId=" + AM.getUrlParam("payPlaceId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改办理方',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/transactor/edit?id=" + id + "&organizationId=" + AM.getUrlParam("organizationId")
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
