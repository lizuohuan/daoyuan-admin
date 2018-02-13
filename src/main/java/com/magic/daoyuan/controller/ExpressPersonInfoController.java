package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.ExpressPersonInfo;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.ExpressPersonInfoService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/9/26 0026.
 */
@RestController
@RequestMapping("/expressPersonInfo")
public class ExpressPersonInfoController extends BaseController {

    @Resource
    private ExpressPersonInfoService expressPersonInfoService;


    @RequestMapping("/queryExpressPersonInfo")
    public ViewDataPage queryExpressPersonInfo(Integer companyId, PageArgs pageArgs){
        PageList<ExpressPersonInfo> dataList = expressPersonInfoService.queryInfoByItems(companyId, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }


    @RequestMapping("/queryPersonInfoById")
    public ViewData queryPersonInfoById(Integer id){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                expressPersonInfoService.queryPersonInfoById(id));
    }


    @RequestMapping("/queryAllPersonInfoByCompany")
    public ViewData queryAllPersonInfoByCompany(Integer companyId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                expressPersonInfoService.queryAllPersonInfoByCompany(companyId));
    }


    @RequestMapping("/addExpressPersonInfo")
    public ViewData addExpressPersonInfo(ExpressPersonInfo info){
        expressPersonInfoService.addExpressPersonInfo(info);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }




    @RequestMapping("/updateExpressPersonInfo")
    public ViewData updateExpressPersonInfo(ExpressPersonInfo info){
        if(null == info.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        expressPersonInfoService.updateExpressPersonInfo(info);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
