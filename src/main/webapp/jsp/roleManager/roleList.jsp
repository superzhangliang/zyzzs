<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../head.jsp" %>
<%@include file="../table.jsp"%>
<script src="${basepath}js/dist/template.js"></script>
<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
<style type="text/css">
img { padding-top: 5px;cursor: pointer;}
i {	font-size: 19px; cursor: pointer;}
</style>
<script type="text/javascript">
	function refresh() {
		search();
	}
	var table, selectRowId;
	$(function() {
		var bodyH = parseInt( $(document.body).innerHeight() ),
			searchH = parseInt( $(".searchDiv").outerHeight() ),
			temp = 25,
			gridH = bodyH - searchH - temp;
		table = $("#table");
		table.bootstrapTable({
			url: "${basepath}role/getRole.do",
			columns: [ {
				field: "name",
				title: "角色名称",
				align: "center",
				valign: "middle",
			}, {
				field: "description",
				title: "描述",
				align: "center",
				valign: "middle",
			}, {
				field: "",
				title: "人员授权",
				align: "center",
				valign: "middle",
				formatter: function(value, row) {	
						var url = '';																
						var url = '<i class="iconfont icon-shouquanguanli" title="人员授权" onclick="selectUsers('+row.id+','+'\''+row.name+'\''+');"/>' ;
						return url;	
				}					
			}, {
				field: "",
				title: "功能授权",
				align: "center",
				valign: "middle",
				formatter: function(value, row) {	
						var url = '';								
						if(row.isManager==1){
						var url = '<i class="iconfont icon-shouquan"  title="菜单授权"  onclick="openMessage();"/>' ;																						
						}else{
						var url = '<i class="iconfont icon-shouquan"  title="菜单授权"  onclick="selectMenus('+row.id+','+'\''+row.name+'\''+');"/>' ;
						}	
						return url;
				}					
			}],
			pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
			method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id'
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
	});
	
	//搜索
	function search() {
		if (validateSql("name", 2)) {
	    	BootstrapDialog.alert(sqlErrorTips);
	    } else {
	    	selectRowId = undefined;
			var name = $("#name").val();
			var pageSize = 10;
			if ($(".page-size") && $(".page-size").html() != '') {
				pageSize = $(".page-size").html();
			}
			$("#table").bootstrapTable(
				'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
					return $.extend({},params,{"name": name});
				}}
			);
	    }
	}
	
	function clearSearch(){
		$("#name").val("");
		
		search();
	}
	
	function addRole() {
		//显示对话框
		BootstrapDialog.show({
            title: "<h5>新增角色</h5>",
            message: template('roleTemple', {}),
            nl2br: false,
            closeByBackdrop: false,
            draggable: true,
            onshown: function(dialog) {
				//隐藏提示信息
				$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
				//清空表单信息
				$("#roleForm")[0].reset();
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
						if (validateSql("roleForm", 1)) {
					    	BootstrapDialog.alert(sqlErrorTips);
					    	$button.enable();//验证失败,提交按钮可用
					    } else {
					    	$.ajax({
								url: "${basepath}role/editRole.do",
								type: "post",
								data: $("#roleForm").serialize(),
								dataType:"json",
								success:function(data){
									if (data != undefined) {
										if (data.success) {
											search();
											dialog.close();
										}  else {
											$button.enable();//提交失败,提交按钮可用
										}
										BootstrapDialog.alert("操作成功！");
									}
								},
								error: function() {
									BootstrapDialog.alert("提交异常");
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

	function updateRole(){
		if (selectRowId == undefined || selectRowId == '') {
			BootstrapDialog.alert("请先选中需要修改的角色！");
			return;
		}
		var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
	
		//显示对话框
		BootstrapDialog.show({
            title: "<h5>修改角色：<span class='orange2'>" + row.name + "</span></h5>",
            message: template('roleTemple', {}),
            nl2br: false,
            closeByBackdrop: false,
            draggable: true,
            onshown: function(dialog) {
				//隐藏提示信息
				$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
				//清空表单信息
				$("#roleForm")[0].reset();
				//初始化表单数据
				$("#id").val(row.id);
				$("#form-name").val(row.name);
				$("#form-description").val(row.description);
				if( row.isManager == 1 ){
					$("#form-isManager").attr("checked","checked");
				}
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
						if (validateSql("roleForm", 1)) {
					    	BootstrapDialog.alert(sqlErrorTips);
					    	$button.enable();//验证失败,提交按钮可用
					    } else {
					    	$.ajax({
								url: "${basepath}role/editRole.do",
								type: "post",
								data: $("#roleForm").serialize(),
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
	
	function deleteRole(){
		if (selectRowId == undefined || selectRowId == '') {
			BootstrapDialog.alert("请先选中需要删除的角色！");
			return;
		}
		var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
		if(row.isManager==1){
			BootstrapDialog.alert("管理员角色不能删除！");
			return;
		}
		BootstrapDialog.confirm("确认删除\"" + row.name + "\"角色?", function (yes) {
			if (yes) {
				$.ajax({
					url: "${basepath}role/deleteRole.do",
					type: "post",
					data: {roleId : row.id},
					dataType:"json",
					success:function(data){
						if (data != undefined) {
							BootstrapDialog.alert(data.msg);
							search();
						}else{
							BootstrapDialog.alert("删除失败！");
							search();
						}
					}
				});
			}
		});
	}
	
	function selectUsers(roleId,roleName){			
		//显示对话框
		BootstrapDialog.frame({
            title: "<h5>人员授权：<span class='orange2'>" + roleName + "</span></h5>",
            src:'${basepath}role/showUserView.do?roleId=' + roleId + '&username=' + encodeURI(roleName),
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
						url: "${basepath}role/setRoleUser.do",
						type: "post",
						data: {
							'roleId': roleId,
							'nodeStr': contentWindow.$("#nodeStr").val()
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
	
	function selectMenus(roleId,roleName){
		//显示对话框
		BootstrapDialog.frame({
            title: "<h5>功能授权：<span class='orange2'>" + roleName + "</span></h5>",
            src:'${basepath}role/showMenuView.do?roleId=' + roleId,
            frameId: "menuFrame",
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
                	var contentWindow = $("#menuFrame")[0].contentWindow;
                	contentWindow.sumbitRole($button);
             	    $.ajax({
						url: "${basepath}role/setRoleMenu.do",
						type: "post",
						data: {
							'organMenu':contentWindow.$("#nodeStr").val(),
							'roleId':roleId
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
	
	function openMessage(){
		BootstrapDialog.alert("管理员拥有所有菜单");
	}
	
	function checkNotNull() {
		var msg = '';
		if( $("#form-isManager").attr("checked") == 'checked' ){
			$("#form-isManager").val(1);
		}else{
			$("#form-isManager").val(0);
		}
		
		var name=$("#form-name").val();
		if(name == undefined || $.trim(name) == ''){
			msg += ' 角色名称不能为空；<br>';
		}
		
		var description=$("#form-description").val();
		if(description == undefined || $.trim(description) == ''){
			msg += ' 请添加描述；<br>';
		}
		
		if (msg != '') {
			BootstrapDialog.alert(msg);
			return false;
		} else {
			return true;
		}
	}		

	
</script>
<script type="text/html" id="roleTemple">
	<div style="height:200px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="roleForm" role="form">
			<input type="hidden" id="id" name="id">
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					角色名称
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-name" name="name" placeholder="">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-description">
					描述
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-description" name="description" placeholder="">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-isManager">
					是否管理员
				</label>
				<div class="col-sm-6  control-label" style="text-align:left;">
					<input type="checkbox" id="form-isManager" name="isManager">
				</div>
			</div>
		</form>
	</div>
	</script>
</head>
<body class="specialFrame specialDialog specialSearch">
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12 col-sm-12 specialFrame-grid">
				<div class="searchDiv" style="padding: 8px 15px;">
					<table>
						<tr>
							<td>
								<label>角色名称</label>
								<input id="name" name="name" class="specialForm-text">
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
						<button class="btn btn-app btn-light btn-xs" onclick="addRole();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateRole();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteRole();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
					</span>
				</div>
				<table id="table"></table>
			</div>
		</div>
	</div>
</body>
</html>