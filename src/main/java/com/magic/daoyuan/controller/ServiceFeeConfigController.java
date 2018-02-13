package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.service.ServiceFeeConfigService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/9/13 0013.
 */
@RestController
@RequestMapping("/serviceFee")
public class ServiceFeeConfigController extends BaseController {

    @Resource
    private ServiceFeeConfigService serviceFeeConfigService;


    @RequestMapping("/queryAllServiceFee")
    public ViewData queryAllServiceFee(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                serviceFeeConfigService.queryAllFeeConfig());
    }

}
