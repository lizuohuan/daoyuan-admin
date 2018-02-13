<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>业务列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>

<body>

<div class="admin-main">



    <fieldset class="layui-elem-field">
        <legend>业务列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>业务名称</th>
                    <th>业务描述</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>

</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
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
                url: AM.ip + "/business/queryBusinessByItem",

                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数

                }
            },
            "columns":[
                {"data": "businessName"},
                {"data": "describe"},
            ],
            "columnDefs":[

                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if(row.id > 7){
                            if (row.isValid == 1) {
                                btn += "<button onclick='updateStatus(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_33'><i class='fa fa-trash-o fa-lg'></i>&nbsp;删除</button>";
                            }
                            btn += "<button onclick='updateData(" + row.id + ",\""+row.businessName+"\",\""+row.describe+"\")' class='layui-btn layui-btn-small hide checkBtn_34'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        }
                        if(row.id == 6 || row.id == 7){
                            btn += "<button onclick='checkItems(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_35'><i class='fa fa-list fa-edit'></i>&nbsp;子类管理</button>";
                        }
                        return  btn;
                    },
                    "targets": 2
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
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">业务名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="businessName"  autocomplete="off" lay-verify="required"  placeholder="请输入业务名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">描述</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="describe"  autocomplete="off" lay-verify="required"  placeholder="请输入描述" class="layui-input" maxlength="100" />' +
                '</div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "添加信息", ["500px", "300px"], function () {
            var arr = {
                businessName : $("#businessName").val(),
                describe : $("#describe").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/business/addBusiness", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});
    }

    //查看/修改数据
    function updateData(id,businessName,describe) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">业务名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="businessName" value="'+businessName+'" autocomplete="off" lay-verify="required"  placeholder="请输入业务名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">描述</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="describe" value="'+describe+'" autocomplete="off" lay-verify="required"  placeholder="请输入描述" class="layui-input" maxlength="100" />' +
                '</div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "修改信息", ["500px", "300px"], function () {
            var arr = {
                businessName : $("#businessName").val(),
                describe : $("#describe").val(),
                id : id
            }
            AM.ajaxRequestData("post", false, AM.ip + "/business/updateBusiness", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});
    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "";
        if (status == 0) {
            statusMsg = "是否删除业务?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/business/updateBusiness", arr, function (result) {
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

    function checkItems(id){
        var index = layer.open({
            type: 2,
            title: '子类管理',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/config/business/itemList?businessId="+id
        });
        layer.full(index);

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
