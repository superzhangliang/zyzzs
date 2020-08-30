<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html >
<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>茂名市肉类蔬菜流通追溯管理平台</title>
	<link href="<%=basePath %>css/base-index.css" rel="stylesheet"/>
	<link href="<%=basePath %>css/index.css" rel="stylesheet"/>
	<link href="<%=basePath %>js/flashSlider/style.css" rel="stylesheet"/><!-- 图片轮播 -->
	<style>
		@font-face {
			font-family: "方正兰亭";
			src: url("<%=basePath %>css/font/fzlthjw.ttf");
		}
		@font-face {
			font-family: "叶根友毛";
			src: url("<%=basePath %>css/font/xindexingcao57.ttf");
		}
	</style>
	
	<script src="<%=basePath %>js/jquery-1.8.3.min.js" type="text/javascript" ></script>
	<script src="<%=basePath %>js/flashSlider/YuxiSlider.jQuery.min.js" type="text/javascript" ></script><!-- 图片轮播 -->	
	<script src="<%=basePath %>js/gVerify.js" type="text/javascript" ></script>
	<script src="<%=basePath %>js/index.js" type="text/javascript" ></script>
	
</head>
<body>
	<!--头部开始-->
	<div class="header">
		<div class="logoDiv">
			<table style="width: 980px;height: 100%; margin: 0px auto 0px auto;">
				<tr>
					<td colspan="2"></td>
				</tr>
				<tr>
					<td style="width: 80px; vertical-align: midille;">
						<a href="./index.jsp" target="_self">
							<img src="<%=basePath %>/images/logo.png" class="logo" />
						</a>
					</td>
					<td style="vertical-align: midille; padding-left: 34px;">
						<div style="font-family: '方正兰亭'; font-weight: bold; font-size:34px; color: #0090d1;">
							茂名市肉类蔬菜流通追溯管理平台
						</div>
						<div style="font-family: '方正兰亭'; font-size:13px; color: #424242;">
							MAO MING SHI ROU LEI SHU CAI LIU TONG ZHUI SU GUAN LI PING TAI
						</div>
					</td>
				</tr>
				<tr>
					<td height="30%" colspan="2" style="vertical-align: top; padding-left: 150px;">
						<div style="font-family: '叶根友毛'; font-size:26px; color: #02b418;">
							流通千万里&nbsp;&nbsp;追溯零距离
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="menuDiv">
			<table>
				<tr>
					<td>
						首页
					</td>
					<td onclick="openPage('xwrd')">
						新闻热点
					</td>
					<td onclick="openPage('tzgg')">
						通知公告
					</td>
					<td onclick="openPage('gzdt')">
						工作动态
					</td>
					<td onclick="openPage('zcfg')">
						政策法规
					</td>
					<td onclick="openPage('schq')">
						市场行情
					</td>
					<td onclick="openPage('zsmcx')">
						追溯码查询
					</td>
					<td onclick="openPage('mtxc')" >
						在线咨询
					</td>
					<td onclick="openPage('gzly')">
						公众留言
					</td>
					<td onclick="openPage('zspj')">
						知识普及
					</td>
				</tr>
			</table>
		</div>
	</div>
	<!--头部结束-->
	<!--主要内容开始-->
	<div class="main">
		<table style="width: 100%;" cellspacing="0">
			<!--追溯码查询-->
			<tr style="background-color: #f2f2f5;">
				<td align="center" valign="middle" style="width: 20%;">
					<font style="font-family: '方正兰亭'; font-size: 22px; color: #0065a0;">追溯码查询</font>
				</td>
				<td>
					<img src="<%=basePath %>/images/icon_right.png" style="vertical-align: top;" />
				</td>
				<td align="right" style="width: 55%;">
					<input type="text" class="query_input" id="query_input"/>
				</td>
				<td>
					<button class="query_btn" onclick="search();">查询</button>
				</td>
			</tr>
		</table>
		
		<table style="width: 100%; margin-top: 10px;" cellspacing="0">
			<tr>
				<!--登录-->
				<td style="width: 29%; background-color: #f2f2f5; padding: 10px;">
					<div style="background-color: #FFFFFF; padding: 15px;">
						<form id="loginForm" class="loginForm" action="<%=basePath %>login.do">
							<div style="margin: 10px auto 10px 35px; font-family: '微软雅黑'; font-weight: bold; font-size: 14px; color: #000000;">
								账号登录
							</div>
							<div style="height: 2px; background-color: #e6e6e6;">
								<div style="width: 150px; height: 2px; background-color: #008dcd;"></div>
							</div>
							<div>
								<input type="text" id="account" name="account" class="login_input" style="background-image: url(<%=basePath %>/images/icon_account.jpg);" placeholder="邮箱/会员账号/手机号" />
								<input type="password" id="password" name="password" class="login_input" style="background-image: url(<%=basePath %>/images/icon_password.jpg);" placeholder="请输入密码" />
							</div>
							<div>
								<input type="text" id="yzm" name="yzm" class="login_code_input" autocomplete="off" placeholder="请输入验证码" />
								<div id="v_container" style="width: 100px;height: 30px; position: relative; top: 20px; float: right"></div>
							</div>
							<div align="center">
								<input type="button" value="登录" onclick="submitForm()" class="login_btn" />
							</div>
						</form>	
					</div>
				</td>
				<td style="width: 42%;" align="center">
					<!-- 图片轮循开始 -->
					<div class="demo">
						<div class="slider" id="slider"><!--主体结构，请用此类名调用插件，此类名可自定义-->
							<ul>
								<li><a href=""><img src="<%=basePath %>/images/img1.jpg" alt="会议顺利召开" /></a></li>
								<li><a href=""><img src="<%=basePath %>/images/img2.jpg" alt="领导亲自视察" /></a></li>
								<li><a href=""><img src="<%=basePath %>/images/img3.jpg" alt="召开肉菜溯源平台培训会" /></a></li>
							</ul>
						</div>
					</div>
					<!-- 图片轮循结束 -->
				</td>
				<td style="width: 29%;" valign="top">
					<!--标题-->
					<div style="width: 100%; height: 2px; background-color: #00A9F6;"></div>
					<table style="width: 100%;">
						<tr style="background-color: #f9f9fa;">
							<td>
								<div class="div_btn working_on" id="work_btn" onclick="loadWorkNews()" >工作动态</div>
							</td>
							<td>
								<div class="div_btn notification_off" id="noti_btn" onclick="loadNotifications()" >通知公告</div>
							</td>
						</tr>
					</table>
					
					<table class="table_list" id="work_notification_table" >
						
					</table>
				</td>
			</tr>
		</table>
		
		<div class="bar2">
			<div class="bar2_inner" align="center" style="overflow:hidden">
				<div style="margin-top: 13px; font-family: '方正兰亭'; font-weight: bold; font-size: 30px; color: #FFFFFF; text-align: center;">追溯一下&nbsp;&nbsp;安心万家</div>
				<div style="font-family: '微软雅黑'; font-size: 19px; color: #FFFFFF; text-align: center;">尚德守法，共治共享食品安全</div>
				<div style="background-color: #FFFFFF; width: 70%; height: 2px; margin: 15px auto;"></div>
			</div>
		</div>
		
		<table style="width: 100%; margin-top: 20px;">
			<tr>
				<td style="width: 49%;">
					<div class="blue_title market_quotations" onclick="openPage('zcfg')">政策法规</div>
					<div style="width: 100%; height: 1px; background-color: #00a1e7;"></div>
				</td>
				<td style="width: 2%;"></td>
				<td style="width: 49%;">
					<div class="blue_title market_quotations" onclick="openPage('mtxc')">在线咨询</div>
					<div style="width: 100%; height: 1px; background-color: #00a1e7;"></div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<ul class="new_ul" id="ul_zcfg"></ul>
				</td>
				<td></td>
				<td valign="top">
					<ul class="new_ul" id="ul_mtxc"></ul>
				</td>
			</tr>
		</table>
		
		<table style="width: 100%; margin-top: 15px;">
			<tr>
				<td style="width: 30%;">
					<button style="width: 316px; height: 81px; border: none; background-image: url(<%=basePath %>/images/img_gzly.jpg);cursor: pointer;"  onclick="openPage('gzly')"></button>
				</td>
				<td style="width: 30%;">
					<button style="width: 316px; height: 81px; border: none; background-image: url(<%=basePath %>/images/img_jdqy.jpg);cursor: pointer;"  onclick="openPage('jdqy')"></button>
				</td>
				<td style="width: 30%;">
					<button style="width: 316px; height: 81px; border: none; background-image: url(<%=basePath %>/images/img_bgt.jpg);"></button>
				</td>
			</tr>
		</table>
		
		<table style="width: 100%; margin-top: 15px;">
			<tr>
				<td style="width: 69%; padding-right: 6px;">
					<div class="radius_blue_btn market_quotations" onclick="openPage('schq')">市场行情</div>
					<div class="blue_line"></div>
					<div class="classify">
						<a href="#" style="color: #017ac6;">肉类价格</a>&nbsp;&nbsp;<span style="color: #CCCCCC;">|</span>&nbsp;&nbsp;
						<a href="#">肉类进货量</a>&nbsp;&nbsp;<span style="color: #CCCCCC;">|</span>&nbsp;&nbsp;
						<a href="#">肉类销售量</a>
					</div>
				</td>
				<td style="width: 30%;" valign="top">
					<div class="radius_blue_btn market_quotations" onclick="openPage('zspj')">知识普及</div>
					<div class="blue_line"></div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<table width="100%" class="table2">
						<tr height="35">
							<td width="35%" style="color: #00a1ea; background-color: #f8f8f8;">商品名称</td>
							<td width="35%" style="font-size: 13px; color: #00a1ea; background-color: #f8f8f8;">价格（元/公斤）</td>
							<td align="center" style="font-size: 13px; color: #00a1ea; background-color: #f8f8f8;">日期</td>
						</tr>
						<tr>
							<td>热鲜猪肉(白条)平均价格为</td>
							<td>24.06元/公斤</td>
							<td>2017-10-10</td>
						</tr>
						<tr>
							<td>热鲜猪肉(白条)平均价格为</td>
							<td>24.06元/公斤</td>
							<td>2017-10-10</td>
						</tr>
						<tr>
							<td>热鲜猪肉(白条)平均价格为</td>
							<td>24.06元/公斤</td>
							<td>2017-10-10</td>
						</tr>
						<tr>
							<td>热鲜猪肉(白条)平均价格为</td>
							<td>24.06元/公斤</td>
							<td>2017-10-10</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<ul class="zspj" id="ul_zspj"></ul>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="height: 20px;" valign="bottom">
					<div style="width: 100%; height: 1px; background-color: #00a1ea;"></div>
				</td>
			</tr>
		</table>
		
		<table style="width: 100%; height: 80px; background-color: #f8f8f8;">
			<tr>
				<td align="center" class="icon_friendly">
					友情链接
				</td>
				<td align="center" width="21%">
					<a class="a_friendly" href="http://www.mofcom.gov.cn/" target="_blank" style="background-image: url(<%=basePath %>/images/friendly_1.png);"></a>
				</td>
				<td align="center" width="21%">
					<a class="a_friendly" href="http://www.zyczs.gov.cn/" target="_blank" style="background-image: url(<%=basePath %>/images/friendly_2.png);"></a>
				</td>
				<td align="center" width="21%">
					<a class="a_friendly" href="http://www.gddoftec.gov.cn/" target="_blank" style="background-image: url(<%=basePath %>/images/friendly_3.png);"></a>
				</td>
				<td align="center" width="21%">
					<a class="a_friendly" href="http://mmswj.maoming.gov.cn/" target="_blank" style="background-image: url(<%=basePath %>/images/friendly_4.png);"></a>
				</td>
			</tr>
		</table>
		
		
	</div>
	<!--主要内容结束-->
	<!--尾部开始-->
	<div align="center" class="foot">
		<div>技术支持：广东长盈科技股份有限公司</div>
		<div>电话：0668-2120380 传真：0668-2120380</div>
		<div>地址：广东省茂名市油城九路9号大院1号中银名苑1栋三层</div>
	</div>
	<!--尾部结束-->
	
	<script type="text/javascript" >
		var basePath = "<%=basePath %>";
		var verifyCode = new GVerify("v_container");
		onLoad();
		function search(){
			var type = 'zsmcx';
			var traceabilityNum = $("#query_input").val();
			if(traceabilityNum==null||traceabilityNum==''){
				alert("追溯码不能为空！");
				return;
			}
			if(traceabilityNum.length!=20){
				alert("追溯码填写不正确！");
				return;
			}
			window.location.href = basePath +'jsp/contentPage.jsp?type='+type+'&traceabilityNum='+traceabilityNum;
		}
	</script>
</body>
</html>