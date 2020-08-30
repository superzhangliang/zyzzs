package com.gdcy.zyzzs.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.gdcy.zyzzs.excel.export.ParseConstans;

/**
 * 字符串工具類
 * @author 黃枝良
 *
 */
public class StringUtil {

	/**
	 * 判斷字符串是否全為空
	 * @param strs
	 * @return
	 */
	public static boolean isAllEmpty(String ...strs){
		for(String s:strs){
			if(!isEmpty(s)) return  false;
		}
		return true;
	}
	
	/**
	 * 判斷字符串數組中是否存在一個為空
	 * @param strs
	 * @return
	 */
	public static boolean isOneEmpty(String ...strs){
		for(String s:strs){
			if(isEmpty(s)) return true;
		}
		return false;
	}
	
	/**
	 * 判斷字符串數組中是否存在一個不為空
	 * @param strs
	 * @return
	 */
	public static boolean isOneNotEmpty(String ...strs){
		for(String s:strs){
			if(!isEmpty(s)) return true;
		}
		return false;
	}
	
	/**
	 * 判斷字符串是否全不為空
	 * @param strs
	 * @return
	 */
	public static boolean isAllNotEmpty(String ...strs){
		for(String s:strs){
			if(isEmpty(s)) return false;
		}
		return true;
	}
	
	/**
	 * 判斷字符串是否為空
	 * @param s
	 * @return
	 */
	public static boolean isEmpty(String s){
		if(null==s||"".equals(s.trim())) return true;
		return false;
	}
	
	public static Date stringToDate(String value){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
		Date dateval = null;
		try {
			dateval = sdf.parse(value);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		 return dateval;
	}
	public static Date stringToDateTime(String value) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
		Date dateval = null;
		try {
			dateval = sdf.parse(value);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		 return dateval;
	}
	
	public static String dateTimeToString(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return  sdf.format(date);
	}
	/**
	 * dd/MM/yyyy格式化為yyyy-MM-dd
	 * @param value
	 * @return
	 */
	public static Date ReverseStringToDate(String value) {
		String[] v = value.split("/");
		StringBuffer sb = new StringBuffer();
		for(int i=(v.length-1);i>=0;i--){
			sb.append(v[i]);
			if(i>0){
				sb.append("-");
			}
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date dateval = null;
		try {
			dateval = sdf.parse(sb.toString());
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return dateval;
	}
	
	public static String transFormation(String val){
		String value="0";
		if(val.equals(ParseConstans.STATE_WOMEN)){
			value="1";
		}
		return value;
	}

	public static int stringToInt(String value) {
		return Integer.parseInt(value);
	}

	/**
	 * 不足16位则补0
	 * @param string 字符
	 * @return
	 */
	public static String fixZero(String string){
		int strLen = string.length();
		int len = 16 - strLen ;
		if (len > 0) {
			StringBuffer sb = new StringBuffer();
			for(int i = 0;i < len; i++){
				sb.append("0");
			}
			return sb.append(string).toString();
		}
		return string;
	}
	
}
