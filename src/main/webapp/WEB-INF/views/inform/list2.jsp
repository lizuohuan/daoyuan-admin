<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>待办事项列表</title>
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
                        <label class="layui-form-label">范围选择</label>
                        <div class="layui-input-inline">
                            <input class="layui-input" placeholder="开始日" id="begin" readonly>
                        </div>
                        <div class="layui-input-inline">
                            <input class="layui-input" placeholder="截止日" id="end" readonly>
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
        <legend>待办事项列表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <table id="dataTable" class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>待办内容</th>
                    <th>创建时间</th>
                    <th>操作</th>
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
    $(document).ready(function() {
        dataTable = $('#dataTable').DataTable( {
            "bProcessing" : true, //DataTables载入数据时，是否显示‘进度’提示
            "searching": false, //关闭默认搜索
            "bSort":false,
            "bStateSave": true, //状态保存，使用了翻页或者改变了每页显示数据数量，会保存在cookie中，下回访问时会显示上一次关闭页面时的内容。
            "bPaginate" : false, //是否显示（应用）分页器
            "bInfo" : false, //是否显示页脚信息，DataTables插件左下角显示记录数
            "bLengthChange":false, //是否允许终端用户从一个选择列表中选择分页的页数，页数为10，25，50和100，需要分页组件bPaginate的支持
            'language': {
                'emptyTable': '没有数据',
                'loadingRecords': '加载中...',
                'processing': '查询中...',
                'search': '全局搜索:',
                'lengthMenu': '每页 _MENU_ 件',
                'zeroRecords': '没有您要搜索的内容',
                'paginate': {
                    'first':      '第一页',
                    'last':       '最后一页',
                    'next':       '下一页',
                    'previous':   '上一页'
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
            "ajax":  {
                url: AM.ip + "/backlog/list",
                headers: {
                    "token" : AM.getUserInfo() == null ? null : AM.getUserInfo().token,
                },
                "dataSrc": function(json) {
                    console.log(json);
                    if (json.code == 200) {
                        return json.data;
                    }
                    return [];
                },
                "data": function(data) {

                }
            },
            "columns": [
                { "data": "content" },
                { "data": "createTime" },
            ],
            "columnDefs": [
                {
                    "render": function(data, type, row) {
                        return new Date(data).format("yyyy-MM-dd hh:mm:ss");
                    },
                    "targets": 1
                },
                {
                    "render": function(data, type, row) {
                        return "<button onclick=\"dispose('" + row.url + "')\" class=\"layui-btn layui-btn-small\"><i class=\"fa fa-list fa-edit\"></i>&nbsp;去处理</button>";
                    },
                    "targets": 2
                },
            ]
        } );

        $("#search").click(function(){
            dataTable.ajax.reload();
            return false;
        });
    } );

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;
        var start = {
            max: laydate.now()
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            max: laydate.now()
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('begin').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        document.getElementById('end').onclick = function(){
            end.elem = this
            laydate(end);
        }
    });

    /**处理**/
    function dispose(url) {
        layer.full(layer.open({
            type: 2,
            title: '待办事项',
            shadeClose: true,
            maxmin: true, //开启最大化最小化按钮
            area: ['100%', '100%'],
            content: AM.ip + url
        }));
    }

</script>
</body>
</html>
