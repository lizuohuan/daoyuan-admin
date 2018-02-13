package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.City;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.PayPlace;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.CityService;
import com.magic.daoyuan.business.service.PayPlaceService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 缴金地 控制器
 * Created by Eric Xie on 2017/9/27 0027.
 */

@RestController
@RequestMapping("/payPlace")
public class PayPlaceController extends BaseController {


    @Resource
    private PayPlaceService payPlaceService;
    @Resource
    private CityService cityService;

    /**
     * 缴金地列表接口
     * @param type
     * @param cityId
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getPayPlace")
    public ViewDataPage getPayPlace(Integer type, Integer cityId, PageArgs pageArgs){
        List<Integer> cityIds = null;
        if(null != cityId){
            cityIds = new ArrayList<Integer>();
            City city = cityService.queryCity(cityId);
            if(city.getLevelType() == 1){
                List<City> cities = cityService.queryCityByParentId(cityId, 2);
                for (City city1 : cities) {
                    cityIds.add(city1.getId());
                }
            }
            else if (city.getLevelType() == 2){
                cityIds.add(cityId);
            }
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("type",type);
        params.put("cityId",cityId);
        params.put("cityIds",cityIds);
        PageList<PayPlace> dataList = payPlaceService.queryPayPlaceByItems(params, pageArgs);
        for (PayPlace place : dataList.getList()) {
            place.getCity().setMergerName(place.getCity().getMergerName().replace("中国,","").replace("省","").replace("市",""));
        }
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                dataList.getTotalSize(),dataList.getList());
    }



    /**
     * 获取单个缴金地
     * @return
     */
    @RequestMapping("/getPayPlaceById")
    public ViewData getPayPlaceById(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                payPlaceService.queryPayPlaceById(id));

    }



    /**
     * 通过类型 获取 缴金地列表
     * 缴金地类型 0：社保  1：公积金
     * @return
     */
    @RequestMapping("/getPayPlaceByType")
    public ViewData getPayPlaceByType(Integer type){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                payPlaceService.getPayPlaceByType(type));

    }


    /**
     * 获取 缴金地列表
     * @return
     */
    @RequestMapping("/queryAllPayPlace")
    public ViewData queryAllPayPlace(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                payPlaceService.queryAllPayPlace());

    }




    /**
     * 据地区id获取此缴金地下所有险种及档次 缴金地下所有机构、办理方、险种档次
     * @return payPlace type 0社保 1公积金 2险种
     */
    @RequestMapping("/getOTILInsuranceByCityId")
    public ViewData getOTILInsuranceByCityId(Integer cityId){

        try {
            if(CommonUtil.isEmpty(cityId)){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    payPlaceService.getOTILInsuranceByCityId(cityId));
        } catch (Exception e) {
            e.printStackTrace();
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }

    }



    /**
     * 更新缴金地
     * @param payPlace
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(PayPlace payPlace){
        try {
            if(CommonUtil.isEmpty(payPlace.getId())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            payPlaceService.update(payPlace);
        } catch (InterfaceCommonException e) {
            e.printStackTrace();
            return buildSuccessCodeJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }



    /**
     * 新增缴金地
     * @param payPlace
     * @return
     */
    @RequestMapping("/add")
    public ViewData add(PayPlace payPlace){
        try {
            if(CommonUtil.isEmpty(payPlace.getType(),payPlace.getCityId())){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            payPlaceService.addPayPlace(payPlace);
        } catch (InterfaceCommonException e) {
            e.printStackTrace();
            return buildSuccessCodeJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }



}
