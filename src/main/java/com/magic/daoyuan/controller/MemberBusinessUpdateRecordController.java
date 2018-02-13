package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.MemberBusinessUpdateRecordItemService;
import com.magic.daoyuan.business.service.MemberBusinessUpdateRecordService;
import com.magic.daoyuan.business.util.ClassConvert;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 实做-员工业务增减变表
 * @author lzh
 * @create 2017/10/26 17:02
 */
@RestController
@RequestMapping("/memberBusinessUpdateRecord")
public class MemberBusinessUpdateRecordController extends BaseController {

    @Resource
    private MemberBusinessUpdateRecordService memberBusinessUpdateRecordService;
    @Resource
    private MemberBusinessUpdateRecordItemService memberBusinessUpdateRecordItemService;

    /**
     * 新增备注
     * @param id
     * @param remark
     * @return
     */
    @RequestMapping("/addRemark")
    public ViewData addRemark(Integer id,String remark){
        if(CommonUtil.isEmpty(id,remark)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        MemberBusinessUpdateRecord record = memberBusinessUpdateRecordService.queryBaseInfo(id);
        if(null == record){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"记录不存在");
        }
        User currentUser = LoginHelper.getCurrentUser();
        Remark remark1 = new Remark();
        remark1.setRemark(remark);
        remark1.setUserName(currentUser.getUserName());
        if(CommonUtil.isEmpty(record.getRemark())){
            record.setRemark(JSONArray.fromObject(JSONObject.fromObject(remark1)).toString());
        }
        else{
            JSONArray jsonArray = JSONArray.fromObject(record.getRemark());
            jsonArray.add(JSONObject.fromObject(remark1));
            record.setRemark(jsonArray.toString());
        }
        try {
            memberBusinessUpdateRecordService.update(record);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 实做-员工业务增减变表 通过ID
     * @param memberBusinessUpdateRecord
     */
    @RequestMapping("/update")
    public ViewData update(MemberBusinessUpdateRecord memberBusinessUpdateRecord){
        try {
            if (null == memberBusinessUpdateRecord.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            memberBusinessUpdateRecordService.update(memberBusinessUpdateRecord);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 更新成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 分页 通过各种条件 实做-员工业务增减变表
     *
     * @param pageArgs    分页属性
     * @param uUserName  客服名
     * @param userId  客服Id
     * @param mUserName 员工名
     * @param certificateNum 员工证件编号
     * @param companyId 公司id
     * @param payPlaceId 缴金地id
     * @param transactorId 办理方id
     * @param serviceType 服务类型 0：社保  1：公积金
     * @param status 0：申请 1：待反馈、2：成功、3：失败 4：部分成功
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String uUserName,Integer userId , String mUserName  ,String certificateNum ,
                             Integer companyId , Integer payPlaceId, Integer status, Integer transactorId,
                             Integer serviceType,Integer organizationId) {
        try {
            PageList pageList = memberBusinessUpdateRecordService.list(pageArgs, uUserName ,userId, mUserName, certificateNum,
                    companyId, payPlaceId, status, transactorId,serviceType,organizationId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE," 获取成功",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 实做-全部申请
     * @param
     */
    @RequestMapping("/allApplyFor")
    public ViewData allApplyFor(String uUserName,Integer userId , String mUserName  ,String certificateNum ,
                                Integer companyId , Integer payPlaceId , Integer transactorId,
                                Integer serviceType){
        try {
            memberBusinessUpdateRecordService.allApplyFor(uUserName,userId , mUserName  ,certificateNum ,
                    companyId , payPlaceId, 0, transactorId, serviceType);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 操作成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }


    /**
     * 实做-批量申请
     * @param
     */
    @RequestMapping("/batchApplyFor")
    public ViewData batchApplyFor(String ids){
        try {
            if (CommonUtil.isEmpty(ids)) {
                return buildSuccessCodeJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            Integer[] idInts = ClassConvert.strToIntegerGather(ids.replaceAll("，",",").split(","));

            // 通过记录ID集合 查询待申请的子类集合
//            List<MemberBusinessUpdateRecordItem> itemList = memberBusinessUpdateRecordItemService.queryRecordItemByRecords(idInts);
//            if(null == itemList || itemList.size() == 0){
//                return buildSuccessCodeJson(StatusConstant.Fail_CODE,"没有记录可以申请");
//            }
//            for (MemberBusinessUpdateRecordItem item : itemList) {
//                item.setStatus(StatusConstant.ITEM_FEEDBACKING);
//            }
            List<MemberBusinessUpdateRecordItem> itemList = new ArrayList<MemberBusinessUpdateRecordItem>();
            for (Integer idInt : idInts) {
                MemberBusinessUpdateRecordItem item = new MemberBusinessUpdateRecordItem();
                item.setId(idInt);
                item.setStatus(StatusConstant.ITEM_FEEDBACKING);
                itemList.add(item);
            }
            if (itemList.size() > 0) {
                memberBusinessUpdateRecordItemService.updateStatus(itemList);
            }
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 操作成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }


}
