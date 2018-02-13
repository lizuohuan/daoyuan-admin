<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>认款列表</title>
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
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-inline">
                                <select id="companyId">
                                    <option value="">请选择</option>
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
        <legend>认款列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>公司名字</th>
                    <th>账单金额</th>
                    <th>认款金额</th>
                    <th>处理方式</th>
                    <th>认款方式</th>
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
                url: AM.ip + "/confirmAmount/getConfirmFund",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyId = $("#companyId").val();
                }
            },
            "columns":[
                {"data": "companyName"},
                {"data": "billAmount"},
                {"data": "confirmAmount"},
                {"data": "handleMethod"},
                {"data": "confirmMethod"},
                {"data": "createTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == null ? "0" : data;
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "纳入次月账单";
                        }
                        else if (data == 1) {
                            return "退回客户";
                        }
                        else if (data == 2) {
                            return "追回尾款";
                        }
                        else if (data == 3) {
                            return "不做处理";
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "自动认款";
                        }
                        else if (data == 1) {
                            return "手动拆分认款";
                        }
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.handleMethod == null || row.handleMethod < 0 || row.handleMethod > 3) {
                            btn += "<button onclick='processMode(" + row.id + ", " +  row.billAmount + ", " +  row.confirmAmount + ")' class='layui-btn layui-btn-small hide checkBtn_132'><i class='fa fa-list fa-edit'></i>&nbsp;处理方式</button>";
                        }
                        else {
                            btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_132'><i class='fa fa-list fa-edit'></i>&nbsp;处理方式</button>";
                        }
                        return btn;
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

    /**处理方式**/
    function processMode (id, billAmount, confirmAmount) {
        var handleMethod = confirmAmount - billAmount; //认款金额 - 账单金额
        if (handleMethod > 0) {
            var html = '<form class="layui-form" action=""><div class="layui-form-item">' +
                    '       <label class="layui-form-label">选择方式</label>' +
                    '       <div class="layui-input-block">' +
                    '           <input type="radio" name="handleMethod" value="0" title="纳入次月账单" checked lay-filter="handleMethod">' +
                    '           <input type="radio" name="handleMethod" value="1" title="退回客户" lay-filter="handleMethod">' +
                    '       </div>' +
                    '   <div class="layui-form-item">' +
                    '       <label class="layui-form-label">开票时间</label>' +
                    '       <div class="layui-input-inline">' +
                    '           <input type="text" id="makeBillTimeStamp" class="layui-input" lay-verify="required" readonly placeholder="开票时间" onclick="layui.laydate({elem: this, festival: true})">' +
                    '       </div>' +
                    '   </div>' +
                    '   </div></form>';
        }
        else if (handleMethod < 0) {
            var html = '<form class="layui-form" action="">' +
                    '   <div class="layui-form-item">' +
                    '       <label class="layui-form-label">选择方式</label>' +
                    '       <div class="layui-input-block">' +
                    '           <input type="radio" name="handleMethod" value="0" title="纳入次月账单" checked>' +
                    '           <input type="radio" name="handleMethod" value="2" title="追回尾款">' +
                    '       </div>' +
                    '   </div>' +
                    '   <div class="layui-form-item">' +
                    '       <label class="layui-form-label">开票时间</label>' +
                    '       <div class="layui-input-inline">' +
                    '           <input type="text" id="makeBillTimeStamp" class="layui-input" lay-verify="required" readonly placeholder="开票时间" onclick="layui.laydate({elem: this, festival: true})">' +
                    '       </div>' +
                    '   </div>' +
                    '</form>';
        }

        layer.confirm(html, {
            btn: ['提交','取消'],
            title: "处理成功",
            area: ["600px", "300px"], //宽高
        }, function () {
            if (Number($("input[name=handleMethod]:checked").val()) == 0 && $("#makeBillTimeStamp").val() == "") {
                layer.tips('请选择开票时间', '#makeBillTimeStamp', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#makeBillTimeStamp").focus();
                return false;
            }
            var parameter = {
                confirmFundId : id,
                handleMethod : $("input[name=handleMethod]:checked").val(),
                makeBillTimeStamp : new Date($("#makeBillTimeStamp").val()).getTime()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/confirmAmount/updateConfirmFund", parameter, function(){
                dataTable.ajax.reload();
                layer.msg('处理成功.', {icon: 1});
                var index = layer.load(1, {shade: [0.5,'#eee']});
                setTimeout(function () {layer.close(index);}, 600);
            });
        }, function () {});
        form.render();
    }

    layui.use(['form', 'layedit', 'laydate', 'element'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate,
                element = layui.element();
        queryAllCompany(0, "companyId", null, 0);
        form.render();

        form.on("radio(handleMethod)", function (data) {
            if (data.value == 0) {
                $("#makeBillTimeStamp").attr("lay-verify", "required");
                $("#makeBillTimeStamp").parent().parent().show();
            }
            else {
                $("#makeBillTimeStamp").removeAttr("lay-verify");
                $("#makeBillTimeStamp").parent().parent().hide();
            }
        })

    });




</script>
</body>
</head>
</html>
