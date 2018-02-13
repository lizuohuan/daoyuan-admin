package com.magic.daoyuan.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.magic.daoyuan.business.dto.CompanySonTotalBillDto;
import com.magic.daoyuan.business.dto.QTemp;
import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.mail.EmailUtil;
import com.magic.daoyuan.business.service.CompanySonBillItemService;
import com.magic.daoyuan.business.service.CompanySonTotalBillService;
import com.magic.daoyuan.business.service.ContactsService;
import com.magic.daoyuan.business.service.LogService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.util.Timestamp;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import com.sun.xml.internal.bind.v2.TODO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.io.IOException;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 账单汇总
 * @author lzh
 * @create 2017/10/24 13:03
 */
@RestController
@RequestMapping("/companySonTotalBill")
public class CompanySonTotalBillController extends BaseController {

    @Resource
    private CompanySonTotalBillService companySonTotalBillService;
    @Resource
    private CompanySonBillItemService companySonBillItemService;
    @Resource
    private ContactsService contactsService;
    @Resource
    private LogService logService;
    /**
     * 后台页面 分页获取公司子账单汇总账单
     *
     * @param pageArgs    分页属性
     * @param companyId     公司id
     * @param companyName     公司名
     * @param companySonBillId     子账单id
     * @param startTimes   账单创建的开始时间
     * @param endTimes     账单创建的结束时间
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , Integer companyId ,String companyName , Integer companySonBillId , String startTimes , String endTimes ) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate2(startTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && !endTimes.equals("")) {
                endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
            }
            PageList pageList = companySonTotalBillService.
                    list(pageArgs, companyId ,companyName ,companySonBillId, startTime ,endTime);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

    /**
     * 后台页面 分页获取公司子账单汇总账单
     *
     * @param pageArgs    分页属性
     * @param companyId     公司id
     * @param companyName     公司名
     * @param companySonBillId     子账单id
     * @param startTimes   账单创建的开始时间
     * @param endTimes     账单创建的结束时间
     * @return
     */
    @RequestMapping("/listDto")
    public ViewDataPage listDto(PageArgs pageArgs , Integer companyId ,String companyName , Integer companySonBillId , String startTimes , String endTimes,
                                Integer beforeService,Integer hexiao,Integer jihe,Integer status,Long billMonthStamp) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate2(startTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && !endTimes.equals("")) {
                endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
            }
            PageList pageList = companySonTotalBillService.
                    listDto(pageArgs, companyId ,companyName ,companySonBillId, startTime ,endTime,beforeService,hexiao,jihe,status,
                            null == billMonthStamp ? null : new Date(billMonthStamp));
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }



    @RequestMapping("/sendSonBill")
    public ViewData sendSonBill(String url, Integer companySonTotalBillId){
        if(CommonUtil.isEmpty(url,companySonTotalBillId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        String msg = "<a href='"+url+"' target='_blank'>点我查看账单信息</a>";
        Contacts contacts = contactsService.getContactsByCompanySonBillItemId(companySonTotalBillId);
        if(null != contacts && !CommonUtil.isEmpty(contacts.getEmail())){
            Email email = new Email(contacts.getEmail(),"账单来啦...",msg);
            EmailUtil.sendEmail(email);
            // 日志记录
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            Log log = new Log(LoginHelper.getCurrentUser().getId(),StatusConstant.LOG_MODEL_BILL,"发送账单: " + contacts.getCompanyName()+"("+sdf.format(contacts.getBillMonth())+")",
                    StatusConstant.LOG_FLAG_UPDATE);
            logService.add(log);
        }

        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
    }

    /**
     * 批量发送账单
     * @param companyIdAndBillMonth 公司id和账单月的json数组
     * @param url
     * @return
     */
    @RequestMapping("/batchSendSonBill")
    public ViewData batchSendSonBill(String companyIdAndBillMonth,String url,
                                     Integer companyId ,String companyName , Integer companySonBillId , String startTimes , String endTimes,
                                     Integer beforeService,Integer hexiao,Integer jihe,Integer status,Long billMonthStamp,Integer source) throws IOException {
        Date startTime = null;
        Date endTime = null;
        if (null != startTimes && !startTimes.equals("")) {
            startTime = Timestamp.parseDate2(startTimes,"yyyy-MM-dd HH:mm:ss");
        }
        if (null != endTimes && !endTimes.equals("")) {
            endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
        }
        List<CompanySonTotalBill> bills;
        List<Map<String ,Object>> mapList = null;
        if (null != source && source == 1) {
            PageList pageList = companySonTotalBillService.
                    listDto(null, companyId ,companyName ,companySonBillId, startTime ,endTime,beforeService,hexiao,jihe,status,
                            null == billMonthStamp ? null : new Date(billMonthStamp));
            List<CompanySonTotalBillDto> list = pageList.getList();
            for (CompanySonTotalBillDto dto : list) {
                Map<String ,Object> map = new HashMap<String, Object>();
                map.put("companyId",dto.getCompanyId());
                map.put("billMonth",dto.getBillMonth());
                if (null == mapList) {
                    mapList = new ArrayList<Map<String, Object>>();
                }
                mapList.add(map);
            }
        }
        else{
            if(!CommonUtil.isEmpty(companyIdAndBillMonth)){
                mapList = new ObjectMapper().readValue(companyIdAndBillMonth,List.class);
                for (Map<String, Object> map : mapList) {
                    map.put("billMonth",new Date(Long.valueOf(map.get("billMonth").toString())));
                }
            }
        }

        bills = companySonTotalBillService.queryCompanySonTotalBill_(mapList);
        if(null != bills && bills.size() > 0){
            List<Email> emails = new ArrayList<Email>();
            StringBuffer sb = new StringBuffer();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
            SimpleDateFormat sdfDD = new SimpleDateFormat("dd");
            for (CompanySonTotalBill bill : bills) {
                String billMsg = sdf.format(bill.getBillMonth());
                sb.append(bill.getCompanyName()+"("+ billMsg +")");

                String msg = "<a href='"+url+"?companySonTotalBillId=" + bill.getId() + "&createTime="+bill.getBillMonth().getTime()+"'target='_blank'>点此查看</a>";
                String format = MessageFormat.format(StatusConstant.EMAIL_MSG, billMsg, msg, bill.getServiceName(), bill.getServicePhone(),
                        sdfDD.format(bill.getPayTime()));

                if(null != bill.getContacts() && !CommonUtil.isEmpty(bill.getContacts().getEmail())){
                    Email email = new Email(bill.getContacts().getEmail(),"账单来啦...",format);
                    emails.add(email);
                }
            }
            if(emails.size() > 0){
                EmailUtil.sendEmail(emails);
            }
            // 日志记录
            Log log = new Log(LoginHelper.getCurrentUser().getId(),StatusConstant.LOG_MODEL_BILL,"批量发送账单: " + sb.toString(),StatusConstant.LOG_FLAG_UPDATE);
            logService.add(log);
        }

        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"获取成功");
    }


    /**
     * 确认数据
     * @param companySonTotalBillId 汇总账单id
     * @return
     */
    @RequestMapping("/updateStatus")
    public ViewData updateStatus(Integer companySonTotalBillId){
        if(CommonUtil.isEmpty(companySonTotalBillId)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        try {
            companySonBillItemService.updateStatus(companySonTotalBillId,2);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 确认数据
     * @param companyId 公司id
     * @param billMonth 账单月
     * @param amount
     * @return
     */
    @RequestMapping("/updateStatusQR")
    public ViewData updateStatusQR(Integer companyId,Long billMonth,Double amount){
        if(CommonUtil.isEmpty(companyId,billMonth,amount)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        try {
            companySonBillItemService.updateStatus2(companyId,new Date(billMonth),2, LoginHelper.getCurrentUser(),amount);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 删除账单
     * @param companyId 公司id
     * @param billMonth 账单月
     * @return
     */
    @RequestMapping("/delBill")
    public ViewData delBill(Integer companyId,Long billMonth){
        if(CommonUtil.isEmpty(companyId,billMonth)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        try {
            companySonBillItemService.delBill(companyId,new Date(billMonth));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 确认数据后取消确认
     * @param companyId 公司id
     * @param billMonth 账单月
     * @return
     */
    @RequestMapping("/updateStatusQX")
    public ViewData updateStatusQX(Integer companyId,Long billMonth){
        if(CommonUtil.isEmpty(companyId,billMonth)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        try {
            companySonBillItemService.updateStatus2(companyId,new Date(billMonth),0,LoginHelper.getCurrentUser(),null);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 确认数据后取消确认
     * @param companySonTotalBillId 汇总账单id
     * @return
     */
    @RequestMapping("/updateStatus2")
    public ViewData updateStatus2(Integer companySonTotalBillId){
        if(CommonUtil.isEmpty(companySonTotalBillId)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        try {
            companySonBillItemService.updateStatus(companySonTotalBillId,0);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE," 操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 驳回数据
     * @param companySonTotalBillId 汇总账单id
     * @param createTime 创建时间
     * @return
     */
    @RequestMapping("/delete")
    public ViewData delete(Integer companySonTotalBillId,Long createTime){
        if(CommonUtil.isEmpty(companySonTotalBillId,createTime)){
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        try {
            companySonBillItemService.delete(companySonTotalBillId,new Date(createTime));
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 批量更新发送总结
     * @param companyConsigneeJsonAry 公司id和时间的集合json数组
     * @return
     */
    @RequestMapping("/updateConsigneeList")
    public ViewData updateConsigneeList(String companyConsigneeJsonAry){
        if(CommonUtil.isEmpty(companyConsigneeJsonAry)){
            return buildFailureJson(StatusConstant.Fail_CODE,"字段不能为空 ");
        }
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JSONArray jsonArray = JSONArray.fromObject(companyConsigneeJsonAry);
            List<QTemp> qTemps = new ArrayList<QTemp>();
            for (Object o : jsonArray) {
                JSONObject jsonObject = JSONObject.fromObject(o);
                QTemp q = new QTemp();
                q.setCompanyId(jsonObject.getInt("id"));
                q.setDate(new Date(jsonObject.getLong("billMonth")));
                qTemps.add(q);
            }
//            List<Map<Integer ,Date>> mapList = objectMapper.readValue(companyConsigneeJsonAry,List.class);
            companySonTotalBillService.updateConsigneeList(qTemps);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败 ");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }




}
