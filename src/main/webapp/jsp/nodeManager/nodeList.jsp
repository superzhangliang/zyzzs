<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>节点管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<style type="text/css">
	table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		
		var table, selectRowId;
		var v=null;
		$(function() {
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			table.bootstrapTable({
				url: "${basepath}node/getNode.do",
				columns: [ {
					field: "code",
					title: "企业编码",
					align: "center",
					valign: "middle"
				}, {
					field: "type",
					title: "种养殖类型",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						var url;
						if( value == <%=Constants.TYPE_MEAT%>){
							url='<%=Constants.TYPE_BREED%>';
						}else if( value == <%=Constants.TYPE_VEGETABLES%>){
							url='<%=Constants.TYPE_PLANT%>';
						}
						return url; 
					} 
				},{
					field: "name",
					title: "企业名称",
					align: "center",
					valign: "middle"
				}, {
					field: "regId",
					title: "工商注册登记证号",
					align: "center",
					valign: "middle"
				},{
					field: "addr",
					title: "经营地址",
					align: "center",
					valign: "middle"
				},{
					field: "tel",
					title: "联系电话",
					align: "center",
					valign: "middle"
				},{
					field: "fax",
					title: "传真",
					align: "center",
					valign: "middle"
				},{
					field: "email",
					title: "邮箱",
					align: "center",
					valign: "middle"
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
			if (validateSql("code,name", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				var code = $("#code").val();
				var name = $("#name").val();
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({},params,{"code": code,"name": name});
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#code").val("");
			$("#name").val("");
			
			search();
		}
		
		//新增节点
		function addNode() {
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>新增节点</h5>",
	            message: template('nodeTemple', {}),
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
					$("#nodeForm")[0].reset();
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
							if (validateSql("nodeForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}node/editNode.do",
									type: "post",
									data: $("#nodeForm").serialize(),
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
		
		//修改节点
		function updateNode() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的节点！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
	            title: "<h5>修改节点：<span class='orange2'>" + row.name + "</span></h5>",
	            message: template('nodeTemple', {}),
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
					$("#nodeForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-code").val(row.code);
					$("#form-type").val(row.type);
					$("#form-name").val(row.name);
					$("#form-regId").val(row.regId);
					$("#form-addr").val(row.addr);
					$("#form-tel").val(row.tel);
					$("#form-fax").val(row.fax);
					$("#form-email").val(row.email);
					
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
							if (validateSql("nodeForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}node/editNode.do",
									type: "post",
									data: $("#nodeForm").serialize(),
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
		
		//删除节点
		function deleteNode(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的节点！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.name + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}node/deleteNode.do",
						type: "post",
						data: {nodeId: row.id},
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
			
			var code = $("#form-code").val();
			var type = $("#form-type").val();
			var name = $("#form-name").val();
			var regId = $("#form-regId").val();
			var addr = $("#form-addr").val();
			var tel = $("#form-tel").val();
			var email = $("#form-email").val();
			
			var maxCode = 9;
			var lengthCode = getByteLen(code);
			if(code == undefined || $.trim(code) == ''){
				msg += ' 企业编码不能为空；<br>';
			}else if(lengthCode!=maxCode){
				msg += ' 请输入9位企业编码；<br>';
			}
			
			if (type == undefined || $.trim(type) == '') {
				msg += ' 种养殖类型不能为空；';
			}
			if (name == undefined || $.trim(name) == '') {
				msg += ' 企业名称不能为空；';
			}
			if (regId == undefined || $.trim(regId) == '') {
				msg += ' 工商注册登记证号不能为空；';
			}
			if (addr == undefined || $.trim(addr) == '') {
				msg += ' 地址不能为空；';
			}
			if (tel == undefined || $.trim(tel) == '') {
				msg += ' 电话不能为空；';
			}
			if (email == undefined || $.trim(email) == '') {
				msg += ' 邮箱不能为空；';
			}else if(!email.match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/)){
			 	msg += ' 邮箱格式不正确；';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
		//获取字符串长度（汉字算两个字符，字母数字算一个）
		function getByteLen(val) {
			var len = 0;
			for (var i = 0; i < val.length; i++) {
			  var a = val.charAt(i);
			  if (a.match(/[^\x00-\xff]/ig) != null) {
			    len += 2;
			  }
			  else {
			    len += 1;
			  }
			}
			return len;
		}
		
	</script>
	<script type="text/html" id="nodeTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="nodeForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-areaName" name="areaName">

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-code">
					<i class="fa fa-asterisk fa-1 red"></i>
					企业编码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-code" name="code" maxlength="9" onkeyup="this.value=this.value.replace(/\D/g,'')">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-type">
					<i class="fa fa-asterisk fa-1 red"></i>
					种养殖类型
				</label>
				<div class="col-sm-8">
					<select class="form-control" id="form-type" name="type">
						<option value="">——请选择——</option>
						<option value="<%=Constants.TYPE_MEAT%>"><%=Constants.TYPE_BREED%></option>
						<option value="<%=Constants.TYPE_VEGETABLES%>"><%=Constants.TYPE_PLANT%></option>
					</select>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					企业名称
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
				<label class="col-sm-3 control-label no-padding-right" for="form-addr">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营地址
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-addr" name="addr">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-tel">
					<i class="fa fa-asterisk fa-1 red"></i>
					电话
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-tel" name="tel">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-fax">
					传真
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-fax" name="fax">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-email">
					<i class="fa fa-asterisk fa-1 red"></i>
					邮箱
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-email" name="email">
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
				<div class="searchDiv" >
					<table>
						<tr>
							<td>
								<label>企业编码</label>
								<input id="code" name="code" class="specialForm-text">
							</td>
							<td>
								<label>企业名称</label>
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
						<button class="btn btn-app btn-light btn-xs" onclick="addNode();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateNode();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteNode();">
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
