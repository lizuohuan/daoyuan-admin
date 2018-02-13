<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>险种档次列表</title>
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
                            <label class="layui-form-label">险种</label>
                            <div class="layui-input-inline">
                                <input type="text" id="insuranceName" placeholder="险种" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">档次</label>
                            <div class="layui-input-inline">
                                <input type="text" id="levelName" placeholder="档次" autocomplete="off" class="layui-input" maxlength="20">
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
        <legend>险种档次列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_106"><i
                        class="layui-icon">
                    &#xe608;</i>添加险种档次
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>险种</th>
                    <th>档次</th>
                    <th>公司缴纳类型</th>
                    <th>公司缴纳金额/比例</th>
                    <th>个人缴纳类型</th>
                    <th>个人缴纳金额/比例</th>
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
                url: AM.ip + "/transactorInsuranceLevel/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.transactorId = AM.getUrlParam("transactorId");
                    data.levelName = $("#levelName").val();
                    data.insuranceName = $("#insuranceName").val();
                }
            },
            "columns":[
                {"data": "payTheWay.insuranceName"},
                {"data": "payTheWay.insuranceLevelName"},
                {"data": "coPayType"},
                {"data": "coPayPrice"},
                {"data": "mePayType"},
                {"data": "mePayPrice"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == 0 ? "金额" : "比例";
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        if (row.coPayType == 1) {
                            return data + "%";
                        }
                        else if (row.coPayType == 0) {
                            data = data == null ? 0 : data;
                            return "￥" + data;
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return data == 0 ? "金额" : "比例";
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        if (row.mePayType == 1) {
                            return data + "%";
                        }
                        else if (row.mePayType == 0) {
                            data = data == null ? 0 : data;
                            return "￥" + data;
                        }
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_107'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        return  btn;
                    },
                    "targets": 6
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
            title: '添加险种档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/transactorInsuranceLevel/add?transactorId=" + AM.getUrlParam("transactorId") + "&payPlaceId=" + AM.getUrlParam("payPlaceId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改险种档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/transactorInsuranceLevel/edit?id=" + id + "&payPlaceId=" + AM.getUrlParam("payPlaceId") + "&transactorId=" + AM.getUrlParam("transactorId")
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
