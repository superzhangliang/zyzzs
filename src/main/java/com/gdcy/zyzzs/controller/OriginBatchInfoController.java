package com.gdcy.zyzzs.controller;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

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
import com.gdcy.zyzzs.pojo.OriginBatchInfo;
import com.gdcy.zyzzs.pojo.ProdManager;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.pojo.StatisticObject;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.OriginBatchInfoService;
import com.gdcy.zyzzs.service.ProdManagerService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.PropertiesUtil;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("originBatchInfo/")
public class OriginBatchInfoController extends BaseController {
	Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private OriginBatchInfoService originBatchInfoService;
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private ProdManagerService prodManagerService;
	
	/**
	 * 获取批次信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getOriginBatchInfo")
	public void getOriginBatchInfo(HttpServletRequest request, HttpServletResponse response,  OriginBatchInfo record) {
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
			List<OriginBatchInfo> list = originBatchInfoService.selectByEntity(record);
			int total = originBatchInfoService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取批次信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 自动生成批次批次号
	 * @param request
	 * @return
	 */
	private String autoCreateProdBatchId( HttpServletRequest request ){
		//批次批次号自动生成 = 批次信息编码440900001+日期180119+交易流水号00001;
		Node node = this.getNode(request);
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String prodBatchId = ""; 
		String nodeCode = node.getCode();
		String dateStr = sdf.format(now);
		String searchKey = nodeCode + dateStr;
		OriginBatchInfo originBatchInfo = new OriginBatchInfo();
		originBatchInfo.setNodeId(node.getId());
		originBatchInfo.setSearchKey(searchKey);
		originBatchInfo.setSearchFlag(1);
		List<OriginBatchInfo> listEntry = this.originBatchInfoService.selectByEntity(originBatchInfo);
		if( listEntry != null && listEntry.size() > 0 ){
			prodBatchId = searchKey + String.format("%05d", Integer.parseInt(listEntry.get(0).getProdBatchId().substring(15,20))+1);
		}else{
			prodBatchId = searchKey + "00001";
		}
		return prodBatchId;
	}
	
	/**
	 * 编辑批次信息
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editOriginBatchInfo")
	public void editOriginBatchInfo(HttpServletResponse response, HttpServletRequest request, OriginBatchInfo record){
		JSONObject jsObj = new JSONObject();
		
		try{
			LoginAccount la = this.getCurrentUser(request);
			Node node = this.getNode(request);
			Date now = new Date();
			/*if( node == null ){
				return;
			}*/
		
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateUserId(la.getId());
					record.setUpdateTime(now);
					
				}else{//新增
					record.setNodeId(node.getId());
					record.setAddUserId(la.getId());
					record.setAddTime(now);
					record.setIsDelete(0);
					record.setType(node.getType());
					
					//进货批次号自动生成
					String prodBatchId = autoCreateProdBatchId(request);
					record.setProdBatchId(prodBatchId);
				}
				
				//事务控制
				DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try {
					if( record.getId() != null && !"".equals(record.getId()) ){
						this.originBatchInfoService.updateByPrimaryKeySelective(record);
					}else{
						this.originBatchInfoService.insertSelective(record);
					}
					
					txManager.commit(status);
					jsObj.put("id", record.getId());
					Util.setAjaxReturnSuccess(jsObj, "操作成功!");
				} catch (Exception e) {
					txManager.rollback(status);
					Util.setAjaxReturnError(jsObj, "mysql", "编辑批次信息失败！");
					logger.error("编辑批次信息时数据库异常", e);
				}
			}else{
				Util.setAjaxReturnError(jsObj, "parameter", "参数异常");
			}
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑批次信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除批次信息
	 * @param response
	 * @param request
	 * @param OriginBatchInfoId
	 */
	@RequestMapping("/deleteOriginBatchInfo")
	public void deleteOriginBatchInfo( HttpServletResponse response, HttpServletRequest request, Long batchInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			LoginAccount la = this.getCurrentUser(request);
			OriginBatchInfo OriginBatchInfo = this.originBatchInfoService.selectByPrimaryKey(batchInfoId);
			if( OriginBatchInfo != null ){
				Date deleteTime = new Date();
				OriginBatchInfo.setDeleteUserId(la.getId());
				OriginBatchInfo.setIsDelete(1);
				OriginBatchInfo.setDeleteTime(deleteTime);
				this.originBatchInfoService.updateByPrimaryKeySelective(OriginBatchInfo);
				
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除批次信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
   /**
	* 批次信息导出
	* @param request
	* @param response
	* @param record
	*/
	@RequestMapping("exportOriginBatchInfo")
	public void exportOriginBatchInfo(HttpServletRequest request,HttpServletResponse response,OriginBatchInfo record){
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
					exportName = "breedBatchInfo"; //养殖
				}else {
					exportName = "plantBatchInfo"; //种植
				}
			}
			
			record.setIsDelete(0);
			List<OriginBatchInfo> listOriginBatchInfo = this.originBatchInfoService.selectByEntity(record);
			if(!listOriginBatchInfo.isEmpty()){
				ExcelManager<OriginBatchInfo> excelManager = new ExcelManager<OriginBatchInfo>();
				response.setContentType("application/msexcel");
				response.setHeader("content-disposition", "attachment;filename="
				+ System.currentTimeMillis() + ".xls");
				out = response.getOutputStream();
				excelManager.exportToExcel(request, exportName, listOriginBatchInfo, out);
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
	 
	 /**同步批次到溯源系统
	  * 
	  * @param response
	  * @param request
	  * @param OriginBatchInfoId
	  */
	@RequestMapping("/synToSY")
	public void synToSY( HttpServletResponse response, HttpServletRequest request, Long batchInfoId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = request == null ? null : this.getNode(request);
			List<OriginBatchInfo> listOriginBatchInfo = new ArrayList<OriginBatchInfo>();
			JSONObject jo = new JSONObject();
			jo.put("method", "sOriginBatch");
			if( batchInfoId != null && !"".equals(batchInfoId) ){//新增时同步
				OriginBatchInfo record = originBatchInfoService.selectByPrimaryKey(batchInfoId);
				if( record != null ){
					listOriginBatchInfo.add(record);
				}
			}else{//一键同步
				OriginBatchInfo OriginBatchInfo = new OriginBatchInfo();
				if( node != null ){
					OriginBatchInfo.setNodeId(node.getId());
				}
				
				OriginBatchInfo.setIsDelete(0);
				OriginBatchInfo.setIsReport(Constants.REPORT_NO);
				
				listOriginBatchInfo = originBatchInfoService.selectByEntity(OriginBatchInfo);
			}
			
			Map<Integer, List<JSONObject>> map = new HashMap<Integer, List<JSONObject>>();
			Map<Integer, List<Long>> mapIds = new HashMap<Integer, List<Long>>();
			if( listOriginBatchInfo != null && listOriginBatchInfo.size() > 0 ){
				List<JSONObject> listT = new ArrayList<JSONObject>();
				List<Long> listIds = new ArrayList<Long>();
				Integer maxReportNum = Integer.parseInt(((String) PropertiesUtil.getProperty("maxReportNum", PropertiesUtil.PROP_CONSTANTS_FILE)));
				for( OriginBatchInfo record : listOriginBatchInfo ){
					
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
							//上报成功后更新OriginBatchInfo为已上报状态
							JSONObject Jo = JSONObject.parseObject(joStr);
							Integer size = Jo.getInteger("size");
							List<Long> idList = mapIds.get(size);
							if( idList != null && idList.size() > 0 ){
								Report report = new Report();
								report.setIsReport(Constants.REPORT_YES);
								report.setUpdateTime(now);
								report.setIdList(idList);
								report.setReportFlag(Constants.REPORT_FLAG_BATCH);
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
				logger.error("同步场批次信息时发生异常", e);
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "同步失败！");
			logger.error("同步场批次信息时发生异常", e);
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
	public JSONObject formatObject( OriginBatchInfo record ){
		Node node = this.nodeService.selectByPrimaryKey(record.getNodeId());
		ProdManager prodManager = this.prodManagerService.selectByPrimaryKey(record.getProdId());
		
		JSONObject job = new JSONObject();
		job.put("areaOriginId", node.getCode());
		job.put("areaOriginName", node.getName());
		job.put("prodStartDate", record.getProdStartDate());
		job.put("acreage", record.getAcreage());
		job.put("qty", record.getQty());
		job.put("categoryId", record.getType());
		job.put("goodsId", prodManager.getGoodsCode());
		job.put("goodsName", prodManager.getGoodsName());
		job.put("prodBatchId", record.getProdBatchId());
		job.put("unit", record.getUnit());
		job.put("principalId", record.getPrincipalId());
		job.put("principalName", record.getPrincipalName());
		
		return job;
	}
	
	
	/**
	 * 产品/投入品统计
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("goodsStatic")
	public void goodsStatic(HttpServletRequest request, HttpServletResponse response,  StatisticObject record) {
		JSONObject returnObj = new JSONObject();
		try {
			List<Object> list = null;
			int total = 0;
			
			List<String> listGoods = new ArrayList<String>();
			List<String> listDate = new ArrayList<String>();
			// 日期 集合
			Set<String> dateSet = new TreeSet<String>();
			List<JSONObject> listData = new ArrayList<JSONObject>();
			
			Node node = this.getNode(request);
			record.setNodeId(node.getId());
			if( record.getShowWay() != null && !"".equals(record.getShowWay()) ){
				if( record.getShowWay().equals("table") ){//初始加载成表格形式-表格只存放商品、投入品
					list = this.originBatchInfoService.staticAllGoods(record);
					if(list.size()>0){
						if(list.get(0)==null){
							list= new ArrayList<Object>();
						}
					}
					record.setLimit(null);
					record.setOffset(null);
					if(list!=null){
						List<Object> listTotal = this.originBatchInfoService.staticAllGoods(record);
						total = listTotal != null ? listTotal.size() : 0;
					}
					returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
					returnObj.put("total", total);
				}else{//线形图展示商品、投入品对应 天的统计情况
					
					List<String> listProdId = new ArrayList<String>();
					String[] prodIdArr = record.getProdIds().split(",");
					//需要统计的产品
					if( prodIdArr != null && prodIdArr.length > 0 ){
						for( String prodId : prodIdArr ){
							if( !"".equals(prodId) ){
								listProdId.add(prodId);
							}
						}
						record.setBankList1(listProdId);
					}
					list = this.originBatchInfoService.staticAllGoods(record);
					if(list.size()>0){
						if(list.get(0)==null){
							list = new ArrayList<Object>();
						}
					}
					
					if( list != null && list.size() > 0 ){
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						
						if( record.getHtmlEndDate() == null || "".equals( record.getHtmlEndDate() )){
							record.setHtmlEndDate(sdf.format(new Date()));
						}
						if( record.getHtmlStartDate() == null || "".equals( record.getHtmlStartDate() )){
							Calendar c = Calendar.getInstance();
					        c.setTime(sdf.parse(record.getHtmlEndDate()));
					        c.add(Calendar.DAY_OF_MONTH, -6);
					        record.setHtmlStartDate(sdf.format(c.getTime()));
						}
						
						Date startDate = sdf.parse(record.getHtmlStartDate());
						Date endDate = sdf.parse(record.getHtmlEndDate());
						if( startDate.after(endDate) ){
							endDate = startDate;
						}
						while( startDate.before(endDate) || startDate.equals(endDate) ){
							dateSet.add(sdf.format(startDate));
							Calendar c = Calendar.getInstance();
					        c.setTime(startDate);
					        c.add(Calendar.DAY_OF_MONTH, 1);
					        startDate = c.getTime();
						}
						
						Map<String, JSONObject> mapData = new HashMap<String, JSONObject>();
						//遍历list
						for( Object obj : list ){
							JSONObject jo = JSONObject.parseObject(JSON.toJSONString(obj));
							String goodsCode = jo.getString("goodsCode");
							String goodsName = jo.getString("goodsName");
							String date = jo.getString("date");
							Double amount = jo.getDouble("amount");
							
							JSONObject jos = null;
							JSONArray listAmount = null;
							
							//商品/投入品-amount的map
							if( mapData.containsKey(goodsCode)){
								jos = mapData.get(goodsCode);
								listAmount = jos.getJSONArray("datas");
								
								JSONObject joss = new JSONObject();
								joss.put("date", date);
								joss.put("amount", amount);
								listAmount.add(joss);
								
							}else{
								listGoods.add(goodsName);
								
								jos = new JSONObject();
								listAmount = new JSONArray();
								JSONObject joss = new JSONObject();
								joss.put("date", date);
								joss.put("amount", amount);
								listAmount.add(joss);
								
								jos.put("name", goodsName);
								jos.put("type", "line");
								jos.put("datas", listAmount);
							}
							mapData.put(goodsCode, jos);
						}
						
						//将日对应的amount拼接起来
						for( String goodsCode : mapData.keySet() ){
							JSONObject jo = mapData.get(goodsCode);
							JSONArray listAmount = jo.getJSONArray("datas");
							Map<String, Double> mapAmount = new HashMap<String, Double>();
							for( Object obj : listAmount ){
								JSONObject jos = JSONObject.parseObject(JSON.toJSONString(obj));
								mapAmount.put(jos.getString("date"), jos.getDouble("amount"));
							}
							
							List<Double> listA = new ArrayList<Double>();
							for( String date : dateSet ){
								if( mapAmount.containsKey(date) ){
									listA.add(mapAmount.get(date));
								}else{
									listA.add(0D);
								}
								listDate.add(date);
							}
							jo.put("data", listA);
							
							listData.add(jo);
						}
						
						returnObj.put("listGoods", JSONArray.parseArray(JSON.toJSONString(listGoods)));
						returnObj.put("listDate", JSONArray.parseArray(JSON.toJSONString(dateSet)));
						returnObj.put("listData", JSONArray.parseArray(JSON.toJSONString(listData)));
					}
				}
			}
			
		} catch (Exception e) {
			logger.error("统计商品种植面积/养殖数量或投入品使用量或商品交易量时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
}
