package com.gdcy.zyzzs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Menu;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.service.LoginAccountService;
import com.gdcy.zyzzs.service.MenuService;
import com.gdcy.zyzzs.service.NodeService;
import com.gdcy.zyzzs.service.RoleService;
import com.gdcy.zyzzs.util.Constants;
import com.gdcy.zyzzs.util.CookieTool;
import com.gdcy.zyzzs.util.MD5Util;
import com.gdcy.zyzzs.util.Util;

@Controller
public class UrlController extends BaseController{
	private Logger logger = Logger.getLogger(this.getClass());
	
	@Resource
	private MenuService menuService;
	
	@Resource
	private RoleService roleService;
	
	@Resource
	private LoginAccountService loginAccountService;
	
	@Resource
	private NodeService nodeService;
	
	@RequestMapping("login")
	public ModelAndView login(HttpServletResponse response,HttpServletRequest request,Model model,
			String account, String password, String remberAccount, String rememberPwd, String code ) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			LoginAccount user = super.getCurrentUser(request);
			if (user != null  && (account == null || "".equals(account)) ) {//已登录且session未失效
				//根据缓存ID更新登录用户信息
				user = loginAccountService.selectByPrimaryKey(user.getId());
				//判断账户是否可用
				if (user.getIsDelete() == 1) {
					resultMap.put("tip", "账户已被停用！");
					request.getSession().invalidate();
					return new ModelAndView("index", resultMap);
				}
			} else {
				
				if (account == null || "".equals(account) 
						|| password == null || "".equals(password)) {
					resultMap.put("tip", "请先填写账号密码！");
					return new ModelAndView("index", resultMap);
				}
				
				//查询判断用户是否存在
				LoginAccount record = new LoginAccount();
				record.setAccount(account);
				record.setPassword(MD5Util.generatePassword(password));
				user = loginAccountService.LoginByAP(record);
				if (user == null || user.getId() == null) {
					resultMap.put("tip", "账号不存在或密码错误！");
					return new ModelAndView("index", resultMap);
				}
				//判断账户是否可用
				if (user.getIsDelete() == 1) {
					resultMap.put("tip", "该账户已被停用！");
					return new ModelAndView("index", resultMap);
				}
				resultMap.put("account", account);
				
				request.getSession().invalidate();
				
				// 设置cookie的存活时间为一个月
				if (remberAccount != null && !"".equals(remberAccount)) {
					// 将姓名、密码加入到cookie中
					CookieTool.addCookie(response, "cszsAccount", account, CookieTool.cookieMaxAge);
				} else {
					CookieTool.addCookie(response, "cszsAccount", null, 0);
					
				}
				if (rememberPwd != null && rememberPwd != "") {
					// 将姓名、密码加入到cookie中
					CookieTool.addCookie(response, "cszsPassword", password, CookieTool.cookieMaxAge);
				} else {
					// 清除Cookie
					CookieTool.addCookie(response, "cszsPassword", null, 0);
				}
				
				HttpSession session = request.getSession();
				session.setAttribute(Constants.SESSION_USER, user);
				Node node = this.nodeService.selectByPrimaryKey(user.getNodeId());
				session.setAttribute(Constants.SESSION_NODE, node);
				
				String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/";
				session.setAttribute(Constants.BASEPATH, basePath);
			}
			return this.toMain(response, request, model, user.getId());
		} catch (Exception e) {
			logger.error("电脑版登录时发生异常", e);
			resultMap.put("tip", "服务器异常,请稍候再试！");
			return new ModelAndView("index", resultMap);
		}
	}
	
	/**
	 * 跳转到主界面
	 * @param response
	 * @param request
	 * @param model
	 * @param userId	登录用户ID
	 * @return	最终跳转页面
	 */
	@RequestMapping("tomain")
	public ModelAndView toMain(HttpServletResponse response,HttpServletRequest request,Model model,
			Long userId) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			JSONArray menuArr = new JSONArray();
			//查询出总菜单集合
			List<Menu> menuList = null;
			Menu menuRecord = new Menu();
			if( userId == -1 ){//系统管理员
				menuList = menuService.selectByEntity(menuRecord);
			}else{
				Integer isManager = roleService.isManager(userId);
				if(  isManager != null && isManager == 1 ){//单位管理员
					menuRecord.setIsDefault(0);
					menuList = menuService.selectByEntity(menuRecord);
				}else{
					menuList = menuService.getMenusByUserId(userId);
					//下面for循环中如有追加menu会报错，在此另定义一个addMenuList来存储，用于循环后再一起追加。
					List<Menu> addMenuList = new ArrayList<Menu>();
					if (menuList != null && menuList.size() > 0) {
						Set<Long> menuIdSet = new HashSet<Long>();
						for (Menu menu : menuList) {
							menuIdSet.add(menu.getId());
							if (menu.getPid() != 0L) {
								getAllParentMenus(menu.getPid(), menuIdSet, menuList, addMenuList);
							}
						}
						if(addMenuList.size() > 0){
							menuList.addAll(addMenuList);
						}
					}
				}
			}
			
			if (menuList != null && menuList.size() > 0) {
				JSONObject jsObj = null;
				for (Menu menu : menuList) {
					//筛选出一级菜单
					if (menu.getPid() == 0L) {
						jsObj = JSONObject.parseObject(JSON.toJSONString(menu));
						//总菜单列表中移除当前菜单,减少后续循环次数
						//判断是否还存在下级菜单,若存在则存在在children字段中
						setChildrenToJsonObj(jsObj, menuList);
						menuArr.add(jsObj);
					}
				}
			}
			
			request.getSession().setAttribute("menuList", menuArr);
			
			return new ModelAndView("main", resultMap);
		} catch (Exception e) {
			logger.error("跳转到主页面时异常", e);
			resultMap.put("tip", "服务器异常,请稍候再试！");
			request.getSession().invalidate();
			return new ModelAndView("index", resultMap);
		}
	}

	private void getAllParentMenus(Long menuId, Set<Long> menuIdSet, List<Menu> menuList, List<Menu> addMenuList) {
		if (menuId != null && menuIdSet != null && menuList != null) {
			if (!menuIdSet.contains(menuId)) {
				Menu menu = menuService.selectByPrimaryKey(menuId);
				menuIdSet.add(menu.getId());
				addMenuList.add(menu);
				//menuList.add(menu);
				if (menu.getPid() != 0L) {
					getAllParentMenus(menu.getPid(), menuIdSet, menuList, addMenuList);
				}
			}
		}
		
	}

	/**
	 * 用户注销
	 * @param response
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("logout")
	public ModelAndView logout(HttpServletResponse response,HttpServletRequest request,Model model) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		try {
			request.getSession().invalidate();
		} catch (Exception e) {
			logger.error("用户注销时异常", e);
		}
		return new ModelAndView("index", resultMap);
	}
	
	/**
	 * 从菜单列表查找当前菜单对象的下级菜单,放到children中
	 * @param jsObj	当前菜单对象
	 * @param list	所有下级菜单列表
	 */
	private void setChildrenToJsonObj(JSONObject jsObj, List<Menu> list) {
		if (jsObj != null && list != null && list.size() > 0) {
			JSONArray sonArr = new JSONArray();
			JSONObject sonObj = null;
			Long id = jsObj.getLong("id");
			for (Menu menu : list) {
				if (menu.getPid().equals(id)) {
					sonObj = JSONObject.parseObject(JSON.toJSONString(menu));
					if( sonObj.getString("url").indexOf("?") != -1 ){
						sonObj.put("url", sonObj.getString("url")+"&id="+sonObj.getLong("id"));
					}else{
						sonObj.put("url", sonObj.getString("url")+"?id="+sonObj.getLong("id"));
					}
					setChildrenToJsonObj(sonObj, list);
					sonArr.add(sonObj);
				}
			}
			if (sonArr.size() > 0) {
				jsObj.put("children", sonArr);
			}
		}
	}

	/**
	 * 判断密码是否正确
	 * @param response
	 * @param request
	 * @param pwEnter
	 * @param pwOld
	 */
	@RequestMapping("validatePw")
	public void validatePw(HttpServletResponse response, HttpServletRequest request, 
			String pwEnter, String pwOld) {
		JSONObject jsObj = new JSONObject();
		try {
			jsObj.put("success", MD5Util.validatePassword(pwOld, pwEnter));
		} catch (Exception e) {
			jsObj.put("success", false);
			logger.error("判断密码是否正确时异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
	/**
	 * 更改个人信息
	 * @param request
	 * @param response
	 * @param name
	 * @param account
	 * @param password
	 */
	@RequestMapping("modifySetting")
	public void modifySetting(HttpServletRequest request, HttpServletResponse response,
			String name, String password ) {
		JSONObject jsObj = new JSONObject();
		try {
			LoginAccount la = super.getCurrentUser(request);
			la.setName(name);
			la.setPassword(MD5Util.generatePassword(password));
			this.loginAccountService.updateByPrimaryKeySelective(la);
			Util.setAjaxReturnSuccess(jsObj, "修改成功");
		} catch (Exception e) {
			Util.setAjaxReturnError(jsObj, "system", "系统异常");
			logger.error("更改个人信息时发生异常", e);
		}
		Util.writeObject(response, jsObj);
	}
	
}
