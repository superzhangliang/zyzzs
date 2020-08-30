package com.gdcy.zyzzs.intercepter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;


public class LoginInterceptor extends HandlerInterceptorAdapter{
	private String loginUrl;
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		response.setContentType("text/html; charset=utf-8");
		/*Agent user=(Agent) request.getSession().getAttribute(Constants.SESSION_AGENT_USER);
		
		if(user==null || user.getState() == 1){
			java.io.PrintWriter out = response.getWriter();  
		    out.println("<html>");  
		    out.println("<script>");
		    out.println("alert('登录超时，请重新登录！');");
		    out.println("window.open ('"+request.getContextPath()+"/','_top')");  
		    out.println("</script>");  
		    out.println("</html>");  
			return false;
		}else{
			return true;
		}*/
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}

	@Override
	public void afterConcurrentHandlingStarted(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		super.afterConcurrentHandlingStarted(request, response, handler);
	}

	public String getLoginUrl() {
		return loginUrl;
	}

	public void setLoginUrl(String loginUrl) {
		this.loginUrl = loginUrl;
	}
	
}
