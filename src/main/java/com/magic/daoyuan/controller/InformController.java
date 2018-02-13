package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Inform;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.service.InformService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 通知
 * @author lzh
 * @create 2017/12/21 17:33
 */
@RestController
@RequestMapping("/inform")
public class InformController extends BaseController {

    @Resource
    private InformService informService;

    /**
     * 后台页面 分页获取通知
     *
     * @param pageArgs    分页属性
     * @return
     */
    @RequestMapping("/list")
    public ViewDataPage list(PageArgs pageArgs ,Long startTimeL , Long endTimeL ) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimeL) {
                startTime = new Date(startTimeL);
            }
            if (null != startTimeL) {
                endTime = new Date(endTimeL);
            }
            User user = LoginHelper.getCurrentUser();
            PageList pageList = informService.list(pageArgs,user.getId(), user.getRoleId(), startTime,endTime);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }


    /**
     * 删除
     * @param id
     * @return
     */
    @RequestMapping("/delete")
    public ViewData delete(Integer id){

        informService.delete(id);
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"操作成功");

    }



}
