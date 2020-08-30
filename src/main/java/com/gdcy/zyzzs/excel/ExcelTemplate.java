package com.gdcy.zyzzs.excel;

import java.io.Serializable;

import com.alibaba.fastjson.JSONObject;

/**
 * XML模板類
 * 
 * @author 黃枝良
 * 
 */
public class ExcelTemplate implements Serializable {

	private static final long serialVersionUID = -7088577294603137338L;
	private String name;
	private String cnname;
	private String type;
	private String defaltValue;
	private String handleClass;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCnname() {
		return cnname;
	}

	public void setCnname(String cnname) {
		this.cnname = cnname;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDefaltValue() {
		return defaltValue;
	}

	public void setDefaltValue(String defaltValue) {
		this.defaltValue = defaltValue;
	}

	public String getHandleClass() {
		return handleClass;
	}

	public void setHandleClass(String handleClass) {
		this.handleClass = handleClass;
	}

	@Override
	public String toString() {
		JSONObject json = (JSONObject) JSONObject.toJSON(this);
		return json.toJSONString();
	}
}
