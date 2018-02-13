package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.BankInfo;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.BankInfoService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 公司银行信息
 * Created by Eric Xie on 2017/10/30 0030.
 */

@RestController
@RequestMapping("/bankInfo")
public class BankInfoController extends BaseController {


    @Resource
    private BankInfoService bankInfoService;


    @RequestMapping("/getBankInfo")
    public ViewDataPage getBankInfo(Integer companyId, PageArgs pageArgs){

        if(null == companyId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        PageList<BankInfo> bankInfo = bankInfoService.getBankInfo(companyId, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",bankInfo.getTotalSize(),
                bankInfo.getList());

    }


    @RequestMapping("/addBankInfo")
    public ViewData addBankInfo(BankInfo bankInfo){
        if(CommonUtil.isEmpty(bankInfo.getBankAccount(),bankInfo.getAccountName(),bankInfo.getCompanyId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            bankInfoService.addBankInfo(bankInfo);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    @RequestMapping("/updateBankInfo")
    public ViewData updateBankInfo(BankInfo bankInfo){
        if(CommonUtil.isEmpty(bankInfo.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            bankInfoService.updateBankInfo(bankInfo);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }




}
