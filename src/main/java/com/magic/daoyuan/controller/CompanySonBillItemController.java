package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.enums.Common;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.mail.EmailUtil;
import com.magic.daoyuan.business.service.CompanyService;
import com.magic.daoyuan.business.service.CompanySonBillItemService;
import com.magic.daoyuan.business.service.CompanySonTotalBillService;
import com.magic.daoyuan.business.service.ContactsService;
import com.magic.daoyuan.business.util.*;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import com.sun.glass.ui.View;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.*;

/**
 * 公司子账单子类
 * @author lzh
 * @create 2017/10/13 11:07
 */
@RestController
@RequestMapping("/companySonBillItem")
public class CompanySonBillItemController extends BaseController {

    @Resource
    private CompanySonBillItemService companySonBillItemService;
    @Resource
    private CompanySonTotalBillService companySonTotalBillService;
    @Resource
    private CompanyService companyService;


    /**
     * 查询公司子账单子类的基础信息
     * @return
     */
    @RequestMapping("/info")
    public ViewData info(Integer id){
        try {
            if (null == id){
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            CompanySonBillItem companySonBillItem = companySonBillItemService.info(id);
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",companySonBillItem);
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


//    /**
//     * 新增子账单子类
//     * @param companyId 公司Id
//     */
//    @RequestMapping("/save")
//    public ViewData save(Integer companyId){
//        try {
//            User user = LoginHelper.getCurrentUser();
//            companySonBillItemService.save(companyId,user.getId());
//            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"新增成功");
//        } catch (InterfaceCommonException e) {
//            logger.info(e.getMessage(),e.getErrorCode());
//            return buildFailureJson(e.getErrorCode(),e.getMessage());
//        } catch (Exception e) {
//            logger.error(" 服务器超时，新增失败 ",e);
//            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败 ");
//        }
//    }


    /**
     * 新增子账单子类
     * @param companyIds 公司Id
     * @param dates 时间s
     * @param isAll 0:生成全部  1：批量生成
     */
//    @RequestMapping("/save")
//    public ViewData saveList(String companyIds,String dates,Integer isAll){
//        try {
//            if (CommonUtil.isEmpty(isAll)) {
//                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
//            }
//            if (isAll == 1 && CommonUtil.isEmpty(companyIds,isAll)) {
//                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
//            }
//            Map<String ,Object> map = companySonBillItemService.save(companyIds,dates,isAll);
//            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"新增成功",map);
//        } catch (InterfaceCommonException e) {
//            logger.info(e.getMessage(),e.getErrorCode());
//            return buildFailureJson(e.getErrorCode(),e.getMessage());
//        } catch (Exception e) {
//            logger.error(" 服务器超时，新增失败 ",e);
//            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败 ");
//        }
//    }



    /**
     * 新增子账单子类
     * @param companyIds 公司Id
     * @param dates 时间s
     * @param isAll 0:生成全部  1：批量生成
     */
    @RequestMapping("/save")
    public ViewData saveList2(String companyIds,String dates,Integer isAll){
        try {
            if (CommonUtil.isEmpty(isAll)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            if (isAll == 1 && CommonUtil.isEmpty(companyIds,isAll)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }

            //公司集合
            List<Company> companyList;
//             companyIdInts;
            //记录公司对应的账单月
            Map<Integer , List<Date>> dateMap = new HashMap<Integer, List<Date>>();
            Set<Integer> companyIdSet = new HashSet<Integer>();
            //封装集合 公司和时间集合
//            List<Map<Integer ,Date>> mapList = new ArrayList<Map<Integer, Date>>();

            if (isAll == 1) {
                Integer[] companyIdInts = ClassConvert.strToIntegerGather(companyIds.replaceAll("，",",").split(","));
                companyList = companyService.queryCompanyByIds(companyIdInts);
                List<Date> dateList = ClassConvert.strListToDateListGather(JSONArray.toList(JSONArray.fromObject(dates),Long.class));

                for (int i = 0; i < companyIdInts.length; i++) {
                    List<Date> dateList2 = new ArrayList<Date>();
                    dateList2.add(dateList.get(i));
                    dateList2.add(Timestamp.parseDate3(CommonUtil.getMonth(companyList.get(i).getBusinessStartTime(),companyList.get(i).getBusinessCycle(),1,dateList.get(i)).get(0),"yyyy-MM"));
                    dateMap.put(companyIdInts[i],dateList2);
                    companyIdSet.add(companyIdInts[i]);
//                    Map<Integer ,Date> integerDateMap = new HashMap<Integer, Date>();
//                    integerDateMap.put(companyIdInts[i],dateList2.get(1));
//                    mapList.add(integerDateMap);
                }
            } else {
                companyList = companyService.queryCompanyAll2();
//                companyIdInts = new Integer[companyList.size()];
                for (int i = 0 ; i < companyList.size() ; i++) {
                    List<Date> dateList2 = new ArrayList<Date>();
                    dateList2.add(new Date());
                    dateList2.add(Timestamp.parseDate3(CommonUtil.getMonth(companyList.get(i).getBusinessStartTime(),companyList.get(i).getBusinessCycle(),1,new Date()).get(0),"yyyy-MM"));
                    dateMap.put(companyList.get(i).getId(),dateList2);
                    companyIdSet.add(companyList.get(i).getId());
//                    companyIdInts[i] = companyList.get(i).getId();
//                    Map<Integer ,Date> integerDateMap = new HashMap<Integer, Date>();
//                    integerDateMap.put(companyIdInts[i],dateList2.get(1));
//                    mapList.add(integerDateMap);
                }
            }

//            Map<String ,Object> map = companySonBillItemService.save(companyIds,dates,isAll);
            List<Company> companyList2 = new ArrayList<Company>();
            Map<Integer , List<Date>> dateMap2 = new HashMap<Integer, List<Date>>();

//            Iterator<Map.Entry<Integer , List<Date>>> m = dateMap.entrySet().iterator();
//            int index = 50;
//            int cycle = companyList.size() / index;
//            int i2 = companyList.size() % index;
//            if(i2 > 0){
//                cycle++;
//            }
//            for (int i = 0; i < cycle; i++) {
//                companyList.subList(i * index, (i + 1) * index - 1);
//
//                Map<String ,Object> map = companySonBillItemService.save(companyList,dateMap,companyIdSet);
//            }
//            for (int i = 0; i < companyList.size(); i++) {
//
//            }
//            Map<String ,Object> map2 = companySonBillItemService.save(companyList,dateMap,companyIdSet);
            Map<String ,Object> map = new HashMap<String, Object>();
            for (int i = 0; i < companyList.size(); i++) {
                companyList2.add(companyList.get(i));
                dateMap2.put(companyList.get(i).getId(),dateMap.get(companyList.get(i).getId()));
                companyIdSet.add(companyList.get(i).getId());

                if ((10 > companyList.size() - i && i + 1 == companyList.size()) || (i > 0 && i % 10 == 0)) {
                    Map<String ,Object> map2 = companySonBillItemService.save(companyList2,dateMap2,companyIdSet);
                    companyList2 = new ArrayList<Company>();
                    dateMap2 = new HashMap<Integer, List<Date>>();
                    companyIdSet = new HashSet<Integer>();
                    if (null != map2.get("msg")) {
                        map.put("msg",map2.get("msg"));
                    }
                    if (null != map2.get("msg2")) {
                        map.put("msg2",map2.get("msg2"));
                    }
                }
            }
            
//            Map<String ,Object> map = companySonBillItemService.save(companyList,dateMap,companyIdSet);


            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"新增成功",map);
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(" 服务器超时，新增失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，新增失败 ");
        }
    }



    /**
     * 更新公司子账单子类 不为空的字段 通过ID
     * @param companySonBillItem 子账单子类
     */
    @RequestMapping("/update")
    public ViewData update(CompanySonBillItem companySonBillItem){
        try {
            if (null == companySonBillItem.getId()) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL," 字段不能为空 ");
            }
            companySonBillItemService.update(companySonBillItem);
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
     * 后台页面 分页获取公司子账单子类
     *
     * @param pageArgs    分页属性
     * @param companyId     公司id
     * @param companySonTotalBillId     汇总账单id
     * @param isAudit     是否稽核 0：否 1：是
     * @param startTimes   账单创建的开始时间
     * @param endTimes     账单创建的结束时间
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs , Integer companyId ,Integer companySonTotalBillId , Integer isAudit, String startTimes , String endTimes ) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate2(startTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && !endTimes.equals("")) {
                endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
            }
            PageList pageList = companySonBillItemService.list(pageArgs, companyId,companySonTotalBillId,isAudit, startTime ,endTime);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 合并总账单
     * @param companyId 公司Id
     */
    @RequestMapping("/mergeBill")
    public ViewData mergeBill(Integer companyId){
        try {
            User user = LoginHelper.getCurrentUser();
//            companySonBillItemService.mergeBill(companyId,user.getId());
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"合并总账单成功");
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(" 服务器超时，合并总账单失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，合并总账单失败 ");
        }
    }

    /**
     * 获取总账单
     * @param companySonBillItemId
     * @return
     */
//    @RequestMapping("/getTheTotalBill")
//    public ViewData getTheTotalBill(Integer companySonBillItemId){
//        try {
//            CompanySonBillItem companySonBillItem = companySonBillItemService.info(companySonBillItemId);
//            if (null == companySonBillItem) {
//                return buildSuccessCodeJson(StatusConstant.NO_DATA,"未知的子账单");
//            }
//            //汇总账单
//            CompanySonTotalBill companySonTotalBill = companySonTotalBillService.info(companySonBillItem.getCompanySonTotalBillId());
//            if (null == companySonTotalBill) {
//                return buildSuccessCodeJson(StatusConstant.NO_DATA,"未知的账单");
//            }
//            List<CompanySonBillItem> companySonBillItems = new ArrayList<CompanySonBillItem>();
//            companySonBillItems.add(companySonBillItem);
//            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功 ",
//                    companySonBillItemService.getTheTotalBill(companySonBillItems,companySonTotalBill.getUserId()));
//        } catch (InterfaceCommonException e) {
//            logger.info(e.getMessage(),e.getErrorCode());
//            return buildFailureJson(e.getErrorCode(),e.getMessage());
//        } catch (Exception e) {
//            logger.error(" 服务器超时，获取总账单失败 ",e);
//            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，获取总账单失败 ");
//        }
//    }


    /**
     * 获取最终总账单详情 同一时间生成的总账单和
     * @param companySonTotalBillId 汇总账单id
     * @param createTime 创建时间
     * @return
     */
    @RequestMapping("/getTheTotalBillInfo")
    public ViewData getTheTotalBillInfo(Integer companySonTotalBillId,Long createTime){
        try {
            if (CommonUtil.isEmpty(companySonTotalBillId,createTime)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            List<CompanySonBillItem> companySonBillItems = companySonBillItemService.
                    getByCompanySonBillIdAndCreateTime(companySonTotalBillId, new Date(createTime));
            if (companySonBillItems.size() < 1) {
                return buildFailureJson(StatusConstant.NO_DATA,"暂无账单 ");
            }
            //汇总账单
            CompanySonTotalBill companySonTotalBill = companySonTotalBillService.info(companySonBillItems.get(0).getCompanySonTotalBillId());
            if (null == companySonTotalBill) {
                return buildSuccessCodeJson(StatusConstant.NO_DATA,"未知的账单");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    companySonBillItemService.getTheTotalBill2(companySonBillItems,companySonTotalBill.getUserId(),companySonTotalBill.getId(),companySonTotalBill.getCompanySonBillId(),
                            new Date(createTime)));
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(" 服务器超时，合并总账单失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，合并总账单失败 ");
        }
    }

    /**
     * 获取最终总账单详情 同一时间生成的总账单和
     * @param companyId 公司id
     * @param billMonth 账单月
     * @return
     */
    @RequestMapping("/getTheTotalBillInfoForAdmin")
    public ViewData getTheTotalBillInfoForAdmin(Integer companyId,Long billMonth){
        try {
            if (CommonUtil.isEmpty(companyId,billMonth)) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                    companySonBillItemService.getTheTotalBill3(companyId,new Date(billMonth)));
        } catch (InterfaceCommonException e) {
            logger.info(e.getMessage(),e.getErrorCode());
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(" 服务器超时，合并总账单失败 ",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时，合并总账单失败 ");
        }
    }



    /**
     * 稽核列表
     * @param serviceMonth 服务月份
     * @param companyId 公司id
     * @return
     */
    @RequestMapping("/memberAuditDtoList")
    public ViewDataPage memberAuditDtoList(PageArgs pageArgs ,Date serviceMonth, Integer companyId) {
        try {
            if (CommonUtil.isEmpty(serviceMonth,companyId)) {
                return buildFailureJsonPage(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            PageList pageList = companySonBillItemService.memberAuditDtoList(pageArgs, serviceMonth, companyId);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }
}
