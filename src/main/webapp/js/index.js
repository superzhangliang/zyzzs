//类型:0-图片新闻,1-新闻热点,2-通知公告,3-工作动态,4-政策法规,5-媒体宣传,6-知识普及, -1未定义
var types = new Array('tzgg', 'xwrd', 'gzdt', 'zspj', 'zcfg', 'mtxc');
var typeIds = new Array(2, 1, 3, 6, 4, 5);
var limits = new Array(6, 10, 9, 6, 6, 6);
function onLoad(){
	loadSliderDiv();//加载图片轮播
	loadWorkNews();//工作动态
	loadZMZContent(4);//政策法规
	loadZMZContent(5);//媒体宣传
	loadZMZContent(3);//知识普及
}

function getTypeStr(id){
	var array = new Array('tzgg', 'xwrd', 'gzdt', 'zspj', 'zcfg', 'mtxc');
	return array[id];
}

function loadWorkNews(){
	$('#work_btn').removeClass();
	$('#noti_btn').removeClass();
	$('#work_btn').addClass("div_btn working_on");
	$('#noti_btn').addClass("div_btn notification_off");
	loadWNContent(2);
}

function loadNotifications(){
	$('#work_btn').removeClass();
	$('#noti_btn').removeClass();
	$('#work_btn').addClass("div_btn working_off");
	$('#noti_btn').addClass("div_btn notification_on");
	loadWNContent(0);
}

//加载工作动态、通知公告
function loadWNContent(index){
	$.ajax({
		url: basePath + "news/selectNewsByType.do",
		type: "post",
		data:{'type' : typeIds[index], 'offset' : 1, 'limit' : 7},
		dataType: "json",
		success: function(data) {
			if(data.total == 0)
				return;
			
			var array = data.rows;
			var html = '';
			for(var i = 0; i < array.length; i++){
				var titleStr = array[i].title.length <= 14 ? array[i].title : array[i].title.substr(0, 14)+"...";
				var d = new Date(array[i].publishTime);
				var timeStr = (d.getMonth()+1)+'-'+d.getDate();
				html += '<tr>';
				html += '<td class="btn_class" title="' + array[i].title + '" onclick="openDetailPage(\'' + types[index] + '\',' + array[i].id + ')">';
				html += titleStr;
				html += '</td>';
				html += '<td>[' + timeStr + ']</td>';
				html += '</tr>';
			}
			$('#work_notification_table').html(html);
		}
	});
}

//加载政策法规、媒体宣传、知识普及
function loadZMZContent(index){
	$.ajax({
		url: basePath + "news/selectNewsByType.do",
		type: "post",
		data:{'type' : typeIds[index], 'offset' : 0, 'limit' : 7},
		dataType: "json",
		success: function(data) {
			if(data.total == 0)
				return;
			
			var array = data.rows;
			var limitWord = index == 3 ? 17 : 30;
			var html = '';
			for(var i = 0; i < array.length; i++){
				var titleStr = array[i].title.length <= limitWord ? array[i].title : array[i].title.substr(0, limitWord)+"...";
				html += '<li class="btn_class" title="' + array[i].title + '" onclick="openDetailPage(\'' + types[index] + '\',' + array[i].id + ')">';
				html += titleStr;
				html += '</li>';
			}
			$('#ul_' + types[index]).html(html);
		}
	});
}

function submitForm() {
	var res = verifyCode.validate($("#yzm").val());
	if(res){
		$("#loginForm").submit();
	}else{
		alert("验证码错误");
	}
	
}

function openPage(type){
	window.location.href = basePath +'jsp/contentPage.jsp?type='+type;
}

function openDetailPage(type, newsId){
	window.location.href = basePath + 'jsp/contentPage.jsp?type=' + type + '&newsId=' + newsId;
}

function loadSliderDiv(){
	$.ajax({
		url: basePath + "news/selectNewsByType.do",
		type: "post",
		data:{'type' : 0, 'offset' : 0, 'limit' : 5},
		dataType: "json",
		success: function(data) {
			if(data.total == 0)
				return;
			
			var array = data.rows;
			var html = '<ul>';
			var len = array.length < 3 ? array.length : 3;
			for(var i = 0; i < len; i++){
				var titleStr = array[i].title.length <= 15 ? array[i].title : array[i].title.substr(0, 15)+"...";
				html += '<li>';
				html += '<a href="javascript:openDetailPage(\'tpxw\',' + array[i].id + ')" >';
				html += '<img src="' + basePath + array[i].imgPath + '" alt="' + titleStr + '" />';
				html += '</a></li>';
			}
			html += '</ul>';
			$('.slider').html(html);
			
			$(".slider").YuxiSlider({
				width:390, //容器宽度
				height:288, //容器高度
				control:$('.control'), //绑定控制按钮
				during:3000, //间隔4秒自动滑动
				speed:800, //移动速度0.8秒
				mousewheel:true, //是否开启鼠标滚轮控制
				direkey:true //是否开启左右箭头方向控制
			});
		}
	});
}

function loadDiv(index, limit){
	$.ajax({
		url: basePath + "news/selectNewsByType.do",
		type: "post",
		data:{'type' : typeIds[index], 'offset' : 1, 'limit' : limit},
		dataType: "json",
		success: function(data) {
			if(data.total == 0)
				return;
			
			var array = data.rows;
			var html = '<table class="msgTb"><tbody>';
			for(var i = 0; i < array.length; i++){
				var titleStr = array[i].title.length <= 19 ? array[i].title : array[i].title.substr(0, 19)+"...";
				html += '<tr>';
				html += '<td class="left" title="' + array[i].title + '" onclick="openDetailPage(\'' + types[index] + '\',' + array[i].id + ')">';
				html += titleStr;
				html += '</td>';
				html += '</tr>';
				
			}
			html += '</tbody></table>';
			$('#' + types[index] + 'Div').html(html);
		}
	});
}