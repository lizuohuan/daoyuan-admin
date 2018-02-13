package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Company;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.enums.TimeField;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.service.CompanyService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.DateUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by Eric Xie on 2017/9/13 0013.
 */
@RestController
@RequestMapping("/company")
public class CompanyController extends BaseController {

    @Resource
    private CompanyService companyService;





    @RequestMapping("/queryAllCompany")
    public ViewData queryAllCompany(){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyService.queryAllCompany());
    }


    @RequestMapping("/getBaseCooperationMethod")
    public ViewData getBaseCooperationMethod(Integer companyId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyService.queryBaseCooperationMethod(companyId));
    }

    /**
     * 更新公司状态
     * @param id
     * @param isValid
     * @return
     */
    @RequestMapping(value = "/updateStatus",method = RequestMethod.POST)
    public ViewData updateStatus(Integer id,Integer isValid){
        if(CommonUtil.isEmpty(id,isValid)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        Company info = companyService.info(id);
        if(null == info){
            return buildFailureJson(StatusConstant.Fail_CODE,"公司不存在");
        }
        Company company = new Company();
        company.setId(id);
        company.setIsValid(isValid);
        companyService.update(company);
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 更新公司
     * @return
     */
    @RequestMapping("/updateCompany")
    public ViewData updateCompany(Company company,String businessArr,String extentArr,String salaryDateArr,
                                  String serviceFeeArr,String cooperationMethodArr){
        if(CommonUtil.isEmpty(company.getId(),cooperationMethodArr)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        businessArr = "["+businessArr+"]";
        extentArr = "["+extentArr+"]";
        salaryDateArr = "["+salaryDateArr+"]";
        cooperationMethodArr = "["+cooperationMethodArr+"]";
//        serviceFeeArr = "["+serviceFeeArr+"]";
        try {
            companyService.updateCompany(company,businessArr,extentArr,salaryDateArr,serviceFeeArr,cooperationMethodArr,LoginHelper.getCurrentUser());
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    /**
     * 更新公司
     * @return
     */
    @RequestMapping("/update")
    public ViewData update(Company company){
        if(CommonUtil.isEmpty(company.getId())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            companyService.update(company);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"操作失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    /**
     * 通过公司Id获取 公司
     * @return
     */
    @RequestMapping("/getCompany")
    public ViewData getCompany(Integer companyId){
        if(CommonUtil.isEmpty(companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyService.queryCompanyById(companyId));
    }

    /**
     * 获取公司的票据信息
     * @return
     */
    @RequestMapping("/getCompanyBillInfo")
    public ViewData getCompanyBillInfo(Integer companyId){
        if(CommonUtil.isEmpty(companyId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                companyService.queryBillInfo(companyId));
    }

    /**
     *
     * @return
     */
    @RequestMapping("/getOtherCompany")
    public ViewDataPage getOtherCompany(String companyName,PageArgs pageArgs){
        PageList<Company> data = companyService.queryOtherCompany(companyName,pageArgs, new Date());
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }

    /**
     * 获取客户/公司列表
     * @return
     */
    @RequestMapping("/getCompanyList")
    public ViewDataPage getCompanyList(String companyName, String serialNumber, Integer tradeId, PageArgs pageArgs,
                                       Integer beforeService,Integer sales,String cooperationStatus){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("companyName",CommonUtil.isEmpty(companyName) ? null : companyName);
        params.put("serialNumber",CommonUtil.isEmpty(serialNumber) ? null : serialNumber);
        params.put("tradeId",CommonUtil.isEmpty(tradeId) ? null : tradeId);
        params.put("beforeService",CommonUtil.isEmpty(beforeService) ? null : beforeService);
        params.put("sales",CommonUtil.isEmpty(sales) ? null : sales);
        params.put("cooperationStatus",CommonUtil.isEmpty(cooperationStatus) ? null : cooperationStatus);
        PageList<Company> data = companyService.queryCompanyByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }
    /**
     * 获取客户/公司列表
     * @return
     */
    @RequestMapping("/getCompanyList2")
    public ViewDataPage getCompanyList2(String companyName, String serialNumber, Integer tradeId, PageArgs pageArgs,
                                       Integer beforeService,Integer sales,String cooperationStatus){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("companyName",CommonUtil.isEmpty(companyName) ? null : companyName);
        params.put("serialNumber",CommonUtil.isEmpty(serialNumber) ? null : serialNumber);
        params.put("tradeId",CommonUtil.isEmpty(tradeId) ? null : tradeId);
        params.put("beforeService",CommonUtil.isEmpty(beforeService) ? null : beforeService);
        params.put("sales",CommonUtil.isEmpty(sales) ? null : sales);
        params.put("cooperationStatus",CommonUtil.isEmpty(cooperationStatus) ? null : cooperationStatus);
        PageList<Company> data = companyService.queryCompanyByItems2(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                data.getTotalSize(),data.getList());
    }

    /**
     * 新增公司
     * @param company 公司/客户 基础字段接收
     * @param businessArr 选择业务 ID 集合
     * @param extentArr 区间费用信息集合 对应 CompanyServiceFee.class
     * @param salaryDateArr 工资发放日期
     * @param serviceFeeArr 服务费选择服务区后，报文格式：[{"cityId":1,"price":2.1}]
     * @return
     */
    @RequestMapping("/addCompany")
    public ViewData addCompany(Company company,String businessArr,String extentArr,String salaryDateArr,String serviceFeeArr,
                               String cooperationMethodArr){

        if( null == businessArr){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(CommonUtil.isEmpty(company.getCompanyName())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"公司名不能为空");
        }
        company.setCompanyName(company.getCompanyName().replaceAll(" ",""));
        try {
            User currentUser = LoginHelper.getCurrentUser();
            businessArr = "["+businessArr+"]";
            extentArr = "["+extentArr+"]";
            salaryDateArr = "["+salaryDateArr+"]";
            cooperationMethodArr = "["+cooperationMethodArr+"]";
            companyService.addCompany(company,businessArr,extentArr,salaryDateArr,serviceFeeArr,cooperationMethodArr,currentUser);
        } catch (InterfaceCommonException e) {
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        }catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"新增失败");
        }
        return buildSuccessCodeViewData(StatusConstant.SUCCESS_CODE,"操作成功");
    }


    @RequestMapping("/countTime")
    public @ResponseBody ViewData countTime(Long time, Integer cycle){
        if(CommonUtil.isEmpty(time,cycle)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        List<String> result = new ArrayList<String>();
        Date startTime = new Date(time);
//        cycle -= 1;
        Date endTime = DateUtil.addDate(startTime, TimeField.Month.ordinal(),cycle);
        String endStr = "";
        if(cycle == 1){
            endStr = DateUtil.dateFormat(DateUtil.addDate(endTime, TimeField.Month.ordinal(),-1),"yyyy年MM月");
        }else{
            endStr = DateUtil.dateFormat(startTime,"yyyy年MM月") +" - "+DateUtil.dateFormat(DateUtil.addDate(endTime, TimeField.Month.ordinal(),-1),"yyyy年MM月")+"的费用";
        }
        result.add(DateUtil.dateFormat(startTime,"yyyy年MM月账单") + "," + endStr);

        for (int i = 0; i < 5; i++){
            String start = DateUtil.dateFormat(endTime,"yyyy年MM月账单");
            String endStrTemp = "";
            if(cycle == 1){
                endStrTemp = DateUtil.dateFormat(DateUtil.addDate(endTime, TimeField.Month.ordinal(),cycle - 1),"yyyy年MM月");
            }else{
                endStrTemp = DateUtil.dateFormat(endTime,"yyyy年MM月") + " - " +DateUtil.dateFormat(DateUtil.addDate(endTime, TimeField.Month.ordinal(),cycle - 1),"yyyy年MM月")+"的费用";
            }
            result.add(start + "," + endStrTemp);
            endTime = DateUtil.addDate(endTime, TimeField.Month.ordinal(),cycle);
        }
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                result);
    }

}
