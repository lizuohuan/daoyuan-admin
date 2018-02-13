package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.SalaryInfo;
import com.magic.daoyuan.business.service.SalaryInfoService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by Eric Xie on 2017/10/20 0020.
 */

@RestController
@RequestMapping("/salaryInfo")
public class SalaryInfoController extends BaseController {

    @Resource
    private SalaryInfoService salaryInfoService;


    @RequestMapping("/getSalaryInfo")
    public ViewDataPage getSalaryInfo(Integer companySonTotalBillId, PageArgs pageArgs,Long billMonth,Integer companyId){

        if(null == companySonTotalBillId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        PageList<SalaryInfo> dataList =
                salaryInfoService.querySalaryInfo(companySonTotalBillId, pageArgs,new Date(billMonth),companyId);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());

    }
    @RequestMapping("/getSalaryInfo2")
    public ViewDataPage getSalaryInfo2(PageArgs pageArgs,Long billMonth,Integer companyId){

        if(null == billMonth || null == companyId){
            return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        PageList<SalaryInfo> dataList = salaryInfoService.querySalaryInfo(null, pageArgs,new Date(billMonth),companyId);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());

    }


}
