package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.AccountConfig;
import com.magic.daoyuan.business.service.AccountConfigService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/10/20 0020.
 */

@RestController
@RequestMapping("/accountConfig")
public class AccountConfigController extends BaseController {

    @Resource
    private AccountConfigService accountConfigService;


    @RequestMapping("/update")
    public ViewData update(AccountConfig config){
        if(CommonUtil.isEmpty(config.getId(),config.getBankName(),config.getAccountName(),config.getAliPayAccount(),
                config.getAliPayName(),config.getBankAccount())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"参数异常");
        }
        accountConfigService.update(config);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }

}
