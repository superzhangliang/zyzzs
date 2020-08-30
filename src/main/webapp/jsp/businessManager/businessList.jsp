<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>经营商户信息管理</title>
	<%@include file="../head.jsp"%>
	<%@include file="../table.jsp"%>
	<script src="${basepath}js/dist/template.js"></script>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<style type="text/css">
	table tr td { padding: 2px;}
	label {cursor: pointer;}
	em {color: red;}
	.l-text-field {height: 100%;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		
		var table,table2,selectRowId;
		var mark = 0;
		var navH;
		var gridH;
		var userId = '${user.id}'

		$(function() {
			//计算表高度
			var bodyH = parseInt( $(document.body).innerHeight() ),temp = 25;
			searchH = parseInt( $(".searchDiv").outerHeight() );
			navH = parseInt( $(".nav.nav-tabs").outerHeight() );
			gridH = bodyH - searchH - temp-navH;
			
			$("#businesstab a:first").tab('show');//初始化显示哪个tab
			$("#businesstab a").click(function (e) {
			   e.preventDefault();
			   $(this).tab('show');
			   if($(this).attr("class")=="obusiness"){
					loadGrid2(gridH);
					search();
			   }else{
					loadGrid(gridH);
					search();
			   }
			});
			loadGrid(gridH);
		});
		
		function loadGrid(gridH){
			mark = 0;
			table = $("#businessgrid");
			table.bootstrapTable({
				url: "${basepath}business/getBusiness.do?mark="+mark,
				columns: [ {
					field: "code",
					title: "经营者编码",
					align: "center",
					valign: "middle"
				},{
					field: "name",
					title: "经营者名称",
					align: "center",
					valign: "middle"
				}, {
					field: "regId",
					title: "工商注册登记证号",
					align: "center",
					valign: "middle"
				},{
					field: "property",
					title: "经营者性质",
					align: "center",
					valign: "middle"
				},{
					field: "type",
					title: "经营类型",
					align: "center",
					valign: "middle",
					formatter:function(value,row){
						var url='';
						if(value!=undefined&&value==<%=Constants.BUSINESS_TYPE_SUPPLIER%>){
							url = '<%=Constants.BUSINESS_TYPE_SUPPLIER_NAME%>';
						}else{
							url = '<%=Constants.BUSINESS_TYPE_BUYER_NAME%>';
						}
						return url;
					}
				}],
				pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar1',
				method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id'
			});
			
			/* 监听窗口改变,重设高度值 */
			window.onresize = function(){
				table.bootstrapTable("resetView",{height:gridH});
			};
			
			//绑定选中行事件
			table.on('click-row.bs.table', function (e, row, $element) {
				$('.success').removeClass('success');
				$($element).addClass('success');
				selectRowId = row.id;
			});
		}
		
		function loadGrid2(gridH){
			mark = 1;
			table2 = $("#obusinessgrid");
			table2.bootstrapTable({
				url: "${basepath}business/getBusiness.do?mark="+mark,
				columns: [ {
					field: "code",
					title: "经营者编码",
					align: "center",
					valign: "middle"
				},{
					field: "name",
					title: "经营者名称",
					align: "center",
					valign: "middle"
				}, {
					field: "regId",
					title: "工商注册登记证号",
					align: "center",
					valign: "middle"
				},{
					field: "property",
					title: "经营者性质",
					align: "center",
					valign: "middle"
				},{
					field: "type",
					title: "经营类型",
					align: "center",
					valign: "middle",
					formatter:function(value,row){
						var url='';
						if(value!=undefined&&value==<%=Constants.BUSINESS_TYPE_SUPPLIER%>){
							url = '<%=Constants.BUSINESS_TYPE_SUPPLIER_NAME%>';
						}else{
							url = '<%=Constants.BUSINESS_TYPE_BUYER_NAME%>';
						}
						return url;
					}
				}],
				pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar2',
				method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id'
			});
			
			/* 监听窗口改变,重设高度值 */
			window.onresize = function(){
				table2.bootstrapTable("resetView",{height:gridH});
			};
			
			//绑定选中行事件
			table2.on('click-row.bs.table', function (e, row, $element) {
				$('.success').removeClass('success');
				$($element).addClass('success');
				selectRowId = row.id;
			});
		}
		
		//搜索
		function search() {
			if (validateSql("name,regId", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		var name = $("#name").val();
				var regId = $("#regId").val();
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#businessgrid").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({},params,{"name": name,"regId": regId});
					}}
				);
				$("#obusinessgrid").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({},params,{"name": name,"regId": regId});
					}}
				);
	    	}
		}
		
		//清空
		function clearSearch(){
			$("#name").val("");
			$("#regId").val("");
			
			search();
		}
		
		//新增经营者
		function addBusiness() {
			if(userId == -1) {
				BootstrapDialog.alert("超级管理员不能进行新增操作");
				return;
			}
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>新增经营者</h5>",
	            message: template('businessTemp', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					//隐藏提示信息
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					//清空表单信息
					$("#businessForm")[0].reset();
					$("#codeDiv").attr("style","display:none;");
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
						$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
						if (checkNotNull()) {
							if (validateSql("businessForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}business/editBusiness.do",
									type: "post",
									data: $("#businessForm").serialize(),
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
		
		//修改经营者
		function updateBusiness() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的经营者！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>修改经营者：<span class='orange2'>" + row.name + "</span></h5>",
	            message: template('businessTemp', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					//隐藏提示信息
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					//清空表单信息
					$("#businessForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-code").val(row.code);
					$("#form-name").val(row.name);
					$("#form-regId").val(row.regId);
					$("#form-property").val(row.property);
					$("#form-type").val(row.type);
					$("#form-markType").val(row.markType);
					$("#form-recordDate").datepicker( "setDate", formatTimeStr(row.recordDate) );
					$("#form-legalRepresent").val(row.legalRepresent);
					$("#form-addr").val(row.addr);
					$("#form-tel").val(row.tel);
					$("#form-nodeId").val(row.nodeId);
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
						$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
						
						if (checkNotNull()) {
							if (validateSql("businessForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}business/editBusiness.do",
									type: "post",
									data: $("#businessForm").serialize(),
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
										BootstrapDialog.alert("提交异常！");
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
		
		//停用经营者
		function deleteBusiness(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要停用的经营者！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认停用经营者<font color='red'>" + row.name + "</font>?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}business/deleteBusiness.do",
						type: "post",
						data: {businessId: row.id},
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
		//恢复使用
		function recoveryBusiness(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请选择一行进行操作！");
				return;
			}
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认恢复经营者<font color='red'>" + row.name + "</font>?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}business/recoveryBusiness.do",
						type: "post",
						data: {businessId: row.id},
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
		function checkNotNull() {
			var msg = '';
			
			//var code = $("#form-code").val();
			var name = $("#form-name").val();
			var regId = $("#form-regId").val();
			var property = $("#form-property").val();
			var type = $("#form-type").val();
			var recordDate = $("#form-recordDate").val();
			var legalRepresent = $("#form-legalRepresent").val();
			var tel = $("#form-tel").val();
			
			/**if (code == undefined || $.trim(code) == '') {
				msg += ' 经营者编码不能为空；<br>';
			}**/
			if (name == undefined || $.trim(name) == '') {
				msg += ' 经营者名称不能为空；<br>';
			}
			if (regId == undefined || $.trim(regId) == '') {
				msg += ' 工商注册登记证号不能为空；<br>';
			}
			if (property == undefined || $.trim(property) == '') {
				msg += ' 经营者性质不能为空；<br>';
			}
			if (type == undefined || $.trim(type) == '') {
				msg += ' 经营者类型不能为空；<br>';
			}
			if (recordDate == undefined || $.trim(recordDate) == '') {
				msg += ' 备案日期不能为空；<br>';
			}
			if (legalRepresent == undefined || $.trim(legalRepresent) == '') {
				msg += ' 法人代表不能为空；<br>';
			}
			if (tel == undefined || $.trim(tel) == '') {
				msg += ' 手机号码不能为空；';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
	<script type="text/html" id="businessTemp">
	<div style="height:200px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="businessForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="nodeId" name="nodeId" value="${node.id}">
			<input type="hidden" id="form-markType" name="markType" value="1">

			<div class="form-group" id="codeDiv">
				<label class="col-sm-3 control-label no-padding-right" for="form-code">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者编码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-code" name="code" readOnly>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者名称
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-name" name="name">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-regId">
					<i class="fa fa-asterisk fa-1 red"></i>
					工商注册登记证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-regId" name="regId">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-property">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者性质
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-property" name="property">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-type">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营类型
				</label>
				<div class="col-sm-8">
					<select id="form-type" name="type" class="form-control" >
						<option value="">请选择</option>
						<option value="1">供应商</option>
						<option value="2">买家</option>
					</select>
				</div>
			</div>

			<!--<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-markType">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者角色
				</label>
				<div class="col-sm-8">
					<select id="form-markType" name="markType" class="form-control" >
						<option value="0">供货商</option>
						<option value="1">买家</option>
						<option value="2">供货商及买家</option>
					</select>
				</div>
			</div>-->

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-recordDate">
					<i class="fa fa-asterisk fa-1 red"></i>
					备案日期
				</label>
				<div class="col-sm-8">
					<div class="input-group">
						<input class="form-control date-picker" id="form-recordDate" name="recordDate" 
							data-date-format="yyyy-mm-dd" readonly>
						<span class="input-group-addon">
							<i class="fa fa-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-legalRepresent">
					<i class="fa fa-asterisk fa-1 red"></i>
					法人代表
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-legalRepresent" name="legalRepresent">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-addr">
					地址
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-addr" name="addr">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-tel">
					<i class="fa fa-asterisk fa-1 red"></i>
					手机号码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-tel" name="tel">
				</div>
			</div>

		</form>
	</div>
	</script>
</head>
<body class="specialFrame specialDialog specialSearch">
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12 col-sm-12 specialFrame-grid" style="overflow: auto;">
				<div class="searchDiv" >
					<table>
						<tr>
							<td>
								<label>经营者名称&nbsp;&nbsp; </label>
								<input id="name" name="name" class="specialForm-select">
							</td>
							<td>
								<label>工商注册登记证号&nbsp;&nbsp;</label>
								<input id="regId" name="regId" class="specialForm-select">
							</td>
							<td>
								<button onclick="search();"  style="margin-left:25px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="clearSearch();"  style="margin-left:5px;" class="btn btn-app btn-light btn-xs" >清空</button>
							</td>
						</tr>
					</table>
					
				</div>
				<ul id="businesstab" class="nav nav-tabs" style="margin-top: 6px;height:40px;">
				   <li class="active">
				      <a href="#businessgridtab" data-toggle="tab" class="business">
				         	在用信息
				      </a>
				   </li>
				   <li>
				      <a href="#obusinessgridtab" data-toggle="tab" class="obusiness">
				         	停用信息
				      </a>
				   </li>
				</ul>
				<div class="tab-content">  
				    <div class="tab-pane active" id="businessgridtab">
						<div id="toolbar1">
							<span id="onBusinessBtns">
								<button class="btn btn-app btn-light btn-xs" onclick="addBusiness();">
									<i class="fa fa-plus"></i>
									新增
								</button>
								<button class="btn btn-app btn-light btn-xs" onclick="updateBusiness();">
									<i class="fa fa-pencil"></i>
									修改
								</button>
								<button class="btn btn-app btn-light btn-xs" onclick="deleteBusiness();">
									<i class="fa fa-trash-o"></i>
									停用
								</button>
							</span>
						</div>
						<table id="businessgrid"></table>
				    </div>
				     
				    <div class="tab-pane" id="obusinessgridtab">
						<div id="toolbar2">
							<span id="onBusinessBtns">
								<button class="btn btn-app btn-light btn-xs btnWidth" onclick="recoveryBusiness();">
									<i class="fa fa-tasks"></i>
									恢复使用
								</button>
							</span>
						</div>
						<table id="obusinessgrid"></table>
				    </div>  
				</div>
				<!-- <div id="toolbar">
					<span id="onUseBtns">
						<button class="btn btn-app btn-light btn-xs" onclick="addBusiness();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateBusiness();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteBusiness();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
					</span>
					
				</div>
				<table id="table"></table> -->
			</div>
		</div>
	</div>
</body>
</html>
