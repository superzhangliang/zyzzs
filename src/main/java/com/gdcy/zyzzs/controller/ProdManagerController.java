package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.excel.ExcelManager;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.ProdManager;
import com.gdcy.zyzzs.service.ProdManagerService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("prodManager/")
public class ProdManagerController extends BaseController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private ProdManagerService prodManagerService;
	
	/**
	 * 获取产品信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getProdManager")
	public void getProdManager(HttpServletRequest request, HttpServletResponse response,  ProdManager record) {
		JSONObject returnObj = new JSONObject();
		try {
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			List<ProdManager> list = prodManagerService.selectByEntity(record);
			int total = prodManagerService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取产品信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 操作产品信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editProdManager")
	public void editProdManager(HttpServletResponse response, HttpServletRequest request, ProdManager record){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			if( node == null ){
				return;
			}
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
				}else{//新增
					
					record.setAddTime(now);
					record.setAddUserId(la.getId());
					record.setNodeId(node.getId());
					
				}
				//事务控制
				DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try {
					if( record.getId() != null && !"".equals(record.getId()) ){
						this.prodManagerService.updateByPrimaryKeySelective(record);
					}else{
						this.prodManagerService.insertSelective(record);
					}
					
					txManager.commit(status);
					jsObj.put("id", record.getId());
					Util.setAjaxReturnSuccess(jsObj, "操作成功");
				} catch (Exception e) {
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "mysql", "操作产品信息失败！");
					logger.error("操作产品信息时数据库异常", e);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("操作产品信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 停用产品信息
	 * @param response
	 * @param request
	 * @param ProdManagerId
	 */
	@RequestMapping("/deleteProdManager")
	public void deleteProdManager( HttpServletResponse response, HttpServletRequest request, Long prodManagerId ){
		JSONObject jsObj = new JSONObject();
		try{
			ProdManager ProdManager = this.prodManagerService.selectByPrimaryKey(prodManagerId);
			if( ProdManager != null ){
				Date deleteTime = new Date();
				ProdManager.setIsDelete(1);
				ProdManager.setDeleteTime(deleteTime);
				
				this.prodManagerService.updateByPrimaryKeySelective(ProdManager);
				Util.setAjaxReturnSuccess(jsObj, "停用成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "停用失败！");
			logger.error("停用产品信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
}
