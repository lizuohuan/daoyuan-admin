package com.magic.daoyuan.task;

import com.magic.daoyuan.business.entity.Business;
import com.magic.daoyuan.business.entity.Member;
import com.magic.daoyuan.business.entity.MemberCount;
import com.magic.daoyuan.business.enums.BusinessEnum;
import com.magic.daoyuan.business.mapper.IMemberCountMapper;
import com.magic.daoyuan.business.mapper.IMemberMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 刷新员工每天的状态
 * Created by Eric Xie on 2017/12/26 0026.
 */

@Component
public class UpdateMemberTask {

    @Resource
    private IMemberCountMapper memberCountMapper;
    @Resource
    private IMemberMapper memberMapper;

    /**
     * 每天凌晨1点半执行
     */
    @Scheduled(cron = "0 30 1 * * ?")
    public void update(){

        memberCountMapper.del(new Date());
        List<Member> members = memberMapper.queryAllMemberIdCard();
        List<MemberCount> memberCountList = new ArrayList<MemberCount>();
        for (Member member : members) {
            MemberCount memberCount = new MemberCount();
            memberCount.setCompanyId(member.getCompanyId());
            memberCount.setStateCooperation(member.getStateCooperation());
            memberCount.setMemberId(member.getId());
            if(null != member.getBusinessList() && member.getBusinessList().size() > 0){
                for (Business business : member.getBusinessList()) {
                    if(BusinessEnum.sheBao.ordinal() == business.getId()){
                        memberCount.setPayPlaceIdOfSocialSecurity(business.getMemberBusinessItem().getPayPlaceId());
                    }
                    if(BusinessEnum.gongJiJin.ordinal() == business.getId()){
                        memberCount.setPayPlaceIdOfReservedFunds(business.getMemberBusinessItem().getPayPlaceId());
                    }
                }
            }
            memberCountList.add(memberCount);
        }
        if(memberCountList.size() > 0){
            memberCountMapper.batchAdd(memberCountList);
        }

    }


}
