package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Contacts;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.enums.Common;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.ContactsService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.apache.regexp.RE;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/9/13 0013.
 */
@RestController
@RequestMapping("/contacts")
public class ContactsController extends BaseController {

    @Resource
    private ContactsService contactsService;


    /**
     * 通过公司ID 获取联系人集合
     * @param companyId
     * @return
     */
    @RequestMapping("/getContactsByCompany")
    public ViewData getContactsByCompany(Integer companyId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                contactsService.queryContactsByCompany(companyId));
    }

    /**
     * 通过公司ID 获取联系人集合
     * @param companyId
     * @return
     */
    @RequestMapping("/queryContactsByIsReceiver")
    public ViewData queryContactsByIsReceiver(Integer companyId,Integer isReceiver){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                contactsService.queryContactsByIsReceiver(companyId,isReceiver));
    }

    /**
     * 动态获取 联系人 / 邮寄信息
     * @param contacts
     * @param pageArgs
     * @return
     */
    @RequestMapping("/getContactsByItems")
    public ViewDataPage getContactsByItems(Contacts contacts, PageArgs pageArgs){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("contactsName",CommonUtil.isEmpty(contacts.getContactsName()) ? null : contacts.getContactsName());
        params.put("landLine",CommonUtil.isEmpty(contacts.getLandLine()) ? null : contacts.getLandLine());
        params.put("phone",CommonUtil.isEmpty(contacts.getPhone()) ? null : contacts.getPhone());
        params.put("qq",CommonUtil.isEmpty(contacts.getQq()) ? null : contacts.getQq());
        params.put("email",CommonUtil.isEmpty(contacts.getEmail()) ? null : contacts.getEmail());
        params.put("weChat",CommonUtil.isEmpty(contacts.getWeChat()) ? null : contacts.getWeChat());
        params.put("isReceiver",CommonUtil.isEmpty(contacts.getIsReceiver()) ? null : contacts.getIsReceiver());
        params.put("companyId",CommonUtil.isEmpty(contacts.getCompanyId()) ? null : contacts.getCompanyId());
        params.put("type",contacts.getType());
        PageList<Contacts> data = contactsService.queryContactsByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }

    /**
     * 通过ID 获取 联系人
     * @param id
     * @return
     */
    @RequestMapping("/getContacts")
    public ViewData getContacts(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                contactsService.queryContactsById(id));
    }

    /**
     * 更新联系人
     * @param contacts
     * @return
     */
    @RequestMapping("/updateContacts")
    public ViewData updateContacts(Contacts contacts){
        if(CommonUtil.isEmpty(contacts.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Contacts contacts1 = contactsService.queryContactsById(contacts.getId());
        if(null == contacts1){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"联系人不存在");
        }
        try {
            contactsService.update(contacts, LoginHelper.getCurrentUser());
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 新增联系人
     * @param contacts
     * @return
     */
    @RequestMapping("/addContacts")
    public ViewData addContacts(Contacts contacts){
        if(CommonUtil.isEmpty(contacts.getCompanyId(),contacts.getType())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(0 == contacts.getType() && Common.YES.ordinal() == contacts.getIsReceiver()){
            if(CommonUtil.isEmpty(contacts.getEmail()) && CommonUtil.isEmpty(contacts.getPhone())){
                return buildFailureJson(StatusConstant.Fail_CODE,"手机号和邮箱必须有一项");
            }
        }
        contactsService.add(contacts,LoginHelper.getCurrentUser());
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


}
