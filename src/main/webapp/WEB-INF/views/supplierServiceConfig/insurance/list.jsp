<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>险种列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>

<body>

<div class="admin-main">

    <fieldset class="layui-elem-field">
        <legend>险种列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_94"><i
                        class="layui-icon">
                    &#xe608;</i> 添加险种
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>险种名称</th>
                    <th>备注</th>
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
                url: AM.ip + "/insurance/getInsurance",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.payPlaceId = AM.getUrlParam("payPlaceId");
                }
            },
            "columns":[
                {"data": "insuranceName"},
                {"data": "remark"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_95'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        btn += "<button onclick='findInsuranceLevel(" + row.id + ", \"" + row.insuranceName + "\")' class='layui-btn layui-btn-small hide checkBtn_97'><i class='fa fa-list fa-edit'></i>&nbsp;查看档次</button>";
                        btn += "<button onclick='deleteData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_96'><i class='fa fa-list fa-edit'></i>&nbsp;删除</button>";
                        return  btn;
                    },
                    "targets": 2
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
            title: '添加险种',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insurance/add?payPlaceId=" + AM.getUrlParam("payPlaceId")
        });
        layer.full(index);
    }

    //查看档次
    function findInsuranceLevel(id, insuranceName) {
        sessionStorage.setItem("insuranceName", insuranceName);
        var index = layer.open({
            type: 2,
            title: '查看档次',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insuranceLevel/list?insuranceId=" + id + "&payPlaceId=" + AM.getUrlParam("payPlaceId")
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改险种',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insurance/edit?id=" + id
        });
        layer.full(index);
    }

    //删除
    function deleteData(id) {
        var index = layer.confirm('确定删除该险种？', {
            title: "温馨提示",
            btn: ['确定','取消'] //按钮
        }, function(){
            AM.ajaxRequestData("post", false, AM.ip + "/insurance/updateIsValid", {id : id, isValid : 0}  , function(result) {
                dataTable.ajax.reload();
                layer.close(index);
            });
        }, function(){ });
    }

    layui.use(['form'], function () {
        form = layui.form();
    });

</script>
</body>
</head>
</html>
