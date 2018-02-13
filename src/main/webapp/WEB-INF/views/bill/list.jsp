<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>票据列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>

<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend>票据列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_65"><i
                        class="layui-icon">
                    &#xe608;</i> 添加票据
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>票据名称</th>
                    <th>票据类型</th>
                    <th>发票抬头</th>
                    <th>税号</th>
                    <th>地址</th>
                    <th>电话</th>
                    <th>开户行</th>
                    <th>银行帐号</th>
                    <th>是否启用</th>
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
    var company = $("#companyId").val();
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
                url: AM.ip + "/billInfo/queryBillInfo",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    data.title = '';
                    data.companyId = company
                }
            },
            "columns":[
                {"data": "name"},
                {"data": "billType"},
                {"data": "title"},
                {"data": "taxNumber"},
                {"data": "address"},
                {"data": "phone"},
                {"data": "accountName"},
                {"data": "bankAccount"},
                {"data": "isEnabled"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "专票";
                        }
                        else if (data == 1) {
                            return "普票";
                        }
                        else if (data == 2) {
                            return "收据";
                        }
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        return 0 == data ? "否" : "是";
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isEnabled == 1) {
                            btn += "<button onclick='updateStatus(" + row.id + ",0,"+row.billType+")' class='layui-btn layui-btn-small layui-btn-danger hide checkBtn_66'><i class='fa fa-list fa-edit'></i>&nbsp;禁用</button>";
                        }else{
                            btn += "<button onclick='updateStatus(" + row.id + ",1,"+row.billType+")' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_66'><i class='fa fa-list fa-edit'></i>&nbsp;启用</button>";
                        }

//                        if (row.isFirstBill == 1) {
//                            btn += "<button onclick='setIsFirstBill(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_67'><i class='fa fa-list fa-edit'></i>&nbsp;设置先款后票</button>";
//                        }else{
//                            btn += "<button onclick='setIsFirstBill(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_67'><i class='fa fa-list fa-edit'></i>&nbsp;设置先票后款</button>";
//                        }

                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_68'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>";
                        return  btn;
                    },
                    "targets": 9
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
            title: '添加票据',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bill/add?companyId="+companyId
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改票据',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bill/edit?id=" + id
        });
        layer.full(index);
    }


    //
    function setIsFirstBill(id, isFirstBill) {
        var statusMsg = "";
        if (isFirstBill == 0) {
            statusMsg = "是否设置成先款后票?";
        }else{
            statusMsg = "是否设置成先票后款?";
        }
        var arr = {
            id : id,
            isFirstBill : isFirstBill
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/billInfo/updateBillInfo", arr, function (result) {
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

    //删除票据信息
    function updateStatus(id, isEnabled,billType) {
        var statusMsg = "";
        if (isEnabled == 0) {
            statusMsg = "是否禁用票据信息?";
        }else{
            statusMsg = "是否启用票据信息?";
        }
        var arr = {
            id : id,
            isEnabled : isEnabled,
            billType : billType
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/billInfo/updateBillInfo", arr, function (result) {
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
