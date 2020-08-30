package com.gdcy.zyzzs.ticket;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.util.ArrayList;
import java.util.Calendar;

public class SalesTicket implements Printable {
	
	private ArrayList<Commodity> list; 
    private PrintModel pm;// 图片信息
    private String nodeName;  // 节点名称  
    private String saleNum;  // 商品总数
    private String saleSum;  // 总金额  
    private String code; //条码
    private Font font;  
    
 // 构造函数  
    public SalesTicket(ArrayList<Commodity> list,PrintModel pm, String nodeName, String saleNum, String saleSum,String code) {  
        this.list = list;  
        this.pm = pm;
        this.nodeName = nodeName;  
        this.saleNum = saleNum;  
        this.saleSum = saleSum; 
        this.code = code;
    }
    
    /** 
     * @param Graphic指明打印的图形环境 
     * @param PageFormat指明打印页格式（页面大小以点为计量单位，1点为1英才的1/72，1英寸为25.4毫米。A4纸大致为595× 
     *            842点） 
     * @param pageIndex指明页号 
     **/
	@Override
	public int print(Graphics graphics, PageFormat pageFormat, int pageIndex)
			throws PrinterException {
		 Component c = null;  
        // 转换成Graphics2D 拿到画笔  
        Graphics2D g2 = (Graphics2D) graphics;  
        // 设置打印颜色为黑色  
        g2.setColor(Color.black);  
  
        // 打印起点坐标  
        double x = pageFormat.getImageableX();  
        double y = pageFormat.getImageableY();  
  
        // 虚线  
        float[] dash1 = { 4.0f };  
        // width - 此 BasicStroke 的宽度。此宽度必须大于或等于 0.0f。如果将宽度设置为  
        // 0.0f，则将笔划呈现为可用于目标设备和抗锯齿提示设置的最细线条。  
        // cap - BasicStroke 端点的装饰  
        // join - 应用在路径线段交汇处的装饰  
        // miterlimit - 斜接处的剪裁限制。miterlimit 必须大于或等于 1.0f。  
        // dash - 表示虚线模式的数组  
        // dash_phase - 开始虚线模式的偏移量  
  
        // 设置画虚线  
        g2.setStroke(new BasicStroke(0.5f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER, 4.0f, dash1, 0.0f));  
  
        // 设置打印字体（字体名称、样式和点大小）（字体名称可以是物理或者逻辑名称）  
        font = new Font("宋体", Font.PLAIN, 11);  
        g2.setFont(font);// 设置字体  
        float heigth = font.getSize2D();// 字体高度  
        // 标题  
        g2.drawString("交易信息", (float) x+50, (float) y + heigth);  
        float line = 2 * heigth;  
  
        font = new Font("宋体", Font.PLAIN, 8);  
        g2.setFont(font);// 设置字体  
        heigth = font.getSize2D();// 字体高度  
        
        line += heigth; 
        // 显示节点名称 
        if(nodeName.length()>12){
        	g2.drawString("企业名称:" + nodeName.substring(0, 12), (float) x+6, (float) y + line);  
            line += heigth;
            g2.drawString(nodeName.substring(12), (float) x+6, (float) y + line);  
            line += heigth;
        }else{
        	g2.drawString("企业名称:" + nodeName, (float) x+6, (float) y + line);  
            line += heigth; 
        }
        // 显示时间
        g2.drawString("交易时间:" + Calendar.getInstance().getTime().toLocaleString(), (float) x+6, (float) y + line);  
        line += heigth;  
        g2.drawLine((int) x, (int) (y + line), (int) x + 180, (int) (y + line)); 
        line += 10;  
        // 显示标题  
        g2.drawString("名称", (float) x + 10, (float) y + line);  
        g2.drawString("单价", (float) x + 50, (float) y + line);  
        g2.drawString("数量", (float) x + 80, (float) y + line);  
        g2.drawString("小计", (float) x + 105, (float) y + line);  
        line += heigth;
        // 显示内容  
        for (int i = 0; i < list.size(); i++) {  
  
            Commodity commodity = list.get(i);  
            if(commodity.getName().length()>5){
            	g2.drawString(commodity.getName(), (float) x + 6, (float) y + line);  
                line += heigth;
                g2.drawString(commodity.getUnitPrice(), (float) x + 50, (float) y + line);  
                g2.drawString(commodity.getNum(), (float) x + 80, (float) y + line);  
                g2.drawString(commodity.getSum(), (float) x + 105, (float) y + line);
            }else{
            	g2.drawString(commodity.getName(), (float) x + 6, (float) y + line);    
                g2.drawString(commodity.getUnitPrice(), (float) x + 50, (float) y + line);  
                g2.drawString(commodity.getNum(), (float) x + 80, (float) y + line);  
                g2.drawString(commodity.getSum(), (float) x + 105, (float) y + line); 
            }
            line += heigth;  
  
        }  
        g2.drawLine((int) x, (int) (y + line), (int) x + 158, (int) (y + line));  
        
        line += 10;  
  
        g2.drawString("件数:" + saleNum + "件", (float) x+6, (float) y + line);  
        g2.drawString("合计:" + saleSum + "元", (float) x + 70, (float) y + line);  
        line += 12;
        g2.drawImage(pm.getImage(), (int) x+30, (int) y+(int)line,null);
        line += heigth+82;
        g2.drawString(code, (float) x+31, (float) y + line);
        line += heigth+30;
        g2.drawLine((int) x, (int) (y + line), (int) x + 180, (int) (y + line)); 
        switch (pageIndex) {  
        case 0:  
            return PAGE_EXISTS;  
        default:  
            return NO_SUCH_PAGE;  
        }  
	  
	}

}
