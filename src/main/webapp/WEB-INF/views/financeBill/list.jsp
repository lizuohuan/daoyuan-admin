<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>票据列表</title>
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
                            <label class="layui-form-label">公司名称</label>
                            <div class="layui-input-inline">
                                <select id="companyId" lay-search>
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select id="status">
                                    <option value="">请选择</option>
                                    <option value="3001">未开票</option>
                                    <option value="3002">已开票</option>
                                    <option value="3003">已邮寄</option>
                                    <option value="3004">已作废</option>
                                </select>
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
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">账单年月</label>
                            <div class="layui-input-inline">
                                <input class="layui-input"  placeholder="账单年月" onclick="layui.laydate({elem: this, festival: true,type:'month'})" id="billMonth" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">快递单号</label>
                            <div class="layui-input-inline">
                                <input type="text" placeholder="快递单号" id="orderNumber" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">发票号码</label>
                            <div class="layui-input-inline">
                                <input type="text" placeholder="发票号码" id="billNumber" class="layui-input">
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
        <legend>票据列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="downLoadMakeBill()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_171"><i
                        class="layui-icon">
                    &#xe601;</i> 下载票据
                </button>
                <button onclick="uploadMakeBill()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_172"><i
                        class="layui-icon">
                    &#xe62f;</i> 上传票据
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>公司名称</th>
                    <th>客服</th>
                    <th>账单年月</th>
                    <th>金额</th>
                    <th>差额</th>
                    <th>开票日期</th>
                    <th>快递单号</th>
                    <th>发票号码</th>
                    <th>票据类型</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </fieldset>

    <form id="newUpload" method="post" enctype="multipart/form-data">
        <input id="File" type="file" name="File"
               accept="application/vnd.ms-excel/vnd.openxmlformats-officedocument.spreadsheetml.sheet" class="hide"
               onchange="onChangeFile(this)">
    </form>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
<script>

    var form = null;
    var dataTable = null;
    var layer = null;
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
                url: AM.ip + "/makeBill/getMakeBill",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.status = $("#status").val();
                    data.companyId = $("#companyId").val();
                    data.billNumber = $("#billNumber").val();
                    data.orderNumber = $("#orderNumber").val();
                    data.beforeService = $("#beforeService").val();
                    data.billMonthStamp = '' == $("#billMonth").val() ? null : new Date($("#billMonth").val()).getTime();
                }
            },
            "columns": [
                {"data": "companyName"},
                {"data": "serviceName"},
                {"data": "billMonth"},
                {"data": "amountOfBill"},
                {"data": "amount"},
                {"data": "makeBillDate"},
                {"data": "expressNumber"},
                {"data": "invoiceNumber"},
                {"data": "billType"},
                {"data": "status"},
            ],
            "columnDefs": [
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM");
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd");
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        // /** 票据类型 0：专票 1：普票  2：收据 */
                        if(data == 0){
                            return "专票";
                        }
                        else if(data == 1){
                            return "普票";
                        }
                        else if(data == 2){
                            return "收据";
                        }
                        return "";
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        if (data == 3001) {
                            return "未开票";
                        }
                        else if (data == 3002) {
                            return "已开票";
                        }
                        else if (data == 3003) {
                            return "已邮寄";
                        }
                        else if (data == 3004) {
                            return "已作废";
                        }
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.status == 3001) {
                            // 可以手动录入票据
                            btn += "<button onclick='showBox(" + row.id + ", 3002)' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_168'><i class='fa fa-list fa-edit'></i>&nbsp;录入发票号</button>";
                            btn += "<button  onclick='updateStatus(" + row.id + ", 3004)' class='layui-btn layui-btn-danger layui-btn-small  hide checkBtn_173'>标记作废</button>";
                        }
                        if (row.status == 3002) {
                            btn += "<button onclick='showBoxExpress(" + row.id + ", 3003,"+row.companyId+")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_147'><i class='fa fa-list fa-edit'></i>&nbsp;点击邮寄</button>";
                        }
                        else if (row.status == 3003) {
                            btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_147'>已邮寄</button>";
                        }

                        return btn;
                    },
                    "targets": 10
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


    function showBox(id, status) {
        if (status == 3002) {
            // 需要录入发票号
            var html = '<form class="layui-form" action="">' +
                    '       <div class="layui-form-item" >' +
                    '           <label class="layui-form-label">发票号码</label>' +
                    '           <div class="layui-input-block">' +
                    '               <input type="text" id="invoiceNumber" lay-verify="required" placeholder="输入发票号码" autocomplete="off" class="layui-input" maxlength="50"> ' +
                    '           </div>' +
                    '       </div>' +
                    '   </form>';
            layer.confirm(html, {
                btn: ['确定', '取消'],
                title: "录入发票号",
                area: ["400px", "200px"],
            }, function () {

                var val = $("#invoiceNumber").val();
                if (val == '') {
                    layer.msg('发票号码没有填写', {icon: 2, anim: 6});
                    return;
                }
                AM.ajaxRequestData("post", false, AM.ip + "/makeBill/updateStatus", {
                    id: id,
                    status: status,
                    invoiceNumber: val
                }, function (result) {
                    if (result.code == 200) {
                        layer.msg("操作成功");
                    }
                    else {
                        layer.msg("操作失败");
                    }
                    dataTable.ajax.reload();
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                });

            }, function () {
            });
            form.render();
        }

    }

    var expressInfo = null; // 收件人
    var expressInfoDefault = null; // 默认的收件人
    var expressCompany = null; // 快递公司

    function showBoxExpress(id, status,companyId) {
        if (status == 3003) {
            if(null == expressInfo){
                AM.ajaxRequestData("post", false, AM.ip + "/expressPersonInfo/queryAllPersonInfoByCompany", {companyId:companyId} , function(result){
                    if(result.flag == 0 && result.code == 200){
                        expressInfo = result.data;

                    }
                });
            }
            if(null == expressCompany){
                AM.ajaxRequestData("post", false, AM.ip + "/express/queryAllExpressCompany", {} , function(result){
                    if(result.flag == 0 && result.code == 200){
                        expressCompany = result.data;
                    }
                });
            }
            var expressInfoHtml = buildExpressInfoHtml();
            var expressCompanyHtml = buildExpressCompanyHtml();

            var personName_ = '';
            var phone_ = '';
            var address_ = '';
            var zipcode_ = '';
            var unintName_ = '';
            if(null != expressInfoDefault){
                personName_ = expressInfoDefault.personName;
                phone_ = expressInfoDefault.phone;
                address_ = expressInfoDefault.address;
                unintName_ = expressInfoDefault.unitName;
                zipcode_ = expressInfoDefault.zipcode;
            }

            var html = '<form class="layui-form" action="">' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">快递单号<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="orderNumberDiv">' +
                            '<input type="text" name="orderNumber_" id="orderNumber_" lay-verify="required" placeholder="请输入快递单号" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人<span class="font-red"></span></label>' +
                        '<div class="layui-input-inline" id="expressPersonIdDiv">' +
                            '<select name="expressPersonId" id="expressPersonId" lay-filter="expressPersonFilter">' +
                            expressInfoHtml +
                            ' </select>' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人姓名<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="expressPersonNameDiv">' +
                            '<input type="text" value="'+personName_+'" name="expressPersonName" id="expressPersonName" lay-verify="required" placeholder="收件人姓名" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人电话<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="expressPersonPhoneDiv">' +
                            '<input type="text" value="'+phone_+'" name="expressPersonPhone" id="expressPersonPhone" lay-verify="required" placeholder="收件人电话" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人地址<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="expressPersonAddressDiv">' +
                            '<input type="text" value="'+address_+'" name="expressPersonAddress" id="expressPersonAddress" lay-verify="required" placeholder="收件人地址" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人单位名称<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="expressPersonUnitNameDiv">' +
                            '<input type="text" value="'+unintName_+'" name="expressPersonUnitName" id="expressPersonUnitName" lay-verify="required" placeholder="收件人单位名称" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item">' +
                        '<label class="layui-form-label">收件人邮编<span class="font-red"></span></label>' +
                        '<div class="layui-input-inline" id="expressPersonZipCodeDiv">' +
                            '<input type="text" value="'+zipcode_+'" name="expressPersonZipCode" id="expressPersonZipCodeName" placeholder="收件人邮编" autocomplete="off" class="layui-input" maxlength="50">' +
                        '</div>' +
                    '</div>' +
                    '<div class="layui-form-item ">' +
                        '<label class="layui-form-label">快递公司<span class="font-red">*</span></label>' +
                        '<div class="layui-input-inline" id="expressCompanyIdDiv">' +
                            '<select name="expressCompanyId" id="expressCompanyId" lay-verify="required" lay-search>' +
                            expressCompanyHtml +
                            ' </select>' +
                        '</div>' +
                    '</div>' +
                    '   </form>';


            layer.confirm(html, {
                btn: ['确定', '取消'],
                title: "快递信息",
                area: ["800px", "700px"],
            }, function () {



                if ($("#orderNumber_").val() == "") {
                    layer.tips('没有填写快递单号', '#orderNumberDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#orderNumber_").focus();
                    return false;
                }

                if ($("#expressPersonName").val() == "") {
                    layer.tips('没有填写收件人姓名', '#expressPersonNameDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#expressPersonName").focus();
                    return false;
                }
                if ($("#expressPersonPhone").val() == "") {
                    layer.tips('没有填写收件人电话', '#expressPersonPhoneDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#expressPersonPhone").focus();
                    return false;
                }
                if ($("#expressPersonAddress").val() == "") {
                    layer.tips('没有填写收件人地址', '#expressPersonAddressDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#expressPersonAddress").focus();
                    return false;
                }
                if ($("#expressPersonUnitName").val() == "") {
                    layer.tips('没有填写收件人单位名称', '#expressPersonUnitNameDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#expressPersonUnitName").focus();
                    return false;
                }

                if ($("#expressCompanyId").val() == "") {
                    layer.tips('没有选择快递公司', '#expressCompanyIdDiv', {
                        tips: [1, '#000'],
                        time: 3000
                    });
                    $("#expressCompanyId").focus();
                    return false;
                }


                AM.ajaxRequestData("post", false, AM.ip + "/makeBill/expressMakeBill", {
                    id: id,
                    status: status,
                    companyId: companyId,
                    orderNumber: $("#orderNumber_").val(),
                    expressCompanyId: $("#expressCompanyId").val(),
                    personName: $("#expressPersonName").val(),
                    phone: $("#expressPersonPhone").val(),
                    address: $("#expressPersonAddress").val(),
                    unitName: $("#expressPersonUnitName").val(),
                    zipcode: $("#expressPersonZipCodeName").val()
                }, function (result) {
                    if (result.code == 200) {
                        layer.msg("操作成功");
                    }
                    else {
                        layer.msg("操作失败");
                    }
                    dataTable.ajax.reload();
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                });

            }, function () {
            });
            form.render();
        }

    }



    function buildExpressInfoHtml(){
        var html = "<option value=\"\">请选择收件人</option>";
        for (var i = 0; i < expressInfo.length; i++) {
            if(expressInfo[i].isDefault == 1){
                html += "<option selected=\"selected\" obj="+JSON.stringify(expressInfo[i])+"  value=\"" + expressInfo[i].id + "\">" + expressInfo[i].personName + "</option>";
                expressInfoDefault = expressInfo[i];
            }else{
                html += "<option obj="+JSON.stringify(expressInfo[i])+"  value=\"" + expressInfo[i].id + "\">" + expressInfo[i].personName + "</option>";
            }



        }
        if (expressInfo.length == 0) {
            html += "<option value=\"\" disabled>暂无</option>";
        }
        return html;
    }

    function buildExpressCompanyHtml(){
        var html = "<option value=\"\">请选择快递公司</option>";
        for (var i = 0; i < expressCompany.length; i++) {
            html += "<option value=\"" + expressCompany[i].id + "\">" + expressCompany[i].expressCompanyName + "</option>";
        }
        if (expressCompany.length == 0) {
            html += "<option value=\"\" disabled>暂无</option>";
        }
        return html;
    }


    //修改状态
    function updateStatus(id, status) {
        var msg = "";
        if (status == 3004) {
            msg = "是否确认标记作废？";
        }
        layer.open({
            content: msg,
            yes: function (index, layero) {
                AM.ajaxRequestData("post", false, AM.ip + "/makeBill/updateStatus", {
                    id: id,
                    status: status
                }, function (result) {
                    if (result.code == 200) {
                        layer.msg("操作成功");
                    }
                    else {
                        layer.msg("操作失败");
                    }
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    location.reload();
                });
            }
        });

    }

    layui.use(['form'], function () {
        form = layui.form();
        layer = layui.layer;
        queryAllCompany(0, "companyId", null, 0);
        getUserByRole(0,"beforeService",0,9);


        form.on('select(expressPersonFilter)', function(data){
            var obj = JSON.parse($(data.elem).find("option:selected").attr("obj"));
            $("#expressPersonName").val(obj.personName);
            $("#expressPersonPhone").val(obj.phone);
            $("#expressPersonAddress").val(obj.address);
            $("#expressPersonUnitName").val(obj.unitName);
            $("#expressPersonZipCodeName").val(obj.zipcode);
            form.render();
        });
        form.render();
    });


    function downLoadMakeBill() {
        window.location.href = AM.ip + "/makeBill/exportMakeBill";
    }

    function uploadMakeBill() {
        $("#File").click();
    }
    function onChangeFile(obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
        var fr = new FileReader();
        if (window.FileReader) {
            fr.onloadend = function (e) {
                $("#newUpload").ajaxSubmit({
                    type: "POST",
                    url: AM.ip + '/res/upload',
                    success: function (result) {
                        AM.log(result);
                        if (result.code == 200) {
                            $('#File').val("");
                            layer.close(index);
                            AM.ajaxRequestData("post", false, AM.ip + "/makeBill/url", {
                                url: AM.ip + "/" + result.data.url
                            }, function (result) {
                                layer.msg(result.msg);
                            });
                            $.ajax({
                                type: "POST",
                                url: AM.ip + "/res/delete",
                                data: {url: result.data.url},
                                success: function () {
                                    AM.log("delete.");
                                }
                            });
                        } else {
                            layer.close(index);
                            $('#File').val("");
                            layer.msg(result.msg);
                        }
                    }
                });
            };
            fr.readAsDataURL(file);
        }
    }

</script>
</body>
</head>
</html>
