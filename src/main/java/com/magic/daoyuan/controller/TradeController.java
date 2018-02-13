package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Trade;
import com.magic.daoyuan.business.service.TradeService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/9/12 0012.
 */
@RestController
@RequestMapping("/trade")
public class TradeController extends BaseController {

    @Resource
    private TradeService tradeService;

    /**
     * 获取行业列表
     * @param tradeName
     * @param pageArgs
     * @return
     */
    @RequestMapping("/queryTradeByItem")
    public ViewDataPage queryTradeByItem(String tradeName, PageArgs pageArgs){
        PageList<Trade> data = tradeService.queryTradeByItems(tradeName, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }

    /**
     * 更新行业
     * @param trade
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Trade trade){
        if(CommonUtil.isEmpty(trade.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        tradeService.updateTrade(trade);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 新增行业
     * @param trade
     * @return
     */
    @RequestMapping("/addTrade")
    public ViewData addTrade(Trade trade){
        if(CommonUtil.isEmpty(trade.getTradeName())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        tradeService.addTrade(trade);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 获取所有的行业
     * @return
     */
    @RequestMapping("/queryAllTrade")
    public ViewData queryAllTrade(){
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                tradeService.queryAllTrade(null));
    }

}
