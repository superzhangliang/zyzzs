package com.gdcy.zyzzs.pojo;

public class Collect {
	
	private String name;//商品名
	
	private String sell;//单价
	
	private String num;//数量
	
	private String weight; //重量
	
	private String total;//小计

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSell() {
		return sell;
	}

	public void setSell(String sell) {
		this.sell = sell;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}
	
	public String getWeight() {
		return weight;
	}
	
	public void setWeight(String weight) {
		this.weight = weight;
	}
	
}
