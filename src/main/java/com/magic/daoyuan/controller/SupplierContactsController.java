package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Supplier;
import com.magic.daoyuan.business.entity.SupplierContacts;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.SupplierContactsService;
import com.magic.daoyuan.business.service.SupplierService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 供应商联系人控制器
 * @author lzh
 * @create 2017/9/26 16:21
 */
@RestController
@RequestMapping("/supplierContacts")
public class SupplierContactsController extends BaseController {

    @Resource
    private SupplierContactsService supplierContactsService;


    /**
     * 查询供应商联系人的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            SupplierContacts supplierContacts = supplierContactsService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",supplierContacts);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新供应商联系人 不为空的字段 通过ID
     * @param supplierContacts
     */
    @RequestMapping("/update")
    public ViewData update(SupplierContacts supplierContacts){
        try {
            if (null == supplierContacts.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            supplierContactsService.update(supplierContacts);
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
     * 更新供应商联系人 所有的字段 通过ID
     * @param supplierContacts
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(SupplierContacts supplierContacts){
        try {
            if (null == supplierContacts.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            supplierContactsService.updateAll(supplierContacts);
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
     * 新增供应商联系人
     * @param supplierContacts
     */
    @RequestMapping("/save")
    public ViewData save(SupplierContacts supplierContacts){
        try {
            supplierContactsService.save(supplierContacts);
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
     * 后台页面 分页获取供应商联系人
     *
     * @param pageArgs    分页属性
     * @param jobTitle 职位
     * @param departmentName 部门
     * @param weChat 微信号
     * @param email Email
     * @param qq QQ
     * @param phone 电话号码
     * @param landLine 固定电话 - 座机
     * @param contactsName 联系人
     * @param supplierId 供应商ID
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String jobTitle ,  String departmentName ,
                             String weChat ,  String email ,  String qq , String phone ,
                             String landLine , String contactsName , Integer supplierId) {
        try {
            PageList pageList = supplierContactsService.list(pageArgs, jobTitle, departmentName, weChat, email, qq,
                    phone, landLine, contactsName, supplierId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
