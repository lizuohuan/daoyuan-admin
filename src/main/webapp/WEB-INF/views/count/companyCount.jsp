<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>公司数</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .row{overflow: hidden}
        .col-xs-9{ float: left; width: 75%; box-sizing: border-box;padding: 0 15px}
        .col-xs-3{ float: left; width: 25%; box-sizing: border-box;border-left: 1px solid #e1e1e1;padding: 0 15px;height: 500px;}
        .hint{text-align: center;font-size: 14px;padding: 10px 0;color: #666;}
        .number{padding: 10px 0;text-align: center;font-size: 20px;color: #2ac845}
        .layui-form-item{margin-bottom: 0;}
    </style>
</head>

<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote" id="screen">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">按：</label>
                            <div class="layui-input-inline" style="width: 200px;">
                                <input type="radio" name="flag" value="2" title="月" checked>
                                <input type="radio" name="flag" value="1" title="周">
                                <input type="radio" name="flag" value="0" title="日">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间段</label>
                            <div class="layui-input-inline" style="width: 100px;">
                                <input class="layui-input" placeholder="开始日" id="beginTime" readonly>
                            </div>
                            <div class="layui-form-mid">-</div>
                            <div class="layui-input-inline" style="width: 100px;">
                                <input class="layui-input" placeholder="截止日" id="endTime" readonly>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn" type="button" onclick="passingParameters()"><i class="layui-icon">&#xe615;</i> 筛选</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field">
        <legend>公司数&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <div class="row">
                <div class="col-xs-9">
                    <div id="company" style="width: 100%;height: 500px;"></div>
                </div>
                <div class="col-xs-3">
                    <div class="hint">本月新增公司数</div>
                    <div class="number" id="addCompany">0</div>
                    <div class="hint">本月终止/客户公司数</div>
                    <div class="number" id="reduceCompany">0</div>
                </div>
            </div>
        </div>
    </fieldset>

</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    var companyChart = echarts.init(document.getElementById("company")); // 统计图对象
    var option = {} // 统计图配置

    bindData(2, null, null);
    // 统计本月新增、终止公司数量
    AM.ajaxRequestData("post", false, AM.ip + "/statistics/companyCount",null, function (result) {
        if(result.code == 200){
            $("#addCompany").html(result.data.cooperationCount);
            $("#reduceCompany").html(result.data.unCooperationCount);
        }
    });

    /**参数调用**/
    function passingParameters() {
        if($("#beginTime").val() == '' && $("#endTime").val() != ''){
            layer.msg("开始日期和结束日期必须同时选");
            return false;
        }
        if($("#endTime").val() == '' && $("#beginTime").val() != ''){
            layer.msg("开始日期和结束日期必须同时选");
            return false;
        }
        bindData($("input[name=flag]:checked").val(),
                $("#beginTime").val() == '' ? null : new Date($("#beginTime").val()).getTime(),
                $("#endTime").val() == '' ? null : new Date($("#endTime").val()).getTime());
    }

    /**请求接口**/
    function bindData (flag, begin, end) {
        AM.ajaxRequestData("post", false, AM.ip + "/statistics/effectiveCompany", {
            flag: flag,
            startTimeStamp: begin,
            endTimeStamp: end
        }, function (result) {
            var name = result.data.abscissa;
            var number = result.data.data;
            var number2 = result.data.dataIsPeer;
            //number = [23,66,56,12,54,12,222,56,155,55,32,33,65,45,99,78,12,12,32,88,99,74,5,142,15,45,64,19,32,12,5];
            //number2 = [45,67,98,66,98,5,142,15,45,64,12,222,56,78,12,12,32,88,99,74,19,32,12,5,155,55,32,33,65,45,99];
            //寻找最大的
            var max = 0;
            for (var i = 0; i < number.length; i++) {
                if (number[i] > max) {
                    max = number[i];
                }
            }
            max = AM.getForTen(max);
            companyChart.setOption(setToOption(name, number, number2, "line", max));
        });
    }

    /**封装图表**/
    function setToOption(name, number, number2, type, max) {
        option = {
            title : {
                text: "公司数统计表",
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis'
            },
            color: ["#8B95C9"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['所有', '同行']
            },
            toolbox: {
                show : true,
                feature : {
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    axisTick: {
                        alignWithLabel: true
                    },
                    data : name
                }
            ],
            yAxis : [
                {
                    type: "value",
                    splitLine: {
                        show: false // y轴背景线条
                    },
                    "axisLine": {
                        show: true  // 左侧竖线线
                    },
                    axisTick: {
                        show: true  //刻度标识
                    },
                    splitArea: {
                        show: false //y轴背景颜色
                    },
                    axisLabel: {
                        formatter : "{value}", //添加左侧单位
                    },
                    max: max
                }
            ],
            series : [
                {
                    name:'所有',
                    type: type,
                    smooth: true, //圆弧显示
                    data: number,
                    label: {
                        normal: {
                            show: false,
                            position: 'top'
                        }
                    }
                },
                {
                    name:'同行',
                    type: type,
                    smooth: true, //圆弧显示
                    data: number2,
                    itemStyle: {
                        normal: {
                            color: "#BDB76B",
                            lineStyle: {
                                color: "#BDB76B"
                            }
                        }
                    },
                    label: {
                        normal: {
                            show: false,
                            position: 'top'
                        }
                    }
                },
            ]
        };

        return option;
    }

    layui.use(['form', 'layedit', 'laydate'], function () {
        form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        var start = {
            max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };

        var end = {
            max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('beginTime').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        document.getElementById('endTime').onclick = function(){
            end.elem = this
            laydate(end);
        }

    });

</script>
</body>
</html>
