<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
 <%
	Integer type = null;
	String title = null;
	Node node = (Node) request.getSession().getAttribute("node");
	if (node == null) {
		type = -1;//超级管理
	}else{
		type = 1;
	}
 %>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>采购信息登记</title>
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
		var listInputs,listBusiness;
		$(function() {
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			$("#form-purchaseDate").datepicker("setDate",new Date());
			var nodeType = '${node.type}';
			
			//采购类型
			fullPurchaseType('',nodeType);
			
			//投入品信息
			getInputsList('');
			fullInputs();
			
			//经营者信息
			getBusinessList();
			fullBusiness();
			
		});
		
		function fullPurchaseType(purchaseType,nodeType){
			$("#form-purchaseType").find("option").remove();
			var opt = '<option value="">请选择</option>';
			if(nodeType!=undefined&&nodeType!=''){
				if( nodeType != undefined && nodeType == '<%=Constants.TYPE_VEGETABLES%>' ){
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%></option>';
				}else{
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%></option>';
				}
				opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>"';
				if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>'){
					opt += ' selected';
				}
				opt += '><%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%></option>';
			}
			
			$("#form-purchaseType").append(opt);
			//刷新插件
			$("#form-purchaseType").selectpicker('refresh'); 
		}
		
		//采购类型改变时
		function selectPurchaseChange(){
			getInputsList($("#form-purchaseType").val());
			fullInputs();
			
			var purchaseType = $("#form-purchaseType").val();
			if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>
			||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>){
				$("#organicDiv").css("display","");
				$("#transgenicDiv").css("display","none");
				if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>){
					$("#organicLabel").html("是否无毒副作用");
				}else{
					$("#organicLabel").html("是否有机");
				}
			}else if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>){
				$("#organicDiv").css("display","none");
				$("#transgenicDiv").css("display","");
			}else if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>){
				$("#organicDiv").css("display","none");
				$("#transgenicDiv").css("display","none");
			}else{//全有
				$("#organicDiv").css("display","");
				$("#transgenicDiv").css("display","");
				$("#organicLabel").html("是否有机");
			}
			
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
		
		//填充商品下拉列表
		function fullInputs(){
	  		$("#form-inputs").find("option").remove(); 
			if (listInputs && listInputs.length > 0) {
				var ops="";
				ops += '<option value="">请选择</option>';
				for (var i = 0; i < listInputs.length; i++) {
					ops += '<option value="' + listInputs[i].id + '@'+listInputs[i].name+'@'+listInputs[i].type;
					ops += '">' + listInputs[i].name + '</option>';
				}
				$("#form-inputs").append(ops);
			} else {
				var ops="";
				ops += '<option value="">请选择</option>';
				$("#form-inputs").append(ops);
			}

			if(ops!=""){
				$("#form-inputs").selectpicker({
			          'selectedText': 'cat'
			    });
			      
			     if( $("#form-inputs").val() != null && "" != $("#form-inputs").val() ){
		      		var formInputs = $("#form-inputs").val().split("@");
					$("#form-pId").val(formInputs[0]);
					$("#form-name").val(formInputs[1]);
					//$("#form-type").val(formInputs[2]);
		      	}
			}
			
			//刷新插件
			$("#form-inputs").selectpicker('refresh'); 
	  	}
	  	
	  	//投入品信息下拉框改变事件
	  	function selectInputsChange(){
	  		var purchaseType = $("#form-purchaseType").val();
	  		if(purchaseType==undefined||purchaseType==''){
	  			BootstrapDialog.alert("请先选择采购类型！");
	  			fullInputs();
	  		}else{
	  			var formInputs = $("#form-inputs").val().split("@");
				$("#form-pId").val(formInputs[0]);
				$("#form-name").val(formInputs[1]);
				//$("#form-type").val(formInputs[2]);
				
				fullPurchaseType(formInputs[2],'${node.type}');
	  		}
	  	}
	  	
	  	//获取经营者信息
		function getBusinessList(){
			$.ajax({
				url:'${basepath}business/getBusiness.do?type=<%=Constants.BUSINESS_TYPE_SUPPLIER%>',
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listBusiness = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//填充供应商下拉列表
		function fullBusiness(){
	  		$("#form-supplier").find("option").remove(); 
			if (listBusiness && listBusiness.length > 0) {
				var ops="";
				ops += '<option value="">请选择</option>';
				for (var i = 0; i < listBusiness.length; i++) {
					ops += '<option value="' + listBusiness[i].id + '@'+listBusiness[i].name+'">' + listBusiness[i].name + '</option>';
				}
				$("#form-supplier").append(ops);
			} else {
				var ops="";
				ops += '<option value="">请选择</option>';
				$("#form-supplier").append(ops);
			}

			if(ops!=""){
				$("#form-supplier").selectpicker({
			          'selectedText': 'cat'
			    });
			      
			     if( $("#form-supplier").val() != null && "" != $("#form-supplier").val() ){
		      		var formBusiness = $("#form-supplier").val().split("@");
					$("#form-supplierId").val(formBusiness[0]);
					$("#form-supplierName").val(formBusiness[1]);
		      	}
			}
			
			//刷新插件
			$("#form-supplier").selectpicker('refresh'); 
	  	}
	  	
	  	//产品信息下拉框改变事件
	  	function selectSupplierChange(){
	  		var formBusiness = $("#form-supplier").val().split("@");
			$("#form-supplierId").val(formBusiness[0]);
			$("#form-supplierName").val(formBusiness[1]);
	  	}
		
		function checkNotNull() {
			var msg = '';
			var pId = $("#form-pId").val();
			var purchaseDate = $("#form-purchaseDate").val();
			var purchaseNum = $("input[name='purchaseNum']:checked").val();
			var num = $("#form-num").val();
			var manufacturerDate = $("#form-manufacturerDate").val();
			var supplierId = $("#form-supplierId").val();
			
			if (pId == undefined || $.trim(pId) == '') {
				msg += ' 请选择投入品；<br>';
			}
			
			if (purchaseDate == undefined || $.trim(purchaseDate) == '') {
				msg += ' 采购日期不能为空；<br>';
			}
			
			if (purchaseNum == undefined || $.trim(purchaseNum) == ''){
				msg += ' 请选择采购数量或采购重量；<br>';
			}else{
				if(purchaseNum=="1"){
					$("#form-num").attr("name","purchaseAmount");
				}else{
					$("#form-num").attr("name","totalWeight");
				}
			}
			
			if (num == undefined || $.trim(num) == '') {
				msg += ' 采购数量/采购重量数值不能为空；<br>';
			}
			
			if (manufacturerDate == undefined || $.trim(manufacturerDate) == '') {
				msg += ' 产品生产日期不能为空；<br>';
			} 
			
			if (supplierId == undefined || $.trim(supplierId) == '') {
				msg += ' 请选择供应商；<br>';
			} 
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function savePurchaseInputs() {
			if(<%=type==-1%>) {
				$("#tip").html("超级管理员不能进行此操作");
				$("#saveBtn").prop("disabled", true);
				return;
			}
			
			$("#saveBtn").prop("disabled", false);
			if (checkNotNull()) {
				if (validateSql("purchaseInputsForm", 1)) {
		    		BootstrapDialog.alert(sqlErrorTips);
		    		$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
		    	} else {
					$.ajax({
						url: "${basepath}originPurchaseInputs/editOriginPurchaseInputs.do",
						type: "post",
						data: $("#purchaseInputsForm").serialize(),
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									$.ajax({
										url: "${basepath}originPurchaseInputs/synToSY.do",
										type: "post",
										data: {purchaseInputsId: data.id},
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
			$("#purchaseInputsForm")[0].reset();
			$("#form-purchaseDate").datepicker("setDate",new Date());
			fullPurchaseType('',"${node.type}");//采购类型
			//投入品信息
			getInputsList('');
			fullInputs();
			//经营者信息
			getBusinessList();
			fullBusiness();
			$("#form-result").selectpicker('refresh'); 
			$("#form-upperReaches").selectpicker('refresh');
			$("#form-sourceType").selectpicker('refresh');
			$("#form-organicFlag").selectpicker('refresh'); 
			$("#form-transgenicFlag").selectpicker('refresh'); 
		}
	</script>
	
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div style="height:100%;width: 100%;padding: 10px 0 10px;overflow-x:hidden;overflow-y: auto;">
		
		<form class="form-horizontal" id="purchaseInputsForm" role="form">
			<input type="hidden" id="id" name="id">
			
			<div style="float:left;width:46%;text-align:center">
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseType">
						<i class="fa fa-asterisk fa-1 red"></i>
						采购类型
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-purchaseType" name="purchaseType" onchange="selectPurchaseChange()">
    					</select>
					</div>
				</div>
			
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-inputs">
						<i class="fa fa-asterisk fa-1 red"></i>
						投入品名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-pId" name="pId">
						<input type="hidden" id="form-name" name="name">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-inputs"  onchange="selectInputsChange()">
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						采购日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-purchaseDate" name="purchaseDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-6 control-label no-padding-right" for="form-purchaseAmount">
						<i class="fa fa-asterisk fa-1 red"></i>
						<input type="radio" name="purchaseNum" value="1">
						采购数量
						<input type="radio" name="purchaseNum" value="2">
						采购重量
					</label>
					<div class="col-sm-6">
						<input type="text" class="form-control" id="form-num" name="">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchasePrice">
						采购单价
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-purchasePrice" name="purchasePrice">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseUnit">
						采购单位
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-purchaseUnit" name="purchaseUnit">
					</div>
				</div>
				
				<!--<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-totalWeight">
						<i class="fa fa-asterisk fa-1 red"></i>
						采购重量
					</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="form-totalWeight" name="totalWeight" min="1">
					</div>
 				</div> -->
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						产品生产日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-manufacturerDate" name="manufacturerDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-result">
						检验结果
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli"  id="form-result" name="result">
							<option value="">请选择</option>
							<option value="<%=Constants.PURCHASEINPUTS_RESULT_TYPE_UNPASS%>"><%=Constants.PURCHASEINPUTS_RESULT_TYPE_UNPASS_NAME%></option>
							<option value="<%=Constants.PURCHASEINPUTS_RESULT_TYPE_PASS%>"><%=Constants.PURCHASEINPUTS_RESULT_TYPE_PASS_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-supplier">
						<i class="fa fa-asterisk fa-1 red"></i>
						供应商名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-supplierId" name="supplierId">
						<input type="hidden" id="form-supplierName" name="supplierName">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-supplier"  onchange="selectSupplierChange()">
    					</select>
					</div>
				</div>
				
			</div>
	
			<div style="float:left;width:46%;text-align:center">
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-upperReaches">
						上游是否建立电子台账
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-upperReaches" name="upperReaches">
    						<option value="">请选择</option>
							<option value="<%=Constants.UPPERREACHES_NO%>"><%=Constants.UPPERREACHES_NO_NAME%></option>
							<option value="<%=Constants.UPPERREACHES_YES%>"><%=Constants.UPPERREACHES_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-sourceType">
						来源类型
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-sourceType" name="sourceType">
    						<option value="">请选择</option>
							<option value="<%=Constants.SOURCE_TYPE_SELF_PURCHASE%>"><%=Constants.SOURCE_TYPE_SELF_PURCHASE_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_CULTIVATE%>"><%=Constants.SOURCE_TYPE_CULTIVATE_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_AUTOTROPHIC%>"><%=Constants.SOURCE_TYPE_AUTOTROPHIC_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_WILD%>"><%=Constants.SOURCE_TYPE_WILD_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group" id="organicDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-organicFlag" id="organicLabel">
						是否有机
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli"  id="form-organicFlag" name="organicFlag">
    						<option value="">请选择</option>
							<option value="<%=Constants.ORGANIC_FLAG_NO%>"><%=Constants.ORGANIC_FLAG_NO_NAME%></option>
							<option value="<%=Constants.ORGANIC_FLAG_YES%>"><%=Constants.ORGANIC_FLAG_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group" id="transgenicDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-transgenicFlag">
						是否转基因
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-transgenicFlag" name="transgenicFlag">
    						<option value="">请选择</option>
							<option value="<%=Constants.TRANSGENIC_FLAG_NO%>"><%=Constants.TRANSGENIC_FLAG_NO_NAME%></option>
							<option value="<%=Constants.TRANSGENIC_FLAG_YES%>"><%=Constants.TRANSGENIC_FLAG_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalId">
						采购负责人代码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-principalId" name="principalId">
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalName">
						采购负责人姓名
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-principalName" name="principalName">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-periodDate">
						产品保质期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-periodDate" name="periodDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerId">
						生产商代码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-manufacturerId" name="manufacturerId">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerName">
						生产商名称
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-manufacturerName" name="manufacturerName">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="license">
						生产经营许可证编号
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-license" name="license">
					</div>
				</div>
			</div>
			
			<div style="float:left;width:100%;text-align:center">
				<div class="tip-red" id="tip"></div>
				<div class="form-group">
					<div class="col-sm-12">
						<button class="btn" id="saveBtn" onclick="savePurchaseInputs();return false;">确定</button>
					</div>
				</div>
			</div>

		</form>
	</div>
</body>
</html>
