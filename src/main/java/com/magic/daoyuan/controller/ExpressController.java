package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.ExpressCompany;
import com.magic.daoyuan.business.entity.ExpressInfo;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.ExpressService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import com.sun.glass.ui.View;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 快递类 控制器
 * Created by Eric Xie on 2017/9/21 0021.
 */

@RestController
@RequestMapping("/express")
public class ExpressController extends BaseController {


    @Resource
    private ExpressService expressService;



    /**
     * 分页获取快递信息 集合
     * @param companyId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryExpressInfo")
    public ViewDataPage queryExpressInfo(Integer companyId,PageArgs pageArgs,String orderNumber,Integer expressCompanyId,
                                         Integer isReceive){
        if(null == companyId){
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"字段不能为空");
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("companyId",companyId);
        params.put("orderNumber",CommonUtil.isEmpty(orderNumber) ? null : orderNumber);
        params.put("expressCompanyId",CommonUtil.isEmpty(expressCompanyId) ? null : expressCompanyId);
        params.put("isReceive",CommonUtil.isEmpty(isReceive) ? null : isReceive);
        PageList<ExpressInfo> dataList = expressService.queryExpressInfo(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }


    /**
     * 获取快递信息详情
     * @param id
     * @return
     */
    @RequestMapping("/queryExpressInfoById")
    public ViewData queryExpressInfoById(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                expressService.queryExpressInfoById(id));
    }



    /**
     * 获取快递公司详情
     * @param id
     * @return
     */
    @RequestMapping("/queryExpressCompanyById")
    public ViewData queryExpressCompanyById(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                expressService.queryExpressCompanyById(id));
    }

    /**
     * 分页获取快递公司列表
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryExpressCompany")
    public ViewDataPage queryExpressCompany(PageArgs pageArgs){
        PageList<ExpressCompany> dataList = expressService.queryExpressCompany(pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }


    /**
     * 获取所有的快递公司
     * @return
     */
    @RequestMapping("/queryAllExpressCompany")
    public ViewData queryAllExpressCompany(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                expressService.queryAllExpressCompany());
    }

    /**
     * 更新快递信息
     * @param expressInfo
     * @return
     */
    @RequestMapping("/updateExpressInfo")
    public ViewData updateExpressInfo(ExpressInfo expressInfo){
        if(CommonUtil.isEmpty(expressInfo.getId())){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        expressService.updateExpressInfo(expressInfo);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 更新快递公司
     * @param expressCompany
     * @return
     */
    @RequestMapping("/updateExpressCompany")
    public ViewData updateExpressCompany(ExpressCompany expressCompany){
        if(CommonUtil.isEmpty(expressCompany.getId())){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        expressService.updateExpressCompany(expressCompany);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增快递信息
     * @param expressInfo
     * @return
     */
    @RequestMapping("/addExpressInfo")
    public ViewData addExpressInfo(ExpressInfo expressInfo){
        if(CommonUtil.isEmpty(expressInfo.getCompanyId(),expressInfo.getOrderNumber())){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空");
        }
        expressService.addExpressInfo(expressInfo);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 新增快递公司
     * @param expressCompany
     * @return
     */
    @RequestMapping("/addExpressCompany")
    public ViewData addExpressCompany(ExpressCompany expressCompany){
        if(CommonUtil.isEmpty(expressCompany.getExpressCompanyName())){
            return buildFailureJson(StatusConstant.Fail_CODE,"名称不能为空");
        }
        expressService.addExpressCompany(expressCompany);
        return buildFailureJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



}
