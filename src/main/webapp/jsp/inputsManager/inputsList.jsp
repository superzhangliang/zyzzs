<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>投入品管理</title>
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
		var code = '';
		var name = '';
		var nodeType = '${node.type}';
		var showUser = '${user.id}'=='<%=Constants.ROLE_SUPER_ADMIN%>'?true:false;
		var showName = false;
		var total=0;
		$(function() {
			if(showUser) {
				showName = true;
				$(".btn-xl").attr("style","display:none;");
			}
		
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			table.bootstrapTable({
				url: "${basepath}inputsManager/getInputsManager.do",
				columns: [ {
					field: "code",
					title: "投入品编号",
					align: "center",
					valign: "middle"
				}, {
					field: "name",
					title: "投入品名称",
					align: "center",
					valign: "middle"
				},{
					field: "type",
					title: "类型",
					align: "center",
					valign: "middle",
					formatter:function(value,row){
						var url='';
						if(value==<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%>';
						}else if(value==<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>){
							url='<%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%>';
						}
						return url;
					}
				},{
					field: "num",
					title: "库存",
					align: "center",
					valign: "middle",
					formatter:function(value,row){
						return '<a style="cursor:pointer;" title="查看库存变化" onclick="showNumChangeRecord('+row.id+','+'\''+row.name+'\');">'+value+'</a>';
					}
				},{
					field: "unit",
					title: "投入品使用单位",
					align: "center",
					valign: "middle"
				}, {
					field: "num",
					title: "操作",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {	
						var url = '';
						if( value > 0  && !showUser){
							url +=  '<i class="fa fa-window-close-o fa-lg" style="cursor:pointer;" title="报废" onclick="scrapInputs('+row.id+','+row.nodeId+','
								+row.num+','+'\''+row.name+'\','+'\''+row.unit+'\');"/>&nbsp;&nbsp;' ;
						}			
						
						url += '<i class="fa fa-list-alt fa-lg" style="cursor:pointer;" title="查看库存变化" onclick="showNumChangeRecord('+row.id+','+'\''+row.name+'\');"/>';
						
						return url;									
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
		});
		
		//搜索
		function search() {
			if (validateSql("code,name", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				code = document.getElementById("code").value;
				name = document.getElementById("name").value;
				
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "code": code, "name": name},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#code").val("");
			$("#name").val("");
			
			search();
		}
		
		//查看库存变化记录
		function showNumChangeRecord( id ){
			BootstrapDialog.frame({
	            title: "<h5>查看库存变化记录</h5>",
	            src:'${basepath}jsp/inputsManager/numChangeRecordList.jsp?pId=' + id+'&showName='+showName,
	            frameId: "recordFrame",
	           	size: BootstrapDialog.SIZE_FULL,
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true
	        });
		}
		
		//报废
		function scrapInputs( id, nodeId, num, name, unit ){
			BootstrapDialog.confirm("确认报废\"" + name + "\"?", function (yes) {
				if (yes) {
					BootstrapDialog.show({
			            title: "<h5>报废投入品：<span class='orange2'>" + name + "</span></h5>",
			            message: template('scrapTemple', {}),
			            nl2br: false,
			            closeByBackdrop: false,
			            draggable: true,
			            onshown: function(dialog) {
							$("#scrapForm")[0].reset();
							
							$("#pIdS").val(id);
							$("#nodeIdS").val(nodeId);
							$("#unitS").html(unit);
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
								if (checkScrapNotNull(num)) {
									$.ajax({
										url: "${basepath}inputsManager/scrapInputs.do",
										type: "post",
										data: $("#scrapForm").serialize(),
										dataType:"json",
										success:function(data){
											if (data != undefined) {
												if (data.success) {
													search();
													dialog.close();
												}  else {
													$button.enable();
												}
												BootstrapDialog.alert(data.msg);
											}
										},
										error: function() {
											BootstrapDialog.alert("提交异常！");
											$button.enable();
										}
									});
								} else {
									$button.enable();
								}
			                }
			            }]
			        });
				}
			});
		}
		
		//新增投入品信息
		function addInputsManager() {
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>新增投入品信息</h5>",
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
					
					$("#form-type").find("option").remove();
					var opt = '<option value="">--请选择--</option>';
					if( nodeType != undefined && nodeType == '<%=Constants.TYPE_VEGETABLES%>' ){
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>"><%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>"><%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>"><%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%></option>';
					}else{
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>"><%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>"><%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>"><%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%></option>';
					}
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>"><%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%></option>';
					$("#form-type").append(opt);
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
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}inputsManager/editInputsManager.do",
									type: "post",
									data: $("#inputsForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												search();
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
		
		//修改投入品信息
		function updateInputsManager() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的投入品信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>修改投入品信息：<span class='orange2'>" + row.name + "</span></h5>",
	            message: template('inputsTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
					//清空表单信息
					$("#inputsForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-code").val(row.code);
					$("#form-name").val(row.name);
					$("#form-unit").val(row.unit);
					$("#form-type").find("option").remove();
					var opt = '<option value="">--请选择--</option>';
					if( nodeType != undefined && nodeType == '<%=Constants.TYPE_VEGETABLES%>' ){
						
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%></option>';
					}else{
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%></option>';
						opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>"';
						if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>'){
							opt += ' selected';
						}
						opt += '><%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%></option>';
					}
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>"';
					if(row.type=='<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%></option>';
					$("#form-type").append(opt);
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
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}inputsManager/editInputsManager.do",
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
		
		//删除投入品信息
		function deleteInputsManager(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的投入品信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.name + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}inputsManager/deleteInputsManager.do",
						type: "post",
						data: {inputsManagerId: row.id},
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
		
		//导出投入品信息
		function exportInputs(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?code='+code+'&name='+name;
			location.href = '${basepath}inputsManager/exportInputsManager.do'+parameterStr;
		}
		
		function checkNotNull() {
			var msg = '';
			var code = $("#form-code").val();
			var name = $("#form-name").val();
			
			if (code == undefined || $.trim(code) == '') {
				msg += ' 投入品编号不能为空；<br>';
			}
			if (name == undefined || $.trim(name) == '') {
				msg += ' 投入品名称不能为空；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function checkScrapNotNull(totalNum){
			var msg = '';
		
			var num=$("#numS").val();
			if(num == undefined || $.trim(num) == ''){
				msg += ' 报废数量不能为空；<br>';
			}else if( Number(num) < 0 ){
				msg += ' 报废数量不能小于0；<br>';
			}else if( Number(num) > totalNum ){
				msg += ' 报废数量不能大于库存数量；<br>';
			}
			
			var reason=$("#reasonS").val();
			if(reason == undefined || $.trim(reason) == ''){
				msg += ' 报废原因不能为空；<br>';
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
	<div style="height:200px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="inputsForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-areaName" name="areaName">

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-code">
					<i class="fa fa-asterisk fa-1 red"></i>
					投入品编码
				</label>
				<div class="col-sm-9">
					<input type="text" class="form-control" id="form-code" name="code">
				</div>
			</div>		
			
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					投入品名称
				</label>
				<div class="col-sm-9">
					<input type="text" class="form-control" id="form-name" name="name">
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-type">
					<i class="fa fa-asterisk fa-1 red"></i>
					类型
				</label>
				<div class="col-sm-9">
					<select type="text" class="form-control" id="form-type" name="type">
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-unit">
					投入品使用单位
				</label>
				<div class="col-sm-9">
					<input type="text" class="form-control" id="form-unit" name="unit">
				</div>
			</div>
		</form>
	</div>
	</script>
	<script type="text/html" id="scrapTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="scrapForm" role="form">
			<input type="hidden" id="pIdS" name="pId">
			<input type="hidden" id="nodeIdS" name="nodeId">

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="numS">
					<i class="fa fa-asterisk fa-1 red"></i>
					报废数量
				</label>
				<div class="col-sm-7">
					<input type="number"  id="numS" name="num" min="0.01" step="0.01" style="width:85%;">
					<span id="unitS" style="width:15%;"></span>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="reasonS">
					<i class="fa fa-asterisk fa-1 red"></i>
					报废原因
				</label>
				<div class="col-sm-7">
					<textarea class="form-control" rows="5" id="reasonS" name="reason"></textarea>
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
								<label>投入品编号</label>
								<input id="code" name="code" class="specialForm-text">
							</td>
							<td>
								<label>投入品名称</label>
								<input id="name" name="name" class="specialForm-select">
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
						<button class="btn btn-app btn-light btn-xs" onclick="addInputsManager();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateInputsManager();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteInputsManager();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportInputs();">
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
