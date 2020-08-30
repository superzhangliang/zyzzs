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
public class NumberHandler implements IReportHandler<String> {

	public NumberHandler() {
	}

	@Override
	public List transFormation(String value,String type) {
		List datelist = null;
			if(type.equals("int")){
				datelist =  TransformationUtil.StringToInt(value);
			}
			if(type.equals("bigint")){
				datelist =  TransformationUtil.StringToLong(value);
			}
			if(type.equals("double")){
				datelist =  TransformationUtil.StringToDouble(value);
			}
		return datelist;
	}

//	@Override
//	public T2 transFormation(T1 value) {
//		return null;
//	}

}
