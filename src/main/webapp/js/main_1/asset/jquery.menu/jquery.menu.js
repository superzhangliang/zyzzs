/**
 * title: jquery leftMenu plus
 * version: 0.1.0
 * author: LiuQingYe
 * time: 2016-10-25 11:37:35
 * info: 左侧导航菜单栏插件, 有展开式和折叠式(尚未完成)两种展现形式
 */
;(function ($) {

	/**
	 * 随机id值
	 **/
	$.randomId = function () {
		var Min = 1, Max = 9999, num = Min + Math.round(Math.random() * (Max - Min)),
			time = new Date().getTime();
		return "id-" + time + num;
	};
	/**
	 * 去除多余的"#"和".", 获取其名称
	 **/
	String.prototype.getName = function () {
		return this.replace(".", "").replace("#", "");
	};


	/**
	 * 展开式
	 * @param options
	 * @returns {$.fn.leftMenu}
	 */
	$.fn.menuOpenWing = function (options) {
		//默认值
		var defaults = {
			type: 0,
			delayTime: 200,
			box: ".nav-box",
			subBox:".sub-box",
			list: ".nav-list",
			first: "first",
			item: "li",
			itemText: ".textArea",
			itemSublist: ".sub-list"
		};
		//初始化参数
		this.options = $.extend(true, {}, defaults, options);
		this.main = $(this);
		//存储列表
		this.subBoxList = {};
		/**
		 * 通过id查找subbox
		 **/
		this.findSubBox = function (id) {
			var list = this.subBoxList;
			if (id&&list[id]) {
				return list[id];
			}
			return false;
		};
		/**
		 * 在列表内容查找有相应锚点的项
		 * @param box
		 * @param targetId
		 * @returns {*}
		 */
		this.findTargetItemInBox = function (box,targetId) {
			var target = null;
			if(!box||!targetId){return false;}
			box.find(this.options .item).each(function () {
				if($(this).data("target")==targetId){
					target = $(this);
				}
			});
			return target;
		};
		/**
		 * 延时判定是否隐藏subbox
		 **/
		this.hideBox = function (target) {
			var opts = this.options;
			target.data("state","hide");
			setTimeout(function () {
				if(target.data("state")=="hide"){
					target.removeClass("active");
					target.find(opts.item).removeClass("active");
				}
			}, opts.delayTime);
		};
		/**
		 * 显示subbox, 并准确定位
		 * @param target
		 */
		this.showBox = function (target) {
			if(target){
				target.data("state","show");
				if( !target.hasClass("active") ){
					target.addClass("active");
					if(target.hasClass("sub-box")){
						this.setBoxToSuit(target);
					}
				}
			}
		};
		/**
		 * 让列表调节height和top
		 */
		this.setBoxToSuit = function (target) {
			var top = parseInt(target.data("originTop")),
				height = parseInt(target.outerHeight(true)),
				mainT = parseInt(this.main.offset().top),
				mainH = parseInt(this.main.outerHeight(true));
			if(height < mainH){
				if(top+height<mainH+mainT){
					target.css({top:top,height: "auto",overflowY:"hidden"});
				}else{
					//尚未超出高度,但位置偏下
					target.css({top: mainT+mainH-height,overflowY:"auto"});
				}
			}else{
				//子列表完全超出高度
				target.css({top:mainT,height: mainH,overflowY:"auto"});
			}
		};
		/**
		 * 重设监听
		 **/
		this.resetListener = function () {
			var station = this,
				opts = this.options;
			//监听鼠标移出列表
			$(opts.subBox).on("mouseout",function () {
				var box = $(this),
					parentBox = station.findSubBox(box.data("parent"));
				station.hideBox(box);
				if(parentBox){
					station.hideBox(parentBox);
				}
			});
			//监听鼠标悬停列表
			$(opts.subBox).on("mouseover",function () {
				var box = $(this);
				//显示列表
				station.showBox(box);
				//显示相关列表
				station.showAboutBox(box);
			});
			//监听鼠标进入菜单项
			$(opts.box).find(opts.item).on("mouseenter",function () {
				var item = $(this),
					box = item.closest(opts.box),
					targetBox = station.findSubBox(item.data("target"));
				box.find(opts.item).removeClass("active");
				item.addClass("active");
				//如果目标子列表存在则显示,否则创建子列表
				if(targetBox){
					station.showBox(targetBox);
				}else{
					station.createSubBox(item);
				}
			});
			//监听鼠标离开菜单项
			$(opts.box).find(opts.item).on("mouseleave",function () {
				var item = $(this), box = station.findSubBox(item.data("target"));
				item.removeClass("active");
				if(box){
					station.hideBox(box);
				}
			});
		};
		/**
		 * 递归显示相关列表
		 **/
		this.showAboutBox = function(box) {
			var boxId  = box.attr("id"),
				station = this,
				opts = station.options,
				parentBox = station.findSubBox(box.data("parent"));
			if(parentBox){
				station.showBox(parentBox);
				//遍历列表项,将相应的item设为active
				parentBox.find(opts.item).each(function () {
					var targetId = $(this).data("target");
					if( targetId == boxId){
						$(this).addClass("active");
					}
				});
				station.showAboutBox(parentBox);
			}
		};
		/**
		 * 隐藏所有子列表
		 */
		this.hideAllSubBox = function (callback) {
			var station = this;
			$(this.options.subBox).each(function () {
				station.hideBox($(this));
			});
			if(callback){
				setTimeout(function () {
					callback();
				},100);
			}
		};
		/**
		 * 创建subbox
		 **/
		this.createSubBox = function (target) {
			var id = target.data("target"),
				opts = this.options,
				sublist = target.children(opts.itemSublist);
			//当子列表存在时
			if(!id&&sublist.length>0){
				//获取相关参数
				id = $.randomId();
				target.data("target",id);
				var box = target.closest(opts.box),
					parentId = box.attr("id"),
					info = sublist.clone(true),
					param = {
						width: parseInt( target.closest(".nav-box").width()),
						height: parseInt( target.outerHeight()),
						left: parseInt( target.offset().left ),
						top: parseInt( target.offset().top) - parseInt( target.closest(".nav-box").css("border-top-width") )
					};
				//新建列表
				var subBox = $("<div></div>");
				subBox.addClass(opts.box.getName());
				subBox.addClass(opts.subBox.getName());
				subBox.attr("id", id);
				subBox.data("parent", parentId);
				subBox.data("originTop",param.top);
				subBox.css({
					top: param.top,
					left: param.left + param.width,
					position: "absolute"
				});
				info.children(opts.item).each(function(){
					if($(this).children(opts.itemSublist).length>0){
						$(this).addClass("hasSubList");
					}
				});
				subBox.html(info);
				$(document.body).append(subBox);
				//显示子列表
				this.showBox(subBox);
				this.subBoxList[id] = subBox;
				//重置监听
				this.resetListener();
			}
			return false;
		};
		/**
		 * 初始化
		 * @returns {$.fn.leftMenu}
		 */
		this.init = function () {
			var id = $(this).attr("id");
			//将一级列表也设入subbox列表中
			this.subBoxList[id] = $(this);
			//添加监听
			this.resetListener();
			return this;
		};
		//返参
		return this.init();
	};

	$.fn.menuOpenFold = function (options) {
		//默认值
		var defaults = {
			type: 0,
			delayTime: 200,
			subList:".moreList",
			subItem:".item",
			mainList:".toolList",
			mainItem:".toolItem"
		};
		this.options = $.extend(true, {}, defaults, options);
		this.init = function () {
			//遍历所有子列并添加标志
			this.eachAddSign();
			//添加监听
			this.addListener();
			return this;
		};
		/**
		 * 以递归方式遍历所有项, 并在有子列的项加标志
		 * @param target
		 */
		this.eachAddSign = function () {
			var menu = this, opts = menu.options;
			$(this).find(opts.mainItem).each(function () {
				var subList = $(this).children(opts.subList);
				if(subList.length>0) {
					$(this).addClass("hasSubList");
				}
			});
		};
		this.hideSubList = function(target){
			target.height(0);
		};
		this.showSubList = function(target){

			var item = target.children(this.options.subItem),
				sumH = 0;
			item.each(function () {
				sumH += parseInt($(this).height());
			});
			target.height(sumH);
		};
		this.hideAllBox = function(){
			var subList = $(this).find(this.options.subList);
			for(var i in subList){
				this.hideSubList(subList.eq(i))
			}
		};
		this.addListener = function () {
			var target = $(this).find(".hasSubList"),
				menu = this,
				subListClass = this.options.subList;
			target.each(function () {
				if($(this).hasClass("active")){
					menu.showSubList($(this).children(subListClass));
				}else{
					menu.hideSubList($(this).children(subListClass));
				}
			});
			target.on("click",function () {
				$(this).toggleClass("active");

				if($(this).hasClass("active")){
					menu.showSubList($(this).children(subListClass));
				}else{
					menu.hideSubList($(this).children(subListClass));
				}
				return true;
			});
			//防止
			menu.find("li:not(.hasSubList)").click(function () {
				event.stopPropagation();
			})
		};
		return this.init();
	};


	/**
	 * 侧边菜单显示隐藏
	 * @type {{validData: menuBtn.validData, init: menuBtn.init, slideHideMenu: menuBtn.slideHideMenu,
	  * slideShowMenu: menuBtn.slideShowMenu, judgeToggle: menuBtn.judgeToggle, addListener: menuBtn.addListener}}
	 */
	function menuBtn(opts) {
		return this.init(opts);
	}
	menuBtn.prototype = {
		/**
		 * 验证数据是否满足
		 * @param opts
		 * @returns {boolean}
		 */
		validData:function (opts) {
			var result = true;
			if(!opts.menu || !opts.btn){
				result = false;
			}
			return result;
		},
		/**
		 * 初始化
		 * @param opts
		 * @returns {*}
		 */
		init :function (opts) {
			this.options = $.extend(true,{
				menu: null,
				btn: null,
				bigScreenHide:false,
				way:"left",
				animateTime: 200,
				beforeHide:null,
				afterHide:null,
				beforeShow:null,
				afterShow:null
			},opts);
			if(!this.validData(this.options)){return false;}
			this.options.menu.hide();
			this.addListener();
			return this;
		},
		/**
		 * 滑动隐藏菜单
		 */
		slideHideMenu: function () {
			var opts = this.options;
			opts.menuWidth = parseInt($(opts.menu).width());
			if(opts.beforeHide){opts.beforeHide(opts);}
			if(opts.way=="left"){
				$(opts.menu).stop().animate({left:-opts.menuWidth+"px"},opts.animateTime);
			}else{
				$(opts.menu).stop().animate({right:-opts.menuWidth+"px"},opts.animateTime);
			}
			if(opts.afterHide){opts.afterHide(opts);}
		},
		/**
		 * 侧滑显示菜单
		 */
		slideShowMenu: function () {
			var opts = this.options;
			opts.menuWidth = parseInt($(opts.menu).width());
			if(opts.beforeShow){opts.beforeShow(opts);}
			if(opts.way=="left"){
				$(opts.menu).stop().animate({left:0},opts.animateTime);
			}else{
				$(opts.menu).stop().animate({right:0},opts.animateTime);
			}
			if(opts.afterShow){opts.afterShow(opts);}

		},
		/**
		 * 判断显示还是隐藏
		 */
		judgeToggle:function () {
			var opts = this.options,
				judge = $(opts.btn).hasClass("active")?true:false;

			if(parseInt(window.innerWidth)>=1200){
				if(!opts.bigScreenHide){
					this.slideShowMenu();
					$(opts.btn).addClass("active");
				}else{
					this.slideHideMenu();
					$(opts.btn).removeClass("active");
				}
			}else{
				if (judge){
					this.slideShowMenu();
				}else{
					this.slideHideMenu();
				}
			}
		},
		/**
		 * 添加监听事件
		 */
		addListener: function () {
			var station = this,opts = station.options;
			$(window).on("load",function () {
				if(!opts.bigScreenHide){
					$(opts.menu).show();
				}else{
					if(parseInt(window.innerWidth)<1200){
						$(opts.menu).show();
					}
				}
				station.judgeToggle();
			});
			$(window).on("resize",function () {
				if(parseInt(window.innerWidth)>=1200&&opts.bigScreenHide){
					$(opts.menu).hide();
				}
				$(opts.menu).show();
				station.judgeToggle();
			});
			$(opts.btn).on("click",function () {
				$(this).toggleClass("active");

				station.judgeToggle();
			});
		}
	};
	window.menuBtn = menuBtn;
})(jQuery);