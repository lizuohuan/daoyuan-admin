<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>用户列表</title>
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
                                <input type="text" name="userName" id="userName" lay-verify=""
                                       placeholder="按姓名搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>

                        <div class="layui-inline">
                            <label class="layui-form-label">手机号</label>
                            <div class="layui-input-inline">
                                <input type="text" id="phone" lay-verify="" placeholder="请输入工作手机号或者私人手机号" autocomplete="off"
                                       class="layui-input" maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">角色</label>
                            <div class="layui-input-inline">
                                <select name="roleId" id="roleId" lay-verify="required" lay-search>
                                    <option value="">选择角色搜索</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">账号</label>
                            <div class="layui-input-inline">
                                <input type="text" name="account" id="account" lay-verify=""
                                       placeholder="按账号搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">邮箱</label>
                            <div class="layui-input-inline">
                                <input type="text" name="email" id="email" lay-verify="isEmail"
                                       placeholder="按邮箱搜索" autocomplete="off" class="layui-input"
                                       maxlength="20">
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
        <legend>用户列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        </legend>
        <div class="layui-field-box layui-form">
            <blockquote class="layui-elem-quote">
                <button onclick="addData()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide checkBtn_23"><i
                        class="layui-icon">
                    &#xe608;</i> 添加用户
                </button>
                <button onclick="userExcel()"
                        class="layui-btn layui-btn layui-btn-small layui-btn-normal hide"><i
                        class="layui-icon">
                    &#xe608;</i> 选择导入用户类型
                </button>
            </blockquote>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>姓名</th>
                    <th>账号</th>
                    <th>工作手机号</th>
                    <th>私人手机号</th>
                    <th>邮箱</th>
                    <th>角色</th>
                    <th>注册时间</th>
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
                url: AM.ip + "/user/queryUserList",
                "dataSrc": function (json) {
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.userName = $("#userName").val();
                    data.phone = $("#phone").val();
                    data.roleId = $("#roleId").val();
                    data.account = $("#account").val();
                    data.email = $("#email").val();
                }
            },
            "columns":[
                {"data": "userName"},
                {"data": "account"},
                {"data": "workPhone"},
                {"data": "homePhone"},
                {"data": "email"},
                {"data": "roleName"},
                {"data": "createTime"},
                {"data": "isValid"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        if (data == null || data == "") {
                            return "--";
                        }
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 6
                },
                {
                    "render": function (data, type, row) {
                        if (null != data) {
                            if (data == 0) {
                                return "注销";
                            }
                            if (data == 1) {
                                return "正常";
                            }
                        } else {
                            return "--";
                        }
                    },
                    "targets": 7
                },
                {
                    "render": function (data, type, row) {
                        var btn = "";
                        if (row.isValid == 0) {
                            btn += "<button onclick='updateStatus(" + row.id + ",1)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_20'><i class='fa fa-list fa-edit'></i>&nbsp;激活</button>";
                        }
                        if (row.isValid == 1) {
                            btn += "<button onclick='updateStatus(" + row.id + ",0)' class='layui-btn layui-btn-small layui-btn-normal hide checkBtn_21'><i class='fa fa-list fa-edit'></i>&nbsp;冻结</button>";
                        }
                        btn += "<button onclick='updateData(" + row.id + ")' class='layui-btn layui-btn-small hide checkBtn_22'><i class='fa fa-list fa-edit'></i>&nbsp;查看/修改</button>";
                        btn += "<button onclick='resetPassword(" + row.id + ")' class='layui-btn layui-btn-danger layui-btn-small hide checkBtn_157'>重置密码</button>";
                        return  btn;
                    },
                    "targets": 8
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
            title: '添加课程',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/user/save"
        });
        layer.full(index);
    }

    //查看/修改数据
    function updateData(id) {
        var index = layer.open({
            type: 2,
            title: '修改课程',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + "/page/user/edit?id=" + id
        });
        layer.full(index);
    }


    //修改用户状态
    function updateStatus(id, status) {
        var statusMsg = "是否激活账户?";
        if (status == 0) {
            statusMsg = "是否冻结账户?";
        }
        var arr = {
            id : id,
            isValid : status
        };
        layer.confirm(statusMsg, function(index){
            AM.ajaxRequestData("post", false, AM.ip + "/user/updateUser", arr, function (result) {
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

    /**重置密码**/
    function resetPassword (id) {
        layer.prompt({
            formType: 1,
            title: '请输入登录密码'
        },function(val, index){
            AM.ajaxRequestData("post", false, AM.ip + "/user/resetPassword", {
                pwd: $.md5(val),
                userId: id,
                loginUrl: AM.ip + "/page/login"
            }, function (result) {
                layer.msg("密码重置成功");
            });
            layer.close(index);
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        getRoleList(0); //角色列表
        //自定义验证规则
        form.verify({
            isNumber: function(value) {
                if(value.length > 0 && !AM.isNumber.test(value)) {
                    return "请输入一个整数";
                }
            },
            isPhone: function(value) {
                if(value.length > 0 && !AM.isMobile.test(value)) {
                    return "请输入一个正确的手机号";
                }
            },
            isEmail: function(value) {
                if(value.length > 0 && !AM.isEmail.test(value)) {
                    return "请输入一个正确的邮箱";
                }
            },
            isNumberChar: function(value) {
                if(value.length > 0 && !AM.isNumberChar.test(value)) {
                    return "只能为数字和字母";
                }
            }

        });
    });





    function updatePassWord(id) {
        layer.prompt({
            formType: 3,
            title: '请输入密码',
            area: ['400px', '200px'] //自定义文本域宽高
        }, function(value, index, elem){
            var arr = {
                id: id,
                pwd: $.md5(value)
            }
            AM.ajaxRequestData("post", false, AM.ip + "/user/update", arr, function (result) {
                if (result.flag == 0 && result.code == 200) {
                    dataTable.ajax.reload();
                    layer.msg('操作成功.', {icon: 1});
                    layer.load(1, {shade: [0.5, '#eee']});
                    setTimeout(function () {
                        layer.closeAll();
                    }, 600);
                }
            });
        });


    }

</script>
</body>
</head>
</html>
