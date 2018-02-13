<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>财务出款列表</title>
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
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select id="status">
                                    <option value="">请选择</option>
                                    <option value="2001">待审核</option>
                                    <option value="2002">待出款</option>
                                    <option value="2003">已出款</option>
                                    <option value="2004">已完成</option>
                                    <option value="2005">已拒绝</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">是否加急</label>
                            <div class="layui-input-inline">
                                <select id="isUrgent">
                                    <option value="">请选择</option>
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">账户名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="accountName" placeholder="账户名称" autocomplete="off" class="layui-input" maxlength="100">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">备注</label>
                            <div class="layui-input-inline">
                                <input type="text" id="remark" placeholder="备注" autocomplete="off" class="layui-input" maxlength="250">
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
        <legend>财务出款列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_141"><i
                        class="layui-icon">
                    &#xe608;</i> 申请出款
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>账户名称</th>
                    <th>开户行</th>
                    <th>银行账号</th>
                    <th>金额</th>
                    <th>是否加急</th>
                    <th>备注</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
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
                url: AM.ip + "/outlayAmountRecord/getOutlayAmountRecordByItems",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.status = $("#status").val();
                    data.isUrgent = $("#isUrgent").val();
                    data.remark = $("#remark").val();
                    data.accountName = $("#accountName").val();
                }
            },
            "columns":[
                {"data": "accountName"},
                {"data": "bankName"},
                {"data": "bankAccount"},
                {"data": "amount"},
                {"data": "isUrgent"},
                {"data": "remark"},
                {"data": "status"},
                {"data": "createTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == 0 ? "否" : "是";
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        if (data == 2001) {
                            return "待审核";
                        }
                        else if (data == 2002) {
                            return "待出款";
                        }
                        else if (data == 2003) {
                            return "已出款";
                        }
                        else if (data == 2004) {
                            return "已完成";
                        }
                        else if (data == 2005) {
                            return "已拒绝";
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        var obj = JSON.stringify(row);
                        var btn = "";
                        if (row.status == 2001) {
                            btn += "<button onclick='updateStatus(" + row.id + ", 2002)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_143'><i class='fa fa-list fa-edit'></i>&nbsp;同意出款</button>";
                            btn += "<button onclick='updateStatus(" + row.id + ", 2005)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_143'><i class='fa fa-list fa-edit'></i>&nbsp;拒绝出款</button>";
                        }
                        else if (row.status == 2002) {
                            btn += "<button onclick='updateStatus(" + row.id + ", 2003)' class='layui-btn layui-btn-small layui-btn hide checkBtn_143'><i class='fa fa-list fa-edit'></i>&nbsp;出款</button>";
                        }
                        else if (row.status == 2003) {
                            btn += "<button onclick='updateStatus(" + row.id + ", 2004)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_143'><i class='fa fa-list fa-edit'></i>&nbsp;完成</button>";
                        }
                        if(row.status != 2004){
                            btn += "<button onclick='updateData(" + obj + ")' class='layui-btn layui-btn-small hide checkBtn_142'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        }
                        return  btn;
                    },
                    "targets": 8
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
            title: '申请出款',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/outlayAmountRecord/add"
        });
        layer.full(index);
    }

    //修改数据
    function updateData(obj) {
        sessionStorage.setItem("outlayAmountRecord", JSON.stringify(obj));
        var index = layer.open({
            type: 2,
            title: '修改财务出款',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/outlayAmountRecord/edit"
        });
        layer.full(index);
    }

    //修改数据
    function updateStatus(id, status) {
        if (status == 2005) {
            var html = '<form class="layui-form" action="">' +
                    '       <div class="layui-form-item">' +
                    '           <label class="layui-form-label">拒绝理由</label>' +
                    '           <div class="layui-input-inline">' +
                    '               <textarea placeholder="请输入拒绝理由" id="reason"></textarea>' +
                    '           </div>' +
                    '       </div>' +
                    '    </form>';

            var index = layer.confirm(html, {
                btn: ['提交','取消'],
                title: "拒绝理由",
                area: ["600px", "500px"],
            }, function () {
                if ($("#reason").val() == "") {
                    layer.msg("请输入拒绝理由");
                    return false;
                }
                AM.ajaxRequestData("post", false, AM.ip + "/outlayAmountRecord/updateStatus", {
                    id : id,
                    status : status,
                    reason:$("#reason").val()
                }, function (result) {
                    layer.close(index);
                    dataTable.ajax.reload();
                });
            }, function () {});
        } else {
            AM.ajaxRequestData("post", false, AM.ip + "/outlayAmountRecord/updateStatus", {
                id : id,
                status : status
            }, function(result) {
                dataTable.ajax.reload();
            });
        }

    }

    layui.use(['form'], function () {
        form = layui.form();
    });

</script>
</body>
</head>
</html>
