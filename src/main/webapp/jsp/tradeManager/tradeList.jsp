<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
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
	<!-- 小票打印插件 -->
	<script src="${basepath}/js/LodopFuncs.js"></script>
	
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		var table, selectRowId;
		var listQuarantine;
		var listBuyer;
		var LODOP;
		var printContent;
		var total=0;
		var batchId = '';
		var businessName = '';
		var buyerName = '';
		var startDate = '';
		var endDate = '';
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
					title: "重量(斤)",
					align: "center",
					valign: "middle"
				},{
					field: "price",
					title: "单价(元/斤)",
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
			
			getEntryList();
			
			getBuyerList();
		});
		
		//获取进货批次号
		function getEntryList(){
			$.ajax({
				url:'${basepath}quarantine/getQuarantine.do',
				type:'post',
				dataType:'json',
				success:function(data){
					listQuarantine = eval(data.rows);
				},
				error:function(){
					$.showErr('操作失败！');
				}
			});
		}
		
		//获取买主
		function getBuyerList(){
			$.ajax({
				url:'${basepath}business/getBusiness.do?markTypeStrs=1,2&mark=0',
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listBuyer = eval(data.rows);
				},
				error:function(){
					$.showErr('操作失败！');
				}
			});
		}
	  	
		//填充进货批次号下拉列表
		function fullEntry( batchId ){
	  		$("#form-batch").find("option").remove(); 
	  		if (listQuarantine && listQuarantine.length > 0) {
				var ops;
				for (var i = 0; i < listQuarantine.length; i++) {
					
					ops += '<option value="' + listQuarantine[i].businessId + '@'+listQuarantine[i].businessCode+'@'+listQuarantine[i].businessName
								+'@'+ listQuarantine[i].batchId +'@'+ listQuarantine[i].quarantineAnimalProductsId +'@'+ listQuarantine[i].inspectionMeatId + '"';
					if( batchId != null && batchId != "" && batchId == listQuarantine[i].batchId ){
						ops += ' selected ';
					}
					
					ops += ' >' + listQuarantine[i].batchId + '</option>';
				}
				$("#form-batch").append(ops);
			}
			$("#form-batch").selectpicker({
                'selectedText': 'cat'
            });
            
            var formEntry = $("#form-batch").val().split("@");
	  		$("#form-businessId").val(formEntry[0]);
	  		$("#form-businessCode").val(formEntry[1]);
	  		$("#form-businessName").val(formEntry[2]);
	  		$("#form-batchId").val(formEntry[3]);
	  		$("#form-quarantineAnimalProductsId").val(formEntry[4]);
	  		$("#form-inspectionMeatId").val(formEntry[5]);
	  	}
	  	
	  	//填充买主下拉列表
		function fullBuyer( buyerId ){
	  		$("#form-buyer").find("option").remove(); 
	  		if (listBuyer && listBuyer.length > 0) {
				var ops;
				for (var i = 0; i < listBuyer.length; i++) {
					ops += '<option value="' + listBuyer[i].id + '@'+listBuyer[i].code+'@'+listBuyer[i].name+'"';
					if( buyerId != null && buyerId != "" && buyerId == listBuyer[i].id){
						ops += ' selected ';
					}
					ops += ' >' + listBuyer[i].name + '</option>';
				}
				
				$("#form-buyer").append(ops);
			}
			$("#form-buyer").selectpicker({
                'selectedText': 'cat'
            });
            
            var formBuyer = $("#form-buyer").val().split("@");
	  		$("#form-buyerId").val(formBuyer[0]);
	  		$("#form-buyerCode").val(formBuyer[1]);
	  		$("#form-buyerName").val(formBuyer[2]);
	  		
	  		//刷新插件
	  		$("#form-buyer").selectpicker('refresh'); 
	  	}
	  	
	  	//进货批次号下拉框改变事件
	  	function selectBatchIdChange(){
	  		var formEntry = $("#form-batch").val().split("@");
	  		$("#form-businessId").val(formEntry[0]);
	  		$("#form-businessCode").val(formEntry[1]);
	  		$("#form-businessName").val(formEntry[2]);
	  		$("#form-batchId").val(formEntry[3]);
	  		$("#form-quarantineAnimalProductsId").val(formEntry[4]);
	  		$("#form-inspectionMeatId").val(formEntry[5]);
	  	}
	  	
	  	//买主下拉框改变事件
	  	function selectBuyerChange(){
	  		var formBuyer = $("#form-buyer").val().split("@");
	  		$("#form-buyerId").val(formBuyer[0]);
	  		$("#form-buyerCode").val(formBuyer[1]);
	  		$("#form-buyerName").val(formBuyer[2]);
	  	}
		
		//搜索
		function search() {
			if (validateSql("batchId,businessName,buyerName,start,end", 2)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
	    		selectRowId = undefined;
				batchId = document.getElementById("batchId").value;
				businessName = document.getElementById("businessName").value;
				buyerName = document.getElementById("buyerName").value;
				startDate = document.getElementById("start").value;
				endDate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "batchId": batchId, "businessName": businessName, 
						"buyerName": buyerName, "htmlStartDate":startDate, "htmlEndDate":endDate},params);
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
		
		//新增交易信息
		function addTrade() {
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增交易信息</h5>",
	            message: template('tradeTemple', {}),
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
					$("#tradeForm")[0].reset();
					
					$("#form-tradeDate").datepicker( "setDate", new Date() );
					$("#tranIdDiv").attr("style","display:none;");
					fullEntry();
					fullBuyer();
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
				if (validateSql("tradeForm", 1)) {
	    			BootstrapDialog.alert(sqlErrorTips);
	    			$button.enable();//验证失败,提交按钮可用
	    		} else {
	    			$.ajax({
						url: "${basepath}trade/editTrade.do?isPrint="+isPrint,
						type: "post",
						data: $("#tradeForm").serialize(),
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
										url: "${basepath}trade/synToSY.do",
										type: "post",
										data: {tradeId: data.id},
										dataType:"json",
										async: false,
										success:function(data){
										}
									});
									search();
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
        	var date = new Date();
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            var hour = date.getHours();
            var minute = date.getMinutes();
            var second = date.getSeconds();
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
            LODOP.ADD_PRINT_TEXT(height, 5, 260, 30, "交易时间：" + year + "-" + month + "-"+ day + " " + hour + ":"+ minute + ":" + second);
            height += 20;
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 10;
            LODOP.ADD_PRINT_TEXT(height, 10, 50, 20, "名称");
            LODOP.ADD_PRINT_TEXT(height, 45, 50, 20, "单价");
            LODOP.ADD_PRINT_TEXT(height, 85, 50, 20, "数量");
            LODOP.ADD_PRINT_TEXT(height, 135, 50, 20, "小计");
            height += 20;
           	for(var i=0;i<collectList.length;i++){
           		if(collectList[i].name.length>3){
           			LODOP.ADD_PRINT_TEXT(height, 5, 260, 20, collectList[i].name);
                    height += 20;
                    LODOP.ADD_PRINT_TEXT(height, 40, 100, 20, collectList[i].sell);
                    LODOP.ADD_PRINT_TEXT(height, 80, 100, 20, collectList[i].num);
                    LODOP.ADD_PRINT_TEXT(height, 125, 120, 20, collectList[i].total);
                    height += 20;
               	}else{
               		LODOP.ADD_PRINT_TEXT(height, 5, 100, 20, collectList[i].name);
                    LODOP.ADD_PRINT_TEXT(height, 40, 100, 20, collectList[i].sell);
                    LODOP.ADD_PRINT_TEXT(height, 80, 100, 20, collectList[i].num);
                    LODOP.ADD_PRINT_TEXT(height, 125, 120, 20, collectList[i].total);
                    height += 20;
               	}
           	}
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 10;
            LODOP.ADD_PRINT_TEXT(height, 5, 100, 20, "件数:"+printContent.num);
            LODOP.ADD_PRINT_TEXT(height, 70, 150, 20, "合计:"+printContent.sum);
            height += 20;
            LODOP.ADD_PRINT_BARCODE(height, 25, 150, 150, "QRCode", printContent.codeContent);
            height += 135;
            LODOP.ADD_PRINT_TEXT(height, 30, 200, 20, printContent.code);
            height += 70;
            LODOP.ADD_PRINT_LINE(height,5, height, 255,0, 2);
            height += 20;
        }
		
		
		//修改交易信息
		function updateTrade() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的交易信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>修改交易信息：<span class='orange2'>" + row.batchId + "</span></h5>",
	            message: template('tradeTemple', {}),
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
	            	$('.date-picker').datepicker({
						autoclose: true,
						todayHighlight: true,
						language: 'cn'
					});
					//隐藏提示信息
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					//清空表单信息
					$("#tradeForm")[0].reset();
					
					//初始化表单数据
					$("#id").val(row.id);
					$("#form-tradeDate").datepicker( "setDate", formatTimeStr( row.tradeDate) );
					$("#form-batchId").val(row.batchId);
					$("#form-businessId").val(row.businessId);
					$("#form-businessCode").val(row.businessCode);
					$("#form-businessName").val(row.businessName);
					$("#form-buyerId").val(row.buyerId);
					$("#form-buyerCode").val(row.buyerCode);
					$("#form-buyerName").val(row.buyerName);
					$("#form-dest").val(row.dest);
					$("#form-tranId").val(row.tranId);
					$("#form-quarantineAnimalProductsId").val(row.quarantineAnimalProductsId);
					$("#form-inspectionMeatId").val(row.inspectionMeatId);
					$("#form-meatCode").val(row.meatCode);
					$("#form-meatName").val(row.meatName);
					$("#form-weight").val(row.weight);
					$("#form-price").val(row.price);
					
					fullEntry(row.batchId);
					fullBuyer(row.buyerId);
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
							if (validateSql("tradeForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}trade/editTrade.do",
									type: "post",
									data: $("#tradeForm").serialize(),
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
		
		//删除交易信息
		function deleteTrade(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要删除的交易信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + row.batchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}trade/deleteTrade.do",
						type: "post",
						data: {tradeId: row.id},
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
		
		//导出肉品交易信息
		function exportTrade(){
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?batchId='+batchId+'&businessName='+businessName+'&buyerName='+buyerName+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}trade/exportTrade.do'+parameterStr;
		}
		
		//补打小票
		function printTicket(){
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要打印的交易信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			$.ajax({
				url: "${basepath}trade/getTicketContent.do?tradeId="+row.id,
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
			
			var tradeDate = $("#form-tradeDate").val();
			var batchId = $("#form-batchId").val();
			var businessCode = $("#form-businessCode").val();
			var buyerCode = $("#form-buyerCode").val();
			var meatCode = $("#form-meatCode").val();
			var quarantineAnimalProductsId = $("#form-quarantineAnimalProductsId").val();
			var inspectionMeatId = $("#form-inspectionMeatId").val();
			var weight = $("#form-weight").val();
			var price = $("#form-price").val();
			
			if (tradeDate == undefined || $.trim(tradeDate) == '') {
				msg += ' 抽检日期不能为空；<br>';
			}
			if (batchId == undefined || $.trim(batchId) == '') {
				msg += ' 进货批次号不能为空；<br>';
			}
			if (businessCode == undefined || $.trim(businessCode) == '') {
				msg += ' 货主不能为空；<br>';
			}
			if (buyerCode == undefined || $.trim(buyerCode) == '') {
				msg += ' 买主不能为空；<br>';
			}
			if ((quarantineAnimalProductsId == undefined || $.trim(quarantineAnimalProductsId) == '') && (inspectionMeatId == undefined || $.trim(inspectionMeatId) == '') ) {
				msg += ' 动物产品检疫合格证号/肉品品质检验合格证号，二者必填一个；<br>';
			}
			if (meatCode == undefined || $.trim(meatCode) == '') {
				msg += ' 商品编码不能为空；<br>';
			}
			if (weight == undefined || $.trim(weight) == '') {
				msg += ' 重量不能为空；<br>';
			}
			if (price == undefined || $.trim(price) == '') {
				msg += ' 单价不能为空；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		function addBuyer(){
			//显示对话框
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增买主信息</h5>",
	            message: template('businessTemp', {}),
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
					$("#businessForm")[0].reset();
					
					$("#form-recordDate").datepicker( "setDate", new Date() );
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
						if (checkBusinessNotNull()) {
							if (validateSql("businessForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}business/editBusiness.do",
									type: "post",
									data: $("#businessForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												// 更新买主信息
												getBuyerList();
												fullBuyer();
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
		function checkBusinessNotNull(){
			var msg = '';
			
			var name = $("#form-name").val();
			var regId = $("#form-regId").val();
			var property = $("#form-property").val();
			var type = $("#form-type").val();
			var recordDate = $("#form-recordDate").val();
			var legalRepresent = $("#form-legalRepresent").val();
			var tel = $("#form-tel").val();
			
			if (name == undefined || $.trim(name) == '') {
				msg += ' 经营者名称不能为空；<br>';
			}
			if (regId == undefined || $.trim(regId) == '') {
				msg += ' 工商注册登记证号不能为空；<br>';
			}
			if (property == undefined || $.trim(property) == '') {
				msg += ' 经营者性质不能为空；<br>';
			}
			if (type == undefined || $.trim(type) == '') {
				msg += ' 经营者类型不能为空；<br>';
			}
			if (recordDate == undefined || $.trim(recordDate) == '') {
				msg += ' 备案日期不能为空；<br>';
			}
			if (legalRepresent == undefined || $.trim(legalRepresent) == '') {
				msg += ' 法人代表不能为空；<br>';
			}
			if (tel == undefined || $.trim(tel) == '') {
				msg += ' 手机号码不能为空；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
	</script>
	<script type="text/html" id="tradeTemple">
	<div style="height:200px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="tradeForm" role="form">
			<input type="hidden" id="id" name="id">
			
		<div style="float:left;width:46%;text-align:center">

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-tradeDate">
					<i class="fa fa-asterisk fa-1 red"></i>
					交易日期
				</label>
				<div class="col-sm-8">
					<div class="input-group">
						<input class="form-control date-picker" id="form-tradeDate" name="tradeDate" 
							data-date-format="yyyy-mm-dd" readonly>
						<span class="input-group-addon">
							<i class="fa fa-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-batch">
					<i class="fa fa-asterisk fa-1 red"></i>
					进货批次号
				</label>
				<div class="col-sm-8">
					<input type="hidden" id="form-batchId" name="batchId">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-batch"  onchange="selectBatchIdChange()">
    				</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-businessName">
					<i class="fa fa-asterisk fa-1 red"></i>
					货主
				</label>
				<div class="col-sm-8">
					<input type="hidden" id="form-businessId" name="businessId">
					<input type="hidden" id="form-businessCode" name="businessCode">
					<input type="text" class="form-control" id="form-businessName" name="businessName" readOnly>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-buyer">
					<i class="fa fa-asterisk fa-1 red"></i>
					买主
				</label>
				<div class="col-mini-6">
					<input type="hidden" id="form-buyerId" name="buyerId">
					<input type="hidden" id="form-buyerCode" name="buyerCode">
					<input type="hidden" id="form-buyerName" name="buyerName">
					<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-buyer" data-dropup-auto="false" onchange="selectBuyerChange()">
    				</select>
				</div>
				<div class="col-sm-2">
					<input type="button" class="btn" style="width:100%" value="新增" onclick="addBuyer()">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-dest">
					到达地(销售区域)
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-dest" name="dest">
				</div>
			</div>

			<div class="form-group" id="tranIdDiv">
				<label class="col-sm-4 control-label no-padding-right" for="form-tranId">
					<i class="fa fa-asterisk fa-1 red"></i>
					交易凭证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-tranId" name="tranId" readOnly>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-quarantineAnimalProductsId">
					动物产品检疫合格证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-quarantineAnimalProductsId" name="quarantineAnimalProductsId" readOnly>
				</div>
			</div>

		</div>

		<div style="float:left;width:46%;text-align:center">
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-inspectionMeatId">
					肉品品质检验合格证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-inspectionMeatId" name="inspectionMeatId" readOnly>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-meatCode">
					<i class="fa fa-asterisk fa-1 red"></i>
					商品编码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-meatCode" name="meatCode" value="21113011">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-meatName">
					商品名称
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-meatName" name="meatName" value="带皮鲜或冷却胴体大猪肉">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-weight">
					<i class="fa fa-asterisk fa-1 red"></i>
					重量(斤)
				</label>
				<div class="col-sm-8">
					<input type="number" class="form-control" id="form-weight" name="weight" min="0.01" step="0.01">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-price">
					<i class="fa fa-asterisk fa-1 red"></i>
					单价(元/斤)
				</label>
				<div class="col-sm-8">
					<input type="number" class="form-control" id="form-price" name="price" min="0.01" step="0.01">
				</div>
			</div>

		</div>

		</form>
	</div>
	</script>
	<script type="text/html" id="businessTemp">
	<div style="height:200px;">
		<div class="alert alert-block hide" id="businessMsgDiv">
			<strong id="returnBusinessMsg"></strong>
		</div>
		<form class="form-horizontal" id="businessForm" role="form">
		<input type="hidden" id="id" name="id">
		<input type="hidden" id="nodeId" name="nodeId" value="${node.id}">
		<div style="float:left;width:46%;text-align:center">

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者名称
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-name" name="name">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-property">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者性质
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-property" name="property">
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-type">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营类型
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-type" name="type">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-markType">
					<i class="fa fa-asterisk fa-1 red"></i>
					经营者角色
				</label>
				<div class="col-sm-8">
					<select id="form-markType" name="markType" class="form-control" >
						<option value="0">供货商</option>
						<option value="1">买家</option>
						<option value="2">供货商及买家</option>
					</select>
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-tel">
					<i class="fa fa-asterisk fa-1 red"></i>
					手机号码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-tel" name="tel">
				</div>
			</div>	
				
		</div>

		<div style="float:left;width:46%;text-align:center">
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-recordDate">
					<i class="fa fa-asterisk fa-1 red"></i>
					备案日期
				</label>
				<div class="col-sm-8">
					<div class="input-group">
						<input class="form-control date-picker" id="form-recordDate" name="recordDate" 
							data-date-format="yyyy-mm-dd" readonly>
						<span class="input-group-addon">
							<i class="fa fa-calendar bigger-110"></i>
						</span>
					</div>
				</div>
			</div>	
		
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-regId">
					<i class="fa fa-asterisk fa-1 red"></i>
					工商注册登记证号
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-regId" name="regId">
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-legalRepresent">
					<i class="fa fa-asterisk fa-1 red"></i>
					法人代表
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-legalRepresent" name="legalRepresent">
				</div>
			</div>
			
			<div class="form-group">
				<label class="col-sm-4 control-label no-padding-right" for="form-addr">
					地址
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-addr" name="addr">
				</div>
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
								<label>进货批次号</label>
								<input id="batchId" name="batchId" class="specialForm-text"   style="width:120px;">
							</td>
							<td>
								<label>货主</label>
								<input id="businessName" name="businessName" class="specialForm-select"   style="width:120px;">
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
				<div id="toolbar">
					<span id="onUseBtns">
						<button class="btn btn-app btn-light btn-xs" onclick="addTrade();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updateTrade();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="deleteTrade();">
							<i class="fa fa-trash-o"></i>
							删除
						</button>
						<button class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportTrade();">
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
