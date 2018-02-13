<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>供应商列表</title>
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
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-inline">
                                <input type="text" name="supplierName" id="supplierName" lay-verify=""
                                       placeholder="供应商名字" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">票款顺序</label>
                            <div class="layui-input-inline">
                                <select name="drawABillOrder" id="drawABillOrder">
                                    <option value="">请选择</option>
                                    <option value="0">先票后款</option>
                                    <option value="1">先款后票</option>
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
        <legend>供应商列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_79"><i
                        class="layui-icon">
                    &#xe608;</i> 添加供应商
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>供应商名字</th>
                    <th>票款顺序</th>
                    <th>成本价</th>
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
                url: AM.ip + "/supplier/list",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        console.log("-------------")
                        console.log(json.data)
                        console.log("-------------")
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.supplierName = $("#supplierName").val();
                    data.drawABillOrder = $("#drawABillOrder").val();
                }
            },
            "columns":[
                {"data": "supplierName"},
                {"data": "drawABillOrder"},
                {"data": "serviceFeeConfigId"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (null != data) {
                            if (data == 0) {
                                return "先票后款";
                            }
                            if (data == 1) {
                                return "先款后票";
                            }
                        } else {
                            return "--";
                        }
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        if(null == data || data == ''){
                            return "--";
                        }
                        var str = row.serviceFeeConfigName +": ";
                        if(data == 1 || data == 5 || data == 6){
                            if(null != row.feeList && row.feeList.length > 0){
                                str += row.feeList[0].price+"、";
                            }
                        }
                        else if(data == 2 || data == 7){
                            for(var i = 0; i < row.feeList.length; i++){
                                if(i == 0){
                                    str += 0 + "-" + row.feeList[i].extent +":"+row.feeList[i].price + "、";
                                }else{
                                    str += row.feeList[i-1].extent + "-" + row.feeList[i].extent +":"+row.feeList[i].price+ "、";
                                }
                            }
                        }else if(data == 3){
                            if(row.serviceFeeList != null){
                                for(var i = 0; i < row.serviceFeeList.length; i++){
                                    var split = row.serviceFeeList[i].businessIds.split(",");
                                    var businessMsg = "";
                                    for(var j = 0; j < split.length; j++){
                                        businessMsg +=  getBusiness(Number(split[j]))+"+";
                                    }
                                    str += businessMsg.substring(0,businessMsg.length - 1) + ":" + row.serviceFeeList[i].price + "、";
                                }
                            }
                        }else  if(data == 4){
                            if(row.servicePayPlaceList != null){

                                for(var  i = 0; i < row.servicePayPlaceList.length; i++){
                                    str += row.servicePayPlaceList[i].cityName+":"+row.servicePayPlaceList[i].price+"、";
                                }
                            }
                        }

                        return str.substring(0,str.length - 1);;
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_80'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
                        btn += "<button onclick='findContactsList(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_81'><i class='fa fa-list fa-edit'></i>&nbsp;查看联系人</button>";
                        btn += "<button onclick='collectionList(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_82'><i class='fa fa-list fa-edit'></i>&nbsp;收款信息</button>";
                        return  btn;
                    },
                    "targets": 3
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

    /**查看联系人**/
    function findContactsList (id) {
        var index = layer.open({
            type: 2,
            title: '查看联系人',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierContacts/list?supplierId=" + id
        });
        layer.full(index);
    }

    /**收款信息**/
    function collectionList (id) {
        var index = layer.open({
            type: 2,
            title: '收款信息列表',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplierAccountToBeCredited/list?supplierId=" + id
        });
        layer.full(index);
    }

    //添加
    function addData() {
        var index = layer.open({
            type: 2,
            title: '添加供应商',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplier/add"
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改供应商',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/supplier/edit?id=" + id
        });
        layer.full(index);
    }

    layui.use(['form'], function () {
        form = layui.form();
    });

</script>
</body>
</head>
</html>
