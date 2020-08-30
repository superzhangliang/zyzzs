package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.gdcy.zyzzs.excel.StaticAmountInfo;
import com.gdcy.zyzzs.excel.StaticInfo;
import com.gdcy.zyzzs.pojo.InputsManager;
import com.gdcy.zyzzs.pojo.Invalid;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.NumChangeRecord;
import com.gdcy.zyzzs.service.InputsManagerService;
import com.gdcy.zyzzs.service.InvalidService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("inputsManager/")
public class InputsManagerController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private InputsManagerService inputsManagerService;
	
	@Resource
	private InvalidService invalidService;
	
	/**
	 * 获取投入品信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getInputsManager")
	public void getInputsManager(HttpServletRequest request, HttpServletResponse response,  InputsManager record) {
		JSONObject returnObj = new JSONObject();
		try {
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			record.setIsDelete(0);
			List<InputsManager> list = inputsManagerService.selectByEntity(record);
			int total = inputsManagerService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取投入品信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑投入品信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editInputsManager")
	public void editInputsManager(HttpServletResponse response, HttpServletRequest request, InputsManager record){
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
					record.setUpdateTime(now);
					
				}else{//新增
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setNodeId(node.getId());
					record.setNum(0D);
				}
				
				//事务控制
				DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try {
					if( record.getId() != null && !"".equals(record.getId()) ){
						this.inputsManagerService.updateByPrimaryKeySelective(record);
						Util.setAjaxReturnSuccess(jsObj, "编辑信息成功!");
					}else{
						this.inputsManagerService.insertSelective(record);
						Util.setAjaxReturnSuccess(jsObj, "新增信息成功!");
					}
					
					txManager.commit(status);
					jsObj.put("id", record.getId());
				} catch (Exception e) {
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "mysql", "编辑投入品信息失败！");
					logger.error("编辑投入品信息时数据库异常", e);
				}
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑投入品信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除投入品信息
	 * @param response
	 * @param request
	 * @param InputsManagerId
	 */
	@RequestMapping("/deleteInputsManager")
	public void deleteInputsManager( HttpServletResponse response, HttpServletRequest request, Long inputsManagerId ){
		JSONObject jsObj = new JSONObject();
		try{
			InputsManager inputsManager = this.inputsManagerService.selectByPrimaryKey(inputsManagerId);
			if( inputsManager != null ){
				Date deleteTime = new Date();
				inputsManager.setIsDelete(1);
				inputsManager.setDeleteTime(deleteTime);
				this.inputsManagerService.updateByPrimaryKeySelective(inputsManager);
				
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除投入品信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	 /**
		 * 投入品信息导出
		 * @param request
		 * @param response
		 * @param record
		 */
	@RequestMapping("exportInputsManager")
	public void exportInputsManager(HttpServletRequest request,HttpServletResponse response,InputsManager record){
		OutputStream out=null;
		try{
			record.setIsDelete(0);
			List<InputsManager> listInputsManager = this.inputsManagerService.selectByEntity(record);
			if(!listInputsManager.isEmpty()){
				ExcelManager<InputsManager> excelManager = new ExcelManager<InputsManager>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, "inputsManagerInfo", listInputsManager, out);
				out.flush();
			}
		}catch (Exception e) {
			logger.error("导出数据错误！",e);
		}finally{
			if(out!=null){
				try{
					out.close();
				}catch (Exception e) {
					logger.error("流数据输出错误！",e);
				}
			}
		}
	}
	
	/**
	 * 报废库存
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/scrapInputs")
	public void scrapInputs( HttpServletResponse response, HttpServletRequest request, Invalid record ){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				LoginAccount la = this.getCurrentUser(request);
				Date now = new Date();
				record.setAddTime(now);
				record.setAddUserId(la.getId());
				record.setIsDelete(0);
				
				InputsManager im = this.inputsManagerService.selectByPrimaryKey(record.getpId());
				double oldNum = im.getNum();
				im.setNum(oldNum - record.getNum());
				im.setUpdateTime(now);
				im.setUpdateUserId(la.getId());
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					this.invalidService.insertSelective(record);
					this.inputsManagerService.updateByPrimaryKeySelective(im);
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "报废成功！");
				}catch( Exception e ){
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "param", "数据库异常！");
					logger.error("报废库存时数据库异常", e);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常！");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常！");
			logger.error("报废库存时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 撤销报废
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/cancelScrap")
	public void cancelScrap( HttpServletResponse response, HttpServletRequest request, Invalid record ){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				LoginAccount la = this.getCurrentUser(request);
				Date now = new Date();
				record.setDeleteTime(now);
				record.setDeleteUserId(la.getId());
				record.setIsDelete(1);
				
				InputsManager im = this.inputsManagerService.selectByPrimaryKey(record.getpId());
				double oldNum = im.getNum();
				im.setNum(oldNum + record.getNum());
				im.setUpdateTime(now);
				im.setUpdateUserId(la.getId());
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					this.invalidService.updateByPrimaryKeySelective(record);
					this.inputsManagerService.updateByPrimaryKeySelective(im);
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "撤销成功！");
				}catch( Exception e ){
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "param", "数据库异常！");
					logger.error("撤销报废库存时数据库异常", e);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常！");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常！");
			logger.error("撤销报废库存时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 获取库存变化列表
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/showNumChangeRecord")
	public void showNumChangeRecord(HttpServletResponse response, HttpServletRequest request, NumChangeRecord record ) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			record.setIsDelete(0);
			
			List<NumChangeRecord> list = this.inputsManagerService.selectNumChangeRecord(record);
			Integer total = this.inputsManagerService.countNumChangeRecord(record);
			
			resultMap.put("rows", list);
			resultMap.put("total", total);
		} catch (Exception e) {
			logger.error("获取库存变化列表时异常", e);
		}
		
		Util.writeResultMap(response, resultMap);
	}
	 
	 /**同步投入品到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param InputsManagerId
	  */
	/*@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long InputsManagerId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<InputsManager> listInputsManager = new ArrayList<InputsManager>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sAnimalIn");
			if( InputsManagerId != null && !"".equals(InputsManagerId) ){//新增时同步
				InputsManager record = inputsManagerService.selectByPrimaryKey(InputsManagerId);
				if( record != null ){
					listInputsManager.add(record);
				}
			}else{//一键同步
				InputsManager InputsManagerR = new InputsManager();
				if( node != null ){
					InputsManagerR.setNodeId(node.getId());
				}
				
				InputsManagerR.setIsDelete(0);
				InputsManagerR.setIsReport(Constants.REPORT_NO);
				
				listInputsManager = inputsManagerService.selectByEntity(InputsManagerR);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listInputsManager != null && listInputsManager.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( InputsManager record : listInputsManager ){
					
					JSONObject job = formatObject(record);
					//分批上报
					int mapSize = map.size() == 0?1:map.size();
					listT = map.get(mapSize)==null?new ArrayList<JSONObject>():map.get(mapSize);
					listIds = mapIds.get(mapSize)==null?new ArrayList<Long>():mapIds.get(mapSize);
					if( listT != null && listT.size() < maxReportNum.intValue() ){
						listT.add(job);
						map.put(mapSize, listT);
						
						listIds.add(record.getId());
						mapIds.put(mapSize, listIds);
					}else{
						listT = new ArrayList<JSONObject>();
						listT.add(job);
						map.put(mapSize+1, listT);
						
						listIds = new ArrayList<Long>();
						listIds.add(record.getId());
						mapIds.put(mapSize+1, listIds);
					}
				}
			}
			
			List<String> listJoStr = new ArrayList<String>();
			if( map != null && map.size() > 0 ){
				for(Integer i : map.keySet() ){
					jo.put("list", map.get(i));
					jo.put("size", i);
					listJoStr.add(JSON.toJSONString(jo));
				}
			}
			
			String cszsURL = (String) PropertiesUtil.getProperty("cszsURL", PropertiesUtil.PROP_CONSTANTS_FILE);
			
			try{
				logger.info("同步场投入品信息开始·····································································");
				if( listJoStr != null && listJoStr.size() > 0){
					Date now = new Date();
					boolean successFlag = false;
					for( String joStr : listJoStr ){
						boolean success = false;
						try{
							success = super.dealDataToCszs(cszsURL, joStr);
						}catch(Exception e){
							success = false;
						}
						
						if( success ){
							//上报成功后更新InputsManager为已上报状态
							JSONObject Jo = JSONObject.parseObject(joStr);
							Integer size = Jo.getInteger("size");
							List<Long> idList = mapIds.get(size);
							if( idList != null && idList.size() > 0 ){
								Report report = new Report();
								report.setIsReport(Constants.REPORT_YES);
								report.setUpdateTime(now);
								report.setIdList(idList);
								report.setReportFlag(Constants.REPORT_FLAG_InputsManager);
								this.inputsManagerService.batchUpdateIsReport(report);
							}
							successFlag = true;
						}
					}
						
					if( successFlag ){
						Util.setAjaxReturnSuccess(jsObj, "同步成功！");
					}else{
						Util.setAjaxReturnError(jsObj, "system", "溯源服务器异常，同步失败！");
					}
					
				}else{
					Util.setAjaxReturnError(jsObj, "system", "无数据需要同步！");
				}
				
			}catch(Exception e){
				Util.setAjaxReturnError(jsObj, "system", "同步失败！");
				logger.error("同步场投入品信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步场投入品信息时发生异常", e);
		}
		if( response != null ){
			Util.writeObject(response, jsObj);
		}
	}*/
	
	/**
	 * 格式化InputsManager
	 * @param record
	 * @return
	 */
	/*public JSONObject formatObject( InputsManager record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		JSONObject job = new JSONObject();
		job.put("butcherFacId", node.getCode());
		job.put("butcherFacName", node.getName());
		job.put("inDate", record.getInTime());
		job.put("batchId", record.getBatchId());
		job.put("sellerId", record.getBusinessCode());
		job.put("sellerName", record.getBusinessName());
		job.put("quarantineId", record.getQuarantineId());
		job.put("quarantineNum", record.getQurantineNum());
		DecimalFormat df=new DecimalFormat("#.00");
		BigDecimal price = new BigDecimal(record.getPrice()).multiply(new BigDecimal(2));
		BigDecimal amount = new BigDecimal(record.getAmount()).divide(new BigDecimal(2));
		job.put("price", df.format(price.doubleValue()));
		job.put("amount", df.format(amount.doubleValue()));
		job.put("deadNum", record.getDeadNum());
		job.put("result", record.getResult());
		job.put("areaOriginId", record.getOriginCode());
		job.put("areaOriginName", record.getOriginName());
		job.put("farmName", record.getFarmName());
		job.put("transporterId", record.getTransporterId());
		
		return job;
	}*/
	
}
