<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>行业分类列表</title>

    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .coverImg {
            width: 200px;
            height: 100px;
            border: 1px solid #eee;
        }
    </style>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">行业</label>
                            <div class="layui-input-inline">
                                <input type="text" id="tradeName" lay-verify="" placeholder="请输入行业" autocomplete="off"
                                       class="layui-input" maxlength="20">
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
        <legend>行业列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_27"><i
                        class="layui-icon">&#xe608;</i> 添加行业
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>行业</th>
                    <th>描述</th>
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
                url: AM.ip + "/trade/queryTradeByItem",
                headers: {
                    "token": AM.getUserInfo() == null ? null : AM.getUserInfo().token,
                },
                "dataSrc": function (json) {
                    console.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.tradeName = $("#tradeName").val();
                }
            },
            "columns": [
                {"data": "tradeName"},
                {"data": "describe"},
            ],
            "columnDefs": [
                {
                    "render": function (data, type, row) {
                        return null == data ? "-" : data;
                    },
                    "targets": 1
                }, {
                    "render": function (data, type, row) {
                        var btn = "";

                        return "<button onclick='updateData(" + row.id + ",\"" + row.tradeName + "\",\"" + row.describe + "\")' " +
                                "class='layui-btn layui-btn-small hide checkBtn_28'>" +
                                "<i class='fa fa-list fa-edit'></i>&nbsp;修改</button>"
                                + btn
                                ;
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
        var html =
                '<form class="layui-form" action="" id="formData">' +
                '<div class="layui-form-item" style="margin-left: 10px">' +
                '<label class="layui-form-label">分类名称 <span class="font-red">*</span></label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="tradeName" id="tradeNameAdd" lay-verify="required"  placeholder="请输入行业名" autocomplete="off" class="layui-input" maxlength="50">' +
                ' </div>' +
                '</div>' +
                '<div class="layui-form-item" style="margin-left: 10px">' +
                '<label class="layui-form-label">描述 <span class="font-red">*</span></label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="describe" id="describeAdd" lay-verify="required" placeholder="请输入描述" autocomplete="off" class="layui-input" maxlength="50">' +
                ' </div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "添加行业", ["500px", "300px"], function () {
            if ($("#tradeNameAdd").val() == "") {
                layer.tips('请输入行业名', '#tradeNameAdd', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#tradeNameAdd").focus();
                return false;
            }
            if ($("#describeAdd").val() == "") {
                layer.tips('请输入描述', '#describeAdd', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#describeAdd").focus();
                return false;
            }
            var arr = {
                tradeName : $("#tradeNameAdd").val(),
                describe : $("#describeAdd").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/trade/addTrade", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('添加成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});
    }

    //查看/修改数据
    function updateData(id, tradeName,describe) {
        var html =
                '<form class="layui-form" action="" id="formData">' +
                '<div class="layui-form-item" style="margin-left: 10px">' +
                '<label class="layui-form-label">分类名称 <span class="font-red">*</span></label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="tradeName" id="tradeNames" lay-verify="required" value="'+tradeName+'" placeholder="请输入行业名" autocomplete="off" class="layui-input" maxlength="50">' +
                ' </div>' +
                '</div>' +
                '<div class="layui-form-item" style="margin-left: 10px">' +
                '<label class="layui-form-label">描述 <span class="font-red">*</span></label>' +
                '<div class="layui-input-block">' +
                '<input type="text" name="describe" id="describe"  value="'+describe+'" placeholder="请输入描述" autocomplete="off" class="layui-input" maxlength="50">' +
                ' </div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "修改信息", ["500px", "300px"], function () {
            if ($("#tradeNames").val() == "") {
                layer.tips('请输入行业名', '#tradeNames', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#tradeNames").focus();
                return false;
            }
            if ($("#describe").val() == "") {
                layer.tips('请输入描述', '#describe', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#describe").focus();
                return false;
            }
            var arr = {
                id : id,
                tradeName : $("#tradeNames").val(),
                describe : $("#describe").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/trade/update", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('修改成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});

    }


    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

    });


</script>
</body>
</html>
