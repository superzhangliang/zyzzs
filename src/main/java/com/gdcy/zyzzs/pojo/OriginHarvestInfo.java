package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class OriginHarvestInfo extends BasePage{
    private Long id;

    private Long nodeId;

    private Integer type;

    private String prodBatchId;

    private String harvestBatchId;

    private Date harvestDate;

    private Double amount;

    private Double weight;

    private String unit;

    private Long prodId;
    
    private String prodName;

    private String result;

    private String sheetNo;

    private String principalId;

    private String principalName;

    private Integer isDelete;

    private Long addUserId;

    private Date addTime;

    private Long updateUserId;

    private Date updateTime;

    private Long deleteUserId;

    private Date deleteTime;

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

    public String getProdBatchId() {
        return prodBatchId;
    }

    public void setProdBatchId(String prodBatchId) {
        this.prodBatchId = prodBatchId == null ? null : prodBatchId.trim();
    }

    public String getHarvestBatchId() {
        return harvestBatchId;
    }

    public void setHarvestBatchId(String harvestBatchId) {
        this.harvestBatchId = harvestBatchId == null ? null : harvestBatchId.trim();
    }

    public Date getHarvestDate() {
        return harvestDate;
    }

    public void setHarvestDate(Date harvestDate) {
        this.harvestDate = harvestDate;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit == null ? null : unit.trim();
    }

    public Long getProdId() {
        return prodId;
    }

    public void setProdId(Long prodId) {
        this.prodId = prodId;
    }

    public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getSheetNo() {
        return sheetNo;
    }

    public void setSheetNo(String sheetNo) {
        this.sheetNo = sheetNo == null ? null : sheetNo.trim();
    }

    public String getPrincipalId() {
        return principalId;
    }

    public void setPrincipalId(String principalId) {
        this.principalId = principalId == null ? null : principalId.trim();
    }

    public String getPrincipalName() {
        return principalName;
    }

    public void setPrincipalName(String principalName) {
        this.principalName = principalName == null ? null : principalName.trim();
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

    public Integer getIsReport() {
        return isReport;
    }

    public void setIsReport(Integer isReport) {
        this.isReport = isReport;
    }

	public String getProdName() {
		return prodName;
	}

	public void setProdName(String prodName) {
		this.prodName = prodName;
	}
    
}