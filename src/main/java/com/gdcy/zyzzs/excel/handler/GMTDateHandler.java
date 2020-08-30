package com.gdcy.zyzzs.excel.handler;

import com.gdcy.zyzzs.util.DateUtil;

/**
 * GMT時間轉換處理類
 * 
 * @author 黃枝良
 * 
 */
public class GMTDateHandler implements IExcelHandler {

	public GMTDateHandler() {
	}

	public String execute(String value) {
		return DateUtil.transferGMT(value, null);
	}

}
