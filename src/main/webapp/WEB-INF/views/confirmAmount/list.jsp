<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>认款列表</title>
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
                            <label class="layui-form-label">交易日期选择</label>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="开始日" id="LAY_demorange_s">
                            </div>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="截止日" id="LAY_demorange_e">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">客服</label>
                            <div class="layui-input-inline">
                                <select name="beforeService" id="beforeService"  lay-search>
                                    <option value="">请选择前道客服</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">单位名称</label>
                            <div class="layui-input-inline">
                                <input type="text" id="companyName" placeholder="单位名称" autocomplete="off" class="layui-input" maxlength="50">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">匹配公司</label>
                            <div class="layui-input-inline">
                                <input type="text" id="matchCompanyName" placeholder="匹配公司" autocomplete="off" class="layui-input" maxlength="50">
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">状态</label>
                            <div class="layui-input-inline">
                                <select  id="status"  lay-search>
                                    <option value="">选择</option>
                                    <option value="0">未认款</option>
                                    <option value="1">已认款</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">导入日期选择</label>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="开始日" id="importStartDate">
                            </div>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="截止日" id="importEndDate">
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
        <legend>认款列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="uploadFile()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_129"><i class="fa fa-cloud-upload"></i> 上传认款
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>银行帐号</th>
                    <th>单位名称</th>
                    <th>交易时间</th>
                    <th>到款金额</th>
                    <th>摘要</th>
                    <th>匹配的公司</th>
                    <th>客服</th>
                    <th>导入时间</th>
                    <th>认款方式</th>
                    <th>认款状态</th>
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
<input type="hidden" id="fileUrl">

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>

    var form = null;
    var dataTable = null;
    $(document).ready(function () {
        dataTable = $('#dataTable').DataTable({
            "iDisplayLength" : 30, //默认显示的记录数
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
                url: AM.ip + "/confirmAmount/getConfirmMoneyRecord",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    if ($("#LAY_demorange_s").val() != "") {
                        data.startTimeStamp = new Date($("#LAY_demorange_s").val()).getTime();
                    }
                    if ($("#LAY_demorange_e").val() != "") {
                        data.endTimeStamp = new Date($("#LAY_demorange_e").val()).getTime();
                    }
                    if ($("#importStartDate").val() != "") {
                        data.importStartDateTimeStamp = new Date($("#importStartDate").val()).getTime();
                    }
                    if ($("#importEndDate").val() != "") {
                        data.importEndDateTimeStamp = new Date($("#importEndDate").val()).getTime();
                    }
                    data.beforeService = $("#beforeService").val();
                    data.status = $("#status").val();
                    data.matchCompanyName = $("#matchCompanyName").val();
                    data.companyName = $("#companyName").val();
                }
            },
            "columns":[
                {"data": "bankAccount"},
                {"data": "companyName"},
                {"data": "transactionTime"},
                {"data": "amount"},
                {"data": "digest"},
                {"data": ""},
                {"data": ""},
                {"data": "createTime"},
                {"data": "confirmMethod"},
                {"data": "status"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 2
                },
                {
                    "render": function (data, type, row) {
                        var companyName = "";
                        if (row.confirmMoneyCompanyList.length > 0) {
                            for(var  i = 0; i < row.confirmMoneyCompanyList.length; i++){
                                var d = "";
                                for(var j = 0; j < row.confirmFundList.length; j++){
                                    if(row.confirmFundList[j].companyId ==row.confirmMoneyCompanyList[i].companyId ){
                                        d = ": "+row.confirmFundList[j].confirmAmount;
                                    }
                                }


                                companyName += row.confirmMoneyCompanyList[i].companyName +  d + "、";
                            }
                            return companyName.substring(0,companyName.length - 1);
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        var serviceUserName = "";
                        if (row.confirmMoneyCompanyList.length > 0) {
                            for(var  i = 0; i < row.confirmMoneyCompanyList.length; i++){
                                serviceUserName += row.confirmMoneyCompanyList[i].serviceUserName + "、";
                            }
                            return serviceUserName.substring(0,serviceUserName.length - 1);
                        }
                        else {
                            return "--";
                        }
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "自动认款";
                        }
                        else if (data == 1) {
                            return "手动认款";
                        }
                        else {
                            return "未匹配公司";
                        }
                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        if (data ==  1) {
                            return "已认款";
                        }
                        else {
                            return "未认款";
                        }
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                        var obj = JSON.stringify(row);
                        var btn = "";
                        if (row.status == 0) {
                            btn += "<button onclick='updateData(" + obj + ","+row.id+")' class='layui-btn layui-btn-small hide checkBtn_131'><i class='fa fa-list fa-edit'></i>&nbsp;手动认款</button>";
                        }
//                        else {
//                            btn += "<button class='layui-btn layui-btn-small layui-btn-disabled hide checkBtn_131'><i class='fa fa-list fa-edit'></i>&nbsp;手动认款</button>";
//                        }
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

    /**手动认款**/
    function updateData (obj,id) {
        sessionStorage.setItem("confirmAmount", JSON.stringify(obj));
        var index = layer.open({
            type: 2,
            title: '手动认款',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/confirmAmount/edit?id="+id
        });
        layer.full(index);
        return false;
        /*var html = "";
        for (var i = 0; i < obj.confirmMoneyCompanyList.length; i++) {
            var company = obj.confirmMoneyCompanyList[i];
            html += '<div class="layui-form-item">' +
                    '       <label class="layui-form-label" style="width:90px;">公司名字</label>' +
                    '       <div class="layui-input-inline" style="width:150px;">' +
                    '           <div class="layui-input">' + company.companyName + '</div>' +
                    '       </div>' +
                    '       <label class="layui-form-label" style="width:90px;">金额</label>' +
                    '       <div class="layui-input-inline" style="width:120px;">' +
                    '           <input type="text" name="companyMoney" companyId="' + company.companyId + '" class="layui-input" placeholder="金额">' +
                    '       </div>' +
                    '   </div>';
        }

        AM.formPopup(html, "手动认款", ["600px", "300px"], function () {

            var dataArr = [];
            var totalMoney = 0;
            $("input[name=companyMoney]").each(function () {
                dataArr.push({
                    companyId : $(this).attr("companyId"),
                    amount : $(this).val(),
                });
                totalMoney += Number($(this).val());
            });
            if (totalMoney != obj.amount) {
                layer.msg("输入金额相加必须等于到款金额");
                return false;
            }

            var arr = {
                confirmMoneyRecordId : obj.id,
                dataArr : JSON.stringify(dataArr),
            }
            AM.log(arr);
            AM.ajaxRequestData("post", false, AM.ip + "/confirmAmount/confirmAmount", arr , function(result){
                dataTable.ajax.reload();
                layer.msg('手动认款成功.', {icon: 1});
                var index = layer.load(1, {shade: [0.5,'#eee']});
                setTimeout(function () {layer.close(index);}, 600);
            });
        }, function () {});*/
    }

    /**上传**/
    function uploadFile() {
        $("#fileUrl").val("");
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择类型</label>' +
                '           <div class="layui-input-inline">' +
                '               <select id="flag">' +
                '                   <option value="0">工商银行</option>' +
                '                   <option value="1">成都银行</option>' +
                '                   <option value="2">华夏银行</option>' +
                '                   <option value="3">支付宝</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择文件</label>' +
                '           <div class="layui-input-inline">' +
                '               <button type="button" class="layui-btn" onclick="uploadAdd()"><i class="fa fa-cloud-upload"></i>选择</button>' +
                '               <span class="layui-inline layui-upload-choose" id="kaoPanFile"></span>' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['提交','取消'],
            title: "认款",
            area: ["600px", "300px"],
        }, function () {
            var url = $("#fileUrl").val();
            if (url == "") {
                layer.msg("请选择文件");
                return false;
            }
            AM.ajaxRequestData("post", false, AM.ip + "/confirmAmount/importConfirmMoneyRecord", {
                url : AM.ip + "/" + url,
                flag : $("#flag").val()
            }, function (result) {
                layer.msg(result.msg);
                dataTable.ajax.reload();
                deleteData(url); //删除文件
            });
        }, function () {});
        form.render();
    }
    /**触发文件**/
    function uploadAdd() {
        $("#File").click();
    }

    function onChangeFile (obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
        var fr = new FileReader();
        $("#kaoPanFile").html(file.name);
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
                            $("#fileUrl").val(result.data.url);
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

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        getUserByRole(0,"beforeService",0,9);
        var start = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        var start_s = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
//                end_s.min = datas; //开始日选好后，重置结束日的最小日期
//                end_s.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end_s = {
            min: '1999-01-01 23:59:59'
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
//                start_s.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };

        document.getElementById('LAY_demorange_s').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        document.getElementById('LAY_demorange_e').onclick = function(){
            end.elem = this
            laydate(end);
        }

        document.getElementById('importStartDate').onclick = function(){
            start_s.elem = this;
            laydate(start_s);
        }
        document.getElementById('importEndDate').onclick = function(){
            end_s.elem = this
            laydate(end_s);
        }
        form.render();
    });



    /**删除上传的文件**/
    function deleteData (url) {
        $.ajax({
            type: "POST",
            url: AM.ip + "/res/delete",
            data: { url : url },
            success: function () {}
        });
    }

</script>
</body>
</head>
</html>
