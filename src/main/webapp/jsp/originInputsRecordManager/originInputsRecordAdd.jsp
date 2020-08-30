<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
 <%
	Integer type = null;
	String title = null;
	/* Node node = (Node) session.getAttribute("node"); */
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
		var listBatchInfo;
		var listInputs;
		$(function() {
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			$("#form-usedDate").datepicker("setDate",new Date());
			
			getBatchInfoList();
			fullBatchInfo();
			
			var nodeType = '${node.type}';
			//投入品类型
			fullInputsType('',nodeType);
			
			getInputsList();
			fullInputs();
		});
		
		function fullInputsType(inputsType,nodeType){
			$("#form-inputsType").find("option").remove();
			var opt = '<option value="">请选择</option>';
			if(nodeType!=undefined&&nodeType!=''){
				if( nodeType != undefined && nodeType == '<%=Constants.TYPE_VEGETABLES%>' ){
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%></option>';
				}else{
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>"';
					if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%></option>';
				}
				opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>"';
				if(inputsType=='<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>'){
					opt += ' selected';
				}
				opt += '><%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%></option>';
			}
			
			$("#form-inputsType").append(opt);
			//刷新插件
			$("#form-inputsType").selectpicker('refresh'); 
		}
		
		//采购类型改变时
		function selectInputsTypeChange(){
			getInputsList($("#form-inputsType").val());
			fullInputs();
		}
		
		//获取种养殖批次号
		function getBatchInfoList(){
			$.ajax({
				url:'${basepath}originBatchInfo/getOriginBatchInfo.do',
				type:'post',
				dataType:'json',
				async:false,
				success:function(data){
					listBatchInfo = eval(data.rows);
				},
				error:function(){
					$.ligerDialog.error('操作失败！');
				}
			});
		}
		
		//填充种养殖批次号下拉列表
		function fullBatchInfo(){
	  		$("#form-batch").find("option").remove(); 
	  		var ops = '';
	  		ops += '<option value="">请选择</option>';
	  		if (listBatchInfo && listBatchInfo.length > 0) {
	  			
				for (var i = 0; i < listBatchInfo.length; i++) {
					ops += '<option value="'+ listBatchInfo[i].prodBatchId + '"';
					ops += ' >' +listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
				}
				
			}
			$("#form-batch").append(ops);
			
			$("#form-batch").selectpicker({
                'selectedText': 'cat'
            });
            
            //刷新插件
			$("#form-batch").selectpicker('refresh');
			
	  	}
	  	
	  	//种养殖批次号下拉框改变事件
	  	function selectBatchIdChange(){
	  		var formBatchInfo = $("#form-batch").val().split("@");
	  		$("#form-prodBatchId").val(formBatchInfo[0]);
	  	} 
	  	
	  	//获取投入品信息
		function getInputsList(type){
			if(type==undefined||type==null){
				type='';
			} 
			$.ajax({
				url:'${basepath}inputsManager/getInputsManager.do?type='+type,
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listInputs = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
	  	//填充投入品名称
		function fullInputs(){
			$("#form-inputs").find("option").remove();
			var ops;
				ops += '<option value="">'+'请选择'+'</option>';
			if( listInputs && listInputs.length > 0 ){
				for(var i=0;i<listInputs.length;i++){
					ops += '<option value="' + listInputs[i].id + '@' + listInputs[i].unit+'@'+listInputs[i].type +'@'+listInputs[i].num+'"';
					ops += '>' + listInputs[i].name + '</option>';
				}
			}
			
			$("#form-inputs").append(ops);
			
			if(ops!=""){
	  			$("#form-inputs").selectpicker({
	                'selectedText': 'cat'
	            }); 
	            
	            if( $("#form-inputs").val() != null && "" != $("#form-inputs").val() ){
            		var formInputs = $("#form-inputs").val().split("@");
		  			$("#form-inputsId").val(formInputs[0]);
		  			$("#form-unit").val(formInputs[1]);
            	}
	  		}
            
	  		//刷新插件
			$("#form-inputs").selectpicker('refresh');
		} 
		
		//投入品名称下拉框改变事件
		function selectInputsChange() {
			var formInputs = $("#form-inputs").val().split("@");
	  		
	  		$("#form-inputsId").val(formInputs[0]);
		  	$("#form-unit").val(formInputs[1]);
		  	$("#form-allNum").val(formInputs[3]);
		  	
		  	
		  	fullInputsType(formInputs[2],'${node.type}');
		}
	  	
		function checkNotNull() {
			var msg = '';
			
			var usedDate = $("#form-usedDate").val();
			var prodBatchId = $("#form-prodBatchId").val();
			var inputsId = $("#form-inputsId").val();
			var inputsNumName = $("input[name='inputsNumName']:checked").val();
			var num = $("#form-num").val();
			var allNum = $("#form-allNum").val();
			
			if (usedDate == undefined || $.trim(usedDate) == '') {
				msg += ' 使用日期不能为空；<br>';
			}
			if (prodBatchId == undefined || $.trim(prodBatchId) == '') {
				msg += ' <%=title%>批次号不能为空；<br>';
			}
			if (inputsId == undefined || $.trim(inputsId) == '') {
				msg += ' 投入品名称不能为空；<br>';
			}
			
			if (inputsNumName == undefined || $.trim(inputsNumName) == ''){
				msg += ' 请选择投入数量或投入重量；<br>';
			}else{
				if(inputsNumName=="1"){
					$("#form-num").attr("name","amount");
				}else{
					$("#form-num").attr("name","weight");
				}
			}
			
			if (num == undefined || $.trim(num) == '') {
				msg += ' 投入数量/投入重量数值不能为空；<br>';
			}
			
			if(Number(num)>Number(allNum)){
				msg += ' 投入数量/投入重量数值不能大于库存；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function saveInputsRecord() {
			if(<%=type==-1%>) {
				$("#tip").html("超级管理员不能进行此操作");
				$("#saveBtn").prop("disabled", true);
				return;
			}
			$("#saveBtn").prop("disabled", false);
			if (checkNotNull()) {
				if (validateSql("inputsRecordForm", 1)) {
		    		BootstrapDialog.alert(sqlErrorTips);
		    		$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
		    	} else {
		    		$.ajax({
						url: "${basepath}originInputsRecord/editOriginInputsRecord.do",
						type: "post",
						data: $("#inputsRecordForm").serialize(),
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									$.ajax({
										url: "${basepath}originInputsRecord/synToSY.do",
										type: "post",
										data: {inputsRecordId: data.id},
										dataType:"json",
										success:function(data){
										}
									});
									BootstrapDialog.alert("操作成功！");
									resetForm();
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
			$("#inputsRecordForm")[0].reset();
			$("#form-usedDate").datepicker("setDate",new Date());
			
			//投入品类型
			fullInputsType('',"${node.type}");
			
			//投入品信息
			getInputsList('');
			fullInputs();
			
			fullBatchInfo();
			selectBatchIdChange();
		}
	</script>
	
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div style="height:100%;width: 100%;padding: 10px 0 10px;overflow-x:hidden;overflow-y: auto;text-align:center">
		
		<form class="form-horizontal" id="inputsRecordForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-allNum" name="allNum">

		<div style="float:left;width:46%;text-align:center">
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-prodBatchId">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>批次号
				</label>
				<div class="col-sm-8" id="batchIdDiv">
					<input type="hidden" id="form-prodBatchId" name="prodBatchId">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-batch"  onchange="selectBatchIdChange()">
    				</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-usedDate">
					<i class="fa fa-asterisk fa-1 red"></i>
					使用日期
				</label>
				<div class="col-sm-8">
					<div class="input-group">
						<input class="form-control date-picker" id="form-usedDate" name="usedDate" 
							data-date-format="yyyy-mm-dd" readonly>
						<span class="input-group-addon">
							<i class="fa fa-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-inputsType">
					<i class="fa fa-asterisk fa-1 red"></i>
					投入品类型
				</label>
				<div class="col-sm-8">
					<select class="form-control selectpicker"  id="form-inputsType" name="inputsType"  onchange="selectInputsTypeChange()">
					</select>
				</div>
			</div>	
	
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-inputs">
					<i class="fa fa-asterisk fa-1 red"></i>
					投入品名称
				</label>
				
				<div class="col-sm-8" id="inputsNameDiv">
					<input type="hidden" id="form-inputsId" name="inputsId">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"
					id="form-inputs"  onchange="selectInputsChange()"></select>
				</div>
			</div>

		</div>
		<div style="float:left;width:46%;text-align:center">
			<div class="form-group">
				<label class="col-sm-6 control-label no-padding-right" for="form-num">
					<i class="fa fa-asterisk fa-1 red"></i>
					<input type="radio" name="inputsNumName" value="1">
					投入数量
					<input type="radio" name="inputsNumName" value="2">
					投入重量
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-num" name="">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-unit">
					投入品使用单位
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-unit" name="unit" readonly>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-principalId">
					投入负责人代码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-principalId" name="principalId">
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-principalName">
					投入负责人姓名
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-principalName" name="principalName">
				</div>
			</div>
		</div>
			
			<div style="float:left;width:100%;text-align:center">
				<div class="tip-red" id="tip"></div>
				<div class="form-group">
					<div class="col-sm-12">
						<button class="btn" id="saveBtn" onclick="saveInputsRecord();return false;">确定</button>
					</div>
				</div>
			</div>

		</form>
	</div>
</body>
</html>
