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
		#saveBtn {width: 90px; background-color: #428bca !important;; color: #fff !important;;}
		#saveBtn:HOVER {background-color: #1b6aaa !important;}
		.tip-red {color: #dd3333; height: 35px; line-height: 30px; font-size:14px;}
	</style>
	<script type="text/javascript">
		
		var listBatchInfo,listHarvestInfo, LODOP, printContent;
		var type = '${node.type}';
		
		$(function() {
			
			$('.date-picker').datepicker({
				autoclose: true,
				todayHighlight: true,
				language: 'cn'
			});
			$("#form-outDate").datepicker("setDate",new Date());
			getProdBatchInfoList();
			fullProdBatchInfo('');
			
			getHarvestBatchInfoList('');
			fullHarvestBatchInfo();
			
			getBuyerList();
			fullBuyer();
			
			var htmlDiv = '';
			if(type == '1') {
				htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 动物产地检疫合格证号或检测合格证号';
			}else if(type == '2') {
				htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号';
				$("#form-qty").val(1);
				$("#qtyDiv").attr("style","display:none"); 
			}else {
				htmlDiv = '<i class="fa fa-asterisk fa-1 red"></i> 产地证明号或检测合格证号或动物产地检疫合格证号';
			} 
			$("#quarantineIdDiv").html(htmlDiv);
			
			$("#traceCodeDiv").css("display","none");
			
		});
		
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
		function fullProdBatchInfo(prodBatchId){
			if(prodBatchId==undefined||prodBatchId==null){
				prodBatchId = '';
			}
	  		$("#form-prodBatch").find("option").remove(); 
	  		var ops='';
				ops += '<option value="">请选择</option>';
	  		if (listBatchInfo && listBatchInfo.length > 0) {
				
				for (var i = 0; i < listBatchInfo.length; i++) {
					
					ops += '<option value="' + listBatchInfo[i].prodId + '@'+(listBatchInfo[i].prodName == undefined ? '' : listBatchInfo[i].prodName )
					+'@'+ listBatchInfo[i].prodBatchId + '"';
					if(prodBatchId==listBatchInfo[i].prodBatchId){
						ops += ' selected';
					}
					ops += ' >' + listBatchInfo[i].prodBatchId + '('+listBatchInfo[i].prodName+')' + '</option>';
				}
				
			}
			$("#form-prodBatch").append(ops);
			if(ops!=''){
				$("#form-prodBatch").selectpicker({
	                'selectedText': 'cat'
	            });
			
				var formOutInfo = $("#form-prodBatch").val().split("@");
		  		$("#form-prodId").val(formOutInfo[0]);
		  		$("#form-prodName").val(formOutInfo[1]);
		  		$("#form-prodBatchId").val(formOutInfo[2]);
			}
            
		  	//刷新插件
			$("#form-prodBatch").selectpicker('refresh'); 
	  	}
	  	
	  	//种养殖批次号下拉框改变事件
	  	function selectProdBatchIdChange(){
	  		var formOutInfo = $("#form-prodBatch").val().split("@");
	  		
	  		$("#form-prodId").val(formOutInfo[0]);
	  		$("#form-prodName").val(formOutInfo[1]);
	  		$("#form-prodBatchId").val(formOutInfo[2]);
	  		
	  		if(formOutInfo[2]==undefined||formOutInfo[2]==''){
	  			getProdBatchInfoList();
				fullProdBatchInfo('');
				
				getHarvestBatchInfoList('');
				fullHarvestBatchInfo();
	  		}else{
	  			getHarvestBatchInfoList(formOutInfo[2]);
	  			fullHarvestBatchInfo();
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
		function fullHarvestBatchInfo(){
	  		$("#form-harvestBatch").find("option").remove(); 
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listHarvestInfo && listHarvestInfo.length > 0) {
				
				for (var i = 0; i < listHarvestInfo.length; i++) {
					
					ops += '<option value="' + listHarvestInfo[i].harvestBatchId + '@'+ listHarvestInfo[i].prodBatchId+'"';
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
	  		
  			fullProdBatchInfo(formHarvestInfo[1]);
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
		function fullBuyer(){
	  		$("#form-buyer").find("option").remove(); 
	  		var ops;
				ops += '<option value="">请选择</option>';
	  		if (listBuyer && listBuyer.length > 0) {
				ops += '<option value="@散客">散客</option>';
				for (var i = 0; i < listBuyer.length; i++) {
					
					ops += '<option value="' + listBuyer[i].id + '@'+ listBuyer[i].name+'"';
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
		
		//保存交易信息
		function saveOutInfo(isPrint) {
			if(<%=type==-1%>) {
				$("#tip").html("超级管理员不能进行此操作");
				$(".save1,.save2").prop("disabled", true);
				return;
			}
			$("#saveBtn").prop("disabled", true);
			if (checkNotNull()) {
				if (validateSql("outInfoForm", 1)) {
		    		BootstrapDialog.alert(sqlErrorTips);
		    		$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
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
									$.ajax({
										url: "${basepath}originOutInfo/synToSY.do",
										type: "post",
										data: {outInfoId: data.id},
										dataType:"json",
										success:function(data){
										}
									}); 
									printContent = data.printContent;
									if( printContent!=undefined && printContent!='' ){
										prnPreview(printContent);
									} 
									
									resetForm();
								} else {
									BootstrapDialog.alert(data.msg);
								}
								$("#saveBtn").prop("disabled", false);
							}
						},
						error: function(e) {
							BootstrapDialog.alert("提交异常");
							$("#saveBtn").prop("disabled", false);//提交失败,提交按钮可用
						}
					});
		    	}
			} else {
				$("#saveBtn").prop("disabled", false);//验证失败,提交按钮可用
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
        
        function resetForm(){
			$("#outInfoForm")[0].reset();
			$("#form-outDate").datepicker("setDate",new Date());
			getProdBatchInfoList();
			fullProdBatchInfo('');
			
			getHarvestBatchInfoList('');
			fullHarvestBatchInfo();
			
			getBuyerList();
			fullBuyer();
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
	<input type="hidden" id="basepath" value="${basepath}" />
	<div style="height:100%;width: 100%;padding: 10px 0 10px;overflow-x:hidden;overflow-y: auto;">
		
		<form class="form-horizontal" id="outInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			
			<div style="float:left;width:46%;text-align:center">
				<div class="form-group">
					<label class="col-sm-4 control-label no-padding-right" for="form-prodBatch">
						<i class="fa fa-asterisk fa-1 red"></i>
						<%=title%>批次号
					</label>
					<div class="col-sm-8">
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
					<div class="col-sm-8">
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
			
			<div style="float:left;width:100%;text-align:center">
				<div class="tip-red" id="tip"></div>
				<div class="form-group">
					<div class="col-sm-12">
						<button class="btn save1" id="saveBtn" onclick="saveOutInfo(<%=Constants.PRINT_NO%>);return false;">确定不打印</button>
						<button class="btn save2" id="saveBtn" onclick="saveOutInfo(<%=Constants.PRINT_YES%>);return false;">确定并打印</button>
					</div>
				</div>
			</div>

		</form>
	</div>
</body>
</html>
