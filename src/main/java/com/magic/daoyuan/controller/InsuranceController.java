package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Insurance;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.PayPlace;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.InsuranceService;
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
 * 险种控制器
 * Created by Eric Xie on 2017/9/27 0027.
 */
@RestController
@RequestMapping("/insurance")
public class InsuranceController extends BaseController {


    @Resource
    private InsuranceService insuranceService;



    /**
     * 险种列表接口
     * @param payPlaceId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getInsurance")
    public ViewDataPage getInsurance(Integer payPlaceId, PageArgs pageArgs){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("payPlaceId",payPlaceId);
        PageList<Insurance> dataList = insuranceService.getInsuranceByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }



    /**
     * 获取单个险种
     * @return
     */
    @RequestMapping("/getInsuranceById")
    public ViewData getInsuranceById(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                insuranceService.getInsuranceById(id));

    }


    /**
     * 获取缴金地下跟随办理方的险种及档次
     * @param payPlaceId 缴金地id
     * @return
     */
    @RequestMapping("/getByPayPlaceId")
    public ViewData getByPayPlaceId(Integer payPlaceId,String insuranceIds){
        if(CommonUtil.isEmpty(payPlaceId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                insuranceService.getByPayPlaceId(payPlaceId));

    }





    /**
     * 更新缴金地下的险种
     * @param insurance
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Insurance insurance){
        if(CommonUtil.isEmpty(insurance.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        insuranceService.update(insurance, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }



    /**
     * 新增 险种
     * @param insurance
     * @return
     */
    @RequestMapping("/add")
    public ViewData add(Insurance insurance){
        if(CommonUtil.isEmpty(insurance.getPayPlaceId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        insuranceService.add(insurance, LoginHelper.getCurrentUser());
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }




    /**
     * 获取只是办理方下的险种及档次 下拉框使用
     * @param payPlaceId 缴金地id
     * @param insuranceLevelId 险种档次id
     * @return
     */
    @RequestMapping("/getOnlyTransactor")
    public ViewData getOnlyTransactor(Integer payPlaceId,Integer insuranceLevelId,Integer transactorId){
        if(CommonUtil.isEmpty(payPlaceId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                insuranceService.getOnlyTransactor(payPlaceId,insuranceLevelId,transactorId));

    }



    /**
     * 删除缴金地下的险种 逻辑删除
     * @param id
     * @param isValid 是否有效 0 无效 1 有效
     * @return
     */
    @RequestMapping("/updateIsValid")
    public ViewData updateIsValid(Integer id , Integer isValid){
        if(CommonUtil.isEmpty(id,isValid)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            Insurance insurance = new Insurance();
            insurance.setId(id);
            insurance.setIsValid(isValid);
            insuranceService.update(insurance, LoginHelper.getCurrentUser());
        } catch (InterfaceCommonException e) {
            e.printStackTrace();
            return buildSuccessCodeJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }


}
