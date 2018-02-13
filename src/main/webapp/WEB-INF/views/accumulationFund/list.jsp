<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>托管配置列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend>托管配置列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button id="shebao" onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_72"><i
                        class="layui-icon">
                    &#xe608;</i> 添加社保配置
                <button id="gongjijin" onclick="addData2()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_73"><i
                        class="layui-icon">
                    &#xe608;</i> 添加公积金配置
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>托管类型</th>
                    <th>缴金地</th>
                    <th>经办机构</th>
                    <th>公司</th>
                    <th>比例</th>
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

    $(function () {
        if (AM.getUrlParam("isShowSocialSecurity") == 1 && AM.getUrlParam("isShowAccumulationFund") == 0) {
            $("#gongjijin").remove();
        }
        if (AM.getUrlParam("isShowSocialSecurity") == 0 && AM.getUrlParam("isShowAccumulationFund") == 1) {
            $("#shebao").remove();
        }
    })

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
                url: AM.ip + "/companyPayPlace/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyId = AM.getUrlParam("companyId");
                }
            },
            "columns":[
                {"data": "type"},
                {"data": "payPlaceName"},
                {"data": "organizationName"},
                {"data": "transactorName"},
                {"data": "mePayPrice"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == 0 ? "社保" : "公积金";
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return data == null ? "--" : data;
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (row.type == 0) {
                            return data == null ? "--" : data + "社保局";
                        }
                        else {
                            return data == null ? "--" : data + "公积金中心";
                        }
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        if (row.type == 0) {
                            return "--";
                        }
                        else {
                            return data + "%";
                        }
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.type == 0) {
                            btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_74'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        }
                        else {
                            btn += "<button onclick='updateData2(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_74'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        }
                        return  btn;
                    },
                    "targets": 5
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
            title: '添加社保配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/socialSecurity/add?companyId=" + AM.getUrlParam("companyId")
        });
        layer.full(index);
    }

    //添加
    function addData2() {
        var index = layer.open({
            type: 2,
            title: '添加公积金配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/accumulationFund/add?companyId=" + AM.getUrlParam("companyId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改社保配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/socialSecurity/edit?id=" + id
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData2(id) {
        var index = layer.open({
            type: 2,
            title: '修改公积金配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/accumulationFund/edit?id=" + id
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
