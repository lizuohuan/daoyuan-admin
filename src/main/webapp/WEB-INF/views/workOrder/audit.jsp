<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>处理工单</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/speed.css">

    <style>
        html,body{width: 100%;}
        .row{overflow: hidden}
        .col-xs-6{
            float: left;
            width: 50%;
            box-sizing: border-box;
        }
        .layui-elem-field{
            min-height: 500px;
        }
    </style>
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<div style="margin: 15px;">
    <div class="row">
        <div class="col-xs-6">
            <fieldset class="layui-elem-field">
                <legend>处理工单&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
                </legend>
                <div class="layui-field-box layui-form">
                    <form class="layui-form" action="" id="formData">

                        <div class="layui-form-item">
                            <label class="layui-form-label">经办人:</label>
                            <div class="layui-input-inline">
                                <div class="layui-input" style="background: #eee;">{{workOrder.userName == null ? workOrder.roleName : workOrder.userName}}</div>
                            </div>
                        </div>

                        <div ng-show="workOrder.serviceType == 7">
                            <div class="layui-form-item">
                                <label class="layui-form-label">处理意见<span class="font-red">*</span></label>
                                <div class="layui-input-block">
                                    <input type="radio" name="type" value="0" title="转处理" checked lay-filter="type">
                                    <input type="radio" name="type" value="1" title="结束工单" lay-filter="type">
                                    <input type="radio" name="type" value="2" title="退回上一级经办人" lay-filter="type">
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <label class="layui-form-label">经办类型<span class="font-red">*</span></label>
                                <div class="layui-input-inline">
                                    <input type="radio" name="handleType" value="0" title="用户" checked lay-filter="handleType">
                                    <input type="radio" name="handleType" value="1" title="角色" lay-filter="handleType">
                                </div>
                            </div>

                            <div class="layui-form-item">
                                <label class="layui-form-label">下一个经办人<span class="font-red">*</span></label>
                                <div class="layui-input-inline">
                                    <select name="userId">
                                        <option value="">请选择</option>
                                    </select>
                                </div>
                            </div>

                            <div class="layui-form-item hide">
                                <label class="layui-form-label">下一个经办人<span class="font-red">*</span></label>
                                <div class="layui-input-inline">
                                    <select name="roleId">
                                        <option value="">请选择</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">上传附件</label>
                            <div class="layui-input-block">
                                <button type="button" onclick="$('#File').click();" class="layui-btn layui-btn-small layui-btn-normal">选择文件</button>
                                <span class="layui-inline layui-upload-choose" id="kaoPanFile"></span>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">处理方式</label>
                            <div class="layui-input-block">
                                <textarea name="remark" style="min-height:80px;width: 300px;max-width: 300px;min-width: 300px;" placeholder="请输入处理方式"></textarea>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button class="layui-btn" lay-submit="" lay-filter="demo1">提交</button>
                                <button  ng-show="workOrder.serviceType != 7" class="layui-btn layui-btn-danger" lay-submit="" lay-filter="disagree">不同意</button>
                            </div>
                        </div>
                    </form>
                </div>
            </fieldset>
        </div>

        <div class="col-xs-6">
            <fieldset class="layui-elem-field">
                <legend>工单进度&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
                </legend>
                <div class="layui-field-box layui-form">
                    <div class="intro-flow">
                        <div class="intro-list" ng-repeat="order in workOrderScheduleList">
                            <div class="intro-list-left">
                                <%--业务受理--%>
                            </div>
                            <div class="intro-list-right">
                                <span>{{ workOrderScheduleList.length - $index }}</span>
                                <div class="intro-list-content">
                                    <img class="intro-img" ng-if="detail.avatar == null" src="<%=request.getContextPath()%>/resources/img/0.jpg" >
                                    <div class="content">
                                        <p>申请人：{{order.proposerName}}</p>
                                        <p ng-if="order.status != 0">经办人：{{order.userName == null ? order.roleName : order.userName}}</p>
                                        <p>状态：
                                            <span ng-if="order.status == 0" style="color: green">已申请</span>
                                            <span ng-if="order.status == 1" style="color: orange">已处理</span>
                                            <span ng-if="order.status == 2" style="color: red">不同意</span>
                                            <span ng-if="order.status == 3">完成</span>
                                            <span ng-if="order.status == 4" style="color: #666">作废</span>
                                            <span ng-if="order.status == 5" style="color: #666">待确认</span>
                                        </p>
                                        <p ng-if="order.status == 0">申请时间：{{order.createTime | date : "yyyy-MM-dd hh:mm:ss"}}</p>
                                        <p ng-if="order.status != 0">处理时间：{{order.createTime | date : "yyyy-MM-dd hh:mm:ss"}}</p>
                                        <p ng-if="order.accessory != null && order.accessory != ''">附件：
                                            <a ng-if="!order.isContains" style="color: #1E9FFF;" href="<%=request.getContextPath()%>/{{order.accessory}}" target="_blank">下载</a>
                                            <a ng-if="order.isContains" style="color: #1E9FFF;" href="<%=request.getContextPath()%>/page/workOrder/preview?url={{order.accessory}}" target="_blank">查看预览</a>
                                        </p>
                                        <p ng-if="order.status == 0">申请内容：{{order.remark}}</p>
                                        <p ng-if="order.status != 0">处理意见：{{order.remark}}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>

</div>

<form id="newUpload" method="post" enctype="multipart/form-data">
    <input id="File" type="file" name="File" class="hide" onchange="onChangeFile(this)">
    <input type="hidden" name="type" value="1">
</form>

<input type="hidden" id="fileUrl">

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/resources/js/jquery.form.js" type="text/javascript" charset="UTF-8"></script>

<script>
    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope){
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/workOrder/info", {id : $scope.id} , function(result) {
            $scope.workOrder = result.data;
            if ($scope.workOrder.proposerId == AM.getUserInfo().id && $scope.workOrder.status == 5) {
                $("input[name=type]").eq(0).prop("disabled", true);
                $("input[name=type]").eq(1).prop("checked", true);
                $("input[name=handleType]").parent().parent().hide();
            }
        });

        /**获取工单进度**/
        AM.ajaxRequestData("get", false, AM.ip + "/workOrderSchedule/list", {workOrderId : $scope.id} , function(result) {
            $scope.workOrderScheduleList = result.data;
            for (var i = 0; i < $scope.workOrderScheduleList.length; i++) {
                var obj = $scope.workOrderScheduleList[i];
                obj.isContains = false;
                if (obj.accessory.indexOf(".png") != -1 ||
                        obj.accessory.indexOf(".gif") != -1 ||
                        obj.accessory.indexOf(".jpg") != -1
                ) {
                    obj.isContains = true;
                }
            }
        });

        layui.use(['form', 'layedit'], function() {
            var form = layui.form();
            if ($scope.workOrder.proposerId == AM.getUserInfo().id && $scope.workOrder.status == 5) {
                $("select[name=userId]").parent().parent().hide();
                $(".layui-btn-danger").hide();
            }
            else {
                getUserList(0);
                if ($scope.workOrder.serviceType == 7) {
                    $("select[name=userId]").attr("lay-verify", "required");
                }
            }

            form.render();

            form.on("radio(handleType)", function (data) {
                if (data.value == 0) {
                    $("select[name=userId]").parent().parent().show();
                    $("select[name=roleId]").parent().parent().hide();
                    $("select[name=roleId]").val("");
                    $("select[name=userId]").attr("lay-verify", "required");
                    $("select[name=roleId]").removeAttr("lay-verify");
                }
                else {
                    $("select[name=userId]").val("");
                    $("select[name=userId]").parent().parent().hide();
                    $("select[name=roleId]").attr("lay-verify", "required");
                    $("select[name=userId]").removeAttr("lay-verify");
                    getRoleList(0);
                    form.render();
                }
            });

            form.on("radio(type)", function (data) {
                if (data.value == 0) {
                    $("select[name=userId]").attr("lay-verify", "required");
                    $("select[name=roleId]").attr("lay-verify", "required");
                    $("input[name=handleType]").parent().parent().show();
                    $("select[name=userId]").parent().parent().show();
                }
                else {
                    $("input[name=handleType]").parent().parent().hide();
                    $("select[name=roleId]").parent().parent().hide();
                    $("select[name=userId]").parent().parent().hide();
                    $("select[name=userId]").removeAttr("lay-verify");
                    $("select[name=roleId]").removeAttr("lay-verify");
                }
                if (data.value == 2) {
                    $("#higherUp").show();
                }
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.status = 1;
                data.field.serviceType = $scope.workOrder.serviceType;
                data.field.nextUserId = data.field.userId;
                data.field.nextRoleId = data.field.roleId;
                data.field.roleId = $scope.workOrder.roleId;
                data.field.userId = $scope.workOrder.userId;
                if ($scope.workOrder.serviceType == 0 || $scope.workOrder.serviceType == 1 || $scope.workOrder.serviceType == 3 || $scope.workOrder.serviceType == 4 || $scope.workOrder.serviceType == 5) {
                    data.field.roleId = AM.getUserInfo().roleId;
                    //后道主管
                    if (AM.getUserInfo().roleId == 14) {
                        data.field.status = 5;
                    }
                }
                else if ($scope.workOrder.serviceType == 2) {
                    data.field.roleId = AM.getUserInfo().roleId;
                    //后道客服
                    if (AM.getUserInfo().roleId == 10) {
                        data.field.status = 5;
                    }
                }
                else if ($scope.workOrder.serviceType == 6) {
                    data.field.roleId = AM.getUserInfo().roleId;
                    //前道组长
                    if (AM.getUserInfo().roleId == 5) {
                        data.field.status = 5;
                    }
                }

                //前道客户提交
                if (AM.getUserInfo().roleId == 9 && $scope.workOrder.status == 5) {
                    data.field.status = 3;
                }

                if ($scope.workOrder.serviceType == 7) {
                    if (data.field.type == 1) {
                        data.field.status = 5; //结束返回申请人确认
                        data.field.nextUserId = $scope.workOrder.proposerId;
                        if ($scope.workOrder.proposerId == AM.getUserInfo().id) {
                            data.field.status = 3
                        }
                    }
                    else if (data.field.type == 2) { //返回上一级
                        AM.ajaxRequestData("get", false, AM.ip + "/workOrderSchedule/getNextWorkOrderSchedule", {workOrderId : $scope.id} , function(result) {
                            if (result.data.userId == null && result.data.roleId == null) {
                                data.field.status = 2;
                                data.field.nextUserId = result.data.proposerId;
                            }
                            else {
                                if (result.data.userId != null) {
                                    data.field.nextUserId = result.data.userId;
                                }
                                else {
                                    data.field.nextRoleId = result.data.roleId;
                                }
                                data.field.roleId = AM.getUserInfo().roleId;
                                data.field.userId = AM.getUserInfo().id;
                                data.field.status = 2;
                            }
                        });
                    }
                }

                data.field.workOrderId = $scope.id;
                data.field.proposerId = $scope.workOrder.proposerId;
                data.field.accessory = $("#fileUrl").val();
                AM.log(data.field);
                AM.ajaxRequestData("post", false, AM.ip + "/workOrderSchedule/add", data.field, function(result) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });

            //不同意提交 -- 固定流程
            form.on('submit(disagree)', function(data) {
                data.field.status = 2;
                if ($scope.workOrder.serviceType == 0 || $scope.workOrder.serviceType == 1 || $scope.workOrder.serviceType == 3 || $scope.workOrder.serviceType == 4 || $scope.workOrder.serviceType == 5) {
                    //后道主管
                    if ($scope.workOrder.roleId == 14) {
                        data.field.roleId = 2;
                    }
                    //总经理
                    else if ($scope.workOrder.roleId == 2) {
                        data.field.roleId = 4;
                    }
                    //前道主管
                    if ($scope.workOrder.roleId == 4) {
                        data.field.status = 4;
                        data.field.roleId = AM.getUserInfo().roleId;
                    }
                }
                else if ($scope.workOrder.serviceType == 2) {
                    //前道组长
                    if ($scope.workOrder.roleId == 10) {
                        data.field.roleId = 5;
                    }
                    //前道组长
                    else if ($scope.workOrder.roleId == 5) {
                        //前道组长-- 没有上一级直接作废
                        data.field.status = 4;
                        data.field.roleId = AM.getUserInfo().roleId;
                    }
                }
                else if ($scope.workOrder.serviceType == 6) {
                    //前道组长 -- 没有上一级直接作废
                    data.field.status = 4;
                }
                data.field.serviceType = $scope.workOrder.serviceType;
                data.field.workOrderId = $scope.id;
                data.field.proposerId = $scope.workOrder.proposerId;
                data.field.accessory = $("#fileUrl").val();
                AM.log(data.field);
                AM.ajaxRequestData("post", false, AM.ip + "/workOrderSchedule/add", data.field, function(result) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                    window.parent.closeNodeIframe();
                });
                return false;
            });
        });
    });


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

</script>
</body>
</html>
