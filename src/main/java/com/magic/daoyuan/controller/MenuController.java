package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Menu;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.service.MenuService;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

/**
 * 权限 -- 控制器
 * @author lzh
 * @create 2017/4/20 9:18
 */
@RestController
@RequestMapping("/menu")
public class MenuController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private MenuService menuService;


    /**
     * 全部权限(菜单)
     * @return
     */
    @RequestMapping("/findAllMenu")
    private ViewData findAllMenu(Integer roleId) {
        try {
            List<Menu> menuList = menuService.findAllMenu(roleId);
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",menuList);
        } catch (Exception e) {
            logger.error("服务器超时",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时");
        }
    }

    /**
     * 获取当前登录人角色的所有权限(菜单)
     * @return
     */
    @RequestMapping("/getRoleMenu")
    private ViewData getRoleMenu() {
        try {
            User user = LoginHelper.getCurrentUser();
            if(null == user){
                return buildFailureJson(StatusConstant.NOTLOGIN,"未登录");
            }
            List<Menu> menuList = menuService.getRoleMenu(user.getId());
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",menuList);
        } catch (Exception e) {
            logger.error("服务器超时",e);
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时");
        }
    }



}
