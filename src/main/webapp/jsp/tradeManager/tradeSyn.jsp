<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>肉品交易管理</title>
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
		var table, selectRowId;
		$(function() {
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			table.bootstrapTable({
				url: "${basepath}trade/getTrade.do",
				columns: [ {
					field: "batchId",
					title: "进货批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "tradeDate",
					title: "交易日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "businessName",
					title: "货主",
					align: "center",
					valign: "middle"
				}, {
					field: "buyerName",
					title: "买主",
					align: "center",
					valign: "middle"
				},{
					field: "tranId",
					title: "交易凭证号",
					align: "center",
					valign: "middle"
				},{
					field: "meatName",
					title: "商品名称",
					align: "center",
					valign: "middle"
				},{
					field: "weight",
					title: "重量",
					align: "center",
					valign: "middle"
				},{
					field: "price",
					title: "单价",
					align: "center",
					valign: "middle"
				},{
					field: "isReport",
					title: "状态",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						var url="";
						if( value==0 ){
							url="未同步";
						}else{
							url="已同步";
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

			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
			//遮罩层
        	$("#loadingModal").modal({backdrop: 'static', keyboard: false});
        	$("#loadingModal").modal('show');
			
			$.ajax({
				url: "${basepath}trade/synToSY.do",
				type: "post",
				dataType:"json",
				success:function(data){
					$("#loadingModal").modal('hide');
					BootstrapDialog.alert(data.msg);
					search();
				}
			});
		});
		
		
		//搜索
		function search() {
			if (validateSql("batchId,businessName,buyerName,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				var batchId = document.getElementById("batchId").value;
				var businessName = document.getElementById("businessName").value;
				var buyerName = document.getElementById("buyerName").value;
				var startdate = document.getElementById("start").value;
				var enddate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "batchId": batchId, "businessName": businessName, 
						"buyerName": buyerName, "htmlStartDate":startdate, "htmlEndDate":enddate},params);
					}}
				);
	    	}
		}
		
		function clearSearch(){
			$("#batchId").val("");
			$("#businessName").val("");
			$("#buyerName").val("");
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
								<label>进货批次号</label>
								<input id="batchId" name="batchId" class="specialForm-text"  style="width:120px;">
							</td>
							<td>
								<label>货主</label>
								<input id="businessName" name="businessName" class="specialForm-select"  style="width:120px;">
							</td>
							<td>
								<label>买主</label>
								<input id="buyerName" name="buyerName" class="specialForm-select"  style="width:120px;">
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">交易日期</div>
								<div class="input-group" style="width:120px; float:left;margin-top:5px;margin-left:5px;">
									<input class="form-control date-picker specialForm-select" id="start" name="start" 
										data-date-format="yyyy-mm-dd" placeholder="开始日期">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</td>
							<td>
								<div style="float:left;margin-left:5px;margin-right:5px;font-size:14;line-height: 40px;"> 至  </div>
								<div class="input-group" style="width:120px; float:left;margin-top:5px;">
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
