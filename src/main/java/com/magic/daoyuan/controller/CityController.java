package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.service.CityService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 城市 控制器
 * Created by Eric Xie on 2017/7/12 0012.
 */

@RestController
@RequestMapping("/city")
public class CityController extends BaseController {

    @Resource
    private CityService cityService;

    /**
     * 通过城市ID 查询 城市下面 该级别的所有城市
     * @param cityId
     * @param levelType  1:省级  2：市级  3：区县级
     * @return
     */
    @RequestMapping(value = "/queryCityByParentId",method = RequestMethod.POST)
    public ViewData queryCityByParentId(Integer cityId, Integer levelType){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                cityService.queryCityByParentId(cityId,levelType));
    }


    @RequestMapping(value = "/getCities",method = RequestMethod.POST)
    public ViewData getCities(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                cityService.queryAllCity());
    }

}
