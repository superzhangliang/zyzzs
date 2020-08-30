package com.gdcy.zyzzs.pojo;

import java.util.List;

/**
 * 基础查询类
 * @author CHM
 *
 */
public class BasePage {

	private Integer page;
	
	private Integer offset;
	
	private Integer limit;
	
	private String searchKey;
	
	private Integer searchFlag;
	
	private String orderby;
	
	private String groupby;
	
	private String bank1;
	
	private String bank2;
	
	private String htmlStartDate;
	
	private String htmlEndDate;
	
	private List<Long> idList;
	
	private List<String> bankList1;
	
	private Long searchLong;
	
	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getOffset() {
		return offset;
	}

	public void setOffset(Integer offset) {
		this.offset = offset;
	}

	public Integer getLimit() {
		return limit;
	}

	public void setLimit(Integer limit) {
		this.limit = limit;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public Integer getSearchFlag() {
		return searchFlag;
	}

	public void setSearchFlag(Integer searchFlag) {
		this.searchFlag = searchFlag;
	}

	public String getOrderby() {
		return orderby;
	}

	public void setOrderby(String orderby) {
		this.orderby = orderby;
	}

	public String getGroupby() {
		return groupby;
	}

	public void setGroupby(String groupby) {
		this.groupby = groupby;
	}

	public String getBank1() {
		return bank1;
	}

	public void setBank1(String bank1) {
		this.bank1 = bank1;
	}

	public String getBank2() {
		return bank2;
	}

	public void setBank2(String bank2) {
		this.bank2 = bank2;
	}

	public String getHtmlStartDate() {
		return htmlStartDate;
	}

	public void setHtmlStartDate(String htmlStartDate) {
		this.htmlStartDate = htmlStartDate;
	}

	public String getHtmlEndDate() {
		return htmlEndDate;
	}

	public void setHtmlEndDate(String htmlEndDate) {
		this.htmlEndDate = htmlEndDate;
	}

	public List<Long> getIdList() {
		return idList;
	}

	public void setIdList(List<Long> idList) {
		this.idList = idList;
	}

	public List<String> getBankList1() {
		return bankList1;
	}

	public void setBankList1(List<String> bankList1) {
		this.bankList1 = bankList1;
	}

	public Long getSearchLong() {
		return searchLong;
	}

	public void setSearchLong(Long searchLong) {
		this.searchLong = searchLong;
	}
}
