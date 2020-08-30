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
	<title>种养殖溯源管理平台</title>
	<link href="css/base-login.css" rel="stylesheet"/>
	<link href="css/photoBox.css" rel="stylesheet"/>
	<link href="css/login.css" rel="stylesheet"/>
	<style type="text/css">
		.privaBgBlack{position:fixed;_position:absolute;background:black;top:0;left:0;width:100%;height:100%;z-index:9998;display:none;opacity: 0.65;-moz-opacity: 0.65;filter:alpha(opacity=65);}
		.privaAlertBlock{display:none;position:absolute;top:100px;left:300px;border:1px solid #ddd;width:740px;height:530px;z-index:9999;background:#fff;}
		.bgBlack{position:fixed;_position:absolute;background:black;top:0;left:0;width:100%;height:100%;z-index:9998;display:none;opacity: 0.65;-moz-opacity: 0.65;filter:alpha(opacity=65);}
		.alertBlock{display:none;position:absolute;top:100px;left:300px;border:1px solid #ddd;width:540px;height:530px;z-index:9999;background:#fff;padding-bottom:10px;}
		.headBlock{height:40px;line-height:40px;font-weight:normal;box-sizing:border-box;padding-left:30px;color:#666;border-bottom:1px solid #ddd;}
		.headBlock span{width:40px;height:40px;line-height:40px;text-align:center;display:block;position:absolute;right:-1px;;top:-1px;;cursor:pointer;}
		.headBlock span:hover{background:#ff7700;color:#fff;}
	</style>
</head>
<body class="fs-14px">

<script src="js/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="js/photoShow.js" type="text/javascript"></script>
<script src="js/observer.min.js" type="text/javascript" charset="utf-8"></script>
<script src="js/jquery.photosBox.min.js" type="text/javascript" charset="utf-8"></script>

<!--page start-->
<div class="page" id="page">
	<!--main start-->
	<div class="block main">
		<div class="full photosBox">
			<ul class="photosList" style=" background-image: url(images/zyz1.jpg);background-size:100% 100%;-moz-background-size:100% 100%;">
				<li class="photo bgColor-1"  style="background-image:url(images/zyz2.png)"><div class="img" style="background-image: url(images/zyz1.png)"></div></li>
			</ul>
			
		</div>
		<!--mainCenter start-->
		<div class="container mainCenter" id="loginBlcok">
			<!--loginArea start-->
			<div class="loginArea">
				
				<div class="title suitWidth fs-24px">
					平台用户登录
				</div>
				<!--from start-->
				<form id="loginform" method="post" action="login.do" onkeydown="if(event.keyCode==13){return false;}">
					<label class="input suitWidth" for="user">
					<div class="inputBg"></div>
					<span class="inputicon icon icon-user"></span>
					<input type="text" id="account" name="account" class="fs-18px"  
						placeholder="请输入用户名" onkeydown="loginEnter(this);" />
					</label>
					<div class="suitWidth tip tip-user tip-red fs-14px"></div>
					<label class="input suitWidth" for="key">
						<div class="inputBg"></div>
						<span class="inputicon icon icon-lock"></span>
						<input type="password" id="password" name="password" class="fs-18px" 
							placeholder="请输入登录密码" onkeydown="loginEnter(this);"/>
					</label>
					<div class="suitWidth tip tip-key tip-red fs-14px" id="tip"></div>
					<div class="suitWidth">
						<div class="checkbox">
							<label class="text fs-16px" for="remberAccount">
								<input type="checkbox" id="remberAccount" name="remberAccount" 
									class="hide inputCheckbox" value="1" onclick="checkRember(1);"/>
								<span class="selectIcon"></span>记住账号 
							 </label>
						</div>
						<div class="checkbox floatRight">
							<label class="text fs-16px" for="rememberPwd">
								<input type="checkbox" id="rememberPwd" name="rememberPwd" 
									class="hide inputCheckbox" value="1" onclick="checkRember(2);"/>
								<span class="selectIcon"></span>记住密码 
							 </label>
						</div>
						<!-- <div class="checkbox floatRight">
							<label class="text fs-16px" for="safelogin">
								<input type="checkbox" id="safelogin" name="safelogin" class="hide inputCheckbox"/>
								<span for="safelogin" class="selectIcon"></span>安全登录 
							</label>
						</div> -->
					</div>
					<input type="submit" id='loginBtn' class="btn btn-green suitWidth" value="登 录" />
					<div class="help suitWidth">
						<!-- <a href="#" class="forgetKey floatLeft fs-16px"> 忘记用户密码? </a>
						<a href="<%=basePath %>regist_toregister.do" class="register floatRight fs-16px"> 免费注册 </a>-->
						 
					</div>
				</form><!--from end-->
			</div><!--loginArea end-->
		</div><!--mainCenter end-->
	</div>
	<!--main end-->
	<!--header start-->
	<div class="block header">
		<div class="blackbg opacity-40"></div>
		<div class="container">
			<div class="title fs-32px">
				<img src="<%=basePath %>images/logo.png" class="title_img" />
				<span  class="title_text">种养殖溯源管理平台</span>
			</div> 
			<ul class="link">
				<li><a href="#">首页</a></li>
				<li class="divider"></li>
				<li><a href="#">帮助</a></li>
			</ul>
		</div>
	</div>
	<!--header end-->

	<!--footer start-->
	<div class="block footer">
		<div class="container">
			<p class="detail">
				<a>关于我们</a>
				<a>加入我们</a>
				<a>代理政策</a>
				<a>服务条款</a>
				<a>使用条款</a>
			</p>
			<!-- <div class="attention">
				<div class="title">关注我们：</div>
				<div class="icon icon-weibo"></div>
				<div class="icon icon-weixin"></div>
			</div> -->
		</div>
	</div>
	<!--footer end-->
</div><!--page end-->

<div class="privaAlertBlock">
	<iframe id="privaFrame" name="privaFrame" src="" style="width: 100%;height:100%;border:0;"></iframe>
	
</div>

<div class='privaBgBlack'></div>

<div class='bgBlack'></div>

<script type="text/javascript">
	//监听窗口加载
	window.observer.order("windowLoad",function(){
		resetFrame();
		
		//轮播图片设置
		var pB = $(".photosBox").photosBox({autoPlay:true, lrButton:false,suit:true, dots:true,delayTime:8000, animateSpeed:1500});
		window.observer.order("windowResize",function(){resetFrame();});
		//一张图片时隐藏轮播点
		$(".photosBox .dots span").css("display","none");
	});
	/**
	 * 重设框架宽高
	 */
	function resetFrame() {
		var $page = $("#page"),
			$main = $page.find(".main"),
			$header = $page.find(".header"),
			$footer = $page.find(".footer"),
			$loginBlcok = $("#loginBlcok");
		var winH = parseInt($(window).height()), winW = parseInt($(window).width()),
			otherH = $header.height()+$footer.height(),
			MinMainH = 400+otherH, MinW = 1000,
			W =( winW < MinW ? MinW :"100%" ),
			H = winH > MinMainH ? "100%" : MinMainH,
			endH = winH > MinMainH? winH:MinMainH,
			lbH = endH - otherH;
		$main.height(H).width(W);
		$header.width(W);
		$footer.width(W).css({top:endH+"px"});
		$loginBlcok.height(lbH).css({marginTop: (-endH)+"px",top:"100%"});
	}
	// 页面初始事件
	$(function() {// 将光标锁定在用户文本框
		document.getElementById("account").focus();
	
		if ('${tip}' != '') {
			$("#tip").html('${tip}');
		}
		
		var account = getCookie("cszsAccount");
		if (account && account.replace(/\"/g, "") != "") {
			$("#account").val(account);
			$("#remberAccount").prop("checked", true);
		}
		var password = getCookie("cszsPassword");
		if (password && password.replace(/\"/g, "") != "") {
			$("#password").val(password);
			$("#rememberPwd").prop("checked", true);
		}
	});
	
	function checkRember(flag) {
		if (flag == 1) {//点击记住账号
			//取消记住账号时同步取消记住密码
			if (!$("#remberAccount").prop("checked")) {
				$("#rememberPwd").prop("checked", false);
			}
		} else if (flag == 2) {//点击记住密码
			//记住密码时同步记住账号
			if ($("#rememberPwd").prop("checked")) {
				$("#remberAccount").prop("checked", true);
			}
			
		}
	}

	//读取cookies 
	function getCookie(name) {
		var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
		if (arr = document.cookie.match(reg))
			return unescape(arr[2]);
		else
			return null;
	}
	
	function loginEnter(_this) {
		if (event.keyCode==13) {
			if (_this.id == 'account') {
				$("#password").focus();
				return false;
			} else {
				$("#loginBtn").click();
			}
		}
	}
	
</script>
</body>
</html>