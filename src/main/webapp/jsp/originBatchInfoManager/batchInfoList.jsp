<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	<title><%=title%>管理</title>
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
		var listProds;
		var prodBatchId = '';
		var prodId = '';
		var startDate = '';
		var endDate = '';
		var total=0;
		
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
			var columus = [ {
					field: "prodBatchId",
					title: "<%=title %>批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "prodName",
					title: "产品名称",
					align: "center",
					valign: "middle"
				}, {
					field: "prodStartDate",
					title: "<%=title%>开始日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}];
				if (<%=type==2 %> || <%=type==-1%>) {
					columus[columus.length] = {
						field: "acreage",
						title: "<%=title%>面积（亩）",
						align: "center",
						valign: "middle",
						formatter:function(value,row){
							var url = '';
							if(row.type!=undefined&&row.type==2){
								url = value;
							}
							return url;
						}
					}
				}	
				
				if (<%=type==1 %> || <%=type==-1%>) {
					columus[columus.length] = {
						field: "qty",
						title: "<%=title%>数量",
						align: "center",
						valign: "middle",
						formatter:function(value,row){
							var url = '';
							if(row.type!=undefined&&row.type==1){
								url = value+row.unit;
							}
							return url;
						}
					}
				}
				
				columus[columus.length] = {
						field: "isReport",
						title: "状态",
						align: "center",
						valign: "middle",
						formatter: function (value, row) {
							var val = "";
							if(value == 0){
								val = "未同步";
							} else {
								val = "已同步";
							}
							return val;
						}
					}
			table.bootstrapTable({
				url: "${basepath}originBatchInfo/getOriginBatchInfo.do?flag=<%=type %>",
				columns: columus,
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
			
			getProdsList();
			
			fullprod();
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
		
		//搜索栏填充产品名称
		function fullprod(){
			$("#prodName").find("option").remove();
			if( listProds && listProds.length > 0 ){
				var ops;
				ops += '<option value="">'+'==请选择=='+'</option>';
				for(var i=0;i<listProds.length;i++){
					ops += '<option value="' + listProds[i].id + '"';
					if( prodId != null && prodId != "" && prodId == listProds[i].id ){
						ops += 'selected';
					}
					ops += '>' + listProds[i].name + '</option>';
				}
				$("#prodName").append(ops);
			} else {
				ops += '<option value="">'+'==请选择=='+'</option>';
				$("#prodName").append(ops);
			}
		} 
		
	  	//新增填充商品下拉列表
		function fullProds(prodId){
	  		$("#form-prods").find("option").remove(); 
			if (listProds && listProds.length > 0) {
				var ops="";
				ops += '<option value="">请选择</option>';
				for (var i = 0; i < listProds.length; i++) {
					ops += '<option value="' + listProds[i].id + '@'+(listProds[i].name == undefined ? '' : listProds[i].name)+'"';
					if( prodId != null && prodId != "" && prodId == listProds[i].id ){
						ops += ' selected ';
					}
					ops += '>' + listProds[i].name + '</option>';
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
	  		$("#form-prodName").val(formProds[1]);
	  	}
		
		//搜索
		function search() {
			if (validateSql("prodBatchId,prodName,start,end", 1)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				prodBatchId = document.getElementById("prodBatchId").value;
				prodId = document.getElementById("prodName").value;
				startDate = document.getElementById("start").value;
				endDate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "prodBatchId": prodBatchId, "prodId": prodId, "htmlStartDate":startDate, "htmlEndDate":endDate},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#prodBatchId").val("");
			$("#prodName").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		//新增批次信息
		function addBatchInfo() {
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>新增<%=title%>信息</h5>",
	            message: template('batchInfoTemple', {}),
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
					$("#batchInfoForm")[0].reset();
					
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
		            
					$("#batchIdDiv").attr("style","display:none;");
					$("#form-prodStartDate").datepicker( "setDate", new Date() );
					fullProds();
					
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
							if (validateSql("batchInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
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
		
		//修改批次信息
		function updateBatchInfo() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的<%=title%>信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>修改<%=title%>信息：<span class='orange2'>" + row.prodBatchId + "</span></h5>",
	            message: template('batchInfoTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					
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
					
					//清空表单信息
					$("#batchInfoForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-prodStartDate").datepicker( "setDate", formatTimeStr(row.prodStartDate) );
					$("#form-prodBatchId").val(row.prodBatchId);
					$("#form-prodName").val(row.prodName);
					$("#form-qty").val(row.qty);
					$("#form-acreage").val(row.acreage);
					$("#form-unit").val(row.unit);
					$("#form-principalId").val(row.principalId);
					$("#form-principalName").val(row.principalName);
					$("#form-isReport").val(row.isReport);
					
					fullProds(row.prodId);
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
							if (validateSql("batchInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}originBatchInfo/editOriginBatchInfo.do",
									type: "post",
									data: $("#batchInfoForm").serialize(),
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
		
		//删除批次信息
		function deleteBatchInfo(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的<%=title%>信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.prodBatchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}originBatchInfo/deleteOriginBatchInfo.do",
						type: "post",
						data: {batchInfoId: row.id},
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
		
		//导出批次信息
		function exportBatchInfo(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?prodBatchId='+prodBatchId+'&prodId='+prodId+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}originBatchInfo/exportOriginBatchInfo.do'+parameterStr;
		}
		
		function checkNotNull() {
			var msg = '';
			
			var prodStartDate = $("#form-prodStartDate").val();
			var prodName = $("#form-prodName").val();
			var qty = $("#form-qty").val();
			var acreage = $("#form-acreage").val();
			var isReport = $("#form-isReport").val();
			
			if (prodStartDate == undefined || $.trim(prodStartDate) == '') {
				msg += ' <%=title%>开始日期不能为空；<br>';
			}
			if (prodName == undefined || $.trim(prodName) == '') {
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
			
			if (isReport != undefined && $.trim(isReport) == '1') {
				msg += ' 数据已经上传到追溯平台，不能修改；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
	<script type="text/html" id="batchInfoTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="batchInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-isReport" name="isReport">
			
		<div style="float:left;width:80%;text-align:center">
			<div class="form-group" id="batchIdDiv">
				<label class="col-sm-4 control-label no-padding-right" for="form-prodBatchId">
					<i class="fa fa-asterisk fa-1 red"></i>
					<%=title%>批次号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-prodBatchId" name="prodBatchId" readOnly>
				</div>
			</div>

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
				<label class="col-sm-4 control-label no-padding-right" for="form-prodName">
					<i class="fa fa-asterisk fa-1 red"></i>
					产品名称
				</label>
				<div class="col-sm-8">
					<input type="hidden" class="form-control" id="form-prodId" name="prodId">
					<input type="hidden" id="form-prodName" class="form-control">
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
								<label>产品名称</label>
								<select id="prodName" name="prodName" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;"><%=title%>开始日期</div>
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
						<button id="addButton" class="btn btn-app btn-light btn-xs" onclick="addBatchInfo();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateBatchInfo();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteBatchInfo();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button id="exportButton" class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportBatchInfo();">
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
