<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants,com.gdcy.zyzzs.pojo.Node" pageEncoding="UTF-8"%>
 <%
	Integer type = null;
	String title = null;
	/* Node node = (Node) session.getAttribute("node"); */
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
	<title>采购信息查询</title>
	<%@include file="../head.jsp" %>
	<%@include file="../table.jsp" %>
	<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
	<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>
	<script src="${basepath}js/dist/template.js"></script>
	<!-- 检索下拉框 -->
	<link rel="stylesheet" href="${basepath}/js/selectpicker/bootstrap-select.min.css">
	<script src="${basepath}/js/selectpicker/bootstrap-select.min.js"></script>
	<script src="${basepath}/js/areainfo.js"></script> 
	<style type="text/css">
		table tr td { padding: 2px;}
	</style>
	<script type="text/javascript">
		function refresh() {
			search();
		}
		var table, selectRowId,listInputs,purchaseBatchId,pId;
		var startDate = '';
		var endDate = '';
		var total=0;
		var showName = false;
		$(function() {
			if(<%=type==-1%>) {
				showName = true;
				$("#addButton").attr("style","display:none;");
				$("#exportButton").attr("style","display:none;");
			}
			var bodyH = parseInt( $(document.body).innerHeight() ),
				searchH = parseInt( $(".searchDiv").outerHeight() ),
				temp = 25,
				gridH = bodyH - searchH - temp;
				
			table = $("#table");
			var columus = [ {
					field: "purchaseBatchId",
					title: "采购批次号",
					align: "center",
					valign: "middle"
				}, {
					field: "name",
					title: "投入品名称",
					align: "center",
					valign: "middle"
				}, {
					field: "purchaseDate",
					title: "采购日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "num",
					title: "采购数量/采购重量",
					align: "center",
					valign: "middle",
					formatter: function(value,row){
						var url='';
						if( row.purchaseAmount != undefined && Number(row.purchaseAmount)!=0 ){
							url = row.purchaseAmount+row.purchaseUnit;
						}else if( row.totalWeight != undefined && Number(row.totalWeight)!=0 ){
							url = row.totalWeight+row.purchaseUnit;
						}
						return url;
					}
				} ,{
					field: "manufacturerDate",
					title: "生产日期",
					align: "center",
					valign: "middle",
					formatter: function(value, row) {
						return formatTimeStr(value);
					}
				}, {
					field: "supplierName",
					title: "供应商名称",
					align: "center",
					valign: "middle"
				}, {
					field: "isReport",
					title: "状态",
					align: "center",
					valign: "middle",
					formatter: function (value, row) {
						var val = "";
						if(value == 0){
							val = "未同步";
						} else {
							val = "已同步";
						}
						return val;
					}
				},{
				title: "操作",
				align: "center",
				valign: "middle",
				//visible: !showName,
				formatter: function(value, row) {
					var url = '';
   					var times = (new Date(row.addTime)).getTime();
   					var hours = getTimesGap(times);
   					if( hours < 2 ){
   						url +=  '<i class="fa fa-trash-o" style="cursor:pointer;" title="删除" onclick="deletePurchaseInputs('+
   							times+','+row.id+',\''+row.purchaseAmount+'\',\''+row.allNum+'\',\''+row.isReport+'\',\''+row.purchaseBatchId+'\');"/>' ;
   					}
					return url;
				}
			}];
				
			table.bootstrapTable({
				url: "${basepath}originPurchaseInputs/getOriginPurchaseInputs.do",
				columns: columus,
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
			
			
			getInputsList();
			fullInputs("pId",'');
		});
		
		//搜索
		function search() {
			if (validateSql("purchaseBatchId,pId,start,end", 1)) {
	    		BootstrapDialog.alert(sqlErrorTips);
	    	} else {
				selectRowId = undefined;
				purchaseBatchId = document.getElementById("purchaseBatchId").value;
				pId = document.getElementById("pId").value;
				startDate = document.getElementById("start").value;
				endDate = document.getElementById("end").value;
				var pageSize = 10;
				if ($(".page-size") && $(".page-size").html() != '') {
					pageSize = $(".page-size").html();
				}
				$("#table").bootstrapTable(
					'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
						return $.extend({rows: this.pageSize, page: this.pageNumber, "purchaseBatchId": purchaseBatchId, "pId": pId, "htmlStartDate":startDate, "htmlEndDate":endDate},params);
					}}
				);
			}
		}
		
		function clearSearch(){
			$("#purchaseBatchId").val("");
			$("#pId").val("");
			$("#start").val("");
			$("#end").val("");
			
			search();
		}
		
		function fullPurchaseType(purchaseType,nodeType){
			$("#form-purchaseType").find("option").remove();
			var opt = '<option value="">请选择</option>';
			if(nodeType!=undefined&&nodeType!=''){
				if( nodeType != undefined && nodeType == '<%=Constants.TYPE_VEGETABLES%>' ){
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_SEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER_NAME%></option>';
				}else{
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_PUPS_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_FEED_NAME%></option>';
					opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>"';
					if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>'){
						opt += ' selected';
					}
					opt += '><%=Constants.ORIGIN_INPUTS_TYPE_DRUG_NAME%></option>';
				}
				opt += '<option value="<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>"';
				if(purchaseType=='<%=Constants.ORIGIN_INPUTS_TYPE_OTHER%>'){
					opt += ' selected';
				}
				opt += '><%=Constants.ORIGIN_INPUTS_TYPE_OTHER_NAME%></option>';
			}
			
			$("#form-purchaseType").append(opt);
			//刷新插件
			$("#form-purchaseType").selectpicker('refresh'); 
		}
		
		//采购类型改变时
		function selectPurchaseChange(){
			getInputsList($("#form-purchaseType").val());
			fullInputs("form-inputs");
			
			var purchaseType = $("#form-purchaseType").val();
			if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_PESTICIDES%>||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_FERTILIZER%>
			||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_FEED%>||purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>){
				$("#organicDiv").css("display","");
				$("#transgenicDiv").css("display","none");
				if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_DRUG%>){
					$("#organicLabel").html("是否无毒副作用");
				}else{
					$("#organicLabel").html("是否有机");
				}
			}else if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_SEED%>){
				$("#organicDiv").css("display","none");
				$("#transgenicDiv").css("display","");
			}else if(purchaseType==<%=Constants.ORIGIN_INPUTS_TYPE_PUPS%>){
				$("#organicDiv").css("display","none");
				$("#transgenicDiv").css("display","none");
			}else{//全有
				$("#organicDiv").css("display","");
				$("#transgenicDiv").css("display","");
				$("#organicLabel").html("是否有机");
			}
			
		}
		
		//获取投入品信息
		function getInputsList(type){
			if(type==undefined||type==null){
				type='';
			} 
			$.ajax({
				url:'${basepath}inputsManager/getInputsManager.do?type='+type,
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listInputs = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//填充投入品下拉列表
		function fullInputs(optName,pId){
			if(optName!=undefined&&optName=="form-inputs"){
				$("#"+optName+"").find("option").remove(); 
				if (listInputs && listInputs.length > 0) {
					var ops="";
					ops += '<option value="">请选择</option>';
					for (var i = 0; i < listInputs.length; i++) {
						ops += '<option value="' + listInputs[i].id + '@'+listInputs[i].name+'@'+listInputs[i].type+'"';
						if(pId!=undefined&&pId==listInputs[i].id){
							ops += ' selected';
						}
						ops += '>' + listInputs[i].name + '</option>';
					}
					$("#"+optName+"").append(ops);
				} else {
					var ops="";
					ops += '<option value="">请选择</option>';
					$("#"+optName+"").append(ops);
				}
	
				if(ops!=""){
					$("#"+optName+"").selectpicker({
				          'selectedText': 'cat'
				    });
				      
				     if( $("#"+optName+"").val() != null && "" != $("#"+optName+"").val() ){
			      		var formInputs = $("#form-inputs").val().split("@");
						$("#form-pId").val(formInputs[0]);
						$("#form-name").val(formInputs[1]);
						//$("#form-type").val(formInputs[2]);
			      	}
				}
				
				//刷新插件
				$("#"+optName+"").selectpicker('refresh');
			}else{
				if (listInputs && listInputs.length > 0) {
					var ops="";
					ops += '<option value="">请选择</option>';
					for (var i = 0; i < listInputs.length; i++) {
						ops += '<option value="' + +listInputs[i].id+'">' + listInputs[i].name + '</option>';
					}
					$("#"+optName+"").append(ops);
				} else {
					var ops="";
					ops += '<option value="">请选择</option>';
					$("#"+optName+"").append(ops);
				}
			}
	  		 
	  	}
	  	
	  	//投入品信息下拉框改变事件
	  	function selectInputsChange(){
	  		var purchaseType = $("#form-purchaseType").val();
	  		if(purchaseType==undefined||purchaseType==''){
	  			BootstrapDialog.alert("请先选择采购类型！");
	  			fullInputs("form-inputs");
	  		}else{
	  			var formInputs = $("#form-inputs").val().split("@");
				$("#form-pId").val(formInputs[0]);
				$("#form-name").val(formInputs[1]);
				//$("#form-type").val(formInputs[2]);
				
				fullPurchaseType(formInputs[2],'${node.type}');
	  		}
	  		
	  	}
	  	
	  	//获取经营者信息
		function getBusinessList(){
			$.ajax({
				url:'${basepath}business/getBusiness.do?type=<%=Constants.BUSINESS_TYPE_SUPPLIER%>',
				type:'post',
				dataType:'json',
				async:false, 
				success:function(data){
					listBusiness = eval(data.rows);
				},
				error:function(){
					alert('操作失败！');
				}
			});
		} 
		
		//填充供应商下拉列表
		function fullBusiness(supplierId){
	  		$("#form-supplier").find("option").remove(); 
			if (listBusiness && listBusiness.length > 0) {
				var ops="";
				ops += '<option value="">请选择</option>';
				for (var i = 0; i < listBusiness.length; i++) {
					ops += '<option value="' + listBusiness[i].id + '@'+listBusiness[i].name+'"';
					if(supplierId!=undefined&&supplierId==listBusiness[i].id){
						ops += ' selected';
					}
					ops += '>' + listBusiness[i].name + '</option>';
				}
				$("#form-supplier").append(ops);
			} else {
				var ops="";
				ops += '<option value="">请选择</option>';
				$("#form-supplier").append(ops);
			}

			if(ops!=""){
				$("#form-supplier").selectpicker({
			          'selectedText': 'cat'
			    });
			      
			     if( $("#form-supplier").val() != null && "" != $("#form-supplier").val() ){
		      		var formBusiness = $("#form-supplier").val().split("@");
					$("#form-supplierId").val(formBusiness[0]);
					$("#form-supplierName").val(formBusiness[1]);
		      	}
			}
			
			//刷新插件
			$("#form-supplier").selectpicker('refresh'); 
	  	}
	  	
	  	//产品信息下拉框改变事件
	  	function selectSupplierChange(){
	  		var formBusiness = $("#form-supplier").val().split("@");
			$("#form-supplierId").val(formBusiness[0]);
			$("#form-supplierName").val(formBusiness[1]);
	  	}
		
		//新增采购信息
		function addPurchaseInputs() {
			//显示对话框
			BootstrapDialog.show({
				size:BootstrapDialog.SIZE_FULL,
	            title: "<h5>新增采购信息</h5>",
	            message: template('purchaseInputsTemple', {}),
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
					$("#purchaseInputsForm")[0].reset();
					$("#form-purchaseDate").datepicker("setDate",new Date());
					
					fullPurchaseType('',"${node.type}");//采购类型
					//投入品信息
					getInputsList('');
					fullInputs("form-inputs",'');
					//经营者信息
					getBusinessList();
					fullBusiness('');
					
					
					$("#form-result").selectpicker('refresh'); 
					$("#form-upperReaches").selectpicker('refresh');
					$("#form-sourceType").selectpicker('refresh');
					$("#form-organicFlag").selectpicker('refresh'); 
					$("#form-transgenicFlag").selectpicker('refresh');  
					
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
							if (validateSql("purchaseInputsForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
								$.ajax({
									url: "${basepath}originPurchaseInputs/editOriginPurchaseInputs.do",
									type: "post",
									data: $("#purchaseInputsForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												$.ajax({
													url: "${basepath}originPurchaseInputs/synToSY.do",
													type: "post",
													data: {purchaseInputsId: data.id},
													dataType:"json",
													success:function(data){
														search();
													}
												}); 
												search();
												dialog.close();
											}  else {
												$button.enable();//提交失败,提交按钮可用
											}
											BootstrapDialog.alert(data.msg);
										}
									},
									error: function() {
										BootstrapDialog.alert("提交异常！");
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
		
		//修改采购信息
		function updatePurchaseInputs() {
			if (selectRowId == undefined || selectRowId == '') {
				BootstrapDialog.alert("请先选中需要修改的采购信息！");
				return;
			}
			var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			
			//显示对话框
			BootstrapDialog.show({
				size:BootstrapDialog.SIZE_FULL,
	            title: "<h5>修改采购信息：<span class='orange2'>" + row.purchaseBatchId + "</span></h5>",
	            message: template('purchaseInputsTemple', {}),
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
					$("#purchaseInputsForm")[0].reset();
					
					var id = row.id;
					var isReport = row.isReport;
					var purchaseType = row.purchaseType;
					var pId = row.pId;
					var purchaseAmount = row.purchaseAmount;
					var purchasePrice = row.purchasePrice;
					var purchaseUnit = row.purchaseUnit;
					var totalWeight = row.totalWeight;
					var result = row.result;
					var supplierId = row.supplierId;
					var upperReaches = row.upperReaches;
					var sourceType = row.sourceType;
					var organicFlag = row.organicFlag;
					var transgenicFlag = row.transgenicFlag;
					var principalId = row.principalId;
					var principalName = row.principalName;
					var periodDate = row.periodDate;
					var manufacturerId = row.manufacturerId;
					var manufacturerName = row.manufacturerName;
					var license = row.license;
					
					$("#form-id").val(id);
					$("#form-isReport").val(isReport);
					fullPurchaseType(purchaseType,row.type);//采购类型
					selectPurchaseChange();
					//投入品信息
					getInputsList('');
					fullInputs("form-inputs",pId);
					$("#form-purchaseDate").datepicker("setDate",formatTimeStr(row.purchaseDate));
					
					if(purchaseAmount!=undefined&&Number(purchaseAmount)!=0){
						$("#form-num").val(purchaseAmount);
						$("input:radio[value='1']").attr('checked','true');
					}else if(totalWeight!=undefined&&Number(totalWeight)!=0){
						$("#form-num").val(totalWeight);
						$("input:radio[value='2']").attr('checked','true');
					}
					$("#form-purchasePrice").val(purchasePrice);
					$("#form-purchaseUnit").val(purchaseUnit);
					$("#form-manufacturerDate").datepicker("setDate",formatTimeStr(row.manufacturerDate));
					$("#form-result").val(result);
					
					//经营者信息
					getBusinessList();
					fullBusiness(supplierId);
					$("#form-upperReaches").val(upperReaches);
					$("#form-sourceType").val(sourceType);
					$("#form-organicFlag").val(organicFlag);
					$("#form-transgenicFlag").val(transgenicFlag);
					
					$("#form-principalId").val(principalId);
					$("#form-principalName").val(principalName);
					if(periodDate!=undefined&&periodDate!=null&&periodDate!=''){
						$("#form-periodDate").datepicker("setDate",formatTimeStr(row.periodDate));
					}
					$("#form-manufacturerId").val(manufacturerId);
					$("#form-manufacturerName").val(manufacturerName);
					$("#form-license").val(license);
					
					$("#form-result").selectpicker('refresh'); 
					$("#form-upperReaches").selectpicker('refresh');
					$("#form-sourceType").selectpicker('refresh');
					$("#form-organicFlag").selectpicker('refresh'); 
					$("#form-transgenicFlag").selectpicker('refresh'); 
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
							if (validateSql("purchaseInputsForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
								$.ajax({
									url: "${basepath}originPurchaseInputs/editOriginPurchaseInputs.do",
									type: "post",
									data: $("#purchaseInputsForm").serialize(),
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
		
		//删除采购信息
		function deletePurchaseInputs( hours, id ,num , allNum ,isReport,purchaseBatchId){
			var hours = getTimesGap(hours);
			if( hours >= 2 ){
				BootstrapDialog.alert("删除已超过限定时间，无法删除！");
				return;
			}
			if(Number(num)>Number(allNum)){
				BootstrapDialog.alert("删除数量超过库存数量，无法删除！");
				return;
			}
			if(isReport!=undefined&&isReport=='1'){
				BootstrapDialog.alert("数据已经同步到溯源平台，不能删除！");
				return;
			}
			//var row = table.bootstrapTable('getRowByUniqueId', selectRowId);
			BootstrapDialog.confirm("确认删除\"" + purchaseBatchId + "\"?", function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}originPurchaseInputs/deleteOriginPurchaseInputs.do",
						type: "post",
						data: {purchaseInputsId: id},
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
		
		//导出批次信息
		function exportPurchaseInputs(){
			debugger;
			if(total==0||total==''||total==null){
				BootstrapDialog.alert("没有数据，不能导出数据！");
				return;
			}
			var parameterStr = '?purchaseBatchId='+purchaseBatchId+'&pId='+pId+
				'&htmlStartDate='+startDate+'&htmlEndDate='+endDate;
			location.href = '${basepath}originPurchaseInputs/exportOriginPurchaseInputs.do'+parameterStr;
		} 
		
		function checkNotNull() {
			var msg = '';
			
			var msg = '';
			var pId = $("#form-pId").val();
			var purchaseDate = $("#form-purchaseDate").val();
			var purchaseNum = $("input[name='purchaseNum']:checked").val();
			var num = $("#form-num").val();
			var manufacturerDate = $("#form-manufacturerDate").val();
			var supplierName = $("#form-supplierName").val();
			var isReport = $("#form-isReport").val();
			
			if (pId == undefined || $.trim(pId) == '') {
				msg += ' 请选择投入品；<br>';
			}
			
			if (purchaseDate == undefined || $.trim(purchaseDate) == '') {
				msg += ' 采购日期不能为空；<br>';
			}
			
			if (purchaseNum == undefined || $.trim(purchaseNum) == ''){
				msg += ' 请选择采购数量或采购重量；<br>';
			}else{
				if(purchaseNum=="1"){
					$("#form-num").attr("name","purchaseAmount");
				}else{
					$("#form-num").attr("name","totalWeight");
				}
			}
			
			if (num == undefined || $.trim(num) == '') {
				msg += ' 采购数量/采购重量数值不能为空；<br>';
			}
			
			if (manufacturerDate == undefined || $.trim(manufacturerDate) == '') {
				msg += ' 产品生产日期不能为空；<br>';
			} 
			
			if (supplierName == undefined || $.trim(supplierName) == '') {
				msg += ' 请选择供应商；<br>';
			} 
			
			if (isReport != undefined && $.trim(isReport) == '1') {
				msg += ' 数据已经同步到溯源平台，不能修改；<br>';
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
	<script type="text/html" id="purchaseInputsTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="purchaseInputsForm" role="form">
			<input type="hidden" id="form-id" name="id">
			<input type="hidden" id="form-isReport" name="isReport">
			
			<div style="float:left;width:46%;text-align:center">
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseType">
						<i class="fa fa-asterisk fa-1 red"></i>
						采购类型
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-purchaseType" name="purchaseType" onchange="selectPurchaseChange()">
    					</select>
					</div>
				</div>
			
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-inputs">
						<i class="fa fa-asterisk fa-1 red"></i>
						投入品名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-pId" name="pId">
						<input type="hidden" id="form-name" name="name">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-inputs"  onchange="selectInputsChange()">
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						采购日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-purchaseDate" name="purchaseDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-6 control-label no-padding-right" for="form-purchaseAmount">
						<i class="fa fa-asterisk fa-1 red"></i>
						<input type="radio" name="purchaseNum" value="1">
						采购数量
						<input type="radio" name="purchaseNum" value="2">
						采购重量
					</label>
					<div class="col-sm-6">
						<input type="text" class="form-control" id="form-num" name="">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchasePrice">
						采购单价
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-purchasePrice" name="purchasePrice">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-purchaseUnit">
						采购单位
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-purchaseUnit" name="purchaseUnit">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerDate">
						<i class="fa fa-asterisk fa-1 red"></i>
						产品生产日期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-manufacturerDate" name="manufacturerDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-result">
						检验结果
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli"  id="form-result" name="result">
							<option value="">请选择</option>
							<option value="<%=Constants.PURCHASEINPUTS_RESULT_TYPE_UNPASS%>"><%=Constants.PURCHASEINPUTS_RESULT_TYPE_UNPASS_NAME%></option>
							<option value="<%=Constants.PURCHASEINPUTS_RESULT_TYPE_PASS%>"><%=Constants.PURCHASEINPUTS_RESULT_TYPE_PASS_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-supplier">
						<i class="fa fa-asterisk fa-1 red"></i>
						供应商名称
					</label>
					<div class="col-sm-8">
						<input type="hidden" id="form-supplierId" name="supplierId">
						<input type="hidden" id="form-supplierName" name="supplierName">
						<select class="form-control selectpicker bla bla bli" data-live-search="true"  id="form-supplier"  onchange="selectSupplierChange()">
    					</select>
					</div>
				</div>
				
			</div>
	
			<div style="float:left;width:46%;text-align:center">
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-upperReaches">
						上游是否建立电子台账
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-upperReaches" name="upperReaches">
    						<option value="">请选择</option>
							<option value="<%=Constants.UPPERREACHES_NO%>"><%=Constants.UPPERREACHES_NO_NAME%></option>
							<option value="<%=Constants.UPPERREACHES_YES%>"><%=Constants.UPPERREACHES_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-sourceType">
						来源类型
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-sourceType" name="sourceType">
    						<option value="">请选择</option>
							<option value="<%=Constants.SOURCE_TYPE_SELF_PURCHASE%>"><%=Constants.SOURCE_TYPE_SELF_PURCHASE_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_CULTIVATE%>"><%=Constants.SOURCE_TYPE_CULTIVATE_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_AUTOTROPHIC%>"><%=Constants.SOURCE_TYPE_AUTOTROPHIC_NAME%></option>
							<option value="<%=Constants.SOURCE_TYPE_WILD%>"><%=Constants.SOURCE_TYPE_WILD_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group" id="organicDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-organicFlag" id="organicLabel">
						是否有机
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli"  id="form-organicFlag" name="organicFlag">
    						<option value="">请选择</option>
							<option value="<%=Constants.ORGANIC_FLAG_NO%>"><%=Constants.ORGANIC_FLAG_NO_NAME%></option>
							<option value="<%=Constants.ORGANIC_FLAG_YES%>"><%=Constants.ORGANIC_FLAG_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group" id="transgenicDiv">
					<label class="col-sm-4 control-label no-padding-right" for="form-transgenicFlag">
						是否转基因
					</label>
					<div class="col-sm-8">
						<select class="form-control selectpicker bla bla bli" id="form-transgenicFlag" name="transgenicFlag">
    						<option value="">请选择</option>
							<option value="<%=Constants.TRANSGENIC_FLAG_NO%>"><%=Constants.TRANSGENIC_FLAG_NO_NAME%></option>
							<option value="<%=Constants.TRANSGENIC_FLAG_YES%>"><%=Constants.TRANSGENIC_FLAG_YES_NAME%></option>
    					</select>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalId">
						采购负责人代码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-principalId" name="principalId">
					</div>
				</div>
	
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-principalName">
						采购负责人姓名
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-principalName" name="principalName">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-periodDate">
						产品保质期
					</label>
					<div class="col-sm-8">
						<div class="input-group">
							<input class="form-control date-picker" id="form-periodDate" name="periodDate" 
								data-date-format="yyyy-mm-dd" readonly>
							<span class="input-group-addon">
								<i class="fa fa-calendar bigger-110"></i>
							</span>
						</div>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerId">
						生产商代码
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-manufacturerId" name="manufacturerId">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-manufacturerName">
						生产商名称
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-manufacturerName" name="manufacturerName">
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="license">
						生产经营许可证编号
					</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="form-license" name="license">
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
								<label>采购批次号</label>
								<input id=purchaseBatchId name="purchaseBatchId" class="specialForm-text">
							</td>
							<td>
								<label>投入品名称</label>
								<select id="pId" name="pId" class="specialForm-select">
								</select>
							</td>
							<td>
								<div style="float:left;font-size:14;line-height: 40px;">采购日期</div>
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
						<button id="addButton" class="btn btn-app btn-light btn-xs" onclick="addPurchaseInputs();">
							<i class="fa fa-plus"></i>
							新增
						</button>
						<button class="btn btn-app btn-light btn-xs" onclick="updatePurchaseInputs();">
							<i class="fa fa-pencil"></i>
							修改
						</button>
						<button id="exportButton" class="btn btn-app btn-light btn-xs" style="width: 90px;" onclick="exportPurchaseInputs();">
							<i class="fa fa-arrow-circle-right"></i>
							导出数据
						</button> 
					</span>
					
				</div>
				<table id="table"></table>
			</div>
		</div>
	</div>
</body>
</html>
