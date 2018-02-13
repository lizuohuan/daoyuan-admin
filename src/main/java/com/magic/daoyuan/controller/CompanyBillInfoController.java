package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.CompanyBillInfo;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.enums.BillType;
import com.magic.daoyuan.business.service.CompanyBillInfoService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.apache.regexp.RE;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/9/20 0020.
 */

@RestController
@RequestMapping("/billInfo")
public class CompanyBillInfoController extends BaseController {

    @Resource
    private CompanyBillInfoService companyBillInfoService;



    @RequestMapping("/queryBillInfoByCompany")
    public ViewData queryBillInfoByCompany(Integer companyId){
        if(null == companyId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyBillInfoService.queryBillInfo(companyId));
    }


    @RequestMapping("/queryBillInfoById")
    public ViewData queryBillInfoById(Integer id){
        if(null == id){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyBillInfoService.queryBillInfoById(id));
    }

    /**
     * 获取公司 票据信息列表
     * @param companyId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryBillInfo")
    public ViewDataPage queryBillInfo(Integer companyId, PageArgs pageArgs){
        if(null == companyId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("companyId",companyId);
        PageList<CompanyBillInfo> dataList = companyBillInfoService.queryBillInfoByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }

    /**
     * updateBillInfo 更新
     * @param billInfo
     * @return
     */
    @RequestMapping("/updateBillInfo")
    public ViewData updateBillInfo(CompanyBillInfo billInfo){
        if(CommonUtil.isEmpty(billInfo.getId())){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        companyBillInfoService.updateBillInfo(billInfo,LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    
    /**
     * addBillInfo 新增
     * @param billInfo
     * @return
     */
    @RequestMapping("/addBillInfo")
    public ViewData addBillInfo(CompanyBillInfo billInfo){
        if(null == billInfo.getCompanyId()){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        if(BillType.SpecialInvoice.ordinal() == billInfo.getBillType()){
            // 如果是专票 则发票信息全部必填
            if(CommonUtil.isEmpty(billInfo.getPhone(),billInfo.getAccountName(),billInfo.getAddress(),billInfo.getBankAccount(),
                    billInfo.getTaxNumber(),billInfo.getTitle())){
                return buildFailureJson(StatusConstant.Fail_CODE,"票据所有选项必填");
            }
        }
        else if(BillType.TaxInvoice.ordinal() == billInfo.getBillType()){
            // 如果是普通发票 则 发票抬头和税号必填
            if(CommonUtil.isEmpty(billInfo.getTaxNumber(),billInfo.getTitle())){
                return buildFailureJson(StatusConstant.Fail_CODE,"抬头和税号必填");
            }
        }
        else if(BillType.Voucher.ordinal() == billInfo.getBillType()){
            // 如果是收据 则 发票抬头必填
//            if(CommonUtil.isEmpty(billInfo.getTitle())){
//                return buildFailureJson(StatusConstant.Fail_CODE,"抬头必填");
//            }
        }
        else{
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        billInfo.setIsCopy(0);
        companyBillInfoService.addBillInfo(billInfo, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
