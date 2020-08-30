package com.gdcy.zyzzs.controller;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.util.Constants;

public class BaseController {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	public LoginAccount getCurrentUser(HttpServletRequest request) {
		return (LoginAccount) request.getSession().getAttribute(Constants.SESSION_USER);
	}
	
	public Node getNode(HttpServletRequest request){
		return (Node) request.getSession().getAttribute(Constants.SESSION_NODE);
	}
	
	/**
	 * 初始化数据绑定，添加date和Timestamp的数据转换
	 * @param request
	 * @param binder
	 */
	@InitBinder
	protected void init(HttpServletRequest request, ServletRequestDataBinder binder){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		SimpleDateFormat datetimeFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		datetimeFormat.setLenient(false);
		binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat,true));
		binder.registerCustomEditor(java.sql.Timestamp.class, new CustomDateEditor(datetimeFormat,true));
	}
	
	/**
	 * 信息同步到茂名市肉菜流通追溯系统中
	 * @param urlStr
	 * @param dataStr
	 * @throws IOException
	 */
	public boolean dealDataToCszs( String urlStr, String dataStr ) throws IOException{
		log.info("dataStr----------"+dataStr);
		dataStr = URLEncoder.encode(dataStr,"UTF-8");
		
		URL postUrl = new URL(urlStr);
		HttpURLConnection connection = (HttpURLConnection) postUrl
				.openConnection();
		connection.setDoOutput(true);
		connection.setDoInput(true);
		connection.setRequestMethod("POST");
		connection.setUseCaches(false);
		connection.setInstanceFollowRedirects(true);
		connection.setRequestProperty("Content-Type",
				"application/x-www-form-urlencoded");
		connection.connect();
		DataOutputStream out = new DataOutputStream(
				connection.getOutputStream());
		String content = "dataStr=" + dataStr;
		out.writeBytes(content);
		out.flush();
		out.close();
		BufferedReader reader = new BufferedReader(new InputStreamReader(
				connection.getInputStream(), "utf-8"));// 设置编码,否则中文乱码
		String line = "";
		boolean success = false;
		while ((line = reader.readLine()) != null) {
			success = JSONObject.parseObject(line).getBoolean("success");
			log.info("return>>>>>>>>" + line);
		}

		reader.close();
		connection.disconnect();
		return success;
	}
}
