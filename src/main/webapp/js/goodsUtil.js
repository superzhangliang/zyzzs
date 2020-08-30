var goodsNameTxt='', data1 = [];

//初始化商品信息下拉框
function initGoodsInfoView(){
	loadAllGoods();
	
	$("#form-goodsName").on('keypress',function(event){ 
    	if(event.keyCode == 13){  
    		//模糊查询
    		goodsNameTxt = encodeURI(encodeURI($("#form-goodsName").val().trim()));
			loadAllGoods();  
			loadGoodsInfoView();
		}  
	});
	
	$("#form-goodsName").mousedown(function(){
		loadGoodsInfoView();
	});
	
	$("#form-goodsName").blur(function(){
		$("#treeview").hide();
    });
}

//加载商品列表
function loadAllGoods(){
	$.ajax({
		url: basepath + 'goodsInfo/getGoodsTree.do?name='+goodsNameTxt,
		type:'post',
		dataType:'json',
		async:false, 
		success:function(data){
			data1 = eval(data.rows);
		},
		error : function() {
			alert('操作失败！');
		}
	}); 
}

//加载商品树下拉框
function loadGoodsInfoView(){
	$("#treeview").show();
	var options = {
		bootstrap2 : false,
		levels : 1,
		showCheckbox : false,
		checkedIcon : "glyphicon glyphicon-check",
		data : buildDomTree(),
		onNodeSelected : function(event, data) {
			$("#form-goodsName").val(data.text);
			$("#form-goodsCode").val(data.code);
			$("#form-goodsId").val(data.id);
			$("#treeview").hide();
		}
	};

	$('#treeview').treeview(options);
}

function buildDomTree() {
	var data = [];
	var root = "所有分类";
	function walk(nodes, data) {
		if (!nodes) {
			return;
		}
		for( var i=0;i<nodes.length;i++ ){
			var node = nodes[i];
			var obj = {
				id : node.id,
				text : node.name != null ? node.name : root,
				code: node.code
			};
			if (node.isLeaf == true) {
				obj.nodes = [];
				walk(node.children, obj.nodes);
			}
			data.push(obj);
		}
	}

	walk(data1, data);
	return data;
}