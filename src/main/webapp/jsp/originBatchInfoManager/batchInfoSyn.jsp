<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
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
	<title>进场管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		
		var table;
		$(function() {
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
						valign: "middle"
					}
				}
				
				columus[columus.length] = {
						field: "isReport",
						title: "状态",
						align: "center",
						valign: "middle",
						formatter: function(value, row) {
							var val="";
							if(value == 0) {
								val = "未同步";
							}else {
								val = "已同步";
							}
							return val;
						}
					}
			table.bootstrapTable({
				url: "${basepath}originBatchInfo/getOriginBatchInfo.do",
				columns: columus,
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
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
			
			//遮罩层
        	$("#loadingModal").modal({backdrop: 'static', keyboard: false});
        	$("#loadingModal").modal('show');
			
			$.ajax({
				url: "${basepath}originBatchInfo/synToSY.do",
				type: "post",
				dataType:"json",
				success:function(data){
					$("#loadingModal").modal('hide');
					BootstrapDialog.alert(data.msg);
					search();
				}
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
					listBatchInfo = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//填充产品名称
		function fullprod( prodId ){
			$("#prodName").find("option").remove();
			var ops;
				ops += '<option value="">'+'==请选择=='+'</option>';
			if( listBatchInfo && listBatchInfo.length > 0 ){
				for(var i=0;i<listBatchInfo.length;i++){
					ops += '<option value="' + listBatchInfo[i].id + '"';
					if( prodId != null && prodId != "" && prodId == listBatchInfo[i].id ){
						ops += 'selected';
					}
					ops += '>' + listBatchInfo[i].name + '</option>';
				}
			}
			$("#prodName").append(ops);
		}
		
		//搜索
		function search() {
			if (validateSql("prodBatchId,prodName,start,end", 2)) {
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
								<label><%=title %>批次号</label>
								<input id="prodBatchId" name="prodBatchId" class="specialForm-text">
							</td>
							<td>
								<label>产品名称</label>
								<select id="prodName" name="prodName" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;"><%=title %>开始日期</div>
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
				<table id="table"></table>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="loadingModal">
	    <div style="width: 200px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-100px;margin-top:-10px">
	        <div class="progress progress-striped active" style="margin-bottom: 0;">
	            <div class="progress-bar" style="width: 100%;"></div>
	        </div>
	        <h5 style="color:#fff;font-weight:bold;">正在同步...</h5>
	    </div>
	</div>
	
</body>
</html>
