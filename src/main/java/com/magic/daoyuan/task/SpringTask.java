package com.magic.daoyuan.task;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.service.*;
import com.magic.daoyuan.business.util.Timestamp;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.*;

/**
 * 定时任务
 * @author lzh
 * @create 2017/12/25 11:19
 */
@Component
public class SpringTask {

    @Resource
    private MemberBusinessUpdateRecordItemService recordItemService;
    @Resource
    private InformService informService;
    @Resource
    private BacklogService backlogService;
    @Resource
    private CompanySonTotalBillService companySonTotalBillService;
    @Resource
    private ConfirmAmountService confirmAmountService;
    @Resource
    private UserService userService;
    @Resource
    private ConfirmMoneyRecordService confirmMoneyRecordService;
    @Resource
    private MakeBillService makeBillService;
    /**
     * 获取实作待申请员工
     * 进行待办->前道客服
     *     通知->供应商管理专员(角色)
     * 每天凌晨执行
     */
    @Scheduled(cron = "0 1 0 * * *")
    public void updateRecordStatusToApplyFor() {
        Integer date = Integer.parseInt(Timestamp.DateTimeStamp(new Date(),"dd")) + 2;
        List<MemberBusinessUpdateRecordItem> recordItemList = recordItemService.getUpdateRecordStatus(0,date);
        Set<Integer> userIdSet = new HashSet<Integer>();
        if (recordItemList.size() > 0) {
            //通知 供应商管理专员
            Inform inform = new Inform();
            inform.setRoleId(7);
            inform.setContent("还存在实做在待申请的员工");
            informService.save(inform);
            for (MemberBusinessUpdateRecordItem item : recordItemList) {
                if (!userIdSet.contains(item.getUserId())) {
                    userIdSet.add(item.getUserId());
                    //待办 前道客服
                    Backlog backlog = new Backlog();
                    backlog.setRoleId(9);
                    backlog.setUserId(item.getUserId());
                    backlog.setContent("还存在实做待申请的员工，请及时处理");
                    backlog.setUrl("/page/memberBusiness/list?userId="+item.getUserId() + "&status=0");
                    backlogService.save(backlog);

                }
            }
        }
    }

    /**
     * 获取实作待反馈员工
     * 进行待办->前道客服
     *     通知->供应商管理专员(角色)
     * 每天凌晨执行
     */
    @Scheduled(cron = "0 3 0 * * *")
    public void updateRecordStatusFeedback() {
        Integer date = Integer.parseInt(Timestamp.DateTimeStamp(new Date(),"dd")) + 2;
        List<MemberBusinessUpdateRecordItem> recordItemList = recordItemService.getUpdateRecordStatus(0,date);
        Set<Integer> cityIdSet = new HashSet<Integer>();
        if (recordItemList.size() > 0) {
            for (MemberBusinessUpdateRecordItem item : recordItemList) {
                cityIdSet.add(item.getCityId());
            }
            if (cityIdSet.contains(510100) || cityIdSet.contains(500100)) {
                //待办 后道客服
                Backlog backlog = new Backlog();
                backlog.setRoleId(10);
                backlog.setContent("还存在实做待反馈的员工，请及时处理");
                backlog.setUrl("/page/memberBusiness/list?status=1");
                backlogService.save(backlog);
            }
            cityIdSet.remove(510100);
            cityIdSet.remove(500100);
            if (cityIdSet.size() > 0) {
                //待办 供应商管理专员
                Backlog backlog = new Backlog();
                backlog.setRoleId(7);
                backlog.setContent("还存在实做待反馈的员工，请及时处理");
                backlog.setUrl("/page/memberBusiness/list?status=1");
                backlogService.save(backlog);
            }
        }
    }
    /**
     * 查找超时的账单 记录待办
     */
    @Scheduled(cron = "0 5 0 * * *")
    public void uncertainBill() {
        Integer date = Integer.parseInt(Timestamp.DateTimeStamp(new Date(),"dd"));
        List<CompanySonTotalBill> list = companySonTotalBillService.getUncertainBill(date);
        Set<Integer> userIdSet = new HashSet<Integer>();
        for (CompanySonTotalBill item : list) {
            if (!userIdSet.contains(item.getUserId())) {
                userIdSet.add(item.getUserId());
                //待办 前道客服
                Backlog backlog = new Backlog();
                backlog.setRoleId(9);
                backlog.setUserId(item.getUserId());
                backlog.setContent("还存在账单未确认，请及时处理");
                backlog.setUrl("/page/companySonBillItem/totalList");
                backlogService.save(backlog);
            }
        }
    }


    /**
     * 查找超时的没有选择核销处理方式认款单 记录待办
     */
    @Scheduled(cron = "0 7 0 * * *")
    public void unDispose() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_MONTH, -2);
        List<ConfirmFund> list = confirmAmountService.getUnDispose(calendar.getTime());
        Set<Integer> userIdSet = new HashSet<Integer>();
        for (ConfirmFund item : list) {
            if (!userIdSet.contains(item.getUserId())) {
                userIdSet.add(item.getUserId());
                //待办 前道客服
                Backlog backlog = new Backlog();
                backlog.setRoleId(9);
                backlog.setUserId(item.getUserId());
                backlog.setContent("还存在账单未选择处理方式，请及时处理");
                backlog.setUrl("/page/companySonBillItem/totalList");
                backlogService.save(backlog);
            }
        }
    }





    /**
     * 查找超时的没有选择核销处理方式认款单 记录待办
     */
    @Scheduled(cron = "0 9 0 * * *")
    public void auditUnDispose() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_MONTH, -2);
        List<User> list = userService.getAuditUnDispose(calendar.getTime());
        Set<Integer> userIdSet = new HashSet<Integer>();
        for (User item : list) {
            if (!userIdSet.contains(item.getId())) {
                userIdSet.add(item.getId());
                //待办 前道客服
                Backlog backlog = new Backlog();
                backlog.setRoleId(9);
                backlog.setUserId(item.getId());
                backlog.setContent("还存在账单未稽核，请及时处理");
                backlog.setUrl("/page/companySonBillItem/auditList");
                backlogService.save(backlog);
            }
        }
    }


    /**
     * 查找超时没有未处理的工单 记录待办
     */
    @Scheduled(cron = "0 11 0 * * *")
    public void WorkOrderUnDispose() {
        List<User> list = userService.getWorkOrderUnDispose(new Date());
        Set<Integer> userIdSet = new HashSet<Integer>();
        for (User item : list) {
            if (!userIdSet.contains(item.getId())) {
                userIdSet.add(item.getId());
                //待办 前道客服
                Backlog backlog = new Backlog();
                backlog.setRoleId(item.getRoleId());
                backlog.setUserId(item.getId());
                backlog.setContent("还存在工单未处理，请及时处理");
                backlog.setUrl("/page/workOrder/list?userId="+item.getId());
                backlogService.save(backlog);
            }
        }
    }

    /**
     * 查找超时没有未处理的工单 记录待办
     */
    @Scheduled(cron = "0 0 16 * * *")
    public void makeBillUnDispose() {

        int num = makeBillService.getMakeBillUnDispose();
        if (num > 0) {
            Backlog backlog = new Backlog();
            backlog.setRoleId(11);
            backlog.setContent("还存在未开票状态的票据，请及时处理");
            backlog.setUrl("/page/financeBill/list?roleId=11&status=3001");
            backlogService.save(backlog);
        }
    }

    /**
     * 查找超时未处理的认款单数量 记录通知
     */
    @Scheduled(cron = "0 13 0 * * *")
    public void confirmMoneyRecordUnDispose() {
        int num = confirmMoneyRecordService.getOverTime(new Date());
        if (num > 0) {
            //通知 前道客服
            Inform inform = new Inform();
            inform.setRoleId(9);
            inform.setContent("还存在有未认款的认款单");
            informService.save(inform);
        }
    }



}
