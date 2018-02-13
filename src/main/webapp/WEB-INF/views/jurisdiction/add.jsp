<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加权限</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>.dx-manage-info{padding-top:23px!important;padding-left:38px;padding-right:38px;position:relative}.dx-manage-info .btn-box{position:absolute;right:0}.dx-manage-info .btn-box .layui-btn{width:120px}.dx-manage-info h2.title{font-size:16px;color:#333;border-left:solid 5px #fab530;padding-left:7px}.dx-manage-info .waterfall-box{-webkit-column-width:300px;-moz-column-width:300px;-o-colum-width:300px}.dx-manage-info .function-box{background-color:#f0f2f5;border:solid 1px #e4e4e4;margin-top:15px;margin-bottom:15px;width:300px;position:relative;padding-top:50px;display:inline-block;margin-right:10px}.dx-manage-info .function-box h5.title{width:100%;border:solid 1px #a5abb7;background-color:#a5abb7;color:#fff;font-size:14px;line-height:30px;position:absolute;top:-1px;left:-1px}.dx-manage-info .function-box h5.title i{margin-right:5px;margin-left:10px}.dx-manage-info .function-box .list-item{padding-bottom:5px}.dx-manage-info .function-box .list-item li{padding-left:30px}.dx-manage-info .function-box .list-item li:first-child{padding-left:0}.dx-manage-info .function-box .list-item .layui-form-checkbox{padding-left:30px;padding-right:0}.dx-manage-info .function-box .list-item .layui-form-checkbox i{left:-7px}.dx-manage-info.type-info .btn-box{display:none}.dx-manage-info.dx-info-box.type-info input{border:solid 1px #e6e6e6!important}.dx-manage-info.dx-info-box.type-info .layui-checkbox-disbaled.layui-form-checked:hover i{color:#e2e2e2!important}.dx-manage-info.dx-info-box.type-info .layui-checkbox-disbaled.layui-form-checked{border-color:#e2e2e2!important}.dx-manage-info.dx-info-box.type-info .layui-checkbox-disbaled.layui-form-checked span{background-color:#e2e2e2!important}.layui-form-checkbox.layui-form-checked.layui-checkbox-disbaled.layui-disabled i{color: #e2e2e2!important}</style>

</head>
<body>
<div style="margin: 15px;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加权限&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
    </fieldset>
    <section class="dx-info-default">
        <div class="dx-info-box dx-manage-info">
            <form class="layui-form layui-form-pane dx-form-pane" id="dataForm">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">角色</label>
                        <div class="layui-input-block">
                            <select id="roleId" name="roleId" lay-verify="required" lay-search="" lay-filter="role">
                                <option value="">选择或搜索角色</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-block">
                            <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                </div>

                <h2 class="title">角色功能选择</h2>
                <div style="padding-top: 15px;margin-left: -10px;">
                    <input id="checkboxAll" type="checkbox" title="全选" lay-filter="checkboxAll">
                </div>
                <div class="waterfall-box" id="menuList"></div>

            </form>
        </div>
    </section>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var form = null;
    function initData (roleId) {
        var isAllChecked = false; //是否没有全选
        //监听select事件--用户类型过滤器
        AM.ajaxRequestData("get", false, AM.ip + "/menu/findAllMenu", {roleId : roleId} , function(result) {
            if (result.flag == 0 && result.code == 200) {
                var menuList = result.data;
                var html = "";
                for (var i = 0; i < menuList.length; i++) { //第一级
                    var oneChildHtml = menuPackaging(menuList[i].child);

                    var oneInput = "";
                    if (menuList[i].spread) {
                        oneInput = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" lay-filter="checkbox" parentCheckBox="true" checked>';
                    }
                    else {
                        isAllChecked = true;
                        oneInput = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" lay-filter="checkbox" parentCheckBox="true">';
                    }
                    html += '<div class="function-box">' +
                            '<h5 class="title"><i class="fa ' + menuList[i].icon + '"></i>' + menuList[i].title + '</h5>' +
                            '<ul class="list-item">' +
                            '<li>' + oneInput + '</li>' +
                            oneChildHtml +
                            '</ul>' +
                            '</div>';
                }
                $("#menuList").html(html);
                AM.log(isAllChecked);
                if (isAllChecked) {
                    $("#checkboxAll").prop("checked", false);
                }
                else {
                    $("#checkboxAll").prop("checked", true);
                }
                form.render(); //重新渲染
            }
        });

    }

    layui.use(['form', 'layedit', 'laydate'], function() {
        form = layui.form(),
                layer = layui.layer;

        getRoleList(0);
        initData(null);
        form.render(); //重新渲染

        form.on('select(role)', function(data){
            var index = layer.load(1, {shade: [0.5,'#eee']});
            initData(data.value);
            setTimeout(function () {layer.close(index);}, 600);
            form.render(); //重新渲染
        });

        // 监听checkbox点击
        form.on('checkbox(checkbox)', function (data) {
            AM.log(data);
            var $elem = $(data.elem);
            var $parent = $(data.elem).parent().parent();
            // 判断是否全选
            AM.log($elem.attr('parentCheckBox') == "true");
            if ($elem.attr('parentCheckBox') == "true") {
                AM.log($elem.is(":checked"));
                if ($elem.is(":checked")) {
                    $parent.find('.layui-form-checkbox').addClass('layui-form-checked');
                    $parent.find('input[type="checkbox"]').prop("checked", true);
                    form.render(); //重新渲染
                } else {
                    $parent.find('.layui-form-checkbox').removeClass('layui-form-checked');
                    $parent.find('input[type="checkbox"]').prop("checked", false);
                    form.render(); //重新渲染
                }
            } else {
                if (!$elem.is(":checked")) {
                    $parent.find('input[parentCheckBox]').eq(0).next('.layui-form-checkbox').removeClass('layui-form-checked')
                    form.render(); //重新渲染
                }
            }
            form.render(); //重新渲染
        });

        //全选
        form.on('checkbox(checkboxAll)', function (data) {
            if (data.elem.checked) {
                $("input[type=checkbox]").prop("checked", true);
            }
            else {
                $("input[type=checkbox]").prop("checked", false);
            }
            form.render(); //重新渲染
        });


            //监听提交
        form.on('submit(demo1)', function(data) {
            AM.log(data);
            AM.log(data.elem)
            AM.log(data.field);
            var arr = [];
            $("#menuList input[type='checkbox']").each(function () {
                if ($(this).is(':checked')) {
                    arr.push($(this).val());
                }
            });
            data.field.keyIds = JSON.stringify(arr);
            AM.log(data.field);
            AM.ajaxRequestData("post", false, AM.ip + "/roleUrl/addRoleUrl", data.field , function(result) {
                if (result.flag == 0 && result.code == 200) {
                    var index = layer.alert('添加成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        window.parent.location.reload();
                        layer.close(index);
                    });
                }
            });
            return false;
        });
    });


    /**
     * 给菜单封包  拼接菜单
     *
     * @param menuList
     */
    function menuPackaging(menuList) {
        var html = "";
        for (var i = 0 ; i < menuList.length ; i ++) {
            var childHtml = "";
            if (menuList[i].spread) {
                if ($("#roleId").val() == 1 && menuList[i].id == 3) {
                    childHtml = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" lay-filter="checkbox" checked disabled>';
                    $(".dx-info-box").addClass('type-info');
                }
                else {
                    if (menuList[i].child.length > 0) {
                        childHtml = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" parentCheckBox="true" lay-filter="checkbox" checked>';
                    }
                    else {
                        childHtml = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" lay-filter="checkbox" checked>';
                    }
                }
            }
            else {
                isAllChecked = true;
                if (menuList[i].child.length > 0) {
                    childHtml = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" parentCheckBox="true" lay-filter="checkbox">';
                }
                else {
                    childHtml = '<input type="checkbox" value="' + menuList[i].id + '" title="' + menuList[i].title + '" lay-filter="checkbox">';
                }
            }
            html += '<li>' +
                    '   <ul class="list-item">' +
                    '       <li>' + childHtml + '</li>' +
                            menuPackaging(menuList[i].child) +
                    '   </ul>' +
                    '</li>';
        }
        return html;
    }


</script>
</body>
</html>
