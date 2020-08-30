package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.util.ArrayList;
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
import com.gdcy.zyzzs.pojo.InputsManager;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.OriginInputsRecord;
import com.gdcy.zyzzs.pojo.OriginPurchaseInputs;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.service.InputsManagerService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.OriginBatchInfoService;
import com.gdcy.zyzzs.service.OriginInputsRecordService;
import com.gdcy.zyzzs.service.OriginPurchaseInputsService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.PropertiesUtil;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("originInputsRecord/")
public class OriginInputsRecordController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private OriginInputsRecordService originInputsRecordService;
	
	@Resource
	private InputsManagerService inputsManagerService;
	
	@Resource
	private OriginBatchInfoService originBatchInfoService;
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private OriginPurchaseInputsService originPurchaseInputsService;
	
	/**
	 * 获取投入品使用信息信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getOriginInputsRecord")
	public void getOriginInputsRecord(HttpServletRequest request, HttpServletResponse response,  OriginInputsRecord record) {
		JSONObject returnObj = new JSONObject();
		try {
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			if( node != null && node.getType() != null ){
				record.setType(node.getType());
			}
			record.setIsDelete(0);
			List<OriginInputsRecord> list = originInputsRecordService.selectByEntity(record);
			int total = originInputsRecordService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取投入品使用信息信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑投入品使用信息信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editOriginInputsRecord")
	public void editOriginInputsRecord(HttpServletResponse response, HttpServletRequest request, OriginInputsRecord record){
		JSONObject jsObj = new JSONObject();
		
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			Double oldNum=0D;
			Double newNum=0D;
			InputsManager oldIm = null;
			InputsManager newIm = this.inputsManagerService.selectByPrimaryKey(record.getInputsId());
			
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
					
					OriginInputsRecord oldOi = this.originInputsRecordService.selectByPrimaryKey(record.getId());
					oldIm = this.inputsManagerService.selectByPrimaryKey(oldOi.getInputsId());
					if(record.getInputsId().longValue()==oldOi.getInputsId().longValue()){
						//修改采购信息时未修改投入品，此时投入品的库存应该先加上旧的num，然后再减去新的num
						
						//修改采购数量/采购重量单选框时
						Double oldOiNum = 0D;
						if( oldOi.getAmount()!= null && oldOi.getAmount() != 0D ){
							oldOiNum = oldOi.getAmount();
						}else if( oldOi.getWeight()!=null && oldOi.getWeight() != 0D ){
							oldOiNum = oldOi.getWeight();
						}
						if( record.getAmount() != null && record.getAmount() != 0D ){
							record.setWeight(0D);
							oldNum = oldIm.getNum() + oldOiNum - record.getAmount();
						}else if( record.getWeight() !=null && record.getWeight() != 0D ){
							record.setAmount(0D);
							oldNum = oldIm.getNum() + oldOiNum - record.getWeight();
						}
						
					}else{
						//若修改了投入品，则要先给旧投入库存加上num，然后再给新的投入品库存减去num
						if(oldOi.getAmount()!= null && oldOi.getAmount() != 0D ){
							oldNum = oldIm.getNum() + oldOi.getAmount();
						}else{
							oldNum = oldIm.getNum() + oldOi.getWeight();
						}
						if(record.getAmount()!= null && record.getAmount() != 0D ){
							record.setWeight(0D);
							newNum = newIm.getNum() - record.getAmount();
						}else{
							record.setAmount(0D);
							newNum = newIm.getNum() - record.getWeight();
						}
						
						newIm.setNum(newNum);
						newIm.setUpdateTime(now);
						newIm.setUpdateUserId(la.getId());
					}
					
					oldIm.setNum(oldNum);
					oldIm.setUpdateTime(now);
					oldIm.setUpdateUserId(la.getId());
					
				}else{//新增
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setIsDelete(0);
					record.setNodeId(node.getId());
					record.setType(node.getType());
					
					if( record.getAmount() != null && record.getAmount() != 0D ){
						newNum = newIm.getNum() - record.getAmount();
					}else if( record.getWeight() != null && record.getWeight() != 0D ){
						newNum = newIm.getNum() - record.getWeight();
					}
					
					newIm.setNum(newNum);
					newIm.setUpdateTime(now);
					newIm.setUpdateUserId(la.getId());
				}
				
				//事务控制
				DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try {
					if( record.getId() != null && !"".equals(record.getId()) ){
						this.originInputsRecordService.updateByPrimaryKeySelective(record);
						this.inputsManagerService.updateByPrimaryKeySelective(oldIm);
						if(newIm.getId().longValue()!=oldIm.getId().longValue()){
							this.inputsManagerService.updateByPrimaryKeySelective(newIm);
						}
						Util.setAjaxReturnSuccess(jsObj, "编辑投入品使用信息成功!");
					}else{
						this.originInputsRecordService.insertSelective(record);
						this.inputsManagerService.updateByPrimaryKeySelective(newIm);
						Util.setAjaxReturnSuccess(jsObj, "新增投入品使用信息成功!");
					}
					
					txManager.commit(status);
					jsObj.put("id", record.getId());
					
				} catch (Exception e) {
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "mysql", "编辑投入品使用信息信息失败！");
					logger.error("编辑投入品使用信息信息时数据库异常", e);
				}
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑投入品使用信息信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除投入品使用信息信息
	 * @param response
	 * @param request
	 * @param OriginInputsRecordId
	 */
	@RequestMapping("/deleteOriginInputsRecord")
	public void deleteOriginInputsRecord( HttpServletResponse response, HttpServletRequest request, Long inputsId ){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			OriginInputsRecord originInputsRecord = this.originInputsRecordService.selectByPrimaryKey(inputsId);
			if( originInputsRecord != null ){
				Date deleteTime = new Date();
				originInputsRecord.setDeleteUserId(la.getId());
				originInputsRecord.setIsDelete(1);
				originInputsRecord.setDeleteTime(deleteTime);
				
				InputsManager im = this.inputsManagerService.selectByPrimaryKey(originInputsRecord.getInputsId());
				if(originInputsRecord.getAmount()!=null&&originInputsRecord.getAmount()!=0D){
					im.setNum(im.getNum()+originInputsRecord.getAmount());
				}else{
					im.setNum(im.getNum()+originInputsRecord.getWeight());
				}
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				try{
					this.originInputsRecordService.updateByPrimaryKeySelective(originInputsRecord);
					this.inputsManagerService.updateByPrimaryKeySelective(im);
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "删除成功！");
				}catch( Exception e ){
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "param", "数据库异常！");
					logger.error("删除投入品使用信息时数据库异常", e);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除投入品使用信息信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	 /**
		 * 投入品使用信息信息导出
		 * @param request
		 * @param response
		 * @param record
		 */
	@RequestMapping("exportOriginInputsRecord")
	public void exportOriginInputsRecord(HttpServletRequest request,HttpServletResponse response,OriginInputsRecord record){
		OutputStream out=null;
		String exportName = "";
		try{
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			if( node != null && node.getType() != null ){
				if(node.getType() == Constants.TYPE_MEAT) {
					exportName = "breedInputsRecord"; //养殖
				}else {
					exportName = "plantInputsRecord"; //种植
				}
			}
			record.setIsDelete(0);
			List<OriginInputsRecord> listOriginInputsRecord = this.originInputsRecordService.selectByEntity(record);
			if(!listOriginInputsRecord.isEmpty()){
				ExcelManager<OriginInputsRecord> excelManager = new ExcelManager<OriginInputsRecord>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, exportName, listOriginInputsRecord, out);
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
	 
	 /**同步投入品使用信息到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param originInputsRecordId
	  */
	@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long inputsRecordId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<OriginInputsRecord> listOriginInputsRecord = new ArrayList<OriginInputsRecord>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sOriginInputs");
			if( inputsRecordId != null && !"".equals(inputsRecordId) ){//新增时同步
				OriginInputsRecord record = originInputsRecordService.selectByPrimaryKey(inputsRecordId);
				if( record != null ){
					listOriginInputsRecord.add(record);
				}
			}else{//一键同步
				OriginInputsRecord OriginInputsRecordR = new OriginInputsRecord();
				if( node != null ){
					OriginInputsRecordR.setNodeId(node.getId());
				}
				
				OriginInputsRecordR.setIsDelete(0);
				OriginInputsRecordR.setIsReport(Constants.REPORT_NO);
				
				listOriginInputsRecord = originInputsRecordService.selectByEntity(OriginInputsRecordR);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listOriginInputsRecord != null && listOriginInputsRecord.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( OriginInputsRecord record : listOriginInputsRecord ){
					
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
				logger.info("同步场投入品使用信息信息开始·····································································");
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
							//上报成功后更新OriginBatchInfo为已上报状态
							JSONObject Jo = JSONObject.parseObject(joStr);
							Integer size = Jo.getInteger("size");
							List<Long> idList = mapIds.get(size);
							if( idList != null && idList.size() > 0 ){
								Report report = new Report();
								report.setIsReport(Constants.REPORT_YES);
								report.setUpdateTime(now);
								report.setIdList(idList);
								report.setReportFlag(Constants.REPORT_FLAG_INPUTS);
								this.originBatchInfoService.batchUpdateIsReport(report);
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
				logger.error("同步场投入品使用信息信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步场投入品使用信息信息时发生异常", e);
		}
		if( response != null ){
			Util.writeObject(response, jsObj);
		}
	}
	
	/**
	 * 格式化OriginInputsRecord
	 * @param record
	 * @return
	 */
	public JSONObject formatObject( OriginInputsRecord record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		InputsManager inputsManager = this.inputsManagerService.selectByPrimaryKey(record.getInputsId());
		OriginPurchaseInputs op = new OriginPurchaseInputs();
		op.setNodeId(record.getNodeId());
		op.setpId(record.getInputsId());
		List<OriginPurchaseInputs> list = this.originPurchaseInputsService.selectByEntity(op);
		JSONObject job = new JSONObject();
		job.put("areaOriginId", node.getCode());
		job.put("areaOriginName", node.getName());
		job.put("prodBatchId", record.getProdBatchId());
		if(list!=null&&list.size()>0){
			job.put("purchaseBatchId", list.get(0).getPurchaseBatchId());
		}
		job.put("inputsId", inputsManager.getCode());
		job.put("inputsName", inputsManager.getName());
		job.put("categoryId", record.getType());
		job.put("usedDate", record.getUsedDate());
		job.put("dailyConsumption", record.getDailyConsumption());
		job.put("unit", record.getUnit());
		job.put("type", record.getInputsType());
		job.put("amount", record.getAmount());
		job.put("weight", record.getWeight());
		job.put("principalId", record.getPrincipalId());
		job.put("principalName", record.getPrincipalName());
		
		return job;
	}
	
}
