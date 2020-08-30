package com.gdcy.zyzzs.pojo;

import java.util.Date;
import java.util.List;

public class PrintContent {
	
	private String nodeName;//商品名
	
	private List<Collect> collects;//单价
	
	private String num;//件数
	
	private String sum;//合计
	
	private String codeContent;//二维码内容
	
	private String code;//追溯码
	
	private Date outDate; //交易日期
	
	public String getNodeName() {
		return nodeName;
	}

	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}

	public List<Collect> getCollects() {
		return collects;
	}

	public void setCollects(List<Collect> collects) {
		this.collects = collects;
	}

	public String getSum() {
		return sum;
	}

	public void setSum(String sum) {
		this.sum = sum;
	}

	public String getCodeContent() {
		return codeContent;
	}

	public void setCodeContent(String codeContent) {
		this.codeContent = codeContent;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}
	
	public Date getOutDate() {
        return outDate;
    }

    public void setOutDate(Date outDate) {
        this.outDate = outDate;
    }
	
}
