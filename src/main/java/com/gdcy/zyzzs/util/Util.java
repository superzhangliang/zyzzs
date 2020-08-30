package com.gdcy.zyzzs.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.gdcy.zyzzs.spring.SpringContextManager;

public class Util {
	/**
	 * 开始数据库事务管理
	 * @param txManager	事务管理器
	 * @param status	事务状态
	 */
	public static void openTransactionManager(DataSourceTransactionManager txManager, TransactionStatus status) {
		//事务控制
		txManager=(DataSourceTransactionManager) SpringContextManager.getBean("transactionManager");
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        status = txManager.getTransaction(def);
	}
	
	/**
	 * 返回结果集
	 * @param response
	 * @param resultMap
	 */
	public static void writeResultMap(HttpServletResponse response, Map<String, Object> resultMap) {
		PrintWriter out = null;
		try {
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			out.print(JSON.toJSON(resultMap));
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 返回结果对象
	 * @param response
	 * @param object
	 */
	public static void writeObject(HttpServletResponse response, Object object) {
		PrintWriter out = null;
		try {
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			out.print(object);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 字符串转换date格式
	 * @param dateStr
	 * @param formatStr
	 * @return
	 * create time:2014-12-9 下午05:27:25
	 * @author cwz
	 */
	public static Date StringToDate(String dateStr,String formatStr){
		DateFormat sdf=new SimpleDateFormat(formatStr);
		Date date=null;
		try {
			date = sdf.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	
	/**
	 * 把日期转化为对应格式字符串
	 * @param iDate	日期对象
	 * @param format	转换后的格式
	 * @return	日期字符串
	 */
	public static String formatDateToString(Date iDate,String format) {
		if(iDate==null) return "";
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		return formatter.format(iDate);
	}
	
	/**
	 * 字符串数组转化为字符串
	 * @param strarr	字符串数组
	 * @return	字符串
	 */
	public static String strarrytostr(String[] strarr){
		String newstr="";
		for(int i=0;i<strarr.length;i++)
		{
			if(i==0)
			{
				newstr +=strarr[i];
			}else{
				newstr +=","+strarr[i];
			}
		}
		return newstr;
	}
	
	/**
	 * 下载图片
	 * @param imgurl	需下载图片的url地址
	 * @param savepath	图片保存路径
	 * @throws Exception
	 */
	public static void Downloadimgs(String imgurl,String savepath) throws Exception{
		URL url = new URL(imgurl);
		File outFile = new File(savepath);
		OutputStream os = new FileOutputStream(outFile);
		InputStream is = url.openStream();
		byte[] buff = new byte[1024];
		while(true) {
			int readed = is.read(buff);
			if(readed == -1) {
				break;
			}
			byte[] temp = new byte[readed];
			System.arraycopy(buff, 0, temp, 0, readed);
			os.write(temp);
		}
		is.close(); 
        os.close();
	}
	
	/**
     * 把普通字符串转换成html显示的字符串
     * @param str	普通字符串
     * @return	html显示的字符串
     * @throws Exception
     */
	public static String changeStrToHtml(String str) {
		str = str.replaceAll(" ", "&nbsp;");
		str = str.replaceAll("\r\n", "<br/>");
		str = str.replaceAll("\n", "<br/>");

		return str;
	}
	
	/**
	 * 把html显示的字符串转换成普通字符串
	 * @param str	html显示的字符串
	 * @return	普通字符串
	 * @throws Exception
	 */
	public static String changeHtmlToStr(String str) {

		str = str.replaceAll("<br/>", "\n");
		str = str.replaceAll("&nbsp;", " ");
		return str;
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param errorType	错误类型
	 * @param errorMsg	错误信息
	 */
	public static void setAjaxReturnError(JSONObject jsObj, String errorType, String errorMsg) {
		if (jsObj == null) jsObj = new JSONObject();
		jsObj.put("success", false);
		jsObj.put("errorType", errorType);
		jsObj.put("msg", errorMsg);
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param successMsg	成功信息
	 */
	public static void setAjaxReturnSuccess(JSONObject jsObj, String successMsg) {
		if (jsObj == null) jsObj = new JSONObject();
		jsObj.put("success", true);
		jsObj.put("msg", successMsg);
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param errorType	错误类型
	 * @param errorMsg	错误信息
	 */
	public static void setAjaxReturnErrorAndSend(HttpServletResponse response, String errorType, String errorMsg) {
		PrintWriter out = null;
		try {
			JSONObject jsObj = new JSONObject();
			jsObj.put("success", false);
			jsObj.put("errorType", errorType);
			jsObj.put("msg", errorMsg);
			
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			out.print(jsObj);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param successMsg	成功信息
	 */
	public static void setAjaxReturnSuccessAndSend(HttpServletResponse response, String successMsg) {
		PrintWriter out = null;
		try {
			JSONObject jsObj = new JSONObject();
			jsObj.put("success", true);
			jsObj.put("msg", successMsg);
			
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			out.print(jsObj);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 判断是否全部为字母
	 * @param str	需判断的字符串
	 * @return	是否全部为字母
	 */
	public static boolean isAllChar(String str) {
		return str.matches("^[A-Za-z]+$");
	}
	
	/**
	 * 获取单个文件上传大小限制
	 * @return	限制的文件大小,单位为字节
	 */
	public static int getSingleFileSizeLimit() {
		String size = (String) PropertiesUtil.getProperty("singleSizeLimit",PropertiesUtil.PROP_CONSTANTS_FILE);
		int fileSizeLimit = 0;
		String onlyNumber = "^[0-9]*$";
		String unitNumber = "^[0-9]*[A-Z]$";
		if (size != null && !"".equals(size)) {
			size = size.toUpperCase();
			if (size.matches(onlyNumber)) {//判断是否只为数字
				fileSizeLimit = Integer.parseInt(size);
			} else if (size.matches(unitNumber)) {//判断是否为带单位的字符串
				if (size.endsWith("K") || size.endsWith("KB")) {//转换K的大小为字节
					fileSizeLimit = Integer.parseInt(size.substring(0, size.indexOf("K")));
					fileSizeLimit = fileSizeLimit * 1024;
				} else if (size.endsWith("M") || size.endsWith("MB")) {//转换M的大小为字节
					fileSizeLimit = Integer.parseInt(size.substring(0, size.indexOf("M")));
					fileSizeLimit = fileSizeLimit * 1024 * 1024;
				} else if (size.endsWith("G") || size.endsWith("GB")) {//转换G的大小为字节
					fileSizeLimit = Integer.parseInt(size.substring(0, size.indexOf("G")));
					fileSizeLimit = fileSizeLimit * 1024 * 1024 * 1024;
				}
			}
		}
		return fileSizeLimit;
	}
	
	/**
	 * 获取文件的服务器保存路径
	 * @param userinfo	当前登录用户对象
	 * @return	服务器保存文件的路径
	 */
	public static String getSavePath() {
		StringBuffer sb = new StringBuffer("");
		//先添加配置文件定义保存路径
		sb.append(PropertiesUtil.getProperty("document_path",PropertiesUtil.PROP_CONSTANTS_FILE));
		//再添加机构相关的分类保存路径
		sb.append("/");
		sb.append(Calendar.getInstance().get(Calendar.YEAR));
		sb.append("-");
		sb.append(Calendar.getInstance().get(Calendar.MONTH)+1);
		return sb.toString();
	}
	
	/**
	 * 获取服务器保存的新文件名,确保新文件名称不重复
	 * @param postfix	原文件后缀名
	 * @return	新的文件名称
	 */
	public static String getNewSaveName(String postfix) {
		if (!postfix.startsWith(".")) {
			postfix = "." + postfix;
		}
		Random random = new Random();
		return String.valueOf(new Date().getTime()) + random.nextInt(10000) + postfix;
	}
	
	
	/**
	 * 获取机构类型说明
	 * @param type	机构类型
	 * @return	对应的机构类型名称
	 */
	public static String getOrganTypeName(int type) {
		String name = null;
		switch (type) {
		case 1:
			name = "政府";
			break;
		case 2:
			name = "企业";
			break;
		case 3:
			name = "农村";
			break;
		default:
			break;
		}
		return name;
	}
	
	/**
	 * 直接连接两个字符串
	 * @param separator	分隔符,不传则默认为以","分隔
	 * @param str1	字符串1
	 * @param str2	字符串2
	 * @return	连接后的字符串
	 */
	public static String concatString(String separator, String str1, String str2) {
		if (str1 == null && str2 == null) {
			return null;
		} else if (str1 == null || "".equals(str1.trim())) {
			return str2;
		} else if (str2 == null || "".equals(str2.trim())) {
			return str1;
		} else {
			if (separator == null || "".equals(separator)) {
				separator = ",";
			}
			return str1 + separator + str2;
		}
	}
	
	/**
	 * 连接连个ID字符串,并排除掉中间重复的ID
	 * @param separator	ID字符串中的分隔符,不传则默认为以","分隔
	 * @param str1	ID字符串1
	 * @param str2	ID字符串2
	 * @return	整合并去重后的id集合字符串
	 */
	public static String concatIdStrWithDistinct(String separator, String str1, String str2) {
		if (str1 == null && str2 == null) {
			return null;
		} else if (str1 == null || "".equals(str1.trim())) {
			return str2;
		} else if (str2 == null || "".equals(str2.trim())) {
			return str1;
		} else {
			if (separator == null || "".equals(separator)) {
				separator = ",";
			}
			Set<Long> idSet = new HashSet<Long>();
			String[] idArr1 = str1.split(separator);
			for (String idStr1 : idArr1) {
				idSet.add(Long.valueOf(idStr1));
			}
			String[] idArr2 = str2.split(separator);
			for (String idStr2 : idArr2) {
				idSet.add(Long.valueOf(idStr2));
			}
			
			String reStr = "";
			for (Long id : idSet) {
				if (!"".equals(reStr)) {
					reStr += separator;
				}
				reStr += id;
			}
			return reStr;
		}
	}
	
	/**
	 * 获取UUID
	 * @return	生成的UUID
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			System.out.println(getUUID());
		}
	}
	
	/**
	 * 返回结果对象
	 * @param response
	 * @param object
	 */
	public static void writeJsonP(HttpServletRequest request, HttpServletResponse response, String jsonStr) {
		PrintWriter out = null;
		try {
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			String callback = request.getParameter("callback");    
            String retStr = null;
            if (callback != null) {
            	retStr = callback + "("+jsonStr+");";
            } else {
            	retStr = jsonStr;
            }
			out.print(retStr);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param errorType	错误类型
	 * @param errorMsg	错误信息
	 */
	public static void setAjaxReturnErrorAndSendJsonP(HttpServletRequest request, HttpServletResponse response, String errorType, String errorMsg) {
		PrintWriter out = null;
		try {
			JSONObject jsObj = new JSONObject();
			jsObj.put("success", false);
			jsObj.put("errorType", errorType);
			jsObj.put("msg", errorMsg);
			String jsonStr = JSON.toJSONString(jsObj);
			
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			String callback = request.getParameter("callback");    
			String retStr = null;
            if (callback != null) {
            	retStr = callback + "("+jsonStr+");";
            } else {
            	retStr = jsonStr;
            }
			out.print(retStr);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 设置ajax请求返回的错误信息
	 * @param jsObj	要返回的JSONObject对象
	 * @param successMsg	成功信息
	 */
	public static void setAjaxReturnSuccessAndSendJsonP(HttpServletRequest request, HttpServletResponse response, String successMsg) {
		PrintWriter out = null;
		try {
			JSONObject jsObj = new JSONObject();
			jsObj.put("success", true);
			jsObj.put("msg", successMsg);
			String jsonStr = JSON.toJSONString(jsObj);
			
			response.setContentType("text/xml;charset=UTF-8"); 
		    response.setHeader("Pragma",   "no-cache");   //HTTP   1.0 
		    response.setDateHeader("Expires",   0);   //prevents   caching   at   the   proxy   server   
			out = response.getWriter();
			String callback = request.getParameter("callback");    
			String retStr = null;
            if (callback != null) {
            	retStr = callback + "("+jsonStr+");";
            } else {
            	retStr = jsonStr;
            }
			out.print(retStr);
			out.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				try {
					out.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	/**
	 * 得到一段时间内的字符串数组
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public static List<String> getDateList(Date startDate,Date endDate){
		List<String> dateList = new ArrayList<String>();
		Calendar dd = Calendar.getInstance();//定义日期实例
		dd.setTime(startDate);//设置日期起始时间
		do{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String dateStr = sdf.format(dd.getTime());
			dd.add(Calendar.DAY_OF_YEAR,1);
			dateList.add(dateStr);
		}while(dd.getTime().before(endDate));//判断是否到结束日期
		
		// 添加结束日期
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String endStr = sdf.format(endDate);
		dateList.add(endStr);
		
		return dateList;
	}
	
	/**
	 * 在某日添加几天
	 * @param date：某一日
	 * @param dayNum：添加的天数
	 * @return
	 */
	public static String addDay(Date date,int dayNum){
		
		Calendar dd = Calendar.getInstance();//定义日期实例
		dd.setTime(date);//设置日期起始时间
		dd.add(Calendar.DAY_OF_YEAR,dayNum);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String dayStr = sdf.format(dd.getTime());
		
		return dayStr;
	}
	
	/**
	 * 生成随机文件名，防止文件名重复
	 * @return
	 */
	public static String generatorFileName(){
		String fileName = String.valueOf(System.currentTimeMillis())+RandomStringUtils.randomNumeric(5);
		return fileName;
	} 
	
	public static String getRealPath(HttpServletRequest request,String path){
		return request.getSession().getServletContext().getRealPath(path);
	}
	
	/**
	 * 文件保存路径
	 * @param defaultPath
	 * @return
	 */
	public static String getSavePath(String defaultPath) {
		StringBuffer sb = new StringBuffer("");
		sb.append(defaultPath);
		sb.append(Calendar.getInstance().get(Calendar.YEAR));
		sb.append("/");
		sb.append(Calendar.getInstance().get(Calendar.MONTH) + 1);
		sb.append("/");
		sb.append(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
		sb.append("/");
		return sb.toString();
	}
}
