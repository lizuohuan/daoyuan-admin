package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Contract;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.ContractService;
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
 * 合同
 * Created by Eric Xie on 2017/9/20 0020.
 */
@RestController
@RequestMapping("/contract")
public class ContractController extends BaseController {

    @Resource
    private ContractService contractService;

    /**
     * 获取合同详情
     * @param contractId
     * @return
     */
    @RequestMapping("/queryContractById")
    public ViewData queryContractById(Integer contractId){
        if(null == contractId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                contractService.queryContract(contractId));
    }

    /**
     * 获取 合同列表
     * @param companyId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryContract")
    public ViewDataPage queryContract(Integer companyId, PageArgs pageArgs){
        if(null == companyId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("companyId",companyId);
        PageList<Contract> dataList = contractService.queryContractByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }

    /**
     * 新增合同
     * @param contract
     * @param attachmentArr
     * @return
     */
    @RequestMapping("/addContract")
    public ViewData addContract(Contract contract,String attachmentArr){
        if(CommonUtil.isEmpty(contract.getCompanyId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        attachmentArr = "["+attachmentArr+"]";
        try {
            contractService.addContract(contract,attachmentArr);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 修改合同
     * @param contract
     * @param attachmentArr
     * @return
     */
    @RequestMapping("/updateContract")
    public ViewData updateContract(Contract contract,String attachmentArr){
        if(CommonUtil.isEmpty(contract.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        attachmentArr = "["+attachmentArr+"]";
        try {
            contractService.updateContract(contract,attachmentArr);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 修改合同
     * @param contract
     * @return
     */
    @RequestMapping("/updateContractIsValid")
    public ViewData updateContractIsValid(Contract contract){
        if(CommonUtil.isEmpty(contract.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            contractService.updateContract(contract);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

}
