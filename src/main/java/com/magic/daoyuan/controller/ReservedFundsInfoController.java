package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.ReservedFundsInfo;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.ReservedFundsInfoService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.util.Timestamp;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 账单--公积金明细
 * @author lzh
 * @create 2017/10/19 16:42
 */
@RestController
@RequestMapping("/reservedFundsInfo")
public class ReservedFundsInfoController extends BaseController {

    @Resource
    private ReservedFundsInfoService reservedFundsInfoService;

    /**
     * 后台页面 分页获取公积金明细
     *
     * @param pageArgs    分页属性
     * @param userName     姓名
     * @param certificateType     证件类型
     * @param idCard     证件编号
     * @param memberNum   公积金编码
     * @param payPlaceOrganizationName     缴金地-经办机构 名
     * @param companySonBillItemId     子账单子类id
     * @param companySonTotalBillId     汇总账单id
     * @param billMonth     账单月
     * @param companyId     公司id
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String userName,
                             Integer certificateType, String idCard,
                             String memberNum, String payPlaceOrganizationName,
                             Integer companySonBillItemId,Integer companySonTotalBillId,
                             Long billMonth,Integer companyId) {
        try {
            PageList pageList = reservedFundsInfoService.list(pageArgs, userName, certificateType, idCard,
                    memberNum, payPlaceOrganizationName,
                    companySonBillItemId,companySonTotalBillId,
                    new Date(billMonth),companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
    /**
     * 后台页面 分页获取公积金明细
     *
     * @param pageArgs    分页属性
     * @param billMonth     账单月
     * @param companyId     公司id
     * @return
     */
    @RequestMapping("/list2")
    public ViewDataPage list2(PageArgs pageArgs ,Long billMonth,Integer companyId) {
        try {
            PageList pageList = reservedFundsInfoService.list(pageArgs, null, null, null,
                    null, null, null,null, new Date(billMonth),companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
    /**
     * 后台页面 分页获取公积金稽核有差异的稽核列表
     *
     * @param pageArgs    分页属性
     * @param serviceNowYM   服务月
     * @param companyId     公司id
     * @return
     */
    @RequestMapping("/auditList")
    public ViewDataPage auditList(PageArgs pageArgs ,Long serviceNowYM,Integer companyId) {
        try {
            Date date = null;
            if (!CommonUtil.isEmpty(serviceNowYM)) {
                date = Timestamp.parseDate2(serviceNowYM.toString(),"yyyyMM");
            }
            PageList pageList = reservedFundsInfoService.auditList(pageArgs, date ,companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新处理方案状态
     *
     * @param id    公积金id
     * @param processingScheme    处理方案 1：纳入次月账单 2：退回客户
     * @return
     */
    @RequestMapping("/updateProcessingScheme")
    public ViewData updateProcessingScheme(Integer id , Integer processingScheme) {
        try {
            if (CommonUtil.isEmpty(processingScheme,id)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            if (processingScheme != 1 && processingScheme != 2) {
                return buildFailureJson(StatusConstant.ORDER_STATUS_ABNORMITY,"未知的处理方案");
            }
            ReservedFundsInfo securityInfo = new ReservedFundsInfo();
            securityInfo.setId(id);
            securityInfo.setProcessingScheme(processingScheme);
            reservedFundsInfoService.updateProcessingScheme(securityInfo);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功 ");
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }  catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败 ");
        }
    }
}
