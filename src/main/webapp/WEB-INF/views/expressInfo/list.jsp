<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>快递列表</title>
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
                            <label class="layui-form-label">快递单号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="orderNumber" lay-verify="" placeholder="请输入订单号"
                                       autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">快递公司</label>
                            <div class="layui-input-inline">
                                <select name="expressCompanyId" id="expressCompanyId" lay-verify="required" lay-search>
                                    <option value="">请选择快递公司</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">是否收到</label>
                            <div class="layui-input-inline">
                                <select name="isReceive" id="isReceive" lay-verify="required" lay-search>
                                    <option value="">请选择</option>
                                    <option value="1">是</option>
                                    <option value="0">否</option>
                                </select>
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
        <legend>快递列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_62"><i
                        class="layui-icon">
                    &#xe608;</i> 添加快递信息
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>快递单号</th>
                    <th>快递公司</th>
                    <th>内容</th>
                    <th>客户名称</th>
                    <th>收件人</th>
                    <th>是否收到</th>
                    <th>收件时间</th>
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
                url: AM.ip + "/express/queryExpressInfo",

                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.orderNumber = $("#orderNumber").val();
                    data.expressCompanyId = $("#expressCompanyId").val();
                    data.isReceive = $("#isReceive").val();
                    data.companyId = $("#companyId").val();
                }
            },
            "columns":[
                {"data": "orderNumber"},
                {"data": "expressCompanyName"},
                {"data": "content"},
                {"data": "companyName"},
                {"data": "expressPersonName"},
                {"data": "isReceive"},
                {"data": "receiveDate"},
            ],
            "columnDefs":[

                {
                    "render": function (data, type, row) {
                        return "<a href='"+row.expressUrl+"' target='_blank'><span style='color: blue;text-decoration: underline;'>"+data+"</span></a>";
                    },
                    "targets": 0
                }, {
                    "render": function (data, type, row) {
                        return 1 == data ? "收到" : "未收到";
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {

                        if(null == data || data == ''){
                            return "--"
                        }

                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isReceive == 0) {
                            btn += "<button onclick='updateStatus(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_63'><i class='fa fa-list fa-edit'></i>&nbsp;确认到件</button>";
                        }
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_64'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>";
                        return  btn;
                    },
                    "targets": 7
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
            content: AM.ip + "/page/expressInfo/add?companyId="+companyId
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改快递信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/expressInfo/edit?id=" + id
        });
        layer.full(index);
    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "";
        if (status == 1) {
            statusMsg = "是否确认到件?";
        }
        var arr = {
            id : id,
            isReceive : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/express/updateExpressInfo", arr, function (result) {
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
        getExpressCompanyList(0); //快递公司列表
    });




</script>
</body>
</head>
</html>
