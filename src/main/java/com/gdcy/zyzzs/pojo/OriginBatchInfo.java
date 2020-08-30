package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class OriginBatchInfo extends BasePage{
    private Long id;

    private Long nodeId;

    private Integer type;

    private Date prodStartDate;

    private Double acreage;

    private Double qty;
    
    private String unit;

    private Long prodId;

    private String prodBatchId;

    private Integer isDelete;
    
    private String principalId;

    private String principalName;

    private Long addUserId;

    private Date addTime;

    private Long updateUserId;

    private Date updateTime;

    private Long deleteUserId;

    private Date deleteTime;
    
    private String prodName;
    
    private Integer isReport;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public Date getProdStartDate() {
        return prodStartDate;
    }

    public void setProdStartDate(Date prodStartDate) {
        this.prodStartDate = prodStartDate;
    }

    public Double getAcreage() {
        return acreage;
    }

    public void setAcreage(Double acreage) {
        this.acreage = acreage;
    }

    public Double getQty() {
        return qty;
    }

    public void setQty(Double qty) {
        this.qty = qty;
    }

    public Long getProdId() {
        return prodId;
    }

    public void setProdId(Long prodId) {
        this.prodId = prodId;
    }

    public String getProdBatchId() {
        return prodBatchId;
    }

    public void setProdBatchId(String prodBatchId) {
        this.prodBatchId = prodBatchId == null ? null : prodBatchId.trim();
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }

    public Long getAddUserId() {
        return addUserId;
    }

    public void setAddUserId(Long addUserId) {
        this.addUserId = addUserId;
    }

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }

    public Long getUpdateUserId() {
        return updateUserId;
    }

    public void setUpdateUserId(Long updateUserId) {
        this.updateUserId = updateUserId;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Long getDeleteUserId() {
        return deleteUserId;
    }

    public void setDeleteUserId(Long deleteUserId) {
        this.deleteUserId = deleteUserId;
    }

    public Date getDeleteTime() {
        return deleteTime;
    }

    public void setDeleteTime(Date deleteTime) {
        this.deleteTime = deleteTime;
    }
    
    public String getProdName() {
    	return prodName;
    }
    
    public void setProdName(String prodName) {
    	this.prodName = prodName == null ? null : prodName.trim();
    }
    
    public Integer getIsReport() {
    	return isReport;
    }
    
    public void setIsReport(Integer isReport) {
    	this.isReport = isReport;
    }

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getPrincipalId() {
		return principalId;
	}

	public void setPrincipalId(String principalId) {
		this.principalId = principalId;
	}

	public String getPrincipalName() {
		return principalName;
	}

	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}
    
}