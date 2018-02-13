package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.CompanySonBill;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.CompanySonBillService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.util.Timestamp;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 公司子账单
 * @author lzh
 * @create 2017/10/13 11:07
 */
@RestController
@RequestMapping("/companySonBill")
public class CompanySonBillController extends BaseController {

    @Resource
    private CompanySonBillService companySonBillService;


    /**
     * 通过公司 查询公司下的所有子账单
     * @param companyId
     * @return
     */
    @RequestMapping("/getCompanySonBillByCompany")
    public ViewData getCompanySonBillByCompany(Integer companyId){

        if(null == companyId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companySonBillService.queryCompanySonBillByCompany(companyId));
    }


    /**
     * 查询公司子账单的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            CompanySonBill companySonBill = companySonBillService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",companySonBill);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 新增子账单
     * @param companySonBill 子账单
     */
    @RequestMapping("/save")
    public ViewData save(CompanySonBill companySonBill){
        try {
            companySonBillService.save(companySonBill);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败 ");
        }
    }

    /**
     * 更新公司子账单 不为空的字段 通过ID
     * @param companySonBill 子账单
     */
    @RequestMapping("/update")
    public ViewData update(CompanySonBill companySonBill){
        try {
            if (null == companySonBill.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            companySonBillService.update(companySonBill);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }





    /**
     * 后台页面 分页获取公司子账单
     *
     * @param pageArgs    分页属性
     * @param companyId     公司id
     * @param companyName     公司名
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , Integer companyId ,String companyName,String sonBillName,
                             Integer contactsId,Integer billInfoId) {
        try {
            PageList<CompanySonBill> pageList = companySonBillService.list(pageArgs, companyId ,companyName,sonBillName,
                    contactsId,billInfoId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 逻辑删除子账单
     * @param id 子账单id
     */
    @RequestMapping("/updateIsValid")
    public ViewData updateIsValid(Integer id){
        try {
            if (CommonUtil.isEmpty(id)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            companySonBillService.updateIsValid(id);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

}
