package com.gdcy.zyzzs.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.Area;
import com.gdcy.zyzzs.service.AreaService;
import com.gdcy.zyzzs.util.AreaConstants;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("area/")
public class AreaController extends BaseController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private AreaService areaService;
	
	/**
	 * 获取区域信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getAreaInfo")
	public void getAreaInfo(HttpServletRequest request, HttpServletResponse response, Area  record) {
		JSONObject returnObj = new JSONObject();
		try {
			List<Area> list = this.areaService.selectByEntity(record);
			//四个直辖市编码
			List<String> str = new ArrayList<String>();
			str.add(AreaConstants.AREA_BJ);
			str.add(AreaConstants.AREA_TJ);
			str.add(AreaConstants.AREA_SH);
			str.add(AreaConstants.ATEA_CQ);
			returnObj.put("obj", list);
			returnObj.put("str", str);
		} catch (Exception e) {
			logger.error("获取区域信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 填写区域信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("fullAreaInfo")
	public void fullAreaInfo(HttpServletRequest request, HttpServletResponse response, Long  originCode) {
		JSONObject returnObj = new JSONObject();
		try {
			Area record = this.areaService.selectByPrimaryKey(originCode);
			Long proviceCode = 0L;
			Long cityCode = 0L;
			Long areaCode = 0L;
			if(record!=null){
				switch(record.getLevel()){
				case 1: 
					proviceCode = record.getId();
					record.setProviceCode(proviceCode);
					break;
				case 2:
					cityCode = record.getId();
					proviceCode = record.getPid();
					record.setProviceCode(proviceCode);
					record.setCityCode(cityCode);
					break;
				case 3:
					areaCode = record.getId();
					Area a = this.areaService.selectByPrimaryKey(record.getPid());
					cityCode = a.getId();
					proviceCode = a.getPid();
					record.setProviceCode(proviceCode);
					record.setCityCode(cityCode);
					record.setAreaCode(areaCode);
					break;
				default:
					break;
				}
			}
			
			//四个直辖市编码
			List<String> str = new ArrayList<String>();
			str.add(AreaConstants.AREA_BJ);
			str.add(AreaConstants.AREA_TJ);
			str.add(AreaConstants.AREA_SH);
			str.add(AreaConstants.ATEA_CQ);
			
			returnObj.put("obj", record);
			returnObj.put("str", str);
		} catch (Exception e) {
			logger.error("获取区域信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
}
