package com.magic.daoyuan.task;

import com.magic.daoyuan.business.mapper.ICompanySonTotalBillMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;


/**
 *  每月第一天的 凌晨0点5分执行 上月 自动确认账单金额为零的账单
 * Created by Eric Xie on 2018/1/26 0026.
 */

@Component
public class AutoConfirmBillTask {

    @Resource
    private ICompanySonTotalBillMapper companySonTotalBillMapper;


    @Scheduled(cron = "0 5 0 1 * ?")
    public void confirmBill(){







    }


}
