package com.gdcy.zyzzs.controller;

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

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.Menu;
import com.gdcy.zyzzs.service.MenuService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("sysMenu/")
public class MenuController {
	private Logger logger = Logger.getLogger(this.getClass());
    
	@Resource
	private MenuService menuService;

	/***
	 * 展示菜单
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("showMenu")
	public void showAgentMenu( HttpServletResponse response, HttpServletRequest request ) {
		JSONArray jsarry = new JSONArray();
		try{
			Menu menuRecord = new Menu();
			List<Menu> allmenu = this.menuService.selectByEntity(menuRecord);
			String name = null;
			for (Menu menu : allmenu) {
				JSONObject jo = new JSONObject();
				name = "<span ";
				if (menu.getIsDefault() != null && menu.getIsDefault() == 1) {
					name += " class='blue'>";
				} else {
					name += ">";
				}
				name += "<i class='" + menu.getIcon() + "'></i>" + menu.getName() + "</span>";
				jo.put("id", menu.getId());
				jo.put("pId", menu.getPid());
				jo.put("name", name);
				jo.put("menuName", menu.getName());
				jo.put("menuUrl", menu.getUrl());
				jo.put("menuIcon", menu.getIcon());
				jo.put("orderNo", menu.getOrderNo());
				jo.put("parentId", menu.getPid());
				jo.put("isDefault", menu.getIsDefault());
				jsarry.add(jo);
			}
			
		}catch( Exception e ){
			logger.error("显示菜单时异常", e);
		}
		Util.writeObject(response, jsarry);
	}
	
	 /**
	 * 新增、修改菜单
	 * @param response
	 * @param request
	 * @param menu 待更新菜单实体
	 */
	@RequestMapping("editMenu")
	public void editMenu( HttpServletResponse response, HttpServletRequest request, Menu menu ){
		JSONObject jsObj = new JSONObject();
		try{
			Menu menuRecord = new Menu();
			menuRecord.setPid(menu.getPid());
			List<Menu> menuList = this.menuService.selectByEntity(menuRecord);
			int maxOrderNo = 1;
			if( menuList != null && menuList.size() > 0 ){
				maxOrderNo = menuList.get(menuList.size()-1).getOrderNo() + 1;
			}
			if( !menu.getOp().equals(3) ){
				//新增
				menu.setOrderNo(maxOrderNo);
				this.menuService.insertSelective(menu);
			}else{
				//修改
				Menu menuOld = this.menuService.selectByPrimaryKey(menu.getId());
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					if( !menu.getPid().equals(menuOld.getPid()) ){ //更改了父菜单，需要重新排序（原父菜单和新父菜单都需重新排序）
						//新父菜单
						menu.setOrderNo(maxOrderNo);
						//原父菜单
						this.menuService.updateOldOrderNo(menuOld);
					}
					this.menuService.updateByPrimaryKeySelective(menu);
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "操作成功");
				}catch( Exception e ){
					txManager.rollback(status);
					logger.error("更新菜单时数据库异常", e);
					Util.setAjaxReturnError(jsObj, "system", "事务提交异常");
				}
				
			}
			Util.setAjaxReturnSuccess(jsObj, "操作成功");
		}catch(Exception e){
			logger.error("更新菜单时异常", e);
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 删除菜单
	 * @param response
	 * @param request
	 * @param id 待删除菜单ID
	 */
	@RequestMapping("/delMenu")
	public void delMenu( HttpServletResponse response, HttpServletRequest request, Long id){
		JSONObject jsObj = new JSONObject();
		try{
			Menu menu = this.menuService.selectByPrimaryKey(id);
			List<Long> menunodes = new ArrayList<Long>();
			menunodes.add(menu.getId());
			if( menu.getPid().equals(0L) ){//属于一级菜单
				Menu menuRecord = new Menu();
				menuRecord.setPid(menu.getId());
				List<Menu> listSubMenu = this.menuService.selectByEntity(menuRecord);
				if( listSubMenu != null && listSubMenu.size() > 0 ){
					for( Menu subMenu : listSubMenu ){
						menunodes.add(subMenu.getId());
					}
				}
			}
			
			//事务控制
			DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			TransactionStatus status = txManager.getTransaction(def);
			
			try{
				//更新同级菜单orderNo
				this.menuService.updateOldOrderNo(menu);
				this.menuService.deleteByIds(menunodes);
				txManager.commit(status);
				Util.setAjaxReturnSuccess(jsObj, "删除成功");
			}catch( Exception e ){
				txManager.rollback(status);
				logger.error("删除菜单时数据库异常", e);
				Util.setAjaxReturnError(jsObj, "system", "事务提交异常");
			}
		}catch(Exception e){
			logger.error("删除菜单时异常", e);
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
		}
		
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 更新菜单OrderNo
	 * @param response
	 * @param request
	 * @param orderNo
	 * @param menuId
	 * @param menuPid
	 * @param flag
	 */
	@RequestMapping("/updateOrderNo")
	public void updateOrderNo(HttpServletResponse response,
			HttpServletRequest request, Integer orderNo, Long menuId, Long menuPid, Integer flag ) {

		Map<String, Object> resultMap = new HashMap<String, Object>();// 定义map
		try{
			Menu menu = new Menu();
			menu.setPid(menuPid);
			menu.setOrderNo(orderNo);
			menu.setId(menuId);
			menu.setFlag(flag);//1-上移, 2-下移
			
			//事务控制
			DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			TransactionStatus status = txManager.getTransaction(def);
			
			try{
				//更新同级菜单orderNo
				this.menuService.updateAllOrderNo(menu);
				//更新自身orderNo
				this.menuService.updateSelfOrderNo(menu);
				
				txManager.commit(status);
				resultMap.put("success", true);
				resultMap.put("msg", flag.equals(1)?"菜单上移成功":"菜单下移成功");
			}catch( Exception e ){
				txManager.rollback(status);
				logger.error("更新菜单OrderNo时数据库异常", e);
				resultMap.put("success", false);
				resultMap.put("msg", flag.equals(1)?"菜单上移事务提交异常":"菜单下移事务提交异常");
			}
		}catch( Exception e ){
			resultMap.put("success", false);
			logger.error("更新菜单OrderNo时异常", e);
			resultMap.put("msg", flag.equals(1)?"菜单上移系统异常":"菜单下移系统异常");
		}
		Util.writeResultMap(response, resultMap);
	}
	
	
	/**
	 * 获取同级菜单最大序号
	 * @param response
	 * @param request
	 * @param nodePid
	 */
	@RequestMapping("/getMaxOrderNo")
	public void getMaxOrderNo(HttpServletResponse response, HttpServletRequest request, Long nodePid) {

		Map<String, Object> resultMap = new HashMap<String, Object>();// 定义map

		// 获取同级菜单中排序数最大值
		Menu menuRecord = new Menu();
		menuRecord.setPid(nodePid);
		List<Menu> menuList = this.menuService.selectByEntity(menuRecord);
		int maxOrderNo = 1;
		if( menuList != null && menuList.size() > 0 ){
			maxOrderNo = menuList.get(menuList.size()-1).getOrderNo() + 1;
		}
		
		resultMap.put("maxOrderNo", maxOrderNo);
		Util.writeResultMap(response, resultMap);
	}
	
	 /**
	 * 查询父菜单
	 * @param request
	 * @param response
	 */
	@RequestMapping("getPMenu")
	public void getPMenu(HttpServletRequest request,HttpServletResponse response ) {
		JSONArray jsArr = new JSONArray();
		try {
			//查询所有父菜单
			Menu menuRecord = new Menu();
			menuRecord.setPid(0L);
			List<Menu> listAllPMenu = this.menuService.selectByEntity(menuRecord);
			
			JSONObject jo = null;
			for(Menu menu:listAllPMenu){					
				jo = JSONObject.parseObject(JSON.toJSONString(menu));
				jsArr.add(jo);
			}						
			
		}catch (Exception e) {
			logger.error("父菜单查询出现异常", e);
		}
		Util.writeObject(response, jsArr);
	}
	
}
