package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Organization;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.OrganizationService;
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
 * Created by Eric Xie on 2017/9/27 0027.
 */

@RestController
@RequestMapping("/organization")
public class OrganizationController extends BaseController {


    @Resource
    private OrganizationService organizationService;


    /**
     * 通过经办机构 获取上下限
     * @param organizationId
     * @return
     */
    @RequestMapping("/countByOrganization")
    public ViewData countByOrganization(Integer organizationId){
        if(CommonUtil.isEmpty(organizationId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                organizationService.countByOrganization(organizationId));
    }

    /**
     * 计算 缴金地下的最大基数 和 最小基数
     * @param payPlaceId
     * @return
     */
    @RequestMapping("/countBaseNumber")
    public ViewData countBaseNumber(Integer payPlaceId){
        if(null == payPlaceId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                organizationService.countBaseNumber(payPlaceId));
    }

    /**
     * 通过缴金地 查询经办机构的ID 和 名称
     * @param payPlaceId 缴金地ID
     * @return
     */
    @RequestMapping("/getOrganizationByPayPlace")
    public ViewData getOrganizationByPayPlace(Integer payPlaceId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                organizationService.queryOrganizationByPayPlace(payPlaceId));
    }

    /**
     * 通过缴金地 查询经办机构的ID 和 名称
     * @param payPlaceId 缴金地ID
     * @return
     */
    @RequestMapping("/getOrganizationByItem")
    public ViewData getOrganizationByItem(Integer payPlaceId,Integer type){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                organizationService.queryOrganizationByPayPlace(payPlaceId,type));
    }

    /**
     * 获取经办机构
     * @param payPlaceId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getOrganization")
    public ViewDataPage getOrganization(Integer payPlaceId, PageArgs pageArgs){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("payPlaceId",payPlaceId);
        PageList<Organization> dataList = organizationService.getOrganization(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }

    /**
     *  通过ID
     * @param id
     * @return
     */
    @RequestMapping("/getOrganizationById")
    public ViewData getOrganizationById(Integer id){
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                organizationService.getOrganizationById(id));
    }

    /**
     * 更新
     * @param organization
     * @return
     */
    @RequestMapping("/updateOrganization")
    public ViewData update(Organization organization){
        if(null == organization.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        organizationService.updateOrganization(organization, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    @RequestMapping("/addOrganization")
    public ViewData add(Organization organization){
        organizationService.addOrganization(organization, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
