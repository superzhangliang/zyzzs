package com.gdcy.zyzzs.excel;

import java.util.Date;

public class StaticInfo implements java.io.Serializable{

	/**
	 * 统计屠宰数量导出类
	 */
	private static final long serialVersionUID = 1L;
	
	private Date inTime;
	private Integer allowNumTotal;
	public Date getInTime() {
		return inTime;
	}
	public void setInTime(Date inTime) {
		this.inTime = inTime;
	}
	public Integer getAllowNumTotal() {
		return allowNumTotal;
	}
	public void setAllowNumTotal(Integer allowNumTotal) {
		this.allowNumTotal = allowNumTotal;
	}
	
}
