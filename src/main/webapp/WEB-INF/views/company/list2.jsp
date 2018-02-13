<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>客户列表</title>

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
                            <label class="layui-form-label">客户名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="companyName" lay-verify="" placeholder="请输入客户名称"
                                       autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">客户/财务编号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="serialNumber" lay-verify="" placeholder="请输入客户编号"
                                       autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">合作状态</label>
                            <div class="layui-input-inline">
                                <select name="cooperationStatus" id="cooperationStatus" lay-verify="required" lay-search>
                                    <option value="">请选择合作状态</option>
                                    <option value="1">合作中</option>
                                    <option value="0">空户/终止</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">客服</label>
                            <div class="layui-input-inline">
                                <select name="beforeService" id="beforeService" lay-verify="required" lay-search>
                                    <option value="">请选择前道客服</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">销售</label>
                            <div class="layui-input-inline">
                                <select name="sales" id="sales" lay-verify="required" lay-search>
                                    <option value="">请选择销售</option>
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
        <legend>客户列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>客户编号</th>
                    <th>客户名称</th>
                    <th width="500">操作</th>
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
                url: AM.ip + "/company/getCompanyList2",
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
                    data.companyName = $("#companyName").val();
                    data.serialNumber = $("#serialNumber").val();
                    data.cooperationStatus = $("#cooperationStatus").val();
                    data.beforeService = $("#beforeService").val();
                    data.sales = $("#sales").val();
                }
            },
            "columns": [
                {"data": "serialNumber"},
                {"data": "companyName"},
            ],
            "columnDefs": [
                {
                    "render": function (data, type, row) {
                        var btn = "";

                        return "<button onclick='updateData2(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_164'>重置密码</button>"
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



    //重置密码
    function updateData2(id) {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var arr = {
            id: id,
            pwd: $.md5("111111"),
        }
        AM.ajaxRequestData("post", false, AM.ip + "/company/update", arr, function (result) {
            if (result.flag == 0 && result.code == 200) {
                dataTable.ajax.reload();
                layer.close(index);
            }
        });
    }



    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        // 初始化客服
        getUserByRole(0,"beforeService",0,9);
        getUserByRole(0,"sales",0,13);

        form.on("switch(isShow)", function (data) {
            console.log(data);
            var bannerId = $(this).attr("bannerId");
            if (data.elem.checked) {
                updateStatus(bannerId, 1);
            }
            else {
                updateStatus(bannerId, 0);
            }
            form.render();
        });

        var validityStartTimes = {
            max: '2099-06-16 23:59:59'
            , format: 'YYYY-MM-DD hh:mm:ss'
            , istoday: false
            , choose: function (datas) {
                validityEndTimes.min = datas; //开始日选好后，重置结束日的最小日期
                validityEndTimes.start = datas //将结束日的初始值设定为开始日
            }
        };

        var validityEndTimes = {
            max: '2099-06-16 23:59:59'
            , format: 'YYYY-MM-DD hh:mm:ss'
            , istoday: false
            , choose: function (datas) {
                validityStartTimes.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };

        document.getElementById('validityStartTimes').onclick = function () {
            validityStartTimes.elem = this;
            laydate(validityStartTimes);
        }
        document.getElementById('validityEndTimes').onclick = function () {
            validityEndTimes.elem = this
            laydate(validityEndTimes);
        }

        var start = {
            max: '2099-06-16 23:59:59'
            , format: 'YYYY-MM-DD hh:mm:ss'
            , istoday: false
            , choose: function (datas) {
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };

        var end = {
            max: '2099-06-16 23:59:59'
            , format: 'YYYY-MM-DD hh:mm:ss'
            , istoday: false
            , choose: function (datas) {
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };

        document.getElementById('startTimes').onclick = function () {
            start.elem = this;
            laydate(start);
        }
        document.getElementById('endTimes').onclick = function () {
            end.elem = this
            laydate(end);
        }
    });

</script>
</body>
</html>
