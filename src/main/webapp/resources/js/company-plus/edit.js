/**
 * Created by Eric.Xie on 2017/11/2 0002.
 */


function initData(company){
    if(company.cooperationMethodList == null){
        return;
    }
    // 初始化 合作方式

    for (var i = 0; i < company.cooperationMethodList.length; i++){
        var method = company.cooperationMethodList[i];// 合作方式对象
        $("input[name='cooperationMethod']").each(function(){
            if($(this).val() == method.cooperationMethodId){
                $(this).prop("checked",true);
            }
        })
        // 赋值
        if(method.cooperationMethodId == 0){
            // 选中普通
            $("#cooperationMethodDiv").show("fast")
            // 增加验证
            $("#cooperationMethodPTServiceFeeStartTime").attr("lay-verify","required");
            $("#cooperationMethodPTServiceFeeCycle").attr("lay-verify","required");
            $("#cooperationMethodPTServiceFeeConfigId").attr("lay-verify","required");
            assignment(method,"cooperationMethodPT");
            $("#cooperationMethodPTServiceFeeCycleDiv").show("fast");
            editCooperationMethodServiceFeeCycleBlur(method.serviceFeeCycle,'cooperationMethodPTDataBody','cooperationMethodPTServiceFeeStartTime','cooperationMethodPTShowServiceFeeCycleDiv');
            if(method.serviceFeeConfigId == 5){
                $("#cooperationMethodPTBaseDiv").show("fast");
                $("#cooperationMethodPTBase").val(method.baseFee);
                $("#cooperationMethodPTBase").attr("lay-verify","required");
            }
        }
        if(method.cooperationMethodId == 1){
            // 选中派遣
            $("#cooperationMethodPQDiv").show("fast");
            $("#cooperationMethodPQServiceFeeStartTime").attr("lay-verify","required");
            $("#cooperationMethodPQServiceFeeCycle").attr("lay-verify","required");
            $("#cooperationMethodPQServiceFeeConfigId").attr("lay-verify","required");
            assignment(method,"cooperationMethodPQ");
            $("#cooperationMethodPQServiceFeeCycleDiv").show("fast");
            editCooperationMethodServiceFeeCycleBlur(method.serviceFeeCycle,'cooperationMethodPQDataBody','cooperationMethodPQServiceFeeStartTime','cooperationMethodPQShowServiceFeeCycleDiv');
            if(method.serviceFeeConfigId == 5){
                $("#cooperationMethodPQBaseDiv").show("fast");
                $("#cooperationMethodPQBase").val(method.baseFee);
                $("#cooperationMethodPQBase").attr("lay-verify","required");
            }
        }
        if(method.cooperationMethodId == 2){
            // 选中外包
            $("#cooperationMethodWBDiv").show("fast")
            $("#cooperationMethodWBServiceFeeStartTime").attr("lay-verify","required");
            $("#cooperationMethodWBServiceFeeCycle").attr("lay-verify","required");
            $("#cooperationMethodWBServiceFeeConfigId").attr("lay-verify","required");
            assignment(method,"cooperationMethodWB");
            $("#cooperationMethodWBServiceFeeCycleDiv").show("fast");
            editCooperationMethodServiceFeeCycleBlur(method.serviceFeeCycle,'cooperationMethodWBDataBody','cooperationMethodWBServiceFeeStartTime','cooperationMethodWBShowServiceFeeCycleDiv');
            if(method.serviceFeeConfigId == 5){
                $("#cooperationMethodWBBaseDiv").show("fast");
                $("#cooperationMethodWBBase").val(method.baseFee);
                $("#cooperationMethodWBBase").attr("lay-verify","required");
            }
        }

    }




}



function  assignment(method,prefix){
    var configId = method.serviceFeeConfigId;
    var date = new Date(method.serviceFeeStartTime).format("yyyy-MM-dd");
    $("#"+prefix+"ServiceFeeStartTime").val(date);
    $("#"+prefix+"ServiceFeeCycle").val(method.serviceFeeCycle);
    $("select[name='"+prefix+"ServiceFeeConfigId'] option").each(function(){
        if($(this).val() == configId ){
            $(this).prop("selected",true);
        }
    })

    if (configId == 8) {
        $("#"+prefix+"Assist").html(" %");
    }else if(configId == 1){
        $("#"+prefix+"Assist").html(" 元/人*服务月");
    } else if(configId == 5) {
        $("#"+prefix+"Assist").html("元/次");
    } else if(configId == 6) {
        $("#"+prefix+"Assist").html("元");
    }else {
        $("#"+prefix+"Assist").html("");
    }
    if (configId == 1
        || configId == 5 || configId == 6 || configId == 8) {
        $("#"+prefix+"ServiceFeeDiv").show("fast");

        if (null != method.serviceFeeList && method.serviceFeeList.length > 0) {
            $("#"+prefix+"ServiceFee").val(method.serviceFeeList[0].price);
        }

        $("#"+prefix+"ServiceFee").attr("lay-verify", "required");
        $("#"+prefix+"ExtentDiv").hide("fast");
        $("."+prefix+"ExtentNum").removeAttr("lay-verify");
        $("."+prefix+"ExtentPrice").removeAttr("lay-verify");
        $("#"+prefix+"AddConfigBtn").hide("fast");
        $("#"+prefix+"ServiceFeeForType").hide("fast");
        $("#"+prefix+"ServiceFeePlaceDiv").hide("fast");
        $("#"+prefix+"AddServiceConfig").hide("fast");
        $("#"+prefix+"ServiceFeePlaceDiv").find("select[name="+prefix+"ServiceConfigFeePlace]").removeAttr("lay-verify");
        $("#"+prefix+"ServiceFeePlaceDiv").find("input[name="+prefix+"ServiceConfigFeePlacePrice]").removeAttr("lay-verify");
    } else if (configId == 3) {
        // 按服务类别收费 如社保、公积金、工资等
        // 获取已经选择了的(社保、公积金、工资)业务
        //如果没有选择以上 业务， 则不显示其他组件
        var html = getEditServiceConfigHtml(method.businessServiceFeeList);



        $("#"+prefix+"ServiceFeeForType").html(html);
        $("#"+prefix+"ServiceFeeForType").show("fast");
        $("#"+prefix+"ServiceFeeDiv").hide("fast");
        $("#"+prefix+"ServiceFee").removeAttr("lay-verify");

        $("#"+prefix+"ExtentDiv").hide("fast");
        $("."+prefix+"ExtentNum").removeAttr("lay-verify");
        $("."+prefix+"ExtentPrice").removeAttr("lay-verify");

        $("#"+prefix+"AddConfigBtn").hide("fast");


        $("#"+prefix+"ServiceFeePlaceDiv").hide("fast");
        $("#"+prefix+"AddServiceConfig").hide("fast");
        $("#"+prefix+"ServiceFeePlaceDiv").find("select[name="+prefix+"ServiceConfigFeePlace]").removeAttr("lay-verify");
        $("#"+prefix+"ServiceFeePlaceDiv").find("input[name="+prefix+"ServiceConfigFeePlacePrice]").removeAttr("lay-verify");
    } else if(configId == 4){
        // 服务区
        $("#"+prefix+"ServiceFeePlaceDiv").show("fast");
        $("#"+prefix+"AddServiceConfig").show("fast");
        $("."+prefix+"ServiceConfigFeePlace").attr("lay-verify", "required");
        $("."+prefix+"ServiceConfigFeePlacePrice").attr("lay-verify", "required");

        if(null != method.payPlaceList && method.payPlaceList.length > 0){


            for(var i = 0; i < method.payPlaceList.length; i++){
                var obj = method.payPlaceList[i];
                if(i == 0){
                    $("select[id='"+prefix+"ServiceFeePlace'] option").each(function(){
                        if($(this).val() ==  method.payPlaceList[i].cityId){
                            $(this).prop("selected",true);
                        }
                    })
                    $("#"+prefix+"ServiceConfigFeePlacePrice").val(method.payPlaceList[i].price)
                }else{
                    editServiceConfig(obj.cityId, obj.price, "addServiceConfig_" + obj.cityId,prefix);
                }
            }

        }


        $("#"+prefix+"ServiceFeeDiv").hide("fast");
        $("#"+prefix+"ServiceFee").removeAttr("lay-verify");
        $("#"+prefix+"ExtentDiv").hide("fast");
        $("."+prefix+"ExtentNum").removeAttr("lay-verify");
        $("."+prefix+"ExtentPrice").removeAttr("lay-verify");
        $("#"+prefix+"AddConfigBtn").hide("fast");
        $("#"+prefix+"ServiceFeeForType").hide("fast");

    }else {

        if(configId == 2){
            $("."+prefix+"UnitId").each(function(){
                $(this).html(" 元/人*服务月")
            })
        }
        var msg = "";
        if(configId == 2){
            msg = "单位:元/人*服务月";
        }
        if(configId == 7){
            $("."+prefix+"UnitId").each(function(){
                $(this).html("")
            })
        }

        $("#"+prefix+"AddConfigBtn").show("fast");
        $("#"+prefix+"ServiceFeeDiv").hide("fast");
        $("#"+prefix+"ServiceFee").removeAttr("lay-verify");
        $("#"+prefix+"ServiceFeeForType").hide("fast");

        $("#"+prefix+"ExtentDiv").show("fast");
        $("."+prefix+"ExtentNum").attr("lay-verify", "required");
        $("."+prefix+"ExtentPrice").attr("lay-verify", "required");

        $("#"+prefix+"ServiceFeePlaceDiv").hide("fast");
        $("#"+prefix+"AddServiceConfig").hide("fast");
        $("#"+prefix+"ServiceFeePlaceDiv").find("select[name="+prefix+"ServiceConfigFeePlace]").removeAttr("lay-verify");
        $("#"+prefix+"ServiceFeePlaceDiv").find("input[name="+prefix+"ServiceConfigFeePlacePrice]").removeAttr("lay-verify");

        if (null != method.serviceFeeList) {
            var html = "";
            for (var i = 0; i < method.serviceFeeList.length; i++) {
                if (i == 0) {
                    $("#"+prefix+"ExtentNum").val(method.serviceFeeList[i].extent);
                    $("#"+prefix+"ExtentPrice").val(method.serviceFeeList[i].price);
                } else {
                    html +=
                        '<div class="layui-form-item">' +
                        '<label class="layui-form-label">人数低于</label>' +
                        '<div class="layui-input-inline">' +
                        '<input type="text" value="' + method.serviceFeeList[i].extent + '" class="layui-input '+prefix+'ExtentNum" lay-verify="required|isNumber"' +
                        'placeholder="请输入"/>' +
                        '</div>' +
                        '<div class="layui-form-mid layui-word-aux unitId">'+msg+'</div>' +
                        '<label class="layui-form-label">服务费：</label>' +
                        '<div class="layui-input-inline">' +
                        '<input type="text" value="' + method.serviceFeeList[i].price + '" class="layui-input '+prefix+'ExtentPrice" lay-verify="required|isDouble"' +
                        'placeholder="请输入服务费"/>' +
                        '</div>' +
                        '<div class="layui-input-inline" >' +
                        '<button type="button" class="layui-btn layui-btn-danger" onclick="delConfig(this)">删除配置</button>' +
                        '</div>' +
                        '</div>';
                }
            }
            $("#"+prefix+"ExtentDiv").append(html);

        }
    }

    $("#"+prefix+"ServiceFeeMin").val(method.serviceFeeMin);
    $("#"+prefix+"ServiceFeeMax").val(method.serviceFeeMax);
    $("#"+prefix+"Percent").val(method.percent);
    $("input[name='"+prefix+"IsPercent']").each(function(){
        if($(this).val() == method.isPercent){
            $(this).prop("checked",true);
        }
    })


}

// 合作方式 服务费月序初始化
function editServiceFeeCycleBlur(obj, cc) {

    var date = $("#serviceFeeStartTime").val(); //服务费开始时间
    if (null != date && date != '') {
        var cycle = null == obj ? cc : $(obj).val(); // 周期月
        if (null == cycle || cycle == '') {
            $("#showServiceFeeCycleDiv").hide("slow");
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
                    html += "<tr><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                }
                $("#dataBody").html(html);
                $("#showServiceFeeCycleDiv").show("slow");
            }
        });
    } else {
        $("#showServiceFeeCycleDiv").hide("slow");
    }

}

function getEditServiceConfigHtml(businessServiceFeeList){
    var businessObj = new Array();
    var str = "";
    $("input[name='businessArr']:checked").each(function(){
        var o = $(this).val();
        // 设置业务
        if(o == 3 || o == 4 || o == 5){
            businessObj.push(o);
            str += o + ",";
        }
    });
    var businessArray = businessObj;
    var resultArr = [];
    resultArr[resultArr.length] = str.substring(0,str.length - 1);
    for (var i = 0; i < businessArray.length; i++) {
        for (var j = i + 1; j < businessArray.length; j++) {
            var isExist = false;
            var obj = businessArray[i] + "," + businessArray[j];
            for(var k = 0; k < resultArr.length; k++){
                if(obj == resultArr[k]){
                    isExist = true;
                    break;
                }
            }
            if(!isExist){
                resultArr[resultArr.length] = obj;
            }

        }
    }
    for (var i = 0; i < businessArray.length; i++) {
        var isExist = false;
        for(var j = 0; j < resultArr.length; j++){
            if(businessArray[i] == resultArr[j]){
                isExist = true;
                break;
            }
        }
        if(!isExist){
            resultArr[resultArr.length] = businessArray[i];
        }
    }
    // 生成文本框
    var html = "";
    if(resultArr != ''){
        for (var i = 0; i < resultArr.length; i++) {
            var msg = "";
            var names = resultArr[i].split(",");
            for (var j = 0; j < names.length; j++) {
                if(names[j] == ''){
                    continue;
                }
                msg += getBusiness(names[j]) + "、";
            }
            msg = msg.substring(0, msg.length - 1);
            var v = 0.0;
            if(null != businessServiceFeeList && businessServiceFeeList.length > 0){
                for (var  j = 0 ; j < businessServiceFeeList.length; j++){
                    if(businessServiceFeeList[j].businessIds == resultArr[i]){
                        v = businessServiceFeeList[j].price;
                        break;
                    }
                }

            }
            html += '<div class="layui-form-item">' +
                '<label class="layui-form-label">' + msg + '</label>' +
                '<div class="layui-input-inline">' +
                '<input type="number" class="layui-input service_fee" value="'+v+'" ids="' + resultArr[i] + '" lay-verify="isDouble" placeholder="请输入服务费"/>' +
                '</div>' +
                '<div class="layui-form-mid layui-word-aux"> 元/人*服务月</div>' +
                '</div>';
        }
    }
    return html;

}

/**新增服务区配置**/
function editServiceConfig(cityId, price, id,prefix) {
    var serviceConfigFeePlace = $("#cooperationMethodPQServiceFeePlace").html();
    var selectedId = "";
    if (id != 0) {
        selectedId = "id='" + id + "'";
    }
    var html =
        '<div class="layui-form-item">' +
        '   <label class="layui-form-label">选择缴金地<span class="font-red">*</span></label>' +
        '   <div class="layui-input-inline">' +
        '       <select ' + selectedId + ' class="'+prefix+'ServiceConfigFeePlace" lay-verify="required" name="'+prefix+'ServiceConfigFeePlace">' +
        serviceConfigFeePlace +
        '       </select>' +
        '   </div>' +
        '   <label class="layui-form-label" >服务费<span class="font-red">*</span></label>' +
        '   <div class="layui-input-inline">' +
        '       <input type="text" value="' + price + '" class="layui-input '+prefix+'extentPrice" name="'+prefix+'ServiceConfigFeePlacePrice" lay-verify="required|isDouble" placeholder="请输入服务费"/>' +
        '   </div>' +
        '<div class="layui-form-mid layui-word-aux placeAux"> 元/人*服务月</div>' +
        '   <div class="layui-input-inline" >' +
        '       <button type="button" class="layui-btn layui-btn-danger" onclick="$(this).parent().parent().remove()">删除配置</button>' +
        '   </div>' +
        '</div>';
    $("#"+prefix+"ServiceFeePlaceDiv").append(html);
    $("#" + id + " option").each(function () {
        if ($(this).val() == cityId) {
            $(this).attr("selected", true);
        }
    });
    //form.render();
}





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
    obj.percent = $("#"+prefix+"Percent").val() == "" ? 0 : $("#"+prefix+"Percent").val();
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
                    html += "<tr><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                }
                $("#"+dataTable+"").html(html);
                $("#"+showDataDiv+"").show("fast");

            }
        });
    } else {
        $("#"+showDataDiv+"").hide("slow");
    }
}


/**
 * 合作方式 服务费业务月序失去焦点事件
 */
function editCooperationMethodServiceFeeCycleBlur(cycle,dataTable,dateTime,showDataDiv){

    var date = $("#"+dateTime+"").val(); //服务费开始时间
    if (null != date && date != '') {
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
                    html += "<tr><td>" + dateStr[0] + "</td><td>" + dateStr[1] + "</td></tr>";
                }
                $("#"+dataTable+"").html(html);
                $("#"+showDataDiv+"").show("fast");

            }
        });
    } else {
        $("#"+showDataDiv+"").hide("slow");
    }
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
        '   <div class="layui-form-mid layui-word-aux placeAux"> 元/人*服务月</div>' +
        '   <div class="layui-input-inline" >' +
        '       <button type="button" class="layui-btn layui-btn-danger" onclick="$(this).parent().parent().remove()">删除配置</button>' +
        '   </div>' +
        '</div>';
    $("#"+prefix+"ServiceFeePlaceDiv").append(html);
    form.render();
}

