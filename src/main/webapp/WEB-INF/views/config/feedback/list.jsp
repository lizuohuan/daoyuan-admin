<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>意见反馈列表</title>
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
                            <label class="layui-form-label">客户名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="companyName" lay-verify="" placeholder="请输入客户名称"
                                       autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">反馈时间</label>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="选择反馈时间" id="LAY_actiontime">
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
        <legend>意见反馈列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <!--<blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_40"><i
                        class="layui-icon">
                    &#xe608;</i> 添加快递公司
                </button>
            </blockquote>-->
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>客户名称</th>
                    <th>内容</th>
                    <th>反馈时间</th>
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
                url: AM.ip + "/suggest/list",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.userName = $("#actionUser").val();
                    if ($("#LAY_actiontime").val() != "") {
                        data.startTimeStamp = new Date($("#LAY_actiontime").val()).getTime();
                    }
                }
            },
            "columns":[
                {"data": "companyName"},
                {"data": "content"},
                {"data": "createTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        var actionuser = "";
                        return  actionuser+data;
                    },
                    "targets": 0
                },{
                    "render": function (data, type, row) {
                        if (data == null || data == "") {
                            return "--";
                        }
                        return '<a href="'+data+'" target="_blank">'+data+'</a>'
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (data == null) {
                            return "--";
                        }
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
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
                '<label class="layui-form-label">公司名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="expressCompanyName" autocomplete="off" lay-verify="required"  placeholder="请输入公司名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">链接</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="url" autocomplete="off" lay-verify="required"  placeholder="请输入URL" class="layui-input" maxlength="200" />' +
                '</div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "添加信息", ["500px", "300px"], function () {
            var arr = {
                expressCompanyName : $("#expressCompanyName").val(),
                url : $("#url").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/express/addExpressCompany", arr , function(result){
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
    function updateData(id,url,name) {


        var html = '<form class="layui-form layui-form-pane" action="">' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">公司名称</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="expressCompanyName" autocomplete="off" lay-verify="required" value="' + name + '" placeholder="请输入公司名称" class="layui-input" maxlength="20" />' +
                '</div>' +
                '</div>' +
                '<div class="layui-form-item layui-form-text">' +
                '<label class="layui-form-label">链接</label>' +
                '<div class="layui-input-block">' +
                '<input type="text" id="url" autocomplete="off" lay-verify="required" value="' + url + '" placeholder="请输入URL" class="layui-input" maxlength="200" />' +
                '</div>' +
                '</div>' +
                '</form>';

        AM.formPopup(html, "修改信息", ["500px", "300px"], function () {
            var arr = {
                id : id,
                expressCompanyName : $("#expressCompanyName").val(),
                url : $("#url").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/express/updateExpressCompany", arr , function(result){
                if(result.flag == 0 && result.code == 200){
                    dataTable.ajax.reload();
                    layer.msg('修改成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5,'#eee']});
                    setTimeout(function () {layer.close(index);}, 600);
                }
            });
        }, function () {});

    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "是否激活账户?";
        if (status == 0) {
            statusMsg = "是否删除公司?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/express/updateExpressCompany", arr, function (result) {
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
        getRoleList(0); //角色列表
    });





    function updatePassWord(id) {
        layer.prompt({
            formType: 3,
            title: '请输入密码',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            var arr = {
                id: id,
                pwd: $.md5(value)
            }
            AM.ajaxRequestData("post", false, AM.ip + "/user/update", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    layer.load(1, {shade: [0.5, '#eee']});
                    setTimeout(function () {
                        layer.closeAll();
                    }, 600);
                }
            });
        });


    }


    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
            layer = layui.layer,
            laydate = layui.laydate;
        var start = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('LAY_actiontime').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        form.render();
    });
</script>
</body>
</head>
</html>
