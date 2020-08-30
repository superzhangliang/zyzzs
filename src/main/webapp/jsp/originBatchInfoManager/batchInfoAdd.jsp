<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
 <%
	Integer type = null;
	String title = null;
	Node node = (Node) request.getSession().getAttribute("node");
	if (node != null) {
		type = node.getType();
		if (type == 1) {
			title = "养殖";
		} else {
			title = "种植";
		}
	} else {
		type = -1;
		title = "种养殖";
	}
 %>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>进场管理</title>
	<%@include file="../head.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	<script src="${basepath}/js/areainfo.js"></script>
	
	<style type="text/css">
		table tr td { padding: 2px;}
		#saveBtn {width: 90px; background-color: #428bca !important;; color: #fff !important;}
		#saveBtn:HOVER {background-color: #1b6aaa !important;}
		.tip-red {color: #dd3333; height: 35px; line-height: 30px; font-size:14px;}
	</style>
	<script type="text/javascript">
		
		var listProds;
		$(function() {
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			$("#form-prodStartDate").datepicker("setDate",new Date());
			getProdsList();
			fullProds();
			
			if(<%=type==2 %>) {
				$("#qtyDiv").css("display","none");
  			    $("#acreageDiv").css("display","");
  			    $("#form-unit").val("亩");
  			    $("#form-unit").attr("readonly","readonly");
			}else if(<%=type==1 %>){
				$("#qtyDiv").css("display","");
  			    $("#acreageDiv").css("display","none");
			}else{
				$("#qtyDiv").css("display","");
  			    $("#acreageDiv").css("display","");
  			    $("#form-unit").val("亩");
  			    $("#form-unit").attr("readonly","readonly");
			}
			
		});
		
		//获取产品信息
		function getProdsList(){
			$.ajax({
				url:'${basepath}prodManager/getProdManager.do?isDelete=0',
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listProds = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//填充商品下拉列表
		function fullProds(){
	  		$("#form-prods").find("option").remove(); 
			if (listProds && listProds.length > 0) {
				var ops="";
				ops += '<option value="">请选择</option>';
				for (var i = 0; i < listProds.length; i++) {
					ops += '<option value="' + listProds[i].id + '@'+listProds[i].name+'">' + listProds[i].name + '</option>';
				}
				$("#form-prods").append(ops);
			} else {
				var ops="";
				ops += '<option value="">请选择</option>';
				$("#form-prods").append(ops);
			}

			if(ops!=""){
				$("#form-prods").selectpicker({
			          'selectedText': 'cat'
			    });
			      
			     if( $("#form-prods").val() != null && "" != $("#form-prods").val() ){
		      		var formProds = $("#form-prods").val().split("@");
					$("#form-prodId").val(formProds[0]);
					$("#form-prodName").val(formProds[1]);
		      	}
			}
			
			//刷新插件
			$("#form-prods").selectpicker('refresh'); 
	  	}
	  	
	  	//产品信息下拉框改变事件
	  	function selectBusinessChange(){
	  		var formProds = $("#form-prods").val().split("@");
	  		$("#form-prodId").val(formProds[0]);
	  		$("#form-goodsName").val(formProds[1]);
	  	}
		
		function checkNotNull() {
			var msg = '';
			
			var prodStartDate = $("#form-prodStartDate").val();
			var goodsName = $("#form-goodsName").val();
			var qty = $("#form-qty").val();
			var acreage = $("#form-acreage").val();
			
			if (prodStartDate == undefined || $.trim(prodStartDate) == '') {
				msg += ' <%=title%>开始日期不能为空；<br>';
			}
			if (goodsName == undefined || $.trim(goodsName) == '') {
				msg += ' 产品名称不能为空；<br>';
			}
			if(<%=type==2 %>) {
				if (acreage == undefined || $.trim(acreage) == '') {
					msg += ' <%=title%>面积不能为空；<br>';
				}
			}else if(<%=type==1 %>){
				if (qty == undefined || $.trim(qty) == '') {
					msg += ' <%=title%>数量不能为空；<br>';
				}
			}else{
				if( (acreage == undefined || $.trim(acreage) == '') && (qty == undefined || $.trim(qty) == '') ){
					msg += ' <%=title%>数量和面积不能同时为空；<br>';
				}
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function saveBatchIn() {
			if(<%=type==-1%>) {
				$("#tip").html("超级管理员不能进行此操作");
				$("#saveBtn").prop("disabled", true);
				return;
			}
			
			$("#saveBtn").prop("disabled", false);
			if (checkNotNull()) {
				if (validateSql("batchInfoForm", 1)) {
	    			BootstrapDialog.alert(sqlErrorTips);
	    			$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
	    		} else {
	    			$.ajax({
						url: "${basepath}originBatchInfo/editOriginBatchInfo.do",
						type: "post",
						data: $("#batchInfoForm").serialize(),
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									$.ajax({
										url: "${basepath}originBatchInfo/synToSY.do",
										type: "post",
										data: {batchInfoId: data.id},
										dataType:"json",
										success:function(data){
										}
									});
									BootstrapDialog.alert("操作成功！");
									resetForm();
									// 更新产品信息
									fullProds();
								} else {
									BootstrapDialog.alert(data.msg);
								}
								$("#saveBtn").prop("disabled", false);
							}
						},
						error: function(e) {
							BootstrapDialog.alert("提交异常");
							$("#saveBtn").prop("disabled", false);//提交失败,提交按钮可用
						}
					});
	    		}
			} else {
				$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
			}
		}
		
		function resetForm() {
			$("#batchInfoForm")[0].reset();
			$("#form-prodStartDate").datepicker("setDate",new Date());
			if(<%=type==2 %>) {
				$("#qtyDiv").css("display","none");
  			    $("#acreageDiv").css("display","");
  			    $("#form-unit").val("亩");
  			    $("#form-unit").attr("readonly","readonly");
			}else if(<%=type==1 %>){
				$("#qtyDiv").css("display","");
  			    $("#acreageDiv").css("display","none");
			}else{
				$("#qtyDiv").css("display","");
  			    $("#acreageDiv").css("display","");
  			    $("#form-unit").val("亩");
  			    $("#form-unit").attr("readonly","readonly");
			}
			selectBusinessChange();
		}
	</script>
	
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div style="height:100%;width: 75%;padding: 50px 0 10px;overflow-x:hidden;overflow-y: auto;text-align:center">
		
		<form class="form-horizontal" id="batchInfoForm" role="form">
			<input type="hidden" id="id" name="id">

		<div style="width:75%;text-align:center;margin:0 auto;">

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-prodStartDate">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>开始日期
				</label>
				<div class="col-sm-8">
					<div class="input-group">
						<input class="form-control date-picker" id="form-prodStartDate" name="prodStartDate" 
							data-date-format="yyyy-mm-dd" readonly>
						<span class="input-group-addon">
							<i class="fa fa-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-goodsName">
					<i class="fa fa-asterisk fa-1 red"></i>
					产品名称
				</label>
				<div class="col-sm-8">
					<input type="hidden" class="form-control" id="form-prodId" name="prodId">
					<input type="hidden" id="form-goodsName" class="form-control">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-prods" onchange="selectBusinessChange()">
    				</select>
				</div>
			</div>
			
			<div class="form-group" id="qtyDiv">
				<label class="col-sm-4 control-label no-padding-right" for="form-qty">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>数量
				</label>
				<div class="col-sm-8">
					<input type="number" class="form-control" id="form-qty" name="qty" min="1">
					</div>
			</div>
			
			<div class="form-group" id="acreageDiv">
				<label class="col-sm-4 control-label no-padding-right" for="form-acreage">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>面积
				</label>
				<div class="col-sm-8">
					<input type="number" class="form-control" id="form-acreage" name="acreage" min="1">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-acreage">
					单位
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-unit" name="unit">
				</div>
			</div>
			
			<div class="form-group" id="acreageDiv">
				<label class="col-sm-4 control-label no-padding-right" for="form-principalId">
					负责人身份证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-principalId" name="principalId">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-principalName">
					负责人姓名
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-principalName" name="principalName">
				</div>
			</div>
		</div>
		
			<div style="float:left;width:123%;text-align:center">
				<div class="tip-red" id="tip"></div>
				<div class="form-group">
					<div class="col-sm-12">
						<button class="btn" id="saveBtn" onclick="saveBatchIn();return false;">确定</button>
					</div>
				</div>
			</div>

		</form>
	</div>
</body>
</html>
