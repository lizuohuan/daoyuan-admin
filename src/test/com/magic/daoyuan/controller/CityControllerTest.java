package com.magic.daoyuan.controller;

import com.alibaba.fastjson.JSONArray;
import com.magic.daoyuan.business.service.CityService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.stereotype.Controller;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import static org.junit.Assert.*;

/**
 * @author lzh
 * @create 2017/10/18 9:58
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath*:/spring/root-context.xml","classpath*:/web.xml"})
public class CityControllerTest {

    @Resource
    private CityService cityService;

    @Test
    public void testGetCities() throws Exception {
        System.out.println(JSONArray.toJSON(cityService.queryAllCity()));
    }
}