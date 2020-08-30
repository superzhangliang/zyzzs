<link href="${basepath}js/dist/bootstrap-table.css" rel="stylesheet">
<script src="${basepath}js/dist/bootstrap-table.js" ></script>
<script src="${basepath}js/dist/extensions/export/bootstrap-table-export.js" ></script>
<script src="${basepath}js/dist/extensions/export/tableExport.js" ></script>
<script src="${basepath}js/dist/locale/bootstrap-table-zh-CN.min.js" ></script>
<style>
	.searchDiv{width: 100%;line-height: 40px;vertical-align: middle;}
	.searchDiv input{height: 30px;}
	.searchDiv button{line-height: 30px;}
	.btn.btn-app.btn-light{padding: 3px;}
	.btn.btn-app.btn-light.btnWidth{width: 94px;}
</style>
<script type="text/javascript">
	function setHeight(){
		var h = parent.$("#content").height();
		var tableH = 820;
		var temp = 41;
		if(tableH < h){
			parent.$("#content").height(tableH + "px");
			parent.$("#sidebar").height(tableH + temp + "px");
		}else{
			parent.$("#content").height(window.innerHeight + "px");
			parent.$("#sidebar").height(window.innerHeight + temp + "px");
		}
	}			
</script>