<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>绑定档次列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>

<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend><span id="insuranceName"></span>--档次列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_98"><i
                        class="layui-icon">
                    &#xe608;</i> 绑定档次
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th colspan="6" style="background: #DCE6F1">公司缴纳</th>
                    <th colspan="6" style="background: #D7E6CF">个人缴纳</th>
                </tr>
                <tr>
                    <th>档次名称</th>
                    <th>缴纳类型</th>
                    <th>缴纳金额/比例</th>
                    <th>填写精度</th>
                    <th>基数最小范围</th>
                    <th>基数最大范围</th>
                    <th>缴纳类型</th>
                    <th>缴纳金额/比例</th>
                    <th>填写精度</th>
                    <th>基数最小范围</th>
                    <th>基数最大范围</th>
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
    $("#insuranceName").html(sessionStorage.getItem("insuranceName"));
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
                url: AM.ip + "/payTheWay/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.insuranceId = AM.getUrlParam("insuranceId");
                }
            },
            "columns":[
                {"data": "insuranceLevelName"},
                {"data": "coPayType"},
                {"data": "coPayPrice"},
                {"data": "coPrecision"},
                {"data": "coMinScope"},
                {"data": "coMaxScope"},
                {"data": "mePayType"},
                {"data": "mePayPrice"},
                {"data": "mePrecision"},
                {"data": "meMinScope"},
                {"data": "meMaxScope"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "金额";
                        }
                        else if (data == 1) {
                            return "比例";
                        }
                        else {
                            return "跟随办理方";
                        }
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (data == null || data == 0) {
                            return "--";
                        }
                        else if (row.coPayType == 0) {
                            return "￥" + data;
                        }
                        else if (row.coPayType == 1) {
                            return data + "%";
                        }
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == 0 ? "--" : data;
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == 0 ? "--" : data;
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == 0 ? "--" : data;
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "金额";
                        }
                        else if (data == 1) {
                            return "比例";
                        }
                        else {
                            return "跟随办理方";
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        if (data == null || data == 0) {
                            return "--";
                        }
                        else if (row.mePayType == 0) {
                            return "￥" + data;
                        }
                        else if (row.mePayType == 1) {
                            return data + "%";
                        }
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        return data == null ? "--" : data;
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == 0 ? "--" : data;
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == 0 ? "--" : data;
                    },
                    "targets": 10
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_99'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        return  btn;
                    },
                    "targets": 11
                },
            ]
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
            title: '绑定档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insuranceLevel/add?insuranceId=" + AM.getUrlParam("insuranceId") + "&payPlaceId=" + AM.getUrlParam("payPlaceId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insuranceLevel/edit?id=" + id + "&payPlaceId=" + AM.getUrlParam("payPlaceId")
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
