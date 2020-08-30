package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class Business extends BasePage{
    private Long id;

    private String code;

    private String name;

    private String regId;

    private String property;

    private Integer type;

    private Date recordDate;

    private String legalRepresent;
    
    private String addr;

    private String tel;

    private Long nodeId;

    private Integer isDelete;
    
    private Integer markType;

    private Date addTime;

    private Date updateTime;

    private Date deleteTime;
    
    private String markTypeStrs;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code == null ? null : code.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId == null ? null : regId.trim();
    }

    public String getProperty() {
        return property;
    }

    public void setProperty(String property) {
        this.property = property == null ? null : property.trim();
    }

    public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public Date getRecordDate() {
        return recordDate;
    }

    public void setRecordDate(Date recordDate) {
        this.recordDate = recordDate;
    }

    public String getLegalRepresent() {
        return legalRepresent;
    }

    public void setLegalRepresent(String legalRepresent) {
        this.legalRepresent = legalRepresent == null ? null : legalRepresent.trim();
    }

    public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel == null ? null : tel.trim();
    }

    public Long getNodeId() {
        return nodeId;
    }

    public void setNodeId(Long nodeId) {
        this.nodeId = nodeId;
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }

    public Integer getMarkType() {
		return markType;
	}

	public void setMarkType(Integer markType) {
		this.markType = markType;
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

    public Date getDeleteTime() {
        return deleteTime;
    }

    public void setDeleteTime(Date deleteTime) {
        this.deleteTime = deleteTime;
    }

	public String getMarkTypeStrs() {
		return markTypeStrs;
	}

	public void setMarkTypeStrs(String markTypeStrs) {
		this.markTypeStrs = markTypeStrs;
	}
}