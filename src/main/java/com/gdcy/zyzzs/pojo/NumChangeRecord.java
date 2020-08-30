package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class NumChangeRecord extends BasePage{
    private Long id;

    private Long nodeId;

    private Integer flag;

    private Long pId;

    private Double num;
    
    private String prodBatchId;
    
    private String reason;
    
    private String purchaseBatchId;
    
    private Date addTime;
    
    private Date updateTime;

    private Integer isDelete;
    
    private String unit;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getFlag() {
		return flag;
	}

	public void setFlag(Integer flag) {
		this.flag = flag;
	}

	public Long getpId() {
		return pId;
	}

	public void setpId(Long pId) {
		this.pId = pId;
	}

	public Double getNum() {
		return num;
	}

	public void setNum(Double num) {
		this.num = num;
	}


	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public Date getAddTime() {
		return addTime;
	}

	public void setAddTime(Date addTime) {
		this.addTime = addTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Integer getIsDelete() {
		return isDelete;
	}

	public void setIsDelete(Integer isDelete) {
		this.isDelete = isDelete;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public Long getNodeId() {
		return nodeId;
	}

	public void setNodeId(Long nodeId) {
		this.nodeId = nodeId;
	}

	public String getProdBatchId() {
		return prodBatchId;
	}

	public void setProdBatchId(String prodBatchId) {
		this.prodBatchId = prodBatchId;
	}

	public String getPurchaseBatchId() {
		return purchaseBatchId;
	}

	public void setPurchaseBatchId(String purchaseBatchId) {
		this.purchaseBatchId = purchaseBatchId;
	}
    
	
}