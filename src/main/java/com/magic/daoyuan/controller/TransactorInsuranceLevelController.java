package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.TransactorInsuranceLevel;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.TransactorInsuranceLevelService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 办理方绑定的险种及档次
 * @author lzh
 * @create 2017/9/28 15:45
 */
@RestController
@RequestMapping("/transactorInsuranceLevel")
public class TransactorInsuranceLevelController extends BaseController {

    @Resource
    private TransactorInsuranceLevelService transactorInsuranceLevelService;


    /**
     * 查询办理方绑定的险种及档次基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            TransactorInsuranceLevel transactor = transactorInsuranceLevelService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",transactor);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 更新办理方绑定的险种及档次不为空的字段 通过ID
     * @param Transactor
     */
    @RequestMapping("/update")
    public ViewData update(TransactorInsuranceLevel Transactor){
        try {
            if (null == Transactor.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            transactorInsuranceLevelService.update(Transactor);
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
     * 更新办理方绑定的险种及档次 所有的字段 通过ID
     * @param Transactor
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(TransactorInsuranceLevel Transactor){
        try {
            if (null == Transactor.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            transactorInsuranceLevelService.updateAll(Transactor);
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
     * 新增办理方绑定的险种及档次
     * @param Transactor
     */
    @RequestMapping("/save")
    public ViewData save(TransactorInsuranceLevel Transactor){
        try {
            transactorInsuranceLevelService.save(Transactor);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }

    /**
     * 分页 通过各种条件 查询办理方绑定的险种及档次
     *
     * @param pageArgs    分页属性
     * @param levelName  险种档次名
     * @param insuranceName 险种名
     * @param coPayType 公司缴纳类型 0：金额  1：比例
     * @param mePayType 个人缴纳类型 0：金额  1：比例
     * @param isValid 是否有效 0 无效 1 有效
     * @param transactorId 办理方id
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String levelName ,String insuranceName ,
                             Integer coPayType ,Integer mePayType, Integer isValid,  Integer transactorId) {
        try {
            PageList pageList = transactorInsuranceLevelService.list(pageArgs, levelName, insuranceName,
                    coPayType, mePayType, isValid, transactorId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
