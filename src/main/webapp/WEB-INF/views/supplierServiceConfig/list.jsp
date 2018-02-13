<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>缴金地列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .aa{
            text-decoration: underline !important;
            color: #1E9FFF;
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
                            <label class="layui-form-label">类型</label>
                            <div class="layui-input-inline">
                                <select id="type">
                                    <option value="">请选择</option>
                                    <option value="0">社保</option>
                                    <option value="1">公积金</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">选择地区</label>
                        <div class="layui-input-inline">
                            <select id="provinceId" name="province" lay-search lay-filter="province">
                                <option value="">请选择或搜索省</option>
                            </select>
                        </div>
                        <div class="layui-input-inline">
                            <select id="city" name="city" lay-search lay-filter="city">
                                <option value="">请选择或搜索市</option>
                            </select>
                        </div>
                    </div>

                    <input type="hidden" id="cityId">

                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn" id="search"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            <button type="reset" class="layui-btn layui-btn-primary" onclick="$('#cityId').val('')">清空</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field">
        <legend>缴金地列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_89"><i
                        class="layui-icon">
                    &#xe608;</i> 添加缴金地
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>缴金地</th>
                    <th>类型</th>
                    <th>年度调基月份</th>
                    <th>操作方式</th>
                    <th>最晚实做日期</th>
                    <th>提醒日期</th>
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
                url: AM.ip + "/payPlace/getPayPlace",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.cityId = $("#cityId").val();
                    data.type = $("#type").val();
                }
            },
            "columns":[
                {"data": "city.mergerName"},
                {"data": "type"},
                {"data": "yearAlterMonth"},
                {"data": "operationType"},
                {"data": "inTheEndTime"},
                {"data": "remindTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return "<a class='aa' href='javascript:findDetail(" + row.cityId + ")'>" + data + "</a>";
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        return data == 0 ? "社保" : "公积金";
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if (row.type == 1 && data != null) {
                            return data + "月份";
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        if (row.type == 0) {
                            if (data == 0) {
                                return "本月";
                            }
                            else if (data == 1) {
                                return "次月";
                            }
                            else if (data == 2) {
                                return "上月";
                            }
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        if (data != null) {
                            return data + "日";
                        }
                        return "--";
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        if (data != null) {
                            return data + "日24点";
                        }
                        return "--";
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        var obj = JSON.stringify(row);
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_90'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        if (row.type == 0) {
                            btn += "<button onclick='findInsurance(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_91'><i class='fa fa-list fa-edit'></i>&nbsp;配置险种</button>";
                            btn += '<button onclick=\'findOrganization(' + row.id + ', "' + row.city.mergerName + '")\' class="layui-btn layui-btn-small hide checkBtn_92"><i class="fa fa-list fa-edit"></i>&nbsp;查看经办机构</button>';
                            btn += "<button onclick='insuranceLevel(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_93'><i class='fa fa-list fa-edit'></i>&nbsp;档次配置</button>";
                        }
                        else {
                            btn += '<button onclick=\'findOrganization2(' + row.id + ', "' + row.city.mergerName + '")\' class="layui-btn layui-btn-small hide checkBtn_92"><i class="fa fa-list fa-edit"></i>&nbsp;查看经办机构</button>';
                        }
                        return  btn;
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

    /**查看详情**/
    function findDetail (cityId) {
        var index = layer.open({
            type: 2,
            title: '查看详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/detail?cityId=" + cityId
        });
        layer.full(index);
    }

    /**配置险种**/
    function findInsurance (id) {
        var index = layer.open({
            type: 2,
            title: '配置险种',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insurance/list?payPlaceId=" + id
        });
        layer.full(index);
    }

    /**查看经办机构**/
    function findOrganization (id, mergerName) {
        sessionStorage.setItem("mergerName", mergerName);
        var index = layer.open({
            type: 2,
            title: '查看经办机构',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/organization/list?payPlaceId=" + id
        });
        layer.full(index);
    }
    /**查看经办机构**/
    function findOrganization2 (id, mergerName) {
        sessionStorage.setItem("mergerName", mergerName);
        var index = layer.open({
            type: 2,
            title: '查看经办机构',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/organization2/list?payPlaceId=" + id
        });
        layer.full(index);
    }
    /**档次配置**/
    function insuranceLevel (id) {
        var index = layer.open({
            type: 2,
            title: '档次配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/insuranceLevel2/list?payPlaceId=" + id
        });
        layer.full(index);
    }

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加缴金地',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/add"
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改缴金地',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierServiceConfig/edit?id=" + id
        });
        layer.full(index);
    }

    layui.use(['form'], function () {
        form = layui.form();
        selectProvince(0); //默认调用省
        //监听省
        form.on('select(province)', function(data) {
            $("select[name='district']").html("<option value=\"\">请选择或搜索县/区</option>");
            $("#cityId").val(data.value);
            selectCity(data.value);
            form.render();
        });

        //监听市
        form.on('select(city)', function(data) {
            $("#cityId").val(data.value);
            form.render();
        });
    });

</script>
</body>
</head>
</html>
