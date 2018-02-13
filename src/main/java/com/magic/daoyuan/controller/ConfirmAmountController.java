package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.BankInfoService;
import com.magic.daoyuan.business.service.ConfirmAmountService;
import com.magic.daoyuan.business.service.ImportExcelService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *  认账 Controller
 * Created by Eric Xie on 2017/10/31 0031.
 */

@RestController
@RequestMapping("/confirmAmount")
public class ConfirmAmountController extends BaseController {


    @Resource
    private ConfirmAmountService confirmAmountService;
    @Resource
    private BankInfoService bankInfoService;
    @Resource
    private ImportExcelService importExcelService;

    /** 处理方式 ：
     *  0、大于0:纳入次月账单、退回客户（自动生成出款单）
     *  1、小于0: 纳入次月账单、追回尾款（线下）
     *  2、等于0:足额到款，不做处理。
     */


    /**
     *  更新 修改认款后的数据的处理方式
     * @param confirmFundId 认款记录ID
     * @param handleMethod 处理方式 0 纳入次月账单  1 退回客户（自动生成出款单）
     *                      2 追回尾款（线下）
     * @param billAmount 当前的账单金额
     * @return
     */
    @RequestMapping("/updateConfirmFund")
    public ViewData updateConfirmFund(Integer confirmFundId,Integer handleMethod,Long makeBillTimeStamp,
                                      Double billAmount){

        if(CommonUtil.isEmpty(confirmFundId,handleMethod,billAmount)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(handleMethod != 0 && handleMethod != 1 && handleMethod != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        if(StatusConstant.HANDLEMETHOD_RECOVER_AMOUNT.equals(handleMethod)){
            if(null == makeBillTimeStamp){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"预计回款时间不能为空");
            }
        }
        try {
            confirmAmountService.updateConfirmFund(confirmFundId,handleMethod,null == makeBillTimeStamp ? null : new Date(makeBillTimeStamp),
                    billAmount);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 获取 已经认款后的列表
     * @param companyId 公司ID
     * @param confirmMethod 认款方式：0：自动认款  1：手动拆分认款
     * @param handleMethod 0 纳入次月账单  1 退回客户（自动生成出款单）
     *                      2 追回尾款（线下） 3 不做处理
     * @param pageArgs 分页参数
     * @return
     */
    @RequestMapping("/getConfirmFund")
    public ViewDataPage getConfirmFund(Integer companyId,Integer confirmMethod,Integer handleMethod,PageArgs pageArgs){

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("companyId",companyId);
        map.put("confirmMethod",confirmMethod);
        map.put("handleMethod",handleMethod);
        PageList<ConfirmFund> confirmFund = confirmAmountService.getConfirmFund(map, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",confirmFund.getTotalSize(),
                confirmFund.getList());
    }

    /**
     *  获取到款认款记录表(导入后的)
     * @param startTimeStamp
     * @param endTimeStamp
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getConfirmMoneyRecord")
    public ViewDataPage getConfirmMoneyRecord(Long startTimeStamp, Long endTimeStamp, PageArgs pageArgs,Long importStartDateTimeStamp,
                                              Long importEndDateTimeStamp,Integer beforeService,Integer status,String matchCompanyName,
                                              String companyName){
        Date startTime = null == startTimeStamp ? null : new Date(startTimeStamp);
        Date endTime = null == endTimeStamp ? null : new Date(endTimeStamp);
        Date importStartDate = null == importStartDateTimeStamp ? null : new Date(importStartDateTimeStamp);
        Date importEndDate = null == importEndDateTimeStamp ? null : new Date(importEndDateTimeStamp);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("startTime",startTime);
        map.put("endTime",endTime);
        map.put("importStartDate",importStartDate);
        map.put("importEndDate",importEndDate);
        map.put("beforeService",beforeService);
        map.put("status",status);
        map.put("matchCompanyName",CommonUtil.isEmpty(matchCompanyName) ? null : matchCompanyName);
        map.put("companyName",CommonUtil.isEmpty(companyName) ? null : companyName);
        PageList<ConfirmMoneyRecord> record = confirmAmountService.getConfirmMoneyRecord(map, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",record.getTotalSize(),record.getList());
    }

    /**
     * 手动认款
     * @param dataArr JSONArr 数据 格式:
     *              [
     *                   {
     *                   "companyId" : 1,
     *                   "amount" : 128.2
     *                  }
     *              ]
     * @param confirmMoneyRecordId 到账记录ID
     */
    @RequestMapping("/confirmAmount")
    public ViewData confirmAmount(String dataArr,Integer confirmMoneyRecordId){
        if(CommonUtil.isEmpty(dataArr,confirmMoneyRecordId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User currentUser = LoginHelper.getCurrentUser();
        try {
            confirmAmountService.confirmAmount(dataArr,confirmMoneyRecordId,currentUser.getId());
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 导入银行流水信息 (暂支持 0:工行、1:成都银行、2:华夏银行、3:支付宝)
     * 银行账务 上传对账表
     * @param url
     * @return
     */
    @RequestMapping("/importConfirmMoneyRecord")
    public ViewData importConfirmMoneyRecord(String url,Integer flag){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        List<BankInfo> allBankInfo = bankInfoService.getAllBankInfo();
        try {
            Map<String, Integer> map = importExcelService.confirmMoneyRecord(url, allBankInfo, LoginHelper.getCurrentUser(), flag);
            if(map.get("recordListSize") == 0 && map.get("repetitionCount") > 0){
                return buildFailureJson(StatusConstant.Fail_CODE,"表格无数据或者数据全部重复");
            }
            else if(map.get("recordListSize") > 0 && map.get("repetitionCount") > 0){
                return buildFailureJson(StatusConstant.SUCCESS_CODE,"导入成功，和系统重复数据有:"+map.get("repetitionCount")+"条");
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"数据错误，导入失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"导入成功");
    }


    @RequestMapping(value = "/getConfirMoneyRecord",method = RequestMethod.POST)
    public ViewData getConfirMoneyRecord(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"参数不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",confirmAmountService.getConfirMoneyRecord(id));
    }


}
