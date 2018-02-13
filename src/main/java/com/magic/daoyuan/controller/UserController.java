package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.*;
import com.magic.daoyuan.business.enums.Common;
import com.magic.daoyuan.business.exception.InterfaceCommonException;
import com.magic.daoyuan.business.mail.EmailUtil;
import com.magic.daoyuan.business.service.BacklogService;
import com.magic.daoyuan.business.service.UserService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.MD5Util;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/9/12 0012.
 */
@RestController
@RequestMapping("/user")
public class UserController extends BaseController {

    @Resource
    private UserService userService;
    @Resource
    private BacklogService backlogService;


    /**
     * @param flag 0:前道组长+前道客服  1：销售主管 + 销售
     * @return
     */
    @RequestMapping("/queryUserByRoles")
    public ViewData queryUserByRoles(Integer flag){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryUserByRoles(flag));
    }


    /**
     * 通过角色ID 查询 用户集合
     * @param roleId
     * @return
     */
    @RequestMapping("/queryUserByRole")
    public ViewData queryUserByRole(Integer roleId){
        return buildSuccessViewData(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryUserByRole(roleId));
    }


    @RequestMapping("/logout")
    public ViewData logout(HttpServletRequest request){
        request.getSession().invalidate();
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");
    }

    @RequestMapping("/updateUser")
    public ViewData updateUser(User user){
        if(null == user.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User currentUser = LoginHelper.getCurrentUser();
            userService.updateUser(user,currentUser);
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
    }


    @RequestMapping("/add")
    public ViewData addUser(User user,String loginUrl){
        if(CommonUtil.isEmpty(user.getAccount(),user.getRoleId(),user.getPwd())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            User currentUser = LoginHelper.getCurrentUser();
            userService.addUser(user,loginUrl,currentUser);
        } catch (InterfaceCommonException e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(e.getErrorCode(),e.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
    }

    @RequestMapping("/queryUserList")
    public ViewDataPage queryUserList(String userName, Integer roleId, String account,
                                      String phone,String email, PageArgs pageArgs){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("userName",CommonUtil.isEmpty(userName) ? null : userName);
        params.put("roleId",roleId);
        params.put("account",CommonUtil.isEmpty(account) ? null : account);
        params.put("email",CommonUtil.isEmpty(email) ? null : email);
        params.put("phone",CommonUtil.isEmpty(phone) ? null : phone);
        PageList<User> userPageList = userService.queryUserByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                userPageList.getTotalSize(),userPageList.getList());
    }

    @RequestMapping("/login")
    public ViewData login(String account,String pwd,HttpServletRequest request){
        if(CommonUtil.isEmpty(account,pwd)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User user = userService.queryUserByAccount(account);
        if(null == user){
            return buildFailureJson(StatusConstant.USER_DOES_NOT_EXIST,"帐号不存在");
        }
        if(Common.NO.ordinal() == user.getIsValid()){
            return buildFailureJson(StatusConstant.ACCOUNT_FROZEN,"帐号无效,请联系管理员");
        }
        if(!pwd.equals(user.getPwd())){
            return buildFailureJson(StatusConstant.PASSWORD_ERROR,"密码错误");
        }
        request.getSession().setAttribute(LoginHelper.SESSION_USER,user);
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"登录成功",user);
    }

    @RequestMapping("/getUserById")
    public ViewData getUserById(Integer id){
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",
                userService.queryUserById(id));
    }

    @RequestMapping("/updatePassword")
    public ViewData updatePassword(String oldPwd, String newPwd){
        User currentUser = LoginHelper.getCurrentUser();
        if(null == currentUser){
            return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
        }
        if(CommonUtil.isEmpty(oldPwd, newPwd)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        User baseUser = userService.queryUserById(currentUser.getId());
        if(null == baseUser){
            return buildFailureJson(StatusConstant.OBJECT_NOT_EXIST,"用户不存在");
        }
        if(!oldPwd.equals(baseUser.getPwd())){
            return buildFailureJson(StatusConstant.Fail_CODE,"旧密码不正确");
        }
        if (oldPwd == newPwd) {
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"新密码和旧密码不能相同");
        }
        try {
            userService.updatePassword(baseUser.getId(), newPwd);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            e.printStackTrace();
            return buildFailureJson(StatusConstant.PASSWORD_ERROR,"更新失败");
        }

    }

    /***
     * 重置密码
     * @param pwd
     * @param userId
     * @return
     */
    @RequestMapping("/resetPassword")
    public ViewData resetPassword(String pwd, Integer userId,String loginUrl){
        User currentUser = LoginHelper.getCurrentUser();
        if(CommonUtil.isEmpty(pwd, userId)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        if(!pwd.equals(currentUser.getPwd())){
            return buildFailureJson(StatusConstant.Fail_CODE,"密码不正确");
        }
        try {
            User user = new User();
            user.setId(userId);
            user.setPwd(MD5Util.md5("111111"));
            userService.updateUser(user,LoginHelper.getCurrentUser());
            //待办 前道客服
            Backlog backlog = new Backlog();
            backlog.setRoleId(9);
            backlog.setUserId(userId);
            backlog.setContent("您的道远密码重置为111111，请及时修改");
//            backlog.setUrl("/page/companySonBillItem/totalList");
            backlogService.save(backlog);
            User user1 = userService.queryUserById(userId);
            if (!CommonUtil.isEmpty(user1.getEmail())) {
                Email email = new Email(user1.getEmail(),"您的道远密码重置为111111，请及时登录修改",loginUrl);
                EmailUtil.sendEmail(email);
            }
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            e.printStackTrace();
            return buildFailureJson(StatusConstant.PASSWORD_ERROR,"更新失败");
        }

    }

}
