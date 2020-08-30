package com.gdcy.zyzzs.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.Business;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.service.BusinessService;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("business/")
public class BusinessController extends BaseController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	/** 经营商户基本信息 */
	@Resource
	private BusinessService businessService;
	
	/**
	 * 获取经营商户基本信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getBusiness")
	public void getBusiness(HttpServletRequest request, HttpServletResponse response, 
			Business record,Integer mark) {
		JSONObject returnObj = new JSONObject();
		try {
			if( record.getMarkTypeStrs() != null && !"".equals(record.getMarkTypeStrs()) ){
				String[] arr = record.getMarkTypeStrs().split(",");
				if( arr != null && arr.length > 0 ){
					List<Long> list = new ArrayList<Long>();
					for( String markType : arr ){
						list.add(Long.parseLong(markType));
					}
					record.setIdList(list);
				}
			}
			Node node = this.getNode(request);
			if(node != null){
				record.setNodeId(this.getNode(request).getId());
			}
			record.setIsDelete(mark);
			List<Business> list = businessService.selectByEntity(record);
			int total = businessService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取经营商户基本信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑经营者
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editBusiness")
	public void editBusiness(HttpServletResponse response, HttpServletRequest request, Business record){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateTime(new Date());
					this.businessService.updateByPrimaryKeySelective(record);
				}else{//新增
					Node node = this.getNode(request);
					Business businessRecord = new Business();
					
					businessRecord.setNodeId(node.getId());
					List<Business> listBusiness = this.businessService.selectByEntity(businessRecord);
					String codePre = "0001";
					if( !listBusiness.isEmpty()){
						codePre = String.format("%04d", Integer.parseInt(listBusiness.get(0).getCode().substring(9,13))+1);
					}
					record.setCode(node.getCode() + codePre);
					
					record.setAddTime(new Date());
					this.businessService.insertSelective(record);
					
				}
				Util.setAjaxReturnSuccess(jsObj, "操作成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑经营者时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 停用经营者
	 * @param response
	 * @param request
	 * @param businessId
	 */
	@RequestMapping("/deleteBusiness")
	public void deleteBusiness( HttpServletResponse response, HttpServletRequest request, Long businessId ){
		JSONObject jsObj = new JSONObject();
		try{
			Business business = this.businessService.selectByPrimaryKey(businessId);
			if( business != null ){
				business.setIsDelete(1);
				business.setDeleteTime(new Date());
				this.businessService.updateByPrimaryKeySelective(business);
				
				Util.setAjaxReturnSuccess(jsObj, "停用成功!");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "停用失败！");
			logger.error("停用经营者时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 恢复经营者
	 * @param response
	 * @param request
	 * @param businessId
	 */
	@RequestMapping("/recoveryBusiness")
	public void recoveryBusiness( HttpServletResponse response, HttpServletRequest request, Long businessId ){
		JSONObject jsObj = new JSONObject();
		try{
			Business business = this.businessService.selectByPrimaryKey(businessId);
			if( business != null ){
				business.setIsDelete(0);
				business.setDeleteTime(new Date());
				this.businessService.updateByPrimaryKeySelective(business);
				
				Util.setAjaxReturnSuccess(jsObj, "恢复成功!");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "恢复失败！");
			logger.error("恢复经营者时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
}
