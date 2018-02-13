package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.enums.BusinessEnum;
import com.magic.daoyuan.business.service.*;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.vo.CommonTransact;
import com.magic.daoyuan.util.ViewData;
import net.sf.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * Created by Eric Xie on 2017/10/24 0024.
 */

@Controller
@RequestMapping("/export")
public class ExportExcelController extends BaseController {

    @Resource
    private ExportExcelService exportExcelService;
    @Resource
    private SalaryInfoService salaryInfoService;
    @Resource
    private SocialSecurityInfoService socialSecurityInfoService;
    @Resource
    private ReservedFundsInfoService reservedFundsInfoService;
    @Resource
    private CompanySonBillItemService companySonBillItemService;
    @Resource
    private CompanySonTotalBillService companySonTotalBillService;
    @Resource
    private BusinessInsuranceService businessInsuranceService;
    @Resource
    private MemberService memberService;
    @Resource
    private PayPlaceService payPlaceService;
    @Resource
    private BusinessService businessService;


    @RequestMapping(value = "/downCompany")
    public void downCompany(HttpServletResponse response){

    }

    /**
     * 下载 社保通用 实做数据的通用模版
     * @param response
     */
    @RequestMapping("/downSocialSecurityCommonTemplate")
    public void downSocialSecurityCommonTemplate(HttpServletResponse response){
        exportExcelService.downSocialSecurityCommonTemplate(response);
    }


    /**
     * 下载 公积金通用 实做数据的通用模版
     * @param response
     */
    @RequestMapping("/downReservedFundsCommonTemplate")
    public void downReservedFundsCommonTemplate(HttpServletResponse response){
        exportExcelService.downReservedFundsCommonTemplate(response);
    }


    /**
     * 通过ID集合 下载员工信息
     * @param ids
     * @param model
     * @param response
     * @return
     */
    @RequestMapping("/exportEditMember")
    public void exportEditMember(String ids,Model model,HttpServletResponse response){

//        if(CommonUtil.isEmpty(ids)){
//            return buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常").toJson();
//        }
//        response.setContentType("application/msexcel");
//        response.setHeader("Content-Disposition", "attachment; filename=" + "detail.xls");
//        response.setCharacterEncoding("utf-8");
        JSONArray jsonArray = JSONArray.fromObject(ids);
        // 获取员工信息
        List<Member> members = memberService.batchQueryMemberAllField(jsonArray);

        exportExcelService.downLoadChangeUserTemplate(response,members);

//        model.addAttribute("members",members);
//        return "ftl/member/member";
    }


    /**
     * 员工模版下载
     * @param response
     * @param flag 0:新增员工模版  1: 减员模版下载
     */
    @RequestMapping("/downLoadUserTemplate")
    public void downLoadAddUserTemplate(HttpServletResponse response,Integer flag){
        try {
            if(CommonUtil.isEmpty(flag)){
                response.getWriter().print(buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常").toJson());
                return;
            }
            if(flag != 0 && flag != 1){
                response.getWriter().print(buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常").toJson());
                return;
            }
            if (flag == 0) {
                exportExcelService.downLoadAddUserTemplate(response);
            }
            else{
                exportExcelService.downLoadSubtractUserTemplate(response);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 导出社保增减数据
     * @param response 返回对象
     * @param flag  0增员、1减员、2变更
     * @param payPlaceId 缴金地ID
     * @param organizationId 经办机构ID
     * @param transactorId 办理方ID
     * @param companyId 公司ID
     * @param target 0 ：社保  1：公积金
     * @param otherFlag  成都公积金选择导出模版字段  0:个人开户、1:个人启封、2:个人封存、3:基数调整
     *                   4:新增职工、5:封存职工账户、6:补交登记、7:调整缴存基数
     */
    @RequestMapping("/exportUser")
    public void exportUser(HttpServletResponse response, Integer flag, Integer payPlaceId,
                           Integer organizationId, Integer transactorId, Integer companyId, Integer target,
                           Integer otherFlag, Model model,Integer isTuo){
        try {
            if(CommonUtil.isEmpty(target,payPlaceId)){
                response.getWriter().print(buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"字段不能为空").toJson());
            }
            PayPlace payPlace = payPlaceService.queryPayPlaceById(payPlaceId);
            if(null == payPlace){
                payPlace = payPlaceService.queryPayPlaceByCompanyPayPlace(payPlaceId);
                if(null == payPlace){
                    response.getWriter().print(buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"缴金地不存在").toJson());
                }
            }
            if(target != 0 && target != 1){
                response.getWriter().print(buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常").toJson());
            }

            Map<String,Object> map = new HashMap<String, Object>();
            map.put("payPlaceId",payPlaceId);
            map.put("organizationId",organizationId);
            map.put("transactorId",transactorId);
            map.put("companyId",companyId);
            map.put("serviceStatus",flag);
            map.put("target",target);
            map.put("isTuo",isTuo);
            if(target == 0 && StatusConstant.CITY_CHENGDU.equals(payPlace.getCityId()) && flag != 2){
                // 社保
                List<ExportUser> exportUser = null;
                if(flag == 1){
                    exportUser = memberService.getExportUser_(map);
                }else{
                    exportUser = memberService.getExportUser(map);
                }
               exportExcelService.exportUser(exportUser,flag,response);
            }
            else if(target == 0 && (!payPlace.getCityId().equals(StatusConstant.CITY_CHENGDU) || 2 == flag)){
                // 除成都外的 通用社保
                List<CommonTransact> exportUser = memberService.getCommonDataForMember(map,BusinessEnum.sheBao.ordinal());
                exportExcelService.exportUserCommon(exportUser,response);
            }
            else if(target == 1){
                // 通用公积金
                List<CommonTransact> exportUser = memberService.getCommonDataForMember(map,BusinessEnum.gongJiJin.ordinal());
                exportExcelService.exportUserCommon(exportUser,response);
            }

            else{
                //暂时用通用模版

            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                response.getWriter().print(buildFailureJson(StatusConstant.Fail_CODE,"下载失败").toJson());
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
    }



    @RequestMapping("/downLoad")
    public void exportData(HttpServletResponse response,Integer companyId,Long billMonth){
        try {
            if(null == companyId || null == billMonth){
                response.getWriter().print(buildFailureJson(StatusConstant.ARGUMENTS_EXCEPTION,"参数异常").toJson());
                return;
            }
//            List<CompanySonBillItem> companySonBillItems = companySonBillItemService.
//                    getByCompanySonBillIdAndCreateTime(companySonTotalBillId, new Date(createTime));
//            if (companySonBillItems.size() < 1) {
//                response.getWriter().print(buildFailureJson(StatusConstant.NO_DATA,"暂无账单 ").toJson());
//                return;
//            }
            //汇总账单
//            CompanySonTotalBill companySonTotalBill = companySonTotalBillService.info(companySonBillItems.get(0).getCompanySonTotalBillId());
//            if (null == companySonTotalBill) {
//                response.getWriter().print(buildSuccessCodeJson(StatusConstant.NO_DATA,"未知的账单").toJson());
//                return;
//            }
            // 总数据
            Date month = new Date(billMonth);
            Map<String, Object> totalData = companySonBillItemService.getTheTotalBill3(companyId, month);
            // 社保
            List<SocialSecurityInfo> securityInfos = socialSecurityInfoService.list3(companyId, month);
            // 公积金
            List<ReservedFundsInfo> reservedFundsInfos = reservedFundsInfoService.list3(companyId,month);
            // 工资
            List<SalaryInfo> salaryInfos = salaryInfoService.querySalaryInfo2(companyId,month);
            Map<String, Object> map = businessInsuranceService.getBusinessInsurance2(companyId,month);
            List<BusinessInsurance> businessInsuranceList = (List<BusinessInsurance>) map.get("businessInsurance");
            List<BusinessYc> businessYcList = (List<BusinessYc>) map.get("businessYc");
            exportExcelService.exportBillDetail(response,totalData,securityInfos,reservedFundsInfos,salaryInfos,businessInsuranceList,
                    businessYcList,billMonth);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

}
