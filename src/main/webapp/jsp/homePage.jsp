<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title></title>
	<jsp:include page="head.jsp" flush="true"></jsp:include>
	<jsp:include page="zTree.jsp" flush="true"></jsp:include>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<script src="${basepath}js/echarts.js"></script>
	<style type="text/css">
		.page-content {overflow-x: hidden; overflow-y: hidden;}
		.title {width: 100%; line-height: 30px; text-align: center; font-family: "黑体"; font-size: 24px;margin-top:10px}
	</style>
	<script type="text/javascript">
		
		$(function() {
			$.ajax({
				url:'${basepath}baseNode/statisticsBaseNodeInfo.do',
				type:'post',
				dataType:'json',
				success:function(data){
					var result = data.result;
					var dataOneAll = new Array();
					var dataTwoAll = new Array();
					var dataOneDay = new Array();
					var dataTwoDay = new Array();
					var now = data.now;
					if(result!=null&&result.length>0){
						for(var i=0;i<result.length;i++){
							if(result[i].allCount!=0){
								dataOneAll.push(result[i].compName);
								var rowData = new Object;
								rowData.value = result[i].allCount;
								rowData.name = result[i].compName;
								dataTwoAll.push(rowData);
								
							}
							if(result[i].dayCount!=0){
								dataOneDay.push(result[i].compName);
								var rowData = new Object;
								rowData.value = result[i].dayCount;
								rowData.name = result[i].compName;
								dataTwoDay.push(rowData);
							}
						}
					}
					var h = $(".page-content-area").height();
					parent.$("#content").height(h + "px");
					var temp = 41;
					 parent.$("#sidebar").height(h + temp + "px"); 
					 if(dataOneAll!=null&&dataOneAll.length>0){
					 	$("#nodeAll").css("display","");
					 	showChatOneNow(dataOneAll,dataTwoAll);
					 }
					 /*$("#nodeDay").css("display","");
					  showChatTwoNow(dataOneAll,dataTwoAll);  */
					 if(dataOneDay!=null&&dataOneDay.length>0){
					 	$("#nodeDay").css("display","");
					 	$("#titleDay").html("各个流通节点("+now+")上报总数据");
					 	showChatTwoNow(dataOneDay,dataTwoDay);
					 	
					 }
				}
			 }); 
			/*var h = $(".page-content-area").height();
			parent.$("#content").height(h + "px");
			var temp = 41;
			parent.$("#sidebar").height(h + temp + "px");*/

		});
		function showChatOneNow(dataOne,dataTwo){
			var nodeAllData = echarts.init(document.getElementById('nodeAllData'));
			
			// 指定图表的配置项和数据
	        var option = {
	        		tooltip : {
	        			position: function (point, params, dom, rect, size) {
					    return [point[1], '30%'];
						},
	        	        trigger: 'item',
	        	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	        	    },
	        	    legend: {
	        	        type: 'scroll',
				        orient: 'vertical',
				        right:50,
				        top: 20,
	        	        data: dataOne,
	        	        formatter:function(name){
	        	        	var name = name.length>7?name.substring(0,7)+"...":name;
	        	        	return name;
	        	        }
	        	    },
	        	    series : [
	        	        {
	        	            name: '节点名称',
	        	            type: 'pie',
	        	            radius : '90%',
	        	            center: ['40%', '50%'],
	        	            data:dataTwo,
	        	            itemStyle: {
	        	                emphasis: {
	        	                    shadowBlur: 10,
	        	                    shadowOffsetX: 0,
	        	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	        	                }
	        	            },
	        	            label:{
	        	            	normal:{
	        	            		show:false,
	        	            	}
	        	            }
	        	        }
	        	    ]
	        	};

	        // 使用刚指定的配置项和数据显示图表。
	        nodeAllData.setOption(option);
		}
		
		function showChatTwoNow(dataOne,dataTwo){
			var nodeAllData = echarts.init(document.getElementById('nodeDayData'));
			
			// 指定图表的配置项和数据
	        var option = {
	        		tooltip : {
	        			position: function (point, params, dom, rect, size) {
					    return [point[1], '30%'];
					    },
	        	        trigger: 'item',
	        	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	        	    },
	        	    legend: {
	        	        type: 'scroll',
				        orient: 'vertical',
				        right:50,
				        top: 20,
	        	        data: dataOne,
	        	        formatter:function(name){
	        	        	var name = name.length>7?name.substring(0,7)+"...":name;
	        	        	return name;
	        	        }
	        	    },
	        	    series : [
	        	        {
	        	            name: '节点名称',
	        	            type: 'pie',
	        	            radius : '90%',
	        	            center: ['40%', '50%'],
	        	            data:dataTwo,
	        	            itemStyle: {
	        	                emphasis: {
	        	                    shadowBlur: 10,
	        	                    shadowOffsetX: 0,
	        	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	        	                }
	        	            },
	        	            label:{
	        	            	normal:{
	        	            		show:false,
	        	            	}
	        	            }
	        	        }
	        	    ]
	        	};

	        // 使用刚指定的配置项和数据显示图表。
	        nodeAllData.setOption(option);
		}
	</script>
	
	<style>
		html,body{height:100%;}
	</style>
</head>
<body style="overflow: hidden;">

	<div class="page-content" >
		<!-- /section:settings.box -->
		<div class="page-content-area" style="height: 900px">
			<table style="width:100%">
				<tr>
					<td width="50%">
						<div class="nodeAll" id="nodeAll" style="display:none">
						 <div class="title">各个流通节点上报总数据</div>
						 <div id="nodeAllData" style="width: 100%; height: 300px;"></div>
						</div>
					</td>
					<td width="50%">
						<div class="nodeDay" id="nodeDay" style="display:none">
							<div class="title" id="titleDay">各个流通节点今天上报总数据</div>
							<div id="nodeDayData" style="width: 100%; height: 300px;"></div>
						</div>
					</td>
				</tr>
			</table>
		</div><!-- /.page-content-area -->
	</div><!-- /.page-content -->
			
</body>
</html>