package com.magic.daoyuan.controller;

import com.alibaba.fastjson.JSONArray;
import com.magic.daoyuan.business.service.MemberService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import static org.junit.Assert.*;

/**
 * @author lzh
 * @create 2017/10/16 11:06
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath*:/spring/root-context.xml","classpath*:/web.xml"})
public class MemberControllerTest {

    @Resource
    private MemberService memberTestService;
//
//    @Test
//    public void testInfo() throws Exception {
//        System.out.println(111);
//    }

    @Test
    public void getMemberList() throws Exception {
        System.out.println(JSONArray.toJSONString(memberTestService.getMemberList()));
    }


}