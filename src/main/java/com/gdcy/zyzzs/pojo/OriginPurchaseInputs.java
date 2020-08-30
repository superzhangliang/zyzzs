package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class OriginPurchaseInputs extends BasePage{
    private Long id;

    private Long nodeId;

    private Long pId;
    
    private Integer type;
    
    private String code;

    private String name;
    
    private Integer purchaseType;

    private Integer sourceType;

    private Integer upperReaches;

    private String purchaseBatchId;

    private Date purchaseDate;

    private Integer organicFlag;

    private Integer transgenicFlag;

    private String principalId;

    private String principalName;

    private Double purchaseAmount;

    private Double purchasePrice;

    private String purchaseUnit;

    private Double totalWeight;

    private Date manufacturerDate;

    private Integer result;

    private Date periodDate;

    private String manufacturerId;

    private String manufacturerName;

    private String license;

    private Long supplierId;
    
    private String supplierRegId;

    private String supplierName;

    private Integer isDelete;

    private Long addUserId;

    private Date addTime;

    private Long updateUserId;

    private Date updateTime;

    private Long deleteUserId;

    private Date deleteTime;
    
    private Integer isReport;
    
    private Double allNum;

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

    public Long getpId() {
		return pId;
	}

	public void setpId(Long pId) {
		this.pId = pId;
	}

	public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getSourceType() {
        return sourceType;
    }

    public void setSourceType(Integer sourceType) {
        this.sourceType = sourceType;
    }

    public Integer getUpperReaches() {
        return upperReaches;
    }

    public void setUpperReaches(Integer upperReaches) {
        this.upperReaches = upperReaches;
    }

    public String getPurchaseBatchId() {
		return purchaseBatchId;
	}

	public void setPurchaseBatchId(String purchaseBatchId) {
		this.purchaseBatchId = purchaseBatchId;
	}

	public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public Integer getOrganicFlag() {
        return organicFlag;
    }

    public void setOrganicFlag(Integer organicFlag) {
        this.organicFlag = organicFlag;
    }

    public Integer getTransgenicFlag() {
        return transgenicFlag;
    }

    public void setTransgenicFlag(Integer transgenicFlag) {
        this.transgenicFlag = transgenicFlag;
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

    public Double getPurchaseAmount() {
        return purchaseAmount;
    }

    public void setPurchaseAmount(Double purchaseAmount) {
        this.purchaseAmount = purchaseAmount;
    }

    public Double getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(Double purchasePrice) {
        this.purchasePrice = purchasePrice;
    }

    public String getPurchaseUnit() {
        return purchaseUnit;
    }

    public void setPurchaseUnit(String purchaseUnit) {
        this.purchaseUnit = purchaseUnit == null ? null : purchaseUnit.trim();
    }

    public Double getTotalWeight() {
        return totalWeight;
    }

    public void setTotalWeight(Double totalWeight) {
        this.totalWeight = totalWeight;
    }

    public Date getManufacturerDate() {
        return manufacturerDate;
    }

    public void setManufacturerDate(Date manufacturerDate) {
        this.manufacturerDate = manufacturerDate;
    }

    public Integer getResult() {
        return result;
    }

    public void setResult(Integer result) {
        this.result = result;
    }

    public Date getPeriodDate() {
        return periodDate;
    }

    public void setPeriodDate(Date periodDate) {
        this.periodDate = periodDate;
    }

    public String getManufacturerId() {
        return manufacturerId;
    }

    public void setManufacturerId(String manufacturerId) {
        this.manufacturerId = manufacturerId == null ? null : manufacturerId.trim();
    }

    public String getManufacturerName() {
        return manufacturerName;
    }

    public void setManufacturerName(String manufacturerName) {
        this.manufacturerName = manufacturerName == null ? null : manufacturerName.trim();
    }

    public String getLicense() {
        return license;
    }

    public void setLicense(String license) {
        this.license = license == null ? null : license.trim();
    }

    public Long getSupplierId() {
		return supplierId;
	}

	public void setSupplierId(Long supplierId) {
		this.supplierId = supplierId;
	}

	public String getSupplierName() {
		return supplierName;
	}

	public void setSupplierName(String supplierName) {
        this.supplierName = supplierName == null ? null : supplierName.trim();
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

	public Integer getPurchaseType() {
		return purchaseType;
	}

	public void setPurchaseType(Integer purchaseType) {
		this.purchaseType = purchaseType;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getSupplierRegId() {
		return supplierRegId;
	}

	public void setSupplierRegId(String supplierRegId) {
		this.supplierRegId = supplierRegId;
	}

	public Double getAllNum() {
		return allNum;
	}

	public void setAllNum(Double allNum) {
		this.allNum = allNum;
	}

	public Integer getIsReport() {
		return isReport;
	}

	public void setIsReport(Integer isReport) {
		this.isReport = isReport;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}
    
}