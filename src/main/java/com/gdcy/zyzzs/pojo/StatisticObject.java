package com.gdcy.zyzzs.pojo;

public class StatisticObject extends BasePage{
	
	private Long nodeId;//节点Id
	
	private Integer type;//商品类型
    
    private String statisticType;//统计类型
    
    private String showWay;//展示方式：table-表格；line-线形图
    
    private String prodIds;//产品Id集合
    
	public Long getNodeId() {
		return nodeId;
	}

	public void setNodeId(Long nodeId) {
		this.nodeId = nodeId;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getStatisticType() {
		return statisticType;
	}

	public void setStatisticType(String statisticType) {
		this.statisticType = statisticType;
	}

	public String getShowWay() {
		return showWay;
	}

	public void setShowWay(String showWay) {
		this.showWay = showWay;
	}

	public String getProdIds() {
		return prodIds;
	}

	public void setProdIds(String prodIds) {
		this.prodIds = prodIds;
	}

}