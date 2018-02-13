package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Business;
import com.magic.daoyuan.business.entity.BusinessItem;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.BusinessService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/9/12 0012.
 */
@RestController
@RequestMapping("/business")
public class BusinessController extends BaseController {

    @Resource
    private BusinessService businessService;


    /**
     * 通过公司 查询公司下的业务集合
     * @param companyId
     * @return
     */
    @RequestMapping("/queryBusinessByCompany")
    public ViewData queryBusinessByCompany(Integer companyId){
        if(null == companyId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                businessService.queryBusinessByCompany(companyId));
    }

    /**
     * 分页获取业务
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryBusinessItemByItem")
    public ViewDataPage queryBusinessByItem(PageArgs pageArgs,Integer businessId){
        if(null == businessId){
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"获取失败");
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("businessId",businessId);
        PageList<BusinessItem> dataList = businessService.queryBusinessByItems(params,pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }

    /**
     * 分页获取业务
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryBusinessByItem")
    public ViewDataPage queryBusinessByItem(PageArgs pageArgs){
        PageList<Business> dataList = businessService.queryBusinessByItems(pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }

    /**
     * 修改业务
     * @param business
     * @return
     */
    @RequestMapping("/updateBusiness")
    public ViewData updateBusiness(Business business){
        if(CommonUtil.isEmpty(business.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        businessService.updateBusiness(business);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 修改业务子类
     * @param business
     * @return
     */
    @RequestMapping("/updateBusinessItem")
    public ViewData updateBusiness(BusinessItem business){
        if(CommonUtil.isEmpty(business.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
//        if(business.getBusinessId() <= 5){
//            return buildFailureJson(StatusConstant.Fail_CODE,"该业务不能添加");
//        }
        businessService.updateBusiness(business,LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增业务子类
     * @param business
     * @return
     */
    @RequestMapping("/addBusinessItem")
    public ViewData addBusiness(BusinessItem business){
        if(CommonUtil.isEmpty(business.getItemName(),business.getBusinessId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(business.getBusinessId() <= 5){
            return buildFailureJson(StatusConstant.Fail_CODE,"该业务不能添加");
        }
        businessService.addBusiness(business, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增业务
     * @param business
     * @return
     */
    @RequestMapping("/addBusiness")
    public ViewData addBusiness(Business business){
        if(CommonUtil.isEmpty(business.getBusinessName())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"业务名不能为空");
        }
        businessService.addBusiness(business);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 获取所有的 业务
     * @return
     */
    @RequestMapping("/queryBusiness")
    public ViewData queryBusiness(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                businessService.queryBusiness());
    }

    /**
     * 获取所有的 业务子类
     * @return
     */
    @RequestMapping("/queryBusinessItem")
    public ViewData queryBusiness(Integer businessId,Integer companyId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                businessService.queryBusiness(businessId,companyId));
    }

}
