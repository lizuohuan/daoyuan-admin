<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>实做子类列表</title>
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
                        <%--<div class="layui-inline">--%>
                            <%--<label class="layui-form-label">选择公司</label>--%>
                            <%--<div class="layui-input-inline">--%>
                                <%--<select id="companyId">--%>
                                    <%--<option value="">请选择</option>--%>
                                <%--</select>--%>
                            <%--</div>--%>
                        <%--</div>--%>
                        <%--<div class="layui-inline">--%>
                            <%--<label class="layui-form-label">员工名称</label>--%>
                            <%--<div class="layui-input-inline">--%>
                                <%--<input type="text" class="layui-input" placeholder="请输入员工名称" id="mUserName">--%>
                            <%--</div>--%>
                        <%--</div>--%>
                        <%--<div class="layui-inline">--%>
                            <%--<label class="layui-form-label">员工证件编号</label>--%>
                            <%--<div class="layui-input-inline">--%>
                                <%--<input type="text" class="layui-input" placeholder="请输入员工证件编号" id="certificateNum">--%>
                            <%--</div>--%>
                        <%--</div>--%>
                        <%--<div class="layui-inline">--%>
                            <%--<label class="layui-form-label">客服名称</label>--%>
                            <%--<div class="layui-input-inline">--%>
                                <%--<input type="text" class="layui-input" placeholder="请输入客服名称" id="uUserName">--%>
                            <%--</div>--%>
                        <%--</div>--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择缴金地</label>
                            <div class="layui-input-inline">
                                <select id="payPlaceId" lay-filter="payPlaceFilter">
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择经办机构</label>
                            <div class="layui-input-inline">
                                <select id="organizationId" lay-filter="organizationFilter">
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择办理方</label>
                            <div class="layui-input-inline">
                                <select id="transactorId">
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">增减变类型</label>
                            <div class="layui-input-inline">
                                <select id="serviceStatus">
                                    <option value="">请选择</option>
                                    <option value="0">增员</option>
                                    <option value="1">减员</option>
                                    <option value="2">变更</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select id="status">
                                    <%--0：待申请 1：待反馈  2：成功  3: 失败 4: 失效--%>
                                    <option value="">请选择</option>
                                    <option value="0">待申请</option>
                                    <option value="1">待反馈</option>
                                    <option value="2">成功</option>
                                    <option value="3">失败</option>
                                    <option value="4">失效</option>
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
        <legend>实做子类列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>缴金地</th>
                    <th>经办机构</th>
                    <th>办理方</th>
                    <th>档次</th>
                    <th>服务时间</th>
                    <th>创建时间</th>
                    <th>增减变类型</th>
                    <th>状态</th>
                    <th>基数</th>
                    <th>办理人</th>
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
                url: AM.ip + "/memberBusinessUpdateRecordItem/list",
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
                    data.memberBusinessUpdateRecordId = AM.getUrlParam("memberBusinessUpdateRecordId");
                    data.certificateNum = $("#certificateNum").val();
                    data.payPlaceId = $("#payPlaceId").val();
                    data.organizationId = $("#organizationId").val();
                    data.transactorId = $("#transactorId").val();
                    data.serviceStatus = $("#serviceStatus").val();
                    data.status = $("#status").val();
                }
            },
            "columns":[
                {"data": "payPlaceName"},
                {"data": "organizationName"},
                {"data": "transactorName"},
                {"data": "insuranceLevelName"},
                {"data": "serviceMonth"},
                {"data": "createTime"},
                {"data": "serviceStatus"},
                {"data": "status"},
                {"data": "baseNumber"},
                {"data": "createUserName"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return null == data ? "--" : new Date(data).format("yyyy-MM");
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        return null == data ? "--" : new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "增员";
                        }
                        else if (data == 1) {
                            return "减员";
                        }
                        else if (data == 2) {
                            return "变更";
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        <%--0：待申请 1：待反馈  2：成功  3: 失败 4: 失效--%>
                        if (data == 0) {
                            return "待申请";
                        }
                        else if (data == 1) {
                            return "待反馈";
                        }
                        else if (data == 2) {
                            return "成功";
                        }
                        else if (data == 3) {
                            return "失败";
                        }
                        else if (data == 4) {
                            return "失效";
                        }
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if(row.status == 1){
                            btn += "<button onclick='feedback(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_174'>反馈实做</button>";
                        }
                        btn += "<button onclick='findDetail(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_120'>查看详情</button>";
                        return  btn;
                    },
                    "targets":10
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

    //查看详情
    function findDetail(id) {
        var index = layer.open({
            type: 2,
            title: '查看详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/memberBusinessItem/detail?id=" + id
        });
        layer.full(index);
    }

    function feedback(id){

        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">处理结果</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="status" value="2" title="成功" checked lay-filter="status">' +
                '               <input type="radio" name="status" value="3" title="失败" lay-filter="status">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">备注</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="text" name="remark"  id="remark"  placeholder="请输入" autocomplete="off" class="layui-input" maxlength="100">'+
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item layui-hide" id="reasonDiv">' +
                '           <label class="layui-form-label">失败原因</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="text" name="reason"  id="reason"  placeholder="请输入" autocomplete="off" class="layui-input" maxlength="100">'+
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['确定','取消'],
            title: "反馈记录",
            area: ["800px", "500px"],
        }, function () {

            var status = $("input[name='status']:checked").val();
            var arr = {
                status : status,
                remark : $("#remark").val(),
                reason : $("#reason").val(),
                id : id
            }
            AM.ajaxRequestData("post", false, AM.ip + "/memberBusinessUpdateRecordItem/feedback", arr, function (result) {
                if (result.code == 200) {
                    layer.msg("操作成功.");
                    dataTable.ajax.reload();
                }
                else{
                    layer.msg("操作失败.");
                    dataTable.ajax.reload();
                }
            });

        }, function () {});
        form.render();
    }


    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

//        queryAllCompany(0, "companyId", null, 0);
        queryAllPayPlace(0, "payPlaceId", "post", 0);
        form.render();

        //监听缴金地
        form.on('select(payPlaceFilter)', function (data) {
            getOrganizationByPayPlace(0, "organizationId", "post", 0, data.value);
            form.render();
        });

        //监听经办机构
        form.on('select(organizationFilter)', function (data) {
            getTransactorByOrganization(0, "transactorId", "post", null, data.value);
            form.render();
        });

        form.on('radio(status)', function (data) {
            if(data.value == 3){
                $("#reasonDiv").show("fast");
            }
            else{
                $("#reasonDiv").hide("fast");
            }
            form.render();
        });
    });




</script>
</body>
</head>
</html>
