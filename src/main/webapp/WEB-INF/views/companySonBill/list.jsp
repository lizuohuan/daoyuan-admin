<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>子账单列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>

<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote" id="screen">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">子账单名称</label>
                            <div class="layui-input-inline">
                                <input type="text" placeholder="子账单名称" id="sonBillName" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">账单接收人</label>
                            <div class="layui-input-inline">
                                <select id="contactsId" lay-search>
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">票据</label>
                            <div class="layui-input-inline">
                                <select id="billInfoId" lay-search>
                                    <option value="">请选择</option>
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
        <legend>子账单列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_110"><i
                        class="layui-icon">
                    &#xe608;</i> 添加子账单
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>所属公司</th>
                    <th>子账单名称</th>
                    <th>账单接收人</th>
                    <th>所属票据</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>
//    if (AM.getUrlParam("companyId") != "" && AM.getUrlParam("companyId") != undefined && AM.getUrlParam("companyId") != null) {
//        $("#screen").hide();
//    }

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
                url: AM.ip + "/companySonBill/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyName = $("#companyName").val();
                    data.sonBillName = $("#sonBillName").val();
                    data.contactsId = $("#contactsId").val();
                    data.billInfoId = $("#billInfoId").val();
                    if (AM.getUrlParam("companyId") != "" && AM.getUrlParam("companyId") != undefined && AM.getUrlParam("companyId") != null) {
                        data.companyId = AM.getUrlParam("companyId");
                    }
                }
            },
            "columns":[
                {"data": "companyName"},
                {"data": "sonBillName"},
                {"data": "contactsName"},
                {"data": "companyBillInfoName"},
            ],
            "columnDefs":[

                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isValid == 1) {
                            btn += "<button onclick='updateStatus(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_111'><i class='fa fa-list fa-edit'></i>&nbsp;删除</button>";
                        }
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_112'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>";
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
        var params = "";
        if (AM.getUrlParam("companyId") != "" && AM.getUrlParam("companyId") != undefined && AM.getUrlParam("companyId") != null) {
            params = "?companyId="+AM.getUrlParam("companyId");
        }
        var index = layer.open({
            type: 2,
            title: '添加子账单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companySonBill/add"+params
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改子账单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companySonBill/edit?id=" + id
        });
        layer.full(index);
    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "";
        if (status == 0) {
            statusMsg = "是否删除?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/updateIsValid", arr, function (result) {
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

        queryAllCompany(0, "companyId", null, 0);
        // 初始化账单接收人
        getContacts(0,"contactsId",AM.getUrlParam("companyId"),1);
        // 初始化票据
        getBillInfo(0,"billInfoId",AM.getUrlParam("companyId"));
        form.render();
    });




</script>
</body>
</head>
</html>
