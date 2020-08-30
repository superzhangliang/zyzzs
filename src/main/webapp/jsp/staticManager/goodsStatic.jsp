<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>商品统计(种植面积、养殖数量、交易量)和投入品统计</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	<script src="${basepath}js/echarts.js"></script>
	
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		var table,tableData,statisticType='${param.type}';
		$(function() {
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
			var start = new Date();
            start.setDate(start.getDate() - 6);
            start = new Date(start);
			$("#start").datepicker( "setDate", start );
			$("#end").datepicker( "setDate", new Date() );
			
			initTable();
		});
		
		//初始化表格
		function initTable(){
			var type = $("#type").val();
			var dataFormat = $("#cycleList").val();
			
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 10,
				gridH = bodyH - searchH - temp;
			if( statisticType == "batchAmount" ){
				table = $("#table").bootstrapTable({
					url: "${basepath}originBatchInfo/goodsStatic.do",
					columns: [ {
						field: "goodsCode",
						title: "商品编码",
						align: "center",
						valign: "middle"
					}, {
						field: "goodsName",
						title: "商品名称",
						align: "center",
						valign: "middle"
					}, {
						field: "amount",
						title: "养殖数量/种植面积",
						align: "center",
						valign: "middle"
					}],
					pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
					method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id',
					queryParams:{"showWay":"table","statisticType":statisticType,"type":type}
				});
			}else if( statisticType == "outAmount" ){
				$("#typeTD").remove();
				table = $("#table").bootstrapTable({
					url: "${basepath}originBatchInfo/goodsStatic.do",
					columns: [ {
						field: "goodsCode",
						title: "商品编码",
						align: "center",
						valign: "middle"
					}, {
						field: "goodsName",
						title: "商品名称",
						align: "center",
						valign: "middle"
					}, {
						field: "amount",
						title: "交易量",
						align: "center",
						valign: "middle"
					}],
					pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
					method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id',
					queryParams:{"showWay":"table","statisticType":statisticType}
				});
			}else if( statisticType == "inputsAmount" ){
				$("#typeTD").remove();
				table = $("#table").bootstrapTable({
					url: "${basepath}originBatchInfo/goodsStatic.do",
					columns: [ {
						field: "goodsCode",
						title: "投入品编码",
						align: "center",
						valign: "middle"
					}, {
						field: "goodsName",
						title: "投入品名称",
						align: "center",
						valign: "middle"
					}, {
						field: "amount",
						title: "用量",
						align: "center",
						valign: "middle"
					}],
					pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
					method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id',
					queryParams:{"showWay":"table","statisticType":statisticType}
				});
			}
			
			/* 监听窗口改变,重设高度值 */
			window.onresize = function(){
				var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 10,
				gridH = bodyH - searchH - temp;
				table.bootstrapTable("resetView",{height:gridH});
			};
			
			//绑定选中行事件
			table.on('click-row.bs.table', function (e, row, $element) {
				$('.success').removeClass('success');
				$($element).addClass('success');
			});
			
			//加载完表格时间
			table.on('load-success.bs.table',function(data){
		       tableData = $("#table").bootstrapTable('getData');
		       
		       var display = document.getElementById("showLineBtn").style.display;
				if( display == "" ){
					showTable();			
				}else{
					showLine();
				}
			
		    });
			
		
		}
		
		//切换成表格
		function showTable(){
			$("#showLineBtn").attr("style", "margin-left:30px;width:100px;display:'';");
			$("#showTableBtn").attr("style", "display:none;");
			$("#tableDiv").attr("style", "display:'';");
			$("#lineDiv").attr("style", "display:none;");
			
		}
		
		//切换成线形图
		function showLine(){
			$("#showLineBtn").attr("style", "display:none;");
			$("#showTableBtn").attr("style", "margin-left:30px;width:90px;display:'';");
			$("#tableDiv").attr("style", "display:none;");
			$("#lineDiv").attr("style", "width:100%;height:90%;display:'';margin-top:15px");
			
			//获取表格的所有内容行  
	  		if( tableData != null && tableData.length > 0 ){
	  			$("#noDataDiv").attr("style", "display:none;");
	  			$("#statsCharts").attr("style", "display:'';width:100%;height:90%;");
			
	  			var prodIds="";
	  			for( i=0;i<tableData.length;i++){  
					prodIds = prodIds + "," + tableData[i].prodId;
				}
	
				var type = $("#type").val();
				var start = $("#start").val();
				var end = $("#end").val();
				
				$.ajax({
					url : '${basepath}originBatchInfo/goodsStatic.do',
					dataType : 'json',
					type : 'post',
					data : {"showWay":"line", "statisticType":statisticType,"type": type,"htmlStartDate":start, 
					"htmlEndDate":end, "prodIds":prodIds},
					success : function(data) {
						if( data.listGoods !=undefined && data.listGoods != "" && data.listDate !=undefined && 
							data.listDate != "" && data.listData !=undefined && data.listData != "" ){
							var lineTitleTxt="";
							if( statisticType == "batchAmount" ){
								if(type=="1"){
									lineTitleTxt = "商品养殖数量统计";
								}else{
									lineTitleTxt = "商品种植面积统计";
								}
							}else if( statisticType == "outAmount" ){
								lineTitleTxt = "商品交易量统计";
							}else if( statisticType == "inputsAmount" ){
								lineTitleTxt = "投入品使用量统计";
							}
							
							showChart( lineTitleTxt, data.listGoods, data.listDate, data.listData);					
						}else{
							$("#noDataDiv").attr("style", "display:'';");
							$("#statsCharts").attr("style", "display:none;");
	  						$("#noDataTitle").html("<font color='red' size=4>暂无数据需要统计！</font>");
						}
					}
				});
	  		}else{
	  			$("#noDataDiv").attr("style", "display:'';");
	  			$("#statsCharts").attr("style", "display:none;");
	  			$("#noDataTitle").html("<font color='red' size=4>暂无数据需要统计！</font>");
	  		}
			
		}
		
		function showChart(title, oneData, twoData, threeData) {
			var statsCharts = echarts.init(document.getElementById('statsCharts'));
			var option = {
				title: {
			        text: title
			    },
				tooltip : {
					trigger : 'axis'
				},
				legend : {
					type: 'scroll',
			        orient: 'vertical',
			        right: 25,
			        top: 10,
			        bottom: 3,
					data : oneData
				},
				grid : {
					left : '3%',
					right : '10%',
					bottom : '3%',
					containLabel : true
				},
				toolbox : {
					feature : {
						saveAsImage : {}
					}
				},
				xAxis : {
					type : 'category',
					boundaryGap : false,
					data : twoData
				},
				yAxis : {
					type : 'value'
				},
				series : threeData
			};
	
			statsCharts.setOption(option);
		}
		
		//搜索
		function search() {
			var type = $("#type").val();
			var startdate = document.getElementById("start").value;
			var enddate = document.getElementById("end").value;
			var pageSize = 10;
			if ($(".page-size") && $(".page-size").html() != '') {
				pageSize = $(".page-size").html();
			}
			$("#table").bootstrapTable(
				'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
					return $.extend({rows: this.pageSize, page: this.pageNumber, "showWay":"table", "statisticType":statisticType,"htmlStartDate":startdate, "htmlEndDate":enddate,"type":type},params);
				}}
			);
		}
		
		function clearSearch(){
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		function turnTable(){
			$("#tableBtn").attr("style","margin-left:5px;width:90px;display:none;");
			$("#lineBtn").attr("style","margin-left:5px;width:100px;display:'';");
			$("#exportBtn").attr("style","margin-left:5px;width:100px;display:'';");
			
			$("#tableDiv").attr("style","display:'';");
			$("#myChartDiv").attr("style","display:none;");
			
			search();
		}
		
		function turnLine(){
			$("#tableBtn").attr("style","margin-left:5px;width:90px;display:'';");
			$("#lineBtn").attr("style","margin-left:5px;width:100px;display:none;");
			$("#exportBtn").attr("style","margin-left:5px;width:100px;display:none;");
			
			$("#tableDiv").attr("style","display:none;");
			$("#myChartDiv").attr("style","display:'';");
			
			search();
		}
		
		function exportStaticInfo(){
			var startdate = document.getElementById("start").value;
			var enddate = document.getElementById("end").value;
			location.href = '${basepath}entry/staticNumExport.do?htmlStartDate='+startdate+'&htmlEndDate='+enddate;
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
							<td id="typeTD">
								<label>分类统计</label>
								<select id="type" name="type">
									<option value="1">养殖数量</option>
									<option value="2">种植面积</option>
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">日期</div>
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
								<button onclick="search();"  style="margin-left:10px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="showLine();"  style="margin-left:10px;width:100px;" class="btn btn-app btn-light btn-xs" id="showLineBtn">切换线形图</button>
								<button onclick="showTable();"  style="margin-left:10px;width:90px;display:none;" class="btn btn-app btn-light btn-xs" id="showTableBtn">切换表格</button>
							</td>
						</tr>
					</table>
					
				</div>
				<div id="tableDiv">
					<table id="table"></table>
				</div>
				<div id="lineDiv" style="width:100%;height:90%;margin-top:15px;">
					<div class="title" style="display:none;" id="noDataDiv"><span  id="noDataTitle" ></span></div>
					<div id="statsCharts"  style="width:100%;height:100%;">
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
