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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.excel.ExcelManager;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.OriginHarvestInfo;
import com.gdcy.zyzzs.pojo.ProdManager;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.OriginBatchInfoService;
import com.gdcy.zyzzs.service.OriginHarvestInfoService;
import com.gdcy.zyzzs.service.ProdManagerService;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.PropertiesUtil;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("originHarvestInfo/")
public class OriginHarvestInfoController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private OriginHarvestInfoService originHarvestInfoService;
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private ProdManagerService prodManagerService;
	
	@Resource
	private OriginBatchInfoService originBatchInfoService;

	/**
	 * 获取收获信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getOriginHarvestInfo")
	public void getOriginHarvestInfo(HttpServletRequest request, HttpServletResponse response,  OriginHarvestInfo record) {
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
			List<OriginHarvestInfo> list = originHarvestInfoService.selectByEntity(record);
			int total = originHarvestInfoService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取收获信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑收获信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editOriginHarvestInfo")
	public void editOriginHarvestInfo(HttpServletResponse response, HttpServletRequest request, OriginHarvestInfo record){
		JSONObject jsObj = new JSONObject();
		
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
					
					this.originHarvestInfoService.updateByPrimaryKeySelective(record);
					Util.setAjaxReturnSuccess(jsObj, "更新成功");
					
				}else{//新增
					record.setNodeId(node.getId());
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setType(node.getType());
					
					//收获批次号自动生成 = 进场信息编码440900001+日期180119+交易流水号00001;
					String harvestBatchId = ""; 
					String nodeCode = node.getCode();
					String dateStr = sdf.format(now);
					String searchKey = nodeCode + dateStr;
					OriginHarvestInfo harvestInfoRecord = new OriginHarvestInfo();
					harvestInfoRecord.setNodeId(node.getId());
					harvestInfoRecord.setSearchKey(searchKey);
					harvestInfoRecord.setSearchFlag(1);
					List<OriginHarvestInfo> listHarvest = this.originHarvestInfoService.selectByEntity(harvestInfoRecord);
					if( listHarvest != null && listHarvest.size() > 0 ){
						harvestBatchId = searchKey + String.format("%05d", Integer.parseInt(listHarvest.get(0).getHarvestBatchId().substring(15,20))+1);
					}else{
						harvestBatchId = searchKey + "00001";
					}
					
					record.setHarvestBatchId(harvestBatchId);
					
					this.originHarvestInfoService.insertSelective(record);
					Util.setAjaxReturnSuccess(jsObj, "新增成功");

					jsObj.put("id", record.getId());
					
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑收获信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除收获信息
	 * @param response
	 * @param request
	 * @param harvestInfoId
	 */
	@RequestMapping("/deleteOriginHarvestInfo")
	public void deleteOriginHarvestInfo( HttpServletResponse response, HttpServletRequest request, Long harvestInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			OriginHarvestInfo originHarvestInfo = this.originHarvestInfoService.selectByPrimaryKey(harvestInfoId);
			if( originHarvestInfo != null ){
				Date deleteTime = new Date();
				originHarvestInfo.setDeleteUserId(la.getId());
				originHarvestInfo.setIsDelete(1);
				originHarvestInfo.setDeleteTime(deleteTime);
				this.originHarvestInfoService.updateByPrimaryKeySelective(originHarvestInfo);
				
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除收获信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}

	
	/**
		 * 收获信息导出
		 * @param request
		 * @param response
		 * @param record
		 */
	@RequestMapping("exportOriginHarvestInfo")
	public void exportOriginHarvestInfo(HttpServletRequest request,HttpServletResponse response,OriginHarvestInfo record){
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
					exportName = "breedHarvestInfo"; //养殖
				}else {
					exportName = "plantHarvestInfo"; //种植
				}
			}
			record.setIsDelete(0);
			List<OriginHarvestInfo> listOriginHarvestInfo = this.originHarvestInfoService.selectByEntity(record);
			if(!listOriginHarvestInfo.isEmpty()){
				ExcelManager<OriginHarvestInfo> excelManager = new ExcelManager<OriginHarvestInfo>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, exportName, listOriginHarvestInfo, out);
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
	
	 /**同步收获到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param harvestInfoId
	  */
	@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long harvestInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<OriginHarvestInfo> listOriginHarvestInfo = new ArrayList<OriginHarvestInfo>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sOriginHarvestInfo");
			if( harvestInfoId != null && !"".equals(harvestInfoId) ){//新增时同步
				OriginHarvestInfo record = originHarvestInfoService.selectByPrimaryKey(harvestInfoId);
				if( record != null ){
					listOriginHarvestInfo.add(record);
				}
			}else{//一键同步
				OriginHarvestInfo originHarvestInfo = new OriginHarvestInfo();
				if( node != null ){
					originHarvestInfo.setNodeId(node.getId());
				}
				
				originHarvestInfo.setIsDelete(0);
				originHarvestInfo.setIsReport(Constants.REPORT_NO);
				
				listOriginHarvestInfo = originHarvestInfoService.selectByEntity(originHarvestInfo);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listOriginHarvestInfo != null && listOriginHarvestInfo.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( OriginHarvestInfo record : listOriginHarvestInfo ){
					
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
				logger.info("同步场收获信息开始·····································································");
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
								report.setReportFlag(Constants.REPORT_FLAG_HARVEST);
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
				logger.error("同步收获信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步收获信息时发生异常", e);
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
	public JSONObject formatObject( OriginHarvestInfo record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		ProdManager prodManager = this.prodManagerService.selectByPrimaryKey(record.getProdId());
		JSONObject job = new JSONObject();
		job.put("areaOriginId", node.getCode());
		job.put("areaOriginName", node.getName());
		job.put("prodBatchId", record.getProdBatchId());
		job.put("harvestBatchId", record.getHarvestBatchId());
		job.put("harvestDate", record.getHarvestDate());
		job.put("categoryId", record.getType());
		job.put("amount", record.getAmount());
		job.put("weight", record.getWeight());
		job.put("unit", record.getUnit());
		job.put("goodsId", prodManager.getGoodsCode());
		job.put("goodsName", prodManager.getGoodsName());
		job.put("result", record.getResult());
		job.put("sheetNo", record.getSheetNo());
		job.put("principalId", record.getPrincipalId());
		job.put("principalName", record.getPrincipalName());
		
		return job;
	}
	
}
