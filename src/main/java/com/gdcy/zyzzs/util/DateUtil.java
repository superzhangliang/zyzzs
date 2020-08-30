package com.gdcy.zyzzs.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtil {

	/**
	 * 獲取系統當前時間
	 * @return
	 */
	public static Date getCurrentDate(){
		return Calendar.getInstance().getTime();
	}
	
	/**
	 * 獲取系統當前日期時間格式化字符串
	 * @param format
	 * @return
	 */
	public static String getCurrentDate(String format){
		String date = "";
		SimpleDateFormat sdf = null;
		if (format != null && !"".equals(format.trim())) {
			sdf = new SimpleDateFormat(format);
		} else {
			sdf = new SimpleDateFormat("yyyy-MM-dd");
		}
		date = sdf.format(Calendar.getInstance().getTime());      
		return date;
	}
	/**
	 * 將類似 Mon Feb 13 08:00:00 GMT+08:00 2015格式的GMT時間格式化
	 * @param gmt
	 * @param format
	 * @return
	 */
	public static String transferGMT(String gmt,String format){
		SimpleDateFormat gmtFormat = new SimpleDateFormat("EEE MMM dd hh:mm:ss z yyyy", Locale.ENGLISH);
		String dateString=null;
		try {
			Date date = gmtFormat.parse(gmt);
			SimpleDateFormat sdf = null;
			if (format != null && !"".equals(format.trim())) {
				sdf=new SimpleDateFormat(format);
			}else {
				sdf = new SimpleDateFormat("yyyy-MM-dd");
			}
			dateString=sdf.format(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return dateString;
	}
	
	/**
	 * 格式化日期輸出字符串
	 * @param date
	 * @param format
	 * @return
	 */
	public static String format(Date date,String format){
		SimpleDateFormat sdf = null;
		if(StringUtil.isEmpty(format)){
			sdf = new SimpleDateFormat("yyyy-MM-dd");
		}else{
			sdf=new SimpleDateFormat(format);
		}
		if(date==null) return null;
		return sdf.format(date);
	}
	
	/**
	 * 只輸出年月日
	 * @param date
	 * @return
	 */
	public static String onlyDate(Date date){
		SimpleDateFormat myFormat=new SimpleDateFormat("yyyy-MM-dd");
		return myFormat.format(date);
	}
	
	/**
	 * 比較兩個日期的大小，date1>date2返回2；date1<date2返回1；date1=date2返回0
	 * @param date1
	 * @param date2
	 * @return
	 */
	public static Integer compare(String date1,String date2){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date d1;
		try {
			d1 = sdf.parse(date1);
			Date d2=sdf.parse(date2);
			if(d1.getTime()>d2.getTime()) return 2;
			else if(d1.getTime()<d2.getTime()) return 1;
			else return 0;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 格式化字符串輸出日期
	 * @param str
	 * @return
	 */
	public static Date stringToDate(String dateString){
		Date date = null;
		try {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date = sdf.parse(dateString);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	
	/**
	 * 日期增加或减少几日
	 * @param dateString
	 * @return 
	 */
	public static String dateAddOrMenusDay(String dateString,int day){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date dt;
		String reStr = null;
		try {
			dt = sdf.parse(dateString);
			Calendar rightNow = Calendar.getInstance();
			rightNow.setTime(dt);
			rightNow.add(Calendar.DAY_OF_YEAR,day);//日期加减几天
			Date dt1=rightNow.getTime();
			reStr = sdf.format(dt1);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return reStr;
	}
}
