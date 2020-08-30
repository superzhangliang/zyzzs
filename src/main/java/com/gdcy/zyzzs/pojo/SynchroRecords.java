package com.gdcy.zyzzs.pojo;

import java.util.Date;

public class SynchroRecords extends BasePage{
    private Long id;

    private Date createTime;

    private Integer state;

    private String methodName;

    private String records;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName == null ? null : methodName.trim();
    }

    public String getRecords() {
        return records;
    }

    public void setRecords(String records) {
        this.records = records == null ? null : records.trim();
    }
}