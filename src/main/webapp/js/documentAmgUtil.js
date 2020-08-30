/**
 * 打开文件
 * @param url	需打开的文件的url
 */
function openFull(url) {
	 window.open(url,'','scrollbars=yes,toolbar=no,menubar=no,location=no,status=no,width=' + screen.width + ',height=' + screen.height + ',left=0,top=0');    
}

/**
 * 从附件列表容器中按顺序获取附件ID
 * @param attsDivId	附件容器的ID
 * @param eleType	附件行的元素类型,li或者tr
 * @returns {String}	按先后顺序的附件id集合字符串
 */
function getAttIdsFromDiv(attsDivId, eleType) {
	var children = $("#"+attsDivId).children(eleType);
	if (children && children.length) {
		var ids = '';
		for ( var i = 0; i < children.length; i++) {
			var id = $(children[i]).attr("attid");
			if (id) {
				ids += id + ',';
			}
		}
		return ids;
	} else {
		return '';
	}
	
}

/**
 * 删除附件
 * @param aid	附件数据库ID
 * @param delFileName	删除的文件名，确认删除提示用
 * @param haids	附件隐藏IDs的空间ID
 */
function deleteFile(aid,delFileName,haids){
	$.ajax({
		url:$("#basepath").val()+'amgNews/deleteFile.do',
		dataType:'json',
		data:{id:aid},
		success:function(data){
			if(data.success){
				if ($("#li"+aid) != undefined) $("#li"+aid).remove();
				if ($("#tr_"+aid) != undefined) $("#tr_"+aid).remove();
				if (haids != undefined && haids != '') {
					var ids=$('#' + haids).val();
					var tmp=ids.replace(aid+',',"");
					$('#'+haids).val(tmp);
				}
				alert("删除成功！");
			} else {
				alert("删除失败！");
			};
		},
		error:function(e){
			alert("删除失败！");
		}
	});
}

/**
 * 展示原来的附件列表
 * @param attsArr	传入的原来附件列表数组
 * @param attInputId	显示附件的容器ID,默认为attFiles1
 */
function showOldAtts(attsArr, attInputId) {
	if (attsArr != null && attsArr.length > 0 && attsArr[0] != null) {
		var htm = '';
		if (attInputId == undefined || $.trim(attInputId) == '') {
			attInputId = "attFiles1";
		}
		for (var i = 0; i < attsArr.length; i++) {
			htm += getAttachmentLi(attsArr[i]);
		}
		$("#" + attInputId).html($("#" + attInputId).html()+htm);
	}
	
}

/**
 * 展示原来图片的附件列表
 * @param attsArr	传入的原来附件列表数组
 * @param attInputId	显示附件的容器ID,默认为attFiles1
 */
function showOldAmgAtts(attsArr, attInputId,attsIds) {
	if (attsArr != null && attsArr.length > 0 && attsArr[0] != null) {
		var htm = '';
		if (attInputId == undefined || $.trim(attInputId) == '') {
			attInputId = "attFiles1";
		}
		for (var i = 0; i < attsArr.length; i++) {
			htm += getAmgAttachmentLi(attsArr[i]);
			$("#"+attsIds).val($("#"+attsIds).val()+attsArr[i].id+",");
		}
		$("#" + attInputId).html($("#" + attInputId).html()+htm);
	}
	
}

/**
 * 展示查看页面的附件列表
 * @param attsArr	附件信息数组
 * @param pathId	填充到的目标位置
 */
function showAttsView(attsArr, pathId) {
	var oldhtml = $("#" + pathId).html();
	var newhtml = "";
	var basepath = '';
	if ($("#basepath") != undefined) {
		basepath = $("#basepath").val();
	} else {
		basepath = '../';
	}
	if (attsArr != null && attsArr.length > 0 && attsArr[0] != null) {
		for (var i = 0; i < attsArr.length; i++) {
			newhtml += '<div style="vertical-align: middle;"><i class="fa fa-link" ></i>  <a onclick="openFull(\''+
			basepath +attsArr[i].savePath+'/'+attsArr[i].saveName+'\');" href="javascript:void(0);" style="margin-right:10px;"> ' +
				attsArr[i].fileName + '</a>&nbsp;&nbsp;<a onclick="download_click(\''+attsArr[i].fileName+
				'\',\''+attsArr[i].saveName+'\',\''+attsArr[i].savePath+'\')" style="cursor: pointer;" title="下载"><i class="fa fa-download" ></i></a></div>';
		
		}
	}
	$("#"+pathId).html(oldhtml + newhtml);
}


/**
 * 生成li形式的附件行
 * @param item	附件对象
 * @returns {String}
 */
function getAttachmentLi(item) {
	var li = '';
	if (item != undefined) {
		var suffix = item.fileName.toLowerCase().substring(item.fileName.lastIndexOf(".")+1);
		var logo = "<i class='fa fa-file-o'></i>";
		if( suffix == "jpg" || suffix == "png" || suffix == "jpeg" || suffix == "bmp" ){
			logo = "<i class='fa fa-file-image-o'></i>";
		}else if( suffix == "doc" || suffix == "docx" ){
			logo = "<i class='fa fa-file-word-o'></i>";
		}else if( suffix == "xls" || suffix == "xlsx" ){
			logo = "<i class='fa fa-file-excel-o'></i>";
		}else if( suffix == "ppt" || suffix == "pptx" ){
			logo = "<i class='fa fa-file-powerpoint-o'></i>";
		}else if( suffix == "pdf" ){
			logo = "<i class='fa fa-file-pdf-o'></i>";
		}else if( suffix == "html" || suffix =="htm"){
			logo = "<i class='fa fa-file-code-o'></i>";
		}else if( suffix == "zip" || suffix =="rar"){
			logo = "<i class='fa fa-file-zip-o'></i>";
		}else if( suffix == "txt" ){
			logo = "<i class='fa fa-file-text-o'></i>";
		}
		var basepath = $("#basepath").val();
		li = '<li id="li'+item.id+'" attid="'+item.id
		+'">'+logo+'<a href="javascript:void(0);"  style="margin-right:20px;margin-left:5px;" onclick="openFull(\''+
		basepath+'/'+item.savePath+'/'+item.saveName+'\');">'+
		item.fileName+'</a><a href="javascript:void(0);" onclick="upMove(this,\'li\');" style="margin-right:10px;" title="上移"><i class="fa fa-arrow-up" ></i></a>'
		+'<a href="javascript:void(0);" onclick="deleteFile(\''+item.id
		+'\',\''+item.fileName+'\',\'attachmentIds\');" title="删除"><i class="fa fa-trash" ></i></a></li>';
	}
	return li;
}

/**
 * 生成li形式的附件行(图片)
 * @param item	附件对象
 * @returns {String}
 */
function getAmgAttachmentLi(item) {
	var li = '';
	if (item != undefined) {
		var suffix = item.fileName.toLowerCase().substring(item.fileName.lastIndexOf(".")+1);
		var logo = "<i class='fa fa-file-o'></i>";
		if( suffix == "jpg" || suffix == "png" || suffix == "jpeg" || suffix == "bmp" ){
			logo = "<i class='fa fa-file-image-o'></i>";
		}else if( suffix == "doc" || suffix == "docx" ){
			logo = "<i class='fa fa-file-word-o'></i>";
		}else if( suffix == "xls" || suffix == "xlsx" ){
			logo = "<i class='fa fa-file-excel-o'></i>";
		}else if( suffix == "ppt" || suffix == "pptx" ){
			logo = "<i class='fa fa-file-powerpoint-o'></i>";
		}else if( suffix == "pdf" ){
			logo = "<i class='fa fa-file-pdf-o'></i>";
		}else if( suffix == "html" || suffix =="htm"){
			logo = "<i class='fa fa-file-code-o'></i>";
		}else if( suffix == "zip" || suffix =="rar"){
			logo = "<i class='fa fa-file-zip-o'></i>";
		}else if( suffix == "txt" ){
			logo = "<i class='fa fa-file-text-o'></i>";
		}
		var basepath = $("#basepath").val();
		li = '<li id="li'+item.id+'" attid="'+item.id
		+'">'+logo+'<a href="javascript:void(0);"  style="margin-right:20px;margin-left:5px;" title="点击显示图片" onclick="showAmg(\''+
		basepath+'/'+item.savePath+'/'+item.saveName+'\');">'+
		item.fileName+'</a><a href="javascript:void(0);" onclick="deleteFile(\''+item.id
		+'\',\''+item.fileName+'\',\'attachmentIds\');" title="删除"><i class="fa fa-trash" ></i></a></li>';
	}
	return li;
}

function showAmg(url, title)
{
	if (title == undefined) title = '';
	var height = screen.availHeight-150; 
    var width =  screen.availWidth-250;
	var top=Math.round((window.screen.height-height)/2);  
    var left=Math.round((window.screen.width-width)/2);
	window.open(url,title,"height=" + height + ", width=" + width + ", top=" + top + ", left= " + left 
			+ ", scrollbars=yes,toolbar=no,resizable=yes,menubar=no,location=no,status=no");
}

/**
 * 当前记录上移一位
 * @param _this	当前点击对象
 * @param eleType	目标行元素类型,li或者tr
 */
function upMove(_this, eleType) {
	if (_this) {
		var currentRow = $(_this).closest(eleType);
		if (currentRow.length) {
			var prevRow = $(currentRow).prev(eleType);
			if (prevRow.length) {
				$(currentRow).insertBefore(prevRow);
			} else {
				alert("此记录已经是第一位");
			}
		}
	}
}

/**
 * 当前记录下移一位
 * @param _this	当前点击对象
 * @param eleType	目标行元素类型,li或者tr
 */
function downMove(_this, eleType) {
	if (_this) {
		var currentRow = $(_this).closest(eleType);
		if (currentRow.length) {
			var nextRow = $(currentRow).next(eleType);
			if (nextRow.length) {
				$(currentRow).insertAfter(nextRow);
			} else {
				alert("此记录已经是最后一位");
			}
		}
	}
}

/**
 * 是否为正整数 
 * @param s	需要校验的数据
 * @returns	是否正整数
 */
function isPositiveNum(s){
	var re = /^[0-9]*[1-9][0-9]*$/ ; 
	return re.test(s); 
}


//多附件上传使用的统计数
var multiAllCount = 0,
multiSuccessCount = 0,
multiFaliCount = 0,
errorStr = '',
singleSizeLimit = 20*1024*1024;//限制单个文件文件大小,20M

/**
 * 初始化多附件上传
 * @param btnId	上传按钮的ID
 * @param progressId	进度条显示位置的ID
 * @param showSuccessId	上传成功后附件显示位置的ID
 * @param successValId	上传成功后返回附件ID存放的位置
 * @param type	附件类型
 */
function initMultiUpload(btnId, progressId, showSuccessId, successValId, type) {
	if (type == undefined || type == '' || !isPositiveNum(type)) {
		type = 0;
	}
	
	var uploader = WebUploader.create({
		auto: true,
	    // swf文件路径
	    swf: $("#basepath").val() + 'webuploader/Uploader.swf',
	
	    // 文件接收服务端。
	    server: $("#basepath").val() + 'amgNews/multiUpload.do',
	
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '#'+btnId,
	    
	    duplicate: true,
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false
	    
	    //限制单个文件大小20M
	    //fileSingleSizeLimit: 20*1024*1024,
	    
	});
	
	//文件加入队列前执行,这里用来做一些限制判断; file 准备加入队列的文件
	uploader.on( 'beforeFileQueued', function( file ) {
		multiAllCount++;
		if (file.size == 0 ){
			multiFaliCount++;
			errorStr += '\n"' + file.name + '" 文件无内容';
			return false;
		}else if (file.size > singleSizeLimit) {//判断是否超出单个文件大小限制
			multiFaliCount++;
			errorStr += '\n"' + file.name + '"超出最大允许大小';
			return false;
		} else if (file.ext == 'exe' || file.ext == 'bat') {//判断是否限制的文件格式
			multiFaliCount++;
			errorStr += '\n"' + file.name + '"不允许的上传文件格式';
			return false;
		} else {
			file.type = type;
			return true;
		}
	});
	
	//文件加入队列时执行; file 加入队列的文件
	uploader.on( 'fileQueued', function( file ) {
	    $("#"+progressId).append( '<div id="' + file.id + '" class="item">' +
	        '<h4 class="info">' + file.name + '</h4><p class="barspan"></p>' +
	        '<p class="state">等待上传...</p>' +
	    '</div>' );
	});
	
	//返回文件上传进度时执行 file 当前文件, percentage 当前进度
	uploader.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.votebox');
	    var w = parseInt(100*percentage)+"%";
	    
	    // 避免重复创建
	    if ( !$percent.length ) {
	    	//创建该文件的进度条
	        $li.find(".barspan").append('<div class="votebox" >'
	        		+'<dl class="barbox">'
	        		+'<dd class="barline">'
	        		+'<div class="charts"></div>'
	        		+'</dd></dl></div>');
	    }
		
	    //进度条文字状态变更
	    $li.find('p.state').html('上传中 已完成(<span class="rate">'+w+'</span>)');
		//进度条图形状态变更
		$li.find('.charts').each(function(i,item){
			$(item).animate({
				width: w
			},10);
		});
	});
	
	//单个文件上传成功后执行; file 上传成功的文件, response 服务器返回的response数据
	uploader.on( 'uploadSuccess', function( file,response ) {
		//记录成功条数+1
		multiSuccessCount++;
		//上传成功后的附件处理,显示到指定的地方,可供用户查看或删除
		var old_html = $("#" + showSuccessId).html();
		var htm = getAmgAttachmentLi(response);
		//alert(htm);
		$("#" + showSuccessId).html(old_html+htm);
		$("#" + successValId).val($("#" + successValId).val()+response.id+",");
	});
	
	//单个文件上传服务器失败时执行; file 当前文件, reason 失败原因
	uploader.on( 'uploadError', function( file, reason ) {
		multiFaliCount++;
		errorStr += '\n"' + file.name + '"服务器接收失败';
	});
	
	//单个文件上传完成后执行,无论是否成功; file 当前文件
	uploader.on( 'uploadComplete', function( file ) {
		//上传完成后把临时上传状态显示框删除
		$( '#'+file.id ).remove();
	});
	
	//所有文件上传完成后执行
	uploader.on( 'uploadFinished', function() {
		//显示本次上传结果统计
		if (multiFaliCount == 0) {
			alert("本次共上传 " + multiAllCount + " 个文件，全部上传成功！");
		} else {
			alert("本次共上传 " + multiAllCount + " 个文件，成功 " + multiSuccessCount 
					+ " 个，失败 " + multiFaliCount +" 个" + errorStr);
		}
		//重置统计数据
		multiAllCount = 0;
		multiSuccessCount = 0;
		multiFaliCount = 0;
		errorStr = '';
	});
}

