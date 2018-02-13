<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>账单汇总列表</title>
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
                            <label class="layui-form-label">所属公司</label>
                            <div class="layui-input-inline">
                                <input type="text" placeholder="所属公司" id="companyName" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">客服</label>
                            <div class="layui-input-inline">
                                <select name="beforeService" id="beforeService"  lay-search>
                                    <option value="">请选择前道客服</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">账单年月</label>
                            <div class="layui-input-inline">
                                <input class="layui-input"  placeholder="账单年月" onclick="layui.laydate({elem: this, festival: true,type:'month'})" id="billMonthSelect" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">完成核销</label>
                            <div class="layui-input-inline">
                                <select  id="hexiao"  >
                                    <option value="">请选择</option>
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">完成稽核</label>
                            <div class="layui-input-inline">
                                <select  id="jihe" >
                                    <option value="">请选择</option>
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select  id="status" >
                                    <option value="">请选择</option>
                                    <option value="0">未确认</option>
                                    <option value="2">已经确认</option>
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
        <legend>账单汇总列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="batchSend()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_134">批量发送
                </button>
                <button onclick="allSend()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_133">一键全部发送
                </button>
                <button onclick="auditList()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_127">稽核列表
                </button>
                <button onclick="aKeyGeneration()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_52">生成账单
                </button>
                <button onclick="toLeadSalary()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_53">导入工资
                </button>
                <a class="layui-btn layui-btn layui-btn-small layui-btn-normal downloadTemplate" href="<%=request.getContextPath()%>/resources/template/salary.xls"><i class="fa fa-cloud-download"></i>&nbsp;下载工资模版</a>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th><input type="checkbox" name="allSelected" lay-skin="primary" lay-filter="allSelected" ></th>
                    <th>所属公司</th>
                    <th>账单年月</th>
                    <%--<th>稽核余额</th>--%>
                    <th>生成时间</th>
                    <th>账单金额</th>
                    <th>应收金额</th>
                    <th>服务费</th>
                    <th>核销差额</th>
                    <th>是否完成核销</th>
                    <th>稽核差额</th>
                    <th>是否完成稽核</th>
                    <th>状态</th>
                    <th>税费</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>
</div>

<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" accept="application/vnd.ms-excel/vnd.openxmlformats-officedocument.spreadsheetml.sheet" class="hide" onchange="onChangeFile(this)">
    <input type="hidden" name="type" value="1">
</form>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

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
                url: AM.ip + "/companySonTotalBill/listDto",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyName = $("#companyName").val();
                    data.companySonBillId = AM.getUrlParam("companySonBillId");
                    data.beforeService = $("#beforeService").val();
                    data.hexiao = $("#hexiao").val();
                    data.jihe = $("#jihe").val();
                    data.status = $("#status").val();
                    data.billMonthStamp = '' == $("#billMonthSelect").val() ? null : new Date($("#billMonthSelect").val()).getTime();
                }
            },
            "columns":[
                {"data": ""},
                {"data": "companyName"},
                {"data": "billMonth"},
                /*{"data": "monthBalance"},*/
                {"data": "createTime"},
                {"data": "receivablePrice"},
                {"data": "totalPrice"},
                {"data": "serviceFee"},
                {"data": "balanceOfCancelAfterVerification"},
                {"data": "cancelAfterVerificationStatus"},
                {"data": "auditTheDifference"},
                {"data": "auditStatus"},
                {"data": "status"},
                {"data": "taxPrice"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (row.status == 0 || row.status == 2) {
                            return '<input type="checkbox" billMonth = "'+ row.billMonth +'" value="' + row.companyId + '" name="companySonBillItem" lay-skin="primary">';
                        }
                        else {
                            return '<input type="checkbox" disabled lay-skin="primary">';
                        }
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM");
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
//                        var price = data == null ? 0.0 : data + row.serviceFee +
//                        row.salaryInfoPrice;
                        return data == null ? 0.0 : data;
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        /*var price = data == null ? 0.0 : data + row.serviceFee +
                        row.salaryInfoPrice;*/

                        return  data == null ? 0.0 : data;
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        return  data == null ? "--" : data;
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        if(null != row.confirmFund){
                            // 有待认款的记录
                            if(null == data){
                                return (row.confirmFund.confirmAmount - row.totalPrice).toFixed(2);
                            }
                            else{
                                return   (row.confirmFund.confirmAmount - Math.abs(data)).toFixed(2);
                            }
                        }
                        else{
                            return  data == null ? -row.totalPrice : data;
                        }
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        if (null == data) {
                            return "--";
                        }
                        else if (data == 0) {
                            return "未完成";
                        }
                        else if (data == 1) {
                            return "部分完成";
                        }
                        else {
                            return "全部完成";
                        }
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        return  data == null ? "--" : data;
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                        if (null == data) {
                            return "--";
                        }
                        else if (data == 0) {
                            return "未完成";
                        }
                        else if (data == 1) {
                           return "部分完成";
                            // return "未完成";
                        }
                        else {
                            return "全部完成";
                        }
                    },
                    "targets": 10
                },
                {
                    "render": function (data, type, row) {
                        if (row.status == 0) {
                            return "已提交";
                        }
                        else if (row.status == 1) {
                            return "部分确认";
                        }
                        else {
                            return "全部确认";
                        }
                    },
                    "targets": 11
                },
                {
                    "render": function (data, type, row) {
                        if (null == data) {
                            return 0.0;
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 12
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='allDetail(" + row.companyId + ", " + row.billMonth + ")' class='layui-btn layui-btn-small layui-btn layui-btn-normal hide checkBtn_114'>查看账单</button>";
                        btn += "<button onclick='sendTheBill(" + row.companyId + ", " + row.billMonth + ")' class='layui-btn layui-btn-small hide checkBtn_117'>发送账单</button>";
                        if (row.status == 0 || row.status == 1) {
                            //btn += "<button onclick='turnDownBill(" + row.id + ", " + row.createTime + ")' class='layui-btn layui-btn-small layui-btn-danger hide checkBtn_115'>仍需调整</button>";
                            btn += "<button onclick='confirmTheBill(" + row.companyId + ", " + row.billMonth + ","+row.totalPrice+")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_116'>确认</button>";
                        }
                        else if (row.status == 2 && row.isCanCancelBill == 1 && null == row.confirmFund) {
                            btn += "<button onclick='cancelAffirm(" + row.companyId + ", " + row.billMonth + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_116'>取消确认</button>";

                        }

                        if((row.status == 2 && row.isCanCancelBill == 1 && null == row.confirmFund) || row.status == 0){
                            //todo: 删除账单 暂时和取消账单的状态一起使用
                            btn += "<button onclick='delBill(" + row.companyId + ", " + row.billMonth + ")' class='layui-btn layui-btn-small layui-btn-danger hide checkBtn_175'>删除</button>";
                        }
                        // 账单认款处理 按钮

                        if (row.status == 2 && null != row.confirmFund && row.cancelAfterVerificationStatus != 2) {
                            var billAmount = 0.0;
                            if(null == row.balanceOfCancelAfterVerification){
                                billAmount = row.totalPrice;
                            }
                            else{
                                billAmount = -row.balanceOfCancelAfterVerification;
                            }

                            btn += "<button onclick='handleAmount(" + JSON.stringify(row.confirmFund) + ","+billAmount+")' class='layui-btn layui-btn-small  layui-btn-primary hide checkBtn_116'>处理认款</button>";
                        }

                        //btn += "<button onclick='companySonBillItem(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-primary'>子类账单</button>";
                        return  btn;
                    },
                    "targets": 13
                },
            ]
        });

        $("#search").click(function () {
            dataTable.ajax.reload();
            return false;
        });

        form.on('radio(handleMethodFilter)', function(data){
            if(data.value == 2){
                $("#makeBillTimeStampDIV").show("fast");
                $("#makeBillTimeStamp").attr("lay-verify","required");

            }
            else{
                $("#makeBillTimeStampDIV").hide("fast");
                $("#makeBillTimeStamp").removeAttr("lay-verify");
            }
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

    /**确认账单**/
    function confirmTheBill(companyId,billMonth,totalPrice) {
        var arr = {
            companyId : companyId,
            billMonth : billMonth,
            amount : billMonth
        };
        layer.confirm("是否确认?", {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/updateStatusQR", arr, function (result) {
                dataTable.ajax.reload();
                layer.msg("确认账单成功");
            });
            layer.close(index);
        });
    }

    /**驳回账单**/
    function turnDownBill(id, createTime) {
        var arr = {
            companySonTotalBillId : id,
            createTime : createTime
        };
        layer.confirm("是否驳回？", {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/delete", arr, function (result) {
                dataTable.ajax.reload();
                layer.msg("驳回账单成功");
            });
            layer.close(index);
        });
    }


    function handleAmount(confirmFund,billAmount){
        if(null == confirmFund){
            layer.msg("无认款记录.");
            return;
        }
        // alert(JSON.stringify(confirmFund));
        var handleMethod = confirmFund.confirmAmount - billAmount; //认款金额 - 账单金额
        // alert(billAmount);
        if (handleMethod >= 0) {
            var html = '<form class="layui-form" action=""><div class="layui-form-item">' +
                    '       <label class="layui-form-label">选择方式</label>' +
                    '       <div class="layui-input-block">' +
                    '           <input type="radio" name="handleMethod" lay-filter="handleMethodFilter" value="0" title="纳入次月账单(确认核销)" checked lay-filter="handleMethod">' +
                    '           <input type="radio" name="handleMethod" lay-filter="handleMethodFilter" value="1" title="退回客户" lay-filter="handleMethod">' +
                    '       </div>' +
                    '   </div></form>';
        }
        else if (handleMethod < 0) {
            var html = '<form class="layui-form" action="">' +
                    '   <div class="layui-form-item">' +
                    '       <label class="layui-form-label">选择方式</label>' +
                    '       <div class="layui-input-block">' +
                    '           <input type="radio" name="handleMethod" lay-filter="handleMethodFilter" value="0" title="纳入次月账单" checked>' +
                    '           <input type="radio" name="handleMethod" lay-filter="handleMethodFilter" value="2" title="追回尾款">' +
                    '       </div>' +
                    '   </div>' +
                    '   <div class="layui-form-item layui-hide" id="makeBillTimeStampDIV">' +
                    '       <label class="layui-form-label">预计回款时间</label>' +
                    '       <div class="layui-input-inline">' +
                    '           <input type="text" id="makeBillTimeStamp"  class="layui-input" readonly placeholder="预计回款时间" onclick="layui.laydate({elem: this, festival: true})">' +
                    '       </div>' +
                    '   </div>' +
                    '</form>';
        }


        layer.confirm(html, {
            btn: ['提交','取消'],
            title: "处理成功",
            area: ["600px", "300px"], //宽高
        }, function () {
            if (Number($("input[name=handleMethod]:checked").val()) == 2 && $("#makeBillTimeStamp").val() == "") {
                layer.tips('请选择预计回款时间', '#makeBillTimeStamp', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#makeBillTimeStamp").focus();
                return false;
            }
            var parameter = {
                confirmFundId : confirmFund.id,
                handleMethod : $("input[name=handleMethod]:checked").val(),
                billAmount : billAmount
            }
            if(Number($("input[name=handleMethod]:checked").val()) == 2){
                parameter.makeBillTimeStamp = new Date($("#makeBillTimeStamp").val()).getTime();
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

    /**取消确认**/
    function cancelAffirm(companyId,billMonth) {
        var arr = {
            companyId : companyId,
            billMonth : billMonth
        };
        layer.confirm("是否取消确认？", {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/updateStatusQX", arr, function (result) {
                dataTable.ajax.reload();
                layer.msg("取消确认成功");
            });
            layer.close(index);
        });
    }

    /**删除账单**/
    function delBill(companyId,billMonth) {
        var arr = {
            companyId : companyId,
            billMonth : billMonth
        };
        layer.confirm("此操作不可逆！请谨慎操作！是否删除账单？", {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/delBill", arr, function (result) {
                dataTable.ajax.reload();
                layer.msg("删除成功");
            });
            layer.close(index);
        });
    }

    /**账单明细**/
    function allDetail (companyId, billMonth) {
        var index = layer.open({
            type: 2,
            title: '账单明细',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/allDetail?companyId=" + companyId + "&billMonth=" + billMonth
        });
        layer.full(index);
    }

    /**发送账单**/
    function sendTheBill(companyId, billMonth) {

        var companyIdAndBillMonth = [{companyId : companyId , billMonth : billMonth}];

        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var url = "http://" + window.location.host + "/web/page/h5/allDetail";
        AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/batchSendSonBill", {companyIdAndBillMonth : JSON.stringify(companyIdAndBillMonth), url : url}, function (result) {
            layer.msg("发送账单成功.");
        });
        layer.close(index);
    }

    /**一键发送**/
    function allSend() {
        var index = layer.load(1, {shade: [0.1, '#fff']});
        var url = "http://" + window.location.host + "/web/page/h5/allDetail";
        var arr = {
            url : url,
            companyName : $("#companyName").val(),
            companySonBillId : AM.getUrlParam("companySonBillId"),
            beforeService : $("#beforeService").val(),
            hexiao : $("#hexiao").val(),
            jihe : $("#jihe").val(),
            status : $("#status").val(),
            billMonthStamp : '' == $("#billMonthSelect").val() ? null : new Date($("#billMonthSelect").val()).getTime(),
            source : 1
        };
        AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/batchSendSonBill", arr, function (result) {
            layer.msg("一键发送账单成功.");
            dataTable.ajax.reload();
        });
        layer.close(index);
    }

    /**批量发送**/
    function batchSend() {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var companySonTotalBillIds = [];
        $("input[name=companySonBillItem]:checked").each(function () {
            companySonTotalBillIds.push({
                companyId : $(this).val(),
                billMonth : $(this).attr("billMonth")
            });
        });
        if (companySonTotalBillIds.length == 0) {
            layer.msg("请选择要发送的账单");
            layer.close(index);
            return false;
        }

        AM.log(companySonTotalBillIds);
        var url = "http://" + window.location.host + "/web/page/h5/allDetail";
        var arr = {
            companyIdAndBillMonth : JSON.stringify(companySonTotalBillIds),
            url : url,
            source : 0
        };
        AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/batchSendSonBill", arr, function (result) {
            layer.msg("批量发送账单成功.");
            dataTable.ajax.reload();
        });
        layer.close(index);
    }

    /**子类账单**/
    function companySonBillItem(id) {
        var index = layer.open({
            type: 2,
            title: '子类账单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companySonBillItem/list?companySonTotalBillId=" + id
        });
        layer.full(index);
    }

    /**稽核列表**/
    function auditList() {
        var index = layer.open({
            type: 2,
            title: '稽核列表',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companySonBillItem/auditList"
        });
        layer.full(index);
    }

    /**一键生成**/
    function aKeyGeneration() {
        var index = layer.open({
            type: 2,
            title: '生成账单',
            shadeClose: false,
            area: ['800px', '600px'],
            content: AM.ip + "/page/companySonBillItem/generateList"
        });
        //layer.full(index);
    }

    /**导入工资**/
    function toLeadSalary() {
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择公司</label>' +
                '           <div class="layui-input-block">' +
                '               <select id="companyId" lay-search>' +
                '                   <option value="">选择或者搜索</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['确认','取消'],
            title: "导入工资",
            area: ["500px", "300px"],
        }, function () {
            if ($("#companyId").val() == "") {
                layer.msg("请选择公司");
                return false;
            }
            $("#File").click();
        }, function () {});
        queryAllCompany(0, "companyId", null, 0);
        form.render();

    }

    function onChangeFile (obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
        var fr = new FileReader();
        if(window.FileReader) {
            fr.onloadend = function(e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: AM.ip + '/res/upload',
                    success: function(result) {
                        AM.log(result);
                        if (result.code == 200) {
                            $('#File').val("");
                            layer.close(index);
                            AM.ajaxRequestData("post", false, AM.ip + "/member/importSalaryMember", {
                                companyId : $("#companyId").val(),
                                url : AM.ip + "/" +result.data.url
                            }, function (result) {
                                layer.alert(result.msg);
                            });
                            $.ajax({
                                type: "POST",
                                url: AM.ip + "/res/delete",
                                data: { url : result.data.url },
                                success: function () {AM.log("delete.");}
                            });
                        } else {
                            layer.close(index);
                            $('#File').val("");
                            layer.alert(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;


        getUserByRole(0,"beforeService",0,9);
        form.on('checkbox(allSelected)', function (data) {
            if (data.elem.checked) {
                $("input[name=companySonBillItem]").prop("checked", true);
            }
            else {
                $("input[name=companySonBillItem]").prop("checked", false);
            }
            form.render();
        });
    });




</script>
</body>
</head>
</html>
