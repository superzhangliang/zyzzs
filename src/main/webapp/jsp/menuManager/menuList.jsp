<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>菜单管理</title>
	<%@include file="../head.jsp" %>
	<%@include file="../zTree.jsp" %>
	<link rel="stylesheet" href="${basepath}css/iconfont_om/iconfont.css" />
	<script src="${basepath}js/dist/template.js"></script>
	<script type="text/javascript">
		var treeObj, subMenu, winTitle, isParent;
		var menuId, menuName, menuPid, menuUrl, orderNo, menuIcon, op, isDefault;

		//初始化
		$(function() {
			loadMenu();
			$("#menu1").html("菜单管理");
			$("#menu2").html("系统管理");
			height = window.innerHeight - 185;
			$("#content").height(height + "px");
		});
		
		//生成菜单树
		function loadMenu(){
			$.ajax({
				url: "${basepath}sysMenu/showMenu.do",
				type:"post",
				dataType:"json",
				success:function(data){
					if (data != undefined && data.length > 0) {
						$.fn.zTree.init($("#treeDemo"), setting, data);
						treeObj = $.fn.zTree.getZTreeObj("treeDemo");
						treeObj.expandAll(true);
						//subMenu = $("#subMenu"); 
					}else{
						addFirstNode();
					}
				}
			});
		}
		
		var setting = {
			data: {
				key: {
					title: "menuName"
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
			menuName = treeNode.menuName;
			menuUrl = treeNode.menuUrl;
			menuPid = treeNode.parentId!=undefined?treeNode.parentId:0;
			menuId = treeNode.id;
			orderNo = treeNode.orderNo;
			menuIcon = treeNode.menuIcon;
			isDefault = treeNode.isDefault;
		}
		
		//当鼠标移动到节点上时，显示自定义控件(增删改上下移)
		function addHoverDom(treeId, treeNode) {
			initData(treeNode);
			//取消当前被选中节点的选中状态
			treeObj.cancelSelectedNode();
		
			var sObj = $("#" + treeNode.tId + "_span");
			
			//菜单下移
			if (treeNode.editNameFlag || $("#downBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='downBtn_" + treeNode.tId
				+ "' title='菜单下移' onfocus='this.blur();'><i class='fa fa-arrow-down'></i></span>";
			sObj.after(addStr);
			var btn = $("#downBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				updateOrderNo(2);
				return false;
			});   
			
			//菜单上移
			if (treeNode.editNameFlag || $("#upBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='upBtn_" + treeNode.tId
				+ "' title='菜单上移' onfocus='this.blur();'><i class='fa fa-arrow-up'></i></span>";
			sObj.after(addStr);
			var btn = $("#upBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				updateOrderNo(1);
				return false;
			});  
			
			//删除菜单
			if (treeNode.editNameFlag || $("#deleteBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='deleteBtn_" + treeNode.tId
				+ "' title='删除菜单' onfocus='this.blur();'><i class='fa fa-minus-circle'></i></span>";
			sObj.after(addStr);
			var btn = $("#deleteBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				deleNode();
				return false;
			});    
			
			//修改菜单
			if (treeNode.editNameFlag || $("#editBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='editBtn_" + treeNode.tId
				+ "' title='修改菜单' onfocus='this.blur();'><i class='fa fa-pencil'></i></span>";
			sObj.after(addStr);
			var btn = $("#editBtn_"+treeNode.tId);
			if (btn) btn.bind("click", function(){
				editNode();
				return false;
			});  
			
			//二级菜单不可添加下级菜单
			if( isParent ){
				//添加下级菜单
				if (treeNode.editNameFlag || $("#addChildBtn_"+treeNode.tId).length>0) return;
				var addStr = "<span id='addChildBtn_" + treeNode.tId
					+ "' title='添加下级菜单' onfocus='this.blur();'><i class='fa fa-plus-square'></i></span>";
				sObj.after(addStr);
				var btn = $("#addChildBtn_"+treeNode.tId);
				if (btn) btn.bind("click", function(){
					addChildNode();
					return false;
				});  
			}
			
			//添加同级菜单
			if (treeNode.editNameFlag || $("#addBroBtn_"+treeNode.tId).length>0) return;
			var addStr = "<span id='addBroBtn_" + treeNode.tId
				+ "' title='添加同级菜单' onfocus='this.blur();' style='margin-left:10px;'><i class='fa fa-plus'></i></span>";
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
			//二级菜单不可添加下级菜单
			if( isParent ){
				$("#addChildBtn_"+treeNode.tId).unbind().remove();
			}
			$("#editBtn_"+treeNode.tId).unbind().remove();
			$("#deleteBtn_"+treeNode.tId).unbind().remove();
			$("#upBtn_"+treeNode.tId).unbind().remove();
			$("#downBtn_"+treeNode.tId).unbind().remove();
		};
		
		//点击事件
		function onClick(e,treeId, treeNode) {
			initData(treeNode);
		}
		
		//右键事件
		function treeOnRightClick(event, treeId, treeNode) {
			initData(treeNode);
			
			if( !isParent ){
				$("#secondLi").attr("style","display:none;");
			}else{
				$("#secondLi").attr("style","display:;");
			}
			
			var liLength = $("#subMenu .dropdown-menu li[class != 'divider']").length;
			var dividerLength = $("#subMenu .dropdown-menu li[class = 'divider']").length;
			var menuW = 24*liLength + 1*dividerLength + 10 + 10;//右键菜单高度 = 单条菜单高度*菜单数 + 隔断线高度*隔断线条数 + 上边距 + 下边距
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
			winTitle = "<h5>快速添加一个菜单</h5>";
			openWin();
		}
		
		function addBrotherNode() {
			op=1;
			winTitle = "<h5>添加【"+menuName+"】的同级菜单</h5>";
			openWin();
		}
		
		function addChildNode() {
			op=2;
			winTitle = "<h5>添加【"+menuName+"】的下级菜单</h5>";
			menuPid=menuId;
			openWin();
		}
		
		function editNode(){
			op=3;
			winTitle = "<h5>修改【"+menuName+"】菜单</h5>";
			openWin();
		}
		
		function openWin(){
			if(op==0){
				op=1;
				menuPid=0;
			}
			
			BootstrapDialog.show({
	            title: winTitle,
	            message: template('menuTemple', {}),
	            size: BootstrapDialog.SIZE_NORMAL,
	            nl2br: false,
	            closeByBackdrop: false,
	            draggable: true,
	            onshown: function(dialog) {
					//隐藏提示信息
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					//清空表单信息
					$("#menuForm")[0].reset();
					
					/* $("#pid").val(menuPid); */
					$("#op").val(op);
					
					if( op == 1 || op == 3 ){//添加同级或者修改菜单时
						if( isParent ){//父菜单不显示“父菜单”下拉框
							$("#pIdTr").attr("style","display:none;");
						}else{
							$("#pIdTr").attr("style","display:;");
							setPMenu(menuPid);
						}
					}else{//添加下级
						$("#pIdTr").attr("style","display:;");
						setPMenu(menuPid);
					}
					
					if( op == 3){
						//回填数据
						$("#id").val(menuId);
						$("#form-name").val(menuName);
						$("#form-url").val(menuUrl);
						$("#form-icon").val(menuIcon);
						changeIcon();
						
						if( isDefault == 1 ){
							$("#form-isDefault").attr("checked","checked");
						}
						
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
						$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
						if (checkNotNull()) {
							if (validateSql("menuForm", 1)) {
					    		BootstrapDialog.alert(sqlErrorTips);
					    		$button.enable();//验证失败,提交按钮可用
					    	} else {
					    		$.ajax({
									url: "${basepath}sysMenu/editMenu.do",
									type: "post",
									data: $("#menuForm").serialize(),
									dataType:"json",
									success:function(data){
										if (data != undefined) {
											if (data.success) {
												$("#msgDiv").addClass("alert-success");
												loadMenu();
												dialog.close();
											}  else {
												$("#msgDiv").addClass("alert-danger");
												$button.enable();//提交失败,提交按钮可用
											}
											$("#msgDiv").removeClass("hide");
											$("#returnMsg").html(data.msg);
										}
									},
									error: function() {
										$("#msgDiv").addClass("alert-danger").removeClass("hide");
										$("#returnMsg").html("提交异常");
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
		
		//删除菜单
		function deleNode() {
			BootstrapDialog.confirm(menuName+" 其菜单下的所有菜单将会被删除，是否继续？", function (yes) {
				if (yes) {
	           		$.ajax({
						url:"${basepath}sysMenu/delMenu.do",
						type:"post",
						data:{id:menuId},
						dataType:"json",
				      	success:function(data){
							if (data != undefined) {
								BootstrapDialog.alert(data.msg);
								if (data.success) {
									loadMenu();
								}
							}
						}
				   }); 
				}
			});
		}
		
		//菜单上下移，1-上移，2-下移
		function updateOrderNo( flag ){
			if( flag == 1 ){//上移
				if(orderNo-1 <= 0){
					BootstrapDialog.alert("菜单已经在最顶部！");
					return;
				}
			}else{//下移
				var maxOrderNo = 0;
				$.ajax({
					url:"${basepath}sysMenu/getMaxOrderNo.do",
					type:"post",
					async:false, 
					data:{
						"nodePid":menuPid
					},
					dataType:"json",
					success:function(data){
						// 获取同级菜单最大OrderNo
						maxOrderNo=data.maxOrderNo;
					}
				});
		
				if(orderNo + 1 > maxOrderNo){
					BootstrapDialog.alert("菜单已经在最底部！");
					return;
				}
			}
			
			$.ajax({
				url:"${basepath}sysMenu/updateOrderNo.do",
				type:"post",
				data:{
					"orderNo":orderNo,
					"menuId":menuId,
					"menuPid":menuPid,
					"flag":flag
				},
				dataType:"json",
				success:function(data){
					if(data.success){
						loadMenu();				
					}else{
						BootstrapDialog.alert(data.msg);
					}
				}
			});
		}
		
		function checkNotNull() {
			var msg = '';
			if( $("#form-isDefault").attr("checked") == 'checked' ){
				$("#form-isDefault").val(1);
			}else{
				$("#form-isDefault").val(0);
			}
			var name = $("#form-name").val();
			if (name == undefined || $.trim(name) == '') {
				msg += "菜单名称不能为空！";
			}
			
			if (msg != '') {
				$("#msgDiv").addClass("alert-danger").removeClass("hide");
				$("#returnMsg").html(msg);
				return false;
			} else {
				return true;
			}
		}
		
		function changeIcon() {
			var className = $("#form-icon").val();
			$("#showIcon").attr("class", className);
		}    
		  
		//填充父菜单下拉框
		function setPMenu(pid) {
			$.ajax({
				url:"${basepath}sysMenu/getPMenu.do",
				type:"post",
				dataType:"json",
				success:function(data){
					if (data && data.length > 0) {
						var ops = '';
						for (var i = 0; i < data.length; i++) {
							ops += '<option value="' + data[i].id + '">' + data[i].name + '</option>';
						}
						$("#form-pid").append(ops);
						if (pid != undefined && pid != 0) {
							$("#form-pid").val(pid);
						}
					}
				}
			});
		}
		 
	</script>
	
	<script id="menuTemple" type="text/html">
	<div id="menuMessage"  style="height:230px;">
		<div class="alert alert-block hide" id="msgDiv">
			<strong id="returnMsg"></strong>
		</div>
		<form class="form-horizontal" id="menuForm" role="form">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="op" name="op">
			
			<div class="form-group" id="pIdTr">
				<label class="col-sm-3 control-label no-padding-right" for="form-pid">
					父菜单
				</label>
				<div class="col-sm-6">
					<select id="form-pid" name="pid" class="form-control" >
						<option value="0">无</option>
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-name">
					<i class="fa fa-asterisk fa-1 red"></i>
					菜单名称
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-name" name="name">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-url">
					菜单链接
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-url" name="url">
				</div>
			</div>

			<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-icon">
					图标样式
				</label>
				<div class="col-sm-6">
					<input type="text" class="form-control" id="form-icon" name="icon"  onchange="changeIcon();">
				</div>
				<div class="col-sm-0">
					<label class="col-sm-0 control-label no-padding-right">
						<i class="" id="showIcon"></i>
					</label>
				</div>
			</div>

			<!--<div class="form-group">
				<label class="col-sm-3 control-label no-padding-right" for="form-isDefault">
					代理商默认
				</label>
				<div class="col-sm-6  control-label" style="text-align:left;">
					<input type="checkbox" id="form-isDefault" name="isDefault">
				</div>
			</div>-->

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
	<%-- <jsp:include page="../menuHead.jsp"></jsp:include> --%>
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
	                    <li><a onclick="addBrotherNode()" ><i class="fa fa-plus"></i> 添加同级菜单</a></li>
	                    <li><a onclick="addChildNode()" id="secondLi"><i class="fa fa-plus"></i> 添加下级菜单</a></li>
	                    	<li class="divider"></li>
	                    <li><a onclick="editNode()"><i class="fa fa-pencil"></i> 修改菜单</a></li>
	                    <li><a onclick="deleNode()"><i class="fa fa-minus-circle"></i> 删除菜单</a></li>
	                    <li><a onclick="updateOrderNo(1)"><i class="fa fa-arrow-up"></i> 菜单上移</a></li>
	                    <li><a onclick="updateOrderNo(2)"><i class="fa fa-arrow-down"></i> 菜单下移</a></li>          
	                </ul>
	            </div>
        	</div>
			
		</div>
	</div>
</body>
</html>
