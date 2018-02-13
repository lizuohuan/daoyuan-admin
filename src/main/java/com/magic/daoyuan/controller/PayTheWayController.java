package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.PayTheWay;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.PayTheWayService;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 缴纳规则
 * @author lzh
 * @create 2017/9/27 14:23
 */
@RestController
@RequestMapping("/payTheWay")
public class PayTheWayController extends BaseController {

    @Resource
    private PayTheWayService payTheWayService;

    /**
     * 计算该档次下 最低基数  和 最高基数
     * @param levelId 档次ID
     * @return
     */
    @RequestMapping("/countPayTheWay")
    public ViewData countPayTheWay(Integer levelId){
        if(null == levelId){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                payTheWayService.countPayTheWay(levelId));
    }

    /**
     * 查询险种档次缴纳规则的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PayTheWay payTheWay = payTheWayService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",payTheWay);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     * 更新险种档次缴纳规则不为空的字段 通过ID
     * @param payTheWay
     */
    @RequestMapping("/update")
    public ViewData update(PayTheWay payTheWay){
        try {
            if (null == payTheWay.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL," 字段不能为空");
            }
            payTheWayService.update(payTheWay, LoginHelper.getCurrentUser());
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
     * 更新险种档次缴纳规则 所有的字段 通过ID
     * @param payTheWay
     */
    @RequestMapping("/updateAll")
    public ViewData updateAll(PayTheWay payTheWay){
        try {
            if (null == payTheWay.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL," 字段不能为空");
            }
            payTheWayService.updateAll(payTheWay);
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
     * 新增险种档次缴纳规则
     * @param payTheWay
     */
    @RequestMapping("/save")
    public ViewData save(PayTheWay payTheWay){
        try {
            payTheWayService.save(payTheWay, LoginHelper.getCurrentUser());
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 新增成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，新增失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败");
        }
    }

    /**
     * 后台页面 分页获取缴纳规则
     * @param pageArgs 分页属性
     * @param coComputationRule 公司计算规则  0：四舍五入 1：升角省分（精度为0） 2：去尾  3：进一
     * @param isCMakeASupplementaryPayment 公司是否补缴  0：否  1：是
     * @param meComputationRule 个人计算规则  0：四舍五入 1：升角省分（精度为0） 2：去尾  3：进一
     * @param isMMakeASupplementaryPayment 个人是否补缴  0：否  1：是
     * @param insuranceId 险种id
     * @param isValid  是否有效 0 无效 1有效
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , Integer coComputationRule , Integer isCMakeASupplementaryPayment,
                             Integer meComputationRule , Integer isMMakeASupplementaryPayment,
                             Integer insuranceId , Integer isValid) {
        try {
            if (null == insuranceId) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PageList pageList = payTheWayService.list(pageArgs, coComputationRule, isCMakeASupplementaryPayment, meComputationRule,
                    isMMakeASupplementaryPayment, insuranceId, isValid);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    /**
     * 根据险种id 获取上一次最新添加的数据
     * @param insuranceId
     * @return
     */
    @RequestMapping("/getNewByInsuranceId")
    public ViewData getNewByInsuranceId(Integer insuranceId){
        try {
            if (null == insuranceId){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PayTheWay payTheWay = payTheWayService.getNewByInsuranceId(insuranceId);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",payTheWay);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
