<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>业务子类列表</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>

<body>

<div class="admin-main">



    <fieldset class="layui-elem-field">
        <legend>业务子类列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_36"><i
                        class="layui-icon">
                    &#xe608;</i> 添加子类
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>子类名称</th>
                    <th>业务分类</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>

    <input type="hidden" value="${businessId}" id="businessId">

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
                url: AM.ip + "/business/queryBusinessItemByItem",

                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.businessId = $("#businessId").val();
                }
            },
            "columns":[
                {"data": "itemName"},
                {"data": "isCompany"},
            ],
            "columnDefs":[

                {
                    "render": function (data, type, row) {

                        if(data == 0){
                            return "公司";
                        }
                        if(data == 1){
                            return "员工";
                        }
                        return  "--";
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isValid == 1) {
                            btn += "<button onclick='updateStatus(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_37'><i class='fa fa-list fa-edit'></i>&nbsp;删除</button>";
                        }
                        var msg = row.isCompany == 0 ? "设置员工" : "设置公司";
                        btn += "<button onclick='updateData(" + row.id + ",\""+row.itemName+"\")' class='layui-btn layui-btn-small hide checkBtn_38'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        btn += "<button onclick='setData(" + row.id + ",\""+row.isCompany+"\")' class='layui-btn layui-btn-small hide checkBtn_39'><i class='fa fa-list fa-edit'></i>&nbsp;"+msg+"</button>";
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

        var businessId = $("#businessId").val();
        var type;
        var temp = "";
        if(businessId == 6){
            // 商业险
            type = 0;
            temp += '<div class="layui-form-item layui-form-text">' +
            '<label class="layui-form-label">服务费</label>' +
            '<div class="layui-input-block">' +
            '<input type="number" id="serviceFee"  autocomplete="off" lay-verify="required"  placeholder="请输入服务费" class="layui-input" maxlength="20" />' +
            '</div>' +
            '</div>'+
             '<div class="layui-form-item layui-form-text">' +
            '<label class="layui-form-label">收费方式</label>' +
            '<div class="layui-input-block">' +
            '<input type="radio" name="chargeMethod"  value="0" title="按年" checked />' +
            '<input type="radio" name="chargeMethod"  value="1" title="按月" />' +
            '</div>' +
            '</div>';
        }


        if(businessId == 7){
            // 一次性业务
            type = 1;
            temp += '<div class="layui-form-item layui-form-text">' +
                    '<label class="layui-form-label">业务分类</label>' +
                    '<div class="layui-input-block">' +
                    '<input type="radio" name="isCompany"  value="0" title="公司" checked />' +
                    '<input type="radio" name="isCompany"  value="1" title="员工" />' +
                    '</div>' +
                    '</div>';
        }

        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">业务子类名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="itemName"  autocomplete="off" lay-verify="required"  placeholder="请输入业务子类名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +temp+
                '</form>';

        AM.formPopup(html, "添加信息", ["500px", "300px"], function () {
            var arr = {
                itemName : $("#itemName").val(),
                businessId : $("#businessId").val(),
                type : type
            }
            if(type == 0){
                if($("#serviceFee").val() == ''){
                    layer.msg('服务费没有填');
                    return false;
                }
                arr.serviceFee = $("#serviceFee").val();
                arr.chargeMethod = $("input[name='chargeMethod']:checked").val();
            }
            if(type == 1){
                arr.isCompany = $("input[name='isCompany']:checked").val();
            }

            AM.ajaxRequestData("post", false, AM.ip + "/business/addBusinessItem", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});
        form.render();
    }

    //查看/修改数据
    function updateData(id,itemName) {
        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">业务子类名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="itemName" value="'+itemName+'" autocomplete="off" lay-verify="required"  placeholder="请输入业务子类名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "修改信息", ["500px", "300px"], function () {
            var arr = {
                itemName : $("#itemName").val(),
                id : id,
                businessId : $("#businessId").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/business/updateBusinessItem", arr , function(result){
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
            statusMsg = "是否删除业务子类?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/business/updateBusinessItem", arr, function (result) {
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

    function setData(id, isCompany) {
        var statusMsg = "设置分类为公司？";
        if (isCompany == 0) {
            statusMsg = "设置分类为员工？";
        }
        var arr = {
            id : id,
            isCompany : 0 == isCompany ? 1 : 0
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/business/updateBusinessItem", arr, function (result) {
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

        //自定义验证规则
        form.verify({
            isNumber: function(value) {
                if(value.length > 0 && !AM.isNumber.test(value)) {
                    return "请输入一个整数";
                }
            },
            isPhone: function(value) {
                if(value.length > 0 && !AM.isMobile.test(value)) {
                    return "请输入一个正确的手机号";
                }
            },
            isEmail: function(value) {
                if(value.length > 0 && !AM.isEmail.test(value)) {
                    return "请输入一个正确的邮箱";
                }
            },
            isNumberChar: function(value) {
                if(value.length > 0 && !AM.isNumberChar.test(value)) {
                    return "只能为数字和字母";
                }
            }

        });


    });




</script>
</body>
</head>
</html>
