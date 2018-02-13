package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.ConsoleService;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.business.util.Timestamp;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 控制台 部分数据
 * @author lzh
 * @create 2017/12/25 18:07
 */
@RestController
@RequestMapping("/console")
public class ConsoleController extends BaseController {

    @Resource
    private ConsoleService consoleService;

    /**
     * 控制台右下角统计数据
     * @return
     */
    @RequestMapping("/rightConsole")
    public ViewData rightConsole() {
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",consoleService.rightConsole(new Date()));
        } catch (Exception e) {
            return buildFailureJson(StatusConstant.Fail_CODE,"服务器超时");
        }
    }

    /**
     * 后台页面 分页获取工作台列表
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
    public ViewDataPage listDto(PageArgs pageArgs , Integer companyId , String companyName , Integer companySonBillId , String startTimes , String endTimes ) {
        try {
            Date startTime = null;
            Date endTime = null;
            if (null != startTimes && !startTimes.equals("")) {
                startTime = Timestamp.parseDate2(startTimes,"yyyy-MM-dd HH:mm:ss");
            }
            if (null != endTimes && !endTimes.equals("")) {
                endTime = Timestamp.parseDate2(endTimes,"yyyy-MM-dd HH:mm:ss");
            }
            PageList pageList = consoleService.
                    listConsoleDto(pageArgs, companyId ,companyName ,companySonBillId, startTime ,endTime);
            return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功 ",
                    pageList.getTotalSize(),pageList.getList());
        } catch (Exception e) {
            logger.error("服务器超时，获取失败",e);
            return buildFailureJsonPage(StatusConstant.Fail_CODE,"服务器超时，获取失败");
        }
    }

}
