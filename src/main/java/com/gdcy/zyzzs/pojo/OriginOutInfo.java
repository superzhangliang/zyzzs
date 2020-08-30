package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class OriginOutInfo extends BasePage{
	private Long id;

    private Long nodeId;

    private Integer type;

    private Date outDate;

    private String prodBatchId;

    private String harvestBatchId;

    private Long prodId;
    
    private String prodName;

    private Double qty;

    private Double weight;

    private Double price;

    private String destCode;

    private String dest;

    private String transporterId;

    private String quarantineId;

    private String traceCode;

    private String logisticsCode;

    private Long buyerId;

    private String buyerName;

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

    public Date getOutDate() {
        return outDate;
    }

    public void setOutDate(Date outDate) {
        this.outDate = outDate;
    }

    public String getProdBatchId() {
        return prodBatchId;
    }

    public void setProdBatchId(String prodBatchId) {
        this.prodBatchId = prodBatchId == null ? null : prodBatchId.trim();
    }

    public Long getProdId() {
        return prodId;
    }

    public void setProdId(Long prodId) {
        this.prodId = prodId;
    }

    public Double getQty() {
        return qty;
    }

    public void setQty(Double qty) {
        this.qty = qty;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public String getDest() {
        return dest;
    }

    public void setDest(String dest) {
        this.dest = dest == null ? null : dest.trim();
    }

    public String getTransporterId() {
        return transporterId;
    }

    public void setTransporterId(String transporterId) {
        this.transporterId = transporterId == null ? null : transporterId.trim();
    }

    public String getQuarantineId() {
        return quarantineId;
    }

    public void setQuarantineId(String quarantineId) {
        this.quarantineId = quarantineId == null ? null : quarantineId.trim();
    }

    public String getTraceCode() {
        return traceCode;
    }

    public void setTraceCode(String traceCode) {
        this.traceCode = traceCode == null ? null : traceCode.trim();
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
    
    public Double getPrice() {
    	return price;
    }
    
    public void setPrice(Double price) {
    	this.price = price;
    }
    
    public Integer getIsReport() {
    	return isReport;
    }
    
    public void setIsReport(Integer isReport) {
    	this.isReport = isReport;
    }

	public String getHarvestBatchId() {
		return harvestBatchId;
	}

	public void setHarvestBatchId(String harvestBatchId) {
		this.harvestBatchId = harvestBatchId;
	}

	public String getDestCode() {
		return destCode;
	}

	public void setDestCode(String destCode) {
		this.destCode = destCode;
	}

	public String getLogisticsCode() {
		return logisticsCode;
	}

	public void setLogisticsCode(String logisticsCode) {
		this.logisticsCode = logisticsCode;
	}

	public Long getBuyerId() {
		return buyerId;
	}

	public void setBuyerId(Long buyerId) {
		this.buyerId = buyerId;
	}

	public String getBuyerName() {
		return buyerName;
	}

	public void setBuyerName(String buyerName) {
		this.buyerName = buyerName;
	}
    
}