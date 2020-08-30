<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html lang="zh-cn">
<head>
	<title>人员授权</title>
	<%@include file="../head.jsp" %>
	<%@include file="../zTree.jsp" %>
	
	<script type="text/javascript">
		var treeObj;
		var setting = {
			check: {
				enable: true,
				chkStyle: "checkbox",
				chkboxType: { "Y" : "ps", "N" : "ps"  }
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			view: {
				showIcon:false,
				nameIsHTML:true,
				dblClickExpand: false,
				showLine: true
			},
			callback:{
				onClick: onClick
			}
		};
		
		//节点点击事件
		function onClick(e,treeId, treeNode) {
			if (treeNode.isParent) {
				treeObj.expandNode(treeNode);
			} else {
				treeObj.checkNode(treeNode, !treeNode.checked, null, true);
			}
		}
		
		$(function() {
			if ('${success}' == "false") {
				BootstrapDialog.alert('${errorMsg}');
				window.colse();
			} else {
				//生成区域树
				var data = eval('${userTree}');
				if (data != undefined && data.length > 0) {
					$.fn.zTree.init($("#treeDemo"), setting, data);
					treeObj = $.fn.zTree.getZTreeObj("treeDemo");
					treeObj.expandAll(true);
				}
			}
		});
		
		function sumbitRole() {
			var nodes = treeObj.getCheckedNodes(true);
			var nodeStr = '';
			if (nodes && nodes.length > 0) {
				for ( var i = 0; i < nodes.length; i++) {
					var node = nodes[i];
					if(node.isDefault != 1){		
						nodeStr += '@' + node.id;
					}
				}
				nodeStr = nodeStr.substring(1);
			}
			$("#nodeStr").val(nodeStr);
		}

	</script>
	<style>
		html,body{height:100%;background-color:white;}
		.nopadding{padding: 0;}
		.widget-main{padding: 5px;}
		.dd-list{cursor: pointer;}
	</style>
</head>
<body>
	<input type="hidden" id="nodeStr" name="nodeStr">
	<div class="container-fluid" style="margin-left:20px;">
		<div class="row">
			<div>
				<div>
					<div class="widget-body">
						<div class="widget-main">
							<div style="height: 100%;width: 100%;">
								<ul id="treeDemo" class="ztree"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>