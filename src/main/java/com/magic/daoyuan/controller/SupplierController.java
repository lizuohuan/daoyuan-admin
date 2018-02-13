package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Supplier;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.SupplierService;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 供应商控制器
 * @author lzh
 * @create 2017/9/26 16:21
 */
@RestController
@RequestMapping("/supplier")
public class SupplierController extends BaseController {

    @Resource
    private SupplierService supplierService;


    /**
     * 查询供应商的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Supplier supplier = supplierService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplier);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新供应商 不为空的字段 通过ID
     * @param supplier
     */
    @RequestMapping("/update")
    public ViewData update(Supplier supplier,String extentArr,String serviceFeeArr){
        try {
            if (null == supplier.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            extentArr = "[" + extentArr +"]";
            supplierService.update(supplier,extentArr,serviceFeeArr, LoginHelper.getCurrentUser());
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
     * 更新供应商 所有的字段 通过ID
     * @param supplier
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(Supplier supplier){
        try {
            if (null == supplier.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            supplierService.updateAll(supplier);
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
     * 新增供应商
     * @param supplier
     */
    @RequestMapping("/save")
    public ViewData save(Supplier supplier,String extentArr,String serviceFeeArr){
        try {
            extentArr = "[" + extentArr +"]";
            supplierService.save(supplier,extentArr,serviceFeeArr, LoginHelper.getCurrentUser());
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
     * 后台页面 分页获取供应商
     *
     * @param pageArgs    分页属性
     * @param supplierName     供应商名
     * @param drawABillOrder   出票顺序 0：先票  1：先款
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String supplierName , Integer drawABillOrder) {
        try {
            PageList pageList = supplierService.list(pageArgs, supplierName, drawABillOrder);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     * 获取未被此经办机构绑定的供应商
     * @return
     */
    @RequestMapping("/getNOBindToSelect")
    public ViewData getNOBindToSelect(Integer organizationId ,Integer supplierId){
        try {
            if (null == organizationId || null == supplierId){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            ;
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplierService.getNOBindToSelect(organizationId,supplierId));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 获取未被此经办机构绑定的供应商
     * @return
     */
    @RequestMapping("/getAllList")
    public ViewData getAllList(){
        try {
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplierService.getAllList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
