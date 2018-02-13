package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.SupplierAccountToBeCredited;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.SupplierAccountToBeCreditedService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 供应商收款账户控制器
 * @author lzh
 * @create 2017/9/26 16:21
 */
@RestController
@RequestMapping("/supplierAccountToBeCredited")
public class SupplierAccountToBeCreditedController extends BaseController {

    @Resource
    private SupplierAccountToBeCreditedService supplierAccountToBeCreditedService;


    /**
     * 查询供应商收款账户的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            SupplierAccountToBeCredited supplierAccountToBeCredited = supplierAccountToBeCreditedService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplierAccountToBeCredited);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新供应商收款账户 不为空的字段 通过ID
     * @param SupplierAccountToBeCredited
     */
    @RequestMapping("/update")
    public ViewData update(SupplierAccountToBeCredited SupplierAccountToBeCredited){
        try {
            if (null == SupplierAccountToBeCredited.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            supplierAccountToBeCreditedService.update(SupplierAccountToBeCredited);
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
     * 更新供应商收款账户 所有的字段 通过ID
     * @param SupplierAccountToBeCredited
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(SupplierAccountToBeCredited SupplierAccountToBeCredited){
        try {
            if (null == SupplierAccountToBeCredited.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            supplierAccountToBeCreditedService.updateAll(SupplierAccountToBeCredited);
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
     * 新增供应商收款账户
     * @param SupplierAccountToBeCredited
     */
    @RequestMapping("/save")
    public ViewData save(SupplierAccountToBeCredited SupplierAccountToBeCredited){
        try {
            supplierAccountToBeCreditedService.save(SupplierAccountToBeCredited);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功");
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }

    /**
     * 后台页面 分页获取供应商联系人
     *
     * @param pageArgs    分页属性
     * @param accountName 账户名
     * @param account 账号
     * @param bankName 开户行 type=0时不能为空
     * @param type 账号类型 0：银行卡  1：支付宝
     * @param supplierId 供应商ID
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String accountName ,  String account ,
                             String bankName , Integer type , Integer supplierId) {
        try {
            PageList pageList = supplierAccountToBeCreditedService.list(pageArgs, accountName, account, bankName, type, supplierId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     * 根据供应商ID查询 -- 下拉使用
     */
    @RequestMapping("/getBySupplierId")
    public ViewData getBySupplierId(Integer supplierId){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplierAccountToBeCreditedService.getBySupplierId(supplierId));
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }
}
