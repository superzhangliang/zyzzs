<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
<%@include file="../head.jsp" %>
<%@include file="../table.jsp"%>
<script src="${basepath}js/dist/template.js"></script>
<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
<script type="text/javascript">
	var table;
	var showName = '${param.showName}'
	var isFlag = showName == 'true'?true:false;
	function refresh() {
		search();
	}
	$(function() {
		//初始化日期控件
	 	$('.date-picker').datepicker({
			autoclose: true,
			todayHighlight: true,
			language: 'cn'
		});
		
		var bodyH = parseInt( $(document.body).innerHeight() ),
			searchH = parseInt( $(".searchDiv").outerHeight() ),
			temp = 25,
			gridH = bodyH - searchH - temp;
		table = $("#table");
		table.bootstrapTable({
			url: "${basepath}inputsManager/showNumChangeRecord.do?pId=${param.pId}",
			columns: [ {
				title: "序号",
				align: "center",
				valign: "middle",
				formatter: function (value, row, index) {
				    var pageSize=$('#table').bootstrapTable('getOptions').pageSize;  
				    var pageNumber=$('#table').bootstrapTable('getOptions').pageNumber;
				    return pageSize * (pageNumber - 1) + index + 1;
				}
			},{
				field: "flag",
				title: "类型",
				align: "center",
				valign: "middle",
				formatter: function(value, row) {
					var url="";
					if( value==1 ){
						url="采购";
					}else if( value==2 ){
						url="投入";
					}else if( value==3 ){
						url="报废";
					}
					return url;
				}
			}, {
				field: "prodBatchId",
				title: "产品批次号",
				align: "center",
				valign: "middle"
			}, {
				field: "purchaseBatchId",
				title: "采购批次号",
				align: "center",
				valign: "middle"
			}, {
				field: "reason",
				title: "报废原因",
				align: "center",
				valign: "middle"
			}, {
				field: "num",
				title: "数量",
				align: "center",
				valign: "middle",
				formatter: function(value, row) {
					return value+" "+row.unit;
				}
			}, {
				field: "addTime",
				title: "时间",
				align: "center",
				valign: "middle",
				formatter: function(value, row) {
					if( row.updateTime != null ){
						return formatTimeSecondStr(row.updateTime);
					}else{
						return formatTimeSecondStr(value);
					}
				}
			}, {
				title: "操作",
				align: "center",
				valign: "middle",
				visible: !isFlag,
				formatter: function(value, row) {
					var url = '';
					if( row.flag == 3 ){
						var dateDiff = (new Date()).getTime() - (new Date(row.addTime)).getTime();//时间差的毫秒数
    					var dayDiff = Math.floor(dateDiff / (24 * 3600 * 1000));//计算出相差天数
    					if( dayDiff < 1 ){
    						url +=  '<i class="fa fa-reply fa-lg" style="cursor:pointer;" title="撤销报废" onclick="cancelScrap('+(new Date(row.addTime)).getTime()+','
    						+row.id+','+row.pId+','+row.num+');"/>' ;
    					}
					}	
					return url;
				}
			}],
			pagination: true, striped: true, sidePagination: "server",height:gridH,
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
		});
		
	});
	
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
				return $.extend({},params,{"htmlStartDate":startdate, "htmlEndDate":enddate});
			}}
		);
	}
	
	function clearSearch(){
		$("#start").val("");
		$("#end").val("");
		
		search();
	}
	
	//撤销报废
	function cancelScrap( times, id, pId, num ){
		var dateDiff = (new Date()).getTime() - times;//时间差的毫秒数
		var dayDiff = Math.floor(dateDiff / (24 * 3600 * 1000));//计算出相差天数
		if( dayDiff >= 1 ){
			BootstrapDialog.alert("撤销报废已超过限定时间，无法撤销！");
			return;
		}
		BootstrapDialog.confirm("确定撤销报废？", function (yes) {
			if (yes) {
				$.ajax({
					url: "${basepath}inputsManager/cancelScrap.do",
					type: "post",
					data: {"id" : id, "pId": pId, "num": num},
					dataType:"json",
					success:function(data){
						BootstrapDialog.alert(data.msg);
						search();
						window.parent.search();
					}
				});
			}
		});
	}

	
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
								<div style="float:left;font-size:14;line-height: 40px;">时间</div>
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
</body>
</html>