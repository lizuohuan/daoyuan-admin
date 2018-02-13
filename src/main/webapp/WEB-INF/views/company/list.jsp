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
        .blue{color: #00a0e9}
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
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_43"><i
                        class="layui-icon">&#xe608;</i> 添加
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>客户编号</th>
                    <th>客户名称</th>
                    <th>账单日</th>
                    <th>到款日</th>
                    <th>业务</th>
                    <th>合作方式</th>
                    <th>合同开始日期</th>
                    <th>客服</th>
                    <th>合作状态</th>
                    <th width="500">操作</th>
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

        buildTradeOption(0,"tradeId","post",null);

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
                url: AM.ip + "/company/getCompanyList",
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
                {"data": "businessStartTime"},
                {"data": "payTime"},
                {"data": "businesses"},
                {"data": "cooperationMethodList"},
                {"data": "contractStartTime"},
                {"data": "beforeServiceName"},
                {"data": "cooperationStatus"},
            ],
            "columnDefs": [
                {
                    "render": function (data, type, row) {
                        return "<a class='blue' href='javascript: detail(" + row.id + ")'>" + data + "</a>";
                    },
                    "targets": 1
                },
                {
                    "render": function (data, type, row) {
                        var date = new Date(data).format("dd");
                        if (Number(date) < 10) {
                            return "每月" + parseInt(date) + "日";
                        }
                        else {
                            return "每月" + date + "日";
                        }
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        var date = new Date(data).format("dd");
                        if (Number(date) < 10) {
                            return "每月" + parseInt(date) + "日";
                        }
                        else {
                            return "每月" + date + "日";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {

                        // 服务费

                        if(null != row.cooperationMethodList && row.cooperationMethodList != ''){
                            var str = "";
                            for (var i = 0; i < row.cooperationMethodList.length; i++){

                                if(row.cooperationMethodList[i].cooperationMethodId == 0){
                                    str += "普通、";
                                }
                                if(row.cooperationMethodList[i].cooperationMethodId == 1){
                                    str += "派遣、";
                                }
                                if(row.cooperationMethodList[i].cooperationMethodId == 2){
                                    str += "外包、";
                                }
                            }
                            return str;
                        }
                        return "--";
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        if(null == data || data.length == 0){
                            return "-";
                        }
                        var str = "";
                        for (var i = 0; i < data.length; i++){

                            if(data[i].id == 3){
                                // 社保
                                if(data[i].businessMethod.tuoGuan != null && data[i].businessMethod.daiLi != null){
                                    str += data[i].businessName +  "-托管及代理、";
                                }else if(data[i].businessMethod.tuoGuan != null && data[i].businessMethod.daiLi == null){
                                    str += data[i].businessName + "-托管、";
                                }else if(data[i].businessMethod.tuoGuan == null && data[i].businessMethod.daiLi != null){
                                    str += data[i].businessName +  "-代理、";
                                }else{
                                    str += data[i].businessName +"、";
                                }

                            }
                            else if( data[i].id == 4){
                                if(data[i].businessMethod.tuoGuan != null && data[i].businessMethod.daiLi != null){
                                    str += data[i].businessName +  "-托管及代理、";
                                }else if(data[i].businessMethod.tuoGuan != null && data[i].businessMethod.daiLi == null){
                                    str += data[i].businessName + "-托管、";
                                }else if(data[i].businessMethod.tuoGuan == null && data[i].businessMethod.daiLi != null){
                                    str += data[i].businessName +  "-代理、";
                                }else{
                                    str += data[i].businessName +"、";
                                }
                            }
                            else{
                                str += data[i].businessName+"、";
                            }
                        }
                        return str;
                    },
                    "targets": 4
                },
                {
                    "render": function (data, type, row) {
                        if (null == data || data == "") {
                            return "--"
                        } else {
                            return new Date(data).format("yyyy-MM-dd");
                        }
                        ;
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        if (null == data || data == "") {
                            return "--"
                        }
                        return  data ;
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {

                        // 合作状态 0 空户/终止  1 合作

                        if(1 == data){
                            return "合作中";
                        }
                        return "空户/终止";
                    },
                    "targets": 8
                },

                {
                    "render": function (data, type, row) {
                        var btn = "";
                        // 联系人
                        btn += "<button onclick='checkContacts(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_45'>联系人管理</button>";
                        btn += "<button onclick='checkYouji(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_46'>邮寄信息</button>";
                        btn += "<button onclick='checkExpressInfo(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_47'>快递信息</button>";
                        // 查看和修改 票据信息
                        btn += "<button onclick='checkBillInfo(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_48'>票据管理</button><br><br>";
                        // 查看合同
                        btn += "<button onclick='checkContract(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_49'>合同管理</button>";
                        if (row.isShowSocialSecurity != 0 || row.isShowAccumulationFund != 0) {
                            btn += "<button onclick='socialSecurity(" + row.id + ", \"" + row.companyName + "\", " + row.isShowSocialSecurity + ", " + row.isShowAccumulationFund + ")' class='layui-btn layui-btn-small hide checkBtn_50'>托管配置</button>";
                        }
                        if (row.isShowBuildBtn != 0) {
                            btn += "<button onclick='generateTheBill(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_51'>生成子账单</button>";
                        }
                        btn += "<button onclick='sonBill(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_158'>子账单配置</button>";
                        btn += "<button onclick='mergeTheBill(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_54'>合并账单</button>";
                        btn += "<button onclick='accountInfo(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_55'>付款信息</button>";
                        btn += "<button onclick='updateStatus(" + row.id + ","+row.isValid+")' class='layui-btn layui-btn-small layui-btn-danger hide checkBtn_170'>删除</button>";
                        return "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_44'>修改</button>"
//                                + "<button onclick='delBanner(" + row.id + ")' class='layui-btn layui-btn-danger layui-btn-small hide checkBtn_116'><i class='fa fa-list fa-edit'></i>&nbsp;终止合同</button>"
                                + btn
                                ;
                    },
                    "targets": 9
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
            title: '添加客户',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/company/add"
        });
        layer.full(index);
    }


    function checkContacts(id) {
        var index = layer.open({
            type: 2,
            title: '联系人管理',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/lianxi/list?companyId="+id
        });
        layer.full(index);
    }

    function checkExpressInfo(id) {
        var index = layer.open({
            type: 2,
            title: '快递信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/expressInfo/list?companyId="+id
        });
        layer.full(index);
    }

    function checkYouji(id) {
        var index = layer.open({
            type: 2,
            title: '邮寄信息管理',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/youji/list?companyId="+id
        });
        layer.full(index);
    }

    function checkBillInfo(id) {
        var index = layer.open({
            type: 2,
            title: '票据管理',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bill/list?companyId="+id
        });
        layer.full(index);
    }

    function checkContract(id) {
        var index = layer.open({
            type: 2,
            title: '合同管理',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/hetong/list?companyId="+id
        });
        layer.full(index);
    }

    /**社保配置**/
    function socialSecurity(id, companyName, isShowSocialSecurity, isShowAccumulationFund) {
        sessionStorage.setItem("companyName", companyName);
        var index = layer.open({
            type: 2,
            title: '托管配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/accumulationFund/list?companyId="+id + "&isShowSocialSecurity=" + isShowSocialSecurity + "&isShowAccumulationFund=" + isShowAccumulationFund
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改客户',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/company/edit?id=" + id
        });
        layer.full(index);
    }

    //修改状态
    function updateStatus(id, isValid) {
        var statusMsg = "";
        if (isValid == 0) {
            statusMsg = "是否设置有效?";
        }
        else{
            statusMsg = "是否删除公司?";
        }
        isValid = 0 == isValid ? 1 : 0;
        var arr = {
            id : id,
            isValid : isValid
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/company/updateStatus", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    var index = layer.load(1, {shade: [0.5, '#eee']});
                    setTimeout(function () {
                        layer.close(index);
                    }, 600);
                }
            });
            layer.close(index);
        });
    }

    /**生成子账单**/
    function generateTheBill(id) {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/getCompanySonBillByCompany", {companyId : id}, function (result) {
            layer.msg("账单生成成功");
        });
        layer.close(index);
    }

    /**子账单配置**/
    function sonBill(id) {
        var index = layer.open({
            type: 2,
            title: '子账单配置',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companySonBill/list?companyId=" + id
        });
        layer.full(index);
    }

    /**合并账单**/
    function mergeTheBill(id) {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBillItem/mergeBill", {companyId : id}, function (result) {
            layer.msg("合并账单成功");
        });
        layer.close(index);
    }

    /**账户信息**/
    function accountInfo(id) {
        var index = layer.open({
            type: 2,
            title: '账户信息',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/bankInfo/list?companyId=" + id
        });
        layer.full(index);
    }

    //审核通过确认发布
    function adoptToExamine(id) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var index2 = layer.confirm('是否确认发布？', {
            btn: ['确认', '取消'] //按钮
        }, function () {
            var arr = {
                id: id,
                status: 1
            }
            AM.ajaxRequestData("post", false, AM.ip + "/banner/updateStatus", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.close(index);
                    layer.close(index2);
                }
            });
        }, function () {
            layer.close(index);
        });
    }

    //删除
    function delBanner(id) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var index2 = layer.confirm('是否确认删除？', {
            btn: ['确认', '取消'] //按钮
        }, function () {
            var arr = {
                id: id
            }
            AM.ajaxRequestData("post", false, AM.ip + "/banner/delete", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.close(index);
                    layer.close(index2);
                }
            });
        }, function () {
            layer.close(index);
        });
    }

    /**详情**/
    function detail (id) {
        layer.full(layer.open({
            type: 2,
            title: '客户详情',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/companyDetail?id=" + id
        }));
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
