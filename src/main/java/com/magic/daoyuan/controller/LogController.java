package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.Log;
import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.service.LogService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewDataPage;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Eric Xie on 2017/12/27 0027.
 */

@RestController
@RequestMapping(value = "/log")
public class LogController extends BaseController {


    @Resource
    private LogService logService;

    /**
     * 获取操作日志列表
     * @param startTimeStamp 开始日期时间戳
     * @param endTimeStamp 结束日期时间戳
     * @param flag 0：增、1：删、2：改 数据
     * @param model 0 ： 客户模块 .. 其他待定
     * @param pageArgs 分页参数
     * @return
     */
    @RequestMapping(value = "/getLogList",method = RequestMethod.GET)
    public ViewDataPage getLogList(Long startTimeStamp,Long endTimeStamp,String content,Integer flag,Integer model,PageArgs pageArgs){
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("startTime",null == startTimeStamp ? null : new Date(startTimeStamp));
        params.put("endTime",null == endTimeStamp ? null : new Date(endTimeStamp));
        params.put("flag",flag);
        params.put("model",model);
        params.put("content", CommonUtil.isEmpty(content) ? null : content);
        PageList<Log> log = logService.getLog(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",log.getTotalSize(),log.getList());
    }


}
