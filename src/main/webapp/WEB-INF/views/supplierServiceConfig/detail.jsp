<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>缴金地详情</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .display{border: 1px solid #e2e2e2;}
        .display td{padding: 6px 10px;font-size: 12px;}
    </style>
</head>
<body ng-app="webApp" ng-controller="controller" ng-cloak>
<div style="margin: 15px;">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;缴金地详情</legend>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>社保</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th></th>
                    <th colspan="{{typesOfInsurance.length}}" style="background: #6495ED">公司</th>
                    <th colspan="{{typesOfInsurance.length}}" style="background: #90EE90;">个人</th>
                </tr>
                <tr>
                    <th>档次</th>
                    <th ng-repeat="data in typesOfInsurance">{{data.insuranceName}}</th>
                    <th ng-repeat="data in typesOfInsurance">{{data.insuranceName}}</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="data in insurancesLevelList">
                    <td>{{data.levelName}}</td>
                    <td ng-repeat="d in data.payTheWays">{{d.coPayPrice}}</td>
                    <td ng-repeat="d in data.payTheWays">{{d.mePayPrice}}</td>
                </tr>
                </tbody>

                <tfoot>
                <tr ng-if="expressageList.length == 0">
                    <td colspan="99" align="center">暂无</td>
                </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>基数范围</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th></th>
                    <th colspan="{{typesOfInsurance.length}}" style="background: #6495ED">公司</th>
                    <th colspan="{{typesOfInsurance.length}}" style="background: #90EE90;">个人</th>
                </tr>
                <tr>
                    <th>档次</th>
                    <th ng-repeat="data in typesOfInsurance">{{data.insuranceName}}</th>
                    <th ng-repeat="data in typesOfInsurance">{{data.insuranceName}}</th>
                </tr>
                </thead>
                <tbody>
                <tr ng-repeat="data in insurancesLevelList">
                    <td>{{data.levelName}}</td>
                    <td ng-repeat="d in data.payTheWays">{{d.coMinScope}} - {{d.coMaxScope}}</td>
                    <td ng-repeat="d in data.payTheWays">{{d.meMinScope}} - {{d.meMaxScope}}</td>
                </tr>
                </tbody>

                <tfoot>
                <tr ng-if="insurancesLevelList.length == 0">
                    <td colspan="99" align="center">暂无</td>
                </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>经办机构</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>经办机构</th>
                    <th>办理方</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in organizations">
                        <td>{{data.organizationName}}</td>
                        <td>
                            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                                <tr ng-repeat="d in data.transactors">
                                    <td width="200px">{{d.transactorName}}</td>
                                    <td>
                                        <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                                            <tr>
                                                <th></th>
                                                <th colspan="{{d.payTheWays.length / 2}}" style="background: #6495ED">公司</th>
                                                <th colspan="{{d.payTheWays.length / 2}}" style="background: #90EE90;">个人</th>
                                            </tr>
                                            <tr>
                                                <td width="100px">档次</td>
                                                <td ng-repeat="c in d.companyList">{{c.insuranceName}}</td>
                                                <td ng-repeat="c in d.personList">{{c.insuranceName}}</td>
                                            </tr>
                                            <tr ng-repeat="p in d.insuranceNameList">
                                                <td>{{p.insuranceLevelName}}</td>
                                                <td ng-repeat="c in d.companyList">{{c.coPayPrice}}</td>
                                                <td ng-repeat="c in d.personList">{{c.mePayPrice}}</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </tbody>

                <tfoot>
                <tr ng-if="organizations.length == 0">
                    <td colspan="99" align="center">暂无</td>
                </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field">
        <legend>公积金</legend>
        <div class="layui-field-box layui-form">
            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                <thead>
                <tr>
                    <th>经办机构</th>
                    <th>基数范围</th>
                    <th>办理方</th>
                    <th>比例上下先限</th>
                </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="data in accumulationFund">
                        <td>{{data.organizationName}}</td>
                        <td>{{data.minCardinalNumber}} - {{data.maxCardinalNumber}}</td>
                        <td>
                            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                                <tr ng-repeat="t in data.transactors">
                                    <td>{{t.transactorName}}</td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table class="layui-table admin-table table-bordered display" cellspacing="0" width="100%">
                                <tr ng-repeat="t in data.transactors">
                                    <td ng-if="t.minScope == t.maxScope">{{t.minScope}}%</td>
                                    <td ng-if="t.minScope != t.maxScope">{{t.minScope}}% - {{t.maxScope}}%</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </tbody>

                <tfoot>
                <tr ng-if="accumulationFund.length == 0">
                    <td colspan="99" align="center">暂无</td>
                </tr>
                </tfoot>
            </table>
        </div>
    </fieldset>



</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("controller", function($scope,$http,$timeout){

        $scope.insurancesLevelList = null; //档次
        $scope.typesOfInsurance = null // 险种
        $scope.organizations = null // 经办机构
        $scope.accumulationFund = null // 公积金
        $scope.cityId = AM.getUrlParam("cityId");
        AM.ajaxRequestData("get", false, AM.ip + "/payPlace/getOTILInsuranceByCityId", {cityId : $scope.cityId} , function(result) {
            $scope.insurancesLevelList = result.data[2].insurancesLevelList;
            $scope.typesOfInsurance = $scope.insurancesLevelList[0].payTheWays;
            $scope.organizations = result.data[0].organizations;
            $scope.accumulationFund = result.data[1].organizations;

            for (var i = 0; i < $scope.organizations.length; i++) {
                var organization = $scope.organizations[i];
                for (var j = 0; j < organization.transactors.length; j++) {
                    var transactor = organization.transactors[j];
                    transactor.companyList = [];
                    transactor.personList = [];
                    transactor.insuranceNameList = [];
                    transactor.companyList.push(transactor.payTheWays[0]);
                    transactor.personList.push(transactor.payTheWays[0]);
                    for (var k = 0; k < transactor.payTheWays.length; k++) {
                        var payTheWay = transactor.payTheWays[k];
                        if (transactor.companyList[0].insuranceLevelId == payTheWay.insuranceLevelId) {
                            transactor.companyList.push(payTheWay);
                        }
                        else {
                            transactor.personList.push(payTheWay);
                        }

                        if (transactor.insuranceNameList.indexOf(payTheWay.insuranceLevelName) == -1) {
                            transactor.insuranceNameList.push(payTheWay);
                        }
                    }
                    transactor.companyList.shift();
                    transactor.personList.shift();
                    transactor.insuranceNameList = transactor.payTheWays.distinct();
                }
            }
        });

        layui.use(['form', 'layedit'], function() {
            var form = layui.form();

        });

    });


</script>
</body>
</html>
