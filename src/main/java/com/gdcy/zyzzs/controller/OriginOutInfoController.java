package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.excel.ExcelManager;
import com.gdcy.zyzzs.pojo.Business;
import com.gdcy.zyzzs.pojo.Collect;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.OriginOutInfo;
import com.gdcy.zyzzs.pojo.PrintContent;
import com.gdcy.zyzzs.pojo.ProdManager;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.service.BusinessService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.OriginBatchInfoService;
import com.gdcy.zyzzs.service.OriginOutInfoService;
import com.gdcy.zyzzs.service.ProdManagerService;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.PropertiesUtil;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("originOutInfo/")
public class OriginOutInfoController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private OriginOutInfoService originOutInfoService;
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private ProdManagerService prodManagerService;
	
	@Resource
	private OriginBatchInfoService originBatchInfoService;
	
	@Resource
	private BusinessService businessService;

	/**
	 * 获取出场信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getOriginOutInfo")
	public void getOriginOutInfo(HttpServletRequest request, HttpServletResponse response,  OriginOutInfo record) {
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
			List<OriginOutInfo> list = originOutInfoService.selectByEntity(record);
			int total = originOutInfoService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取出场信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑出场信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editOriginOutInfo")
	public void editOriginOutInfo(HttpServletResponse response, HttpServletRequest request, OriginOutInfo record, String isPrint){
		JSONObject jsObj = new JSONObject();
		
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
			/*if( node == null ){
				return;
			}*/
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
					
					this.originOutInfoService.updateByPrimaryKeySelective(record);
					Util.setAjaxReturnSuccess(jsObj, "更新成功");
					
				}else{//新增
					record.setNodeId(node.getId());
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setType(node.getType());
					
					//追溯码自动生成 = 进场信息编码440900001+日期180119+交易流水号00001;
					String trandId = ""; 
					String nodeCode = node.getCode();
					String dateStr = sdf.format(now);
					String searchKey = nodeCode + dateStr;
					OriginOutInfo outInfoRecord = new OriginOutInfo();
					outInfoRecord.setNodeId(node.getId());
					outInfoRecord.setSearchKey(searchKey);
					outInfoRecord.setSearchFlag(1);
					List<OriginOutInfo> listTrade = this.originOutInfoService.selectByEntity(outInfoRecord);
					if( listTrade != null && listTrade.size() > 0 ){
						trandId = searchKey + String.format("%05d", Integer.parseInt(listTrade.get(0).getTraceCode().substring(15,20))+1);
					}else{
						trandId = searchKey + "00001";
					}
					
					record.setTraceCode(trandId);
					
					this.originOutInfoService.insertSelective(record);
					Util.setAjaxReturnSuccess(jsObj, "新增成功");

					jsObj.put("id", record.getId());
					
					//小票内容
					PrintContent printContent = null;
					if( isPrint!=null && !"".equals(isPrint) && isPrint.equals(Constants.PRINT_YES)){
						printContent = new PrintContent();
						printContent.setNodeName(node.getName());
						printContent.setOutDate(record.getOutDate());
						
				        DecimalFormat df=new DecimalFormat("#.00");
				        Collect collect = new Collect();
				        collect.setName(record.getProdName());
				        collect.setNum(Double.valueOf(df.format(record.getQty())).toString());
				        collect.setWeight(Double.valueOf(df.format(record.getWeight())).toString());
				        
				        List<Collect> collectList =  new ArrayList<Collect>();
				        collectList.add(collect);
				        printContent.setCollects(collectList);
				        printContent.setNum(String.valueOf(collectList.size()));
				        String codeContent = (String) PropertiesUtil.getProperty("codeContent", PropertiesUtil.PROP_CONSTANTS_FILE);
				        printContent.setCodeContent(codeContent+trandId);
				        printContent.setCode(trandId);
					}
			        
			        jsObj.put("printContent", printContent);
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑出场信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除出场信息
	 * @param response
	 * @param request
	 * @param OriginOutInfoId
	 */
	@RequestMapping("/deleteOriginOutInfo")
	public void deleteOriginOutInfo( HttpServletResponse response, HttpServletRequest request, Long outInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			OriginOutInfo originOutInfo = this.originOutInfoService.selectByPrimaryKey(outInfoId);
			if( originOutInfo != null ){
				Date deleteTime = new Date();
				originOutInfo.setDeleteUserId(la.getId());
				originOutInfo.setIsDelete(1);
				originOutInfo.setDeleteTime(deleteTime);
				this.originOutInfoService.updateByPrimaryKeySelective(originOutInfo);
				
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除出场信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}

	
	/**
		 * 出场信息导出
		 * @param request
		 * @param response
		 * @param record
		 */
	@RequestMapping("exportOriginOutInfo")
	public void exportOriginOutInfo(HttpServletRequest request,HttpServletResponse response,OriginOutInfo record){
		OutputStream out=null;
		String exportName = "";
		try{
			Node node = this.getNode(request);
			if( node != null && node.getId() != null ){
				record.setNodeId(node.getId());
			}
			if( node != null && node.getType() != null ){
				record.setType(node.getType());
				if(node.getType() == Constants.TYPE_MEAT) {
					exportName = "breedOutInfo"; //养殖
				}else {
					exportName = "plantOutInfo"; //种植
				}
			}
			record.setIsDelete(0);
			List<OriginOutInfo> listOriginOutInfo = this.originOutInfoService.selectByEntity(record);
			if(!listOriginOutInfo.isEmpty()){
				ExcelManager<OriginOutInfo> excelManager = new ExcelManager<OriginOutInfo>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, exportName, listOriginOutInfo, out);
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
	  * 补打小票
	  * @param response
	  * @param request
	  * @param tradeId
	  */
	 @RequestMapping("/getTicketContent")
	 public void getTicketContent( HttpServletResponse response, HttpServletRequest request, Long outInfoId ){
		 JSONObject jsObj = new JSONObject();
		 try {
			if( outInfoId != null ){
				Node node = this.getNode(request);
				OriginOutInfo record = this.originOutInfoService.selectByPrimaryKey(outInfoId);
				//小票内容
				PrintContent printContent  = new PrintContent();
				printContent.setNodeName(node.getName());
				printContent.setOutDate(record.getOutDate());
				
		        DecimalFormat df=new DecimalFormat("#.00");
		        Collect collect = new Collect();
		        collect.setName(record.getProdName());
		        collect.setNum(Double.valueOf(df.format(record.getQty())).toString());
		        collect.setWeight(Double.valueOf(df.format(record.getWeight())).toString());
		       
		        List<Collect> collectList =  new ArrayList<Collect>();
		        collectList.add(collect);
		        
		        printContent.setCollects(collectList);
		        printContent.setNum(String.valueOf(collectList.size()));
		        String codeContent = (String) PropertiesUtil.getProperty("codeContent", PropertiesUtil.PROP_CONSTANTS_FILE);
		        printContent.setCodeContent(codeContent+record.getTraceCode());
		        printContent.setCode(record.getTraceCode());
		        jsObj.put("printContent", printContent);
			}
			Util.setAjaxReturnSuccess(jsObj, "操作成功！");
		} catch (Exception e) {
			Util.setAjaxReturnError(jsObj, "system", "操作失败！");
			logger.error("补打小票时发生异常", e);
		}
		 Util.writeObject(response, jsObj);
	 }
	 
	 /**同步出场到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param OriginOutInfoId
	  */
	@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long outInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<OriginOutInfo> listOriginOutInfo = new ArrayList<OriginOutInfo>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sOriginOut");
			if( outInfoId != null && !"".equals(outInfoId) ){//新增时同步
				OriginOutInfo record = originOutInfoService.selectByPrimaryKey(outInfoId);
				if( record != null ){
					listOriginOutInfo.add(record);
				}
			}else{//一键同步
				OriginOutInfo OriginOutInfoR = new OriginOutInfo();
				if( node != null ){
					OriginOutInfoR.setNodeId(node.getId());
				}
				
				OriginOutInfoR.setIsDelete(0);
				OriginOutInfoR.setIsReport(Constants.REPORT_NO);
				
				listOriginOutInfo = originOutInfoService.selectByEntity(OriginOutInfoR);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listOriginOutInfo != null && listOriginOutInfo.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( OriginOutInfo record : listOriginOutInfo ){
					
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
				logger.info("同步场出场信息开始·····································································");
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
								report.setReportFlag(Constants.REPORT_FLAG_OUT);
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
				logger.error("同步场出场信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步场出场信息时发生异常", e);
		}
		if( response != null ){
			Util.writeObject(response, jsObj);
		}
	}
	
	/**
	 * 格式化OriginOutInfo
	 * @param record
	 * @return
	 */
	public JSONObject formatObject( OriginOutInfo record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		ProdManager prodManager = this.prodManagerService.selectByPrimaryKey(record.getProdId());
		Business business = null;
		if(record.getBuyerId()!=null){
			business = this.businessService.selectByPrimaryKey(record.getBuyerId());
		}
		
		JSONObject job = new JSONObject();
		job.put("areaOriginId", node.getCode());
		job.put("areaOriginName", node.getName());
		job.put("outDate", record.getOutDate());
		job.put("prodBatchId", record.getProdBatchId());
		job.put("harvestBatchId", record.getHarvestBatchId());
		job.put("categoryId", record.getType());
		job.put("goodsId", prodManager.getGoodsCode());
		job.put("goodsName", prodManager.getName());
		job.put("qty", record.getQty());
		job.put("weight", record.getWeight());
		job.put("price", record.getPrice());
		job.put("destCode", record.getDestCode());
		job.put("dest", record.getDest());
		job.put("transporterId", record.getTransporterId());
		job.put("quarantineId", record.getQuarantineId());
		job.put("traceCode", record.getTraceCode());
		job.put("logisticsCode", record.getLogisticsCode());
		if(business!=null){
			job.put("buyerId", business.getRegId());
		}
		job.put("buyerName", record.getBuyerName());
		
		return job;
	}
	
}
