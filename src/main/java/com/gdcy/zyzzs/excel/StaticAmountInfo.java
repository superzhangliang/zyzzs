package com.gdcy.zyzzs.excel;

import java.util.Date;

public class StaticAmountInfo implements java.io.Serializable{

	/**
	 * 统计进场金额，销售金额，利润导出类
	 */
	private static final long serialVersionUID = 1L;
	
	private Date inTime;
	
	private Integer totalAmount;
	
	private Integer saleAmount;
	
	private Integer profitAmount;

	public Date getInTime() {
		return inTime;
	}

	public void setInTime(Date inTime) {
		this.inTime = inTime;
	}

	public Integer getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Integer totalAmount) {
		this.totalAmount = totalAmount;
	}

	public Integer getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(Integer saleAmount) {
		this.saleAmount = saleAmount;
	}

	public Integer getProfitAmount() {
		return profitAmount;
	}

	public void setProfitAmount(Integer profitAmount) {
		this.profitAmount = profitAmount;
	}
	
}
