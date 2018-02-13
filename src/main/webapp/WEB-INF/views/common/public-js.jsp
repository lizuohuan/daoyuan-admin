<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common/jquery-2.1.0.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common/jquery.form.js"></script>
<%--<script type="text/javascript" src="<%=request.getContextPath()%>/resources/plugins/layui/layui.js"></script>--%>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/plugins/layui/lay/dest/layui.all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/angular.min.js"></script>
<%--<script type="text/javascript" src="<%=request.getContextPath()%>/resources/dataTable/js/jquery.dataTables.min.js"></script>--%>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/datatables/media/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/datatables/plugins/bootstrap/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/config.js"></script>
<!--时间控件-->
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/My97DatePicker/WdatePicker.js"></script>
<%--<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/commons.js"></script>--%>

<script>
    $(function () {
        $(".fa-refresh").click(function () {
            location.reload();
        });
    });

    //遍历验证权限
    function checkJurisdiction () {
        var menuList = AM.getLoginUserJurisdiction();
        for (var i = 0; i < menuList.length; i++) {
            var oneChild = menuList[i];
            checkJurisdiction2(oneChild)
        }

    }

    function checkJurisdiction2(menuList) {
        for (var j = 0; j < menuList.child.length; j++) {
            var twoChild = menuList.child[j];
            checkJurisdiction2(twoChild)
            $(".checkBtn_" + twoChild.id).show();
        }
    }

    function buildBusinessInput(selectId,targetView,method,isShow){
        AM.ajaxRequestData(method, false, AM.ip + "/business/queryBusiness", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "";
                for (var i = 0; i < result.data.length; i++) {
                    if(result.data[i].id == 1 || result.data[i].id == 2){
                        continue;
                    }
                    if (result.data[i].id == selectId) {
                        html += '<input type="checkbox" value="'+result.data[i].id+'" lay-filter = "boxChecked"  name="businessArr" title="'+result.data[i].businessName+'" checked>';
                    }
                    else {
                        html += '<input type="checkbox" value="'+result.data[i].id+'" lay-filter = "boxChecked" name="businessArr" title="'+result.data[i].businessName+'">';
                    }
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }



    /**
     * 通过公司ID 查询 公司下的业务集合
     * */
    function buildBusinessInputByCompany(selectId,targetView,method,isShow,companyId){
        AM.ajaxRequestData(method, false, AM.ip + "/business/queryBusinessByCompany", {companyId : companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "";
                for (var i = 0; i < result.data.length; i++) {
                    var str = JSON.stringify(result.data[i]);
                    if (result.data[i].id == selectId) {
                        html += "<input type='checkbox' value='"+result.data[i].id+"' lay-filter = 'boxChecked' objStr = '"+str+"'  name='businessArr' title='"+result.data[i].businessName+"' checked>";
                    }
                    else {
                        html += "<input type='checkbox' value='"+result.data[i].id+"' lay-filter = 'boxChecked' objStr = '"+str+"'  name='businessArr' title='"+result.data[i].businessName+"'>";
                    }
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }


    /**
     * 通过类型 获取 缴金地列表
     * 缴金地类型 0：社保  1：公积金
     * */
    function getPayPlaceByType1(selectId,targetView,method,isShow,type){
        AM.ajaxRequestData(method, false, AM.ip + "/payPlace/getPayPlaceByType", {type : type} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索</option>';
                for (var i = 0; i < result.data.length; i++) {
                    var msg = "";
                    if(0 == result.data[i].type){
                        msg = result.data[i].payPlaceName + "-社保";
                    }
                    else if( 1 == result.data[i].type){
                        msg = result.data[i].payPlaceName + "-公积金";
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + msg + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + msg + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }



    /**
     * 通过类型 获取 缴金地列表
     * 缴金地类型 0：社保  1：公积金
     * */
    function getPayPlaceByType(selectId,targetView,method,isShow,type){
        AM.ajaxRequestData(method, false, AM.ip + "/payPlace/getPayPlaceByType", {type : type} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索</option>';
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].payPlaceName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].payPlaceName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }



    /**
     * 获取 缴金地列表
     * */
    function queryAllPayPlace(selectId,targetView,method,isShow){
        AM.ajaxRequestData(method, false, AM.ip + "/payPlace/queryAllPayPlace", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索</option>';
                for (var i = 0; i < result.data.length; i++) {
                    var payPlaceName = result.data[i].payPlaceName;
//                    payPlaceName = payPlaceName.substring(3,payPlaceName.length);
                    if (result.data[i].cityId == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].cityId + "\">" + payPlaceName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].cityId + "\">" + payPlaceName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }


    /**
     * 获取 缴金地列表
     * */
    function queryOtherAllPayPlace(selectId,targetViews,method){
        AM.ajaxRequestData(method, false, AM.ip + "/payPlace/queryAllPayPlace", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索</option>';
                for (var i = 0; i < result.data.length; i++) {
                    var payPlaceName = result.data[i].payPlaceName;
//                    payPlaceName = payPlaceName.substring(3,payPlaceName.length);
                    if (result.data[i].cityId == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].cityId + "\">" + payPlaceName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].cityId + "\">" + payPlaceName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }

                for(var i = 0; i < targetViews.length; i++){
                    $("#"+targetViews[i]+"").html(html);
                }
            }
        });
    }


    /**
     * 通过类型 获取 公司缴金地列表
     * 缴金地类型 0：社保  1：公积金
     * */
    function getCompanyPayPlaceByType(selectId,targetView,method,isShow,type,companyId){
        AM.ajaxRequestData(method, false, AM.ip + "/companyPayPlace/getCompanyPayPlace", {type : type,companyId:companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = '<option value="">请选择或搜索</option>';
                for (var i = 0; i < result.data.length; i++) {
                    var obj = result.data[i];
                    var msg = obj.payPlaceName + "-" + obj.organizationName + "-" + obj.transactorName;
                    if (result.data[i].id == selectId) {
                        html += "<option selected='selected' payplaceid = '"+obj.payPlaceId+"' organizationId='" + obj.organizationId + "' value='" + result.data[i].id + "'>" + msg + "</option>";
                    }
                    else {
                        html += "<option  payplaceid = '"+obj.payPlaceId+"' organizationId='" + obj.organizationId + "' value='" + result.data[i].id + "'>" + msg + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }



    /**
     * 通过缴金地 查询经办机构的ID 和 名称
     * */
    function getOrganizationByPayPlace(selectId,targetView,method,isShow,payPlaceId){
        AM.ajaxRequestData(method, false, AM.ip + "/organization/getOrganizationByPayPlace", {payPlaceId : payPlaceId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].organizationName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].organizationName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }


    /**
     * 通过缴金地 查询经办机构的ID 和 名称
     * */
    function getOrganizationByPayPlace2(selectId,targetView,method,isShow,payPlaceId){
        AM.ajaxRequestData(method, false, AM.ip + "/organization/getOrganizationByItem", {payPlaceId : payPlaceId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var organizationName = "";
                    if(result.data[i].flag == 0){
                        organizationName = result.data[i].organizationName;
                    }
                    else{
                        organizationName = result.data[i].organizationName + "-托管配置";
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + organizationName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + organizationName + "</option>";
                    }

                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }




    /**
     * 通过经办机构的ID 获取 办理方部门字段
     * */
    function getTransactorByOrganization(selectId,targetView,method,isShow,organizationId){
        AM.ajaxRequestData(method, false, AM.ip + "/transactor/getTransactorByOrganization", {organizationId : organizationId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].transactorName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].transactorName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }

    /**
     * 通过经办机构的ID 获取 办理方部门字段
     * */
    function getTransactorByOrganization2(selectId,targetView,method,isShow,arr){
        AM.ajaxRequestData(method, false, AM.ip + "/transactor/queryTransactorByOrganization2", arr , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {

                    var transactorName = "";
                    if(result.data[i].flag == 0){
                        transactorName = result.data[i].transactorName;
                    }
                    else{
                        transactorName = result.data[i].transactorName + "-托管配置";
                    }

                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + transactorName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + transactorName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }

    /**
     * 通过公司 获取联系人
     * */
    function getContactsByCompany(selectId,targetView,method,isShow,companyId){
        AM.ajaxRequestData(method, false, AM.ip + "/contacts/getContactsByCompany", {companyId : companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var phone = "";
                    if(null != result.data[i].phone && result.data[i].phone != ""){
                        phone = result.data[i].phone;
                    }
                    else {
                        if(null != result.data[i].landLine && result.data[i].landLine != "" ){
                            phone = result.data[i].landLine;
                        }
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" phone=\"" + phone + "\" value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                    else {
                        html += "<option phone=\"" + phone + "\" value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }


    /**
     * 通过公司 获取联系人
     * */
    function queryContactsByIsReceiver(selectId,targetView,method,isShow,companyId,isReceiver){
        AM.ajaxRequestData(method, false, AM.ip + "/contacts/queryContactsByIsReceiver", {companyId : companyId,
            isReceiver:isReceiver} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }

    /**
     * 通过公司 获取票据列表
     * */
    function queryBillInfoByCompany(selectId,targetView,method,isShow,companyId){
        AM.ajaxRequestData(method, false, AM.ip + "/billInfo/queryBillInfoByCompany", {companyId : companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    /** 票据类型 0：专票 1：普票  2：收据 */
                    var billTypeMsg = "";
                    if(result.data[i].billType == 0){
                        billTypeMsg = "专票";
                    }else if (result.data[i].billType == 1){
                        billTypeMsg = "普票";
                    }else{
                        billTypeMsg = "收据";
                    }
                    var msg = result.data[i].title + "-"+billTypeMsg + "-" + result.data[i].name;
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + msg + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + msg + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }

    /**
     * 通过缴金地的ID 获取 档次集合
     * */
    function getInsuranceLevelByPayPlace(selectId,targetView,method,isShow,payPlaceId,isTuoGuan){
        AM.ajaxRequestData(method, false, AM.ip + "/insuranceLevel/getInsuranceLevelByPayPlace", {payPlaceId : payPlaceId, isTuoGuan : isTuoGuan} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var name = result.data[i].levelName;
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + name + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }


    /**
     * 获取所有的银行
     * */
    function getAllBank(selectId,targetView,method,isShow){
        AM.ajaxRequestData(method, false, AM.ip + "/bank/getAllBank", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var name = result.data[i].bankName;
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + name + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + name + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView).parent().parent().show();
                }

            }
        });
    }







    function buildServiceFeeOption(selectId,targetView,method,isShow){
        AM.ajaxRequestData(method, false, AM.ip + "/serviceFee/queryAllServiceFee", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择服务费配置</option>";;
                for (var i = 0; i < result.data.length; i++) {
                    if(result.data[i].id == 8){
                        continue;
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].describe + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].describe + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetView+"']").html(html);
                if(1 == isShow){
                    $("select[name='"+targetView+"']").parent().parent().show();
                }
            }
        });
    }


    function buildOtherServiceFeeOption(selectId,targetViews,method){
        AM.ajaxRequestData(method, false, AM.ip + "/serviceFee/queryAllServiceFee", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择服务费配置</option>";;
                for (var i = 0; i < result.data.length; i++) {
                    if(result.data[i].id == 8){
                        continue;
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].describe + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].describe + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }

                for(var j = 0; j < targetViews.length; j++){
                    $("#"+targetViews[j]+"").html(html);
                }
            }
        });
    }

    function buildTradeOption(selectId,targetView,method,isShow){

        AM.ajaxRequestData(method, false, AM.ip + "/trade/queryAllTrade", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择行业</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].tradeName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].tradeName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name="+targetView+"]").html(html);
                if(1 == isShow){
                    $("select[name="+targetView+"]").parent().parent().show();
                }
            }
        });

    }




    //省
    function selectProvince(selectId) {
        AM.ajaxRequestData("POST", false, AM.ip + "/city/queryCityByParentId", {levelType : 1} , function(result){
            var html = "<option value=''>请选择或搜索省</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='province']").html(html);
        });
    }

    //市
    function selectCity(cityId, selectId) {
        AM.ajaxRequestData("POST", false, AM.ip + "/city/queryCityByParentId", {cityId : cityId, levelType : 2} , function(result){
            var html = "<option value=\"\">请选择或搜索市</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='city']").html(html);
        });
    }

    //区
    function selectCounty(cityId, selectId) {
        AM.ajaxRequestData("POST", false, AM.ip + "/city/queryCityByParentId", {cityId : cityId, levelType : 3} , function(result){
            var html = "<option value=\"\">请选择或搜索县/区</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
                else {
                    html += "<option title=\"" + result.data[i].mergerName + "\" value=\"" + result.data[i].id + "\">" + result.data[i].shortName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='district']").html(html);
        });
    }

    /**省市分组**/
    function selectProvinceAndCity(selectId, targetView) {
        AM.ajaxRequestData("POST", false, AM.ip + "/city/getCities", {} , function(result){
            var optgroup = "<option value=\"\">请选择或搜索</option>";
            for (var i = 0; i < result.data.length; i++) {
                var obj = result.data[i];
                var option = "";
                for (var j = 0; j < obj.cityList.length; j++) {
                    var city = obj.cityList[j];
                    if (city.id == selectId) {
                        option += '<option selected="selected"  value="' + city.id + '">' + city.name + '</option>';
                    }
                    else {
                        option += '<option value="' + city.id + '">' + city.name + '</option>';
                    }
                }
                //optgroup += "<optgroup label=\"" + obj.name + "\">" + option + "</optgroup>";
                optgroup += option;
            }
            if (result.data.length == 0) {
                optgroup += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name="+targetView+"]").html(optgroup);
        });
    }

    //获取快递公司列表
    function getExpressCompanyList (selectId) {
        AM.ajaxRequestData("post", false, AM.ip + "/express/queryAllExpressCompany", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择快递公司</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].expressCompanyName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].expressCompanyName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='expressCompanyId']").html(html);
            }
        });
    }

 //获取快递公司列表
    function getExpressPersonInfoList (selectId,companyId) {
        AM.ajaxRequestData("post", false, AM.ip + "/expressPersonInfo/queryAllPersonInfoByCompany", {companyId:companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择收件人</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].personName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].personName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='expressPersonId']").html(html);
            }
        });
    }


    //获取角色列表
    function getUserByRole (selectId,targetView,isShow,roleId) {

        AM.ajaxRequestData("get", false, AM.ip + "/user/queryUserByRole", {roleId:roleId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择客服</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetView+"']").html(html);
                if(1 == isShow){
                    $("select[name='"+targetView+"']").parent().parent().show();
                }
            }
        });
    }


    //获取角色列表_
    function queryUserByRoles (selectId,targetView,isShow,flag) {

        AM.ajaxRequestData("get", false, AM.ip + "/user/queryUserByRoles", {flag:flag} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择角色类型</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetView+"']").html(html);
                if(1 == isShow){
                    $("select[name='"+targetView+"']").parent().parent().show();
                }
            }
        });
    }


    //获取商业险下所有的列表
    function getAllSy (selectId,targetView,isShow,businessId) {

        AM.ajaxRequestData("get", false, AM.ip + "/business/queryBusinessItem", {businessId:businessId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "";
                for (var i = 0; i < result.data.length; i++) {
                    var msg = "";
                    if(result.data[i].chargeMethod == 0 ){
                        msg = "按年";
                    }else if(result.data[i].chargeMethod == 1){
                        msg = "按月";
                    }
                    if (result.data[i].id == selectId) {

                        html += "   <div class='col-xs-6'>" +
                                "       <input type='checkbox'  lay-filter = 'businessItemChecked' checked value='"+result.data[i].id+"' name='billMadeMethodSy' title='"+result.data[i].itemName+"'>" +
                                "   </div>" +
                                "   <div class='col-xs-6'>" +
                                "       <input type='number' placeholder='输入价格' disabled  value='"+result.data[i].serviceFee+"' class='layui-input check-input' autocomplete='off' >" +
                                "       <span class='layui-form-mid layui-word-aux check-input-span'>"+msg+"</span>" +
                                "   </div>" ;

                    }
                    else {
                        html += "   <div class='col-xs-6'>" +
                                "       <input type='checkbox' lay-filter = 'businessItemChecked'  value='"+result.data[i].id+"' name='billMadeMethodSy' title='"+result.data[i].itemName+"'>" +
                                "   </div>" +
                                "   <div class='col-xs-6'>" +
                                "       <input type='number' placeholder='输入价格' disabled  value='"+result.data[i].serviceFee+"' class='layui-input check-input' autocomplete='off' >" +
                                "       <span class='layui-form-mid layui-word-aux check-input-span'>"+msg+"</span>" +
                                "   </div>" ;
                    }
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView+"").parent().parent().show();
                }
            }
        });
    }


    var sonBill = null;

    //获取一次性业务下所有的列表
    function getAllYc (selectId,targetView,isShow,businessId,companyId) {
        AM.ajaxRequestData("get", false, AM.ip + "/business/queryBusinessItem", {businessId:businessId,companyId:companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "";

                // 子账单获取
                if(null == sonBill){
                    AM.ajaxRequestData("get", false, AM.ip + "/companySonBill/getCompanySonBillByCompany", {companyId:companyId} , function(result){
                        if(result.flag == 0 && result.code == 200){
                            sonBill = result.data;
                        }
                    });
                }

                for (var i = 0; i < result.data.length; i++) {
                    var msg = "";
                    var v = '';
                    if(result.data[i].isCompany == 0 ){
                        msg = "公司";
                        v = "<select ><option value=''>请选择子账单</option>";
                        for(var k = 0; k < sonBill.length; k++){

                            if(result.data[i].companySonBillId == sonBill[k].id){
                                v += "<option value='"+sonBill[k].id+"' selected>"+sonBill[k].sonBillName+"</option>";
                            }
                            else{
                                v += "<option value='"+sonBill[k].id+"'>"+sonBill[k].sonBillName+"</option>";
                            }

                        }
                        v += "</select>";

                    }else if(result.data[i].isCompany == 1){
                        msg = "员工";
                    }
                    html += "<div class='row'>";
                    if (result.data[i].id == selectId) {

                        html += "   <div class='col-xs-4'>" +
                                "       <input type='checkbox' isCompany='"+result.data[i].isCompany+"' lay-filter = 'businessItemChecked' checked value='"+result.data[i].id+"' name='billMadeMethodYc' title='"+result.data[i].itemName+"'>" +
                                "   </div>" +
                                "   <div class='col-xs-4'>" +
                                "       <input type='number' placeholder='输入价格'  value='"+result.data[i].price+"' class='layui-input check-input' autocomplete='off' >" +
                                "       <span class='layui-form-mid layui-word-aux check-input-span'>"+msg+"</span>" +
                                "   </div>" +
                                "   <div class='col-xs-4 layui-hide'>" +
                                    v+
                                "   </div>";
                    }
                    else {

                        html += "   <div class='col-xs-4'>" +
                                "       <input type='checkbox' isCompany='"+result.data[i].isCompany+"' lay-filter = 'businessItemChecked' value='"+result.data[i].id+"' name='billMadeMethodYc' title='"+result.data[i].itemName+"'>" +
                                "   </div>" +
                                "   <div class='col-xs-4'>" +
                                "       <input type='number'placeholder='输入价格' disabled value='"+result.data[i].price+"' class='layui-input check-input' autocomplete='off' >" +
                                "       <span class='layui-form-mid layui-word-aux check-input-span'>"+msg+"</span>" +
                                "   </div>" +
                                "   <div class='col-xs-4 layui-hide'>" +
                                v+
                                "   </div>";

                    }
                    html += "</div>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView+"").parent().parent().show();
                }
            }
        });
    }



    //获取所有的公司
    function queryAllCompany (selectId,targetView,isShow,oldCompany) {
        AM.ajaxRequestData("get", false, AM.ip + "/company/queryAllCompany", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if(oldCompany == result.data[i].id){
                        continue;
                    }
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].companyName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
                if(1 == isShow){
                    $("#"+targetView+"").parent().parent().show();
                }
            }
        });
    }


    //获取联系人
    function getContacts (selectId,targetView,companyId,isReceiver) {
        AM.ajaxRequestData("get", false, AM.ip + "/contacts/queryContactsByIsReceiver", {companyId:companyId,isReceiver:isReceiver} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择</option>";
                for (var i = 0; i < result.data.length; i++) {

                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].contactsName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
            }
        });
    }

    //获取联系人
    function getBillInfo (selectId,targetView,companyId) {
        AM.ajaxRequestData("get", false, AM.ip + "/billInfo/queryBillInfoByCompany", {companyId:companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择</option>";
                for (var i = 0; i < result.data.length; i++) {

                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].title + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].title + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
            }
        });
    }


    //获取公司下的合作方式
    function getBaseCooperationMethod (selectId,targetView,companyId) {
        AM.ajaxRequestData("get", false, AM.ip + "/company/getBaseCooperationMethod", {companyId:companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择</option>";
                for (var i = 0; i < result.data.length; i++) {
                    var msg = "";
                    if(result.data[i].cooperationMethodId == 0){
                        msg = "普通";
                    }
                    if(result.data[i].cooperationMethodId == 1){
                        msg = "派遣";
                    }
                    if(result.data[i].cooperationMethodId == 2){
                        msg = "外包";
                    }


                    if (result.data[i].cooperationMethodId == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].cooperationMethodId + "\">" + msg + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].cooperationMethodId + "\">" + msg + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("#"+targetView+"").html(html);
            }
        });
    }


    //获取角色列表
    function getRoleList (selectId) {
        AM.ajaxRequestData("get", false, AM.ip + "/role/list", {} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">请选择</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].roleName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='roleId']").html(html);
                $("select[name='roleId']").parent().parent().show();
            }
        });
    }

    //获取平台用户列表
    function getUserList (selectId) {
        AM.ajaxRequestData("get", false, AM.ip + "/user/queryUserList", {
            page : 0,
            pageSize : 99999
        } , function(result){
            var html = "<option value=\"\">请选择</option>";
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].userName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
            $("select[name='userId']").html(html);
            $("select[name='userId']").parent().parent().show();
        });
    }


    //根据角色地区获取用户列表
    function getRoleUserList(selectId,roleId,provinceId , cityId , districtId , msg) {
        var ary = {
            roleId:roleId,
            provinceId : provinceId ,
            cityId : cityId,
            districtId : districtId
        }
        AM.ajaxRequestData("get", false, AM.ip + "/user/listForSelect", ary , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=\"\">" + msg + "</option>";
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].showName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].showName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='parentId']").html(html);
                $("select[name='parentId']").parent().parent().show();
            }
        });
    }


    /**计算精度**/
    function calculate (obj, accuracy) {
        AM.log(accuracy);
        var $input = $(obj);
        var value = $input.val();
        if (accuracy == -1) {
            if (value.length == 1 && value == 0) {
                $input.val(10);
            }
            else if (value.length == 1 && value > 0) {
                $input.val(value + "0");
            }
                else if (value.length > 1){
                value = value.substring(0, value.length - 1);
                $input.val(value + "0");
            }
        }
        else if (accuracy == -2) {
            if (value.length == 1 && value == 0) {
                $input.val(100);
            }
            else if (value.length == 1 && value > 0) {
                $input.val(value + "00");
            }
            else if (value.length == 2 && value > 0){
                value = value.substring(0, value.length - 1);
                $input.val(value + "00");
            }
            else if (value.length > 2){
                value = value.substring(0, value.length - 2);
                $input.val(value + "00");
            }
        }
    }

    /**查询公司下的所有子账单**/
    function getCompanySonBillByCompany(selectId,targetView, isShow, companyId){
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/getCompanySonBillByCompany", {companyId : companyId} , function(result){
            if(result.flag == 0 && result.code == 200){
                var html = "<option value=''>请选择或搜索</option>";;
                for (var i = 0; i < result.data.length; i++) {
                    if (result.data[i].id == selectId) {
                        html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].sonBillName + "</option>";
                    }
                    else {
                        html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].sonBillName + "</option>";
                    }
                }
                if (result.data.length == 0) {
                    html += "<option value=\"0\" disabled>暂无</option>";
                }
                $("select[name='"+targetView+"']").html(html);
                if(1 == isShow){
                    $("select[name='"+targetView+"']").parent().parent().show();
                }
            }
        });
    }

    /**查询公司下的所有子账单--返回HTML**/
    function getCompanySonBillByCompanyHTML(selectId, companyId){
        var html = "";
        AM.ajaxRequestData("post", false, AM.ip + "/companySonBill/getCompanySonBillByCompany", {companyId : companyId} , function(result){
            for (var i = 0; i < result.data.length; i++) {
                if (result.data[i].id == selectId) {
                    html += "<option selected=\"selected\" value=\"" + result.data[i].id + "\">" + result.data[i].sonBillName + "</option>";
                }
                else {
                    html += "<option value=\"" + result.data[i].id + "\">" + result.data[i].sonBillName + "</option>";
                }
            }
            if (result.data.length == 0) {
                html += "<option value=\"0\" disabled>暂无</option>";
            }
        });
        return html;
    }

    function getBusiness(id){
        var businessName = "";
        switch (Number(id)){
            case 1:
                businessName = "派遣";
                break;
            case 2:
                businessName = "外包";
                break;
            case 3:
                businessName = "社保";
                break;
            case 4:
                businessName = "公积金";
                break;
            case 5:
                businessName = "工资";
                break;
            case 6:
                businessName = "商业险";
                break;
            case 7:
                businessName = "一次性业务";
                break;
            default:
                businessName = "未知";
                break;
        }
        return businessName;
    }




    $(function () {
        checkJurisdiction();

        document.onkeydown = function(event) {
            var code;
            if (!event) {
                event = window.event; //针对ie浏览器
                code = event.keyCode;
                if (code == 13) {
                    if (document.getElementsByClassName("layui-layer-btn0").length > 0) {
                        document.getElementsByClassName("layui-layer-btn0")[0].click();
                    }
                    if (document.getElementById("unlock")) {
                        document.getElementById("unlock").click();
                    }
                }
            }
            else {
                code = event.keyCode;
                if (code == 13) {
                    if (document.getElementsByClassName("layui-layer-btn0").length > 0) {
                        document.getElementsByClassName("layui-layer-btn0")[0].click();
                    }
                    if (document.getElementById("unlock")) {
                        document.getElementById("unlock").click();
                    }
                }
            }
        };

        $(".layui-btn").blur();

    });

    function getServiceConfigHtml(){
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
                    msg += getBusiness(names[j]) + "+";
                }
                msg = msg.substring(0, msg.length - 1);
                var v = 0.0;

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


    function getOtherServiceConfigHtml(prefix){
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


</script>