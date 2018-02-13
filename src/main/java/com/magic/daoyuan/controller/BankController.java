package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Bank;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.BankService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/10/10 0010.
 */
@RestController
@RequestMapping("/bank")
public class BankController extends BaseController {

    @Resource
    private BankService bankService;




    /**
     * 分页获取
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getBank")
    public ViewDataPage getBank(PageArgs pageArgs){
        PageList<Bank> data = bankService.queryBank(pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }

    /**
     * 获取所有银行
     * @return
     */
    @RequestMapping("/getAllBank")
    public ViewData getAllBank(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                bankService.queryAllBank());
    }

    /**
     * 获取银行
     * @return
     */
    @RequestMapping("/getBankById")
    public ViewData getBankById(Integer id){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                bankService.queryBankById(id));
    }

    /**
     * 新增
     * @param bank
     * @return
     */
    @RequestMapping("/add")
    public ViewData add(Bank bank){
        if(CommonUtil.isEmpty(bank.getBankName())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        bankService.addBank(bank);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 修改
     * @param bank
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Bank bank){
        if(CommonUtil.isEmpty(bank.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        bankService.updateBank(bank);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

}
