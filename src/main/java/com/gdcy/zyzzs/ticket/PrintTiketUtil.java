package com.gdcy.zyzzs.ticket;

import java.awt.Color;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.print.Book;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.PrinterJob;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import com.gdcy.zyzzs.util.Util;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.common.BitMatrix;
/**
 * 小票打印工具类
 * @author Hwz
 *
 */
public class PrintTiketUtil{
	
	/**
	 * 打印销售小票 
	 * @param list 商品列表
	 * @param pm 二维码
	 * @param nodeName 节点名称
	 * @param num 件数
	 * @param sum 合计
	 * @param code 条码
	 */
    public static void printSale(List<Collect> list,PrintModel pm,String nodeName,String num, String sum,String code) {  
        try {  
        	
            // 通俗理解就是书、文档  
            Book book = new Book();  
            // 设置成竖打  
            PageFormat pf = new PageFormat();  
            pf.setOrientation(PageFormat.PORTRAIT);  
  
            ArrayList<Commodity> cmdList = new ArrayList<Commodity>();  
            // 取出数据  
            for (int i = 0; i < list.size(); i++) {  
                Collect c = list.get(i);  
                Commodity cd = new Commodity(c.getName(), String.valueOf(c.getSell()), String.valueOf(c.getNum()),  
                        String.valueOf(c.getTotal()));  
                cmdList.add(cd);  
            }  
  
            // 通过Paper设置页面的空白边距和可打印区域。必须与实际打印纸张大小相符。  
            Paper paper = new Paper();  
            paper.setSize(180, 30000); // 纸张大小    
            paper.setImageableArea(10, 10, 180, 30000); // A4(595 X 842)设置打印区域，其实0，0应该是72，72，因为A4纸的默认X,Y边距是72
            pf.setPaper(paper);  
            
            SalesTicket ticket =  new SalesTicket(cmdList,pm,nodeName, num, sum,code);
            book.append(ticket, pf);  
  
            // 获取打印服务对象  
            PrinterJob job = PrinterJob.getPrinterJob();  
            // 设置打印类  
            job.setPageable(book);  
  
            job.print();  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }
    
    /**     
     * @discription 生成二维码图片，返回Image对象（二维码中间没有logo）
     * @author hwz     
     * @param text 二维码文字
     * @param path 二维码保存路径
     * @param width 二维码宽度
     * @param height 二维码高度
     * @return
     * @throws Exception     
   */
   public static Image writeQrCodeContent(HttpServletRequest request,String text, String path,int width,int height) throws Exception {
       String format = "jpg";// 二维码的图片格式  
         
       Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();  
       hints.put(EncodeHintType.CHARACTER_SET, "utf-8");   // 内容所使用字符集编码  
         
       BitMatrix bitMatrix = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, width, height, hints);  
       
       //去白边
       int[] rec = bitMatrix.getEnclosingRectangle();  
       int resWidth = rec[2] + 1;  
       int resHeight = rec[3] + 1;  
       BitMatrix resMatrix = new BitMatrix(resWidth, resHeight);  
       resMatrix.clear();  
       for (int i = 0; i < resWidth; i++) {  
           for (int j = 0; j < resHeight; j++) {  
               if (bitMatrix.get(i + rec[0], j + rec[1])) { 
                    resMatrix.set(i, j); 
               } 
           }  
       } 
       
       int w = resMatrix.getWidth();
       int h = resMatrix.getHeight();
       BufferedImage image = new BufferedImage(w, h,BufferedImage.TYPE_INT_ARGB);
       for (int x = 0; x < w; x++) {
           for (int y = 0; y < h; y++) {
               image.setRGB(x, y, resMatrix.get(x, y) == true ? 
               Color.BLACK.getRGB():Color.WHITE.getRGB());
           }
       }
       
       String fileName = Util.generatorFileName()+".jpg";
       String filePath = Util.getSavePath(path);
       //判断该保存目录是否存在，如果不存在则新建该目录
       File f = new File(Util.getRealPath(request, filePath));
 		if (!f.exists() && !f.isDirectory()) {
 			f.mkdirs();
 	   }
       File file = new File(Util.getRealPath(request, filePath) + File.separator + fileName);  
       MatrixToImageWriter.writeToFile(resMatrix, format, file);  
       InputStream is = new FileInputStream(file);
       BufferedImage bi;
       bi = ImageIO.read(is);
       java.awt.Image im = (java.awt.Image)bi;
       return im;
   }

}
