package com.gdcy.zyzzs.excel.export.handler;

import java.util.List;

import com.gdcy.zyzzs.util.TransformationUtil;

/**
 * 字符轉換轉換處理類
 * 
 * @author
 * 
 */
@SuppressWarnings("rawtypes")
public class DateHandler implements IReportHandler<String> {

	public DateHandler() {
	}

	@Override
	public List transFormation(String value,String type) {
		List datelist = null;
			if(type.equals("date")){
				datelist =  TransformationUtil.StringToDate(value);
			}
			if(type.equals("datetime")){
				datelist =  TransformationUtil.StringToDateTime(value);
			}
			if(type.equals("reversedate")){
				datelist =  TransformationUtil.ReverseStringToDate(value);
			}
		return datelist;
	}

//	@Override
//	public T2 transFormation(T1 value) {
//		return null;
//	}

}
