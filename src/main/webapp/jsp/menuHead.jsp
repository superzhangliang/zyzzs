<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title></title>
	<jsp:include page="zTree.jsp" flush="true"></jsp:include>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<script src="${basepath}js/echarts.common.min.js"></script>
	<style>
		html,body{height:100%;}
	</style>
</head>
<body style="overflow: hidden;">
	<div class="breadcrumbs" id="breadcrumbs">
		<script type="text/javascript">
			try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){}
		</script>

		<ul class="breadcrumb">
			<li>
				<i class="ace-icon fa fa-home home-icon"></i>
				<a href="${basepath }jsp/homePage.jsp">首页</a>>>>
				<span id="menu2"></span>>>><span id="menu1"></span>
			</li>
		</ul>
	</div>
</body>
</html>
