package com.magic.daoyuan.controller;

import com.magic.daoyuan.business.entity.PageArgs;
import com.magic.daoyuan.business.entity.PageList;
import com.magic.daoyuan.business.entity.Repository;
import com.magic.daoyuan.business.entity.User;
import com.magic.daoyuan.business.service.RepositoryService;
import com.magic.daoyuan.business.util.CommonUtil;
import com.magic.daoyuan.business.util.LoginHelper;
import com.magic.daoyuan.business.util.StatusConstant;
import com.magic.daoyuan.util.ViewData;
import com.magic.daoyuan.util.ViewDataPage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 知识库接口
 */
@RestController
@RequestMapping("/repository")
public class RepositoryController extends BaseController{

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    private RepositoryService repositoryService;

    /**
     * 分页查询知识库
     * @param title 标题
     * @param antistop    关键字
     * @param pageArgs 页码
     * @return 知识库集合
     */
    @RequestMapping("/list")
    public ViewDataPage list (String title, String antistop, PageArgs pageArgs,Integer type,String kbid) {
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("title", CommonUtil.isEmpty(title) ? null : title);
        params.put("antistop", CommonUtil.isEmpty(antistop) ? null : antistop);
        params.put("kbid", CommonUtil.isEmpty(kbid) ? null : kbid);
        params.put("type", type);
        PageList<Repository> list = repositoryService.queryRepositoryByItems(params, pageArgs);
        return buildSuccessViewDataPage(StatusConstant.SUCCESS_CODE,"获取成功",
                list.getTotalSize(),list.getList());
    }

    /**
     * 添加知识库
     * @param repository 知识库实体
     * @return
     */
    @RequestMapping("/add")
    public ViewData insert (Repository repository) {
        User user = LoginHelper.getCurrentUser();
        repository.setCreateUserId(user.getId());
        if(CommonUtil.isEmpty(repository.getTitle(),repository.getAntistop())){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            repositoryService.insert(repository,LoginHelper.getCurrentUser());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"添加失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"添加成功");
    }

    /**
     * 修改知识库
     * @param repository 知识库实体
     * @return
     */
    @RequestMapping("/update")
    public ViewData update (Repository repository) {
        User user = LoginHelper.getCurrentUser();
        repository.setUpdateUserId(user.getId());
        if(null == repository.getId()){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            repositoryService.update(repository,LoginHelper.getCurrentUser());
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"更新失败");
        }
        return buildSuccessCodeJson(StatusConstant.SUCCESS_CODE,"更新成功");
    }

    /**
     * 知识库详情
     * @param id 知识库ID
     * @return
     */
    @RequestMapping("/findById")
    public ViewData findById (Integer id) {
        if(null == id){
            return buildFailureJson(StatusConstant.FIELD_NOT_NULL,"字段不能为空");
        }
        try {
            return buildSuccessJson(StatusConstant.SUCCESS_CODE,"获取成功",repositoryService.findById(id));
        } catch (Exception e) {
            logger.error(e.getMessage(),e);
            return buildFailureJson(StatusConstant.Fail_CODE,"获取失败");
        }
    }

}
