<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
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
	<title>出场管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	<script src="${basepath}/js/areainfo.js"></script> 
	<!-- 小票打印插件 -->
	<script src="${basepath}/js/LodopFuncs.js"></script>
	
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		
		var table, selectRowId , listProds , total=0;
		var prodBatchId = '' , prodId = '' , startDate = '' , endDate = '' ;
		var listBatchInfo, LODOP, printContent;
		var type = '${node.type}';
		
		$(function() {
			
			var vla = "";
			if(<%=type==1%>) {
				vla = "动物产地检疫合格证号或检测合格证号"
			}else if(<%=type==2%>) {
				vla = "产地证明号或检测合格证号"
			}else{
				vla = "产地证明号或检测合格证号或动物产地检疫合格证号"
				$("#addButton").attr("style","display:none;");
				$("#exportButton").attr("style","display:none;");
			}
			
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
			table = $("#table");
			var columns = [{
					field: "prodBatchId",
					title: "<%=title%>批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "prodName",
					title: "产品名称",
					align: "center",
					valign: "middle"
				}, {
					field: "traceCode",
					title: "追溯码",
					align: "center",
					valign: "middle"
				},{
					field: "outDate",
					title: "出场日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "buyerName",
					title: "买家",
					align: "center",
					valign: "middle"
				},{
					field: "weight",
					title: "重量",
					align: "center",
					valign: "middle"
				},{
					field: "quarantineId",
					title: vla,
					align: "center",
					valign: "middle"
				}];
				columns[columns.length] = {
					field: "isReport",
					title: "状态",
					align: "center",
					valign: "middle",
					formatter: function (value, row) {
						var val = "";
						if(value == 0) {
							val = "未同步";
						} else {
							val = "已同步";
						}
						return val;
					}
				}
			table.bootstrapTable({
				url: "${basepath}originOutInfo/getOriginOutInfo.do",
				columns: columns,
				pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar',
				method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id',
				//加载成功时执行
				onLoadSuccess: function(data){ 
					if(data!=null&&data!=''){
						total=data.total;
					}
			    }
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
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			
			getProdsList();
			getProdBatchInfoList();
			fullProdBatchInfo('','prodId');
		});
		
		//获取产品信息
		function getProdsList(){
			$.ajax({
				url:'${basepath}prodManager/getProdManager.do?isDelete=0',
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listProds = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//获取种养殖批次号
		function getProdBatchInfoList(){
			$.ajax({
				url:'${basepath}originBatchInfo/getOriginBatchInfo.do',
				type:'post',
				dataType:'json',
				async:false,
				success:function(data){
					listBatchInfo = eval(data.rows);
				},
				error:function(){
					$.ligerDialog.error('操作失败！');
				}
			});
		}
		
		//填充种养殖批次号下拉列表
		function fullProdBatchInfo(prodBatchId,opsName){
			if(prodBatchId==undefined||prodBatchId==null){
				prodBatchId = '';
			}
			if(opsName!=undefined&&opsName=='form-prodBatch'){
				$("#"+opsName+"").find("option").remove(); 
		  		var ops;
					ops += '<option value="">请选择</option>';
		  		if (listBatchInfo && listBatchInfo.length > 0) {
					
					for (var i = 0; i < listBatchInfo.length; i++) {
						
						ops += '<option value="' + listBatchInfo[i].prodId + '@'+(listBatchInfo[i].prodName == undefined ? '' : listBatchInfo[i].prodName )
						+'@'+ listBatchInfo[i].prodBatchId + '"';
						if(prodBatchId == listBatchInfo[i].prodBatchId ){
							ops += ' selected ';
						}
						ops += ' >' + listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
					}
					
				}
				
				$("#"+opsName+"").append(ops);
				
				if(ops!=""){
		  			$("#"+opsName+"").selectpicker({
		                'selectedText': 'cat'
		            });
		            
		            var formEntry = $("#"+opsName+"").val().split("@");
		  			$("#form-prodId").val(formEntry[0]);
			  		$("#form-prodName").val(formEntry[1]);
			  		$("#form-prodBatchId").val(formEntry[2]);
		  		}
		  		//刷新插件
				$("#"+opsName+"").selectpicker('refresh'); 
			}else if(opsName!=undefined&&opsName=='prodId'){
				$("#"+opsName+"").find("option").remove();
				var ops;
					ops += '<option value="">'+'请选择'+'</option>';
				if( listProds && listProds.length > 0 ){
					
					for(var i=0;i<listProds.length;i++){
						ops += '<option value="' + listProds[i].id + '"';
						
						ops += '>' + listProds[i].name + '</option>';
					}
					
				}
				$("#"+opsName+"").append(ops);
			}
	  	}
	  	
	  	
	  	//种养殖批次号下拉框改变事件
	  	function selectProdBatchIdChange(){
	  		var formOutInfo = $("#form-prodBatch").val().split("@");
	  		
	  		$("#form-prodId").val(formOutInfo[0]);
	  		$("#form-prodName").val(formOutInfo[1]);
	  		$("#form-prodBatchId").val(formOutInfo[2]);
	  		
	  		if(formOutInfo[2]==undefined||formOutInfo[2]==''){
	  			getProdBatchInfoList();
				fullProdBatchInfo('','form-prodBatch');
				
				getHarvestBatchInfoList('');
				fullHarvestBatchInfo('');
	  		}else{
	  			getHarvestBatchInfoList(formOutInfo[2]);
	  			fullHarvestBatchInfo('');
	  		}
	  	}
	  	
	  	//获取种养殖收获批次号
		function getHarvestBatchInfoList(prodBatchId){
			if(prodBatchId==undefined||prodBatchId==null){
				prodBatchId='';
			}
			$.ajax({
				url:'${basepath}originHarvestInfo/getOriginHarvestInfo.do?prodBatchId='+prodBatchId,
				type:'post',
				dataType:'json',
				async:false,
				success:function(data){
					listHarvestInfo = eval(data.rows);
				},
				error:function(){
					$.ligerDialog.error('操作失败！');
				}
			});
		}
		
	  	//填充种养殖收获批次号下拉列表
		function fullHarvestBatchInfo(harvestBatchId){
			if(harvestBatchId==undefined||harvestBatchId==null){
				harvestBatchId='';
			}
		
	  		$("#form-harvestBatch").find("option").remove(); 
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listHarvestInfo && listHarvestInfo.length > 0) {
				
				for (var i = 0; i < listHarvestInfo.length; i++) {
					
					ops += '<option value="' + listHarvestInfo[i].harvestBatchId + '@'+ listHarvestInfo[i].prodBatchId+'"';
					if(harvestBatchId==listHarvestInfo[i].harvestBatchId){
						ops += ' selected';
					}
					ops += ' >' + listHarvestInfo[i].harvestBatchId + '('+listHarvestInfo[i].prodName+')' + '</option>';
				}
				
			}
			$("#form-harvestBatch").append(ops);
			$("#form-harvestBatch").selectpicker({
                'selectedText': 'cat'
            });
            
		  	//刷新插件
			$("#form-harvestBatch").selectpicker('refresh'); 
	  	}
	  	
	  	//种养殖收获批次号下拉框改变事件
	  	function selectHarvestBatchIdChange(){
	  		var formHarvestInfo = $("#form-harvestBatch").val().split("@");
	  		$("#form-harvestBatchId").val(formHarvestInfo[0]);
	  		
  			fullProdBatchInfo(formHarvestInfo[1],'form-prodBatch');
	  	}
	  	
	  	//获取买家信息
		function getBuyerList(){
			$.ajax({
				url:'${basepath}business/getBusiness.do?type=2',
				type:'post',
				dataType:'json',
				async:false,
				success:function(data){
					listBuyer= eval(data.rows);
				},
				error:function(){
					$.ligerDialog.error('操作失败！');
				}
			});
		}
		
	  	//填充买家下拉列表
		function fullBuyer(buyerId,buyerName){
			if(buyerId==undefined||buyerId==null){
				buyerId='';
			}
			if(buyerName==undefined||buyerName==null){
				buyerName='';
			}
	  		$("#form-buyer").find("option").remove(); 
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listBuyer && listBuyer.length > 0) {
				ops += '<option value="@散客"';
				if(buyerName=='散客'){
					ops += ' selected';
				}
				ops += ' >散客</option>';
				for (var i = 0; i < listBuyer.length; i++) {
					
					ops += '<option value="' + listBuyer[i].id + '@'+ listBuyer[i].name+'"';
					if(buyerId==listBuyer[i].id){
						ops += ' selected';
					}
					ops += ' >' + listBuyer[i].name  + '</option>';
				}
				
			}
			$("#form-buyer").append(ops);
			$("#form-buyer").selectpicker({
                'selectedText': 'cat'
            });
            
		  	//刷新插件
			$("#form-buyer").selectpicker('refresh'); 
	  	}
	  	
	  	//买家下拉框改变事件
		function selectBuyerChange(){
			var formBuyer = $("#form-buyer").val().split("@");
	  		$("#form-buyerId").val(formBuyer[0]);
	  		$("#form-buyerName").val(formBuyer[1]);
		}
	  	
		//搜索
		function search() {
			if (validateSql("prodBatchId,prodId,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				prodBatchId = document.getElementById("prodBatchId").value;
				prodId = document.getElementById("prodId").value;
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
			$("#prodId").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		//新增出场信息
		function addOutInfo() {
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增出场信息</h5>",
	            message: template('outInfoTemple', {}),
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
					$("#outInfoForm")[0].reset();
					
					$("#form-outDate").datepicker( "setDate", new Date() );
					$("#traceCodeDiv").attr("style","display:none;");
					
					var htmlDiv = '';
					if(type == '1') {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 动物产地检疫合格证号或检测合格证号'
					}else if(type == '2') {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号'
						$("#form-qty").val(1);
						$("#qutyDiv").attr("style","display:none;");
					}else {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号或动物产地检疫合格证号'
					} 
					$("#quarantineIdDiv").html(htmlDiv);
					
					getProdBatchInfoList();
					fullProdBatchInfo('','form-prodBatch');
					
					getHarvestBatchInfoList('');
					fullHarvestBatchInfo('');
					
					getBuyerList();
					fullBuyer('','');
	            },
	            buttons: [{
	                label: '取消',
	                action: function(dialog){
	                    dialog.close();
	                }
	            }, {
	                label: '确定不打印',
	                cssClass: 'btn-primary',
	                action: function(dialog){
	                	print(<%=Constants.PRINT_NO%>,this,dialog);
	                }
	            },{
	                label: '确定并打印',
	                cssClass: 'btn-primary',
	                action: function(dialog){
	                	print(<%=Constants.PRINT_YES%>,this,dialog);
	                }
	            }]
	        });
		}
		
		//打印小票
		function print(isPrint,$button,dialog){
        	$button.disable();
			if (checkNotNull()) {
				if (validateSql("outInfoForm", 1)) {
	    			BootstrapDialog.alert(sqlErrorTips);
	    			$button.enable();//验证失败,提交按钮可用
	    		} else {
	    			$.ajax({
						url: "${basepath}originOutInfo/editOriginOutInfo.do?isPrint="+isPrint,
						type: "post",
						data: $("#outInfoForm").serialize(),
						dataType:"json",
						success:function(data){
							if (data != undefined) {
								if (data.success) {
									BootstrapDialog.alert("操作成功！");
									printContent = data.printContent;
									if(printContent!=undefined && printContent!=''){
										prnPreview(printContent);
									}
									
									$.ajax({
										url: "${basepath}originOutInfo/synToSY.do",
										type: "post",
										data: {outInfoId: data.id},
										dataType:"json",
										async: false,
										success:function(data){
											search();
										}
									});
									
									dialog.close();
								}  else {
									$button.enable();//提交失败,提交按钮可用
								}
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
		
		//直接打印小票
		function prnPreview(printContent) {
            CreatePrintPage(printContent);
            LODOP.PRINT();
        };
        function CreatePrintPage(printContent){
        	var collectList = printContent.collects;
            var height = 60;
            LODOP = getLodop(document.getElementById('LODOP1'), document.getElementById('LODOP_EM1'));
            LODOP.SET_PRINT_PAGESIZE(3,2430,60,"");//设置制作大小
            LODOP.SET_PRINT_STYLE("FontSize",12);//设置字体大小
            LODOP.ADD_PRINT_TEXT(30, 60, 260, 80, "交易信息");    
            LODOP.SET_PRINT_STYLE("FontSize",9);    
            if(printContent.nodeName.length>9){
            	LODOP.ADD_PRINT_TEXT(height, 5, 260, 20, "企业名称:"+printContent.nodeName.substring(0,9));
                height += 20;
                LODOP.ADD_PRINT_TEXT(height, 5, 260, 20, printContent.nodeName.substring(9));
            }
            height += 20;
            LODOP.ADD_PRINT_TEXT(height, 5, 260, 30, "交易日期："+ formatTimeStr(printContent.outDate));
            height += 20;
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 10;
            LODOP.ADD_PRINT_TEXT(height, 10, 50, 20, "名称");
            LODOP.ADD_PRINT_TEXT(height, 70, 50, 20, "重量");
            LODOP.ADD_PRINT_TEXT(height, 130, 50, 20, "数量");
            
            height += 20;
           	for(var i=0;i<collectList.length;i++){
           		if(collectList[i].name.length>3){
           			LODOP.ADD_PRINT_TEXT(height, 5, 260, 20, collectList[i].name);
                    height += 20;
                    LODOP.ADD_PRINT_TEXT(height, 67, 100, 20, collectList[i].weight);
                    LODOP.ADD_PRINT_TEXT(height, 127, 100, 20, collectList[i].num);
                    
                    height += 20;
               	}else{
               		LODOP.ADD_PRINT_TEXT(height, 5, 100, 20, collectList[i].name);
               		LODOP.ADD_PRINT_TEXT(height, 67, 100, 20, collectList[i].weight);
               		LODOP.ADD_PRINT_TEXT(height, 127, 100, 20, collectList[i].num);
                    height += 20;
               	}
           	}
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 10;
            LODOP.ADD_PRINT_TEXT(height, 5, 100, 20, "件数:"+printContent.num);
           
            height += 20;
            LODOP.ADD_PRINT_BARCODE(height, 35, 150, 150, "QRCode", printContent.codeContent);
            height += 135;
            LODOP.ADD_PRINT_TEXT(height, 30, 200, 20, printContent.code);
            height += 70;
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 20;
        }
		
		//修改出场信息
		function updateOutInfo() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的出场信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>修改出场信息：<span class='orange2'>" + row.prodBatchId + "</span></h5>",
	            message: template('outInfoTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					
					var htmlDiv = '';
					if(type == '1') {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 动物产地检疫合格证号或检测合格证号'
					}else if(type == '2') {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号'
						$("#form-qty").val(1);
						$("#qutyDiv").attr("style","display:none;");
					}else {
						htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号或动物产地检疫合格证号'
					} 
					$("#quarantineIdDiv").html(htmlDiv);
					
					//清空表单信息
					$("#outInfoForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-outDate").datepicker( "setDate", formatTimeStr(row.outDate) );
					$("#form-prodBatchId").val(row.prodBatchId);
					$("#form-harvestBatchId").val(row.harvestBatchId);
					$("#form-weight").val(row.weight);
					$("#form-price").val(row.price);
					$("#form-destCode").val(row.destCode);
					$("#form-dest").val(row.dest);
					$("#form-quarantineId").val(row.quarantineId);
					$("#form-traceCode").val(row.traceCode);
					$("#form-logisticsCode").val(row.logisticsCode);
					$("#form-buyerId").val(row.buyerId);
					$("#form-buyerName").val(row.buyerName);
					$("#form-isReport").val(row.isReport);
					
					getProdBatchInfoList();
					fullProdBatchInfo(row.prodBatchId,'form-prodBatch');
					
					getHarvestBatchInfoList('');
					fullHarvestBatchInfo(row.harvestBatchId);
					
					getBuyerList();
					fullBuyer(row.buyerId,row.buyerName);
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
							if (validateSql("outInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}originOutInfo/editOriginOutInfo.do",
									type: "post",
									data: $("#outInfoForm").serialize(),
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
		
		//删除出场信息
		function deleteOutIfo(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的出场信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.prodBatchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}originOutInfo/deleteOriginOutInfo.do",
						type: "post",
						data: {outInfoId: row.id},
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
		
		//导出出场信息
		function exportOutInfo(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?prodBatchId='+prodBatchId+'&prodId='+prodId+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}originOutInfo/exportOriginOutInfo.do'+parameterStr;
		} 
		
		//补打小票
		function printTicket(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要打印的出场信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			$.ajax({
				url: "${basepath}originOutInfo/getTicketContent.do?outInfoId="+row.id,
				type: "post",
				dataType:"json",
				success:function(data){
					if (data != undefined) {
						if (data.success) {
							printContent = data.printContent;
							if(printContent!=undefined && printContent!=''){
								prnPreview(printContent);
							}
							BootstrapDialog.alert("操作成功！");
						} else{
							BootstrapDialog.alert("操作失败！");
						} 
					}else{
						BootstrapDialog.alert("操作失败！");
					}
					
				},
				error: function() {
					BootstrapDialog.alert("打印异常");
				}
			});
		}
		
		function checkNotNull() {
			var msg = '';
			
			var prodBatchId = $("#form-prodBatchId").val();
			var harvestBatchId = $("#form-harvestBatchId").val();
			var buyerName = $("#form-buyerName").val();
			var outDate = $("#form-outDate").val();
			var prodName = $("#form-prodName").val();
			var weight = $("#form-weight").val();
			var quarantineId = $("#form-quarantineId").val();
			var isReport = $("#form-isReport").val();
			
			if (prodBatchId == undefined || $.trim(prodBatchId) == '') {
				msg += ' <%=title%>批次号不能为空；<br>';
			}
			if (harvestBatchId == undefined || $.trim(harvestBatchId) == '') {
				msg += ' <%=title%>收获批次号不能为空；<br>';
			}
			if (buyerName == undefined || $.trim(buyerName) == '') {
				msg += ' 买家不能为空；<br>';
			}
			if (outDate == undefined || $.trim(outDate) == '') {
				msg += ' 出场日期不能为空；<br>';
			}
			if (prodName == undefined || $.trim(prodName) == '') {
				msg += ' 产品名称不能为空；<br>';
			}
			if (weight == undefined || $.trim(weight) == '') {
				msg += '重量不能为空；<br>';
			}
			if (quarantineId == undefined || $.trim(quarantineId) == '') {
				msg += $("#quarantineIdDiv").text()+'不能为空；<br>';
			}
			
			if (isReport != undefined && $.trim(isReport) == '1') {
				msg += ' 数据已经上传到追溯平台，不能修改；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
	<script type="text/html" id="outInfoTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="outInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="form-isReport" name="isReport">
			
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodBatch">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>批次号
					</label>
					<div class="col-sm-8" id="prodBatchDiv">
						<input type="hidden" id="form-prodBatchId" name="prodBatchId">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-prodBatch"  onchange="selectProdBatchIdChange()">
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-harvestBatch">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>收获批次号
					</label>
					<div class="col-sm-8" id="harvestBatchDiv">
						<input type="hidden" id="form-harvestBatchId" name="harvestBatchId">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-harvestBatch"  onchange="selectHarvestBatchIdChange()">
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-buyer">
						<i class="fa fa-asterisk fa-1 red"></i>
						买家
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-buyerId" name="buyerId">
						<input type="hidden" id="form-buyerName" name="buyerName">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-buyer" onchange="selectBuyerChange()">
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-outDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						出场日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-outDate" name="outDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodName">
						<i class="fa fa-asterisk fa-1 red"></i>
						产品名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-prodId" name="prodId">
						<input type="text" class="form-control" id="form-prodName" name="prodName" readOnly>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-weight">
						<i class="fa fa-asterisk fa-1 red"></i>
						重量
					</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="form-weight" name="weight" min="1">
					</div>
				</div>
	
			</div>
	
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group" id="traceCodeDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-traceCode">
						追溯码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-traceCode" name="traceCode" readonly>
					</div>
				</div>
			
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-price">
						单价
					</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="form-price" name="price" min="1">
					</div>
				</div> 
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-quarantineId">
						<div id="quarantineIdDiv"></div>
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-quarantineId" name="quarantineId">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-logisticsCode">
						物流单号
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-logisticsCode" name="logisticsCode">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-destCode">
						到达地编码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-destCode" name="destCode">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-dest">
						到达地
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-dest" name="dest">
					</div>
				</div>
	
	
			</div>
			
		</form>
	</div>
	</script>
	
</head>
<body class="specialFrame specialDialog specialSearch">
	<input type="hidden" id="basepath" value="${basepath}" />
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12 col-sm-12 specialFrame-grid">
				<div class="searchDiv" >
					<table>
						<tr>
							<td>
								<label><%=title%>批次号</label>
								<input id="prodBatchId" name="prodBatchId" class="specialForm-text">
							</td>
							<td>
								<label>产品名称</label>
								<select id="prodId" name="prodId" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">出场日期</div>
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
				<div id="toolbar">
					<span id="onUseBtns">
						<button	id="addButton" class="btn btn-app btn-light btn-xs" onclick="addOutInfo();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateOutInfo();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteOutIfo();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button	id="exportButton" class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportOutInfo();">
							<i class="fa fa-arrow-circle-right"></i>
							导出数据
						</button>
						<button class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="printTicket();">
							<i class="fa fa-print"></i>
							补打小票
						</button>
					</span>
					
				</div>
				<table id="table"></table>
			</div>
		</div>
	</div>
</body>
</html>
