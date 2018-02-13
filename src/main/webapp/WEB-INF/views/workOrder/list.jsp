<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>工单列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>.blue{color: #00a0e9}</style>
<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">服务类型</label>
                            <div class="layui-input-inline">
                                <select id="serviceType">
                                    <option value="">请选择</option>
                                    <option value="0">社保特殊补缴</option>
                                    <option value="1">社保特殊减少</option>
                                    <option value="2">社保紧急制卡</option>
                                    <option value="3">当月参保类型修改</option>
                                    <option value="4">公积金退费</option>
                                    <option value="5">公积金特殊修改基数</option>
                                    <option value="6">公积金个人收入证明</option>
                                    <option value="7">自由流程</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">公司</label>
                            <div class="layui-input-inline">
                                <input type="text" id="companyName" placeholder="公司" autocomplete="off" class="layui-input" maxlength="100">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">员工</label>
                            <div class="layui-input-inline">
                                <input type="text" id="memberName" placeholder="员工" autocomplete="off" class="layui-input" maxlength="50">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">申请人</label>
                            <div class="layui-input-inline">
                                <input type="text" id="proposerName" placeholder="申请人" autocomplete="off" class="layui-input" maxlength="50">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">账单年月</label>
                            <div class="layui-input-inline">
                                <input class="layui-input"  placeholder="账单年月" onclick="layui.laydate({elem: this, festival: true,type:'month'})" id="billMonth" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select id="status">
                                    <option value="">请选择</option>
                                    <option value="0">待审批</option>
                                    <option value="1">同意</option>
                                    <option value="2">不同意</option>
                                    <option value="3">完成</option>
                                    <option value="4">作废</option>
                                    <option value="5">返回申请人确认</option>
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
        <legend>工单列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_144"><i
                        class="layui-icon">
                    &#xe608;</i> 添加工单
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>服务类型</th>
                    <th>服务名称</th>
                    <th>公司</th>
                    <th>员工</th>
                    <th>申请人</th>
                    <th>经办人</th>
                    <th>账单月</th>
                    <th>最晚处理时间</th>
                    <th>创建时间</th>
                    <th>备注</th>
                    <th>状态</th>
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
                url: AM.ip + "/workOrder/list",
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
                    data.companyName = $("#companyName").val();
                    data.memberName = $("#memberName").val();
                    data.proposerName = $("#proposerName").val();
                    data.status = $("#status").val();
                    data.billMonthStamp = '' == $("#billMonth").val() ? null : new Date($("#billMonth").val()).getTime();
                }
            },
            "columns":[
                {"data": "serviceType"},
                {"data": "serviceName"},
                {"data": "companyName"},
                {"data": "memberName"},
                {"data": "proposerName"},
                {"data": "userName"},
                {"data": "theBillingMonth"},
                {"data": "latestTime"},
                {"data": "createTime"},
                {"data": "remark"},
                {"data": "status"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        switch (data){
                            case 0: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>社保特殊补缴</a>"; break;
                            case 1: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>社保特殊减少</a>"; break;
                            case 2: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>社保紧急制卡</a>"; break;
                            case 3: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>当月参保类型修改</a>"; break;
                            case 4: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>公积金退费</a>"; break;
                            case 5: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>公积金特殊修改基数</a>"; break;
                            case 6: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>公积金个人收入证明</a>"; break;
                            case 7: return "<a class='blue' href='javascript: schedule(" + row.id + ")'>自由流程</a>"; break;
                        }
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return row.serviceType == 7 ? data : "--";
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        return data == null ? "--" : data;
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        return data == null ? "--" : data;
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        if (data == null) {
                            if (row.roleName == null) {
                                return "--";
                            }
                            else {
                                return row.roleName;
                            }
                        }
                        else {
                            return data;
                        }
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        if (data == null) {
                            return "--";
                        }
                        return new Date(data).format("yyyy-MM");
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        if (data == null) {
                            return "--";
                        }
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        switch (data){
                            case 0: return "<span style='color: green;'>处理中</span>"; break;
                            case 1: return "<span style='color: orange;'>已处理</span>"; break;
                            case 2: return "<span style='color: red;'>不同意</span>"; break;
                            case 3: return "<span>完成</span>"; break;
                            case 4: return "<span style='color: #666;'>作废</span>"; break;
                            case 5: return "<span style='color: #666;'>待确认</span>"; break;
                        }
                    },
                    "targets": 10
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        /**社保特殊补缴**/
                        /**社保特殊减少**/
                        /**当月参保类型修改**/
                        /**公积金退费**/
                        /**公积金特殊修改基数**/
                        if (row.serviceType == 0 || row.serviceType == 1 || row.serviceType == 3 || row.serviceType == 4 || row.serviceType == 5) {
                            //前道主管
                            if (AM.getUserInfo().roleId == 4 && row.roleId == 4 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //总经理
                            else if (AM.getUserInfo().roleId == 2 && row.roleId == 2 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //后道主管
                            else if (AM.getUserInfo().roleId == 14 && row.roleId == 14 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //前道客服
                            else if (AM.getUserInfo().roleId == 9 && row.status == 5) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            else {
                                btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                        }
                        /**社保紧急制卡**/
                        else if (row.serviceType == 2) {
                            //前道组长
                            if (AM.getUserInfo().roleId == 5 && row.roleId == 5 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //后道客服
                            else if (AM.getUserInfo().roleId == 10 && row.roleId == 10 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //前道客服
                            else if (AM.getUserInfo().roleId == 9 && row.status == 5) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            else {
                                btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                        }
                        /**公积金个人收入证明**/
                        else if (row.serviceType == 6) {
                            //前道组长
                            if (AM.getUserInfo().roleId == 5 && row.roleId == 5 && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            //前道客服
                            else if (AM.getUserInfo().roleId == 9 && row.status == 5) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            else {
                                btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                        }
                        /**自由流程**/
                        else if (row.serviceType == 7) {
                            if (AM.getUserInfo().id == row.userId && (row.status == 0 || row.status == 2 || row.status == 5)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            else if (AM.getUserInfo().roleId == row.roleId && row.userId == null && (row.status == 0 || row.status == 2)) {
                                btn += "<button onclick='audit(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                            else {
                                btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_148'><i class='fa fa-list fa-edit'></i>&nbsp;处理工单</button>";
                            }
                        }
                        return  btn;
                    },
                    "targets": 11
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
            title: '添加工单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/workOrder/add"
        });
        layer.full(index);
    }

    //修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改工单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/workOrder/edit?id=" + id
        });
        layer.full(index);
    }

    //处理工单
    function audit(id) {
        layer.full(layer.open({
            type: 2,
            title: '处理工单',
            shadeClose: true,
            area: ['100%', '100%'],
            content: AM.ip + "/page/workOrder/audit?id=" + id
        }));
    }

    /**工单进度**/
    function schedule (id) {
        layer.full(layer.open({
            type: 2,
            title: '工单进度',
            shadeClose: true,
            area: ['100%', '100%'],
            content: AM.ip + "/page/workOrder/schedule?id=" + id
        }));
    }

    /**无权限操作**/
    function lackOfCompetence () {
        layer.msg("您暂无权限操作");
        return false;
    }

    layui.use(['form'], function () {
        form = layui.form();
        //queryAllCompany(0, "companyId", null, 0);
        form.render();
    });

</script>
</body>
</head>
</html>
