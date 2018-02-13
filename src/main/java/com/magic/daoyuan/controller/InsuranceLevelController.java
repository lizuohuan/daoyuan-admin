package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.InsuranceLevel;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.PayTheWay;
import com.magic.daoyuan.business.service.InsuranceLevelService;
import com.magic.daoyuan.business.service.InsuranceService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/9/27 0027.
 */

@RestController
@RequestMapping("/insuranceLevel")
public class InsuranceLevelController extends BaseController {

    @Resource
    private InsuranceLevelService insuranceLevelService;


    /**
     * 通过缴金地 查询缴金地下所有的险种档次集合
     * @param payPlaceId
     * @return
     */
    @RequestMapping("/getInsuranceLevelByPayPlace")
    public ViewData getInsuranceLevelByPayPlace(Integer payPlaceId,Integer isTuoGuan){
        if (CommonUtil.isEmpty(isTuoGuan,payPlaceId)) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                insuranceLevelService.queryInsuranceLevelByPayPlace(payPlaceId,isTuoGuan));
    }

    /**
     * 获取 档次列表集合
     * @param payPlaceId 缴金地ID
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getInsuranceLevel")
    public ViewDataPage getInsuranceLevel(Integer payPlaceId, PageArgs pageArgs,
                                          Integer insuranceId, Integer insuranceLevelId){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("payPlaceId",payPlaceId);
        params.put("insuranceId",insuranceId);
        params.put("insuranceLevelId",insuranceLevelId);
        PageList<InsuranceLevel> dataList = insuranceLevelService.getInsuranceLevel(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }


    /**
     * 通过ID 查询
     * @param id
     * @return
     */
    @RequestMapping("/getInsuranceLevelById")
    public ViewData getInsuranceLevelById(Integer id){
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                insuranceLevelService.getInsuranceLevelById(id));
    }

    /**
     * 更新 档次
     * @param level
     * @return
     */
    @RequestMapping("/updateInsuranceLevel")
    public ViewData update(InsuranceLevel level){
        if(null == level.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            insuranceLevelService.updateInsuranceLevel(level);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 新增 档次
     * @param level
     * @return
     */
    @RequestMapping("/addInsuranceLevel")
    public ViewData add(InsuranceLevel level){
        try {
            insuranceLevelService.addInsuranceLevel(level);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
