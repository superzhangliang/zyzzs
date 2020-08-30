
var tabSelect = $("#tabArea").tabSelecter(),
	basepath = window.basepath;
$(function(){
	addTabs({
		id:"tab-001",
		title:"首页",
		url: $("#basepath").val()+"jsp/homePage.jsp",
		close:false,
		toIndex:true
	});
});
function addTabs(options) {
	var defaults = {
			id: null,//id值
			title: "",//标签文本
			url:null,//地址
			close:true,//是否有关闭
			toIndex:true//设为当前页
	};
	var opts = $.extend(true,{},defaults,options);
	//参数意义: 1. id值; 2.分页标签内容; 3.加载页面地址; 4.是否设为当前页; 5.是否有关闭按钮
	tabSelect.newTab(opts.id,opts.title,opts.url,opts.toIndex,opts.close);
};
var closeTab = function(id) {
	tabSelect.close(id);
};
$(function() {
	/*var bodyH = $(document.body).height(),
		navH = $("#navbar").height();
	$("#main-content").height(bodyH-navH);
	$("#main-container").height(bodyH-navH).css({overflow:"hidden"});*/
	$("[addtabs]").click(function() {
		addTabs({
			id: $(this).attr("id"),
			title: $(this).attr('title'),
			close: true
		});
	});
	
});