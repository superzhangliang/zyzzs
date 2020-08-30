/**
 * Created by Administrator on 2016/10/13.
 */
/*轮播js代码*/
//封装js得到对象的函数
$(function(){
	

	var byId = function(id){
	    return document.getElementById(id);
	}
	var byTag = function(tag){
	    return document.getElementsByTagName(tag);
	}
	/*var byIdTag = function(id,tag){
	    return document.getElementsById(id).getElementsByTagName(tag);//出错
	}*/
	
	//轮播图片元素
	var imgs = document.getElementById("list").getElementsByTagName("img");
	var list = byId("list");
	var container =byId("container");
	//屏幕宽度
	var bodyWidth = document.body.offsetWidth;
	var indexMainHeight = $("#index-main").height();
	//单张图片宽度
	var imgWidth = bodyWidth;
	var allImgWidth = parseInt(5 * bodyWidth);
	//总图片数
	var countImgs = 0;
	//轮播控制时间
	var timer;
	//获小圆点
	var buttons = document.getElementById("buttons").getElementsByTagName("span");
	var index = 1;
	
	//监听事件为获取屏幕可见高度为轮播图片宽度赋值
	for (var i = 0; i < imgs.length; i++) {
	    imgs[i].style.width = bodyWidth + 'px';
	    countImgs += 1;//7
	}
	list.style.left = -bodyWidth + 'px';
	list.style.width = parseInt(countImgs * bodyWidth) + 'px';
	
	//把index-main高度赋给图片与图片外包div
	container.style.height = parseInt(indexMainHeight) + 'px';
	for (var i = 0; i < imgs.length; i++) {
	    imgs[i].style.height = parseInt(indexMainHeight) + 'px';
	}
	
	//屏幕大小改变重置宽高度
	window.onresize = function () {
	    //屏幕大小变时高度重置
	    var bodyWidth = document.body.offsetWidth;
	    imgWidth = bodyWidth;
	    var indexMainHeight = $("#index-main").height();
	    container.style.height = parseInt(indexMainHeight) + 'px';
	    $(container).height(indexMainHeight);
	    for (var i = 0; i < imgs.length; i++) {
	        imgs[i].style.height = parseInt(indexMainHeight) + 'px';
	    }
	    //屏幕大小变时宽度重置
	    for (var i = 0; i < imgs.length; i++) {
	        imgs[i].style.width = document.body.offsetWidth + 'px';
	    }
	    list.style.left = -bodyWidth + 'px';
	    list.style.width = parseInt(countImgs * bodyWidth) + 'px';
	
	}
	
	//点击左右轮播
	function animate(offset) {
	    var newLeft = parseInt(list.style.left) + offset;
	    list.style.left = newLeft + 'px';
	    if (newLeft > -imgWidth) {
	        list.style.left = -allImgWidth + 'px';
	    }
	    if (newLeft < -allImgWidth) {
	        list.style.left = -imgWidth + 'px';
	    }
	}
	prev.onclick = function () {
	    index -= 1;
	    if (index < 1) {
	        index = parseInt(countImgs - 2);
	    }
	    buttonsShow();
	    animate(imgWidth);
	}
	next.onclick = function () {
	    index += 1;
	    if (index >  parseInt(countImgs - 2)) {
	        index = 1;
	    }
	    buttonsShow();
	    animate(-imgWidth);
	}
	//自动轮播
	var play = function () {
	    timer = setInterval(
	        function () {
	            next.click()
	        }, 5000)
	}
	play();
	
	//清除自动轮播
	var stop = function () {
	    clearInterval(timer);
	}
	
	//鼠标移上去清除轮播,移开继续;
	container.onmouseover = stop;
	container.onmouseout = play;
	
	//圆点显示颜色与否
	function buttonsShow() {
	    for (var i = 0; i < buttons.length; i++) {
	        if (buttons[i].className == "on") {
	            buttons[i].className = "";
	        }
	        buttons[index - 1].className = "on";
	    }
	}
	
	//点击相应小点显示相应图片
	for (var i = 0; i < buttons.length; i++) {
	    (function (i) {
	        buttons[i].onclick = function () {
	            var clickIndex = parseInt(this.getAttribute('index'));
	            var offset = parseInt(imgWidth * (index - clickIndex));
	            animate(offset);
	            index = clickIndex;
	            buttonsShow();
	        }
	    })(i)
	}
});