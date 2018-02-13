package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.MemberBusinessUpdateRecordItem;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.MemberBusinessUpdateRecordItemService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * @author lzh
 * @create 2017/10/26 17:32
 */
@RestController
@RequestMapping("/memberBusinessUpdateRecordItem")
public class MemberBusinessUpdateRecordItemController extends BaseController {

    @Resource
    private MemberBusinessUpdateRecordItemService memberBusinessUpdateRecordItemService;


    /**
     * 实做-员工业务增减变记录表 通过ID
     * @param recordItem
     */
    @RequestMapping("/update")
    public ViewData update(MemberBusinessUpdateRecordItem recordItem){
        try {
            if (null == recordItem.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            memberBusinessUpdateRecordItemService.update(recordItem);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 更新成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE," 服务器超时，更新失败");
        }
    }


    /**
     * 实做-员工业务增减变记录表 通过ID
     */
    @RequestMapping("/feedback")
    public ViewData update2(Integer id,Integer status,String remark,String reason){
        try {
            if (CommonUtil.isEmpty(id,status)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空 ");
            }
            MemberBusinessUpdateRecordItem recordItem = new MemberBusinessUpdateRecordItem();
            recordItem.setId(id);
            recordItem.setStatus(status);
            recordItem.setCreateUserId(LoginHelper.getCurrentUser().getId());
            if(!CommonUtil.isEmpty(remark)){
                recordItem.setRemark(remark);
            }
            if(status == 3 && !CommonUtil.isEmpty(reason)){
                recordItem.setReason(reason);
            }
            memberBusinessUpdateRecordItemService.update(recordItem);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE," 更新成功 ");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error("服务器超时，更新失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE," 服务器超时，更新失败");
        }
    }

    /**
     * 分页 通过各种条件 实做-员工业务增减变记录表
     *
     * @param pageArgs    分页属性
     * @param serviceStatus 0增员、1减员、2变更
     * @param organizationId 经办机构id
     * @param payPlaceId 缴金地id
     * @param transactorId 办理方id
     * @param status 0：申请 1：待反馈、2：成功、3：失败 4：部分成功
     * @param memberBusinessUpdateRecordId 员工业务增减变id
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , Integer serviceStatus,
                             Integer organizationId , Integer payPlaceId,
                             Integer status, Integer transactorId,
                             Integer memberBusinessUpdateRecordId) {
        try {
            PageList pageList = memberBusinessUpdateRecordItemService.list(pageArgs, serviceStatus,
                    organizationId, payPlaceId, status, transactorId,memberBusinessUpdateRecordId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE," 获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 查询实做-员工业务增减变记录表
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",memberBusinessUpdateRecordItemService.info(id));
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
