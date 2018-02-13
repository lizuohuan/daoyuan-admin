package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.OutlayAmountRecord;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.service.OutlayAmountRecordService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.OutlayAmountStatus;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 财务出款记录信息
 * Created by Eric Xie on 2017/11/18 0018.
 */
@RestController
@RequestMapping("/outlayAmountRecord")
public class OutlayAmountRecordController extends BaseController {

    @Resource
    private OutlayAmountRecordService outlayAmountRecordService;


    /**
     * 更新修改记录状态
     * @param id
     * @param status
     * @return
     */
    @RequestMapping("/updateStatus")
    public ViewData updateStatus(Integer id,Integer status ,String reason){
        if(CommonUtil.isEmpty(id,status)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        OutlayAmountRecord record = outlayAmountRecordService.queryById(id);
        if(null == record){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"记录不存在");
        }
//        if(status - 1 != record.getStatus() || status.equals(OutlayAmountStatus.pending)
//                || status > OutlayAmountStatus.finished){
//            return buildFailureJson(StatusConstant.Fail_CODE,"记录状态异常");
//        }
        if (status.equals(OutlayAmountStatus.turnDown) && CommonUtil.isEmpty(reason)) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"请填写拒绝理由");
        }

        OutlayAmountRecord temp = new OutlayAmountRecord();
        temp.setId(id);
        temp.setStatus(status);
        outlayAmountRecordService.updateOutlayAmountRecord(temp);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"获取成功");
    }


    /**
     * 获取记录
     * @param status 状态，详细查看 entity.OutlayAmountRecord
     * @param isUrgent 是否加急  0 否  1 是
     * @param pageArgs 分页参数
     * @return
     */
    @RequestMapping("/getOutlayAmountRecordByItems")
    public ViewDataPage getOutlayAmountRecordByItems(Integer status, Integer isUrgent,
                                                     PageArgs pageArgs,String remark,String accountName){
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("status",status);
        map.put("isUrgent",isUrgent);
        map.put("remark",CommonUtil.isEmpty(remark) ? null : remark);
        map.put("accountName",CommonUtil.isEmpty(accountName) ? null : accountName);
        PageList<OutlayAmountRecord> list = outlayAmountRecordService.queryOutlayAmountRecordByItems(map, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                list.getTotalSize(),list.getList());
    }

    /**
     * 修改更新 非状态更新
     * @param record
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(OutlayAmountRecord record){
        if(null == record.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        outlayAmountRecordService.updateOutlayAmountRecord(record);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 新增记录
     * @param record
     * @return
     */
    @RequestMapping("/add")
    public ViewData add(OutlayAmountRecord record){
        User currentUser = LoginHelper.getCurrentUser();
        record.setUserId(currentUser.getId());
        outlayAmountRecordService.addOutlayAmountRecord(record);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
