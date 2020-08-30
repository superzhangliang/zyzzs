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
		
		var table, selectRowId , listProds , total=0;
		var prodBatchId = '' , prodId = '' , startDate = '' , endDate = '' ;
		var listBatchInfo;
		var type = '${node.type}';
		
		$(function() {
			
			var vla = "";
			if(<%=type==-1%>) {
				$("#addButton").attr("style","display:none;");
				$("#exportButton").attr("style","display:none;");
			}
			
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			var columns = [{
					field: "harvestBatchId",
					title: "<%=title%>收获批次号",
					align: "center",
					valign: "middle"
				},{
					field: "prodBatchId",
					title: "<%=title%>批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "prodName",
					title: "产品名称",
					align: "center",
					valign: "middle"
				},{
					field: "harvestDate",
					title: "收获日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "weight",
					title: "重量",
					align: "center",
					valign: "middle"
				}];
				columns[columns.length] = {
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
				}
			table.bootstrapTable({
				url: "${basepath}originHarvestInfo/getOriginHarvestInfo.do",
				columns: columns,
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
			
			getBatchInfoList();
			getProdsList();
			fullProd();
		});

		//初始化检测结果
		function inintResult(result){
			var html = '';
			if(type == '1') {
				    html += '<select class="form-control" id="form-result" name="result">';
				    html +=		'<option value="">请选择</option>';
				    html +=		'<option value="1"';
				    if( result!=undefined && result=="1"){
				    	html += ' selected';
				    }
				    html += 	'>合格</option>';
				    html +=		'<option value="0"';
				    if( result!=undefined && result=="0"){
				    	html += ' selected';
				    }
				    html +=		'>不合格</option>';
				    html += '</select>';
				$("#resultLabel").html("检测结果");
			}else {
				if( result==undefined || result==null){
					result = '';
				}
				html += '<input type="text" class="form-control" id="form-result" name="result" ';
				html += 'value="'+result+'"'+'>';
				$("#resultLabel").html("检测结果(农残抑制率)");
			} 
			$("#resultDiv").html(html);
		}	
		
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
		
		//填充产品名称
		function fullProd(){
			$("#prodId").find("option").remove();
			var ops;
				ops += '<option value="">'+'请选择'+'</option>';
			if( listProds && listProds.length > 0 ){
				
				for(var i=0;i<listProds.length;i++){
					ops += '<option value="' + listProds[i].id + '"';
					
					ops += '>' + listProds[i].name + '</option>';
				}
				
			}
			$("#prodId").append(ops);
		}
		
		//填充种养殖批次号下拉列表
		function fullBatchInfo(prodBatchId){
	  		$("#form-batch").find("option").remove(); 
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listBatchInfo && listBatchInfo.length > 0) {
				
				for (var i = 0; i < listBatchInfo.length; i++) {
					
					ops += '<option value="' + listBatchInfo[i].prodId + '@'+(listBatchInfo[i].prodName == undefined ? '' : listBatchInfo[i].prodName )
					+'@'+ listBatchInfo[i].prodBatchId + '"';
					if( prodBatchId != null && prodBatchId != "" && prodBatchId == listBatchInfo[i].prodBatchId ){
						ops += ' selected ';
					}
					ops += ' >' + listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
				}
				
			}
			
			$("#form-batch").append(ops);
			
			if(ops!=""){
	  			$("#form-batch").selectpicker({
	                'selectedText': 'cat'
	            });
	            
	            var formEntry = $("#form-batch").val().split("@");
	  			$("#form-prodId").val(formEntry[0]);
		  		$("#form-prodName").val(formEntry[1]);
		  		$("#form-prodBatchId").val(formEntry[2]);
	  		}
	  	}
	  	
	  	//种养殖批次号下拉框改变事件
	  	function selectBatchIdChange(){
	  		var formEntry = $("#form-batch").val().split("@");
	  		
	  		$("#form-prodId").val(formEntry[0]);
	  		$("#form-prodName").val(formEntry[1]);
	  		$("#form-prodBatchId").val(formEntry[2]);
	  	}
	  	
		//搜索
		function search() {
			if (validateSql("harvestBatchId,prodName,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				harvestBatchId = document.getElementById("harvestBatchId").value;
				prodId = document.getElementById("prodId").value;
				startDate = document.getElementById("start").value;
				endDate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "harvestBatchId": harvestBatchId, "prodId": prodId, "htmlStartDate":startDate, "htmlEndDate":endDate},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#harvestBatchId").val("");
			$("#prodId").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		//新增收获信息
		function addHarvestInfo() {
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增收获信息</h5>",
	            message: template('harvestInfoTemple', {}),
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
					$("#harvestInfoForm")[0].reset();
					
					inintResult();
					$("#harvestBatchIdDiv").css("display","none");
					$("#form-harvestDate").datepicker( "setDate", new Date() );
					
					var html ='';
						html += '<input type="hidden" id="form-prodBatchId" name="prodBatchId">';
						html += '<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-batch"  onchange="selectBatchIdChange()"></select>';
					$("#prodBatchDiv").html(html);
					fullBatchInfo();
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
							if (validateSql("harvestInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}originHarvestInfo/editOriginHarvestInfo.do",
									type: "post",
									data: $("#harvestInfoForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												$.ajax({
													url: "${basepath}originHarvestInfo/synToSY.do",
													type: "post",
													data: {harvestInfoId: data.id},
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
		
		//修改收获信息
		function updateHarvestInfo() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的收获信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>修改收获信息：<span class='orange2'>" + row.harvestBatchId + "</span></h5>",
	            message: template('harvestInfoTemple', {}),
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
					$("#harvestInfoForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					var html ='';
						html += '<input type="text" class="form-control" id="form-prodBatchId" name="prodBatchId" readonly>';
					$("#prodBatchDiv").html(html);
					$("#form-prodBatchId").val(row.prodBatchId);
					$("#form-harvestBatchId").val(row.harvestBatchId);
					$("#form-harvestDate").datepicker( "setDate", formatTimeStr(row.harvestDate) );
					$("#form-prodId").val(row.prodId);
					$("#form-prodName").val(row.prodName);
					$("#form-weight").val(row.weight);
					$("#form-amount").val(row.amount);
					$("#form-unit").val(row.unit);
					$("#form-sheetNo").val(row.sheetNo);
					$("#form-principalId").val(row.principalId);
					$("#form-principalName").val(row.principalName);
					
					$("#form-isReport").val(row.isReport);
					inintResult(row.result);
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
							if (validateSql("harvestInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}originHarvestInfo/editOriginHarvestInfo.do",
									type: "post",
									data: $("#harvestInfoForm").serialize(),
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
		
		//删除收获信息
		function deleteHarvestIfo(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的收获信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.harvestBatchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}originHarvestInfo/deleteOriginHarvestInfo.do",
						type: "post",
						data: {harvestInfoId: row.id},
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
		
		//导出收获信息
		function exportHarvestInfo(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?prodBatchId='+prodBatchId+'&prodId='+prodId+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}originHarvestInfo/exportOriginHarvestInfo.do'+parameterStr;
		} 
		
		function checkNotNull() {
			var msg = '';
			
			var prodBatchId = $("#form-prodBatchId").val();
			var harvestDate = $("#form-harvestDate").val();
			var prodName = $("#form-prodName").val();
			var weight = $("#form-weight").val();
			var amount = $("#form-amount").val();
			var unit = $("#form-unit").val();
			var isReport = $("#form-isReport").val();
			
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
	<script type="text/html" id="harvestInfoTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="harvestInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-isReport" name="isReport">
			
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group" id="harvestBatchIdDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-harvestBatchId">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>收获批次号
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control"  id="form-harvestBatchId" name="harvestBatchId" readonly>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodBatchId">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>批次号
					</label>
					<div class="col-sm-8" id="prodBatchDiv">
						
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
								<label><%=title%>收获批次号</label>
								<input id="harvestBatchId" name="harvestBatchId" class="specialForm-text">
							</td>
							<td>
								<label>产品名称</label>
								<select id="prodId" name="prodId" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">收获日期</div>
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
						<button	id="addButton" class="btn btn-app btn-light btn-xs" onclick="addHarvestInfo();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateHarvestInfo();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteHarvestIfo();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button	id="exportButton" class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportHarvestInfo();">
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
