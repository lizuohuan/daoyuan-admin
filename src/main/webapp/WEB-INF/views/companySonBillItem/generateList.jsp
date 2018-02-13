<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>生成账单</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>

<body>

<div class="admin-main">
    <fieldset class="layui-elem-field">
        <div class="layui-field-box layui-form">
            <form class="layui-form">
                <div class="layui-form-item">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="radio" name="type" value="0" title="当前账单月" checked lay-filter="type">
                            <input type="radio" name="type" value="1" title="其他账单月" lay-filter="type">
                        </div>
                    </div>
                </div>

                <blockquote class="layui-elem-quote">
                    <div class="layui-form-item" style="margin-bottom: 0px;">
                        <div class="layui-inline" style="margin-bottom: 0px;">
                            <div class="layui-input-inline">
                                <button type="button" onclick="batchSend()"
                                        class="layui-btn layui-btn layui-btn-small layui-btn-normal">批量生成
                                </button>
                                <button type="button" onclick="generateAll()" id="aKeyGeneration"
                                        class="layui-btn layui-btn layui-btn-small layui-btn-normal">一键生成
                                </button>
                            </div>
                        </div>
                        <div class="layui-inline" style="margin-bottom: 0px;">
                            <div class="layui-input-inline" style="width: 150px;">
                                <input type="text" placeholder="公司名字" id="companyName" class="layui-input" style="height: 30px;position: relative;top:8px;">
                            </div>
                            <div class="layui-form-mid layui-word-aux">
                                <button class="layui-btn layui-btn-small" id="search"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            </div>
                        </div>
                    </div>
                </blockquote>
            </form>
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th style="width:120px"><input type="checkbox" name="allSelected" lay-skin="primary" lay-filter="allSelected"></th>
                    <th>公司名字</th>
                    <th id="theBillingMonth" style='width: 300px;'>账单月</th>
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
//                $(".table-select").parent().hide();
//                $("#theBillingMonth").hide();
                if ($("input[name='type']:checked").val() == 0) {
                    $("#aKeyGeneration").show();
                    $(".table-select").prop("disabled", true);
                    $(".table-select").parent().hide();
                    $("#theBillingMonth").hide();
                }
                else {
                    $("#aKeyGeneration").hide();
                    $(".table-select").prop("disabled", false);
                    $(".table-select").parent().show();
                    $("#theBillingMonth").show();
                }
                form.render();
            },
            "ajax": {
                url: AM.ip + "/company/getOtherCompany",
                "dataSrc": function (json) {
                    AM.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function (data) {
                    //高级查询参数
                    data.companyName = $("#companyName").val();
                }
            },
            "columns":[
                {"data": ""},
                {"data": "companyName"},
                {"data": "serviceFeeStartTime"},
            ],
            "columnDefs":[
                {
                    "render": function (data, type, row) {
                        return '<input type="checkbox" value="' + row.id + '" name="companyId" lay-skin="primary">';
                    },
                    "targets": 0
                },
                {
                    "render": function (data, type, row) {
                        var option = "";
                        for (var i = 0; i < row.dateList.length; i++) {
                            var date = new Date(row.dateList[i]).format('yyyy-MM');
                            option += "<option value=\"" + row.dateList[i] + "\">" + date + "</option>"
                        }
                        var html = "<select class='table-select' disabled name=\"date\"><option value=''>请选择</option>" + option + "</select>";
                        return html;
                    },
                    "targets": 2
                },
            ]
        });

        $("#search").click(function () {
            dataTable.ajax.reload();
            return false;
        });

    });

    /**批量生成**/
    function batchSend() {
        var index = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        var companyIds = [], dates = [];
        var type = $("input[name=type]:checked").val();
        //其他账单月
        if (type == 1) {
            var isSelect = true;
            $("input[name=companyId]:checked").each(function () {
                companyIds.push($(this).val());
                if ($(this).parent().parent().find("select[name=date]").val() == "") {
                    isSelect = false;
                }
                else {
                    dates.push(Number($(this).parent().parent().find("select[name=date]").val()));
                }
            });
            if (!isSelect) {
                layer.msg("请选择账单月");
                layer.close(index);
                return false;
            }
        }
        //当前月
        else {
            $("input[name=companyId]:checked").each(function () {
                companyIds.push($(this).val());
                dates.push(new Date().getTime());
            });
        }

        if (companyIds.length == 0) {
            layer.msg("请选择要生成的账单");
            layer.close(index);
            return false;
        }
        else {
            var loadMsg = layer.msg('加载中', {
                icon: 16
                ,shade: 0.01
            });
            var parameter = {
                companyIds : companyIds.toString(),
                dates : JSON.stringify(dates),
                isAll : 1
            }
            AM.log(parameter);
            AM.ajaxRequestData("post", true, AM.ip + "/companySonBillItem/save", parameter, function (result) {
                layer.close(loadMsg);
                var msg = "";
                if (typeof(result.data.msg) != 'undefined' && typeof(result.data.msg2) != 'undefined') {
                    msg = result.data.msg + "<br>" + result.data.msg2;
                }
                else if (typeof(result.data.msg) == 'undefined') {
                    msg = result.data.msg2;
                }
                else if (typeof(result.data.msg2) == 'undefined') {
                    msg = result.data.msg;
                }

                layer.alert(msg, {
                    skin: 'layui-layer-molv' //样式类名
                    ,closeBtn: 0
                    ,anim: 3 //动画类型
                }, function(){
                    //关闭iframe页面
                    var index2 = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index2);
                    window.parent.closeNodeIframe();
                });
            });
        }
        layer.close(index);
    }

    /**生成全部**/
    function generateAll() {
        var loadMsg = layer.load(1, {
            shade: [0.5, '#fff'] //0.1透明度的白色背景
        });
        AM.ajaxRequestData("post", true, AM.ip + "/companySonBillItem/save", {
            isAll : 0
        }, function (result) {
            layer.close(loadMsg);
            var msg = "";
            if (typeof(result.data.msg) != 'undefined' && typeof(result.data.msg2) != 'undefined') {
                msg = result.data.msg + "<br>" + result.data.msg2;
            }
            else if (typeof(result.data.msg) == 'undefined') {
                msg = result.data.msg2;
            }
            else if (typeof(result.data.msg2) == 'undefined') {
                msg = result.data.msg;
            }
            layer.alert(msg, {
                skin: 'layui-layer-molv' //样式类名
                ,closeBtn: 0
                ,anim: 3 //动画类型
            }, function(){
                //关闭iframe页面
                var index2 = parent.layer.getFrameIndex(window.name); //获取窗口索引
                parent.layer.close(index2);
                window.parent.closeNodeIframe();
            });
        });
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer;

        form.on('checkbox(allSelected)', function (data) {
            if (data.elem.checked) {
                $("input[name=companyId]").prop("checked", true);
            }
            else {
                $("input[name=companyId]").prop("checked", false);
            }
            form.render();
        });

        form.on('radio(type)', function (data) {
            if (data.value == 0) {
                $("#aKeyGeneration").show();
                $(".table-select").prop("disabled", true);
                $(".table-select").parent().hide();
                $("#theBillingMonth").hide();
            }
            else {
                $("#aKeyGeneration").hide();
                $(".table-select").prop("disabled", false);
                $(".table-select").parent().show();
                $("#theBillingMonth").show();
            }
            form.render();
        });
    });




</script>
</body>
</head>
</html>
