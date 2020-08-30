package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
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
import com.gdcy.zyzzs.pojo.Business;
import com.gdcy.zyzzs.pojo.InputsManager;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.OriginPurchaseInputs;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.service.BusinessService;
import com.gdcy.zyzzs.service.InputsManagerService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.OriginBatchInfoService;
import com.gdcy.zyzzs.service.ProdManagerService;
import com.gdcy.zyzzs.service.OriginPurchaseInputsService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.PropertiesUtil;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("originPurchaseInputs/")
public class OriginPurchaseInputsController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private OriginBatchInfoService originBatchInfoService;
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private ProdManagerService prodManagerService;
	
	@Resource
	private OriginPurchaseInputsService originPurchaseInputsService;
	
	@Resource
	private InputsManagerService inputsManagerService;
	
	@Resource
	private BusinessService businessService;
	
	/**
	 * 获取采购信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getOriginPurchaseInputs")
	public void getOriginPurchaseInputs(HttpServletRequest request, HttpServletResponse response,  OriginPurchaseInputs record) {
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
			List<OriginPurchaseInputs> list = originPurchaseInputsService.selectByEntity(record);
			int total = originPurchaseInputsService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取采购信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 自动生成采购批次号
	 * @param request
	 * @return
	 */
	private String autoCreatePurchaseBatchId( HttpServletRequest request ){
		//采购批次号自动生成 = 批次信息编码440900001+日期180119+交易流水号00001;
		Node node = this.getNode(request);
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String purchaseBatchId = ""; 
		String nodeCode = node.getCode();
		String dateStr = sdf.format(now);
		String searchKey = nodeCode + dateStr;
		OriginPurchaseInputs purchaseInputs = new OriginPurchaseInputs();
		purchaseInputs.setNodeId(node.getId());
		purchaseInputs.setSearchKey(searchKey);
		purchaseInputs.setSearchFlag(1);
		List<OriginPurchaseInputs> listEntry = this.originPurchaseInputsService.selectByEntity(purchaseInputs);
		if( listEntry != null && listEntry.size() > 0 ){
			purchaseBatchId = searchKey + String.format("%05d", Integer.parseInt(listEntry.get(0).getPurchaseBatchId().substring(15,20))+1);
		}else{
			purchaseBatchId = searchKey + "00001";
		}
		return purchaseBatchId;
	}
	
	/**
	 * 编辑采购信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editOriginPurchaseInputs")
	public void editOriginPurchaseInputs(HttpServletResponse response, HttpServletRequest request, OriginPurchaseInputs record){
		JSONObject jsObj = new JSONObject();
		
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			Double oldNum=0D;
			Double newNum=0D;
			InputsManager oldIm = null;
			InputsManager newIm = this.inputsManagerService.selectByPrimaryKey(record.getpId());
			
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
					
					OriginPurchaseInputs oldPi = this.originPurchaseInputsService.selectByPrimaryKey(record.getId());
					oldIm = this.inputsManagerService.selectByPrimaryKey(oldPi.getpId());
					if(record.getpId().longValue()==oldPi.getpId().longValue()){
						//修改采购信息时未修改投入品，此时投入品的库存应该先减去旧的num，然后再加上新的num
						
						//修改采购数量/采购重量单选框时
						Double oldPiNum = 0D;
						if( oldPi.getPurchaseAmount()!= null && oldPi.getPurchaseAmount() != 0D ){
							oldPiNum = oldPi.getPurchaseAmount();
						}else if( oldPi.getTotalWeight()!=null && oldPi.getTotalWeight() != 0D ){
							oldPiNum = oldPi.getTotalWeight();
						}
						if( record.getPurchaseAmount() != null && record.getPurchaseAmount() != 0D ){
							record.setTotalWeight(0D);
							oldNum = oldIm.getNum() - oldPiNum + record.getPurchaseAmount();
						}else if( record.getTotalWeight() !=null && record.getTotalWeight() != 0D ){
							record.setPurchaseAmount(0D);
							oldNum = oldIm.getNum() - oldPiNum + record.getTotalWeight();
						}
						
					}else{
						//若修改了投入品，则要先给旧投入库存减num，然后再给新的投入品库存加num
						if(oldPi.getPurchaseAmount()!= null && oldPi.getPurchaseAmount() != 0D ){
							oldNum = oldIm.getNum() - oldPi.getPurchaseAmount();
						}else{
							oldNum = oldIm.getNum() - oldPi.getTotalWeight();
						}
						if(record.getPurchaseAmount()!= null && record.getPurchaseAmount() != 0D ){
							record.setTotalWeight(0D);
							newNum = newIm.getNum() + record.getPurchaseAmount();
						}else{
							record.setPurchaseAmount(0D);
							newNum = newIm.getNum() + record.getTotalWeight();
						}
						
						newIm.setNum(newNum);
						newIm.setUpdateTime(now);
						newIm.setUpdateUserId(la.getId());
					}
					
					oldIm.setNum(oldNum);
					oldIm.setUpdateTime(now);
					oldIm.setUpdateUserId(la.getId());
				}else{//新增
					record.setNodeId(node.getId());
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setIsDelete(0);
					record.setType(node.getType());
					
					//采购批次号自动生成
					String purchaseBatchId = autoCreatePurchaseBatchId(request);
					record.setPurchaseBatchId(purchaseBatchId);
					
					if( record.getPurchaseAmount() != null && record.getPurchaseAmount() != 0D ){
						newNum = newIm.getNum() + record.getPurchaseAmount();
					}else if( record.getTotalWeight() != null && record.getTotalWeight() != 0D ){
						newNum = newIm.getNum() + record.getTotalWeight();
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
						this.originPurchaseInputsService.updateByPrimaryKeySelective(record);
						this.inputsManagerService.updateByPrimaryKeySelective(oldIm);
						if(newIm.getId().longValue()!=oldIm.getId().longValue()){
							this.inputsManagerService.updateByPrimaryKeySelective(newIm);
						}
					}else{
						this.originPurchaseInputsService.insertSelective(record);
						this.inputsManagerService.updateByPrimaryKeySelective(newIm);
					}
					
					txManager.commit(status);
					jsObj.put("id", record.getId());
					Util.setAjaxReturnSuccess(jsObj, "操作成功!");
				} catch (Exception e) {
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "mysql", "编辑采购信息失败！");
					logger.error("编辑采购信息时数据库异常", e);
				}
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑采购信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除采购信息
	 * @param response
	 * @param request
	 * @param purchaseInputsId
	 */
	@RequestMapping("/deleteOriginPurchaseInputs")
	public void deleteOriginBatchInfo( HttpServletResponse response, HttpServletRequest request, Long purchaseInputsId ){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			Date now = new Date();
			OriginPurchaseInputs purchaseInputs = this.originPurchaseInputsService.selectByPrimaryKey(purchaseInputsId);
			if( purchaseInputs != null ){
				purchaseInputs.setDeleteUserId(la.getId());
				purchaseInputs.setIsDelete(1);
				purchaseInputs.setDeleteTime(now);
				
				InputsManager im = this.inputsManagerService.selectByPrimaryKey(purchaseInputs.getpId());
				if(purchaseInputs.getPurchaseAmount()!=null&&purchaseInputs.getPurchaseAmount()!=0D){
					im.setNum(im.getNum()-purchaseInputs.getPurchaseAmount());
				}else{
					im.setNum(im.getNum()-purchaseInputs.getTotalWeight());
				}
				
				im.setUpdateTime(now);
				im.setUpdateUserId(la.getId());
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				try{
					this.originPurchaseInputsService.updateByPrimaryKeySelective(purchaseInputs);
					this.inputsManagerService.updateByPrimaryKeySelective(im);
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "删除成功！");
				}catch( Exception e ){
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "param", "数据库异常！");
					logger.error("删除采购信息时数据库异常", e);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除采购信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
   /**
	* 采购信息导出
	* @param request
	* @param response
	* @param record
	*/
	@RequestMapping("exportOriginPurchaseInputs")
	public void exportOriginBatchInfo(HttpServletRequest request,HttpServletResponse response,OriginPurchaseInputs record){
		OutputStream out=null;
		String exportName = "purchaseInputs";
		try{
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			
			record.setIsDelete(0);
			List<OriginPurchaseInputs> listOriginOriginPurchaseInputs = this.originPurchaseInputsService.selectByEntity(record);
			if(!listOriginOriginPurchaseInputs.isEmpty()){
				ExcelManager<OriginPurchaseInputs> excelManager = new ExcelManager<OriginPurchaseInputs>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, exportName, listOriginOriginPurchaseInputs, out);
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
	 
	 /**同步采购信息到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param OriginBatchInfoId
	  */
	@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long purchaseInputsId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<OriginPurchaseInputs> listOriginPurchaseInputs = new ArrayList<OriginPurchaseInputs>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sOriginPurchaseInputs");
			if( purchaseInputsId != null && !"".equals(purchaseInputsId) ){//新增时同步
				OriginPurchaseInputs record = originPurchaseInputsService.selectByPrimaryKey(purchaseInputsId);
				if( record != null ){
					listOriginPurchaseInputs.add(record);
				}
			}else{//一键同步
				OriginPurchaseInputs originPurchaseInputs = new OriginPurchaseInputs();
				if( node != null ){
					originPurchaseInputs.setNodeId(node.getId());
				}
				
				originPurchaseInputs.setIsDelete(0);
				originPurchaseInputs.setIsReport(Constants.REPORT_NO);
				
				listOriginPurchaseInputs = originPurchaseInputsService.selectByEntity(originPurchaseInputs);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listOriginPurchaseInputs != null && listOriginPurchaseInputs.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( OriginPurchaseInputs record : listOriginPurchaseInputs ){
					
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
				logger.info("同步场批次信息开始·····································································");
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
							//上报成功后更新OriginPurchaseInputs为已上报状态
							JSONObject Jo = JSONObject.parseObject(joStr);
							Integer size = Jo.getInteger("size");
							List<Long> idList = mapIds.get(size);
							if( idList != null && idList.size() > 0 ){
								Report report = new Report();
								report.setIsReport(Constants.REPORT_YES);
								report.setUpdateTime(now);
								report.setIdList(idList);
								report.setReportFlag(Constants.REPORT_FLAG_PURCHASE);
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
				logger.error("同步采购信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步采购信息时发生异常", e);
		}
		if( response != null ){
			Util.writeObject(response, jsObj);
		}
	}
	
	/**
	 * 格式化OriginBatchInfo
	 * @param record
	 * @return
	 */
	public JSONObject formatObject( OriginPurchaseInputs record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		InputsManager inputsManager = this.inputsManagerService.selectByPrimaryKey(record.getpId());
		Business business = this.businessService.selectByPrimaryKey(record.getSupplierId());
		
		JSONObject job = new JSONObject();
		job.put("areaOriginId", node.getCode());
		job.put("areaOriginName", node.getName());
		job.put("categoryId", record.getType());
		job.put("goodsId", inputsManager.getCode());
		job.put("goodsName", inputsManager.getName());
		job.put("purchaseType", record.getPurchaseType());
		job.put("sourceType", record.getSourceType());
		job.put("upperReaches", record.getUpperReaches());
		job.put("purchaseBatchId", record.getPurchaseBatchId());
		job.put("purchaseDate", record.getPurchaseDate());
		job.put("organicFlag", record.getOrganicFlag());
		job.put("transgenicFlag", record.getTransgenicFlag());
		job.put("principalId", record.getPrincipalId());
		job.put("principalName", record.getPrincipalName());
		job.put("amount", record.getPurchaseAmount());
		job.put("price", record.getPurchasePrice());
		job.put("unit", record.getPurchaseUnit());
		job.put("weight", record.getTotalWeight());
		job.put("manufacturerDate", record.getManufacturerDate());
		job.put("result", record.getResult());
		job.put("periodDate", record.getPeriodDate());
		job.put("manufacturerId", record.getManufacturerDate());
		job.put("manufacturerName", record.getManufacturerName());
		job.put("license", record.getLicense());
		job.put("supplierId", business.getRegId());
		job.put("supplierName", record.getSupplierName());

		
		return job;
	}
	
}
