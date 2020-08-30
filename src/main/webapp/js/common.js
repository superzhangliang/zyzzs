String.prototype.startWith=function(str){
	var reg=new RegExp("^"+str);     
	return reg.test(this);        
};

String.prototype.endWith=function(str){
	var reg=new RegExp(str+"$");     
	return reg.test(this);        
};

/**
 * 打开新窗口
 * @param url	转向网页的地址
 * @param name	网页名称，可为空
 * @param iWidth	弹出窗口的宽度
 * @param iHeight	弹出窗口的高度
 * @returns
 */
function openwindow(url,name,iWidth,iHeight)
{
// var url;   //转向网页的地址;
// var name;  //网页名称，可为空;
// var iWidth; //弹出窗口的宽度;
// var iHeight; //弹出窗口的高度;
 var iTop = (screen.availHeight-90-iHeight)/2;  //获得窗口的垂直位置;
 var iLeft = (screen.availWidth-10-iWidth)/2;   //获得窗口的水平位置;
 var win = window.open(url,name,'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=yes,resizeable=no,location=no,status=no');
 return win;
}

function openFull(url, title)
{
	if (title == undefined) title = '';
	window.open(url,title,'scrollbars=yes,toolbar=no,resizable=yes,menubar=no,location=no,status=no,width=' + screen.availWidth + ',height=' + (screen.availHeight-110) + ',left=0,top=0');    
}

/** 将date型转换为tring 
 * 传来的datetime是:Wed Mar 04 2009 11:05:05 GMT+0800格式  得到结果：2009-06-12
 * flag   1:返回yyyy-MM-dd格式,2:返回yyyy-MM-dd HH:mm:ss格式
 */
function dateToStr(datetime, flag){ 

	var year = datetime.getFullYear();
	var month = datetime.getMonth()+1;//js从0开始取 
	var date = datetime.getDate(); 
	var hour = datetime.getHours(); 
	var minutes = datetime.getMinutes(); 
	var second = datetime.getSeconds();

	if(month<10){
		month = "0" + month;
	}
	if(date<10){
		date = "0" + date;
	}
	if(hour <10){
		hour = "0" + hour;
	}
	if(minutes <10){
		minutes = "0" + minutes;
	}
	if(second <10){
		second = "0" + second ;
	}
	
	var time = "";
	switch (flag) {
	case 1:
		time = year+"-"+month+"-"+date;
		break;
	case 2:
		time = year+"-"+month+"-"+date+" "+hour;
		break;
	case 3:
		time = year+"-"+month+"-"+date+" "+hour+":"+minutes;
		break;
	default:
		time = year+"-"+month+"-"+date+" "+hour+":"+minutes+":"+second;
		break;
	}
	//alert(time);
	return time;
}

function createDate(timeStr) {
	if (typeof timeStr == "string" && timeStr.indexOf("CST")>-1){
		var time = 14*60*60*1000;
		return new Date(new Date(timeStr).valueOf()- time);
	}
	return new Date(timeStr);
}

/**
 * 把时间Long形式的字符串转成'yyyy-MM-dd'格式的字符串
 * @param timeStr	时间数字字符串
 * @returns	年月日格式字符串
 */
function formatTimeStr(timeStr) {
	if (timeStr != null && timeStr != "") {
		try {
			var date = createDate(timeStr);
			return dateToStr(date, 1);
		} catch (e) {
			return "";
		}
	} else {
		return "";
	}
}

/**
 * 把时间Long形式的字符串转成'yyyy-MM-dd HH'格式的字符串
 * @param timeStr	时间数字字符串
 * @returns	年月日时格式字符串
 */
function formatTimeHourStr(timeStr) {
	if (timeStr != null && timeStr != "") {
		try {
			var date = createDate(timeStr);
			return dateToStr(date, 2);
		} catch (e) {
			return "";
		}
	} else {
		return "";
	}
}

/**
 * 把时间Long形式的字符串转成'yyyy-MM-dd HH:mm'格式的字符串
 * @param timeStr	时间数字字符串
 * @returns	年月日时分格式字符串
 */
function formatTimeMinuteStr(timeStr) {
	if (timeStr != null && timeStr != "") {
		try {
			var date = createDate(timeStr);
			return dateToStr(date, 3);
		} catch (e) {
			return "";
		}
	} else {
		return "";
	}
}

/**
 * 把时间Long形式的字符串转成'yyyy-MM-dd HH:mm:ss'格式的字符串
 * @param timeStr	时间数字字符串
 * @returns	年月日时分秒格式字符串
 */
function formatTimeSecondStr(timeStr) {
	if (timeStr != null && timeStr != "") {
		try {
			var date = createDate(timeStr);
			return dateToStr(date, 4);
		} catch (e) {
			return "";
		}
	} else {
		return "";
	}
}

/**
 * 关闭以ligerDialog.open方式打开的弹窗
 */
function closeDialog() {
	var id = "#"+$("#dialogID").val();
	if (id != null && id != '') {
		$(window.parent.document).find(id).find(".l-dialog-close").click();
	}
}

/**
 * 子页面打开新标签页
 * @param win	窗口对象
 * @param tabid	标签ID
 * @param text	标签名称
 * @param url	标签路径
 */
function subAddTab(win, tabid, text, url) {
	if (win.f_addTab != undefined) {
		win.f_addTab(tabid,text,url);
	} else {
		subAddTab(win.parent, tabid, text, url);
	}
}

/**
 * 获取内容主界面的tab管理器
 * @param win	当前window对象
 * @returns	内容主界面的tab管理器
 */
function subGetTabManager(win) {
	if (win.$("#framecenter").ligerGetTabManager) {
		return win.$("#framecenter").ligerGetTabManager();
	} else {
		return subGetTabManager(win.parent);
	}
}

/**
 * 打开对话窗口
 * @param url	窗口内容url
 * @param title	窗口标题
 * @param width	宽度(支持数字,百分比,自动;默认是父窗口50%宽度)
 * @param height	高度(支持数字,百分比,自动;默认是父窗口50%高度)
 */
function openDialog(url, title, width, height) {
	if (url != undefined && url != '' && title != undefined && title != '') {
		//默认高度,宽度
		var windowW = $(this).width(),
			windowH = $(this).height(),
			w = windowW * 0.5,
			h = windowH * 0.5;
		//获取设置宽度
		if (width != undefined) {
			if (typeof width == 'number') {
				w = width;
			} else if (typeof width == 'string') {
				if (parseFloat(width) != 'NaN') {
					var temp_w = parseFloat(width);
					if (width.endWith('%')) {
						w = windowW * temp_w / 100;
						if (w < 700) {
							w = 700;
						}
					} else {
						w = temp_w;
					}
				}
			}
		}
		//获取设置高度
		if (height != undefined) {
			if (typeof height == 'number') {
				h = height;
			} else if (typeof height == 'string') {
				if (parseFloat(height) != 'NaN') {
					var temp_h = parseFloat(height);
					if (height.endWith('%')) {
						h = windowH * temp_h / 100;
						if (h < 400) {
							h = 400;
						}
					} else {
						h = temp_h;
					}
				}
			}
		}
		//获取顶部间距
		var t = 0;
		if ((windowH - h) > 0) {
			t = (windowH - h) / 2;
		}
		//打开子窗口
		return $.ligerDialog.open({
			url:$("#basepath").val()+url,
			title:title,
			width: w,
			height: h,
			top: t,
			isResize: true,
			showMax: true
		});
	}
}

/**
 * 获取当前选中的标签页ID
 * @returns	当前选中的标签页ID
 */
function getCurrentTabid() {
	var tabManager = subGetTabManager(window.parent);
	if(tabManager){
		return tabManager.getSelectedTabItemID();
	}else{
		return getCurrentTabid();
	}
}

/**
 * 关闭当前标签页并返回来源标签页
 * @param fromTabid
 */
function backToTab(fromTabid) {
	var tabManager = subGetTabManager(window.parent);
	tabManager.removeSelectedTabItem();
	if (fromTabid != undefined && fromTabid != "") {
		tabManager.reload(fromTabid);
		tabManager.selectTabItem(fromTabid);
	} else {
		tabManager.selectTabItem('home');
	}
}

/**
 * 删除指定页面元素
 * @param elementId	需删除的页面元素的ID
 */
function delElement(elementId) {
	$("#"+elementId).remove();
} 

/**
 * 下载文件
 * @param oldName	原文件名称
 * @param saveName	保存后的文件名称
 * @param savePath	保存路径
 */
function download_click(oldName,saveName,savePath){
	
	var postForm = document.createElement("form");//表单对象   
    postForm.method="post" ;   
    postForm.action = $("#basepath").val()+'jsp/download.jsp' ;   
     
    var oldNameInput = document.createElement("input") ;  //oldName input 
    oldNameInput.setAttribute("name", "oldName") ;   
    oldNameInput.setAttribute("value", oldName);   
    postForm.appendChild(oldNameInput) ;   
    var saveNameInput = document.createElement("input");// saveName input 
    saveNameInput.setAttribute("name","saveName"); 
    saveNameInput.setAttribute("value",saveName); 
    postForm.appendChild(saveNameInput); 
    var savePathInput = document.createElement("input");// saveName input 
    savePathInput.setAttribute("name","savePath"); 
    savePathInput.setAttribute("value",savePath); 
    postForm.appendChild(savePathInput); 
     
    document.body.appendChild(postForm) ;   
    postForm.submit() ;   
    document.body.removeChild(postForm) ;
	
}

/**
 * 获取订单类型说明
 * @param type	订单类型
 * @returns {String}	类型说明
 */
function getOrderType(type) {
	var msg = '';
	if (type == 1) {
		msg = '机构注册';
	} else if (type == 2) {
		msg = '机构续费';
	} else if (type == 3) {
		msg = '账号调整';
	} else if (type == 4) {
		msg = '功能调整';
	} else if (type == 5) {
		msg = '短信充值';
	} else if (type == 6) {
		msg = '机构续签';
	}
	return msg;
}

/**
 * 获取机构类型说明
 * @param type	机构类型
 * @returns {String}机构类型说明
 */
function getOrganType(type) {
	var msg = '';
	if (type == 1) {
		msg = '政府';
	} else if (type == 2) {
		msg = '企业';
	} else if (type == 3) {
		msg = '农村';
	}
	return msg;
}

/**
 * 只能输入大于0的正整数
 */
function onlyNum() {
    if(!(event.keyCode==46)&&!(event.keyCode==8)&&!(event.keyCode==37)&&!(event.keyCode==39))
    if(!((event.keyCode>=48&&event.keyCode<=57)||(event.keyCode>=96&&event.keyCode<=105)))
    event.returnValue=false;
}

/**
 * 检查数值是否在定义的范围内,小于最小则取最小,大于最大则取最大
 * @param _this	input对象
 */
function checkRange(_this) {
	if (_this.max && Number(_this.value) > Number(_this.max)) {
		_this.value = _this.max;
	}
	if (_this.min && Number(_this.value) < Number(_this.min)) {
		_this.value = _this.min;
	}
}

/**
 * 获取节点类型名称
 * @param type 节点类型
 * @return 对应节点类型名称
 */
function getNodeTypeName(type){
	var name = null;
	switch (type) {
	case 1: 
		name = "种植基地";
		break;
	case 2:
		name="养殖场";
		break;
	case 3: 
		name = "屠宰厂";
		break;
	case 4:
		name = "肉类批发市场";
		break;
	case 5: 
		name = "菜类批发市场";
		break;
	case 6:
		name = "肉类配送中心";
		break;
	case 7:
		name = "菜类配送中心";
		break;
	case 8:
		name = "标准化菜市场";
		break;
	case 9:
		name = "连锁超市";
		break;
	case 10:
		name = "团体消费单位";
		break;
	default:
		break;
	}
	return name;
}
	
	
/**
 * 获取经营者类型名称
 * @param type 经营者类型
 * @return 对应经营者类型名称
 */
function getBusinessTypeName(type){
	var name = null;
	switch (type) {
	case "0001": 
		name = "生猪批发商";
		break;
	case "0002":
		name = "肉类蔬菜批发商";
		break;
	case "0003": 
		name = "肉类蔬菜零售商";
		break;
	case "0004":
		name = "其他类型";
		break;
	default:
		break;
	}
	return name;
}
/**
 * 获取检疫结果类型名称
 * @param type 检疫结果类型
 * @return 对应检疫结果类型名称
 */
function getResultTypeName(type){
	var name = null;
	switch (type) {
	case "0": 
		name = "不合格";
		break;
	case "1":
		name = "合格";
		break;
	default:
		break;
	}
	return name;
}
/**
 * 获取凭证类型名称(检验、零售市场)
 * @param type 凭证类型
 * @return 对应凭证类型名称
 */
function getVoucherTypeName(type){
	var name = null;
	switch (type) {
	case "1": 
		name = "交易凭证号";
		break;
	case "2":
		name = "合格证号";
		break;
	case "6":
		name = "蔬菜进货批次号";
		break;
	default:
		break;
	}
	return name;
}
/**
 * 获取肉菜基础信息凭证类型名称（批发市场、零售市场、超市）
 * @param type 凭证类型
 * @return 对应凭证类型名称
 */
function getMarketVoucherTypeName(type){
	var name = null;
	switch (type) {
	case "1": 
		name = "交易凭证号";
		break;
	case "2":
		name = "动物产品检疫合格证号";
		break;
	case "3":
		name = "肉品品质检验合格证号";
		break;
	case "4":
		name = "蔬菜产地证明";
		break;
	case "5":
		name = "蔬菜检测合格证号";
		break;
	default:
		break;
	}
	return name;
}
/**
 * 获取留言管理回复状态
 * @param state 回复状态
 * @return 对应回复状态名称
 */
function getLeavingMsgStateName(state){
	var name = null;
	switch (state) {
	case 0: 
		name = "未回复";
		break;
	case 1:
		name = "已回复";
		break;
	default:
		break;
	}
	return name;
}

/**
 * 获取时间-小时差
 */
function getTimesGap( times ){
	var dateDiff = (new Date()).getTime() - times;//时间差的毫秒数
	var dayDiff = Math.floor(dateDiff / (24 * 3600 * 1000));//计算出相差天数
	if( dayDiff > 0 ){
		return 999;
	}else{
		var leave1 = dateDiff % (24 * 3600 * 1000)    //计算天数后剩余的毫秒数
		var hours = Math.floor(leave1 / (3600 * 1000))//计算出小时数
		
		return hours;
	}
}