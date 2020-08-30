package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class OriginInputsRecord extends BasePage{
    private Long id;

    private Long nodeId;

    private String prodBatchId;

    private Long inputsId;

    private Integer type;
    
    private Integer inputsType;

    private Date usedDate;
    
    private Double dailyConsumption;

    private Double amount;

    private Double weight;

    private String unit;

    private String principalId;

    private String principalName;

    private Integer isDelete;

    private Long addUserId;

    private Date addTime;

    private Long updateUserId;

    private Date updateTime;

    private Long deleteUserId;

    private Date deleteTime;
    
    private String inputsName;
    
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

    public String getProdBatchId() {
        return prodBatchId;
    }

    public void setProdBatchId(String prodBatchId) {
        this.prodBatchId = prodBatchId == null ? null : prodBatchId.trim();
    }

    public Long getInputsId() {
        return inputsId;
    }

    public void setInputsId(Long inputsId) {
        this.inputsId = inputsId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Date getUsedDate() {
        return usedDate;
    }

    public void setUsedDate(Date usedDate) {
        this.usedDate = usedDate;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit == null ? null : unit.trim();
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
    
    public String getInputsName() {
    	return inputsName;
    }
    
    public void setInputsName(String inputsName) {
    	this.inputsName = inputsName == null ? null : inputsName.trim();
    }
    
    public Integer getIsReport() {
    	return isReport;
    }
    
    public void setIsReport(Integer isReport) {
    	this.isReport = isReport;
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

	public Double getDailyConsumption() {
		return dailyConsumption;
	}

	public void setDailyConsumption(Double dailyConsumption) {
		this.dailyConsumption = dailyConsumption;
	}

	public Integer getInputsType() {
		return inputsType;
	}

	public void setInputsType(Integer inputsType) {
		this.inputsType = inputsType;
	}
    
}