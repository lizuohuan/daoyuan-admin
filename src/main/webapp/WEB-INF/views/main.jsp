<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <!--引入抽取css文件-->
    <%@include file="common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/main.css" />

    <style>
        .main-row{overflow: hidden}
        .col-xs-6{
            float: left;
            width: 50%;
            box-sizing: border-box;
        }
        .border{border: 1px solid #e1e1e1;}
        .title{padding: 10px 15px;background: #F1F1F1;border-bottom: 1px solid #e1e1e1;font-size: 16px;font-weight: bold;color: #999;}
        .list{padding: 0 15px; padding-left: 115px;list-style: none outside none;height: 199px;overflow: hidden}
        .list li{border-bottom: 1px solid #e1e1e1;height: 40px;line-height: 40px;box-sizing: border-box;}
        .list li:last-child{border: none;}
        .list li a{color: #666;}
        .list li a:hover{color: #1E9FFF;text-decoration: underline}
        .statistics{position: absolute;width: 80px;height: 80px;background: #1E9FFF;color: #FFF;font-size: 20px;border-radius: 50%;text-align: center;line-height: 80px;
            top: 50px;left: 15px;
        }
        .div-list{position: relative;}

        .layui-col-xs9{
            width: 75%;
            float: left;
        }
        .layui-col-xs3{
            width: 25%;
            float: left;
        }
        .record{
            padding: 15px;
            overflow: hidden;
            border: 1px solid #eee;
            box-sizing: border-box;
        }
        .record-table{
            width: 100%;
        }
        .record-table td{
            padding: 15px 0;
            font-size: 14px;
            text-align: left;
            width: 50%;
        }
    </style>
</head>
<body>
<div class="admin-main">
    <%--<blockquote class="layui-elem-quote">--%>
        <%--<div class="widget">--%>
            <%--<div class="row" id="rowDiv">--%>
                <%--<div class="col-xs-12 weather">--%>
                    <%--<iframe allowtransparency="true"--%>
                            <%--frameborder="0" width="575"--%>
                            <%--height="96" scrolling="no"--%>
                            <%--src="//tianqi.2345.com/plugin/widget/index.htm?s=2&z=1&t=0&v=0&d=5&bd=0&k=000000&f=000000&q=1&e=1&a=1&c=54511&w=575&h=96&align=center"></iframe>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</blockquote>--%>

    <div class="main-row">
        <div class="col-xs-6" style="padding-right: 7.5px;">
            <div class="border">
                <div class="title">待办事项 <i class="layui-icon" style="font-size: 24px; color: #666;">&#xe642;</i></div>
                <div class="div-list">
                    <div class="statistics" id="backlogCount">0</div>
                    <ul class="list slide-list">
                        <li id="backlog"><a href="javascript:setUrlBacklog('/page/inform/list2')">更多···</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-xs-6" style="padding-left: 7.5px;">
            <div class="border">
                <div class="title">通知 <i class="layui-icon" style="font-size: 24px; color: #666;">&#xe645;</i></div>
                <div class="div-list">
                    <div class="statistics" id="inFromCount">0</div>
                    <ul class="list slide-list2">
                        <li id="inFrom"><a href="javascript:setUrlInform('/page/inform/list')">更多···</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <fieldset class="layui-elem-field" style="margin-top: 15px;padding-bottom: 15px;">
        <legend>工作台列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <button onclick="batchSend()" style="margin-bottom: 15px;" class="layui-btn layui-btn layui-btn-small layui-btn-normal">批量发送总结</button>
            <div class="layui-row">
                <div class="layui-col-xs9">
                    <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                        <thead>
                        <tr>
                            <th><input type="checkbox" name="allSelected" lay-skin="primary" lay-filter="allSelected"></th>
                            <th>公司名</th>
                            <th>客服</th>
                            <th>应收总额</th>
                            <th>服务费</th>
                            <th>当前状态</th>
                            <th>账单年月</th>
                            <%--<th>是否可稽核</th>--%>
                            <th>发送总结</th>
                        </tr>
                        </thead>
                    </table>
                </div>
                <div class="layui-col-xs3" style="padding-left: 15px;box-sizing: border-box;">
                    <div class="record">
                        <table class="record-table">
                            <tr>
                                <td>服务人数</td>
                                <td id="personNumber">0</td>
                            </tr>
                            <tr>
                                <td>服务公司数</td>
                                <td id="companyNumber">0</td>
                            </tr>
                            <tr>
                                <td>本月新增人数</td>
                                <td id="addNumber">0</td>
                            </tr>
                            <tr>
                                <td>本月减少人数</td>
                                <td id="minusNumber">0</td>
                            </tr>
                            <tr>
                                <td>新增公司数</td>
                                <td id="addCompanyNumber">0</td>
                            </tr>
                            <tr>
                                <td>终止公司数</td>
                                <td id="minusCompanyNumber">0</td>
                            </tr>
                            <tr>
                                <td>未确认账单公司</td>
                                <td id="notBillNumber">0</td>
                            </tr>
                            <tr>
                                <td>未完成核销公司</td>
                                <td id="notFulfillNumber">0</td>
                            </tr>
                            <tr>
                                <td>当月核销率</td>
                                <td id="monthNumber">0</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </fieldset>


</div>

<!--引入抽取公共js-->
<%@include file="common/public-js.jsp" %>
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
                url: AM.ip + "/console/listDto",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.serviceType = $("#serviceType").val();
                }
            },
            "columns":[
                {"data": ""},
                {"data": "companyName"},
                {"data": "userName"},
                {"data": "amount"},
                {"data": "serviceFee"},
                {"data": "cstbStatus"},
                {"data": "billMonth"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (row.isSend == 0) {
                            return '<input type="checkbox" value="' + row.id + '" name="isClick" lay-skin="primary" billMonth="' + row.billMonth + '">';
                        }
                        else {
                            return '<input type="checkbox" disabled lay-skin="primary">';
                        }
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        var msg = "";
                        if (data == 0) {
                            msg = "账单-待确认";
                        }
                        else if (data == 1) {
                            msg = "账单-已确认";
                            if (row.isFirstBill == 0) {
                                if (row.isConfirmFund == 0) {
                                    msg = "到款核销-待到款";
                                }
                                else if (row.isConfirmFund == 1){
                                    msg = "到款核销-已核销";
                                }
                            }
                            else {
                                if (row.isMakeBill == 0) {
                                    msg = "票据-未开票";
                                }
                                else if (row.isMakeBill == 1){
                                    msg = "票据-已开票";
                                }
                            }

                            if (row.isConsignee == 0) {
                                msg = "票据-待收件";
                            }
                            else if (row.isConsignee == 1){
                                msg = "票据-已到件";
                            }

                            if (row.realDoStatus == 0) {
                                msg = "实做-待反馈";
                            }
                            else if (row.realDoStatus == 1){
                                msg = "实做-已完成";
                            }

                            if (row.isSend == 0) {
                                msg = "总结-待发送";
                            }
                            else if (row.isSend == 1){
                                msg = "总结-已发送";
                            }

                            if (row.auditStatus == 0) {
                                msg = "稽核-缺拷盘";
                            }
                            else if (row.auditStatus == 1){
                                msg = "稽核-待稽核";
                            }
                            else if (row.auditStatus == 2){
                                msg = "稽核-已完成";
                            }


                        }

                        return msg;
                    },
                    "targets": 5
                }, {
                    "render": function (data, type, row) {
                        return  new Date(data).format("yyyy-MM");
                    },
                    "targets": 6
                }, {
                    "render": function (data, type, row) {
                        // alert("稽核状态："+row.auditStatus +
                        //     " 核销状态：" + row.cancelAfterVerificationStatus +
                        //     " 票据状态：" + row.isConsignee +
                        //     " 实做状态：" + row.realDoStatus)
                        var btn = "";
                        if (row.auditStatus == 2 && row.cancelAfterVerificationStatus == 1 && row.isConsignee == 1 && row.realDoStatus == 1) {
                            btn += "<button onclick='findSchedule(" + row.companyId + ", " + row.billMonth + ")' class='layui-btn layui-btn-small layui-btn-normal'>发送总结</button>";
                        }
                        else {
                            btn += "<button class='layui-btn layui-btn-small layui-btn-disabled'>发送总结</button>";
                        }
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

    layui.use(['form'], function () {
        form = layui.form();

        form.on('checkbox(allSelected)', function (data) {
            if (data.elem.checked) {
                $("input[name=isClick]").prop("checked", true);
            }
            else {
                $("input[name=isClick]").prop("checked", false);
            }
            form.render();
        });

        form.render();
    });

    /**发送总结**/
    function findSchedule (id, date) {
        var ids = [{
            id: id,
            billMonth: new Date(date).getTime()
        }];
        AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/updateConsigneeList", {companyConsigneeJsonAry : JSON.stringify(ids)}, function (result) {
            layer.msg("发送总结成功.");
            dataTable.ajax.reload();
        });
    }

    /**批量发送**/
    function batchSend () {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var ids = [];
        $("input[name=isClick]:checked").each(function () {
            ids.push({
                id: $(this).val(),
                billMonth: new Date($(this).attr("billMonth")).getTime()
            });
        });
        if (ids.length == 0) {
            layer.msg("请选择");
            layer.close(index);
            return false;
        }
        AM.ajaxRequestData("post", false, AM.ip + "/companySonTotalBill/updateConsigneeList", {companyConsigneeJsonAry : JSON.stringify(ids)}, function (result) {
            layer.msg("批量发送总结成功.");
            dataTable.ajax.reload();
        });
        layer.close(index);
    }


    function initData () {
        /**获取待办事项**/
        AM.ajaxRequestData("GET", false, AM.ip + "/backlog/list", {pageNo: 1, pageSize: 4}, function (result) {
            $("#backlogCount").html(result.recordsTotal);
            var html = "";
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                html += "<li><a href=\"javascript:setUrlBacklog('" + obj.url + "')\">" + obj.content + "</a></li>";
            }
            $("#backlog").before(html);
        })
        /**获取通知**/
        AM.ajaxRequestData("GET", false, AM.ip + "/inform/list", {pageNo: 1, pageSize: 4}, function (result) {
            $("#inFromCount").html(result.recordsTotal);
            var html = "";
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                html += "<li><a>" + obj.content + "</a></li>";
            }
            $("#inFrom").before(html);
        })
        /**获取右下角统计**/
        AM.ajaxRequestData("GET", false, AM.ip + "/console/rightConsole", {}, function (result) {
            $("#personNumber").html(result.data.memberNum);
            $("#companyNumber").html(result.data.companyNum);
            $("#addNumber").html(result.data.addMemberNum + "&nbsp;<i class='fa fa-arrow-up' style='color: #2ac845'></i>");
            $("#minusNumber").html(result.data.delMemberNum + "&nbsp;<i class='fa fa-arrow-down' style='color: red'></i>");
            $("#addCompanyNumber").html(result.data.addCompanyNum);
            $("#minusCompanyNumber").html(result.data.delCompanyNum);
            $("#notBillNumber").html(result.data.unconfirmedBillCompanyNum);
            $("#notFulfillNumber").html(result.data.unCancelAfterVerificationCompanyNum);
            $("#monthNumber").html(result.data.cancelAfterVerificationForNewMonthRate + "%");
        })
    }

    initData();

    function setUrlBacklog (url) {
        layer.full(layer.open({
            type: 2,
            title: '待办事项',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + url
        }));
    }

    function setUrlInform (url) {
        layer.full(layer.open({
            type: 2,
            title: '通知',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + url
        }));
    }


    /**无缝滚动**/
    var doscroll = function(){
        var $parent = $('.slide-list');
        var $first = $parent.find('li:first');
        var height = $first.height() + 1;
        $first.animate({
            marginTop: -height + 'px'
        }, 500, function() {
            $first.css('marginTop', 0).appendTo($parent);
        });

        var $parent2 = $('.slide-list2');
        var $first2 = $parent2.find('li:first');
        var height2 = $first.height() + 1;
        $first2.animate({
            marginTop: -height2 + 'px'
        }, 500, function() {
            $first2.css('marginTop', 0).appendTo($parent2);
        });
    };
    //setInterval(function(){doscroll()}, 2000);



</script>
</body>
</html>
