/**
 *  tab页插件
 *  time: 2016-11-3 16:25:34
 *  author: LiuQingYe
 *  info: 提供一下接口
 *              1.newTab(id:string,text:string,src:string,isSwitch:boolean,needClose:boolean):
 *                      新建tab页，如果已有该id的页面，则会直接跳转该页而非新建页面，无返回。
 *                      id为自定义tab页id(默认自动生成)；text为tab标题文本（默认为空）；src为加载地址（必填项）；
 *                      isSwitch为是否设新页面为当前页；needClose为是否添加关闭按钮。
 *              2.switchTo(id:string): 切换至对应id的tab页面, 无返回。
 *              3.refresh(id)：调用对应id的tab里iframe页面的refresh方法(应需求添加的功能)，非直接刷新，无返回。
 *              4.reload(id)：重新加载对应id的tab里的iframe页面，无返回。
 *              5.close(id)：关闭对应id的tab页面，无返回。
 *              6.closeAll()：关闭所有tab页面，无返回。
 *              7.getCurrentTabId()：获取当前tab页面的id,返回string。
 *              8.getTab(id)：获取对应id的tab页面的信息,返回object。
 *              9.getTabs()：获取所有tab页面的信息,返回array。
 *              10.setSrc(id,src)：修改对应id的tab页面的地址信息,返回当前对象(this)。
 *              11.setText(id,text)：修改对应id的tab页面的标题信息,返回当前对象(this)。
 *              12.set(id,data)：修改对应id的tab页面的信息，data仅包含title和text，返回当前对象(this)。
 */
!(function($){
	var defaults={
		target: null,
		tabClass: {
			//tab容器
			box: "tab-box",
			//tab标签
			mark: "tab-mark",//容器
			mark_list: "tab-mark-list",//列表
			mark_list_item: "tab-mark-list-item",//项
			//快速链接
			quick: "tab-quick",
			quick_list: "tab-quick-list",
			quick_list_item:"tab-quick-list-item",
			//tab内容页
			page:"tab-page",
			page_frame:"tab-frame"
		}
	};
	$.fn.tabSelecter = function (options) {
		var router = window.frameRouter;
		//tab页记录列表
		this.record = {
			length:0
		};
		//刷新
		this.refresh = function (id) {
			var tab = this.getTab(id),
				frame = tab.frame,
				refresh = frame[0].contentWindow.refresh;
			if(refresh){
				refresh();
			}
		};
		//重新加载
		this.reload = function (id) {
			var tab = this.getTab(id),
				frame = tab.frame,
				src = frame.attr("src");
			frame.attr("src",src);
			//frame[0].contentWindow.location.reload(true);
		};
		//查找tab
		this.getTab = function (id) {
			if(this.record[id]){
				return this.record[id];
			}else{
				return false;
			}
		};
		//关闭
		this.close = function (id) {
			//隐藏并移除tab项
			var tab = this.getTab(id);
			if(!tab)return false;
			var mark = tab.mark,
				quick = tab.quick,
				frame = tab.frame,
				isCurrent = tab.isCurrent;
			//若当前显示中
			if(isCurrent){
				var len = this.record.length,
					arr = this.mark_list_item,
					index = null,next = null;
				for(var i = 0;i<len;i++){
					if($(arr[i]).data("target")==mark.data("target")){
						index = i;
					}
				}
				if(len==2){
					next = 1 - index;
				}else{
					if(index==0){
						next = index + 1;
					}else{
						next = index - 1;
					}
				}
				if(next==0||next){
					var targetId = $(arr[next]).data("target");
					this.switchTo(targetId);
				}
			}
			//删除对象
			mark.remove();
			quick.remove();
			frame.remove();
			//删除记录
			delete this.record[id];
			this.record.length--;
			//重置对象和监听
			this.reset();
		};
		//关闭全部
		this.closeAll = function () {
			//遍历所有tab页,并执行关闭
			var record = this.record;
			for(var i in record){
				if(i!="length"){
					this.close(i);
				}
			}
			this.record = [];
		};
		//新建
		this.newTab = function (id,text,src,isSwitch,needClose) {
			//判断该id的tab页是否存在, 存在则跳转
			var oldTab = this.getTab(id);
			if(oldTab){
				return this.switchTo(id);
			}
			if(!src){
				return false;
			}
			var tabClass = this.options.tabClass;
			//新建tab标签和快速链接
			var markItem = $('<li></li>');
			markItem.append('<span class="text">'+text+'</span>');
			markItem.append('<i class="close">×</i>');
			markItem.data("target", id);
			markItem.attr("title", text);
			//克隆至快速链接菜单
			var quickItem = markItem.clone();
			markItem.addClass(tabClass.mark_list_item);
			this.mark_list.append(markItem);
			quickItem.addClass(tabClass.quick_list_item);
			quickItem.data("target", id);
			quickItem.attr("title", text);
			this.quick_list.append(quickItem);
			//是否需要关闭按钮
			!needClose&&markItem.addClass("notClose");
			//新建tab内容页
			var frame = $('<iframe></iframe>');
			frame.addClass(tabClass.page_frame);
			//加入内容页列表
			this.page.append(frame);
			
			var newsrc = src.split("://"),
			 	location = (window.location+'').split('://');
			var bnewsrc = src.split("/"),
				blocation = (window.location+'').split('/');
			
			if(newsrc[0]=="http"|| newsrc[0]=="https"){
				if(bnewsrc[2]==blocation[2]){
					frame.attr("id",id)
					.attr("name",id)
					.attr("src",src);
				}else{
					var nframe = $('<iframe></iframe>');
					nframe.addClass(tabClass.page_frame);
					this.page.append(nframe);
					nframe.attr("id",id)
					.attr("name",id)
					.attr("src",src);
				}		
			}else{
				frame.attr("id",id)
				.attr("name",id)
				.attr("src",src);
			}
			//添加入记录列表
			var tab = {
				isCurrent:false,
				text:text,
				src: src,
				hasClose:needClose,
				mark: markItem,
				quick: quickItem,
				frame: frame
			};
			this.record[id] = tab;
			this.record.length++;
			//重置对象和绑定事件
			this.reset();
			//切换新建页为当前页
			if(isSwitch){this.switchTo(id);}
		};
		//获取当前tab的id
		this.getCurrentTabId = function(){
			return this.currentId;
		};
		//获取tab数组信息
		this.getTabs= function(){
			var record = this.record,arr = [];
			for(var i in record){
				if(i!="length"){
					arr.push({
						id: i,
						hasClose:record[i].hasClose,
						isCurrent: record[i].isCurrent,
						text:record[i].text,
						src: record[i].src
					});
				}
			}
			return arr;
		};
		//地址重定位
		this.setSrc = function (id, src) {
			if(id&&src){
				var tab = this.getTab(id);
				if(tab){
					tab.frame.attr("src",src);
				}
			}
			return this;
		};
		//修改标题
		this.setText = function (id, text) {
			if(id&&text){
				var tab = this.getTab(id);
				if(tab){
					tab.mark.children(".text").text(text);
					tab.mark.attr("title",text);
					tab.quick.children(".text").text(text);
					tab.quick.attr("title",text);
				}
			}
			return this;
		};
		//修改属性
		this.set = function (id,data) {
			var setting = $.extend({
				text: null,
				src: null
			},data);
			if(id&&data){
				var tab = this.getTab(id);
				if(tab){
					if(data.src){tab.frame.attr("src",setting.src);}
					if(data.text){
						tab.mark.children(".text").text(setting.text);
						tab.mark.attr("title",setting.text);
						tab.quick.children(".text").text(setting.text);
						tab.quick.attr("title",setting.text);
					}
				}
			}
			return this;
		};
		//切换
		this.switchTo = function (id) {
			var tabSelect = this;
			tabSelect.mark_list.width(this.mark_list_item.length * this.mark_list_item.eq(0).outerWidth(true));
			function getRecordCurrentItem(){
				var record = tabSelect.record;
				for(var i in record){
					if(record[i].isCurrent){
						return record[i];
					}
				}
				return false;
			}
			this.mark_list_item.each(function(num){
				var markItem = $(this),
					target = markItem.data("target"),
					isActive = markItem.hasClass("active");
				if(isActive&&target!=id){markItem.removeClass("active");}
				if(target==id){
					markItem.addClass("active");
					var oldCurrent = getRecordCurrentItem();
					if(oldCurrent){
						oldCurrent.isCurrent = false;
					}
					tabSelect.currentId = target;
					if(tabSelect.record[target]){
						tabSelect.record[target].isCurrent = true;
						tabSelect.refresh(target);
					}
					var maxW = parseInt(tabSelect.mark.width()),
						idx = num,
						len = tabSelect.mark_list_item.length,
						itemW = parseInt(markItem.outerWidth(true)),
						temp = 0;
					if(len*itemW<maxW){
						temp = 0;
					}else{
						if( (idx+1)*itemW<maxW/2 ){
							temp = 0;
						}else if( (len-idx-1)*itemW < maxW/2 ){
							temp = maxW - (len)*itemW;
						}else{
							temp = maxW/2-(idx+1)*itemW;
						}
					}
					tabSelect.mark_list.animate({marginLeft:temp+"px"},"quick");
				}
			});
			this.quick_list_item.each(function(){
				var quickItem = $(this),
					target = quickItem.data("target"),
					isActive = quickItem.hasClass("active");
				if(isActive&&target!=id){quickItem.removeClass("active");}
				if(target==id){quickItem.addClass("active");}
			});
			this.page_frame.each(function(){
				var frame = $(this),
					thisId =frame.attr("id"),
					isActive = frame.hasClass("active");
				if(isActive&&thisId!=id){frame.removeClass("active");}
				if(thisId==id){frame.addClass("active");}
			});
		};
		//更新对象
		this.resetObject = function () {
			var tabClass = this.options.tabClass;
			this.tabBox = $(this);
			this.mark = this.tabBox.children("."+tabClass.mark);
			this.mark_list = this.mark.children("."+tabClass.mark_list);
			this.mark_list_item = this.mark_list.children("."+tabClass.mark_list_item);
			this.quick = this.tabBox.children("."+tabClass.quick);
			this.quick_list = this.quick.children("."+tabClass.quick_list);
			this.quick_list_item = this.quick_list.children("."+tabClass.quick_list_item);
			this.page = this.tabBox.children("."+tabClass.page);
			this.page_frame = this.page.children("."+tabClass.page_frame);
			var width = 0, items = this.mark_list_item;
			for(var i =0,len= items.length;i<len;i++){
				var w = items.eq(i).outerWidth(true);
				width +=w;
			}
			this.mark_list.width(width);
		};
		//绑定监听
		this.bindListen = function () {
			var tab = this;
			this.mark_list_item.off("mouseup").on("mouseup",function () {
				var target = $(this).data("target");
				tab.switchTo(target);
			});
			this.quick_list_item.off("mouseup").on("mouseup",function () {
				var target = $(this).data("target");
				tab.switchTo(target);
			});
			this.mark_list_item.each(function () {
				var targetId = $(this).data("target");
				$(this).children(".close").off("mouseup").on("mouseup",function () {
					tab.close(targetId);
				});
			});
			this.quick.on("mouseover",function () {
				setTimeout(function () {
					var maxH = tab.page.height(),
						maxLen = 10,
						len = tab.quick_list_item.length,
						itemH = tab.quick_list_item.eq(0).height()+2,
						quickH =  len*itemH;
					if(maxH<quickH){
						tab.quick_list.css({maxHeight:maxH});
					}else{
						if (len<maxLen){
							tab.quick_list.css({maxHeight:quickH});
						}else{
							tab.quick_list.css({maxHeight:maxLen*itemH});
						}
					}
				},100)
			});
		};
		//注册至路由器
		this.registerRoute = function () {
			var tabSelecter = this;
			function getFrameEndId(id,win) {

				if(id){return id;}else{return win.name;}
			}
			router.register("closeTab",function (data,win) {
				var isFrame = window.top?true:false;
				if(isFrame){
					var endId = getFrameEndId(data,win);

					tabSelecter.close(endId);
				}
			});
			router.register("switchToTab",function (data,win) {
				var isFrame = window.top?true:false;
				if(isFrame){
					var endId = getFrameEndId(data,win);
					tabSelecter.switchTo(endId);
				}
			});
			router.register("setTab",function (data,win) {
				var opts = $.extend({
					id:null,
					text:null,
					src: null
				},data);
				var isFrame = window.top?true:false;
				if(isFrame){
					var endId = getFrameEndId(opts.id,win);
					if(opts.src||opts.text)tabSelecter.set(endId,opts);
				}
			});
			router.register("newTab",function (data,win) {
				var opts = $.extend({
					id:null,
					text:null,
					src: null,
					isSwitch: false
				},data);
				var isFrame = window.top?true:false;
				if(isFrame){
					var endId = getFrameEndId(opts.id,win);
					if(opts.src){
						tabSelecter.newTab(opts.id, opts.text, opts.src, opts.isSwitch);
					}
				}
			});
		};
		//重置
		this.reset = function () {
			this.resetObject();
			this.bindListen();
		};
		//初始化
		this.init = function (options) {
			this.options = $.extend(true, {}, defaults, options);
			this.currentId = null;
			//生成框架(未完善)
			this.append();
			//初始化内容
			var tabClass = this.options.tabClass,
				mark = $('<div class="'+tabClass.mark+'"></div>'),
				markList = $('<ul class="'+tabClass.mark_list+'"></ul>'),
				quick = $('<div class="'+tabClass.quick+'"></div>'),
				quickIcon = $('<i class="quickIcon"></i>'),
				quickList = $('<ul class="'+tabClass.quick_list+'"></ul>'),
				page = $('<div class="'+tabClass.page+'"></div>');
			mark.append(markList);
			quick.append(quickIcon).append(quickList);
			$(this).append(mark).append(quick).append(page);
			$(this).css({
				paddingTop: mark.height(),
				boxSizing: "border-box"
			});
			//重置对象和绑定事件
			this.reset();
			//注册方法
			this.registerRoute();
			return this;
		};
		//返回
		return this.init(options);
	}
})(window.jQuery,window.frameRouter);