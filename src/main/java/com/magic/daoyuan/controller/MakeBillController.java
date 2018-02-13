package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.enums.BillType;
import com.magic.daoyuan.business.enums.Common;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.MakeBillService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 开票控制器
 * Created by Eric Xie on 2017/11/18 0018.
 */
@RestController
@RequestMapping("/makeBill")
public class MakeBillController extends BaseController {

    @Resource
    private MakeBillService makeBillService;


    /**
     *  邮寄票据
     * @return
     */
    @RequestMapping("/expressMakeBill")
    public ViewData expressMakeBill(Integer id, Integer status, String orderNumber, Integer expressCompanyId,
                                    Integer companyId, ExpressPersonInfo expressPerson){
        if(CommonUtil.isEmpty(id,status,orderNumber,expressCompanyId,companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }

        MakeBill info = makeBillService.queryBaseInfo(id);
        if(null == info){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"票据不存在");
        }

        MakeBill makeBill = new MakeBill();
        makeBill.setId(id);
        makeBill.setStatus(status);

        ExpressInfo expressInfo = new ExpressInfo();
        expressInfo.setCompanyId(companyId);
        expressInfo.setContent(info.getInvoiceNumber());
        expressInfo.setExpressCompanyId(expressCompanyId);
        expressInfo.setOrderNumber(orderNumber);
        expressInfo.setIsReceive(Common.NO.ordinal());
        try {
            makeBillService.expressMakeBill(makeBill,expressInfo,expressPerson);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     *  更新
     * @return
     */
    @RequestMapping("/updateStatus")
    public ViewData updateStatus(MakeBill makeBill){
        if(CommonUtil.isEmpty(makeBill.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        makeBillService.updateMakeBill(makeBill);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 获取列表
     * @param companyId
     * @param status
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getMakeBill")
    public ViewDataPage getMakeBill(Integer companyId, Integer status, PageArgs pageArgs,String billNumber,String orderNumber,
                                    Integer beforeService,Long billMonthStamp){

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("companyId",companyId);
        map.put("status",status);
        map.put("billNumber",CommonUtil.isEmpty(billNumber) ? null : billNumber);
        map.put("orderNumber",CommonUtil.isEmpty(orderNumber) ? null : orderNumber);
        map.put("beforeService",beforeService);
        map.put("billMonth",null == billMonthStamp ? null : new Date(billMonthStamp));
        PageList<MakeBill> list = makeBillService.queryMakeBillByItems(map, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                list.getTotalSize(),list.getList());
    }


    /**
     * 导入票据
     * @param url
     * @return
     */
    @RequestMapping("/url")
    public ViewData importMakeBill(String url){
        if(CommonUtil.isEmpty(url)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            Map<String, Object>  result = makeBillService.importBill(url);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"操作成功",result);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }

    }


    /**
     * 导出票据
     * @param response
     */
    @RequestMapping("exportMakeBill")
    public void exportMakeBill(HttpServletResponse response){
        Map<String,Object> data = new HashMap<String, Object>();
        data.put("status",StatusConstant.BILL_STATUS_UN);
        List<MakeBill> makeBillForExport = makeBillService.getMakeBillForExport(data);
        List<MakeBill> ordinaryBills = new ArrayList<MakeBill>(); // 普票集合
        List<MakeBill> specialBill = new ArrayList<MakeBill>(); // 专票集合
        if(null != makeBillForExport && makeBillForExport.size() > 0){
            for (MakeBill makeBill : makeBillForExport) {
                if(BillType.TaxInvoice.ordinal() == makeBill.getBillInfo().getBillType()){
                    ordinaryBills.add(makeBill);
                }
                else if(BillType.SpecialInvoice.ordinal() == makeBill.getBillInfo().getBillType()){
                    specialBill.add(makeBill);
                }
            }
        }
        makeBillService.exportMakeBill(response,ordinaryBills,specialBill);
    }


}
