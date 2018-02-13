<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>稽核列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>

<body>

<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
    <ul class="layui-tab-title">
        <li class="layui-this">社保</li>
        <li>公积金</li>
    </ul>
    <div class="layui-tab-content">
        <div class="layui-tab-item layui-show">

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
                                            <select id="companyId" lay-verify="required" lay-search="">
                                                <option value="">请选择</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label">服务月</label>
                                        <div class="layui-input-inline">
                                            <input type="text" id="serviceMonth" onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})"
                                                   placeholder="服务月" autocomplete="off" class="layui-input" maxlength="20" readonly>
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
                    <legend>稽核社保列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
                    </legend>
                    <div class="layui-field-box layui-form">
                        <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th>身份证</th>
                                    <th>姓名</th>
                                    <th>公司</th>
                                    <th>服务月</th>
                                    <th>缴金地-经办机构</th>
                                    <th>办理方</th>
                                    <th>档次</th>
                                    <th>基数</th>
                                    <th>社保明细</th>
                                    <th>处理方案</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </fieldset>
            </div>

        </div>
        <div class="layui-tab-item">

            <div class="admin-main">
                <blockquote class="layui-elem-quote">
                    <fieldset class="layui-elem-field">
                        <legend>高级筛选</legend>
                        <div class="layui-field-box layui-form">
                            <form class="layui-form" action="" id="formData2">
                                <div class="layui-form-item">
                                    <div class="layui-inline">
                                        <label class="layui-form-label">选择公司</label>
                                        <div class="layui-input-inline">
                                            <select id="companyId2" lay-verify="required" lay-search="">
                                                <option value="">请选择</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="layui-inline">
                                        <label class="layui-form-label">服务月</label>
                                        <div class="layui-input-inline">
                                            <input type="text" id="serviceMonth2" onfocus="WdatePicker({dateFmt:'yyyyMM',readOnly:true})"
                                                   placeholder="服务月" autocomplete="off" class="layui-input" maxlength="20" readonly>
                                        </div>
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-input-block">
                                        <button class="layui-btn" id="search2"><i class="layui-icon">&#xe615;</i> 搜索</button>
                                        <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </fieldset>
                </blockquote>

                <fieldset class="layui-elem-field">
                    <legend>稽核公积金列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
                    </legend>
                    <div class="layui-field-box layui-form">
                        <table id="dataTable2" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th>身份证</th>
                                    <th>姓名</th>
                                    <th>公司</th>
                                    <th>服务月</th>
                                    <th>缴金地-经办机构</th>
                                    <th>办理方</th>
                                    <th>基数</th>
                                    <th>公积金明细</th>
                                    <th>处理方案</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </fieldset>
            </div>

        </div>
    </div>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var form = null;
    var dataTable = null;
    var dataTable2 = null;
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
                url: AM.ip + "/socialSecurityInfo/auditList",
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
                    data.serviceNowYM = $("#serviceMonth").val();
                }
            },
            "columns":[
                {"data": "idCard"},
                {"data": "userName"},
                {"data": "companyName"},
                {"data": "serviceNowYM"},
                {"data": "payPlaceOrganizationName"},
                {"data": "transactorName"},
                {"data": "insuranceLevelName"},
                {"data": "payCardinalNumber"},
                {"data": ""},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM");
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        var html = "公司</br>";
                        var ssis = row.socialSecurityInfoItems;
                        for (var i = 0 ; i < ssis.length ; i ++) {
                            if (ssis[i].type == 0 && (ssis[i].payPrice != 0 || ssis[i].practicalPayPrice != 0)) {
                                if ( ssis[i].payPrice != ssis[i].practicalPayPrice) {
                                    html+= ssis[i].insuranceName + "  应缴：" + ssis[i].payPrice + "  实缴：" + ssis[i].practicalPayPrice + "  差额：" + ssis[i].auditDifference + "</br>";
                                }
                            }
                        }
                        var html2 = "个人</br>";
                        for (var i = 0 ; i < ssis.length ; i ++) {
                            if (ssis[i].type == 1 && (ssis[i].payPrice != 0 || ssis[i].practicalPayPrice != 0)) {
                                if ( ssis[i].payPrice != ssis[i].practicalPayPrice) {
                                    html2+= ssis[i].insuranceName + "  应缴：" + ssis[i].payPrice + "  实缴：" + ssis[i].practicalPayPrice + "  差额：" + ssis[i].auditDifference + "</br>";
                                }
                            }
                        }

                        return  html + html2;
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateProcessingSchemeS(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>纳入次月账单</button>";
                        btn += "<button onclick='updateProcessingSchemeS(" + row.id + ",2)' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>退回客户</button>";
                        return  btn;
                    },
                    "targets": 9
                },
            ]
        });

        $("#search").click(function () {
            dataTable.ajax.reload();
            return false;
        });

        dataTable2 = $('#dataTable2').DataTable({
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
                url: AM.ip + "/reservedFundsInfo/auditList",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyId = $("#companyId2").val();
                    data.serviceNowYM = $("#serviceMonth2").val()
                }
            },
            "columns":[
                {"data": "idCard"},
                {"data": "userName"},
                {"data": "companyName"},
                {"data": "serviceNowYM"},
                {"data": "payPlaceOrganizationName"},
                {"data": "transactorName"},
                {"data": "payCardinalNumber"},
                {"data": ""},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM");
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        var html = "公司应缴："+row.companyTotalPay + "</br>";
                        html += "公司实缴："+row.practicalCompanyTotalPay + "</br>";
                        html += "公司稽核差："+row.companyAuditDifference + "</br>";
                        html += "个人应缴："+row.memberTotalPay + "</br>";
                        html += "个人实缴："+row.practicalMemberTotalPay + "</br>"
                        html += "个人稽核差："+row.memberAuditDifference;
                        return html;
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateProcessingSchemeR(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn layui-btn-normal'>纳入次月账单</button>";
                        btn += "<button onclick='updateProcessingSchemeR(" + row.id + ",2)' class='layui-btn layui-btn-small layui-btn layui-btn-normal '>退回客户</button>";
                        return  btn;
                    },
                    "targets": 8
                },
            ]
        });

        $("#search2").click(function () {
            dataTable2.ajax.reload();
            return false;
        });

    });

    //更新社保处理方案
    var updateProcessingSchemeS = function(id, processingScheme) {
        var ary = {
            id : id,
            processingScheme : processingScheme
        }
        AM.ajaxRequestData("post", false, AM.ip + "/socialSecurityInfo/updateProcessingScheme", ary, function (result) {
            dataTable.ajax.reload();
            layer.msg("更新社保处理方案成功");
        });
    }

    //更新公积金处理方案
    var updateProcessingSchemeR = function(id, processingScheme) {
        var ary = {
            id : id,
            processingScheme : processingScheme
        }
        AM.ajaxRequestData("post", false, AM.ip + "/reservedFundsInfo/updateProcessingScheme", ary, function (result) {
            dataTable2.ajax.reload();
            layer.msg("更新公积金处理方案成功");
        });
    }


    /**确认账单**/
    function confirmTheBill(id) {
        layer.confirm("是否确认?", {
            title : "温馨提示"
        }, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/updateStatus", {companySonTotalBillId : id}, function (result) {
                dataTable.ajax.reload();
                layer.msg("确认账单成功");
            });
            layer.close(index);
        });
    }

    /**账单明细**/
    function allDetail (id, createTime) {
        var index = layer.open({
            type: 2,
            title: '账单明细',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/h5/allDetail?companySonTotalBillId=" + id + "&createTime=" + createTime
        });
        layer.full(index);
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        queryAllCompany(0, "companyId", null, 0);
        queryAllCompany(0, "companyId2", null, 0);
        form.render();
    });




</script>
</body>
</head>
</html>
