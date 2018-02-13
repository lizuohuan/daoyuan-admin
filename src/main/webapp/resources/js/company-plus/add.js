/**
 * Created by Eric.Xie on 2017/11/2 0002.
 */






function getSubmitData(prefix,i){

    var obj = {
        cooperationMethodId : i
    }
    if($("#"+prefix+"ServiceFeeStartTime").val() == ''){
        layer.msg('合作方式的开始时间没有选择', {icon: 2, anim: 6});
        return false;
    }
    obj.serviceFeeStartTime = new Date($("#"+prefix+"ServiceFeeStartTime").val()).getTime();
    obj.serviceFeeCycle = $("input[name='"+prefix+"ServiceFeeCycle']").val();
    obj.serviceFeeConfigId = $("#"+prefix+"ServiceFeeConfigId").val();
    obj.serviceFeeMin = $("#"+prefix+"ServiceFeeMin").val();
    obj.serviceFeeMax = $("#"+prefix+"ServiceFeeMax").val();
    obj.percent = $("#"+prefix+"Percent").val();
    obj.isPercent = $("input[name='"+prefix+"IsPercent']:checked").val();
    if(obj.serviceFeeConfigId == 5){
        obj.baseFee = $("#"+prefix+"Base").val();
    }
    var businessServiceFeeList = new Array();
    var serviceFeeList = new Array();
    var payPlaceList = new Array();
    if( obj.serviceFeeConfigId == 2 ||  obj.serviceFeeConfigId == 7){
        var extentNumArr = [];
        var extentPriceArr = [];
        $('.'+prefix+'ExtentNum').each(function () {
            extentNumArr[extentNumArr.length] = $(this).val();
        });
        $('.'+prefix+'ExtentPrice').each(function () {
            extentPriceArr[extentPriceArr.length] = $(this).val();
        });
        if (extentNumArr.length != extentPriceArr.length) {
            layer.msg('请完善服务费配置', {icon: 2, anim: 6});
            return false;
        }
        for (var i = 0; i < extentNumArr.length; i++) {
            var temp = {
                price: extentPriceArr[i],
                extent: extentNumArr[i]
            }
            serviceFeeList.push(temp);
        }
    }else if(obj.serviceFeeConfigId == 1 || obj.serviceFeeConfigId == 5
        || obj.serviceFeeConfigId == 6 ){
        var extentObj = {
            price: $("#"+prefix+"ServiceFee").val(),
            extent: 0
        }

        serviceFeeList.push(extentObj);

    }else if(obj.serviceFeeConfigId == 3){
        $("#"+prefix+"ServiceFeeForType").find(".service_fee").each(function () {
            var price = $(this).val();
            if ('' == price) {
                price = 0.0;
            }
            var businessIds = $(this).attr("ids");
            var extentObj = {
                price: price,
                businessIds: businessIds
            }
            businessServiceFeeList.push(extentObj);
        });
    }else if(obj.serviceFeeConfigId == 4){
        $("#"+prefix+"ServiceFeePlaceDiv").find(".layui-form-item").each(function () {
            payPlaceList.push({
                cityId : $(this).find("select[name="+prefix+"ServiceConfigFeePlace]").val(),
                price : $(this).find("input[name="+prefix+"ServiceConfigFeePlacePrice]").val(),
            });
        });
    }
    obj.businessServiceFeeList = businessServiceFeeList;
    obj.serviceFeeList = serviceFeeList;
    obj.payPlaceList = payPlaceList;
    return obj;
}







/**
 * 合作方式 服务费业务月序失去焦点事件
 */
function cooperationMethodServiceFeeCycleBlur(obj,dataTable,dateTime,showDataDiv){

    var date = $("#"+dateTime+"").val(); //服务费开始时间
    if (null != date && date != '') {
        var cycle = $(obj).val(); // 周期月
        if(cycle <= 0){
            $(obj).val("");
            $("#"+dataTable+"").html("");
            $("#"+showDataDiv+"").hide("fast");
            layer.msg('请输入一个正整数', {icon: 2, anim: 6});
            return;
        }
        if (null == cycle || cycle == '') {
            $("#"+showDataDiv+"").hide("slow");
            return;
        }
        var startTime = new Date(date);
        var arr = {
            cycle: cycle,
            time: startTime.getTime()
        };
        AM.ajaxRequestData("post", false, AM.ip + "/company/countTime", arr, function (result) {
            if (result.flag == 0 && result.code == 200) {
                var html = "";
                for (var i = 0; i < result.data.length; i++) {
                    var dateStr = result.data[i].split(",");
                    html += "<tr style='50px'><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                }
                $("#"+dataTable+"").html(html);
                $("#"+showDataDiv+"").show("fast");

            }
        });
    } else {
        $("#"+showDataDiv+"").hide("slow");
    }
}

function buildTable(cycle,timeStamp){
    var html = "";
    var arr = {
        cycle: cycle,
        time: timeStamp
    };
    AM.ajaxRequestData("post", false, AM.ip + "/company/countTime", arr, function (result) {
        if (result.flag == 0 && result.code == 200) {
            for (var i = 0; i < result.data.length; i++) {
                var dateStr = result.data[i].split(",");
                html += "<tr style='50px'><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
            }
        }
    });
    return html;
}



// 点击新增配置
function cooperationMethodAddConfig(obj,serviceFeeConfigId,extentDiv,extentNum,extentPrice) {
    var val = $("#"+serviceFeeConfigId+"").val();
    var msg = "";
    if(val == 2){
        msg = " 元/人*服务月";
    }
    var html =
        '<div class="layui-form-item">' +
        '<label class="layui-form-label">人数低于</label>' +
        '<div class="layui-input-inline">' +
        '<input type="text" class="layui-input '+extentNum+'"  lay-verify="required|isNumber"' +
        'placeholder="请输入"/>' +
        '</div>' +
        '<div class="layui-form-mid layui-word-aux unitId">'+msg+'</div>' +
        '<label class="layui-form-label" >服务费：</label>' +
        '<div class="layui-input-inline">' +
        '<input type="text" class="layui-input '+extentPrice+'"  lay-verify="required|isDouble"' +
        'placeholder="请输入服务费"/>' +
        '</div>' +
        '<div class="layui-input-inline" >' +
        '<button type="button" class="layui-btn layui-btn-danger" onclick="delConfig(this)">删除配置</button>' +
        '</div>' +
        '</div>';
    $("#"+extentDiv+"").append(html);
}
function delConfig(obj) {
    $(obj).parent().parent().remove();
}

/**新增服务区配置**/
function cooperationMethodAddServiceConfig(obj,prefix) {
    var serviceConfigFeePlace = $("#"+prefix+"ServiceFeePlace").html();
    var html =
        '<div class="layui-form-item">' +
        '   <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>' +
        '   <div class="layui-input-inline">' +
        '       <select class="'+prefix+'ServiceConfigFeePlace" lay-verify="required" name="'+prefix+'ServiceConfigFeePlace" lay-search>' +
        serviceConfigFeePlace +
        '       </select>' +
        '   </div>' +
        '   <label class="layui-form-label" >服务费<span class="font-red">*</span></label>' +
        '   <div class="layui-input-inline">' +
        '       <input type="text" class="layui-input '+prefix+'ExtentPrice" name="'+prefix+'ServiceConfigFeePlacePrice" lay-verify="required|isDouble" placeholder="请输入服务费"/>' +
        '   </div>' +
        '<div class="layui-form-mid layui-word-aux placeAux"> 元/人*服务月</div>' +
        '   <div class="layui-input-inline" >' +
        '       <button type="button" class="layui-btn layui-btn-danger" onclick="$(this).parent().parent().remove()">删除配置</button>' +
        '   </div>' +
        '</div>';
    $("#"+prefix+"ServiceFeePlaceDiv").append(html);
    form.render();
}

