<%@ page language="java" import="java.util.*,com.gdcy.zyzzs.util.Constants" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%@include file="../head.jsp" %>
<%@include file="../table.jsp"%>
<script src="${basepath}js/dist/template.js"></script>
<link href="${basepath}js/assets/css/datepicker.css" rel="stylesheet">
<script src="${basepath}js/assets/js/date-time/bootstrap-datepicker.min.js"></script>

<link href="${basepath}js/bootstrap-treeview-master/bootstrap-treeview.css" rel="stylesheet">
<script src="${basepath}js/bootstrap-treeview-master/bootstrap-treeview.js"></script>

<script src="${basepath}/js/goodsUtil.js"></script> 

<script type="text/javascript" src="${basepath}/js/jquery.ocupload-1.1.2.js"></script>
<style type="text/css">
table tr td { padding: 2px;};
.form-horizontal .form-group {
    margin-top: 21px;
}

</style>
<script type="text/javascript">
	function refresh() {
		search();
	}
	var table1, table2, selectRowId1, selectRowId2;
	var grid1;
	var grid2;
	var searchH;
	var temp;
	var mark = 0;
	var gridH;
	var navH;
	
	$(function() {
			
		//计算表高度
		var bodyH = parseInt( $(document.body).innerHeight() ),temp = 25;
		searchH = parseInt( $(".searchDiv").outerHeight() );
		navH = parseInt( $(".nav.nav-tabs").outerHeight() );
		gridH = bodyH - searchH - temp-navH;
			
		$("#tabId a:first").tab('show');//初始化显示哪个tab
		$("#tabId a").click(function (e) {
		  e.preventDefault();
		  $(this).tab('show');
		  if($(this).attr("class")=="using"){
			loadGrid1(gridH);
			search();
		  }else{
			loadGrid2(gridH);
			search();
		  }
		});			
		loadGrid1(gridH);
	});
	
	function loadGrid1(gridH) {
		table1 = $("#grid1");
		table1.bootstrapTable({
			url: "${basepath}prodManager/getProdManager.do?isDelete=0",
			columns: [{
				field: "name",
				title: "商品名称",
				align: "center",
				valign: "middle"					
			},{
				field: "goodsCode",
				title: "国标商品编码",
				align: "center",
				valign: "middle"					
			},{
				field: "goodsName",
				title: "国标商品名称",
				align: "center",
				valign: "middle"					
			}],
			pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar1',
			method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id'
		});
		
		/* 监听窗口改变,重设高度值 */
		window.onresize = function(){
			table1.bootstrapTable("resetView",{height:gridH});
		};
		
		//绑定选中行事件
		table1.on('click-row.bs.table', function (e, row, $element) {
			$('.success').removeClass('success');
			$($element).addClass('success');
			selectRowId1 = row.id;
		});
		
	}
	
	function loadGrid2(gridH) {
		table2 = $("#grid2");
		table2.bootstrapTable({
			url: "${basepath}prodManager/getProdManager.do?isDelete=1",
			columns: [ {
				field: "name",
				title: "商品名称",
				align: "center",
				valign: "middle"					
			},{
				field: "goodsCode",
				title: "国标商品编码",
				align: "center",
				valign: "middle",
			}, {
				field: "goodsName",
				title: "国标商品名称",
				align: "center",
				valign: "middle",
			}],
			pagination: true, striped: true, sidePagination: "server",height:gridH,toolbar: '#toolbar2',
			method: "post", contentType: "application/x-www-form-urlencoded", uniqueId: 'id'
		});
		
		/* 监听窗口改变,重设高度值 */
		window.onresize = function(){
			table2.bootstrapTable("resetView",{height:gridH});
		};
		
		//绑定选中行事件
		table2.on('click-row.bs.table', function (e, row, $element) {
			$('.success').removeClass('success');
			$($element).addClass('success');
			selectRowId2 = row.id;
		});
	}
	
	
	//搜索
	function search() {
		if (validateSql("name", 2)) {
	    	BootstrapDialog.alert(sqlErrorTips);
	    } else {
	    	selectRowId1 = undefined;
			selectRowId2 = undefined;
			var name = $("#name").val();
			var pageSize = 10;
			if ($(".page-size") && $(".page-size").html() != '') {
				pageSize = $(".page-size").html();
			}
			$("#grid1").bootstrapTable(
				'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
					return $.extend({},params,{"name": name});
				}}
			);
			
			$("#grid2").bootstrapTable(
				'refreshOptions', {pageNumber: 1, pageSize: pageSize, queryParams: function (params) {
					return $.extend({},params,{"name": name});
				}}
			);
	    }
	}
	
	function clearSearch(){
		$("#name").val("");
		
		search();
	}
	
	function addProdManager() {
		//显示对话框
		BootstrapDialog.show({
            title: "<h5>新增商品</h5>",
            message: template('prodManagerTemple', {}),
            nl2br: false,
            closeByBackdrop: false,
            draggable: true,
            onshown: function(dialog) {
				//清空表单信息
				$("#prodManagerForm")[0].reset();
				//初始化商品树
				initGoodsInfoView();
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
						if (validateSql("prodManagerForm", 1)) {
				    		BootstrapDialog.alert(sqlErrorTips);
				    		$button.enable();//验证失败,提交按钮可用
				    	} else {
				    		$.ajax({
								url: "${basepath}prodManager/editProdManager.do",
								type: "post",
								data: $("#prodManagerForm").serialize(),
								dataType:"json",
								success:function(data){
									if (data != undefined) {
										if (data.success) {
											search();
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

	function updateProdManager(){
		if (selectRowId1 == undefined || selectRowId1 == '') {
			BootstrapDialog.alert("请先选中需要修改的商品！");
			return;
		}
		var row = table1.bootstrapTable('getRowByUniqueId', selectRowId1);
	
		//显示对话框
		BootstrapDialog.show({
            title: "<h5>修改商品：<span class='orange2'>" + row.name + "</span></h5>",
            message: template('prodManagerTemple', {}),
            nl2br: false,
            closeByBackdrop: false,
            draggable: true,
            onshown: function(dialog) {
				//清空表单信息
				$("#prodManagerForm")[0].reset();
				//初始化表单数据
				$("#id").val(row.id);
				$("#form-name").val(row.name);
				$("#form-goodsName").val(row.goodsName);
				$("#form-goodsCode").val(row.goodsCode);
				//初始化商品树
				initGoodsInfoView();
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
						if (validateSql("prodManagerForm", 1)) {
				    		BootstrapDialog.alert(sqlErrorTips);
				    		$button.enable();//验证失败,提交按钮可用
				    	} else {
				    		$.ajax({
								url: "${basepath}prodManager/editProdManager.do",
								type: "post",
								data: $("#prodManagerForm").serialize(),
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
	
	function deleteProdManager(){
		if (selectRowId1 == undefined || selectRowId1 == '') {
			BootstrapDialog.alert("请先选中需要停用的商品！");
			return;
		}
		var row = table1.bootstrapTable('getRowByUniqueId', selectRowId1);
		BootstrapDialog.confirm("确认停用\"" + row.name + "\"?", function (yes) {
			if (yes) {
				$.ajax({
					url: "${basepath}prodManager/deleteProdManager.do",
					type: "post",
					data: {prodManagerId : row.id},
					dataType:"json",
					success:function(data){
						if (data != undefined) {
							BootstrapDialog.alert(data.msg);
							search();
						}else{
							BootstrapDialog.alert("停用失败！");
							search();
						}
					}
				});
			}
		});
	}
	
	//恢复商品
	function recoveryProdManager(){
		if (selectRowId2 == undefined || selectRowId2 == '') {
			BootstrapDialog.alert("请选择行！");
			return;
		} else {
			var row = table2.bootstrapTable('getRowByUniqueId', selectRowId2);
			BootstrapDialog.confirm("确认恢复<font color='red'>" + row.name + "？<br />",function (yes) {
				if (yes) {
					$.ajax({
						url: "${basepath}prodManager/editProdManager.do",
						type: "post",
						data: {id: row.id, isDelete:0},
						dataType:"json",
						success:function(data){
							if(data.success) {
								BootstrapDialog.alert(data.msg);
								search();
							}else {
								BootstrapDialog.alert(data.msg);
								search();
							}
						}
					});
				}
			});
		}
	}
	
	function checkNotNull() {
		var msg = '';
		
		var goodsName=$("#form-goodsName").val();
		if(goodsName == undefined || $.trim(goodsName) == ''){
			msg += ' 国际商品名称不能为空；<br/>';
		}
		
		var name=$("#form-name").val();
		if(name == undefined || $.trim(name) == ''){
			msg += ' 商品名称不能为空；<br/>';
		}
		
		if (msg != '') {
			BootstrapDialog.alert(msg);
			return false;
		} else {
			return true;
		}
	}		

	
</script>
<script type="text/html" id="prodManagerTemple">
	<div style="height:200px;">
		<form class="form-horizontal" id="prodManagerForm" role="form">
			<input type="hidden" id="id" name="id">

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-goods">
					<i class="fa fa-asterisk fa-1 red"></i>
					国际商品名称
				</label>
				<div class="col-sm-8">
					<input type="hidden" id="form-goodsId" name="goodsId">
	    			<input type="text" id="form-goodsName" name="goodsName" class="form-control" value=""  autocomplete="off">  
                    <div id="treeview" style="display:none;text-align:left;height:200px;overflow:auto;position:absolute;left:12;top:34;z-index:9999;"></div>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-goodsCode">
					<i class="fa fa-asterisk fa-1 red"></i>
					国际商品编码
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-goodsCode" name="goodsCode" placeholder="" readOnly>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					商品名称
				</label>
				<div class="col-sm-8">
					<input type="text" class="form-control" id="form-name" name="name" placeholder="">
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
				<div class="searchDiv" style="padding: 8px 15px;">
					<table>
						<tr>
							<td>
								<label>商品名称</label>
								<input id="name" name="name" class="specialForm-text" style="width:130px;">
							</td>
							<td>
								<button onclick="search();"  style="margin-left:30px;" class="btn btn-app btn-light btn-xs" >搜索</button>
								<button onclick="clearSearch();"  style="margin-left:5px;" class="btn btn-app btn-light btn-xs" >清空</button>
							</td>
						</tr>
					</table>
				</div>
				
				<ul id="tabId" class="nav nav-tabs" style="margin-top: 5px; height:40px;">
				   <li class="active">
				      <a href="#tab1" data-toggle="tab" class="using">
				         	在用商品
				      </a>
				   </li>
				   <li>
				      <a href="#tab2" data-toggle="tab" class="unused">
				         	停用商品
				      </a>
				   </li>
				</ul>

				<div class="tab-content">  
				    <div class="tab-pane active" id="tab1">
						<div id="toolbar1">
							<span id="onUseBtns">
								<button class="btn btn-app btn-light btn-xs" onclick="addProdManager();">
								<i class="fa fa-plus"></i>
								新增
							</button>
							<button class="btn btn-app btn-light btn-xs" onclick="updateProdManager();">
								<i class="fa fa-pencil"></i>
								修改
							</button>
							<button class="btn btn-app btn-light btn-xs" onclick="deleteProdManager();">
								<i class="fa fa-trash-o"></i>
								停用
							</button>
							</span>
						</div>
						<table id="grid1"></table>
				    </div>
				     
				    <div class="tab-pane" id="tab2">
						<div id="toolbar2">
							<span id="onUseBtns">
								<button class="btn btn-app btn-light btn-xs btnWidth" onclick="recoveryProdManager();">
									<i class="fa fa-tasks"></i>
									恢复使用
								</button>
							</span>
						</div>
						<table id="grid2"></table>
				    </div>  
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>
