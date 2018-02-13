package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.service.WorkOrderScheduleService;
import com.magic.daoyuan.business.service.WorkOrderService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 工单接口
 */
@RestController
@RequestMapping("/workOrder")
public class WorkOrderController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private WorkOrderService workOrderService;

    @Resource
    private WorkOrderScheduleService workOrderScheduleService;

    /**
     * 分页查询工单
     */
    @RequestMapping("/list")
    public ViewDataPage list (PageArgs pageArgs, Integer serviceType,String companyName,String memberName,String proposerName,
                              Integer status ,Long billMonthStamp) {
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("serviceType", serviceType);
        params.put("status", status);
        params.put("companyName", CommonUtil.isEmpty(companyName) ? null : companyName);
        params.put("memberName", CommonUtil.isEmpty(memberName) ? null : memberName);
        params.put("proposerName", CommonUtil.isEmpty(proposerName) ? null : proposerName);
        params.put("billMonth", null == billMonthStamp ? null : new Date(billMonthStamp));
        PageList<WorkOrder> list = workOrderService.queryWorkOrderByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                list.getTotalSize(),list.getList());
    }

    /**
     * 添加
     */
    @RequestMapping("/add")
    public ViewData insert (WorkOrder workOrder) {
        User user = LoginHelper.getCurrentUser();
        workOrder.setProposerId(user.getId());
        try {
            int workOrderId = workOrderService.insert(workOrder);
            WorkOrderSchedule workOrderSchedule = new WorkOrderSchedule();
            workOrderSchedule.setStatus(workOrder.getStatus());
            //workOrderSchedule.setUserId(workOrder.getUserId());
            //workOrderSchedule.setRoleId(workOrder.getRoleId());
            workOrderSchedule.setProposerId(user.getId());
            workOrderSchedule.setAccessory(workOrder.getAccessory());
            workOrderSchedule.setRemark(workOrder.getRemark());
            workOrderSchedule.setWorkOrderId(workOrderId);
            workOrderScheduleService.insert(workOrderSchedule);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"添加失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }

    /**
     * 修改
     */
    @RequestMapping("/update")
    public ViewData update (WorkOrder workOrder) {
        User user = LoginHelper.getCurrentUser();
        if(null == workOrder.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            workOrderService.update(workOrder);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
    }

    /**
     * 工单详情
     */
    @RequestMapping("/info")
    public ViewData info (Integer id) {
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",workOrderService.findById(id));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }



}
