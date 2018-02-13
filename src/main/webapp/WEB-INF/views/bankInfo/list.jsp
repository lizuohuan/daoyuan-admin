<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>银行信息列表</title>
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
                            <label class="layui-form-label">开户行</label>
                            <div class="layui-input-inline">
                                <input type="text" name="bankName" id="bankName" placeholder="开户行" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">银行账户</label>
                            <div class="layui-input-inline">
                                <input type="text" name="accountName" id="accountName" placeholder="银行账户" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">银行账号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="bankAccount" id="bankAccount" placeholder="银行账号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">账户类型</label>
                            <div class="layui-input-inline">
                                <select name="type" id="type">
                                    <option value="">请选择</option>
                                    <option value="0">银行卡</option>
                                    <option value="1">支付宝</option>
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
        <legend>银行信息列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_75"><i
                        class="layui-icon">
                    &#xe608;</i> 添加银行信息
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>银行账户</th>
                    <th>银行账号</th>
                    <th>开户行</th>
                    <th>账户类型</th>
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
                url: AM.ip + "/bankInfo/getBankInfo",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        console.log(json);
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.bankName = $("#bankName").val();
                    data.accountName = $("#accountName").val();
                    data.bankAccount = $("#bankAccount").val();
                    data.type = $("#type").val();
                    data.companyId = AM.getUrlParam("companyId");
                }
            },
            "columns":[
                {"data": "accountName"},
                {"data": "bankAccount"},
                {"data": "bankName"},
                {"data": "type"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        if (null != data) {
                            if (data == 0) {
                                return "银行卡";
                            }
                            if (data == 1) {
                                return "支付宝";
                            }
                        } else {
                            return "--";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        var obj = JSON.stringify(row);
                        var btn = "";
                        btn += '<button onclick=\'updateData(' + obj + ')\' class="layui-btn layui-btn-small hide checkBtn_76">修改</button>';
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
            title: '添加银行信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bankInfo/add?companyId=" + AM.getUrlParam("companyId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(data) {
        sessionStorage.setItem("bankInfo", JSON.stringify(data));
        var index = layer.open({
            type: 2,
            title: '修改银行信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bankInfo/edit"
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
