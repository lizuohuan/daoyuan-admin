package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.CompanyPayPlace;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.CompanyPayPlaceService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 公司绑定缴金地
 * @author lzh
 * @create 2017/10/10 16:10
 */
@RestController
@RequestMapping("/companyPayPlace")
public class CompanyPayPlaceController extends BaseController {

    @Resource
    private CompanyPayPlaceService companyPayPlaceService;


    /**
     * 通过公司 和 类型 获取公司下的缴金地
     * @param companyId
     * @param type 类型 0：社保 1：公积金
     * @return
     */
    @RequestMapping("/getCompanyPayPlace")
    public ViewData getCompanyPayPlace(Integer companyId,Integer type){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyPayPlaceService.queryCompanyPayPlaceByItems(companyId,type));
    }

    /**
     * 缴金地 和险种详情
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            CompanyPayPlace transactor = companyPayPlaceService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",transactor);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 更新缴金地 和险种
     * @param companyPayPlace 缴金地
     * @param companyInsuranceJsonAry 险种的json数组 字符串
     */
    @RequestMapping("/update")
    public ViewData update(CompanyPayPlace companyPayPlace,String companyInsuranceJsonAry){
        try {
            if (CommonUtil.isEmpty(companyPayPlace.getPayPlaceId(),
                    companyPayPlace.getTransactorName(),companyPayPlace.getId())) {
                return buildSuccessCodeJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            companyPayPlaceService.update(companyPayPlace,companyInsuranceJsonAry);
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
     * 添加缴金地 和险种
     * @param companyPayPlace 缴金地
     * @param companyInsuranceJsonAry 险种的json数组 字符串
     */
    @RequestMapping("/save")
    public ViewData save(CompanyPayPlace companyPayPlace,String companyInsuranceJsonAry){
        try {
            if (CommonUtil.isEmpty(companyPayPlace.getCompanyId(),
                    companyPayPlace.getPayPlaceId(),
                    companyPayPlace.getTransactorName(),companyPayPlace.getType())) {
                return buildSuccessCodeJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            companyPayPlaceService.save(companyPayPlace,companyInsuranceJsonAry);
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
     * 后台页面 分页获取公司缴金地
     *
     * @param pageArgs    分页属性
     * @param transactorName     办理方名称
     * @param payPlaceName   缴金地名
     * @param isValid   是否有效 0 无效 1有效
     * @param organizationName   经办机构名
     * @param companyId   公司名
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , String transactorName ,String payPlaceName ,
                             String organizationName , Integer isValid, Integer companyId, Integer type) {
        try {
            if (null == companyId) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PageList pageList = companyPayPlaceService.list(pageArgs, transactorName, payPlaceName,
                    organizationName, isValid, companyId,type);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



}
