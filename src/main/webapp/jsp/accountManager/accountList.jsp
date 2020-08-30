<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
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
		var table, table2, selectRowId, selectRowId2;
		var usergrid;
		var ousergrid;
		var searchH;
		var temp;
		var mark = 0;
		var gridH;
		var navH;
		
		$(function() {
			//初始化日期控件
		 	$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
		 	//计算表高度
			var bodyH = parseInt( $(document.body).innerHeight() ),temp = 25;
			searchH = parseInt( $(".searchDiv").outerHeight() );
			navH = parseInt( $(".nav.nav-tabs").outerHeight() );
			gridH = bodyH - searchH - temp-navH;
			
			$("#usertab a:first").tab('show');//初始化显示哪个tab
			$("#usertab a").click(function (e) {
			  e.preventDefault();
			  $(this).tab('show');
			  if($(this).attr("class")=="ouser"){
				loadGrid(gridH);
				search();
			  }else{
				loadGrid2(gridH);
				search();
			  }
			});			
			loadGrid2(gridH);
		});

		function loadGrid(gridH) {	
			mark = 1;
			table = $("#ousergrid");
			table.bootstrapTable({
				url: '${basepath}loginAccount/showAccount.do?mark=' + mark,
				columns: 
				[{
					field: "account",
					title: "账号",
					align: "center",
					valign: "middle",
				}, {
					field: "name",
					title: "姓名",
					align: "center",
					valign: "middle",
				}, {
					field: "addTime",
					title: "添加时间",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				},],
				pagination: true, striped: true, sidePagination: "server",height: gridH,toolbar: '#toolbar2',
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
		
		function loadGrid2(gridH) {
			mark = 0;
			table2 = $("#usergrid");
			table2.bootstrapTable({
				url: '${basepath}loginAccount/showAccount.do?mark=' + mark,
				columns: [ {
					field: "account",
					title: "账号",
					align: "center",
					valign: "middle",
				}, {
					field: "name",
					title: "姓名",
					align: "center",
					valign: "middle",
				}, {
					field: "addTime",
					title: "添加时间",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				},],
				pagination: true, striped: true, sidePagination: "server", height:gridH, toolbar: '#toolbar1',
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
				selectRowId2 = row.id;
			});
		}

		function checkNotNull() {
			var msg = '';
			var name = $("#form-name").val();
			if (name == undefined || $.trim(name) == '') {
				msg += ' 用户名称不能为空；<br>';
			}
			
			var account = $("#form-account").val();
			if (account == undefined || $.trim(account) == '') {
				msg += ' 用户账号不能为空；<br>';
			}

			/**var password = $("#form-password").val();
			if (password == undefined || $.trim(password) == '') {
				msg += ' 密码不能为空；<br>';
			}
			if(!isPassword(password)){
				msg += ' 两次密码输入不正确；<br>';
				BootstrapDialog.confirm("<b>两次密码输入不正确</b>", '提示',function (yes) {
					if (yes) {
						$("#form-password").focus();
					}
				});
				return false;
			}
			
			var confirmPassword = $("#form-confirmPassword").val();
			if(!isconfirmPassword(confirmPassword)){
				BootstrapDialog.confirm("<b>两次密码输入不正确</b>", '提示',function (yes) {
					if (yes) {
						$("#form-confirmPassword").focus();	
					}
				});
				return false;
			}**/
			
			var phone = $("#form-phone").val();
			if(!isMobile(phone)){
				BootstrapDialog.confirm("<b>请输入11位手机号码</b>", '提示',function (yes) {
					if (yes) {
						$("#form-phone").focus();	
					}
				});
				return false;
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}

		function checkNotNull2() {
			var msg = '';
			var name = $("#form-name").val();
			if (name == undefined || $.trim(name) == '') {
				msg += ' 用户名称不能为空；<br>';
			}
			
			if (msg != '') {	
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function isNumber(obj) {
			var reg = /^\d+(?=\.{0,1}\d+$|$)/;
			if (obj != "" && obj != null) {
				if (!reg.test(obj)) {					
									
					return false;
				}
			}
			return true;
		}
		

		function isEmail(obj) {					
			var reg = /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;		
			if (obj != "" && obj != null) {
				if (!reg.test(obj)) {					
					return false;
				}				
			}
			return true;
					
		}

		function isTelephone(obj) {
			var reg = /^([0-9]{3,4}-)?[0-9]{7,8}$/;
			if (obj != "" && obj != null) {
				if (!reg.test(obj)) {				
					return false;
				}
			}
			return true;
		}

		function isMobile(obj) {
			var reg = /^1[0-9]{10}$/;
			if (obj != "" && obj != null) {
				if (!reg.test(obj)) {					
					return false;
				}
			}
			return true;
		}

		/**function isPassword(obj) {
			var reg = /^\w{6,}$/;
			var password = $("#form-confirmPassword").val();
			if (obj != password && obj != null) {
				if (!reg.test(obj)) {					
					return false;
				}
			}
			return true;
		}

		function isconfirmPassword(obj) {
			var password = $("#form-password").val();
			if (password != obj) {			
				return false;
			}
			return true;
		}**/
				
		//新增用户
		function addAccount() {
			$.ajax({
				url: "${basepath}loginAccount/getNewAccount.do",
				type: "post",
				data: {},
				dataType:"json",
				success:function(data){
					if(data.success){
						//显示对话框
						BootstrapDialog.show({
				            title: "<h5>新增用户</h5>",
				            message: template('accountTemple', {}),
				            nl2br: false,
				            closeByBackdrop: false,
				            draggable: true,
				            onshown: function(dialog) {
								//隐藏提示信息
								$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
								$("#accountForm")[0].reset();
								//获取新账号
								$("#form-account").val(data.newAccount);
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
										if (validateSql("accountForm", 1)) {
								    		BootstrapDialog.alert(sqlErrorTips);
								    		$button.enable();//验证失败,提交按钮可用
								    	} else {
								    		$.ajax({
												url: "${basepath}loginAccount/editAccount.do",
												type: "post",
												data: $("#accountForm").serialize(),
												dataType:"json",
												success:function(data){
													if (data != undefined) {
														if (data.success) {
															$("#msgDiv").addClass("alert-success");
															search();
															dialog.close();
														}  else {
															$("#msgDiv").addClass("alert-danger");
															$button.enable();//提交失败,提交按钮可用
														}
														BootstrapDialog.alert("操作成功！");
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
						
					}else if(data.msg != undefined){
						BootstrapDialog.alert("data.msg");
					}
				}
			});
		}
		
		//修改账号
		function updateAccount() {
			if (selectRowId2 == undefined || selectRowId2 == '') {
				BootstrapDialog.alert("请先选中需要修改的账号！");
				return;
			}
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId2);
			
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>修改账号：<span class='orange2'>" + row.name + "</span></h5>",
	            message: template('accountTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
					//隐藏提示信息
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					
					$("#pwDiv").attr("style","display:none;");
					$("#dpwDiv").attr("style","display:none;");
					$("#cpwDiv").attr("style","display:none;");
					
					//清空表单信息
					$("#accountForm")[0].reset();
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-name").val(row.name);
					$("#form-account").val(row.account);
					$("#form-phone").val(row.phone);
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
						
						if (checkNotNull2()) {
							if (validateSql("accountForm", 1)) {
								BootstrapDialog.alert(sqlErrorTips);
								$button.enable();//验证失败,提交按钮可用
							} else {
								$.ajax({
									url: "${basepath}loginAccount/editAccount.do",
									type: "post",
									data: $("#accountForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												search();
												dialog.close();
											}  else {
												$button.enable();//请求完成,提交按钮可用
											}
											BootstrapDialog.alert("操作成功！");
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
		
		//停用账号
		function closeAccount(){
			if (selectRowId2 == undefined || selectRowId2 == '') {
				BootstrapDialog.alert("请先选中需要停用的账号！");
				return;
			}
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId2);
			BootstrapDialog.confirm("确认停用<font color='red'>" + row.name + "</font>的账号?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}loginAccount/closeAccount.do",
						type: "post",
						data: {accountId: row.id},
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								BootstrapDialog.alert(data.msg);
								search();
							}else{
								BootstrapDialog.alert("停用失败！");
								search();
							}
						}
					});
				}
			});
		}
		
		// 角色配置	
		function fixRole() {
			
			if (selectRowId2 == undefined || selectRowId2 == '') {
				BootstrapDialog.alert("请选择行！");
				return;
			}
			
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId2);
			//显示对话框
			BootstrapDialog.frame({
	            title: "<h5>角色配置：<span class='orange2'>" + row.name + "</span></h5>",
	            src:'${basepath}loginAccount/showUserOrganRole.do?accountId=' + row.id,
	            frameId: "roleFrame",
	            height:"98%",
	            size: BootstrapDialog.SIZE_NORMAL,
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
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
	                	var contentWindow = $("#roleFrame")[0].contentWindow;
	                	contentWindow.sumbitRole($button);
	                	
               	    	$.ajax({
							url: "${basepath}loginAccount/setUserRole.do",
							type: "post",
							data: {
								'accountId': row.id,
								'account': row.account,
								'roleIds': contentWindow.$("#nodeStr").val()
							},
							dataType: "json",
							success: function(data) {
								BootstrapDialog.alert(data.msg);
								dialog.close();
							}
						});
	                }
	            }]
	            
	        });
		}

		// 恢复账号
		function recoveryAccount() {
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请选择行！");
				return;
			} else {
				BootstrapDialog.confirm("确认恢复<font color='red'>" + row.name + "</font>的账号?",function (yes) {
					if (yes) {
						$.ajax({
							url: "${basepath}loginAccount/recoveryAccount.do",
							type: "post",
							data: {accountId: row.id},
							dataType:"json",
							success:function(data){
								if(data.success) {
									BootstrapDialog.alert(data.msg);
									search();
								}else {
									BootstrapDialog.alert(data.msg);
									search();
								}
							}
						});
					}
				});
			}
		}
		//重置密码
		function resetPassword() {
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId2);
			if (selectRowId2 == undefined || selectRowId2 == '') {
				BootstrapDialog.alert("请选择行！");
				return;
			} else {
				BootstrapDialog.confirm("确认重置<font color='red'>" + row.name + "</font>的密码？<br />默认密码: <font color='red'>123456</font>",function (yes) {
					if (yes) {
						$.ajax({
							url: "${basepath}loginAccount/resetPass.do",
							type: "post",
							data: {
								'accountId': row.id,
								'newPass':"123456"
							},
							dataType:"json",
							success:function(data){
								if(data.success) {
									BootstrapDialog.alert("重置密码成功!");
									search();
								}else {
									BootstrapDialog.alert('重置失败！');
									search();
								}
							}
						});
					}
				});
			}
		}
		
		//搜索
		function search() {
			if (validateSql("accountS,searchkey,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				selectRowId2 = undefined;
				var accountS = document.getElementById("accountS").value;
				var searchkey = document.getElementById("searchkey").value;
				var startdate = document.getElementById("start").value;
				var enddate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#usergrid").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({"state":3, rows: this.pageSize, page: this.pageNumber, "account": accountS, "name": searchkey, "htmlStartDate":startdate, "htmlEndDate":enddate},params);
					}}
				);
				$("#ousergrid").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({"state":3, rows: this.pageSize, page: this.pageNumber, "account": accountS, "name": searchkey, "htmlStartDate":startdate, "htmlEndDate":enddate},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#accountS").val("");
			$("#searchkey").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
	</script>
	<script type="text/html" id="accountTemple">
	<div style="height:200px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="accountForm" role="form">
			<input type="hidden" id="id" name="id">

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-account">
					账号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-account" name="account" readonly="readonly" value=""style="border: none;">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					姓名
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-name" name="name">
				</div>
			</div>

			<div class="form-group" id="pwDiv">
				<label class="col-sm-3 control-label no-padding-right" for="form-password">
					密码
				</label>
				<div class="col-sm-8">
					<input type="password" class="form-control" id="form-password" name="password"  value="123456" readonly>
					<font color='red'>默认密码：123456</font>
				</div>
			</div>

			<!--<div class="form-group" id="dpwDiv">
				<label class="col-sm-3 control-label no-padding-right" for="form-defaultPassword">
					默认密码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-defaultPassword" name="defaultPassword"  value="123456" style="border: none;" readonly="readonly">
				</div>
			</div>

			<div class="form-group" id="cpwDiv">
				<label class="col-sm-3 control-label no-padding-right" for="form-confirmPassword">
				<i class="fa fa-asterisk fa-1 red"></i>
					确认密码
				</label>
				<div class="col-sm-8">
					<input type="password" class="form-control" id="form-confirmPassword" name="confirmPassword" value="123456">
				</div>
			</div>-->

		</form>
	</div>
	</script>
</head>
<body class="specialFrame specialDialog specialSearch">

	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12 col-sm-12 specialFrame-grid" style="overflow: auto;">
				<div class="searchDiv">
					<table>
						<tr>
							<td>
								<label>账号</label>
								<input id="accountS" name="accountS" class="specialForm-select">
							</td>
							<td>
								<label>名称</label>
								<input id="searchkey" name="searchkey" class="specialForm-select">
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">创建时间</div>
								<div class="input-group" style="width:150px; float:left;margin-top:5px;margin-left:5px;">
									<input class="form-control date-picker specialForm-select" id="start" name="start" 
										data-date-format="yyyy-mm-dd" placeholder="开始时间">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</td>
							<td>
								<div style="float:left;margin-left:5px;margin-right:5px;font-size:14;line-height: 40px;"> 至  </div>
								<div class="input-group" style="width:150px; float:left;margin-top:5px;">
									<input class="form-control date-picker specialForm-select" id="end" name="end" 
										data-date-format="yyyy-mm-dd" placeholder="结束时间">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</td>
							<td>
								<button onclick="search();"  style="margin-left:20px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="clearSearch();"  style="margin-left:5px;" class="btn btn-app btn-light btn-xs" >清空</button>
							</td>
						</tr>
					</table>
				</div>
				
				<ul id="usertab" class="nav nav-tabs" style="margin-top: 6px;height:40px;">
				   <li class="active">
				      <a href="#usergridtab" data-toggle="tab" class="user">
				         	在用账号
				      </a>
				   </li>
				   <li>
				      <a href="#ousergridtab" data-toggle="tab" class="ouser">
				         	停用账号
				      </a>
				   </li>
				</ul>

				<div class="tab-content">  
				    <div class="tab-pane active" id="usergridtab">
						<div id="toolbar1">
							<span id="onUseBtns">
								<button class="btn btn-app btn-light btn-xs" onclick="addAccount();">
									<i class="fa fa-plus"></i>
									新增
								</button>
								<button class="btn btn-app btn-light btn-xs" onclick="updateAccount();">
									<i class="fa fa-pencil"></i>
									修改
								</button>
								<button class="btn btn-app btn-light btn-xs" onclick="closeAccount();">
									<i class="fa fa-trash-o"></i>
									停用
								</button>
								<button class="btn btn-app btn-light btn-xs btnWidth" onclick="fixRole();">
									<i class="fa fa-tasks"></i>
									角色配置
								</button>
								<button class="btn btn-app btn-light btn-xs btnWidth" onclick="resetPassword();">
									<i class="fa fa-share"></i>
									密码重置
								</button>
							</span>
						</div>
						<table id="usergrid"></table>
				    </div>
				     
				    <div class="tab-pane" id="ousergridtab">
						<div id="toolbar2">
							<span id="onUseBtns">
								<button class="btn btn-app btn-light btn-xs btnWidth" onclick="recoveryAccount();">
									<i class="fa fa-tasks"></i>
									恢复使用
								</button>
							</span>
						</div>
						<table id="ousergrid"></table>
				    </div>  
				</div>
								
			</div>
		</div>
	</div>

	<div style="display:none;"></div>
	<div style="visibility: hidden;">
		<table id="exportTable"></table>
	</div>
</body>
</html>