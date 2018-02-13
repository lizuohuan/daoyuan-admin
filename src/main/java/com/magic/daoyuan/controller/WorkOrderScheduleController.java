package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.service.WorkOrderScheduleService;
import com.magic.daoyuan.business.service.WorkOrderService;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 工单进度接口
 */
@RestController
@RequestMapping("/workOrderSchedule")
public class WorkOrderScheduleController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private WorkOrderService workOrderService;

    @Resource
    private WorkOrderScheduleService workOrderScheduleService;

    /**
     * 分页查询工单
     */
    @RequestMapping("/list")
    public ViewData list (Integer workOrderId) {
        if(null == workOrderId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            List<WorkOrderSchedule> list = workOrderScheduleService.queryRepositoryByItems(workOrderId);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

    /**
     * 添加
     */
    @RequestMapping("/add")
    public ViewData insert (WorkOrderSchedule workOrderSchedule) {
        try {
            workOrderScheduleService.insert(workOrderSchedule);
            WorkOrder workOrder = new WorkOrder();
            if (workOrderSchedule.getServiceType() == 0 || workOrderSchedule.getServiceType() == 1 || workOrderSchedule.getServiceType() == 3 || workOrderSchedule.getServiceType() == 4 || workOrderSchedule.getServiceType() == 5) {
                //前道主管
                if (workOrderSchedule.getRoleId() == 4) {
                    workOrder.setRoleId(2);
                }
                //总经理
                else if (workOrderSchedule.getRoleId() == 2) {
                    workOrder.setRoleId(14);
                }
                else if (workOrderSchedule.getRoleId() == 14) {
                    workOrder.setRoleId(9);
                }
            }
            else if (workOrderSchedule.getServiceType() == 2) {
                //前道组长
                if (workOrderSchedule.getRoleId() == 5) {
                    workOrder.setRoleId(10);
                }
                else if (workOrderSchedule.getRoleId() == 10) {
                    workOrder.setRoleId(9);
                }
            }
            else if (workOrderSchedule.getServiceType() == 6) {
                if (workOrderSchedule.getRoleId() == 6) {
                    workOrder.setRoleId(9);
                }
            }
            else if (workOrderSchedule.getServiceType() == 7) {
                if (null != workOrderSchedule.getNextUserId()) {
                    workOrder.setUserId(workOrderSchedule.getNextUserId());
                    workOrder.setRoleId(null);
                }
                if (null != workOrderSchedule.getNextRoleId()) {
                    workOrder.setRoleId(workOrderSchedule.getNextRoleId());
                    workOrder.setUserId(null);
                }
            }
            if (workOrderSchedule.getServiceType() != 7 && (workOrderSchedule.getStatus() == 2 || workOrderSchedule.getStatus() == 3 || workOrderSchedule.getStatus() == 4 || workOrderSchedule.getStatus() == 5)) {
                workOrder.setStatus(workOrderSchedule.getStatus());
                workOrder.setUserId(workOrderSchedule.getUserId());
                workOrder.setRoleId(workOrderSchedule.getRoleId());
            }
            if (workOrderSchedule.getUserId() == workOrderSchedule.getProposerId()) {
                workOrder.setStatus(workOrderSchedule.getStatus());
            }
            workOrder.setId(workOrderSchedule.getWorkOrderId());
            workOrderService.update(workOrder);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"添加失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }


    /**
     * 根据工单ID获取上一级审批进度
     */
    @RequestMapping("/getNextWorkOrderSchedule")
    public ViewData getNextWorkOrderSchedule (Integer workOrderId) {
        if(null == workOrderId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            WorkOrderSchedule workOrderSchedule = workOrderScheduleService.getNextWorkOrderSchedule(workOrderId);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",workOrderSchedule);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }


}
