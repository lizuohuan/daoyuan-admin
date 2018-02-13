<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>实做列表</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .hover-content {

        }
        .popUpWindows {
            width: 300px;
            height: 300px;
            background: #FFF;
            border-radius: 10px;
            box-shadow: 0 5px 5px rgba(0, 0, 0, 0.5);
            position: absolute;
            z-index: 9999;
            animation: opacity0-1 0.5s;
            -moz-animation: opacity0-1 0.5s;
            -webkit-animation: opacity0-1 0.5s;
            -o-animation: opacity0-1 0.5s;
            transition: 0.5s all;
            transform: scale(0);
            padding: 15px;
            box-sizing: border-box;
        }
        .remark-list{
            list-style: decimal-leading-zero;
        }
        .remark-list li{
            padding-top: 15px;
            padding-left: 15px;
            font-size: 14px;
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
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-inline">
                                <select id="companyId" lay-search>
                                    <option value="">请选择或搜索</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">员工名称</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" placeholder="请输入员工名称" id="mUserName">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">员工证件编号</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" placeholder="请输入员工证件编号" id="certificateNum">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">客服名称</label>
                            <div class="layui-input-inline">
                                <input type="text" class="layui-input" placeholder="请输入客服名称" id="uUserName">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">服务类型</label>
                            <div class="layui-input-inline">
                                <select id="serviceType">
                                    <option value="">请选择</option>
                                    <option value="0">社保</option>
                                    <option value="1">公积金</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择缴金地</label>
                            <div class="layui-input-inline">
                                <select id="payPlaceId" lay-filter="payPlaceFilter" lay-search>
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择经办机构</label>
                            <div class="layui-input-inline">
                                <select id="organizationId" lay-filter="organizationFilter" lay-search>
                                    <option value="">请选择</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择办理方</label>
                            <div class="layui-input-inline">
                                <select id="transactorId" lay-search>
                                    <option value="">请选择</option>
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
        <legend>实做列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="batchSend()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_135">批量申请
                </button>
                <button onclick="allSend()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_136">一键全部申请
                </button>
                <button onclick="uploadAddPersonModal()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_122"><i class="fa fa-cloud-upload"></i> 上传增/减员反馈
                </button>
                <button onclick="downloadPersonModal()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_124"><i class="fa fa-cloud-download"></i> 下载增/减员数据</button>
                <button onclick="uploadKaoPanData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_126"><i class="fa fa-cloud-upload"></i> 上传拷盘数据
                </button>
                <button onclick="downloadSocialSecurity(0)"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_169"><i class="fa fa-cloud-download"></i> 下载社保拷盘通用模版</button>
                <button onclick="downloadSocialSecurity(1)"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_169"><i class="fa fa-cloud-download"></i> 下载公积金拷盘通用模版</button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th><input type="checkbox" name="allSelected" lay-skin="primary" lay-filter="allSelected" ></th>
                    <th>公司</th>
                    <th>员工</th>
                    <th>证件类型</th>
                    <th>证件编号</th>
                    <th>服务类型</th>
                    <th>服务名称</th>
                    <th>社保/公积金编号</th>
                    <th>缴金地</th>
                    <th>经办机构</th>
                    <th>办理方</th>
                    <%--<th>档次</th>--%>
                    <th>客服</th>
                    <th>状态</th>
                    <th>原因</th>
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

<div class="popUpWindows">

</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>
    var topHeight = 0;
    $(document).ready(function(){
        $(window).scroll(function(){
            topHeight = $(document).scrollTop();
        })
    })
    var form = null;
    var dataTable = null;
    var timer = null;
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
                $(".hover-content").hover(function (event) {
                    $(".popUpWindows").html("原因：" + $(this).attr("failReason"));
                    clearTimeout(timer);
                    var xx = event.originalEvent.x || event.originalEvent.layerX || 0;
                    var yy = event.originalEvent.y || event.originalEvent.layerY || 0;
                    yy = yy + topHeight;
                    $(".popUpWindows").css({top: yy - 270, left: xx - 320, transform: "scale(1)"});
                    timer = setTimeout(function () {
                        $(".popUpWindows").css({transform: "scale(0)"});
                    }, 3000);
                });
                form.render();
            },
            "ajax": {
                url: AM.ip + "/memberBusinessUpdateRecord/list",
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
                    data.uUserName = $("#uUserName").val();
                    data.mUserName = $("#mUserName").val();
                    data.certificateNum = $("#certificateNum").val();
                    data.payPlaceId = $("#payPlaceId").val();
                    data.organizationId = $("#organizationId").val();
                    data.transactorId = $("#transactorId").val();
                    data.status = $("#status").val();
                    data.serviceType = $("#serviceType").val();
                }
            },
            "columns":[
                {"data": ""},
                {"data": "companyName"},
                {"data": "userName"},
                {"data": "certificateType"},
                {"data": "certificateNum"},
                {"data": "serviceType"},
                {"data": "serviceStatus"},
                {"data": "serviceNumber"},
                {"data": "payPlaceName"},
                {"data": "organizationName"},
                {"data": "transactorName"},
//                {"data": "insuranceLevelName"},
                {"data": "beforeService"},
                {"data": "status"},
                {"data": "failReason"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (row.status == 0 || row.status == 3) {
                            return '<input type="checkbox" value="' + row.mburiId + '" name="memberBusinessUpdateRecordId" lay-skin="primary">';
                        }
                        else {
                            return '<input type="checkbox" disabled lay-skin="primary">';
                        }
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "身份证";
                        }
                        else if (data == 1) {
                            return "护照";
                        }
                        else {
                            return "港澳台通行证";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return  data == 0 ? "社保" : "公积金";
                    },
                    "targets": 5
                },
                {
                    "render": function (data, type, row) {
                        return  data == 0 ? "增员" : data == 1 ? "减员" : "变更";
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 8
                },/*
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : data;
                    },
                    "targets": 9
                },*/
                {
                    "render": function (data, type, row) {
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
                    "targets": 12
                },
                {
                    "render": function (data, type, row) {
                        return data == null || data == "" ? "--" : "<div class='hover-content' failReason='" + data + "'>" + data + "</div>";
                    },
                    "targets": 13
                },

                {
                    "render": function (data, type, row) {
                        var btn = "";
                        //btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_118'>查看/修改</button>";

                        btn += "<button onclick='subclass(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_119'>增减变记录</button>";
                        btn += "<button onclick='findRemark(" + row.remark + ")' class='layui-btn layui-btn-small hide checkBtn_150'>查看备注</button>";
                        btn += "<button onclick='addRemark(" + row.id + ")' class='layui-btn layui-btn-small layui-btn-warm hide checkBtn_149'>添加备注</button>";
                        return  btn;
                    },
                    "targets": 14
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

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改子账单',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/memberBusiness/edit?id=" + id
        });
        layer.full(index);
    }

    //查看子类
    function subclass(id) {
        var index = layer.open({
            type: 2,
            title: '查看子类',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/memberBusinessItem/list?memberBusinessUpdateRecordId=" + id
        });
        layer.full(index);
    }

    /**一键申请**/
    function allSend() {
        var companyId = $("#companyId").val();
        var uUserName = $("#uUserName").val();
        var mUserName = $("#mUserName").val();
        var certificateNum = $("#certificateNum").val();
        var payPlaceId = $("#payPlaceId").val();
        var organizationId = $("#organizationId").val();
        var transactorId = $("#transactorId").val();
        var serviceType = $("#serviceType").val();
        var index = layer.load(1, {shade: [0.1, '#fff']});
        var arr = {
            companyId:companyId,
            uUserName:uUserName,
            mUserName:mUserName,
            certificateNum:certificateNum,
            payPlaceId:payPlaceId,
            organizationId:organizationId,
            serviceType:serviceType,
            transactorId:transactorId
        }
        AM.ajaxRequestData("post", false, AM.ip + "/memberBusinessUpdateRecord/allApplyFor", arr, function (result) {
            layer.msg("一键申请成功.");
            dataTable.ajax.reload();
        });
        layer.close(index);
    }

    /**批量申请**/
    function batchSend() {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var ids = [];
        $("input[name=memberBusinessUpdateRecordId]:checked").each(function () {
            ids.push($(this).val());
        });
        if (ids.length == 0) {
            layer.msg("请选择");
            layer.close(index);
            return false;
        }
        AM.ajaxRequestData("post", false, AM.ip + "/memberBusinessUpdateRecord/batchApplyFor", {ids : ids.toString()}, function (result) {
            layer.msg("批量申请成功.");
            location.reload();
        });
        layer.close(index);
    }

    /**上传增/减员反馈**/
    function uploadAddPersonModal () {
        $("#fileUrl").val("");
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="type" value="0" title="社保" checked lay-filter="type">' +
                '               <input type="radio" name="type" value="1" title="公积金" lay-filter="type">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择城市</label>' +
                '           <div class="layui-input-inline">' +
                '               <select name="cityType" lay-filter="cityType">' +
                '                   <option value="0">通用</option>' +
                '                   <option value="1">成都</option>' +
//                '                   <option value="2">重庆</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item hide" id="selectType">' +
                '           <label class="layui-form-label">反馈类型</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="flag" value="0" title="参保反馈" checked>' +
                '               <input type="radio" name="flag" value="1" title="停保反馈">' +
                '               <input type="radio" name="flag" value="2" title="变更反馈">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item" id="selectType1">' +
                '           <label class="layui-form-label">反馈类型</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="flag" value="3" title="通用反馈" checked>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择上传的表格</label>' +
                '           <div class="layui-input-inline">' +
                '               <button type="button" id="selectFile" class="layui-btn" onclick="uploadAdd()"><i class="fa fa-cloud-upload"></i>选择</button>' +
                '               <span class="layui-inline layui-upload-choose" id="kaoPanFile"></span>' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['提交','取消'],
            title: "上传增/减员反馈",
            area: ["600px", "500px"],
        }, function () {
            var url = $("#fileUrl").val();
            if (url == "") {
                layer.tips('请选择文件', '#selectFile', {
                    tips: [1, '#000'],
                    time: 3000
                });
                return false;
            }
            if ($("select[name=cityType]").val() == 0) {
                AM.ajaxRequestData("post", false, AM.ip + "/import/commonFeedbackReport", {
                    url : AM.ip + "/" + url,
                }, function (result) {
                    layer.msg(result.msg);
                    deleteData(url); //删除文件
                });
            }
            else {
                AM.ajaxRequestData("post", false, AM.ip + "/import/handleSocialSecurityFeedbackReport", {
                    url : AM.ip + "/" + url,
                    flag : $("input[name=flag]:checked").val()
                }, function (result) {
                    layer.msg(result.msg);
                });
            }

        }, function () {});
        form.render();
    }

    /**上传拷盘数据**/
    function uploadKaoPanData () {
        $("#fileUrl").val("");
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="type" value="0" title="社保" checked>' +
                '               <input type="radio" name="type" value="1" title="公积金">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择城市</label>' +
                '           <div class="layui-input-inline">' +
                '               <select id="kaoPanCity">' +
                '                   <option value="0">通用</option>' +
                '                   <option value="1">成都</option>' +
//                '                   <option value="2">重庆</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">操作方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="operateType" value="0" title="覆盖" checked>' +
                '               <input type="radio" name="operateType" value="1" title="追加">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择拷盘数据</label>' +
                '           <div class="layui-input-inline">' +
                '               <button type="button" id="selectFile" class="layui-btn" onclick="uploadAdd(1)"><i class="fa fa-cloud-upload"></i>选择</button>' +
                '               <span class="layui-inline layui-upload-choose" id="kaoPanFile"></span>' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['提交','取消'],
            title: "上传拷盘数据",
            area: ["600px", "500px"],
        }, function () {
            var url = $("#fileUrl").val();
            if (url == "") {
                layer.tips('请选择文件', '#selectFile', {
                    tips: [1, '#000'],
                    time: 3000
                });
                return false;
            }
            var kaoPanCity = $("#kaoPanCity").val();
            var operateType = $("input[name=operateType]:checked").val();
            var type = $("input[name=type]:checked").val();
            var importUrl = "/import/socialSecurityImplements";
            if (type == 1) {
                importUrl = "/import/reservedFundsImplements";
            }

            //通用
            if (kaoPanCity == 0) {
                AM.ajaxRequestData("post", false, AM.ip + importUrl, {
                    url : AM.ip + "/" + url,
                    flag : 2,
                    operateType : operateType
                }, function (result) {
                    layer.msg(result.msg);
//                    layer.alert("需要手动生成账单");
                    layer.alert("上传成功");
                    $("#fileUrl").val("");
                });
            }
            //成都
            else if (kaoPanCity == 1) {

                AM.ajaxRequestData("post", false, AM.ip + importUrl, {
                    url : AM.ip + "/" + url,
                    flag : 0,
                    operateType : operateType
                }, function (result) {
                    layer.msg(result.msg);
//                    layer.alert("需要手动生成账单");
                    layer.alert("上传成功");
                    $("#fileUrl").val("");
                });
            }
            //重庆
            else if (kaoPanCity == 2) {
//                layer.msg("待开发");
                AM.ajaxRequestData("post", false, AM.ip + importUrl, {
                    url : AM.ip + "/" + url,
                    flag : 2,
                    operateType : operateType
                }, function (result) {
                    layer.msg(result.msg);
//                    layer.alert("需要手动生成账单");
                    layer.alert("上传成功");
                    $("#fileUrl").val("");
                });
            }
            deleteData(url); //删除文件
        }, function () {});
        form.render();
    }

    function downloadSocialSecurity(flag){
        if (flag == 0) {
            window.location.href = AM.ip + "/export/downSocialSecurityCommonTemplate";
        }
        else{
            window.location.href = AM.ip + "/export/downReservedFundsCommonTemplate";
        }
    }

    /**下载增/减/变员数据**/
    function downloadPersonModal () {
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="type" value="0" title="社保" checked lay-filter="type">' +
                '               <input type="radio" name="type" value="1" title="公积金" lay-filter="type">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">是否托管</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="isTuo" value="0" title="否" checked lay-filter="isTuo">' +
                '               <input type="radio" name="isTuo" value="1" title="是" lay-filter="isTuo">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择缴金地</label>' +
                '           <div class="layui-input-inline" id="payPlaceDiv">' +
                '               <select id="payPlaceId2" lay-search lay-filter="payPlaceFilter2">' +
                '                   <option value="">选择或者搜索</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                    '<div id="bigDiv">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择经办机构</label>' +
                '           <div class="layui-input-inline">' +
                '               <select id="organizationId2" lay-search lay-filter="organizationFilter2">' +
                '                   <option value="">选择或者搜索</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择办理方</label>' +
                '           <div class="layui-input-inline" id="transactorDiv">' +
                '               <select id="transactorId2" lay-search>' +
                '                   <option value="">选择或者搜索</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择公司</label>' +
                '           <div class="layui-input-inline">' +
                '               <select id="companyId2" lay-search>' +
                '                   <option value="">选择或者搜索</option>' +
                '               </select>' +
                '           </div>' +
                '       </div>' +
                '   </div>' +
                '       <div class="layui-form-item" id="selectType">' +
                '           <label class="layui-form-label">选择方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="memberType" value="0" title="下载增员数据" checked>' +
                '               <input type="radio" name="memberType" value="1" title="下载减员数据">' +
                '               <input type="radio" name="memberType" value="2" title="下载变更数据">' +
                '           </div>' +
                '       </div>' +
                '       <div class="layui-form-item hide" id="selectType1">' +
                '           <label class="layui-form-label">选择方式</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="memberType" value="3" title="下载增/减/变通用数据">' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['确定下载','取消'],
            title: "下载增/减/变员数据",
            area: ["800px", "500px"],
        }, function () {
            if ($("#payPlaceId2").val() == "") {
                layer.tips('请选择缴金地', '#payPlaceDiv', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#payPlaceId2").focus();
                return false;
            }



            if ($("input[name=memberType]:checked").val() == 3) {
                window.location.href = AM.ip + "/export/exportUser?payPlaceId=" + $("#payPlaceId2").val()
                        + "&organizationId=" + $("#organizationId2").val()
                        + "&transactorId=" + $("#transactorId2").val()
                        + "&transactorName=" + $("#transactorId2 option:selected").text()
                        + "&companyId=" + $("#companyId2").val()
                        + "&target=" + $("input[name=type]:checked").val()
                        + "&isTuo=" + $("input[name=isTuo]:checked").val()
            }
            else {
                window.location.href = AM.ip + "/export/exportUser?payPlaceId=" + $("#payPlaceId2").val()
                        + "&organizationId=" + $("#organizationId2").val()
                        + "&transactorId=" + $("#transactorId2").val()
                        + "&transactorName=" + $("#transactorId2 option:selected").text()
                        + "&companyId=" + $("#companyId2").val()
                        + "&target=" + $("input[name=type]:checked").val()
                        + "&flag=" + $("input[name=memberType]:checked").val()
                        + "&isTuo=" + $("input[name=isTuo]:checked").val()
            }

        }, function () {});
        queryAllCompany(0, "companyId2", null, 0);
        getPayPlaceByType(0, "payPlaceId2", "post", 0, 0);
        form.render();
    }

    /**查看备注**/
    function findRemark (remark) {
        var remarks = remark;
        if (remarks == null) {
            layer.msg("暂无备注");
            return false;
        }
        var html = "<ol class='remark-list'>";
        for (var i = 0; i < remarks.length; i++) {
            var obj = remarks[i];
            html += '<li>' + (i + 1) + '、' + obj.userName + '： ' + obj.remark + '</li>';
        }
        html += '</ol>';
        layer.open({
            title: "查看备注",
            type: 1,
            area: ['600px', '400px'], //宽高
            content: html
        });
    }

    /**添加备注**/
    function addRemark (id) {
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">备注</label>' +
                '           <div class="layui-input-block">' +
                '               <textarea class="layer-textarea" id="remark" placeholder="请输入备注"></textarea>' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['确定','取消'],
            title: "添加备注",
            area: ["600px", "500px"],
        }, function () {
            if ($("#remark").val() == "") {
                layer.tips('请输入备注', '#remark', {
                    tips: [1, '#000'],
                    time: 3000
                });
                $("#remark").focus();
                return false;
            }
            var parameter = {
                id : id,
                remark : $("#remark").val()
            }
            AM.ajaxRequestData("post", false, AM.ip + "/memberBusinessUpdateRecord/addRemark", parameter, function (result) {
                layer.msg("添加备注成功.");
                dataTable.ajax.reload();
            });
        }, function () {});
    }

    /**触发文件**/
    function uploadAdd(type) {
        $("#File").click();
    }

    /**上传文件获取地址**/
    function onChangeFile (obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
        $("#kaoPanFile").html(file.name);
        var fr = new FileReader();
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

    /**删除上传的文件**/
    function deleteData (url) {
        $.ajax({
            type: "POST",
            url: AM.ip + "/res/delete",
            data: { url : url },
            success: function () {}
        });
    }


    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        getPayPlaceByType1(0, "payPlaceId", "post", 0, null);
        queryAllCompany(0, "companyId", null, 0);
        form.render();

        //监听缴金地--类型
        form.on('select(payPlaceType)', function (data) {
            getPayPlaceByType(0, "payPlaceId", "post", 0, data.value);
            form.render();
        });

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

        //监听缴金地
        form.on('select(payPlaceFilter2)', function (data) {
            getOrganizationByPayPlace(0, "organizationId2", "post", 0, data.value);
            if (data.elem[data.elem.selectedIndex].text.indexOf("成都") >= 0 && $("input[name=type]:checked").val() == 0) {
                $("#selectType").show();
                $("#selectType1").hide();
                $("input[name=memberType]").eq(0).prop("checked", true);
            }
            else {
                $("#selectType").hide();
                $("#selectType1").show();
                $("input[name=memberType]").eq(3).prop("checked", true);
            }
            form.render();
        });

        //城市类型
        form.on('select(cityType)', function (data) {
            if (data.value == 1 && $("input[name=type]:checked").val() == 0) {
                $("#selectType").show();
                $("#selectType1").hide();
                $("input[name=flag]").eq(0).prop("checked", true);
            }
            else {
                $("#selectType").hide();
                $("#selectType1").show();
                $("input[name=flag]").eq(3).prop("checked", true);
            }
            form.render();
        });

        //监听社保type
        form.on('radio(type)', function (data) {
            var isTuo = $("input[name='isTuo']:checked").val();
            if (data.value == 0) {
                if(isTuo == 1){
                    // 禁用其他缴金地以及办理方的选项
                    $("#bigDiv").hide("fast");
                    getCompanyPayPlaceByType(0, "payPlaceId2", "post", 0, data.value,null);
                }else{
                    $("#bigDiv").show("fast");
                    getPayPlaceByType(0, "payPlaceId2", "post", 0, 0);
                    if ($("select[name=cityType]").val() == 0) {
                        $("#selectType").hide();
                        $("#selectType1").show();
                        $("input[name=flag]").eq(3).prop("checked", true);
                    }
                    else {
                        $("#selectType").show();
                        $("#selectType1").hide();
                        $("input[name=flag]").eq(0).prop("checked", true);
                    }
                    $("input[name=memberType]").eq(0).prop("checked", true);
                }
            }
            else {
                if(isTuo == 1){
                    // 禁用其他缴金地以及办理方的选项
                    $("#bigDiv").hide("fast");
                    getCompanyPayPlaceByType(0, "payPlaceId2", "post", 0, data.value,null);
                }
                else{
                    $("#bigDiv").show("fast");
                    getPayPlaceByType(0, "payPlaceId2", "post", 0, 1);
                    $("#selectType").hide();
                    $("#selectType1").show();
                    $("input[name=memberType]").eq(3).prop("checked", true);
                    $("input[name=flag]").eq(3).prop("checked", true);
                }
            }
            form.render();
        });

        //监听是否托管type
        form.on('radio(isTuo)', function (data) {
            var type = $("input[name='type']:checked").val();
            if (data.value == 1) {
                // 禁用其他缴金地以及办理方的选项
                $("#bigDiv").hide("fast");
                getCompanyPayPlaceByType(0, "payPlaceId2", "post", 0, type,null);
            }
            else {
                $("#bigDiv").show("fast");
                getPayPlaceByType(0, "payPlaceId2", "post", 0, 1);
            }
            form.render();
        });

        //监听经办机构
        form.on('select(organizationFilter2)', function (data) {
            var text = $(data.elem).find("option:selected").text();
            var type = $("input[name='type']:checked").val();
            var arr  = {
                organizationId : data.value,
                organizationName : text,
                type : type
            }
            getTransactorByOrganization(0, "transactorId2", "post", null, data.value);
            form.render();
        });

        form.on('checkbox(allSelected)', function (data) {
            if (data.elem.checked) {
                $("input[name=memberBusinessUpdateRecordId]").prop("checked", true);
            }
            else {
                $("input[name=memberBusinessUpdateRecordId]").prop("checked", false);
            }
            form.render();
        });

    });



</script>
</body>
</head>
</html>
