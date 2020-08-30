package com.gdcy.zyzzs.ticket;

public class Collect {

	private String name;//商品名
	
	private Double sell;//单价
	
	private Double num;//数量
	
	private Double total;//小计
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Double getSell() {
		return sell;
	}

	public void setSell(Double sell) {
		this.sell = sell;
	}

	public Double getNum() {
		return num;
	}

	public void setNum(Double num) {
		this.num = num;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

}
