package com.gdcy.zyzzs.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.xml.sax.InputSource;

public class WebServiceUtil {
	/**
	 * 获取连接
	 * @param url	URL请求地址
	 * @param connectTimeout	连接超时时间
	 * @param ReadTimeout		请求接收超时时间
	 * @return	连接
	 * @throws Exception
	 */
	public static HttpURLConnection getConnection(String url, Integer connectTimeout, Integer ReadTimeout) 
			throws Exception {
		HttpURLConnection conn = null;
		if (url != null && !"".equals(url)) {
			URL wsUrl = new URL(url);
			conn = (HttpURLConnection) wsUrl.openConnection();
			if (connectTimeout != null) {
				conn.setConnectTimeout(connectTimeout);
			}
			if (ReadTimeout != null) {
				conn.setReadTimeout(ReadTimeout);
			}
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "text/xml;charset=UTF-8");
		}
		return conn;
	}
	
	public static String getRequestXml(String xmlns, String methodName, String argsStr) {
		String xml = "";
		if (xmlns != null && !"".equals(xmlns) && methodName != null && !"".equals(methodName)) {
			xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:q0=\""
				+ xmlns 
				+ "\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
				+ "<soapenv:Body><q0:" + methodName + ">";
			if (argsStr != null && !"".equals(argsStr)) {
				xml += argsStr;
			}
			xml += "</q0:" + methodName + "></soapenv:Body></soapenv:Envelope>";
		}
		return xml;
	}
	
	/**
	 * Description:将字符串类型的XML 转化成Docunent文档结构
	 * 
	 * @param parseStrXml
	 *            待转换的xml 字符串
	 * @return Document
	 * 
	 * @author huoge
	 */
	public static Document strXmlToDocument(String parseStrXml) {
		StringReader read = new StringReader(parseStrXml);
		// 创建新的输入源SAX 解析器将使用 InputSource 对象来确定如何读取 XML 输入
		InputSource source = new InputSource(read);
		// 创建一个新的SAXBuilder
		SAXBuilder sb = new SAXBuilder(); // 新建立构造器
		Document doc = null;
		try {
			doc = sb.build(source);
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return doc;

	}

	/**
	 * Description: 根据目标节点名获取值
	 * 
	 * @param doc
	 *            文档结构
	 * @param finalNodeName
	 *            最终节点名
	 * @return
	 * 
	 * @author huoge
	 */
	public static String getValueByElementName(Document doc, String finalNodeName) {
		Element root = doc.getRootElement();
		HashMap<String, Object> map = new HashMap<String, Object>();
		// 调用getChildAllText方法。获取目标子节点的值
		Map<String, Object> resultmap = getChildAllText(doc, root, map);
		String result = (String) resultmap.get(finalNodeName);
		return result;
	}

	/**
	 * Description: 递归获得子节点的值
	 * 
	 * @param doc
	 *            文档结构
	 * @param e
	 *            节点元素
	 * @param resultmap
	 *            递归将值压入map中
	 * @return
	 * 
	 * @author huoge
	 */
	public static Map<String, Object> getChildAllText(Document doc, Element e, HashMap<String, Object> resultmap) {
		if (e != null) {
			if (e.getChildren() != null) // 如果存在子节点
			{
				List<Element> list = e.getChildren();
				for (Element el : list) // 循环输出
				{
					if (el.getChildren().size() > 0) // 如果子节点还存在子节点，则递归获取
					{
						getChildAllText(doc, el, resultmap);
					} else {
						resultmap.put(el.getName(), el.getTextTrim()); // 将叶子节点值压入map
					}
				}
			}
		}
		return resultmap;
	}
	
	/**
	 * 发送报文,然后获取返回的报文,返回指定的节点内容
	 * @param conn	HttpURLConnection连接
	 * @param xml	报文内容
	 * @param tagName	获取指点节点的名称,不传则不获取
	 * @param logger	日志记录,传入则记录返回的报文,不传则不记录
	 * @return	相应报文的指定节点内容,指定节点不存在或不传入tagName则为null
	 * @throws Exception
	 */
	public static String sendXmlAndGetTag(HttpURLConnection conn, String xml, String tagName, Logger logger) 
			throws Exception{
		String returnMsg = null;
		if (conn != null && xml != null && !"".contentEquals(xml)) {
			//构造向指定链接写入数据的的输出流 
			OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream()); 
			//向指定链接写入数据
			out.write(xml); 
			out.flush(); 
			out.close();
			
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF8"));
	        
			String line = "";
			//构造一个空的StringBuffer对象，用于存储内存中的数据
			StringBuffer buf = new StringBuffer(); 
			for (line = br.readLine(); line != null; line = br.readLine()) { 
			//由于服务端返回的数据的字符集编码有可能不是utf-8,需要对返回的数据通过指定的字符集进行解码
				buf.append(new String(line.getBytes(),"UTF-8")); 
			}
			if (logger != null) {
				logger.info("网格化返回报文-->" + buf.toString());
			}
	        
			if (tagName != null && !"".equals(tagName)) {
				Document doc= strXmlToDocument(buf.toString());
				
				returnMsg = getValueByElementName(doc, tagName);
			}
		}
		return returnMsg;
	}
}
