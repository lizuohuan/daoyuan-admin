package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Transactor;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.TransactorService;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 办理方
 * @author lzh
 * @create 2017/9/27 15:20
 */
@RestController
@RequestMapping("/transactor")
public class TransactorController extends BaseController {


    @Resource
    private TransactorService transactorService;


    /**
     * 通过经办机构 获取 办理方的 部分字段
     * @param organizationId
     * @return
     */
    @RequestMapping("/getTransactorByOrganization")
    public ViewData getTransactorByOrganization(Integer organizationId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                transactorService.queryTransactorByOrganization(organizationId));
    }

    /**
     * 通过经办机构 获取 办理方的 部分字段
     * @param organizationId
     * @return
     */
    @RequestMapping("/queryTransactorByOrganization2")
    public ViewData queryTransactorByOrganization2(Integer organizationId,String organizationName,Integer type){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                transactorService.queryTransactorByOrganization2(organizationId,organizationName,type));
    }

    /**
     * 查询办理方的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            Transactor transactor = transactorService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",transactor);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新办理方 不为空的字段 通过ID
     * @param transactor
     */
    @RequestMapping("/update")
    public ViewData update(Transactor transactor){
        try {
            if (null == transactor.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            transactorService.update(transactor,LoginHelper.getCurrentUser());
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 更新办理方 所有的字段 通过ID
     * @param transactor
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(Transactor transactor){
        try {
            if (null == transactor.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            transactorService.updateAll(transactor);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，更新失败");
        }
    }

    /**
     * 新增办理方
     * @param transactor
     */
    @RequestMapping("/save")
    public ViewData save(Transactor transactor){
        try {
            transactorService.save(transactor, LoginHelper.getCurrentUser());
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }

    /**
     * 后台页面 分页获取办理方
     *
     * @param pageArgs    分页属性
     * @param transactorName     办理方名称
     * @param operationType   操作方式  0：本月  1：次月  2：上月
     * @param isValid   是否有效 0 无效 1有效
     * @param organizationId   经办机构id
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String transactorName , Integer operationType , Integer isValid, Integer organizationId) {
        try {
            PageList pageList = transactorService.list(pageArgs, transactorName, operationType, isValid,organizationId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

}
