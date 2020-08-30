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
	<title>使用管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	<script src="${basepath}/js/areainfo.js"></script> 
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
	
		var table, selectRowId;
		var listInputs;
		var prodBatchId = '';
		var inputsId = '';
		var startDate = '';
		var endDate = '';
		var total=0;
		var listBatchInfo;
		var flag = 0;//0：代表新增，1：代表修改
		$(function() {
			if(<%=type==-1%>) {
				$("#addButton").attr("style","display:none;");
				$("#exportButton").attr("style","display:none;");
			}
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			table.bootstrapTable({
				url: "${basepath}originInputsRecord/getOriginInputsRecord.do",
				columns: [ {
					field: "prodBatchId",
					title: "<%=title%>批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "inputsName",
					title: "投入品名称",
					align: "center",
					valign: "middle"
				}, {
					field: "usedDate",
					title: "使用日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "num",
					title: "投入数量/投入重量",
					align: "center",
					valign: "middle",
					formatter:function(value,row){
						var url='';
						if( row.amount != undefined && Number(row.amount)!=0 ){
							url = row.amount+row.unit;
						}else if( row.weight != undefined && Number(row.weight)!=0 ){
							url = row.weight+row.unit;
						}
						return url;
					}
				},{
					field: "isReport",
					title: "状态",
					align: "center",
					valign: "middle",
					formatter: function (value, row) {
						var val = "";
						if(value == 0) {
							val = "未同步";
						} else {
							val = "已同步";
						}
						return val;
					}
				}],
				pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
				method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id',
				//加载成功时执行
				onLoadSuccess: function(data){ 
					if(data!=null&&data!=''){
						total=data.total;
					}
			    }
			});
			
			/* 监听窗口改变,重设高度值 */
			window.onresize = function(){
				var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
				table.bootstrapTable("resetView",{height:gridH});
			};
			
			//绑定选中行事件
			table.on('click-row.bs.table', function (e, row, $element) {
				$('.success').removeClass('success');
				$($element).addClass('success');
				selectRowId = row.id;
			});
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
			getInputsList('');
			fullInputs("inputsId",'');
			getBatchInfoList();
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
			fullInputs("form-inputs",'');
		}
		
		//获取种养殖批次号
		function getBatchInfoList(){
			$.ajax({
				url:'${basepath}originBatchInfo/getOriginBatchInfo.do',
				type:'post',
				dataType:'json',
				success:function(data){
					listBatchInfo = eval(data.rows);
				},
				error:function(){
					$.ligerDialog.error('操作失败！');
				}
			});
		}
		
		//填充种养殖批次号下拉列表
		function fullBatchInfo(prodBatchId){
	  		$("#form-batch").find("option").remove(); 
	  		var ops = '';
	  			ops += '<option value="">请选择</option>';
	  		if (listBatchInfo && listBatchInfo.length > 0) {
				for (var i = 0; i < listBatchInfo.length; i++) {
					ops += '<option value="' + listBatchInfo[i].prodId + '@'
						+(listBatchInfo[i].prodName == undefined ? '' : listBatchInfo[i].prodName )+ '@'
						+ listBatchInfo[i].prodBatchId + '"';
					if( prodBatchId != null && prodBatchId != "" && prodBatchId == listBatchInfo[i].prodBatchId){
						ops += ' selected ';
					}
					ops += ' >' +listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
				}
			}
			$("#form-batch").append(ops);
			$("#form-batch").selectpicker({
                'selectedText': 'cat'
            });
			
			if(ops!=""&&flag==0){
				var formBatchInfo = $("#form-batch").val().split("@");
		  		
		  		$("#form-prodId").val(formBatchInfo[0]);
		  		$("#form-prodName").val(formBatchInfo[1]);
		  		$("#form-prodBatchId").val(formBatchInfo[2]);
			}
			//刷新插件
			$("#form-batch").selectpicker('refresh'); 
	  	}
	  	
	  	//种养殖批次号下拉框改变事件
	  	function selectBatchIdChange(){
	  		var formBatchInfo = $("#form-batch").val().split("@");
	  		
	  		$("#form-prodId").val(formBatchInfo[0]);
	  		$("#form-prodName").val(formBatchInfo[1]);
	  		$("#form-prodBatchId").val(formBatchInfo[2]);
	  		
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
		function fullInputs( optName,inputsId ){
			if(optName!=undefined&&optName=="form-inputs"){
				$("#"+optName+"").find("option").remove();
				var ops;
					ops += '<option value="">'+'请选择'+'</option>';
				if( listInputs && listInputs.length > 0 ){
					for(var i=0;i<listInputs.length;i++){
						ops += '<option value="' + listInputs[i].id + '@' + listInputs[i].unit + '@' + listInputs[i].type +'@' + listInputs[i].num+'"';
						if( inputsId != null && inputsId != "" && inputsId == listInputs[i].id ){
							ops += 'selected';
						}
						ops += '>' + listInputs[i].name + '</option>';
					}
				}
				$("#"+optName+"").append(ops);
				
				if(ops!=""){
		  			$("#"+optName+"").selectpicker({
		                'selectedText': 'cat'
		            }); 
		            
		            if( $("#"+optName+"").val() != null && "" != $("#form-inputs").val() ){
	            		var formInputs = $("#form-inputs").val().split("@");
			  			$("#form-inputsId").val(formInputs[0]);
			  			$("#form-unit").val(formInputs[1]);
	            	}
		  		}
	            
		  		//刷新插件
				$("#"+optName+"").selectpicker('refresh');
			}else{
				$("#"+optName+"").find("option").remove();
				var ops;
				ops += '<option value="">'+'请选择'+'</option>';
				if( listInputs && listInputs.length > 0 ){
					for(var i=0;i<listInputs.length;i++){
						ops += '<option value="' + listInputs[i].id + '"';
						if( inputsId != null && inputsId != "" && inputsId == listInputs[i].id ){
							ops += 'selected';
						}
						ops += '>' + listInputs[i].name + '</option>';
					}
				}
				$("#"+optName+"").append(ops);
			}
			
		} 
		
		//投入品名称下拉框改变事件
		function selectInputsChange() {
			var formInputs = $("#form-inputs").val().split("@");
	  		
	  		$("#form-inputsId").val(formInputs[0]);
		  	$("#form-unit").val(formInputs[1]);
		  	$("#form-allNum").val(formInputs[3]);
	  		fullInputsType(formInputs[2],'${node.type}');
		}
		
	  	
		//搜索
		function search() {
			if (validateSql("prodBatchId,inputsName,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				prodBatchId = document.getElementById("prodBatchId").value;
				inputsId = document.getElementById("inputsId").value;
				startDate = document.getElementById("start").value;
				endDate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "prodBatchId": prodBatchId, "inputsId": inputsId, "htmlStartDate":startDate, "htmlEndDate":endDate},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#prodBatchId").val("");
			$("#inputsId").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		//新增使用信息
		function addInputs() {
			//显示对话框
			BootstrapDialog.show({
				size:BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增投入品使用信息</h5>",
	            message: template('inputsTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					
					//投入品类型
					fullInputsType('','${node.type}');
					
					var addHtml = '';
					addHtml += '<input type="hidden" id="form-prodBatchId" name="prodBatchId">';
					addHtml += '<select class="form-control selectpicker bla bla bli" data-live-search="true" '+
					' id="form-batch"  onchange="selectBatchIdChange()"></select>';
					$("#batchIdDiv").html(addHtml);
					flag = 0; //新增
					
					//清空表单信息
					$("#inputsForm")[0].reset();
					
					$("#form-usedDate").datepicker( "setDate", new Date() );
					
					fullBatchInfo();
					fullInputs("form-inputs",'');
	            },
	            buttons: [{
	                label: '取消',
	                action: function(dialog){
	                    dialog.close();
	                }
	            }, {
	                label: '确定',
	                cssClass: 'btn-primary',
	                action: function(dialog){
	                	var $button = this;
	                	$button.disable();
						if (checkNotNull()) {
							if (validateSql("inputsForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();
					    	} else {
					    		$.ajax({
									url: "${basepath}originInputsRecord/editOriginInputsRecord.do",
									type: "post",
									data: $("#inputsForm").serialize(),
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
														search();
													}
												});
												
												dialog.close();
											}  else {
												$button.enable();//提交失败,提交按钮可用
											}
											BootstrapDialog.alert(data.msg);
										}
									},
									error: function() {
										BootstrapDialog.alert("提交异常！");
										$button.enable();//提交失败,提交按钮可用
									}
								});
					    	}
						} else {
							$button.enable();//验证失败,提交按钮可用
						}
	                }
	            }]
	        });
		}
		
		//修改使用信息
		function updateInputs() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的投入品使用信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
				size:BootstrapDialog.SIZE_FULL,
	            title: "<h5>修改投入品使用信息：<span class='orange2'>" + row.prodBatchId + "</span></h5>",
	            message: template('inputsTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					//清空表单信息
					$("#inputsForm")[0].reset();
					
					var htmlDiv = '';
					htmlDiv += '<input type="text" class="form-control" id="form-prodBatchId" name="prodBatchId" value="'+row.prodBatchId+'" readonly>';
	            	$("#batchIdDiv").html(htmlDiv);
	            	
					
					
					//初始化表单数据
					$("#id").val(row.id);
					//使用日期
					$("#form-usedDate").datepicker( "setDate", formatTimeStr(row.usedDate) );
					//投入品类型
					fullInputsType(row.inputsType,row.type);
					//投入品名称、使用单位
					fullInputs("form-inputs",row.inputsId);
					selectInputsChange();
					
					if(row.amount!=undefined&&Number(row.amount)!=0){
						$("#form-num").val(row.amount);
						$("input:radio[value='1']").attr('checked','true');
					}else if(row.weight!=undefined&&Number(row.weight)!=0){
						$("#form-num").val(row.weight);
						$("input:radio[value='2']").attr('checked','true');
					}
					
					$("#form-principalId").val(row.principalId);
					$("#form-principalName").val(row.principalName);
					$("#form-isReport").val(row.isReport);
					
	            },
	            buttons: [{
	                label: '取消',
	                action: function(dialog){
	                    dialog.close();
	                }
	            }, {
	                label: '确定',
	                cssClass: 'btn-primary',
	                action: function(dialog){
	                	var $button = this;
	                	$button.disable();//提交按钮不可用,防止重复提交
						
						if (checkNotNull()) {
							if (validateSql("inputsForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();
					    	} else {
					    		$.ajax({
									url: "${basepath}originInputsRecord/editOriginInputsRecord.do",
									type: "post",
									data: $("#inputsForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												search();
												dialog.close();
											}  else {
												$button.enable();//请求完成,提交按钮可用
											}
											BootstrapDialog.alert(data.msg);
										}
									},
									error: function() {
										BootstrapDialog.alert("提交异常");
										$button.enable();
									}
								});
					    	}
							
						} else {
							$button.enable();//验证失败,提交按钮可用
						}
	                }
	            }]
	        });
		}
		
		//删除使用信息
		function deleteInputs(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的投入品使用信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.prodBatchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}originInputsRecord/deleteOriginInputsRecord.do",
						type: "post",
						data: {inputsId: row.id},
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								BootstrapDialog.alert(data.msg);
								search();
							}
						}
					});
				}
			});
		}
		
		//导出使用信息
		function exportInputs(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?prodBatchId='+prodBatchId+'&inputsId='+inputsId+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}originInputsRecord/exportOriginInputsRecord.do'+parameterStr;
		}
		
		function checkNotNull() {
			var msg = '';
			
			var usedDate = $("#form-usedDate").val();
			var prodBatchId = $("#form-prodBatchId").val();
			var inputsId = $("#form-inputsId").val();
			var inputsNumName = $("input[name='inputsNumName']:checked").val();
			var num = $("#form-num").val();
			var allNum = $("#form-allNum").val();
			var isReport = $("#form-isReport").val();
			
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
			
			if (isReport != undefined && $.trim(isReport) == '1') {
				msg += ' 数据已经上传到追溯平台，不能修改；<br>';
			}else{
				if(Number(num)>Number(allNum)){
					msg += ' 投入数量/投入重量数值不能大于库存；<br>';
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
	<script type="text/html" id="inputsTemple">
	<div style="height:300px;">
		<form class="form-horizontal" id="inputsForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-allNum" name="allNum">
			<input type="hidden" id="form-isReport" name="isReport">		
			
		<div style="float:left;width:46%;text-align:center">
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-prodBatchId">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>批次号
				</label>
				<div class="col-sm-8" id="batchIdDiv">
					<%--<input type="hidden" id="form-prodBatchId" name="prodBatchId">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-batch"  onchange="selectBatchIdChange()">
    				</select>--%>
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
				<label class="col-sm-4 control-label no-padding-right" for="form-type">
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
		
		</form>
	</div>
	</script>
	
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12 col-sm-12 specialFrame-grid">
				<div class="searchDiv" >
					<table>
						<tr>
							<td>
								<label><%=title%>批次号</label>
								<input id="prodBatchId" name="prodBatchId" class="specialForm-text">
							</td>
							<td>
								<label>投入品名称</label>
								<select id="inputsId" name="inputsId" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">使用日期</div>
								<div class="input-group" style="width:150px; float:left;margin-top:5px;margin-left:5px;">
									<input class="form-control date-picker specialForm-select" id="start" name="start" 
										data-date-format="yyyy-mm-dd" placeholder="开始日期">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</td>
							<td>
								<div style="float:left;margin-left:5px;margin-right:5px;font-size:14;line-height: 40px;"> 至  </div>
								<div class="input-group" style="width:150px; float:left;margin-top:5px;">
									<input class="form-control date-picker specialForm-select" id="end" name="end" 
										data-date-format="yyyy-mm-dd" placeholder="结束日期">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</td>
							<td>
								<button onclick="search();"  style="margin-left:30px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="clearSearch();"  style="margin-left:5px;" class="btn btn-app btn-light btn-xs" >清空</button>
							</td>
						</tr>
					</table>
				</div>
				<div id="toolbar">
					<span id="onUseBtns">
						<button id="addButton" class="btn btn-app btn-light btn-xs" onclick="addInputs();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateInputs();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteInputs();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button id="exportButton" class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportInputs();">
							<i class="fa fa-arrow-circle-right"></i>
							导出数据
						</button>
					</span>
					
				</div>
				<table id="table"></table>
			</div>
		</div>
	</div>
</body>
</html>
