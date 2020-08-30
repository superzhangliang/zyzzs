<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>屠宰数量统计</title>
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
		var table;
		$(function() {
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			table.bootstrapTable({
				url: "${basepath}entry/staticNum.do",
				columns: [{
					field: "inTime",
					title: "进场日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				},{
					field: "allowNumTotal",
					title: "准宰数量",
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
			
			$("#myChartDiv").attr("style","width: 95%;height:75%;margin-top:20px;margin-left:20px;display:'';");
			staticNum();
		});
		
		function staticNum(){
			var startdate = document.getElementById("start").value;
			var enddate = document.getElementById("end").value;
			$.ajax({
				url:"${basepath}entry/staticNum.do?htmlStartDate="+startdate+"&htmlEndDate="+enddate,
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					var dataOne = new Array();
					var dataTwo = new Array();
					for( var i=0;i<data.rows.length;i++ ){
						dataOne.push(formatTimeStr(data.rows[i].inTime));
						dataTwo.push(data.rows[i].allowNumTotal);
					}
					showEchart(dataOne, dataTwo);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		}
		
		function showEchart(dataOne, dataTwo){
			// 基于准备好的dom，初始化echarts实例
        	var myChart = echarts.init(document.getElementById('myChartDiv'));
			var option = {
			    title: {
			        text: '屠宰数量统计'
			    },
			    tooltip: {
			        trigger: 'axis'
			    },
			    legend: {
			        data:['屠宰数量']
			    },
			    grid: {
			        left: '3%',
			        right: '4%',
			        bottom: '3%',
			        containLabel: true
			    },
			    toolbox: {
			        feature: {
			            saveAsImage: {}
			        }
			    },
			    xAxis: {
			        type: 'category',
			        boundaryGap: false,
			        data: dataOne
			    },
			    yAxis: {
			        type: 'value'
			    },
			    series: [
			        {
			            name:'屠宰数量',
			            type:'line',
			            stack: '总量',
			            data:dataTwo
			        }
			    ]
			};
			
			// 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);	
		}
		
		//搜索
		function search() {
			var startdate = document.getElementById("start").value;
			var enddate = document.getElementById("end").value;
			var pageSize = 10;
			if ($(".page-size") && $(".page-size").html() != '') {
				pageSize = $(".page-size").html();
			}
			$("#table").bootstrapTable(
				'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
					return $.extend({rows: this.pageSize, page: this.pageNumber, "htmlStartDate":startdate, "htmlEndDate":enddate},params);
				}}
			);
			
			staticNum();
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
								<button onclick="search();"  style="margin-left:30px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="clearSearch();"  style="margin-left:5px;" class="btn btn-app btn-light btn-xs" >清空</button>
								<button onclick="turnTable();"  id="tableBtn" style="margin-left:5px;width:90px;" class="btn btn-app btn-light btn-xs" >切换表格</button>
								<button onclick="turnLine();"  id="lineBtn" style="margin-left:5px;width:100px;display:none;" class="btn btn-app btn-light btn-xs" >切换线形图</button>
								<button onclick="exportStaticInfo();"  id="exportBtn" style="margin-left:5px;width:100px;display:none;" class="btn btn-app btn-light btn-xs" >导出数据</button>
							</td>
						</tr>
					</table>
					
				</div>
				<div id="tableDiv" style='display:none;'> <table id="table" ></table> </div>
				
				<div id='myChartDiv' style='display:none;padding-top:20px;'></div>
			</div>
		</div>
	</div>
</body>
</html>
