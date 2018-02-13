<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>账单列表</title>
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
        <legend>账单列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>总金额(实收金额)</th>
                    <th>应收金额</th>
                    <th>核销差额</th>
                    <th>是否稽核</th>
                    <th>稽核差额</th>
                    <th>服务月</th>
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
                url: AM.ip + "/companySonBillItem/list",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companySonTotalBillId = AM.getUrlParam("companySonTotalBillId");
                }
            },
            "columns":[
                {"data": "totalPrice"},
                {"data": "receivablePrice"},
                {"data": "balanceOfCancelAfterVerification"},
                {"data": "isAudit"},
                {"data": "auditTheDifference"},
                {"data": "serviceMonth"},
                {"data": "createTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        return  data == 0 ? "否" : "是";
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return  data == null || data == "" ? "--" : data;
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM");
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        /*btn += "<button onclick='billDetail(" + row.id + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>总账单</button>";
                        btn += "<button onclick='socialSecurityDetail(" + row.id + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>社保明细</button>";
                        btn += "<button onclick='accumulationFundDetail(" + row.id + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>公积金明细</button>";
                        btn += "<button onclick='salaryDetail(" + row.id + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>工资明细</button>";*/
                        btn += "<button onclick='allDetail(" + row.id + ", " + row.createTime + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>账单明细</button>";
                        /*if (row.status == 0) {
                            btn += "<button onclick='updateStatus(" + row.id + ", 1)' class='layui-btn layui-btn-small layui-btn-danger'>驳回</button>";
                            btn += "<button onclick='updateStatus(" + row.id + ", 2)' class='layui-btn layui-btn-small layui-btn-warm'>确认账单</button>";
                        }
                        btn += "<button onclick='sendTheBill(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm'>发送账单</button>";*/
                        return  btn;
                    },
                    "targets": 7
                },
            ]
        });

        $("#search").click(function () {
            dataTable.ajax.reload();
            return false;
        });

    });

    //修改状态
    function updateStatus(id, status) {
        var statusMsg = status == 1 ? "是否驳回?" : "是否确认?";
        var arr = {
            sonBillId : id,
            status : status
        };
        layer.confirm(statusMsg, {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonBillItem/updateStatus", arr, function (result) {
                dataTable.ajax.reload();
                layer.msg("确认账单成功");
            });
            layer.close(index);
        });
    }

    /**总账单**/
    function billDetail (companySonBillItemId) {
        var index = layer.open({
            type: 2,
            title: '总账单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/billDetail?companySonBillItemId=" + companySonBillItemId
        });
        layer.full(index);
    }

    /**社保信息**/
    function socialSecurityDetail (companySonBillItemId) {
        var index = layer.open({
            type: 2,
            title: '社保信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/socialSecurityDetail?companySonBillItemId=" + companySonBillItemId
        });
        layer.full(index);
    }

    /**公积金信息**/
    function accumulationFundDetail (companySonBillItemId) {
        var index = layer.open({
            type: 2,
            title: '公积金信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/accumulationFundDetail?companySonBillItemId=" + companySonBillItemId
        });
        layer.full(index);
    }

    /**工资信息**/
    function salaryDetail (companySonBillItemId) {
        var index = layer.open({
            type: 2,
            title: '工资信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/salaryDetail?companySonBillItemId=" + companySonBillItemId
        });
        layer.full(index);
    }

    /**账单明细**/
    function allDetail (companySonBillItemId, createTime) {
        var index = layer.open({
            type: 2,
            title: '账单明细',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/allDetail?companySonBillItemId=" + companySonBillItemId + "&createTime=" + createTime + "&companySonBillId=" + AM.getUrlParam("companySonBillId")
        });
        layer.full(index);
    }

    /**发送账单**/
    function sendTheBill(id) {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var url = "http://" + window.location.host + "/web/page/h5/allDetail?companySonBillItemId=" + id + "&createTime=" + createTime + "&companySonBillId=" + AM.getUrlParam("companySonBillId");
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBillItem/sendSonBill", {companySonBillItemId : id, url : url}, function (result) {
            layer.msg("发送账单成功.");
        });
        layer.close(index);
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        queryAllCompany(0, "companyId", null, 0);
        form.render();
    });




</script>
</body>
</head>
</html>
