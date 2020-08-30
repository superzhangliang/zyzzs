<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>商品管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../zTree.jsp" %>
	<link rel="stylesheet" href="${basepath}css/iconfont/iconfont.css" />
	<script src="${basepath}js/dist/template.js"></script>
	<script type="text/javascript">
		var treeObj, subMenu, winTitle, isParent;
		var goodsId, goodsCode, goodsName, goodsPid, op;

		//初始化
		$(function() {
			loadGoodsInfo();
		});
		
		//生成商品树
		function loadGoodsInfo(){
			$.ajax({
				url: "${basepath}goodsInfo/showGoods.do",
				type:"post",
				dataType:"json",
				success:function(data){
					if (data != undefined && data.length > 0) {
						$.fn.zTree.init($("#treeDemo"), setting, data);
						treeObj = $.fn.zTree.getZTreeObj("treeDemo");
						treeObj.expandAll(false);
					}else{
						addFirstNode();
					}
				}
			});
		}
		
		var setting = {
			data: {
				key: {
					title: "goodsName"
				},
				simpleData: {
					enable: true
				}
			},
			callback:{
				onClick: onClick,
				onRightClick: treeOnRightClick
			},
			view: {
				dblClickExpand: false,
				nameIsHTML: true,
				showIcon: false,
				selectedMulti: false,
				addHoverDom: addHoverDom,
				removeHoverDom: removeHoverDom
			}
		};
		
		function initData( treeNode ){
			isParent = treeNode.parentId==0?true:false;
			goodsCode = treeNode.goodsCode;
			goodsName = treeNode.goodsName;
			goodsPid = treeNode.parentId!=undefined?treeNode.parentId:0;
			goodsId = treeNode.id;
		}
		
		//当鼠标移动到节点上时，显示自定义控件(增删改上下移)
		function addHoverDom(treeId, treeNode) {
			initData(treeNode);
			//取消当前被选中节点的选中状态
			treeObj.cancelSelectedNode();
		
			var sObj = $("#" + treeNode.tId + "_span");
			
			//删除商品
			if (treeNode.editNameFlag || $("#deleteBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='deleteBtn_" + treeNode.tId
				+ "' title='删除商品' onfocus='this.blur();'><i class='fa fa-minus-circle'></i></span>";
			sObj.after(addStr);
			var btn = $("#deleteBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				deleNode();
				return false;
			});    
			
			//修改商品
			if (treeNode.editNameFlag || $("#editBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='editBtn_" + treeNode.tId
				+ "' title='修改商品' onfocus='this.blur();'><i class='fa fa-pencil'></i></span>";
			sObj.after(addStr);
			var btn = $("#editBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				editNode();
				return false;
			});  
			
			//添加下级商品
			if (treeNode.editNameFlag || $("#addChildBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='addChildBtn_" + treeNode.tId
				+ "' title='添加下级商品' onfocus='this.blur();'><i class='fa fa-plus-square'></i></span>";
			sObj.after(addStr);
			var btn = $("#addChildBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				addChildNode();
				return false;
			});  
			
			//添加同级商品
			if (treeNode.editNameFlag || $("#addBroBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='addBroBtn_" + treeNode.tId
				+ "' title='添加同级商品' onfocus='this.blur();' style='margin-left:10px;'><i class='fa fa-plus'></i></span>";
			sObj.after(addStr);
			var addBroBtn_ = $("#addBroBtn_"+treeNode.tId);
			if (addBroBtn_) addBroBtn_.bind("click", function(){
				addBrotherNode();
				return false;
			});
   
		};
		
		//当鼠标移出节点时，隐藏自定义控件(增删改上下移)
		function removeHoverDom(treeId, treeNode) {
			$("#addBroBtn_"+treeNode.tId).unbind().remove();
			$("#addChildBtn_"+treeNode.tId).unbind().remove();
			$("#editBtn_"+treeNode.tId).unbind().remove();
			$("#deleteBtn_"+treeNode.tId).unbind().remove();
		};
		
		//点击事件
		function onClick(e,treeId, treeNode) {
			initData(treeNode);
		}
		
		//右键事件
		function treeOnRightClick(event, treeId, treeNode) {
			initData(treeNode);
			
			var liLength = $("#subMenu .dropdown-menu li[class != 'divider']").length;
			var dividerLength = $("#subMenu .dropdown-menu li[class = 'divider']").length;
			var menuW = 24*liLength + 1*dividerLength + 10 + 10;
			var y=event.clientY;
			if( y > (window.innerHeight-menuW) ){
				y=window.innerHeight-menuW;
			}
			showMenu("node", event.clientX, y);
		}
		
		 //显示右键菜单
		function showMenu(type, x, y) {
		    $("#subMenu ul").show();
		    subMenu.css({"top": y + "px", "left": x + "px", "visibility": "visible"});
		    $("body").bind("mousedown", onBodyMouseDownSub);
		}
		
		function hideMenu() {
		    if (subMenu) subMenu.css({"visibility": "hidden"});
		    $("body").unbind("mousedown", onBodyMouseDownSub);
		}
		
		function onBodyMouseDownSub(event) {
		    if (!(event.target.id == "subMenu" || $(event.target).parents("#subMenu").length > 0)) {
		        subMenu.css({"visibility": "hidden"});
		    }
		}
		
		function addFirstNode() {
			op=0;
			winTitle = "<h5>快速添加一个商品</h5>";
			openWin();
		}
		
		function addBrotherNode() {
			op=1;
			winTitle = "<h5>添加【"+goodsName+"】的同级商品</h5>";
			openWin();
		}
		
		function addChildNode() {
			op=2;
			winTitle = "<h5>添加【"+goodsName+"】的下级商品</h5>";
			goodsPid=goodsId;
			openWin();
		}
		
		function editNode(){
			op=3;
			winTitle = "<h5>修改【"+goodsName+"】商品</h5>";
			openWin();
		}
		
		function openWin(){
			if(op==0){
				op=1;
				goodsPid=0;
			}
			
			BootstrapDialog.show({
	            title: winTitle,
	            message: template('goodsInfoTemple', {}),
	            size: BootstrapDialog.SIZE_NORMAL,
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
					//清空表单信息
					$("#goodsInfoForm")[0].reset();
					
					$("#op").val(op);
					$("#pid").val(goodsPid);
					
					if( op == 3){
						//回填数据
						$("#id").val(goodsId);
						$("#form-goodsName").val(goodsName);
						$("#form-goodsCode").val(goodsCode);
					}
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
							if (validateSql("goodsInfoForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}goodsInfo/editGoodsInfo.do",
									type: "post",
									data: $("#goodsInfoForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												loadGoodsInfo();
												dialog.close();
											}  else {
												$button.enable();//提交失败,提交按钮可用
											}
											BootstrapDialog.alert(data.msg);
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
		
		//删除商品
		function deleNode() {
			/* BootstrapDialog.confirm(goodsName+" 其商品下的所有商品将会被删除，是否继续？", function (yes) {
				if (yes) {
	           		$.ajax({
						url:"${basepath}goodsInfo/delGoodsInfo.do",
						type:"post",
						data:{id:goodsId},
						dataType:"json",
				      	success:function(data){
							if (data != undefined) {
						            title: '提示信息',  
						            message: data.msg,  
						            closable: true, 
						            draggable: true, 
						            buttonLabel: '确定',
						            callback: function(result) {  
						                if (data.success) {
											loadGoodsInfo();
										}
						            }  
						        });
							}
						}
				   }); 
				}
			}); */
		}
		
		function checkNotNull() {
			var msg = '';
			var goodsCode = $("#form-goodsCode").val();
			
			if (goodsCode == undefined || $.trim(goodsCode) == '') {
				msg += "商品编码不能为空！";
			}
			
			if (msg != '') {
				BootstrapDialog.alert(msg);
				return false;
			} else {
				return true;
			}
		}
		
	</script>
	
	<script id="goodsInfoTemple" type="text/html">
	<div id="menuMessage"  style="height:230px;">
		<form class="form-horizontal" id="goodsInfoForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="pid" name="pid">
			<input type="hidden" id="op" name="op">
			
			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-goodsCode">
					<i class="fa fa-asterisk fa-1 red"></i>
					商品编码
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-goodsCode" name="goodsCode">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-goodsName">
					商品名称
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-goodsName" name="goodsName">
				</div>
			</div>

		</form>
	</div>
	</script>
	
	<style>
		html,body{height:100%;background-color:white;}
        
        div#subMenu {
            position: absolute;
            visibility: hidden;
            top: 0;
            text-align: left;
            padding: 2px;
        }
 
        div#subMenu ul li {
            margin: 1px 0;
            padding: 0 5px;
            cursor: pointer;
            list-style: none outside none;
        }
        .ztree i {margin-right: 5px;}
	</style>
</head>
<body class="specialDialog">
	<div class="container-fluid" >
		<div class="row">
			<div class="col-xs-9 col-sm-10">
				<div style="width:98%; height:90%; float:left; border:none; overflow:auto;padding-left:50px;padding-top:10px;">
					<ul id="treeDemo" class="ztree"></ul>
				</div>
			</div>
			
        	<!-- 右键菜单 -->
        	<div id="subMenu">
	            <div class="dropdown">
	                <ul class="dropdown-menu">
	                    <li><a onclick="addBrotherNode()" ><i class="fa fa-plus"></i> 添加同级商品</a></li>
	                    <li><a onclick="addChildNode()" id="secondLi"><i class="fa fa-plus"></i> 添加下级商品</a></li>
	                    	<li class="divider"></li>
	                    <li><a onclick="editNode()"><i class="fa fa-pencil"></i> 修改商品</a></li>
	                    <li><a onclick="deleNode()"><i class="fa fa-minus-circle"></i> 删除商品</a></li>
	                </ul>
	            </div>
        	</div>
			
		</div>
	</div>
</body>
</html>
