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
	<title>收获管理</title>
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
		#saveBtn {width: 90px; background-color: #428bca !important;; color: #fff !important;;}
		#saveBtn:HOVER {background-color: #1b6aaa !important;}
		.tip-red {color: #dd3333; height: 35px; line-height: 30px; font-size:14px;}
	</style>
	<script type="text/javascript">
		
		var listBatchInfo, LODOP, printContent;
		var type = '${node.type}';
		
		$(function() {
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			$("#form-harvestDate").datepicker("setDate",new Date());
			getBatchInfoList();
			fullBatchInfo();
			inintResult();
		});
		
		//初始化检测结果
		function inintResult(){
			var html = '';
			if(type == '1') {
				    html += '<select class="form-control" id="form-result" name="result">';
				    html +=		'<option value="">请选择</option>';
				    html +=		'<option value="1">合格</option>';
				    html +=		'<option value="0">不合格</option>';
				    html += '</select>';
				$("#resultLabel").html("检测结果");
			}else {
				html += '<input type="text" class="form-control" id="form-result" name="result">';
				$("#resultLabel").html("检测结果(农残抑制率)");
			} 
			$("#resultDiv").html(html);
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
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listBatchInfo && listBatchInfo.length > 0) {
				
				for (var i = 0; i < listBatchInfo.length; i++) {
					
					ops += '<option value="' + listBatchInfo[i].prodId + '@'+(listBatchInfo[i].prodName == undefined ? '' : listBatchInfo[i].prodName )
					+'@'+ listBatchInfo[i].prodBatchId + '"';
					ops += ' >' + listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
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
	  		var formOutInfo = $("#form-batch").val().split("@");
	  		
	  		$("#form-prodId").val(formOutInfo[0]);
	  		$("#form-prodName").val(formOutInfo[1]);
	  		$("#form-prodBatchId").val(formOutInfo[2]);
	  	}
		
		//保存交易信息
		function saveHarvestInfo() {
			if(<%=type==-1%>) {
				$("#tip").html("超级管理员不能进行此操作");
				$(".save").prop("disabled", true);
				return;
			}
			$("#saveBtn").prop("disabled", true);
			if (checkNotNull()) {
				if (validateSql("harvestInfoForm", 1)) {
		    		BootstrapDialog.alert(sqlErrorTips);
		    		$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
		    	} else {
		    		$.ajax({
						url: "${basepath}originHarvestInfo/editOriginHarvestInfo.do",
						type: "post",
						data: $("#harvestInfoForm").serialize(),
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									BootstrapDialog.alert("操作成功！");
									$.ajax({
										url: "${basepath}originHarvestInfo/synToSY.do",
										type: "post",
										data: {harvestInfoId: data.id},
										dataType:"json",
										success:function(data){
										}
									 }); 
									
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
        
        function resetForm(){
			$("#harvestInfoForm")[0].reset();
			selectBatchIdChange();
			$("#form-harvestDate").datepicker("setDate",new Date());
			inintResult();
			fullBatchInfo();
		}
		
		function checkNotNull() {
			var msg = '';
			var prodBatchId = $("#form-prodBatchId").val();
			var harvestDate = $("#form-harvestDate").val();
			var prodName = $("#form-prodName").val();
			var weight = $("#form-weight").val();
			var amount = $("#form-amount").val();
			var unit = $("#form-unit").val();
			
			if (prodBatchId == undefined || $.trim(prodBatchId) == '') {
				msg += ' <%=title%>批次号不能为空；<br>';
			}
			if (harvestDate == undefined || $.trim(harvestDate) == '') {
				msg += ' 收获日期不能为空；<br>';
			}
			if (prodName == undefined || $.trim(prodName) == '') {
				msg += ' 产品名称不能为空；<br>';
			}
			
			if (weight == undefined || $.trim(weight) == '') {
				msg += '重量不能为空；<br>';
			}
			if (amount != undefined && $.trim(amount) != '') {
				if (unit == undefined || $.trim(unit) == '') {
					msg += '请填写计量单位；<br>';
				}
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div style="height:100%;width: 100%;padding: 10px 0 10px;overflow-x:hidden;overflow-y: auto;">
		
		<form class="form-horizontal" id="harvestInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodBatchId">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>批次号
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-prodBatchId" name="prodBatchId">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-batch"  onchange="selectBatchIdChange()">
    					</select>
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-harvestDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						收获日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-harvestDate" name="harvestDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodName">
						<i class="fa fa-asterisk fa-1 red"></i>
						产品名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-prodId" name="prodId">
						<input type="text" class="form-control" id="form-prodName" name="prodName" readOnly>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-weight">
						<i class="fa fa-asterisk fa-1 red"></i>
						重量
					</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="form-weight" name="weight" min="1">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-amount">
						数量
					</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="form-amount" name="amount" min="1">
					</div>
				</div> 
				
			</div>
	
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-unit">
						计量单位
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-unit" name="unit">
					</div>
				</div> 
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-result" id="resultLabel">
						
					</label>
					<div class="col-sm-8" id="resultDiv">
					</div>
				</div>
				
				<div class="form-group" id="sheetNoDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-sheetNo">
						检测单号
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-sheetNo" name="sheetNo">
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalId">
						收获负责人代码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-principalId" name="principalId">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalName">
						收获负责人姓名
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
						<button class="btn save" id="saveBtn" onclick="saveHarvestInfo();return false;">确定</button>
					</div>
				</div>
			</div>

		</form>
	</div>
</body>
</html>
