package com.gdcy.zyzzs.controller;

import java.util.ArrayList;
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
import com.gdcy.zyzzs.pojo.AccountToRole;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.Role;
import com.gdcy.zyzzs.pojo.RoleToMenu;
import com.gdcy.zyzzs.service.AccountToRoleService;
import com.gdcy.zyzzs.service.LoginAccountService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.RoleService;
import com.gdcy.zyzzs.service.RoleToMenuService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.MD5Util;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("node/")
public class NodeController extends BaseController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private NodeService nodeService;
	
	@Resource
	private RoleService roleService;
	
	@Resource
	private LoginAccountService loginAccountService;
	
	@Resource
	private AccountToRoleService accountToRoleService;
	
	@Resource
	private RoleToMenuService roleToMenuService;
	
	/**
	 * 获取节点信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getNode")
	public void getNode(HttpServletRequest request, HttpServletResponse response, 
			Node record) {
		JSONObject returnObj = new JSONObject();
		try {
			record.setIsDelete(0);
			List<Node> list = nodeService.selectByEntity(record);
			int total = nodeService.countByEntity(record);
			
			returnObj.put("rows", JSONArray.parseArray(JSON.toJSONString(list)));
			returnObj.put("total", total);
		} catch (Exception e) {
			logger.error("获取节点信息时异常", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 获取登录节点基本信息
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getNodeDetail")
	public void getNodeDetail(HttpServletRequest request, HttpServletResponse response, 
			Long nodeId) {
		JSONObject returnObj = new JSONObject();
		try {
			Node node = this.nodeService.selectByPrimaryKey( nodeId );
			returnObj.put("data", node);
		} catch (Exception e) {
			logger.error("获取登录节点基本信息", e);
		}
		Util.writeObject(response, returnObj);
	}
	
	/**
	 * 编辑节点
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editNode")
	public void editNode(HttpServletResponse response, HttpServletRequest request, Node record){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateTime(new Date());
				}else{//新增
					record.setAddTime(new Date());
				}
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					if( record.getId() != null && !"".equals(record.getId())){ //修改
						this.nodeService.updateByPrimaryKeySelective(record);
					}else{
						
						Node nodeRecord = new Node();
						List<Node> listNode = this.nodeService.selectByEntity(nodeRecord);
						String nodeAccount = "0001";
						if( listNode != null && listNode.size() > 0){
							nodeAccount = String.format("%04d", Integer.parseInt(listNode.get(0).getAccount())+1);
						}
						record.setAccount(nodeAccount);
						this.nodeService.insertSelective(record);
						
						//自动为单位添加角色及账号
						Role role = new Role();
						role.setName("单位管理员");
						role.setDescription("单位管理员");
						role.setIsManager(1);
						role.setNodeId(record.getId());
						role.setAddTime(new Date());
						this.roleService.insertSelective(role);
						
						String account = nodeAccount + "0001";
						LoginAccount loginAccount = new LoginAccount();
						loginAccount.setName("管理员");
						loginAccount.setAccount(account);
						loginAccount.setPassword(MD5Util.encodeByMD5("123456"));
						loginAccount.setNodeId(record.getId());
						loginAccount.setAddTime(new Date());
						this.loginAccountService.insertSelective(loginAccount);
						
						AccountToRole accountToRole = new AccountToRole();
						accountToRole.setAccountId(loginAccount.getId());
						accountToRole.setRoleId(role.getId());
						this.accountToRoleService.insertSelective(accountToRole);
					}
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "更新成功");
				}catch( Exception e ){
					txManager.rollback(status);
					logger.error("编辑节点时数据库异常", e);
					Util.setAjaxReturnError(jsObj, "system", "事务提交异常");
				}
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑节点时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	

	/**
	 * 删除节点
	 * @param response
	 * @param request
	 * @param nodeId
	 */
	@RequestMapping("/deleteNode")
	public void deleteNode( HttpServletResponse response, HttpServletRequest request, Long nodeId ){
		JSONObject jsObj = new JSONObject();
		try{
			Node node = this.nodeService.selectByPrimaryKey(nodeId);
			if( node != null ){
				Date deleteTime = new Date();
				node.setIsDelete(1);
				node.setDeleteTime(deleteTime);
				
				Role role = new Role();
				role.setNodeId(nodeId);
				role.setIsDelete(0);
				List<Role> listRole = this.roleService.selectByEntity(role);
				List<Long> listRTM = new ArrayList<Long>();
				if( listRole != null && listRole.size() > 0 ){
					for( Role roleT : listRole ){
						roleT.setIsDelete(1);
						roleT.setDeleteTime(deleteTime);
						
						RoleToMenu rtm = new RoleToMenu();
						rtm.setRoleId(roleT.getId());
						List<RoleToMenu> listT = this.roleToMenuService.selectByEntity(rtm);
						if( listT != null && listT.size() > 0 ){
							for( RoleToMenu rtmT : listT ){
								listRTM.add(rtmT.getId());
							}
						}
					}
				}
				
				LoginAccount loginAccount = new LoginAccount();
				loginAccount.setNodeId(nodeId);
				loginAccount.setIsDelete(0);
				List<LoginAccount> listLoginAccount = this.loginAccountService.selectByEntity(loginAccount);
				List<Long> listATR = new ArrayList<Long>();
				if( listLoginAccount != null && listLoginAccount.size() > 0 ){
					for( LoginAccount la : listLoginAccount ){
						la.setIsDelete(1);
						la.setDeleteTime(deleteTime);
						
						AccountToRole atr = new AccountToRole();
						atr.setAccountId(la.getId());
						List<AccountToRole> listT = this.accountToRoleService.selectByEntity(atr);
						if( listT != null && listT.size() > 0 ){
							for( AccountToRole atrT : listT ){
								listATR.add(atrT.getId());
							}
						}
					}
				}
				
				//事务控制
				DataSourceTransactionManager txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
				DefaultTransactionDefinition def = new DefaultTransactionDefinition();
				def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
				TransactionStatus status = txManager.getTransaction(def);
				
				try{
					this.nodeService.updateByPrimaryKeySelective(node);
					
					if( listRole != null && listRole.size() > 0 ){
						for( Role roleT : listRole ){
							this.roleService.updateByPrimaryKeySelective(roleT);
						}
					}
					
					if( listRTM != null && listRTM.size() > 0 ){
						for( Long id : listRTM ){
							this.roleToMenuService.deleteByPrimaryKey(id);
						}
					}
					
					if( listLoginAccount != null && listLoginAccount.size() > 0 ){
						for( LoginAccount loginAccountT : listLoginAccount ){
							this.loginAccountService.updateByPrimaryKeySelective(loginAccountT);
						}
					}
					
					if( listATR != null && listATR.size() > 0 ){
						for( Long id : listATR ){
							this.accountToRoleService.deleteByPrimaryKey(id);
						}
					}
					
					txManager.commit(status);
					Util.setAjaxReturnSuccess(jsObj, "删除成功");
				}catch( Exception e ){
					txManager.rollback(status);
					logger.error("删除节点时数据库异常", e);
					Util.setAjaxReturnError(jsObj, "system", "事务提交异常");
				}
				
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
			
		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "删除失败！");
			logger.error("删除节点时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
}
