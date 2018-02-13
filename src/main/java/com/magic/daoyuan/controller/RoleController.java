package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Role;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.service.RoleService;
import com.magic.daoyuan.business.service.UserService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author lzh
 * @create 2017/4/20 16:19
 */
@RestController
@RequestMapping("/role")
public class RoleController extends BaseController {


    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private RoleService roleService;
    @Resource
    private UserService userService;


    /**
     * 角色列表
     * @return
     */
    @RequestMapping("/list")
    public ViewData list() {
        try {
            List<Role> list = roleService.list();
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",list);
        } catch (Exception e) {
            logger.error("服务器超时，获取角色列表失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，获取角色列表失败");
        }
    }

    /**
     * 添加角色
     * @param role 角色实体
     * @return
     */
    @RequestMapping("/insert")
    public ViewData insert(Role role) {
        try {
            roleService.insert(role);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }

    /**
     * 更新角色
     * @return
     */
    @RequestMapping("/updateRole")
    public ViewData insert(Integer id,String roleName,String describe) {
        if(CommonUtil.isEmpty(id)){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            roleName = CommonUtil.isEmpty(roleName) ? null : roleName;
            describe = CommonUtil.isEmpty(describe) ? null : describe;
            roleService.updateRole(roleName,describe,id);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
        } catch (Exception e) {
            logger.error("服务器超时，更新失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }


    /**
     * 删除角色
     * @param id 角色id
     * @return
     */
    @RequestMapping("/delete")
    public ViewData delete(Integer id) {
        try {
            if (null == id ) {
                return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
            }
            List<User> userList = userService.queryUserByRole(id);
            if(null != userList && userList.size() > 0){
                return buildFailureJson(StatusConstant.Fail_CODE,"当前角色下有其他用户");
            }
            roleService.delete(id);
            return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
        } catch (Exception e) {
            logger.error("服务器超时，添加失败",e);
            return buildSuccessCodeJson(StatusConstant.Fail_CODE,"服务器超时，添加失败");
        }
    }
}
