package com.gdcy.zyzzs.util;

import java.util.Properties;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

public class PropertiesUtil {

	public static final String PROP_CONSTANTS_FILE = "constants.properties";

	public static Object getProperty(String propName, String propFile) {
		Resource resource = new ClassPathResource(propFile);
		Properties props=null;
		try{
			props = PropertiesLoaderUtils.loadProperties(resource);
		}catch (Exception e) {
			return null;
		}
		return props.get(propName);
	}
	
	/**
	 * 默認讀取constants.properties文件中的屬性值
	 * @param propName
	 * @return
	 */
	public static String getProperty(String propName){
		Resource resource = new ClassPathResource(PROP_CONSTANTS_FILE);
		Properties props=null;
		try{
			props = PropertiesLoaderUtils.loadProperties(resource);
		}catch (Exception e) {
			return null;
		}
		return (String)props.get(propName);
	}

}
