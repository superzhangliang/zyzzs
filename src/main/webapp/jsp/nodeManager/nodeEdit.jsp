<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>节点维护</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<style type="text/css">
	table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		
		$(function() {
			$.ajax({
				url: "${basepath}node/getNodeDetail.do",
				type: "post",
				data: {"nodeId":"${node.id}"},
				dataType:"json",
				success:function(data){
					if (data.data != undefined) {
						$("#id").val(data.data.id);
						$("#code").val(data.data.code);
						$("#type").val(data.data.type);
						$("#name").val(data.data.name);
						$("#regId").val(data.data.regId);
						$("#addr").val(data.data.addr);
						$("#tel").val(data.data.tel);
						$("#fax").val(data.data.fax);
						$("#email").val(data.data.email);
					}
				}
			});
		});
		
		
		//保存更改
		function editNode(){
			if (validateSql("code,name,regId,addr,tel,fax,email", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		var str = JSON.stringify("id="+$("#id").val()+"&code="+$("#code").val()+"&type="+$("#type").val()+"&name="+$("#name").val()
							+"&="+$("#regId").val()+"&addr="+$("#addr").val()+"&tel="+$("#tel").val()+"&fax="+$("#fax").val()+"&email="+$("#email").val())
				str = str.substring(str.indexOf("\"")+1,str.lastIndexOf("\""));
				if (checkNotNull()) {
					$.ajax({
						url: "${basepath}node/editNode.do",
						type: "post",
						data: str,
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									$("#msgDiv").addClass("alert-success");
								}  else {
									$("#msgDiv").addClass("alert-danger");
								}
								BootstrapDialog.alert(data.msg);
							}
						},
						error: function() {
							$("#msgDiv").addClass("alert-danger").removeClass("hide");
							$("#returnMsg").html("提交异常");
						}
					});
				}
	    	}
		}
		
		function checkNotNull() {
			var msg = '';
			
			var code = $("#code").val();
			var type = $("#type").val();
			var name = $("#name").val();
			var regId = $("#regId").val();
			var addr = $("#addr").val();
			var tel = $("#tel").val();
			var email = $("#email").val();
			
			if (code == undefined || $.trim(code) == '') {
				msg += ' 企业编码不能为空；';
			}
			if (type == undefined || $.trim(type) == '') {
				msg += ' 品类不能为空；';
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
		
	</script>
</head>
<body class="specialFrame specialDialog specialSearch">
	<div class="container-fluid">
		<div class="row">
			<div class="specialFrame-grid">
				<div class="searchDiv" style="padding-top:20px;border:0px;">
					<table align="center" >
						<tr>
							<td colspan=2>
								<div class="alert alert-block hide" id="msgDiv">
									<strong id="returnMsg"></strong>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<label>企业编码</label>
							</td>
							<td>
								<input id="id" name="id" type="hidden">
								<input id="code" name="code" class="specialForm-text" style = "width:300px;" readOnly>
							</td>
						</tr>
						
						<tr>
							<td>
								<label>品类</label>
							</td>
							<td>
								<select id="type" name="type" class="specialForm-text" style = "width:300px;">
									<option value="">——请选择——</option>
									<option value="1">肉类</option>
									<option value="2">菜类</option>
								</select>
							</td>
						</tr>
						
						<tr>
							<td>
								<label>企业名称</label>
							</td>
							<td>
								<input id="name" name="name" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>
							<td>
								<label style="width:130px;">工商注册登记证号</label>
							</td>
							<td>
								<input id="regId" name="regId" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>							
							<td>
								<label>经营地址</label>
							</td>
							<td>
								<input id="addr" name="addr" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>
							<td>
								<label>联系电话</label>
							</td>
							<td>
								<input id="tel" name="tel" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>							
							<td>
								<label>传真</label>
							</td>
							<td>
								<input id="fax" name="fax" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>							
							<td>
								<label>邮箱</label>
							</td>
							<td>
								<input id="email" name="email" class="specialForm-text" style = "width:300px;">
							</td>
						</tr>
						
						<tr>
							<td colspan=2>
								<button onclick="editNode();"  style="margin-left:180px;" class="btn btn-app btn-light btn-xs" >保存</button>
							</td>
						</tr>
						
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
