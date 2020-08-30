package com.gdcy.zyzzs.ticket;
/**
 * 商品信息类
 * @author hwz
 *
 */
public class Commodity {
	// 商品名称  
    private String name;  
    // 单价  
    private String unitPrice;  
    // 数量  
    private String num;  
    // 小计  
    private String sum; 
    
    public Commodity(String name, String unitPrice, String num, String sum) {  
        super();  
        this.name = name;  
        this.unitPrice = unitPrice;  
        this.num = num;  
        this.sum = sum;  
    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(String unitPrice) {
		this.unitPrice = unitPrice;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getSum() {
		return sum;
	}

	public void setSum(String sum) {
		this.sum = sum;
	}

}
