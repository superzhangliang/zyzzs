package com.gdcy.zyzzs.intercepter;

import java.io.IOException;
import java.util.Enumeration;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class SqlFilter implements Filter {
	private Logger logger = Logger.getLogger(this.getClass());
	
	/**正则表达式**/
    private static String reg = "(?:')|(/\\*(?:.|[\\n\\r])*?\\*/)|"  
            + "(\\b(select|update|and|or|delete|insert|trancate|char|into|substr|ascii|declare|exec|count|master|into|drop|execute)\\b)";  
  
    private static Pattern sqlPattern = Pattern.compile(reg, Pattern.CASE_INSENSITIVE);  

	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		// 获得所有请求参数名
		Enumeration<String> params = req.getParameterNames();

		boolean pass = true;
		while (params.hasMoreElements()) {
			// 得到参数名
			String name = params.nextElement().toString();
			// System.out.println("name===========================" + name +
			// "--");
			// 得到参数对应值
			String[] value = req.getParameterValues(name);
			for (int i = 0; i < value.length; i++) {
				if (sqlPattern.matcher(value[i].toLowerCase()).find()) {
					logger.info(req.getRequestURI() + "请求检测到SQL注入关键字，包含关键字的参数为：" + value[i]);
					pass = false;
					break;
				}
			}
			//如果已经检测到包含sql注入关键字，则不需要再往下做校验
			if (!pass) {
				break;
			}
		}
		if (!pass) {
			res.sendRedirect("jsp/error.jsp");
		} else {
			chain.doFilter(req, res);
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		// throw new UnsupportedOperationException("Not supported yet.");
	}

	public void destroy() {
		// throw new UnsupportedOperationException("Not supported yet.");
	}

}
