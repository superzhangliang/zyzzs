package com.gdcy.zyzzs.excel;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.gdcy.zyzzs.excel.handler.IExcelHandler;
import com.gdcy.zyzzs.util.PropertiesUtil;


/**
 * Excel導入導出處理類
 * @author 黃枝良
 *
 * @param <T>
 */
public class ExcelManager<T>{
	
	public static LinkedHashMap<HashMap<String,String>,List<ExcelTemplate>> templates;
	public HttpServletRequest request;
	
	/**
	 * 導出EXCEL
	 * @param request
	 * @param tableName
	 * @param list
	 * @param out
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * @throws IOException
	 * @throws ParseException
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 */
	public void exportToExcel(HttpServletRequest request,String tableName,Collection<T> list,OutputStream out) throws IllegalArgumentException, IllegalAccessException, IOException, ParseException, ClassNotFoundException, InstantiationException{
		this.request=request;
		init();
		HashMap<String, String> map=new LinkedHashMap<String, String>();
		map.put("id", tableName);
		HSSFWorkbook excel = new HSSFWorkbook();
		List<ExcelTemplate> template=templates.get(map);
		HSSFSheet sheet = excel.createSheet(tableName);
		HSSFRow title=sheet.createRow(0);
		sheet.createFreezePane(0, 1,0,1);
		HSSFCellStyle titleStyle = excel.createCellStyle();
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		HSSFFont font=excel.createFont();
		font.setFontName("黑體");
		font.setFontHeightInPoints((short) 10);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		titleStyle.setFont(font);
		LinkedHashMap<String,Integer> classAttributes=new LinkedHashMap<String, Integer>();
		for(int n=0;n<template.size();n++){
			sheet.setColumnWidth(n, 4000);
			HSSFCell cell=title.createCell(n);
			cell.setCellValue(template.get(n).getCnname());
			cell.setCellStyle(titleStyle);
			classAttributes.put(template.get(n).getName(), n);
		}
		Iterator<T> iterator=list.iterator();
		int r=1;
		while(iterator.hasNext()){
			T obj=iterator.next();
			HSSFRow row=sheet.createRow(r);
			Field[] fields=obj.getClass().getDeclaredFields();
			for(int i=0;i<template.size();i++){
				int loc=0;
				for(int j=0;j<fields.length;j++){
					if(template.get(i).getName().toLowerCase().trim().equals(fields[j].getName().toLowerCase())){
						loc=j;
						break;
					}
				}
				Field field=fields[loc];
				field.setAccessible(true);
				String value=field.get(obj)==null?"":field.get(obj).toString();
				String defaltValue=template.get(i).getDefaltValue().trim();
				if(defaltValue!=null&&!defaltValue.equals("")){
					value=defaltValue;
				}
				if(template.get(i).getHandleClass().trim()!=null&&!template.get(i).getHandleClass().trim().equals("")){
					ExcelHandlerFactory<IExcelHandler> factory=new ExcelHandlerFactory<IExcelHandler>();
					value=factory.execute(template.get(i).getHandleClass().trim(), value);
				}
				HSSFCell c=row.createCell(i);
				c.setCellValue(value);
			}
			r++;
		}
		excel.write(out);
	}
	
	/**
	 * XML模板文件初始化
	 */
	@SuppressWarnings("rawtypes")
	private void init(){
		templates=new LinkedHashMap<HashMap<String,String>, List<ExcelTemplate>>();
		templates.clear();
		SAXReader builder = new SAXReader();
		Document doc = null;
		try {
			String s=PropertiesUtil.getProperty("excelTemplateXml");
			System.out.println("s="+s);
			String dir=request.getSession().getServletContext().getRealPath(s);
			System.out.println("dir="+dir);
			doc = builder.read(new File(dir));
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
			List<ExcelTemplate> excelTemplates=new ArrayList<ExcelTemplate>();
			for (int i = 0;fields!=null && i < fields.size(); i++) {
				Element field = (Element) fields.get(i);
				ExcelTemplate t=new ExcelTemplate();
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
	
//	public static void main(String[] args){
//		ExcelManager<Organization> excelManager=new ExcelManager<Organization>();
//		HashMap<String, String> map=new LinkedHashMap<String, String>();
//		map.put("id", "organization");
//		map.put("name", "tb_organization");
//		System.out.println("---"+map.toString());
//		
//		System.out.println(excelManager.templates.containsKey(map));
//	}
}
