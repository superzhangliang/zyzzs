package com.gdcy.zyzzs.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Excel導入類型轉換
 * @author 
 *
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class TransformationUtil {

	public static List StringToDate(String value) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date dateval = null;
		List val = new ArrayList();
		try {
			dateval = sdf.parse(value);
			val.add(dateval);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return val;
	}
	public static List ReverseStringToDate(String value) {
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
		List val = new ArrayList();
		try {
			dateval = sdf.parse(sb.toString());
			val.add(dateval);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return val;
	}
	public static List StringToDateTime(String value) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
		Date dateval = null;
		List val = new ArrayList();
		try {
			dateval = sdf.parse(value);
			val.add(dateval);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return val;
	}

	public static List StringToInt(String value) {
		if(value.contains(".")){
			String[] v = (value.trim()).split(".");
			if(v.length>1){
				value=v[0];
			}
		}
		List val = new ArrayList();
		val.add(Integer.parseInt(value));
		return val;
	}

	public static List StringToLong(String value) {
		if(value.contains(".")){
			String[] v = (value.trim()).split(".");
			if(v.length>1){
				value=v[0];
			}
		}
		List val = new ArrayList();
		val.add(Long.parseLong(value));
		return val;
	}
	public static List StringToDouble(String value) {
		List val = new ArrayList();
		val.add(Double.parseDouble(value));
		return val;
	}
	
}
