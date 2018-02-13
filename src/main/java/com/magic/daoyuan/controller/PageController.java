package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.service.CompanyService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * Created by Eric Xie on 2017/9/12 0012.
 */
@Controller
@RequestMapping("/page")
public class PageController {

    @Resource
    private CompanyService companyService;

    /*** 配置列表 */
    // 快递公司配置
    @RequestMapping("/config/expressCompany")
    public String configExpressCompany() {
        return "/config/expressCompany/list";
    }

    // 银行配置
    @RequestMapping("/config/bank")
    public String configBank() {
        return "/config/bank/list";
    }
    // 银行配置 添加
    @RequestMapping("/config/bank/add")
    public String configBankAdd() {
        return "/config/bank/save";
    }
    // 银行配置 修改
    @RequestMapping("/config/bank/edit")
    public String configBankEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/config/bank/edit";
    }

    // 业务配置
    @RequestMapping("/config/business")
    public String businessConfig(){
        return "/config/business/list";
    }
    // 业务子类配置
    @RequestMapping("/config/business/itemList")
    public String businessConfigItemList(Integer businessId,Model model){
        model.addAttribute("businessId",businessId);
        if(businessId == 6){
            return "/config/business/itemList2";
        }
        return "/config/business/itemList";
    }



    /********** 客户/公司 合同 管理 ***********/
    @RequestMapping("/hetong/list")
    public String hetongList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/hetong/list";
    }

    @RequestMapping("/hetong/add")
    public String hetongAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/hetong/save";
    }

    @RequestMapping("/hetong/edit")
    public String hetongEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/hetong/edit";
    }
    /***************************/



    /***************************/
    /********** 客户/公司 票据 管理 ***********/
    @RequestMapping("/bill/list")
    public String billList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/bill/list";
    }

    @RequestMapping("/bill/add")
    public String billAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        model.addAttribute("companyName",companyService.queryCompanyById(companyId).getCompanyName());
        return "/bill/save";
    }

    @RequestMapping("/bill/edit")
    public String billEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/bill/edit";
    }
    /***************************/



    /***************************/
    /********** 客户/公司 子账单 管理 ***********/
    @RequestMapping("/companySonBill/list")
    public String companySonBillList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/companySonBill/list";
    }

    @RequestMapping("/companySonBill/add")
    public String companySonBillAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/companySonBill/save";
    }

    @RequestMapping("/companySonBill/edit")
    public String companySonBillEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/companySonBill/edit";
    }
    /***************************/




    /********** 客户/公司 联系人 管理 ***********/
    @RequestMapping("/lianxi/list")
    public String lianxiList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/lianxi/list";
    }

    @RequestMapping("/lianxi/add")
    public String lianxiAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/lianxi/save";
    }

    @RequestMapping("/lianxi/edit")
    public String lianxiEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/lianxi/edit";
    }
    @RequestMapping("/youji/list")
    public String youjiList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/youji/list";
    }

    @RequestMapping("/youji/add")
    public String youjiAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        model.addAttribute("companyName",companyService.info(companyId).getCompanyName());
        return "/youji/save";
    }

    @RequestMapping("/youji/edit")
    public String youjiEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/youji/edit";
    }

    @RequestMapping("/expressInfo/list")
    public String expressInfoList(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/expressInfo/list";
    }

    @RequestMapping("/expressInfo/add")
    public String expressInfoAdd(Integer companyId,Model model) {
        model.addAttribute("companyId",companyId);
        return "/expressInfo/save";
    }

    @RequestMapping("/expressInfo/edit")
    public String expressInfoEdit(Model model,Integer id) {
        model.addAttribute("id",id);
        return "/expressInfo/edit";
    }

    /***************************/


    /***************************/
    /********** 客户/公司管理 ***********/
    @RequestMapping("/company/list")
    public String companyList() {
        return "/company/list";
    }

    @RequestMapping("/company/list2")
    public String companyList2() {
        return "/company/list2";
    }

    @RequestMapping("/company/add")
    public String companyAdd() {
        return "/company/add";
    }

    @RequestMapping("/company/edit")
    public String companyEdit(Integer id,Model model) {
        model.addAttribute("id",id);
        return "/company/edit";
    }

    /** 票据管理 */
    @RequestMapping("/company/billEdit")
    public String companyBillEdit(Integer companyId,Model model,Integer billType) {
        model.addAttribute("companyId",companyId);
        model.addAttribute("billType",billType);
        return "/company/billEdit";
    }


    /***************************/



    /***************************/
    /********** 角色管理 ***********/
    @RequestMapping("/role/list")
    public String roleList() {
        return "/role/list";
    }

    @RequestMapping("/role/add")
    public String roleAdd() {
        return "/role/add";
    }
    /***************************/


    /***************************/
    /*********
     * 行业管理
     ***********/
    @RequestMapping("/trade/list")
    public String tradeList() {
        return "/trade/list";
    }

    /***************************/


    @RequestMapping("/login")
    public String loginPage() {
        return "login";
    }

    @RequestMapping("/index")
    public String indexPage() {
        return "index";
    }

    /**
     * 进入主页
     *
     * @return
     */
    @RequestMapping("/main")
    public String main() {
        return "main";
    }

    /**
     * 权限
     *
     * @return
     */
    @RequestMapping("/jurisdiction/add")
    public String jurisdiction() {
        return "/jurisdiction/add";
    }


    /**
     * 用户列表
     *
     * @return
     */
    @RequestMapping("/user/list")
    public String userList() {
        return "/user/list";
    }

    /**
     * 进入用户详情
     *
     * @return
     */
    @RequestMapping("/user/edit")
    public String userUpdate(Integer id, ModelMap modelMap) {
        modelMap.addAttribute("id", id);
        return "/user/edit";
    }

    /**
     * 进入用户详情
     *
     * @return
     */
    @RequestMapping("/user/personalDetail")
    public String useruserPersonalDetail(Integer id, ModelMap modelMap) {
        modelMap.addAttribute("id", id);
        return "/user/personalDetail";
    }

    /**
     * 进入用户详情
     *
     * @return
     */
    @RequestMapping("/user/updatePassword")
    public String useruserPpdatePassword() {
        return "/user/updatePassword";
    }

    /**
     * 添加用户
     *
     * @return
     */
    @RequestMapping("/user/save")
    public String userSave() {
        return "/user/save";
    }

    /**
     * 供应商管理--列表
     *
     * @return
     */
    @RequestMapping("/supplier/list")
    public String supplierList() { return "/supplier/list"; }

    /**
     * 供应商管理--添加
     *
     * @return
     */
    @RequestMapping("/supplier/add")
    public String supplierAdd() { return "/supplier/add"; }

    /**
     * 供应商管理--修改
     *
     * @return
     */
    @RequestMapping("/supplier/edit")
    public String supplierEdit() { return "/supplier/edit"; }

    /**
     * 联系人管理--列表
     *
     * @return
     */
    @RequestMapping("/supplierContacts/list")
    public String supplierContactsList() { return "/supplierContacts/list"; }

    /**
     * 联系人管理--添加
     *
     * @return
     */
    @RequestMapping("/supplierContacts/add")
    public String supplierContactsAdd() { return "/supplierContacts/add"; }

    /**
     * 联系人管理--修改
     *
     * @return
     */
    @RequestMapping("/supplierContacts/edit")
    public String supplierContactsEdit() { return "/supplierContacts/edit"; }

    /**
     * 收款信息--列表
     *
     * @return
     */
    @RequestMapping("/supplierAccountToBeCredited/list")
    public String supplierAccountToBeCreditedList() {
        return "/supplierAccountToBeCredited/list";
    }

    /**
     * 收款信息--添加
     *
     * @return
     */
    @RequestMapping("/supplierAccountToBeCredited/add")
    public String supplierAccountToBeCreditedAdd() { return "/supplierAccountToBeCredited/add"; }

    /**
     * 收款信息--修改
     *
     * @return
     */
    @RequestMapping("/supplierAccountToBeCredited/edit")
    public String supplierAccountToBeCreditedEdit() { return "/supplierAccountToBeCredited/edit"; }

    /**
     * 服务配置--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/list")
    public String supplierServiceConfigList() { return "/supplierServiceConfig/list"; }

    /**
     * 服务配置--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/add")
    public String supplierServiceConfigAdd() { return "/supplierServiceConfig/add"; }

    /**
     * 服务配置--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/edit")
    public String supplierServiceConfigEdit() { return "/supplierServiceConfig/edit"; }

    /**
     * 服务配置--详情
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/detail")
    public String supplierServiceConfigDetail() { return "/supplierServiceConfig/detail"; }

    /**
     * 服务配置--险种--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insurance/list")
    public String supplierServiceConfigInsuranceList() { return "/supplierServiceConfig/insurance/list"; }

    /**
     * 服务配置--险种--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insurance/add")
    public String supplierServiceConfigInsuranceAdd() { return "/supplierServiceConfig/insurance/add"; }

    /**
     * 服务配置--险种--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insurance/edit")
    public String supplierServiceConfigInsuranceEdit() { return "/supplierServiceConfig/insurance/edit"; }

    /**
     * 服务配置--档次--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel/list")
    public String supplierServiceConfigInsuranceLevelList() { return "/supplierServiceConfig/insuranceLevel/list"; }

    /**
     * 服务配置--档次--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel/add")
    public String supplierServiceConfigInsuranceLevelAdd() { return "/supplierServiceConfig/insuranceLevel/add"; }

    /**
     * 服务配置--档次--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel2/edit")
    public String supplierServiceConfigInsuranceLevel2Edit() { return "/supplierServiceConfig/insuranceLevel2/edit"; }

    /**
     * 服务配置--档次配置--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel2/list")
    public String supplierServiceConfigInsuranceLevel2List() { return "/supplierServiceConfig/insuranceLevel2/list"; }

    /**
     * 服务配置--档次配置--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel2/add")
    public String supplierServiceConfigInsuranceLevel2Add() { return "/supplierServiceConfig/insuranceLevel2/add"; }

    /**
     * 服务配置--档次配置--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/insuranceLevel/edit")
    public String supplierServiceConfigInsuranceLevelEdit() { return "/supplierServiceConfig/insuranceLevel/edit"; }

    /**
     * 服务配置--经办机构--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization/list")
    public String supplierServiceConfigOrganizationList() { return "/supplierServiceConfig/organization/list"; }

    /**
     * 服务配置--经办机构--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization/add")
    public String supplierServiceConfigOrganizationAdd() { return "/supplierServiceConfig/organization/add"; }

    /**
     * 服务配置--经办机构--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization/edit")
    public String supplierServiceConfigOrganizationEdit() { return "/supplierServiceConfig/organization/edit"; }

    /**
     * 服务配置--经办机构--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization2/list")
    public String supplierServiceConfigOrganization2List() { return "/supplierServiceConfig/organization2/list"; }

    /**
     * 服务配置--经办机构--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization2/add")
    public String supplierServiceConfigOrganization2Add() { return "/supplierServiceConfig/organization2/add"; }

    /**
     * 服务配置--经办机构--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/organization2/edit")
    public String supplierServiceConfigOrganization2Edit() { return "/supplierServiceConfig/organization2/edit"; }

    /**
     * 服务配置--办理方--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor/list")
    public String supplierServiceConfigTransactorList() { return "/supplierServiceConfig/transactor/list"; }

    /**
     * 服务配置--办理方--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor/add")
    public String supplierServiceConfigTransactorAdd() { return "/supplierServiceConfig/transactor/add"; }

    /**
     * 服务配置--办理方--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor/edit")
    public String supplierServiceConfigTransactorEdit() { return "/supplierServiceConfig/transactor/edit"; }

    /**
     * 服务配置--办理方--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor2/list")
    public String supplierServiceConfigTransactor2List() { return "/supplierServiceConfig/transactor2/list"; }

    /**
     * 服务配置--办理方--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor2/add")
    public String supplierServiceConfigTransactor2Add() { return "/supplierServiceConfig/transactor2/add"; }

    /**
     * 服务配置--办理方--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactor2/edit")
    public String supplierServiceConfigTransactor2Edit() { return "/supplierServiceConfig/transactor2/edit"; }

    /**
     * 服务配置--办理方--绑定档次--列表
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactorInsuranceLevel/list")
    public String supplierServiceConfigTransactorInsuranceLevelList() { return "/supplierServiceConfig/transactorInsuranceLevel/list"; }

    /**
     * 服务配置--办理方--添加
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactorInsuranceLevel/add")
    public String supplierServiceConfigTransactorInsuranceLevelAdd() { return "/supplierServiceConfig/transactorInsuranceLevel/add"; }

    /**
     * 服务配置--办理方--修改
     *
     * @return
     */
    @RequestMapping("/supplierServiceConfig/transactorInsuranceLevel/edit")
    public String supplierServiceConfigTransactorInsuranceLevelEdit() { return "/supplierServiceConfig/transactorInsuranceLevel/edit"; }

    /**
     * 员工管理--列表
     *
     * @return
     */
    @RequestMapping("/member/list")
    public String memberList() { return "/member/list"; }

    /**
     * 员工管理--添加
     *
     * @return
     */
    @RequestMapping("/member/add")
    public String memberAdd() { return "/member/add"; }

    /**
     * 员工管理--修改
     *
     * @return
     */
    @RequestMapping("/member/edit")
    public String memberEdit() { return "/member/edit"; }

    /**
     * 客户列表--社保列表
     *
     * @return
     */
    @RequestMapping("/socialSecurity/list")
    public String socialSecurityList() { return "/socialSecurity/list"; }

    /**
     * 客户列表--社保添加
     *
     * @return
     */
    @RequestMapping("/socialSecurity/add")
    public String socialSecurityAdd() { return "/socialSecurity/add"; }

    /**
     * 客户列表--社保修改
     *
     * @return
     */
    @RequestMapping("/socialSecurity/edit")
    public String socialSecurityEdit() { return "/socialSecurity/edit"; }

    /**
     * 客户列表--公积金列表
     *
     * @return
     */
    @RequestMapping("/accumulationFund/list")
    public String accumulationFundList() { return "/accumulationFund/list"; }

    /**
     * 客户列表--公积金添加
     *
     * @return
     */
    @RequestMapping("/accumulationFund/add")
    public String accumulationFundAdd() { return "/accumulationFund/add"; }

    /**
     * 客户列表--公积金修改
     *
     * @return
     */
    @RequestMapping("/accumulationFund/edit")
    public String accumulationFundEdit() { return "/accumulationFund/edit"; }

    /**
     * 客户列表--子类列表
     *
     * @return
     */
    @RequestMapping("/companySonBillItem/list")
    public String companySonBillItemList() { return "/companySonBillItem/list"; }

    /**
     * 账单汇总列表
     *
     * @return
     */
    @RequestMapping("/companySonBillItem/totalList")
    public String companySonBillItemTotalList() { return "/companySonBillItem/totalList"; }

    /**
     * 稽核列表
     *
     * @return
     */
    @RequestMapping("/companySonBillItem/auditList")
    public String auditList() { return "/companySonBillItem/auditList"; }

    /**
     * 一键生成
     *
     * @return
     */
    @RequestMapping("/companySonBillItem/generateList")
    public String generateList() { return "/companySonBillItem/generateList"; }

    /**
     * 实做-员工业务增减变表
     *
     * @return
     */
    @RequestMapping("/memberBusiness/list")
    public String memberBusinessList() { return "/memberBusiness/list"; }

    /**
     * 实做--添加
     *
     * @return
     */
    @RequestMapping("/memberBusiness/add")
    public String memberBusinessAdd() { return "/memberBusiness/add"; }

    /**
     * 实做-员工业务增减变表--子类
     *
     * @return
     */
    @RequestMapping("/memberBusinessItem/list")
    public String memberBusinessItemList() { return "/memberBusinessItem/list"; }

    /**
     * 实做--详情
     *
     * @return
     */
    @RequestMapping("/memberBusinessItem/detail")
    public String memberBusinessItemDetail() { return "/memberBusinessItem/detail"; }

    /**
     * 客户管理--账户信息添加
     *
     * @return
     */
    @RequestMapping("/bankInfo/add")
    public String bankInfoAdd() { return "/bankInfo/add"; }

    /**
     * 客户管理--账户信息列表
     *
     * @return
     */
    @RequestMapping("/bankInfo/list")
    public String bankInfoList() { return "/bankInfo/list"; }

    /**
     * 客户管理--账户信息修改
     *
     * @return
     */
    @RequestMapping("/bankInfo/edit")
    public String bankInfoEdit() { return "/bankInfo/edit"; }

    /**
     * 财务--认款--列表
     *
     * @return
     */
    @RequestMapping("/confirmAmount/list")
    public String confirmAmountList() { return "/confirmAmount/list"; }

    /**
     * 财务--手动认款
     *
     * @return
     */
    @RequestMapping("/confirmAmount/edit")
    public String confirmAmountEdit() { return "/confirmAmount/edit"; }

    /**
     * 财务--处理认款--列表
     *
     * @return
     */
    @RequestMapping("/confirmAmountDispose/list")
    public String confirmAmountDisposeList() { return "/confirmAmountDispose/list"; }

    /**
     * 财务--出款--列表
     *
     * @return
     */
    @RequestMapping("/outlayAmountRecord/list")
    public String outlayAmountRecordList() { return "/outlayAmountRecord/list"; }

    /**
     * 财务--出款--添加
     *
     * @return
     */
    @RequestMapping("/outlayAmountRecord/add")
    public String outlayAmountRecordAdd() { return "/outlayAmountRecord/add"; }

    /**
     * 财务--出款--修改
     *
     * @return
     */
    @RequestMapping("/outlayAmountRecord/edit")
    public String outlayAmountRecordEdit() { return "/outlayAmountRecord/edit"; }

    /**
     * 工单--票据列表
     *
     * @return
     */
    @RequestMapping("/financeBill/list")
    public String financeBillList() { return "/financeBill/list"; }

    /**
     * 知识库--详情
     *
     * @return
     */
    @RequestMapping("/repository/detail")
    public String repositoryDetail() { return "/repository/detail"; }

    /**
     * 知识库--添加
     *
     * @return
     */
    @RequestMapping("/repository/add")
    public String repositoryAdd() { return "/repository/add"; }

    /**
     * 知识库--列表
     *
     * @return
     */
    @RequestMapping("/repository/list")
    public String repositoryList() { return "/repository/list"; }

    /**
     * 知识库--修改
     *
     * @return
     */
    @RequestMapping("/repository/edit")
    public String repositoryEdit() { return "/repository/edit"; }

    /**
     * 工单--添加
     *
     * @return
     */
    @RequestMapping("/workOrder/add")
    public String workOrderAdd() { return "/workOrder/add"; }

    /**
     * 工单--列表
     *
     * @return
     */
    @RequestMapping("/workOrder/list")
    public String workOrderList() { return "/workOrder/list"; }

    /**
     * 工单--修改
     *
     * @return
     */
    @RequestMapping("/workOrder/edit")
    public String workOrderEdit() { return "/workOrder/edit"; }

    /**
     * 工单--进度
     *
     * @return
     */
    @RequestMapping("/workOrder/schedule")
    public String workOrderSchedule() { return "/workOrder/schedule"; }

    /**
     * 工单--审批页面
     *
     * @return
     */
    @RequestMapping("/workOrder/audit")
    public String workOrderAudit() { return "/workOrder/audit"; }

    /**
     * 工单--预览页面
     *
     * @return
     */
    @RequestMapping("/workOrder/preview")
    public String workOrderPreview() { return "/workOrder/preview"; }

    /**
     * 财务统计 -- 公司统计
     *
     * @return
     */
    @RequestMapping("/count/companyCount")
    public String companyCount() { return "/count/companyCount"; }

    /**
     * 财务统计 -- 公司统计
     *
     * @return
     */
    @RequestMapping("/count/companyCount2")
    public String companyCount2() { return "/count/companyCount2"; }

    /**
     * 财务统计 -- 账单统计
     *
     * @return
     */
    @RequestMapping("/count/billCount")
    public String billCount() { return "/count/billCount"; }

    /**
     * 财务统计 -- 账单统计
     *
     * @return
     */
    @RequestMapping("/count/billCount2")
    public String billCount2() { return "/count/billCount2"; }

    /**
     * 通知 -- 列表
     *
     * @return
     */
    @RequestMapping("/inform/list")
    public String informList() { return "/inform/list"; }

    /**
     * 待办事项 -- 列表
     *
     * @return
     */
    @RequestMapping("/inform/list2")
    public String informList2() { return "/inform/list2"; }

    /**
     * 操作日志 -- 列表
     *
     * @return
     */
    @RequestMapping("/config/actionlog")
    public String configActionLog() { return "/config/actionlog/list"; }

    /**
     * 意见反馈 -- 列表
     *
     * @return
     */
    @RequestMapping("/config/feedback")
    public String configFeedback() { return "/config/feedback/list"; }

    /**
     * 客户详情
     *
     * @return
     */
    @RequestMapping("/companyDetail")
    public String companyDetail() { return "/company/detail"; }


    /************************************************************************H5*****************************************************************/
    /**账单明细**/
    @RequestMapping("/h5/billDetail")
    public String billDetail() { return "/h5/billDetail"; }

    /**社保明细**/
    @RequestMapping("/h5/socialSecurityDetail")
    public String socialSecurityDetail() { return "/h5/socialSecurityDetail"; }

    /**公积金明细**/
    @RequestMapping("/h5/accumulationFundDetail")
    public String accumulationFundDetail() { return "/h5/accumulationFundDetail"; }

    /**工资明细**/
    @RequestMapping("/h5/salaryDetail")
    public String salaryDetail() { return "/h5/salaryDetail"; }

    /**专项服务进度**/
    @RequestMapping("/h5/exclusiveService")
    public String exclusiveService() { return "/h5/exclusiveService"; }

    /**全部明细**/
    @RequestMapping("/h5/allDetail")
    public String allDetail() { return "/h5/allDetail"; }

    /**错误页面**/
    @RequestMapping("/error")
    public String error() { return "/error"; }


}
