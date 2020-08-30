package com.gdcy.zyzzs.controller;

import java.text.DecimalFormat;
import java.text.Format;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.AccountToRole;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.pojo.Role;
import com.gdcy.zyzzs.service.AccountToRoleService;
import com.gdcy.zyzzs.service.LoginAccountService;
import com.gdcy.zyzzs.service.RoleService;
import com.gdcy.zyzzs.spring.SpringContextManager;
import com.gdcy.zyzzs.util.MD5Util;
import com.gdcy.zyzzs.util.Util;

@Controller
@RequestMapping("loginAccount/")
public class LoginAccountController extends BaseController {
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private LoginAccountService loginAccountService;
	
	@Resource
	private AccountToRoleService accountToRoleService;
	
	@Resource
	private RoleService roleService;
	
	/**
	 * 
	 * @param request
	 * @param response
	 * @param record
	 */
	@RequestMapping("getAccountInfo")
	public ModelAndView getAccountInfo(HttpServletRequest request, HttpServletResponse response, 
			LoginAccount record) {
		Map<String, Object> resultMap = new HashMap<String, Object>();// 定义map
		return new ModelAndView("accountManager/accountList", resultMap);
	}
	
	/***
	 * 获取用户列表
	 * @param response
	 * @param request
	 * @param loginAccount
	 * @param mark
	 */
	@RequestMapping("/showAccount")
	public void showAccount(HttpServletResponse response,
			HttpServletRequest request, LoginAccount loginAccount, Integer mark) {
		Map<String, Object> resultMap = new HashMap<String, Object>();// 定义map
		try {
			LoginAccount la = this.getCurrentUser(request);
			if( la.getId() != -1 ){
				loginAccount.setNodeId(la.getNodeId());
			}
			loginAccount.setIsDelete(mark);
			
			List<LoginAccount> loginAccountList = this.loginAccountService.selectByEntity(loginAccount);
			Integer total = this.loginAccountService.countByEntity(loginAccount);
			
			resultMap.put("rows", loginAccountList);
			resultMap.put("total", total);
		} catch (Exception e) {
			logger.error("获取用户列表时异常", e);
		}
		
		Util.writeResultMap(response, resultMap);
	}
	
	/**编辑账号
	 * 
	 * @param response
	 * @param request
	 * @param record
	 */
	@RequestMapping("/editAccount")
	public void editAccount( HttpServletResponse response, HttpServletRequest request, LoginAccount record ){
		JSONObject jsObj = new JSONObject();
		try{
			if( record != null ){
				if( record.getId() != null && !"".equals(record.getId())){ //修改
					record.setUpdateTime(new Date());
					record.setPassword(MD5Util.encodeByMD5(record.getPassword()));
					this.loginAccountService.updateByPrimaryKeySelective(record);
				}else{//新增
					LoginAccount la = this.getCurrentUser(request);
					if( la.getId() != -1 ){
						record.setNodeId(la.getNodeId());
					}
					record.setAddTime(new Date());
					record.setPassword(MD5Util.encodeByMD5(record.getPassword()));
					this.loginAccountService.insertSelective(record);
				}
				
				Util.setAjaxReturnSuccess(jsObj, "编辑成功!");
			}else{
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}

		}catch(Exception e){
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("编辑账号时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 账号停用
	 * @param response
	 * @param request
	 * @param accountId
	 */
	@RequestMapping("/closeAccount")
	public void closeAccount( HttpServletResponse response, HttpServletRequest request, Long accountId) {
		JSONObject jsObj=new JSONObject();
		try {
			LoginAccount la = this.getCurrentUser(request);
			LoginAccount laRecord = new LoginAccount();
			if( la.getId() != -1 ){
				laRecord.setNodeId(la.getNodeId());
			}else{
				return;
			}
			
			laRecord.setIsDelete(0);
			List<LoginAccount> loginAccountList = this.loginAccountService.selectByEntity(laRecord);
			int countManager = 0;
			if( loginAccountList != null && loginAccountList.size() > 0 ){
				for( LoginAccount lo : loginAccountList ){
					Integer isManager = this.roleService.isManager(lo.getId());
					if( isManager != null && isManager > 0 ){//管理员角色
						countManager ++;
					}
				}
			}
			
			if( countManager == 0 ){
				Util.setAjaxReturnError(jsObj, "manager", "此用户是最后一位管理员，管理员不能为空！");
				Util.writeObject(response, jsObj);
				return ;
			}
			
			LoginAccount loginAccount=new LoginAccount();
			loginAccount.setId(accountId);
			loginAccount.setIsDelete(1);
			this.loginAccountService.updateByPrimaryKeySelective(loginAccount);
			Util.setAjaxReturnSuccess(jsObj, "停用成功！");
		} catch (Exception e) {
			logger.error("停用用户时发生异常", e);
			Util.setAjaxReturnError(jsObj, "system", "系统异常！");
		}
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 恢复账号
	 * @param response
	 * @param request
	 * @param accountId
	 */
	@RequestMapping("/recoveryAccount")
	public void recoveryAccount(HttpServletResponse response,
			HttpServletRequest request, Long accountId) {
		JSONObject jsObj =new JSONObject();
		try {
			LoginAccount loginAccount = new LoginAccount();
			loginAccount.setId(accountId);
			loginAccount.setIsDelete(0);
			this.loginAccountService.updateByPrimaryKeySelective(loginAccount);
			Util.setAjaxReturnSuccess(jsObj, "恢复成功！");
		} catch (Exception e) {
			logger.error("账号恢复时异常", e);
			Util.setAjaxReturnError(jsObj, "system", "恢复失败！");
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 获取新账号号码
	 * @param request
	 * @param response
	 */
	@RequestMapping("getNewAccount")
	public void getNewAccount(HttpServletRequest request, HttpServletResponse response) {
		JSONObject returnObj = new JSONObject();
		try {
			LoginAccount la = this.getCurrentUser(request);
			if( la.getId() == -1 ){
				return;
			}
			
			String accountNo = "";
			LoginAccount laRecord = new LoginAccount();
			laRecord.setNodeId(la.getNodeId());
			List<LoginAccount> listLoginAccount = this.loginAccountService.selectByEntity(laRecord);
			if( listLoginAccount != null && listLoginAccount.size() > 0 ){
				Format deFormat = new DecimalFormat("00000000");
				accountNo = deFormat.format(Integer.parseInt(listLoginAccount.get(listLoginAccount.size()-1).getAccount())+1);
			}else{
				Node node = this.getNode(request);
				accountNo = node.getAccount() + "0001";
			}
			
			returnObj.put("newAccount", accountNo);
			Util.setAjaxReturnSuccess(returnObj, "查询成功");
		} catch (Exception e) {
			logger.error("获取最新账号时异常", e);
			Util.setAjaxReturnError(returnObj, "system", "系统异常");
		}
		Util.writeObject(response, returnObj);
	}

	/**
	 * 角色配置
	 * @param response
	 * @param request
	 * @param aid
	 * @param username
	 * @return
	 */
	@RequestMapping("/showUserOrganRole")
	public ModelAndView showUserOrganRole(HttpServletResponse response, HttpServletRequest request, Long accountId ) {
		Map<String, Object> resultMap = new HashMap<String, Object>();// 定义map
		try {
			if(accountId != null){
				Node node = this.getNode(request);
				Role record = new Role();
				record.setIsDelete(0);
				record.setNodeId(node.getId());
				List<Role> roleList = this.roleService.selectByEntity(record);
				
				AccountToRole atr = new AccountToRole();
				atr.setAccountId(accountId);
				List<AccountToRole> listatr = accountToRoleService.selectByEntity(atr);
				//把已有角色放到集合中
				Set<Long> idSet = new HashSet<Long>();
				for (AccountToRole atR : listatr) {
					idSet.add(atR.getRoleId());
				}
				
				//生成平台菜单树,把已有的角色默认勾选
				JSONArray jsArr = new JSONArray();
				JSONObject jsObj = null;
				if( roleList != null && roleList.size() > 0 ){
					for (Role role : roleList) {
						jsObj = new JSONObject();
						jsObj.put("id", role.getId());
						jsObj.put("pId", -1);
						jsObj.put("name", role.getName());
						if (idSet.contains(role.getId())) {
							jsObj.put("checked", true);
						}
						jsArr.add(jsObj);
					}
					
					resultMap.put("success", true);
					resultMap.put("roleTree", jsArr);
				}else{
					resultMap.put("success", false);
					resultMap.put("errorMsg", "无角色可配置");
				}
				
			}else{
				resultMap.put("success", false);
				resultMap.put("errorMsg", "参数异常");
			}
		} catch (Exception e) {
			resultMap.put("success", false);
			resultMap.put("errorMsg", "系统异常");
			logger.error("跳转到角色配置时异常", e);
		}
		return new ModelAndView("accountManager/userRoleEdit", resultMap);
	}

	/**
	 * 设置用户角色
	 * @param response
	 * @param request
	 * @param aid
	 * @param roleIds
	 * @param account
	 */
	@RequestMapping("/setUserRole")
	public void setUserRole(HttpServletResponse response, HttpServletRequest request, Long accountId, String roleIds,String account) {
			JSONObject jsObj=new JSONObject();
		try {
			//汇总修改后角色集合
			Set<Long> newRoleSet =new HashSet<Long>();
			if(roleIds !=null && roleIds.trim().length()!=0){
				String[] idArr=roleIds.split("@");
				for(String sid:idArr){
					newRoleSet.add(Long.parseLong(sid));
				}
			}
			
			//查找修改前角色集合
			AccountToRole atr = new AccountToRole();
			atr.setAccountId(accountId);
			List<AccountToRole> oldAtrList = accountToRoleService.selectByEntity(atr);
			
			if (oldAtrList != null && oldAtrList.size() > 0) {
				Long roleId = null;
				//对比修改前后集合,得出新增删除角色
				for (int i = 0; i < oldAtrList.size(); i++) {
					roleId = oldAtrList.get(i).getId();
					if (newRoleSet.contains(roleId)) {
						newRoleSet.remove(roleId);
						oldAtrList.remove(i);
						i--;
						continue;
					}
				}
			}
			
			LoginAccount la = this.getCurrentUser(request);
			LoginAccount laRecord = new LoginAccount();
			if( la.getId() != -1 ){
				laRecord.setNodeId(la.getNodeId());
			}else{
				return;
			}
			
			laRecord.setIsDelete(0);
			List<LoginAccount> loginAccountList = this.loginAccountService.selectByEntity(laRecord);
			int countManager = 0;
			Long accountIdTemp = 0L;
			if( loginAccountList != null && loginAccountList.size() > 0 ){
				for( LoginAccount lo : loginAccountList ){
					Integer isManager = this.roleService.isManager(lo.getId());
					if( isManager != null && isManager > 0 ){//管理员角色
						countManager ++;
						accountIdTemp = lo.getId();
					}
				}
			}
			
			if( countManager == 0 || (countManager == 1 && accountIdTemp == accountId) ){
				Util.setAjaxReturnError(jsObj, "manager", "此用户是最后一位管理员，管理员不能为空！");
				Util.writeObject(response, jsObj);
				return ;
			}
			
			//事务控制
			DataSourceTransactionManager txManager = (DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
			TransactionStatus status = txManager.getTransaction(def);
			
			try {
				if( oldAtrList != null && oldAtrList.size() > 0){
					for(AccountToRole oldAtr:oldAtrList){
						accountToRoleService.deleteByPrimaryKey(oldAtr.getId());
					}
				}
				
				if( newRoleSet != null && newRoleSet.size() > 0){
					AccountToRole record = new AccountToRole();
					record.setAccountId(accountId);
					for(Long roleId:newRoleSet){
						record.setRoleId(roleId);
						accountToRoleService.insert(record);
					}
				}

				txManager.commit(status);
				Util.setAjaxReturnSuccess(jsObj, "角色配置成功!");
			} catch (Exception e) {
				txManager.rollback(status);
				Util.setAjaxReturnError(jsObj, "mysql", "角色配置失败！");
				logger.error("设置用户角色时数据库异常", e);
			}
		} catch (Exception e) {
			Util.setAjaxReturnError(jsObj, "system", "角色配置失败！");
			logger.error("角色配置时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}

	/**
	 * 重置密码
	 * @param response
	 * @param request
	 * @param accountId
	 * @param newPass
	 */
	@RequestMapping("/resetPass")
	public void resetPass(HttpServletResponse response,
			HttpServletRequest request, Long accountId, String newPass) {
		JSONObject jsObj = new JSONObject();
		try {
			if (accountId  != null && newPass != null && !"".equals(newPass)) {
				
				//查询获取原密码
				LoginAccount loginAccount = this.loginAccountService.selectByPrimaryKey(accountId);
				//设置新密码
				loginAccount.setPassword(MD5Util.generatePassword(newPass));
				
		        this.loginAccountService.updateByPrimaryKey(loginAccount);
		        
		        Util.setAjaxReturnSuccess(jsObj, "重置成功！");
			} else {
				Util.setAjaxReturnError(jsObj, "param", "参数异常");
			}
		} catch (Exception e) {
			Util.setAjaxReturnError(jsObj, "system", "重置密码失败");
			logger.error("重置密码时异常", e);
		}
		Util.writeObject(response, jsObj);
	}

}
