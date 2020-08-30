package com.gdcy.zyzzs.controller;

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
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.AccountToRole;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Menu;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.Role;
import com.gdcy.zyzzs.pojo.RoleToMenu;
import com.gdcy.zyzzs.service.AccountToRoleService;
import com.gdcy.zyzzs.service.LoginAccountService;
import com.gdcy.zyzzs.service.MenuService;
import com.gdcy.zyzzs.service.RoleService;
import com.gdcy.zyzzs.service.RoleToMenuService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.Util;


@Controller
@RequestMapping("role/")
public class RoleController extends BaseController{
	
	private Logger logger =Logger.getLogger(this.getClass());
	
	@Resource
	private RoleService roleService;
	
	@Resource
	private LoginAccountService loginAccountService;
	
	@Resource
	private AccountToRoleService accountToRoleService;
	
	@Resource
	private MenuService menuService;
	
	@Resource
	private RoleToMenuService roleToMenuService;
	
	/**获取角色信息
	 * 
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("getRole")
	public void getRole( HttpServletResponse response, HttpServletRequest request, Role record ){
		JSONObject returnObj = new JSONObject();
		try {
			Node node = this.getNode(request);
			if( node != null ){
				record.setNodeId(node.getId());
			}
			
			List<Role> list = roleService.selectByEntity(record);
			int total = roleService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取角色信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**编辑角色
	 * 
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editRole")
	public void editRole( HttpServletResponse response, HttpServletRequest request, Role record ){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					if(record.getIsManager()==null){
						record.setIsManager(0);
					}
					record.setUpdateTime(new Date());
					this.roleService.updateByPrimaryKeySelective(record);
				}else{//新增
					LoginAccount la = this.getCurrentUser(request);
					if( la.getId() != -1 ){
						record.setNodeId(la.getNodeId());
					}
					record.setAddTime(new Date());
					this.roleService.insertSelective(record);
				}
				
				Util.setAjaxReturnSuccess(jsObj, "编辑成功!");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑角色时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	/** 删除角色
	 * 
	 * @param response
	 * @param request
	 * @param roleId
	 */
	@RequestMapping("/deleteRole")
	public void deleteRole( HttpServletResponse response, HttpServletRequest request, Long roleId ){
		JSONObject jsObj = new JSONObject();
		try{
			Role role = this.roleService.selectByPrimaryKey(roleId);
			if( role != null ){
				this.roleService.deleteByPrimaryKey(roleId);
				Util.setAjaxReturnSuccess(jsObj, "删除成功!");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除角色时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 人员授权界面
	 * @param response
	 * @param request
	 * @param roleName
	 * @param roleId
	 * @return
	 */
	@RequestMapping("showUserView")
	public ModelAndView showUserView( HttpServletResponse response, HttpServletRequest request, String roleName, Long roleId ) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			JSONArray jsArr = new JSONArray();
			
			if(roleId != null){
				LoginAccount la = this.getCurrentUser(request);
				JSONObject root = new JSONObject();
				root.put("id", "0");
				root.put("pId", "-1");
				root.put("isParent", true);
				root.put("name", "用户名称");
				jsArr.add(root);
				
				JSONObject userObj = null;
				LoginAccount record = new LoginAccount();
				if( la.getId() != -1 ){
					record.setNodeId(la.getNodeId());
				}
				
				record.setIsDelete(0);
				List<LoginAccount> loginAccounts = this.loginAccountService.selectByEntity(record);
				
				AccountToRole atr = new AccountToRole();
				atr.setRoleId(roleId);
				List<AccountToRole> listatr = accountToRoleService.selectByEntity(atr);
				
				for (LoginAccount acc : loginAccounts) {
					userObj = new JSONObject();
					userObj.put("id", acc.getId());
					userObj.put("pId", "0");
					userObj.put("name", acc.getName());
					
					for(AccountToRole atR:listatr){
						if(atR.getAccountId() == acc.getId()){
							userObj.put("checked", true);
						}
					}
					jsArr.add(userObj);
				}
				resultMap.put("success", true);
				resultMap.put("menuTree", jsArr);
				resultMap.put("roleId", roleId);
				
			}else{
				resultMap.put("success", false);
				resultMap.put("errorMsg", "参数异常");
			}
		} catch (Exception e) {
			resultMap.put("success", false);
			resultMap.put("errorMsg", "系统异常");
			logger.error("生成人员列表时发生异常", e);
		}
		return new ModelAndView("roleManager/selectMenu", resultMap);
	}

	/**
	 * 人员授权
	 * @param request
	 * @param response
	 * @param nodeStr
	 * @param roleId
	 */
	@RequestMapping("setRoleUser")
	public void setRoleUser(HttpServletRequest request,HttpServletResponse response,
			String nodeStr,Long roleId){
		JSONObject jsObject =new JSONObject();		
		try{	
			Role role = this.roleService.selectByPrimaryKey(roleId);
			List<Long> newAccountIdList  =new ArrayList<Long>();
			//如果该角色是单位管理员角色,则不能全部人员都去除
			if(role.getIsManager()==1 && "".equals(nodeStr)){
				Util.setAjaxReturnError(jsObject, "manager", "单位管理员角色不能为空！");
			} else {
				String[] new_aidArr = nodeStr.trim().length()>0?nodeStr.split("@"):null;
				if(new_aidArr!=null&&new_aidArr.length>0){
					for(String sid: new_aidArr){
						newAccountIdList.add(Long.valueOf(sid));
					}
				}
				//查询原来拥有该角色的用户id;
				List<Long> oldAccountIdList =new ArrayList<Long>();
				AccountToRole actRecord = new AccountToRole();
				actRecord.setRoleId(roleId);
				List<AccountToRole> oldATRList = this.accountToRoleService.selectByEntity(actRecord);
				if( oldATRList != null && oldATRList.size() > 0 ){
					for( AccountToRole atr : oldATRList ){
						oldAccountIdList.add(atr.getAccountId());
					}
				}
				
				//判断哪些用户需要删除、增加、
				for (int i = 0; i < newAccountIdList.size(); i++) {
					for (Long oldId : oldAccountIdList) {
						if (oldId.equals(newAccountIdList.get(i))) {
							newAccountIdList.remove(i);
							oldAccountIdList.remove(oldId);
							i--;
							break;
						}
					}
				}
				
				List<AccountToRole> addAccToRoleList = new ArrayList<AccountToRole>();
				List<AccountToRole> delAccToRoleList = new ArrayList<AccountToRole>();
				
				//如果newAccountIdList存在数据则说明有用户新增了该角色
				if (newAccountIdList.size() > 0) {
					for (Long addAccId : newAccountIdList) {
						AccountToRole atr = new AccountToRole();
						atr.setAccountId(addAccId);
						atr.setRoleId(roleId);
						addAccToRoleList.add(atr);
					}
				}
				
				//如果oldAccountIdList存在数据则说明有用户删除了该角色
				if (oldAccountIdList.size() > 0) {
					for (Long delAccId : oldAccountIdList) {
						AccountToRole atR = new AccountToRole();
						atR.setAccountId(delAccId);
						atR.setRoleId(roleId);
						delAccToRoleList.add(atR);
					}
				}
				
				//事务控制
				DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					if (addAccToRoleList.size() > 0) {
						for (AccountToRole addAcc : addAccToRoleList) {
							this.accountToRoleService.insertSelective(addAcc);
						}
					}
					
					if (delAccToRoleList.size() > 0) {
						for (AccountToRole delAcc : delAccToRoleList) {
							this.accountToRoleService.delByAccIdAndRoleId(delAcc);
						}
					}
					
					boolean isCommit = true;
					
					if (isCommit) {
						txManager.commit(status);
						Util.setAjaxReturnSuccess(jsObject, "授权成功!");
					} else {
						txManager.rollback(status);
						Util.setAjaxReturnError(jsObject, "wgh", "授权失败！");
					}
		        } catch (Exception e) {
		        	txManager.rollback(status);
					Util.setAjaxReturnError(jsObject, "mysql", "授权失败！");
					logger.error("人员授权时数据库异常", e);
				}
			}
		}catch (Exception e) {
			logger.error("人员授权时发生异常", e);
			Util.setAjaxReturnError(jsObject, "system", "授权失败！");
		}
		Util.writeObject(response, jsObject);
	}

	/**
	 * 功能授权菜单
	 * @param response
	 * @param request
	 * @param chooseRolied
	 * @return
	 */
	@RequestMapping("/showMenuView")
	public ModelAndView showMenuView( HttpServletResponse response, HttpServletRequest request, Long roleId ){
		Map<String, Object> resultMap = new HashMap<String, Object>();//定义map
		JSONArray jsarry=new JSONArray();
		try{
			if( roleId != null && roleId != 0L ){
				Menu menuRecord = new Menu();
				menuRecord.setIsDefault(0);
				List<Menu> allMenu=this.menuService.selectByEntity(menuRecord);
				//获取选择角色菜单
				RoleToMenu record=new RoleToMenu();
				record.setRoleId(roleId);
				List<RoleToMenu> listRoleMenu =this.roleToMenuService.selectByEntity(record);
				for(Menu menu:allMenu){			
					JSONObject jo = new JSONObject();
					jo.put("id", menu.getId());
					jo.put("pId", menu.getPid());
					jo.put("name","<i class=\\\""+ menu.getIcon() + "\\\"></i>"+menu.getName());
					jo.put("title", menu.getName());
					if( listRoleMenu != null && listRoleMenu.size() > 0 ){
						for(RoleToMenu rtm:listRoleMenu){
							if(menu.getId().equals(rtm.getMenuId())){
								jo.put("checked", true);
								break;
							}
						}	
					}
					
					jsarry.add(jo);
				}
				resultMap.put("menuTree",jsarry);
				resultMap.put("roleId",roleId);
				resultMap.put("success", true);
				
			}else{
				resultMap.put("success", false);
				resultMap.put("errorMsg", "参数异常");
			}
		}catch (Exception e) {
			resultMap.put("success", false);
			resultMap.put("errorMsg", "系统异常");
			logger.error("功能授权菜单生成树异常",e);
		}
	    return new ModelAndView("roleManager/selectMenu",resultMap);
	}

	/**
	 * 功能授权设置
	 * @param response
	 * @param request
	 * @param model
	 * @param organMenu
	 * @param roleId
	 */
	@RequestMapping("/setRoleMenu")
	public void setRoleMenu( HttpServletResponse response, HttpServletRequest request, String organMenu, Long roleId ){
		JSONObject jsonObject=new JSONObject();
		try{			
			List<Long> roleIdList =new ArrayList<Long>();
			roleIdList.add(roleId);
			//查询当前角色的已有菜单
			List<Menu> menuList =this.menuService.getMenusByRoleIds(roleIdList);
			//新旧菜单Id集合
			List<Long> oldMenuList =new ArrayList<Long>();
			if(menuList.size()>0){
				//加入已有菜单集合中；
				for(Menu menu:menuList){
					oldMenuList.add(menu.getId());
				}
			}
			//对比得到需要删除，增加的菜单集合；并生成新增插入对象集合；
			List<Long> addList=new ArrayList<Long>();
			List<Long>  delList=new ArrayList<Long>();
			List<RoleToMenu> rtmList=new ArrayList<RoleToMenu>();
			if(organMenu.trim()!=null && !"".equals(organMenu.trim())){
				//生成更新后菜单集合
				String[] menuArr=organMenu.split("@");
				RoleToMenu orm=null;	
				//遍历前台传来的id数组，不存在oldMenuList，则是新增，存在，则是保留；
				for(String menuId:menuArr){				
					Long id=Long.parseLong(menuId);
					if(!oldMenuList.contains(id)){
						//不存在于原来菜单，属于增加项
						orm=new RoleToMenu();
						orm.setRoleId(roleId);
						orm.setMenuId(id);
						rtmList.add(orm);
						addList.add(id);
					}else{
						//oldMenuList去除保留的，剩下的均为删除id项
						oldMenuList.remove(id);
					}				
				}
				delList.addAll(oldMenuList);

			}else{
				addList=null;
				delList.addAll(oldMenuList);
			}
			//事务控制
			DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
			DefaultTransactionDefinition def=new DefaultTransactionDefinition();
			TransactionStatus status = txManager.getTransaction(def);
			try{
				if(addList!=null && addList.size()>0){
					this.roleToMenuService.batchInsert(rtmList);
				}
				if(delList!=null && delList.size()>0){				
					this.roleToMenuService.deleteByMenuIds(roleId, delList);
				}
				txManager.commit(status);
				jsonObject.put("success", true);
				jsonObject.put("mess", "修改菜单权限成功");
				Util.setAjaxReturnSuccess(jsonObject, "授权成功!");
			}catch (Exception e) {
				txManager.rollback(status);
				jsonObject.put("success", false);
				jsonObject.put("mess", "修改菜单权限失败");
				Util.setAjaxReturnError(jsonObject, "mysql", "授权失败！");
			}

		}catch (Exception e) {
			logger.error("更新菜单时发生异常",e);
			Util.setAjaxReturnError(jsonObject, "system", "授权失败！");
		}
		Util.writeObject(response, jsonObject);
	}
	
}
