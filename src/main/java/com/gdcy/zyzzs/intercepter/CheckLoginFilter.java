package com.gdcy.zyzzs.intercepter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CheckLoginFilter implements Filter{
	
	private String loginUrl;
	
    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest servletRequest,
            ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        response.setContentType("text/html; charset=utf-8");
       /* Agent user=(Agent) request.getSession().getAttribute(Constants.SESSION_AGENT_USER);

		// 获得用户请求的URI
        String path = request.getServletPath();
        // 登陆页面无需过滤
		if( path.indexOf("index.jsp") != -1 ){
			filterChain.doFilter(servletRequest, servletResponse);
			return;
		}
        
		if(user==null || user.getState() == 1){
			java.io.PrintWriter out = response.getWriter();  
		    out.println("<html>");  
		    out.println("<script>");  
		    out.println("alert('登录超时，请重新登录！');");
		    out.println("window.open ('"+request.getContextPath()+"/','_top')");  
		    out.println("</script>");  
		    out.println("</html>");  
		}else{
			filterChain.doFilter(servletRequest, servletResponse);
		}*/

    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    	this.loginUrl = filterConfig.getInitParameter("loginUrl");  
    }
    
}

