<!-- 解决layer.open 不居中问题 -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>公司统计</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .layui-form-item{margin-bottom: 0;}
    </style>

<body>

<div class="admin-main">

    <blockquote class="layui-elem-quote" id="screen">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label" style="width: 50px;"></label>
                            <div class="layui-form-mid">客户人数>=</div>
                            <div class="layui-input-inline" style="width: 100px;">
                                <input class="layui-input" placeholder="数量" type="text" id="greaterThan">
                            </div>
                            <div class="layui-form-mid">人的账单确认率</div>

                            <label class="layui-form-label" style="width: 50px;"></label>
                            <div class="layui-form-mid">客户人数<=</div>
                            <div class="layui-input-inline" style="width: 100px;">
                                <input class="layui-input" placeholder="数量" type="text" id="lessThan">
                            </div>
                            <div class="layui-form-mid">人的账单确认率</div>

                            <label class="layui-form-label" style="width: 50px;"></label>
                            <div class="layui-form-mid">上月服务费>=</div>
                            <div class="layui-input-inline" style="width: 100px;">
                                <input class="layui-input" placeholder="数量" type="text" id="greaterThanService">
                            </div>
                            <div class="layui-form-mid">人的账单确认率</div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">日期</label>
                            <div class="layui-input-inline" style="width: 100px;">
                                <select class="layui-input" id="date">
                                    <option value="">请选择</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                    <option value="16">16</option>
                                    <option value="17">17</option>
                                    <option value="18">18</option>
                                    <option value="19">19</option>
                                    <option value="20">20</option>
                                    <option value="21">21</option>
                                    <option value="22">22</option>
                                    <option value="23">23</option>
                                    <option value="24">24</option>
                                    <option value="25">25</option>
                                    <option value="26">26</option>
                                    <option value="27">27</option>
                                    <option value="28">28</option>
                                    <option value="29">29</option>
                                    <option value="30">30</option>
                                    <option value="31">31</option>
                                </select>
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
        <legend>账单确认率&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend>
        <div class="layui-field-box layui-form">
            <div id="chart" style="width: 100%;height: 500px;"></div>
        </div>
        <div class="layui-field-box layui-form">
            <div id="chart2" style="width: 100%;height: 500px;"></div>
        </div>
    </fieldset>

</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    var chart = echarts.init(document.getElementById("chart")); // 统计图对象
    var chart2 = echarts.init(document.getElementById("chart2")); // 统计图对象
    var option = {} // 统计图配置

    bindData(null, null, null, new Date().getDate());

    AM.ajaxRequestData("post", false, AM.ip + "/statistics/billIdentificationRateOfMonth",{type: 0}, function (result) {
        //寻找最大的
        var max = 0;
        for (var i = 0; i < result.data.data.length; i++) {
            if (result.data.data[i] > max) {
                max = result.data.data[i];
            }
        }
        max = AM.getForTen(max);
        chart2.setOption(setToOption(result.data.abscissa, result.data.data, result.data.dataIsPeer, "line", max));
    });

    /**参数调用**/
    function passingParameters() {
        if($("#greaterThan").val() != '' && !AM.isNumber.test($("#greaterThan").val())){
            layer.msg("请输入整数");
            $("#greaterThan").focus();
            return false;
        }
        if($("#lessThan").val() != '' && !AM.isNumber.test($("#lessThan").val())){
            layer.msg("请输入整数");
            $("#lessThan").focus();
            return false;
        }
        if($("#greaterThanService").val() != '' && !AM.isNumber.test($("#greaterThanService").val())){
            layer.msg("请输入整数");
            $("#greaterThanService").focus();
            return false;
        }
        bindData(
                $("#greaterThan").val() == '' ? null : $("#greaterThan").val(),
                $("#lessThan").val() == '' ? null : $("#lessThan").val(),
                $("#greaterThanService").val() == '' ? null : $("#greaterThanService").val(),
                $("#date").val() == '' ? null : $("#date").val()
        );
    }

    /**请求接口**/
    function bindData (more, less, serviceAmount, day) {
        AM.ajaxRequestData("post", false, AM.ip + "/statistics/billIdentificationRate", {
            more: more,
            less: less,
            serviceAmount: serviceAmount,
            day: day,
            type: 0
        }, function (result) {
            var name = result.data.abscissa;
            var number = result.data.data;
            var number2 = result.data.dataIsPeer;
            //name = ["1月", "2月", "3月", "4月", "5月", "6月", "7月"];
            //number = [23, 32, 56, 22, 54, 67, 18];
            //number2 = [22, 54, 67, 18, 23, 32, 56];
            //寻找最大的
            var max = 0;
            for (var i = 0; i < number.length; i++) {
                if (number[i] > max) {
                    max = number[i];
                }
            }
            max = AM.getForTen(max);
            chart.setOption(setToOption(name, number, number2, "bar", max));
        });
    }

    /**封装图表**/
    function setToOption(name, number, number2, type, max) {
        option = {
            title : {
                text: "统计表",
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis',
                formatter: '{b}<br /><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#8B95C8"></span>{a0}：{c0}%' +
                '<br /><span style="display:inline-block;margin-right:5px;border-radius:10px;width:9px;height:9px;background-color:#BCB66C"></span>{a1}：{c1}%'
            },
            color: ["#8B95C9"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['所有', '同年']
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
                        formatter : "{value}%", //添加左侧单位
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
                    name:'同年',
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

        $("#date option").each(function () {
            if($(this).val() == new Date().getDate()){$(this).prop("selected", true);}
            form.render();
        });
    });

</script>
</body>
</head>
</html>
