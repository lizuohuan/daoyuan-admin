package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.service.BusinessInsuranceService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/10/25 0025.
 */

@RestController
@RequestMapping("/businessInsurance")
public class BusinessInsuranceController extends BaseController {


    @Resource
    private BusinessInsuranceService businessInsuranceService;



    @RequestMapping("/getBusinessInsurance")
    public ViewData getBusinessInsurance(Integer companySonTotalBillId){
        if(null == companySonTotalBillId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                businessInsuranceService.getBusinessInsurance(companySonTotalBillId));
    }


    @RequestMapping("/getBusinessInsurance2")
    public ViewData getBusinessInsurance2(Integer companyId,Long billMonth){
        if(null == companyId || null == billMonth){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                businessInsuranceService.getBusinessInsurance2(companyId,new Date(billMonth)));
    }


}
