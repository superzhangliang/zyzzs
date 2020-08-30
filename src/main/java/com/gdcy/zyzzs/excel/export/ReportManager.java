package com.gdcy.zyzzs.excel.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.gdcy.zyzzs.excel.export.handler.IReportHandler;
import com.gdcy.zyzzs.excel.export.handler.ReportlHandlerFactory;
import com.gdcy.zyzzs.util.Constants;


/**
 * Excel導入處理類
 * @author 
 *
 * @param <T>
 */
public class ReportManager<T>{
	
	public static LinkedHashMap<HashMap<String,String>,List<ReportExcelTemplate>> templates;
	public HttpServletRequest request;
	
	/**
	 * 導入EXCEL
	 * @param excelName
	 * @param excelFile
	 * @param xmlFile
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws IOException
	 * @throws ParseException
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 */
//	@SuppressWarnings({"rawtypes", "unchecked"})
//	public List exportToExcel(String fileName,String excelName,String excelFile,String xmlFile) throws IllegalArgumentException, IllegalAccessException, IOException, ParseException, ClassNotFoundException, InstantiationException{
//		 FileInputStream fis ;  
//		 HSSFWorkbook workBook;  
//		 HSSFSheet sheet; 
//		 List listDatas = new ArrayList();;
//		 try {
//			init(xmlFile);
//			HashMap<String, String> map=new LinkedHashMap<String, String>();
//			map.put("id", excelName);
//			List<ReportExcelTemplate> excelTemplates = templates.get(map);
//			HashMap<String, ReportExcelTemplate> xmlmap=new LinkedHashMap<String, ReportExcelTemplate>();
//			for(ReportExcelTemplate ret:excelTemplates){
//				String cnname = ret.getCnname();
//				xmlmap.put(cnname, ret);
//			}
//           fis = new FileInputStream(excelFile);             
//           workBook = new HSSFWorkbook(fis);
//			sheet = workBook.getSheetAt(0);
//           // 得到總行數
//           int rowNum = sheet.getLastRowNum();
//           HashMap<Integer, String> titleMap=new LinkedHashMap<Integer, String>();
//           HashMap<String, String> titleValueMap;
//           List<HashMap<String, String>> excelList = new ArrayList<HashMap<String, String>>();
//           for(int i = 0; i <= rowNum; i++){
//        	   HSSFRow row = sheet.getRow(i);
//        	  if(!isBlankRow(row)){
//        		  //總列數
//        		  int colNum = row.getPhysicalNumberOfCells();
//        		  if(getCellFormatValue(row.getCell(0)).equals(Constants.EXCEL_JUDGE)&&titleMap.isEmpty()){
//             		  for(int j=0;j<colNum;j++){
//    	     			  String r = getCellFormatValue(row.getCell(j));
//    	     			  titleMap.put(j, r);
//    	     		  }
//            	   }else if(!getCellFormatValue(row.getCell(0)).equals(Constants.EXCEL_JUDGE)&&colNum>1){
//            		   titleValueMap=new LinkedHashMap<String, String>();
//            		   for(int j=0;j<colNum;j++){
//            			   String r = getCellFormatValue(row.getCell(j));
//            			   titleValueMap.put(titleMap.get(j), r);
//            		   }
//            		   excelList.add(titleValueMap);
//            	   }
//                }
//           }
//           if(!excelList.isEmpty()){
//	   	  	   for(int l = 0 ; l< excelList.size();l++){   
//	   			 HashMap<String, String> ltmap = (HashMap<String, String>) excelList.get(l);
//	   			 Iterator<Entry<String, String>> it = ltmap.entrySet().iterator();
//	   			 Map curRowCellMap = new HashMap();
//	       		 while(it.hasNext()){
//					 Map.Entry entry = (Map.Entry) it.next();
//					 String cnname= (String)entry.getKey();
//					 String value= (String)entry.getValue();
//					 String type= xmlmap.get(cnname).getType();
//					 String name = xmlmap.get(cnname).getName();
//					 String defaltValue = xmlmap.get(cnname).getDefaltValue();
//					 if(value != null&&!value.equals("")){  
//		                    value = value.trim();  
//		                } 
//					 if(value.equals("")){
//						 value=null;
//					 }
//					 if(defaltValue!=null&&!defaltValue.equals("")){
//							value=defaltValue;
//					}
//					 if(defaltValue!=null&&!defaltValue.equals("")){
//							value=defaltValue;
//						}
//					 String handleClass = xmlmap.get(cnname).getHandleClass();
//		             	 if(!handleClass.trim().equals("")&&handleClass.trim()!=null&&value != null&&!value.equals("")){
//		             		 ReportlHandlerFactory<IReportHandler> factory = new ReportlHandlerFactory<IReportHandler>();
//		                 	 List val = factory.transFormation(handleClass.trim(), value,type);
//		                 	 if(val.size()>0){
//		                 		curRowCellMap.put(name, val.get(0));
//		                 	 }
//					 }else{
//						 curRowCellMap.put(name, value);
//					 }
//	       		 }
//	       		 listDatas.add(curRowCellMap);
//	   	  	   }
//	   		}
//		}catch (Exception e) {
//			e.printStackTrace();
//		} 
//		return listDatas;
//	}
	/**
	 * 導入EXCEL
	 * @param excelName
	 * @param excelFile
	 * @param xmlFile
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws IOException
	 * @throws ParseException
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 */
	@SuppressWarnings({"rawtypes", "unchecked"})
	public List exportToExcel(String fileName,String excelName,String excelFile,String xmlFile) throws IllegalArgumentException, IllegalAccessException, IOException, ParseException, ClassNotFoundException, InstantiationException{
		 List listDatas = new ArrayList();
		 List<HashMap<String, String>> excelList;
		 try {
			init(xmlFile);
			HashMap<String, String> map=new LinkedHashMap<String, String>();
			map.put("id", excelName);
			List<ReportExcelTemplate> excelTemplates = templates.get(map);
			HashMap<String, ReportExcelTemplate> xmlmap=new LinkedHashMap<String, ReportExcelTemplate>();
			for(ReportExcelTemplate ret:excelTemplates){
				String cnname = ret.getCnname();
				xmlmap.put(cnname, ret);
			}
			InputStream in = new FileInputStream(excelFile);    //創建輸入流  
			//判斷Excel版本
			if (fileName.endsWith(".xlsx")) {  
				excelList = readXlsx(in,excelName,xmlFile);// 獲取Excel 2010文件數據  
		    } else {  
		    	excelList = readXls(in,excelName,xmlFile);// 獲取Excel 2003文件數據  
		    } 
			if(!excelList.isEmpty()){
		   	  	   for(int l = 0 ; l< excelList.size();l++){   
		   			 HashMap<String, String> ltmap = (HashMap<String, String>) excelList.get(l);
		   			 Iterator<Entry<String, String>> it = ltmap.entrySet().iterator();
		   			 Map curRowCellMap = new HashMap();
		       		 while(it.hasNext()){
						 Map.Entry entry = (Map.Entry) it.next();
						 String cnname= (String)entry.getKey();
						 String value= (String)entry.getValue();
						 String type= xmlmap.get(cnname).getType();
						 String name = xmlmap.get(cnname).getName();
						 String defaltValue = xmlmap.get(cnname).getDefaltValue();
						 if(value != null&&!value.equals("")){  
			                    value = value.trim();  
			                } 
						 if(value.equals("")){
							 value=null;
						 }
						 if(defaltValue!=null&&!defaltValue.equals("")){
								value=defaltValue;
						}
						 if(defaltValue!=null&&!defaltValue.equals("")){
								value=defaltValue;
							}
						 String handleClass = xmlmap.get(cnname).getHandleClass();
			             	 if(!handleClass.trim().equals("")&&handleClass.trim()!=null&&value != null&&!value.equals("")){
			             		 ReportlHandlerFactory<IReportHandler> factory = new ReportlHandlerFactory<IReportHandler>();
			                 	 List val = factory.transFormation(handleClass.trim(), value,type);
			                 	 if(val.size()>0){
			                 		curRowCellMap.put(name, val.get(0));
			                 	 }
						 }else{
							 curRowCellMap.put(name, value);
						 }
		       		 }
		       		 listDatas.add(curRowCellMap);
		   	  	   }
		   	}
		}catch (Exception e) {
			e.printStackTrace();
			 listDatas.clear();
		} 
		return listDatas;
	}
    /**
     * 讀 Excel 2003
     * @param 
     * @return
     * @throws IOException
     */
	public static List<HashMap<String, String>> readXls(InputStream in,String excelName,String xmlFile) throws IOException {
		List<HashMap<String, String>> excelList = new ArrayList<HashMap<String, String>>();
	    HSSFWorkbook hssfWorkbook = new HSSFWorkbook(in);
	    //讀表格
	    for (int numSheet = 0; numSheet < hssfWorkbook.getNumberOfSheets(); numSheet++) {
	        HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(numSheet);
	        if (hssfSheet == null) {
	            continue;
	        }
	        //讀行
	        HashMap<String, String> titleValueMap;
        	HashMap<Integer, String> titleMap=new LinkedHashMap<Integer, String>();
	        for (int rowNum = 0; rowNum <= hssfSheet.getLastRowNum(); rowNum++) {
	            HSSFRow hssfRow = hssfSheet.getRow(rowNum);
	          /*  if (hssfRow != null) {
	            	int colNum = hssfRow.getPhysicalNumberOfCells();//得到每行的列數
            	    if(getValue(hssfRow.getCell(0)).equals(Constants.EXCEL_JUDGE)&&titleMap.isEmpty()){
              		  for(int j=0;j<colNum-1;j++){ //最後一項（總重量）不要
    	     			  String r = getValue(hssfRow.getCell(j));
    	     			  titleMap.put(j, r);
    	     		  }
        		    }else if(!getValue(hssfRow.getCell(0)).equals(Constants.EXCEL_JUDGE)&&colNum>1){
        			   titleValueMap=new LinkedHashMap<String, String>();
            		   for(int j=0;j<colNum-1;j++){//最後一項（總重量）不要
            			   String r = getValue(hssfRow.getCell(j));
            			   titleValueMap.put(titleMap.get(j), r);
            		   }
            		   excelList.add(titleValueMap);
        		   }
	            }*/
	        }
	    }
	    return excelList;
	}	
	/**
	* 讀 Excel 2007-2010版本
	* @param 
	* @return
	* @throws IOException
	*/
	public static List<HashMap<String, String>> readXlsx(InputStream in,String excelName,String xmlFile) throws IOException {
	   List<HashMap<String, String>> excelList = new ArrayList<HashMap<String, String>>();
	   XSSFWorkbook xssfWorkbook = new XSSFWorkbook(in);
	   HashMap<Integer, String> titleMap=new LinkedHashMap<Integer, String>();
	   HashMap<String, String> titleValueMap;
	   //讀表格
	   for (int numSheet = 0; numSheet < xssfWorkbook.getNumberOfSheets(); numSheet++) {
	      XSSFSheet xssfSheet = xssfWorkbook.getSheetAt(numSheet);
	       if (xssfSheet == null) {
	          continue;
	      }
	       //讀行
	       for (int rowNum = 0; rowNum <= xssfSheet.getLastRowNum(); rowNum++) {
	           XSSFRow xssfRow = xssfSheet.getRow(rowNum);
	         /*  if (xssfRow != null) {
	        	   int colNum = xssfRow.getPhysicalNumberOfCells();//得到每行的列數
        		   if(getValue(xssfRow.getCell(0)).equals(Constants.EXCEL_JUDGE)&&titleMap.isEmpty()){
              		  for(int j=0;j<colNum-1;j++){
    	     			  String r = getValue(xssfRow.getCell(j));
    	     			  titleMap.put(j, r);
    	     		  }
        		   }else if(!getValue(xssfRow.getCell(0)).equals(Constants.EXCEL_JUDGE)&&colNum>1){
        			   titleValueMap=new LinkedHashMap<String, String>();
            		   for(int j=0;j<colNum-1;j++){
            			   String r = getValue(xssfRow.getCell(j));
            			   titleValueMap.put(titleMap.get(j), r);
            		   }
            		   excelList.add(titleValueMap);
        		   }
	           }*/
	       }
	   }
	   return excelList;
	}	
	/**
	 * 取表格中的值
	 * @param xssfCell
	 * @return
	 */
	@SuppressWarnings({ "static-access", "deprecation" })
    public static String getValue(XSSFCell xssfCell) {
         if (xssfCell.getCellType() == xssfCell.CELL_TYPE_BOOLEAN) {
             return String.valueOf(xssfCell.getBooleanCellValue()).trim();
         } 
         else if (xssfCell.getCellType() == xssfCell.CELL_TYPE_NUMERIC) {
             return String.valueOf((int)xssfCell.getNumericCellValue()).trim();
         }else {
             return String.valueOf(xssfCell.getStringCellValue()).trim();
         }
    }
	/**
	 * 取表格中的值
	 * @param xssfCell
	 * @return
	 */
    @SuppressWarnings({ "static-access", "deprecation" })
    public static String getValue(HSSFCell hssfCell) {
         if (hssfCell.getCellType() == hssfCell.CELL_TYPE_BOOLEAN) {
             return String.valueOf(hssfCell.getBooleanCellValue()).trim();
         } 
         else if (hssfCell.getCellType() == hssfCell.CELL_TYPE_NUMERIC) {
             return String.valueOf((int)hssfCell.getNumericCellValue()).trim();
         } else {
             return String.valueOf(hssfCell.getStringCellValue()).trim();
         }
    }
    /**
     * 取得表格中的全部值
     * @param excelList
     * @param excelName
     * @param xmlFile
     * @return
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getListValue(List<HashMap<String, String>> excelList,String excelName,String xmlFile){
    	   List listDatas = new ArrayList();
    	   try{
    		init(xmlFile);
   			HashMap<String, String> map=new LinkedHashMap<String, String>();
   			map.put("id", excelName);
   			List<ReportExcelTemplate> excelTemplates = templates.get(map);
   			HashMap<String, ReportExcelTemplate> xmlmap=new LinkedHashMap<String, ReportExcelTemplate>();
   			for(ReportExcelTemplate ret:excelTemplates){
   				String cnname = ret.getCnname();
   				xmlmap.put(cnname, ret);
   			}
 	  	     for(int l = 0 ; l< excelList.size();l++){   
 			 HashMap<String, String> ltmap = (HashMap<String, String>) excelList.get(l);
 			 Iterator<Entry<String, String>> it = ltmap.entrySet().iterator();
 			 Map curRowCellMap = new HashMap();
     		 while(it.hasNext()){
				 Map.Entry entry = (Map.Entry) it.next();
				 String cnname= (String)entry.getKey();
				 String value= (String)entry.getValue();
				 String type= xmlmap.get(cnname).getType();
				 String name = xmlmap.get(cnname).getName();
				 String defaltValue = xmlmap.get(cnname).getDefaltValue();
				 if(value != null&&!value.equals("")){  
	                    value = value.trim();  
	                } 
				 if(value.equals("")){
					 value=null;
				 }
				 if(defaltValue!=null&&!defaltValue.equals("")){
						value=defaltValue;
				}
				 if(defaltValue!=null&&!defaltValue.equals("")){
						value=defaltValue;
					}
				 String handleClass = xmlmap.get(cnname).getHandleClass();
	             	 if(!handleClass.trim().equals("")&&handleClass.trim()!=null&&value != null&&!value.equals("")){
	             		 ReportlHandlerFactory<IReportHandler> factory = new ReportlHandlerFactory<IReportHandler>();
	                 	 List val = factory.transFormation(handleClass.trim(), value,type);
	                 	 if(val.size()>0){
	                 		curRowCellMap.put(name, val.get(0));
	                 	 }
				 }else{
					 curRowCellMap.put(name, value);
				 }
     		 }
     		 listDatas.add(curRowCellMap);
 	  	   }
    	 }catch(Exception e){
    		 e.printStackTrace();
    	 }
 	  	 return listDatas;
     }
	 //讀單個excel數據
	 @SuppressWarnings("deprecation")
	 public static String getCellFormatValue(HSSFCell cell) {
        String cellvalue = "";
        if (cell != null) {
            // 判斷當前Cell的Type
            switch (cell.getCellType()) {
            // 如果當前Cell的Type為NUMERIC
            case HSSFCell.CELL_TYPE_NUMERIC:
            //case HSSFCell.CELL_TYPE_FORMULA: {
                // 判斷當前的cell是否為Date
                if (HSSFDateUtil.isCellDateFormatted(cell)) {
                    // 如果是Date類型則，轉化為Data格式
                	Date date = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    cellvalue = sdf.format(date);
                    
                }
                // 如果是純数字
                else {
                    // 取得當前Cell的數值
                	BigDecimal big =new BigDecimal(cell.getNumericCellValue());
                	cellvalue = big.toString();
                	if(cellvalue!=null&&cellvalue.trim().equals("")){
                		String[] item = cellvalue.split("[.]");
                		if(item.length>1&&item[1].equals("0")){
                			cellvalue=item[0];
                		}
                	}
                }
                break;
            // 如果當前Cell的Type為STRING
            case HSSFCell.CELL_TYPE_STRING:
                // 取得當前的Cell字符串
                cellvalue = cell.getStringCellValue().toString();
                break;
             // 公式類型  
            case HSSFCell.CELL_TYPE_FORMULA:  
                //讀公式計算值  
            	cellvalue = String.valueOf(cell.getNumericCellValue());  
                if (cellvalue.equals("NaN")) {// 如果獲取的數據值為非法值,則轉換為獲取字符串  
                	cellvalue = cell.getStringCellValue().toString();  
                }  
                break;
             // 布爾類型  
            case HSSFCell.CELL_TYPE_BOOLEAN:  
            	cellvalue = " "+ cell.getBooleanCellValue();  
                break;
            // 默認的Cell值
            default:
            	cellvalue = cell.getStringCellValue().toString();
            }
        } 
        if(cell==null){
            cellvalue = "";
        }
        return cellvalue;

     }
	 //讀單個excel數據
	 @SuppressWarnings("deprecation")
	 public static String getCellFormatValue(XSSFCell cell) {
        String cellvalue = "";
        if (cell != null) {
            // 判斷當前Cell的Type
            switch (cell.getCellType()) {
            // 如果當前Cell的Type為NUMERIC
            case XSSFCell.CELL_TYPE_NUMERIC:
                // 判斷當前的cell是否為Date
                if (HSSFDateUtil.isCellDateFormatted(cell)) {
                    // 如果是Date類型則，轉化為Data格式
                	Date date = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    cellvalue = sdf.format(date);
                    
                }
                // 如果是純数字
                else {
                    // 取得當前Cell的數值
                	BigDecimal big =new BigDecimal(cell.getNumericCellValue());
                	cellvalue = big.toString();
                	if(cellvalue!=null&&cellvalue.trim().equals("")){
                		String[] item = cellvalue.split("[.]");
                		if(item.length>1&&item[1].equals("0")){
                			cellvalue=item[0];
                		}
                	}
                }
                break;
            // 如果當前Cell的Type為STRING
            case XSSFCell.CELL_TYPE_STRING:
                // 取得當前的Cell字符串
                cellvalue = cell.getStringCellValue().toString();
                break;
             // 公式類型  
            case XSSFCell.CELL_TYPE_FORMULA:  
                //讀公式計算值  
            	cellvalue = String.valueOf(cell.getNumericCellValue());  
                if (cellvalue.equals("NaN")) {// 如果獲取的數據值為非法值,則轉換為獲取字符串  
                	cellvalue = cell.getStringCellValue().toString();  
                }  
                break;
             // 布爾類型  
            case XSSFCell.CELL_TYPE_BOOLEAN:  
            	cellvalue = " "+ cell.getBooleanCellValue();  
                break;
            // 默認的Cell值
            default:
            	cellvalue = cell.getStringCellValue().toString();
            }
        } 
        if(cell==null){
            cellvalue = "";
        }
        return cellvalue;

    }
	//判斷行是否為空  
	@SuppressWarnings("deprecation")
	public static boolean isBlankRow(Row row){
	    if(row == null) return true;
	    boolean result = true;
	    for(int i = row.getFirstCellNum(); i < row.getLastCellNum(); i++){
	    	Cell cell = row.getCell(i, Row.RETURN_BLANK_AS_NULL);
	        String value = "";
	        if(cell != null){
	            switch (cell.getCellType()) {
	            case Cell.CELL_TYPE_STRING:
	                value = cell.getStringCellValue();
	                break;
	            case Cell.CELL_TYPE_NUMERIC:
	                value = String.valueOf((int) cell.getNumericCellValue());
	                break;
	            case Cell.CELL_TYPE_BOOLEAN:
	                value = String.valueOf(cell.getBooleanCellValue());
	                break;
	            case Cell.CELL_TYPE_FORMULA:
	                value = String.valueOf(cell.getCellFormula());
	                break;
	            //case Cell.CELL_TYPE_BLANK:
	            //    break;
	            default:
	                break;
	            }
	             
	            if(!value.trim().equals("")){
	                result = false;
	                break;
	            }
	        }
	    }
	     
	    return result;
	}
	//判斷行是否為空  XSSFRow
	@SuppressWarnings("deprecation")
	public static boolean isBlankRow(HSSFRow row){
	    if(row == null) return true;
	    boolean result = true;
	    for(int i = row.getFirstCellNum(); i < row.getLastCellNum(); i++){
	        HSSFCell cell = row.getCell(i, HSSFRow.RETURN_BLANK_AS_NULL);
	        String value = "";
	        if(cell != null){
	            switch (cell.getCellType()) {
	            case Cell.CELL_TYPE_STRING:
	                value = cell.getStringCellValue();
	                break;
	            case Cell.CELL_TYPE_NUMERIC:
	                value = String.valueOf((int) cell.getNumericCellValue());
	                break;
	            case Cell.CELL_TYPE_BOOLEAN:
	                value = String.valueOf(cell.getBooleanCellValue());
	                break;
	            case Cell.CELL_TYPE_FORMULA:
	                value = String.valueOf(cell.getCellFormula());
	                break;
	            //case Cell.CELL_TYPE_BLANK:
	            //    break;
	            default:
	                break;
	            }
	             
	            if(!value.trim().equals("")){
	                result = false;
	                break;
	            }
	        }
	    }
	     
	    return result;
	}
	/**
	 * XML模板文件初始化
	 */
	@SuppressWarnings("rawtypes")
	public static void init(String xmlFile) throws Exception{
		templates=new LinkedHashMap<HashMap<String,String>, List<ReportExcelTemplate>>();
		templates.clear();
		SAXReader builder = new SAXReader();
		Document doc = null;
		try {
			doc = builder.read(new File(xmlFile));
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		Element root=doc.getRootElement();
		
		List elements=root.elements();
		Iterator it=elements.iterator();
		while(it.hasNext()){
			Element table = (Element) it.next();
			List tableAttributes=table.attributes();
			HashMap<String,String> tableAttributesMap=new HashMap<String, String>();
			Iterator tableAttributesIterator=tableAttributes.iterator();
			while(tableAttributesIterator.hasNext()){
				Attribute tableAttribute=(Attribute) tableAttributesIterator.next();
				tableAttributesMap.put(tableAttribute.getName(), tableAttribute.getText());
			}
			List fields=table.elements();
			List<ReportExcelTemplate> excelTemplates=new ArrayList<ReportExcelTemplate>();
			for (int i = 0;fields!=null && i < fields.size(); i++) {
				Element field = (Element) fields.get(i);
				ReportExcelTemplate t=new ReportExcelTemplate();
				List attributes=field.attributes();
				Iterator attrIterator=attributes.iterator();
				while(attrIterator.hasNext()){
					Attribute attribute=(Attribute) attrIterator.next();
					try {
						Field f=t.getClass().getDeclaredField(attribute.getName());
						f.setAccessible(true);
						f.set(t, attribute.getText());
					} catch (NoSuchFieldException e) {
						e.printStackTrace();
					} catch (SecurityException e) {
						e.printStackTrace();
					}catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					}
				}
				excelTemplates.add(t);
			}
			templates.put(tableAttributesMap, excelTemplates);
		}
	}
}
