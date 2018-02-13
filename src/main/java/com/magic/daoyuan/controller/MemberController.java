package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Member;
import com.magic.daoyuan.business.entity.WorkOrderSchedule;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.MemberService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.util.Timestamp;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 员工控制器
 * @author lzh
 * @create 2017/9/26 16:21
 */
@RestController
@RequestMapping("/member")
public class MemberController extends BaseController {

    @Resource
    private MemberService memberService;





    /**
     * 导入员工工资表格
     * @param companyId
     * @param url
     * @return
     */
    @RequestMapping("/importSalaryMember")
    public ViewData importSalaryMember(Integer companyId,String url){
        if(CommonUtil.isEmpty(companyId,url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            memberService.importMemberSalaryInfo(companyId,url);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 查询员工的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Member member = memberService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",member);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新员工 不为空的字段 通过ID
     * @param member
     */
    @RequestMapping("/update")
    public ViewData update(Member member,String businessArr){
        try {
            if (null == member.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            memberService.update(member,businessArr);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 更新员工 所有的字段 通过ID
     * @param member
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(Member member){
        try {
            if (null == member.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            memberService.updateAll(member);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 新增员工
     * @param member
     * @param businessArr 业务集合 数据结构
     *
     * "baseInfo": {},
     * "businessArr": [
     *  {
     *      "id": 3,
     *      "data": {
     *          "serviceMethod": 0,
     *          "isReceivable": 1,
     *          "payPlaceId": 13,
     *          "organizationId": 11,
     *          "transactor": 23,
     *          "other": 13,
     *          "baseNumber": 1.3,
     *          "serviceStartTime": 时间戳,
     *          "billStartTime": 时间戳
     *          "serviceEndTime": 时间戳
     *      }
     *  },
     *  {
     *      "id": 5,
     *      "data": {
     *          "nationality": 1,
     *          "bankAccount": "62218990001231241231",
     *          "bankId": 13,
     *          "phone": "1231241231"
     *      }
     *  },
     *  {
     *      "id": 6,
     *      "data": [
     *          1,
     *          2,
     *          3
     *      ]
     *  }
     * ]
     *
     */
    @RequestMapping("/save")
    public ViewData save(Member member,String businessArr){
        try {
            memberService.save(member,businessArr);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }

    /**
     * 后台页面 分页获取员工
     * @param pageArgs 分页属性
     * @param certificateNum 证件编号
     * @param userName 员工名
     * @param companyId 所属公司id
     * @param stateCooperation 合作状态 0：离职  1：在职
     * @param waysOfCooperation 合作方式 0：普通 1：派遣  2：外包
     * @param leaveOfficeTimeStartTimes 离职时间开始
     * @param leaveOfficeTimeEndTimes 离职时间结束
     * @param contractStartTimeStartTimes 合同执行时间开始
     * @param contractStartTimeEndTimes 合同执行时间结束
     * @param contractEndTimeStartTimes 合同结束时间开始
     * @param contractEndTimeEndTimes 合同结束时间结束
     * @param cityId 城市id
     * @param certificateType 证件类型
     * @param beforeService 客服
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String certificateNum , String userName ,
                             Integer companyId , Integer stateCooperation , Integer waysOfCooperation ,
                             String leaveOfficeTimeStartTimes , String leaveOfficeTimeEndTimes ,
                             String contractStartTimeStartTimes , String contractStartTimeEndTimes ,
                             String contractEndTimeStartTimes , String contractEndTimeEndTimes ,
                             Integer cityId , Integer certificateType, String companyName,Integer beforeService) {
        try {
            Date leaveOfficeTimeStartTime = null;
            Date leaveOfficeTimeEndTime = null;
            Date contractStartTimeStartTime = null;
            Date contractStartTimeEndTime = null;
            Date contractEndTimeStartTime = null;
            Date contractEndTimeEndTime = null;
            if (null != leaveOfficeTimeStartTimes && !leaveOfficeTimeStartTimes.equals("")) {
                leaveOfficeTimeStartTime = Timestamp.parseDate2(leaveOfficeTimeStartTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != leaveOfficeTimeEndTimes && !leaveOfficeTimeEndTimes.equals("")) {
                leaveOfficeTimeEndTime = Timestamp.parseDate2(leaveOfficeTimeEndTimes,"yyyy-MM-dd HH:mm:ss");
            }

            if (null != contractStartTimeStartTimes && !contractStartTimeStartTimes.equals("")) {
                contractStartTimeStartTime = Timestamp.parseDate2(contractStartTimeStartTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != contractStartTimeEndTimes && !contractStartTimeEndTimes.equals("")) {
                contractStartTimeEndTime = Timestamp.parseDate2(contractStartTimeEndTimes,"yyyy-MM-dd HH:mm:ss");
            }

            if (null != contractEndTimeStartTimes && !contractEndTimeStartTimes.equals("")) {
                contractEndTimeStartTime = Timestamp.parseDate2(contractEndTimeStartTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != contractEndTimeEndTimes && !contractEndTimeEndTimes.equals("")) {
                contractEndTimeEndTime = Timestamp.parseDate2(contractEndTimeEndTimes,"yyyy-MM-dd HH:mm:ss");
            }

            PageList pageList = memberService.list(pageArgs, certificateNum, userName, companyId,
                    stateCooperation, waysOfCooperation,
                    leaveOfficeTimeStartTime, leaveOfficeTimeEndTime,
                    contractStartTimeStartTime, contractStartTimeEndTime,
                    contractEndTimeStartTime, contractEndTimeEndTime,
                    cityId, certificateType, companyName,beforeService);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 根据公司ID获取员工--下拉使用
     */
    @RequestMapping("/getCompanyMember")
    public ViewData list (Integer companyId) {
        if(null == companyId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            List<Member> list = memberService.getCompanyMember(companyId);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }
}
