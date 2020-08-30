package com.gdcy.zyzzs.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.GoodsInfo;
import com.gdcy.zyzzs.service.GoodsInfoService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("goodsInfo/")
public class GoodsController {
	private Logger logger = Logger.getLogger(this.getClass());
    
	@Resource
	private GoodsInfoService goodsInfoService;

	/***
	 * 展示商品
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("showGoods")
	public void showGoods( HttpServletResponse response, HttpServletRequest request ) {
		JSONArray jsarry = new JSONArray();
		try{
			GoodsInfo goodsInfoRecord = new GoodsInfo();
			List<GoodsInfo> allgoodsInfo = this.goodsInfoService.selectByEntity(goodsInfoRecord);
			for (GoodsInfo goodsInfo : allgoodsInfo) {
				JSONObject jo = new JSONObject();
				jo.put("id", goodsInfo.getId());
				jo.put("pId", goodsInfo.getPid());
				jo.put("name", goodsInfo.getGoodsName());
				jo.put("goodsName", goodsInfo.getGoodsName());
				jo.put("goodsCode", goodsInfo.getGoodsCode());
				jo.put("parentId", goodsInfo.getPid());
				jsarry.add(jo);
			}
			
		}catch( Exception e ){
			logger.error("显示商品时异常", e);
		}
		Util.writeObject(response, jsarry);
	}
	
	 /**
	 * 新增、修改商品
	 * @param response
	 * @param request
	 * @param goodsInfo 待更新商品实体
	 */
	@RequestMapping("editGoodsInfo")
	public void editGoodsInfo( HttpServletResponse response, HttpServletRequest request, GoodsInfo goodsInfo ){
		JSONObject jsObj = new JSONObject();
		try{
			GoodsInfo goodsInfoRecord = new GoodsInfo();
			goodsInfoRecord.setPid(goodsInfo.getPid());
			if( !goodsInfo.getOp().equals(3) ){
				//新增
				this.goodsInfoService.insertSelective(goodsInfo);
			}else{
				//修改
				this.goodsInfoService.updateByPrimaryKeySelective(goodsInfo);
			}
			Util.setAjaxReturnSuccess(jsObj, "操作成功");
		}catch(Exception e){
			logger.error("更新商品时异常", e);
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 删除商品
	 * @param response
	 * @param request
	 * @param id 待删除商品ID
	 */
	@RequestMapping("/delGoodsInfo")
	public void delGoodsInfo( HttpServletResponse response, HttpServletRequest request, Long id){
		JSONObject jsObj = new JSONObject();
		try{
			GoodsInfo goodsInfo = this.goodsInfoService.selectByPrimaryKey(id);
			List<Long> goodsInfonodes = new ArrayList<Long>();
			getSubGoodsByPid( goodsInfonodes, goodsInfo.getId() );
			goodsInfonodes.add(goodsInfo.getId());
			
			//事务控制
			DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			TransactionStatus status = txManager.getTransaction(def);
			
			try{
				if( goodsInfonodes != null && goodsInfonodes.size() > 0 ){
					for( Long dId : goodsInfonodes ){
						this.goodsInfoService.deleteByPrimaryKey(dId);
					}
				}
				txManager.commit(status);
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}catch( Exception e ){
				txManager.rollback(status);
				logger.error("删除商品时数据库异常", e);
				Util.setAjaxReturnError(jsObj, "system", "事务提交异常");
			}
		}catch(Exception e){
			logger.error("删除商品时异常", e);
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
		}
		
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 获取所有下级商品
	 * @param allGoodsList
	 * @param pId
	 */
	private void getSubGoodsByPid(List<Long> allGoodsList, Long pId) {
		if (allGoodsList != null && pId != null ) {
			GoodsInfo goodsInfoRecord = new GoodsInfo();
			goodsInfoRecord.setPid(pId);
			List<GoodsInfo> subList = this.goodsInfoService.selectByEntity(goodsInfoRecord);
			if (subList != null && subList.size() > 0) {
				Long areaId = null;
				for (GoodsInfo goodsInfo : subList) {
					areaId = goodsInfo.getId();
					allGoodsList.add(areaId);
					getSubGoodsByPid(allGoodsList, areaId);
				}
			}else{
				return;
			}
		}
	}
	
	/**
	 * 获取商品树
	 * @param response
	 * @param request
	 * @param name
	 */
	@RequestMapping("getGoodsTree")
	public void getGoodsTree( HttpServletResponse response, HttpServletRequest request, String name ) {
		JSONObject returnObj = new JSONObject();
		JSONArray jsarry = new JSONArray();
		try{
			GoodsInfo record = new GoodsInfo();
			record.setGoodsName(URLDecoder.decode(name, "UTF-8"));
			List<GoodsInfo> list = this.goodsInfoService.selectByEntity(record);
			Map<Long, List<GoodsInfo>> map = null;
			if( list != null && list.size() > 0 ){
				map = new HashMap<Long, List<GoodsInfo>>();
				for( GoodsInfo goods : list ){
					if( map.containsKey(goods.getPid()) ){
						map.get(goods.getPid()).add(goods);
					}else{
						List<GoodsInfo> listGI = new ArrayList<GoodsInfo>();
						listGI.add(goods);
						map.put(goods.getPid(), listGI);
					}
				}
			}
			
			if( map != null && map.size() > 0 ){
				Long pId = 0L;
				for( Long pid : map.keySet() ){
					pId = pid;
					break;
				}
				List<GoodsInfo> listPId = map.get(pId);
				if( listPId != null && listPId.size() > 0 ){
					for( GoodsInfo gi : listPId ){
						JSONObject jo = new JSONObject();
						jo.put("id", gi.getId());
						jo.put("code", gi.getGoodsCode());
						jo.put("name", gi.getGoodsName());
						jo.put("searchName", name);
						
						getChildGoods( jo, map );
						jsarry.add(jo);
					}
				}
			}
			
			returnObj.put("rows", jsarry);
		}catch( Exception e ){
			logger.error("显示商品时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	private void getChildGoods( JSONObject joT, Map<Long, List<GoodsInfo>> map ){
		JSONArray jsarry = new JSONArray();
		List<GoodsInfo> list = map.get(joT.getLong("id"));
		boolean isLeaf = false;
		if( list != null && list.size() > 0 ){
			for( GoodsInfo gi : list ){
				JSONObject jo = new JSONObject();
				jo.put("id", gi.getId());
				jo.put("code", gi.getGoodsCode());
				jo.put("name", gi.getGoodsName());
				jo.put("searchName", joT.getString("searchName"));
				
				getChildGoods( jo, map );
				jsarry.add(jo);
			}
			isLeaf = true;
		}
		joT.put("children", jsarry);
		joT.put("isLeaf", isLeaf);
	}
	
}
