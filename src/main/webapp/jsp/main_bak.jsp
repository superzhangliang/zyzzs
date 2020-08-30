<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.MD5Util" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>南海食品集团进销存管理平台</title>

		<meta name="description" content="overview &amp; stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0,  " />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="${basepath}/js/assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="${basepath}/js/assets/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->

		<!-- text fonts -->
		<link rel="stylesheet" href="${basepath}/js/assets/css/ace-fonts.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="${basepath}/js/assets/css/ace.min.css" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="${basepath}/js/assets/css/ace-part2.min.css" />
		<![endif]-->
		<link rel="stylesheet" href="${basepath}/js/assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="${basepath}/js/assets/css/ace-rtl.min.css" />

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="${basepath}/js/assets/css/ace-ie.min.css" />
		<![endif]-->

		<!-- inline styles related to this page -->

		<!-- ace settings handler -->
		<script src="${basepath}/js/assets/js/ace-extra.min.js"></script>
		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

		<!--[if lte IE 8]>
		<script src="${basepath}/js/assets/js/html5shiv.min.js"></script>
		<script src="${basepath}/js/assets/js/respond.min.js"></script>
		<![endif]-->
		<style type="text/css">
			.navbar {width: 100%; height: 180px; background-image: url(${basepath}images/topcszs.jpg); margin: 0 auto; background-color: #fff;}
			.main-container {width: 100%; margin: 0 auto;height: 70%}
			
			.navbar-header {height: 180px; line-height: 180px;}
			.logo {width: 116px; height: 116px;}
			.pull-left {font-family: "黑体"; font-size: 30px; color: #1851a2;}
			
			.sidebar {width: 175px; overflow-y: auto;}
			.sidebar+.main-content {padding-left: 175px;}
			.breadcrumbs {background-color: #f9f9f9;}
			
		</style>
	</head>

	<body class="no-skin" style="overflow-x: hidden; overflow-y: auto;">
		<!-- #section:basics/navbar.layout -->
		<div id="navbar" class="navbar navbar-default">
			<script type="text/javascript">
				try{ace.settings.check('navbar' , 'fixed')}catch(e){}
			</script>

			<div class="navbar-container" id="navbar-container">
				<!-- #section:basics/sidebar.mobile.toggle -->
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler">
					<span class="sr-only">Toggle sidebar</span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>
				</button>

				<!-- /section:basics/sidebar.mobile.toggle -->
				<div class="navbar-header pull-left">
					<img class="logo" src="${basepath }images/logo.png">
					南海食品集团进销存管理平台
				</div>

			</div><!-- /.navbar-container -->
		</div>

		<!-- /section:basics/navbar.layout -->
		<div class="main-container" id="main-container">
			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>

			<!-- #section:basics/sidebar -->
			<div id="sidebar" class="sidebar responsive">
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>

				<ul class="nav nav-list">
		            <c:forEach var="menu" items="${menuList }" varStatus="status">
		                <c:if test="${status.index == 0 }">
		                    <li class="open">
		                </c:if>
		                <c:if test="${status.index != 0 }">
		                    <li >
		                </c:if>
		                <c:choose>
		                    <c:when test="${menu.children != null }">
		                        <a href="#" class="dropdown-toggle">
		                    </c:when>
		                    <c:otherwise>
		                        <a href="javascript:f_addTab('menu${menu.id }','${menu.name }','${menu.url }');" menuName="${menu.name }">
		                    </c:otherwise>
		                </c:choose>
		                <i class="${menu.icon }" style="font-size: 18px;"></i>
		                <span class="menu-text"> ${menu.name } </span>
		                <c:if test="${menu.children != null}">
		                    <b class="arrow fa fa-angle-down"></b>
		                </c:if>
		                </a>
		                <b class="arrow"></b>
		                <c:if test="${menu.children != null}">
		                    <ul class="submenu">
		                        <c:forEach var="menu2" items="${menu.children}">
		                            <c:choose>
		                                <c:when test="${menu2.children != null}">
		                                    <li>
		                                        <a href="javascript:void(0);" class="dropdown-toggle">
		                                            <i class="${menu2.icon }" style="font-size: 18px;"></i>
		                                            <span class="menu-text"> ${menu2.name } </span>
		                                            <b class="arrow fa fa-angle-down"></b>
		                                        </a>
		                                        <ul class="submenu">
		                                            <c:forEach var="menu3" items="${menu2.children}">
		                                                <li class="">
		                                                    <a href="${menu3.url}"
		                                                       menuName="${menu3.name }" target="content">
		                                                        <i class="${menu3.icon }" style="font-size: 17px;"></i>
		                                                            ${menu3.name }
		                                                    </a>
		                                                    <b class="arrow"></b>
		                                                </li>
		                                            </c:forEach>
		                                        </ul>
		                                    </li>
		                                </c:when>
		                                <c:otherwise>
		                                    <li class="">
		                                        <a href="${menu2.url }"
		                                           menuName="${menu2.name }" target="content">
		                                            <i class="iconfont ${menu2.icon }" style="font-size: 18px;"></i>
		                                                ${menu2.name }
		                                        </a>
		                                        <b class="arrow"></b>
		                                    </li>
		                                </c:otherwise>
		                            </c:choose>
		                        </c:forEach>
		                    </ul>
		                </c:if>
		                </li>
		            </c:forEach>
				
				</ul><!-- /.nav-list -->

				<!-- #section:basics/sidebar.layout.minimize -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>

				<!-- /section:basics/sidebar.layout.minimize -->
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
			</div>
			
			<div class="main-content">  
				<div class="breadcrumbs" id="breadcrumbs">
					<script type="text/javascript">
						try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){}
					</script>
					<ul class="breadcrumb">
						<li>
							<i class="ace-icon fa fa-home home-icon"></i>
							<a href="${basepath }jsp/homePage.jsp" target="content">首页</a>
						</li>
					</ul><!-- /.breadcrumb -->
					<div class="userMessage" style="float: right; padding-right: 20px;">
						<span style="color: #4c8fbd;">${user.name }，你好！</span>
						<i class="fa fa-power-off" title="注销" onclick="logout();"
							style="font-size: 20px;position: relative;top: 3px;color: #d43131; cursor: pointer;margin-left: 10px;"></i>
					</div>
 				</div> 
				<div class="page-content" id="main" style="height: 100%; ">
					<iframe id="content" name="content" src="${basepath }jsp/homePage.jsp" style="width: 100%; height: 100%; " ></iframe>
				</div>
 			</div>

			<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
		</div><!-- /.main-container -->

			
			<!-- /section:basics/sidebar -->
			<!--<div class="main-content">
				<iframe id="content" src="${basepath }jsp/homePage.jsp" style="width: 100%; height: auto; ">
				</iframe>
			
				<%-- <jsp:include page="./homePage.jsp"></jsp:include> --%>
			</div> /.main-content -->

		<!-- 	<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
				<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
			</a>
		</div>/.main-container -->

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='${basepath}/js/assets/js/jquery.min.js'>"+"<"+"/script>");
		</script>

		<!-- <![endif]-->

		<!--[if IE]>
<script type="text/javascript">
 window.jQuery || document.write("<script src='${basepath}/js/assets/js/jquery1x.min.js'>"+"<"+"/script>");
</script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='${basepath}/js/assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="${basepath}/js/assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->

		<!--[if lte IE 8]>
		  <script src="${basepath}/js/assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="${basepath}/js/assets/js/jquery-ui.custom.min.js"></script>
		<script src="${basepath}/js/assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="${basepath}/js/assets/js/jquery.easypiechart.min.js"></script>
		<script src="${basepath}/js/assets/js/jquery.sparkline.min.js"></script>
		<script src="${basepath}/js/assets/js/flot/jquery.flot.min.js"></script>
		<script src="${basepath}/js/assets/js/flot/jquery.flot.pie.min.js"></script>
		<script src="${basepath}/js/assets/js/flot/jquery.flot.resize.min.js"></script>

		<!-- ace scripts -->
		<script src="${basepath}/js/assets/js/ace-elements.min.js"></script>
		<script src="${basepath}/js/assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			var height;
			jQuery(function($) {
				height = window.innerHeight - 185;
				//$("#content").height(1023 + "px");
			});
			
			function f_addTab(tabid, text, url) {
				$("#content").attr("src", '${basepath}'+url);
		    }
		</script>

		<!-- the following scripts are used in demo only for onpage help and you don't need them -->
		<link rel="stylesheet" href="${basepath}/js/assets/css/ace.onpage-help.css" />

		<!-- <script type="text/javascript"> ace.vars['base'] = '..'; </script> -->
		<script src="${basepath}/js/assets/js/ace/elements.onpage-help.js"></script>
		<script src="${basepath}/js/assets/js/ace/ace.onpage-help.js"></script>
	</body>
	<script type="text/javascript">
		$(document).ready(function(){
			//读取导航栏信息
			loadNavigationBar();
		});

		function loadNavigationBar(){
			 var oldhtml=$(".breadcrumb").html();
			 $("ul.nav-list a").on('click',function(event){
			  	var data = getMenuAttr($(this));
			  	var addhtml="";
			  	for(var i=0;i<data.length;i++){
			      addhtml += "<li><span>";
			      addhtml += data[data.length-i-1];
			      addhtml += "<span></li>";
			  	}
			    $(".breadcrumb").html(oldhtml+addhtml);
			    //导航条标签返回首页状态
			    $("ul.breadcrumb li:first a").on('click',function(){
			  		$(".breadcrumb").html(oldhtml);
			    });
				$("ul.nav-list li").removeClass("active");
			});
		}
		/**
		 * 得到多级菜单名称
		 */
		function getMenuAttr(leaf){
			var arr = new Array();
			arr.push(leaf.text());
			var x=null;
			if(!leaf.parent().parent().hasClass("nav nav-list")){
				var x = leaf.parent().parent();
				while(x.hasClass("submenu nav-show")){
					var y=null;
					if(x.prev().hasClass("arrow")){
						y = x.prev().prev();
					}else{
						y = x.prev();
					}
					arr.push(y.text());
					x = x.parent().parent();
				}
			}
			return arr;
		}
		
		function logout() {
			window.location.href = "${basepath}logout.do";
		}
	</script>
</html>