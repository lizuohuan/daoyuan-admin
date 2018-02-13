<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>员工列表</title>
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
                            <label class="layui-form-label">公司</label>
                            <div class="layui-input-inline">
                                <input type="text" id="companyName" placeholder="公司" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">员工</label>
                            <div class="layui-input-inline">
                                <input type="text" id="userName" placeholder="员工" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">身份证号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="certificateNum" placeholder="身份证号" autocomplete="off" class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">合作状态</label>
                            <div class="layui-input-inline">
                                <select id="stateCooperation">
                                    <option value="">请选择</option>
                                    <option value="0">离职</option>
                                    <option value="1">在职</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">合作方式</label>
                            <div class="layui-input-inline">
                                <select id="waysOfCooperation">
                                    <option value="">请选择</option>
                                    <option value="0">普通</option>
                                    <option value="1">派遣</option>
                                    <option value="2">外包</option>
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
        <legend>员工列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_77"><i
                        class="layui-icon">
                    &#xe608;</i> 添加员工
                </button>
                <button onclick="downLoadAddUserTemplate()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_151"><i class="fa fa-cloud-download"></i> 下载模版</button>
                <button onclick="uploadFile(0)"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_152"><i class="fa fa-cloud-upload"></i> 上传新增员工
                </button>
                <button onclick="uploadFile(1)"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_153"><i class="fa fa-cloud-upload"></i> 上传减员
                </button>
                <button onclick="uploadFile(2)"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_160"><i class="fa fa-cloud-upload"></i> 上传批量修改员工
                </button>
                <button onclick="downLoadEditMember()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_159"><i class="fa fa-cloud-upload"></i> 下载批量修改员工
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th><input type="checkbox" name="allSelected" lay-skin="primary" lay-filter="allSelected" ></th>
                    <th>员工编号</th>
                    <th>员工</th>
                    <th>证件类型</th>
                    <th>证件编号</th>
                    <th>工作地点</th>
                    <th>所属公司</th>
                    <th>所属部门</th>
                    <th>合作状态</th>
                    <th>合作方式</th>
                    <th>创建时间</th>
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

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
<script>

    var form = null;
    var dataTable = null;
    $(document).ready(function () {
        dataTable = $('#dataTable').DataTable({
            "iDisplayLength" : 30, //默认显示的记录数
            "bLengthChange" : false, //改变每页显示数据数量
            "searching": false,
            "bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
            "processing": true,
            "serverSide": true,
            "bSort": false, //关闭排序功能
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
                url: AM.ip + "/member/list",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.userName = $("#userName").val();
                    data.certificateNum = $("#certificateNum").val();
                    data.companyName = $("#companyName").val();
                    data.stateCooperation = $("#stateCooperation").val();
                    data.waysOfCooperation = $("#waysOfCooperation").val();
                    data.beforeService = $("#beforeService").val();
                }
            },
            "columns":[
                {"data": ""},
                {"data": "id"},
                {"data": "userName"},
                {"data": "certificateType"},
                {"data": "certificateNum"},
                {"data": "cityName"},
                {"data": "companyName"},
                {"data": "department"},
                {"data": "stateCooperation"},
                {"data": "waysOfCooperation"},
                {"data": "createTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return '<input type="checkbox" value="' + row.id + '" name="memberId" lay-skin="primary">';
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
                        } else {
                            return "港澳台通行证";
                        }
                    },
                    "targets": 3
                },
                {
                    "render": function (data, type, row) {
                        return data == null ? "--" : data;
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "离职";
                        }
                        else if (data == 1) {
                            return "在职";
                        } else {
                            return "--";
                        }

                    },
                    "targets": 8
                },
                {
                    "render": function (data, type, row) {
                        if (data == 0) {
                            return "普通";
                        }
                        else if (data == 1) {
                            return "派遣";
                        } else {
                            return "外包";
                        }
                    },
                    "targets": 9
                },
                {
                    "render": function (data, type, row) {
                       return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 10
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_78'><i class='fa fa-list fa-edit'></i>&nbsp;修改</button>";
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

        form.on('checkbox(allSelected)', function (data) {
            if (data.elem.checked) {
                $("input[name=memberId]").prop("checked", true);
            }
            else {
                $("input[name=memberId]").prop("checked", false);
            }
            form.render();
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
            title: '添加员工',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/member/add"
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改员工',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/member/edit?id=" + id
        });
        layer.full(index);
    }

    /**下载模版**/
    function downLoadAddUserTemplate () {
        var html = '<form class="layui-form" action="">' +
                '       <div class="layui-form-item">' +
                '           <label class="layui-form-label">选择类型</label>' +
                '           <div class="layui-input-block">' +
                '               <input type="radio" name="flag" value="0" title="新增模版" checked>' +
                '               <input type="radio" name="flag" value="1" title="减员模版">' +
                '           </div>' +
                '       </div>' +
                '   </form>';
        layer.confirm(html, {
            btn: ['确定下载','取消'],
            title: "下载增/减员模版",
            area: ["600px", "500px"],
        }, function () {
            window.location.href = AM.ip + "/export/downLoadUserTemplate?flag=" + $("input[name=flag]:checked").val();
        }, function () {});
        form.render();
    }

    layui.use(['form'], function () {
        form = layui.form();
        getUserByRole(0,"beforeService",0,9);
    });

    var flag = null;
    /**上传**/
    function uploadFile(flag_) {
        flag = flag_;
        $("#File").click();
    }

    function downLoadEditMember(){
        var members = [];
        $("input[name='memberId']:checked").each(function(){
            members[members.length] = $(this).val();
        })
        if(members.length == 0){
            layer.msg("请选择需要修改的员工");
            return;
        }
        window.open(AM.ip + '/export/exportEditMember?ids='+JSON.stringify(members));
    }


    function onChangeFile (obj) {
        var index = layer.load(1, {shade: [0.5, '#eee']});
        var file = obj.files[0];
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
                            AM.ajaxRequestData("post", false, AM.ip + "/import/importMember", {
                                url : AM.ip + "/" +result.data.url,flag:flag
                            }, function (result) {
                                layer.msg(result.msg);
                            });
                            $.ajax({
                                type: "POST",
                                url: AM.ip + "/res/delete",
                                data: { url : result.data.url },
                                success: function () {AM.log("delete.");}
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
