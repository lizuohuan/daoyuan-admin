package com.magic.daoyuan.task;

import com.magic.daoyuan.business.entity.Company;
import com.magic.daoyuan.business.entity.CompanyCooperation;
import com.magic.daoyuan.business.enums.Common;
import com.magic.daoyuan.business.mapper.ICompanyCooperationMapper;
import com.magic.daoyuan.business.mapper.ICompanyMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 更新公司 合作状态每天
 * Created by Eric Xie on 2017/12/21 0021.
 */

@Component
public class UpdateCompanyCooperationTask {

    @Resource
    private ICompanyMapper companyMapper;
    @Resource
    private ICompanyCooperationMapper companyCooperationMapper;

    /**
     * 每天凌晨 00:30点执行
     */
    @Scheduled(cron = "0 30 0 * * ?")
    public void update(){
        List<Company> companyList = companyMapper.queryCompanyCooperation();
        // 首先删除今天所产生的所有记录
        companyCooperationMapper.delAllByDate(new Date());
        List<CompanyCooperation> data = new ArrayList<CompanyCooperation>();
        for (Company company : companyList) {
            CompanyCooperation companyCooperation = new CompanyCooperation();
            companyCooperation.setCompanyId(company.getId());
            companyCooperation.setCooperationStatus(company.getCooperationStatus());
            companyCooperation.setIsInitiative(Common.NO.ordinal());
            companyCooperation.setIsPeer(company.getIsPeer());
            data.add(companyCooperation);
        }
        if(data.size() > 0){
            companyCooperationMapper.batchAdd(data);
        }
    }

}
