package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.CompanySonBillItemService;
import com.magic.daoyuan.business.service.ImportExcelService;
import com.magic.daoyuan.business.service.MemberBusinessUpdateRecordItemService;
import com.magic.daoyuan.business.service.MemberService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.*;

/**
 *
 * 文件导入系统处理 Controller
 *
 * Created by Eric Xie on 2017/10/26 0026.
 */

@RestController
@RequestMapping("/import")
public class ImportExcelController extends BaseController {

    @Resource
    private MemberService memberService;
    @Resource
    private ImportExcelService importExcelService;
    @Resource
    private MemberBusinessUpdateRecordItemService memberBusinessUpdateRecordItemService;
    @Resource
    private CompanySonBillItemService companySonBillItemService;



    /**
     * 导入员工
     * @param url
     * @param flag  0:新增员工模版  1: 减员模版下载 2:变更模版
     * @return
     */
    @RequestMapping("/importMember")
    public ViewData importMember(String url,Integer flag){
        if(CommonUtil.isEmpty(url,flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1 && flag != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            if (flag == 0) {
                importExcelService.importMemberInfo(url);
            }
            else if(flag == 1){
                importExcelService.importReduceMember(url);
            }
            else{
                // 变更
                importExcelService.importChangeMember(url);
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }







    /**
     * 处理社保反馈数据  暂时适用于成都
     * @param url 表格URL
     * @param companyId 公司ID
     * @param flag 0 ：参保  1：停保 数据
     * @return
     */
    @RequestMapping("/handleSocialSecurityFeedbackReport")
    public ViewData handleSocialSecurityFeedbackReport(String url,Integer companyId,Integer flag){

        if(CommonUtil.isEmpty(url,flag)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            List<Member> members = memberService.queryVerifyMember(companyId, 0, 0);
            List<Feedback> feedbackList = importExcelService.socialSecurityFeedbackReport(url, companyId, flag);
            List<MemberBusinessUpdateRecordItem> itemList = new ArrayList<MemberBusinessUpdateRecordItem>();
            if(null != feedbackList && null != members){
                for (Feedback feedback : feedbackList) {
                    for (Member member : members) {
                        if(feedback.getCertificateNumber().equals(member.getCertificateNum())){
                            MemberBusinessUpdateRecordItem item = new MemberBusinessUpdateRecordItem();
                            item.setRemark(feedback.getRemark());
                            item.setReason(feedback.getReason());
                            item.setCreateUserId(LoginHelper.getCurrentUser().getId());
                            if(feedback.getIsSuccess() == 1){
                                item.setStatus(StatusConstant.ITEM_SUCCESS);
                            } if(feedback.getIsSuccess() == 0){
                                item.setStatus(StatusConstant.ITEM_FAILURE);
                            }if(feedback.getIsSuccess() == 2){
                                item.setStatus(StatusConstant.ITEM_SUCCESS);
                            }if(feedback.getIsSuccess() == 3){
                                item.setStatus(StatusConstant.ITEM_SUCCESS);
                            }

//                            item.setStatus(1 == feedback.getIsSuccess() ? 1 : 2);
                            item.setMemberBusinessUpdateRecordId(member.getMemberBusinessUpdateRecordId());
                            item.setServiceMonth(feedback.getServiceDate());
                            item.setIsNowCreate(1);
                            item.setId(member.getRecordId());
                            itemList.add(item);
                            break;
                        }
                    }
                }
            }
            if(itemList.size() > 0){
                memberBusinessUpdateRecordItemService.update(itemList);
            }
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"处理失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }


    /**
     * 社保、公积金 通用模版反馈处理接口
     * @param url
     * @return
     */
    @RequestMapping("/commonFeedbackReport")
    public ViewData commonFeedbackReport(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            importExcelService.commonFeedbackReport(url,LoginHelper.getCurrentUser());
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"处理失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"处理成功");
    }



    /**
     * 社保实做数据读取 稽核用 暂时适用于成都
     * @param url 表格URL
     * @param flag 0：成都社保实做数据  1:重庆实做数据  2：通用模版实做数据
     * @return
     */
    @RequestMapping("/socialSecurityImplements")
    public ViewData socialSecurityImplements(String url,Integer flag,Integer operateType){

        User user = LoginHelper.getCurrentUser();
        if(CommonUtil.isEmpty(url,flag,operateType)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1 && flag != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            //城市类型 0：成都 2：通用
            Integer cityType = 0;
            Map<String ,Object> map = new HashMap<String, Object>();
            if (flag == 0) {
                map = importExcelService.socialSecurityImplements(url);

            }
            else if(flag == 2){
                // 通用模版的稽核数据
                map = importExcelService.commonAuditOfSocialSecurity(url);
                cityType = 2;
            }
            Set<Date> serviceMonth = new HashSet<Date>();
            Set<String> idCardSet = (Set<String>) map.get("idCards");
            if (null == map.get("month")) {
                serviceMonth.add(new Date());
            } else {
                serviceMonth = (Set<Date>) map.get("month");
            }
            if (null == map.get("dataMap")) {
                return buildFailureJson(StatusConstant.Fail_CODE,"数据错误");
            }
            //社保账单稽核
            companySonBillItemService.auditSocialSecurityBill(serviceMonth,
                    (Map<String, SocialSecurityImportData>) map.get("dataMap"),(List<SocialSecurityImportData>) map.get("dataList"),idCardSet,cityType,operateType);
            logger.info("集合处理 借宿.......");
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"处理失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }



    /**
     * 公积金实做数据读取 稽核用 通用模版
     * @param url 表格URL
     * @param flag 0：成都公积金实做数据  1:重庆实做数据  2：通用模版实做数据
     * @return
     */
    @RequestMapping("/reservedFundsImplements")
    public ViewData reservedFundsImplements(String url,Integer flag,Integer operateType){
        User user = LoginHelper.getCurrentUser();
        if(CommonUtil.isEmpty(url,flag,operateType)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(flag != 0 && flag != 1 && flag != 2){
            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常");
        }
        try {
            Map<String ,Object> map = new HashMap<String, Object>();
            if (flag == 0) {
                map = importExcelService.commonAuditOfReservedFunds(url);
            }
            else if(flag == 2){
                // 通用模版的稽核数据
                map = importExcelService.commonAuditOfReservedFunds(url);
            }
            Set<Date> serviceMonth = new HashSet<Date>();
            Set<String> idCardSet = (Set<String>) map.get("idCards");
            if (null == map.get("month")) {
                serviceMonth.add(new Date());
            } else {
                serviceMonth = (Set<Date>) map.get("month");
            }
            if (null == map.get("dataMap")) {
                return buildFailureJson(StatusConstant.Fail_CODE,"数据错误");
            }
            //公积金账单稽核
            companySonBillItemService.auditReservedFundsBill(serviceMonth,
                    (Map<String, ReservedFundImportData>) map.get("dataMap"),idCardSet,operateType);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"处理失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }




}
