package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.service.StatisticsService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;

/**
 * 统计接口
 * Created by Eric Xie on 2017/12/21 0021.
 */
@RestController
@RequestMapping(value = "/statistics")
public class StatisticsController extends BaseController {

    @Resource
    private StatisticsService statisticsService;

    /**
     * 统计合作中的公司
     * @param flag 0 日  1 周  2 月
     * @return
     */
    @RequestMapping(value = "/effectiveCompany",method = RequestMethod.POST)
    public ViewData statisticsEffectiveCompany(Integer flag,Long startTimeStamp,Long endTimeStamp){
        if(null == flag){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1 && flag != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            Map<String, Object> data =  statisticsService.statisticsEffectiveCompany(flag, null == startTimeStamp ? null : new Date(startTimeStamp),
                    null == endTimeStamp ? null : new Date(endTimeStamp));
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    data);
        }catch (Exception e){
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }
    }


    /**
     * 统计 新增、终止公司数量
     * @return
     */
    @RequestMapping(value = "/companyCount",method = RequestMethod.POST)
    public ViewData statisticsCompanyCount(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    statisticsService.statisticsCompanyCount(new Date()));
    }

    /**
     *  统计员工人数
     * @param flag 0 日  1 周  2 月
     * @param payPlaceId 缴金地ID
     * @param startTimeStamp 开始日期
     * @param endTimeStamp 截至日期
     * @param more 大于员工的数量
     * @param less 小于员工的数量
     * @return
     */
    @RequestMapping(value = "/statisticsMember",method = RequestMethod.POST)
    public ViewData statisticsMember(Integer flag,Integer payPlaceId,Long startTimeStamp,Long endTimeStamp,Integer more,Integer less){

        if(null == flag){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1 && flag != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            Map<String, Object> stringObjectMap =  statisticsService.statisticsMember(flag, payPlaceId, null == startTimeStamp ? null : new Date(startTimeStamp), null == endTimeStamp ? null : new Date(endTimeStamp),
                    more, less);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",stringObjectMap);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }
    }

    /**
     * 统计 新增、终止员工数量
     * @return
     */
    @RequestMapping(value = "/countMemberByDate",method = RequestMethod.POST)
    public ViewData countMemberByDate(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                statisticsService.countMemberByDate(new Date()));
    }


    /**
     * 确认率/核销率 统计
     * @param more
     * @param less
     * @param serviceAmount
     * @param day
     * @param type 0:确认率  1：核销率
     * @return
     */
    @RequestMapping(value = "/billIdentificationRate",method = RequestMethod.POST)
    public ViewData billIdentificationRate(Integer more,Integer less,Double serviceAmount,Integer day,Integer type){
        if(CommonUtil.isEmpty(type,day)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        try {
            Map<String, Object> map = statisticsService.billIdentificationRate(more, less, serviceAmount, day, type);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",map);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }
    }



    /**
     * 当月每天的 确认率/核销率 统计
     * @param type 0:确认率  1：核销率
     * @return
     */
    @RequestMapping(value = "/billIdentificationRateOfMonth",method = RequestMethod.POST)
    public ViewData billIdentificationRateOfMonth(Integer type){
        if(CommonUtil.isEmpty(type)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        try {
            Map<String, Object> map = statisticsService.billIdentificationRateOfMonth(type);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",map);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"统计失败");
        }
    }









}
