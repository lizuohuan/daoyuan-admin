<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>知识库详情</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{
            min-height: 300px;border: 1px solid #e1e1e1;font-size: 13px;border-radius: 2px;line-height: 24px;padding: 10px;
        }
        .preview img, video{max-width: 100%;}
    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>知识库详情<i class="fa fa-refresh" aria-hidden="true"></i></legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="controller" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">标题</label>
            <div class="layui-input-block">
                <div class="layui-input">{{repository.title}}</div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">创建人</label>
            <div class="layui-input-block">
                <div class="layui-input">{{repository.createUserName}}</div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">最近修改人</label>
            <div class="layui-input-block">
                <div class="layui-input">{{repository.updateUserName}}</div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">最近修改日期</label>
            <div class="layui-input-block">
                <div class="layui-input">{{repository.updateTime | date : "yyyy-MM-dd HH:MM:ss"}}</div>
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label">内部信息<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <script id="interiorInfoEditor" style="height:500px" name="interiorInfo" type="text/plain"></script>

                </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">外部信息<span class="font-red">*</span></label>
                <div class="layui-input-block">
                    <script id="externalInfoEditor" style="height:500px" name="externalInfo" type="text/plain"></script>
            </div>
        </div>

        <%--<div class="layui-form-item">--%>
            <%--<label class="layui-form-label">内部信息</label>--%>
            <%--<div class="layui-input-block">--%>
                <%--<div class="preview" ng-bind-html="repository.interiorInfo | trustHtml"></div>--%>
            <%--</div>--%>
        <%--</div>--%>

        <%--<div class="layui-form-item">--%>
            <%--<label class="layui-form-label">外部信息</label>--%>
            <%--<div class="layui-input-block">--%>
                <%--<div class="preview" ng-bind-html="repository.externalInfo | trustHtml"></div>--%>
            <%--</div>--%>
        <%--</div>--%>

    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script src="<%=request.getContextPath()%>/ue/ueditor.config.js"></script>
<script src="<%=request.getContextPath()%>/ue/ueditor.all.js"></script>
<script src="<%=request.getContextPath()%>/ue/lang/zh-cn/zh-cn.js"></script>
<script>



    var externalInfoEditor = UE.getEditor('externalInfoEditor');
    var interiorInfoEditor = UE.getEditor('interiorInfoEditor');

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.repository = null;
        $scope.id = AM.getUrlParam("id");
        AM.ajaxRequestData("get", false, AM.ip + "/repository/findById", {id : $scope.id} , function(result) {
            $scope.repository = result.data;
            $("#externalInfo").html($scope.repository.externalInfo);
            $("#interiorInfo").html($scope.repository.interiorInfo);
        });
        $(document).ready(function(){
            externalInfoEditor.ready(function() {//编辑器初始化完成再赋值
                externalInfoEditor.setContent($scope.repository.externalInfo);
            });
            interiorInfoEditor.ready(function() {//编辑器初始化完成再赋值
                interiorInfoEditor.setContent($scope.repository.interiorInfo);
            });
            externalInfoEditor.setDisabled('fullscreen');
            interiorInfoEditor.setDisabled('fullscreen');


        });
        layui.use(['form', 'layedit'], function() {
            var form = layui.form();

            form.render();
        });
    });
    //富文本过滤器
    webApp.filter('trustHtml', ['$sce',function($sce) {
        return function(val) {
            return $sce.trustAsHtml(val);
        };
    }]);







</script>
</body>
</html>
