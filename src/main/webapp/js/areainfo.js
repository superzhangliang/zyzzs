var pHtml,cHtml,aHtml,pid,cid,aid,originName,proviceCode,cityCode,areaCode,level;

//初始化省信息
function initProviceInfo(level){
	$.ajax({
		url:$("#basepath").val()+'area/getAreaInfo.do?level='+level,
		type:'post',
		dataType:'json',
		async:false,
		success:function(data){
			var obj = eval(data.obj);
			var str = eval(data.str);
			if(obj!=null&&obj.length>0){
				pHtml = $("#provice").html();
				for(var i=0;i<obj.length;i++){
					if(proviceCode==obj[i].id){
						pHtml += '<option value="'+obj[i].id+'" selected>'+obj[i].name+'</option>';
					}else{
						pHtml += '<option value="'+obj[i].id+'">'+obj[i].name+'</option>';
					}
				}
				$("#provice").html(pHtml);
				$("select#provice").change(function(){
					var id = $(this).val();
					cityCode = 0;
					if(id!="0"){
						$("#form-originCode").val($("#provice").val());
						$("#form-originName").val($("#provice option:selected").text());
						if(isCity(id,str)){
							cHtml = '';
							cHtml += '<option value="0">——市——</option>';
							cHtml += '<option value="1">市直辖市</option>';
							$("#city").html(cHtml);
							
							aHtml = '';
							aHtml += '<option value="0">——区——</option>';
							$("#area").html(aHtml);
						}else{
							initCity(id,2);
						}
						$("select#city").change(function(){
							pid = $('#provice option:selected').val();
							cid = $('#city option:selected').val();
							if(cid == "0"){
								aHtml = '';
								aHtml += '<option value="0">——区——</option>';
								$("#area").html(aHtml);
								
								$("#form-originCode").val(pid);
								originName = $("#provice option:selected").text();
								$("#form-originName").val(originName);
							}else if(cid == "1"){
								initArea(pid,2);
							}else{
								$("#form-originCode").val(cid);
								originName = $("#provice option:selected").text()+$("#city option:selected").text();
								$("#form-originName").val(originName);
								initArea(cid,3);
							}
						});
					}else{
						cHtml = '';
						cHtml += '<option value="0">——市——</option>';
						$("#city").html(cHtml);
						
						aHtml = '';
						aHtml += '<option value="0">——区——</option>';
						$("#area").html(aHtml);
						
						$("#form-originCode").val("");
						$("#form-originName").val("");
					}
				});
			}
		},
		error:function(){
			alert('获取省数据失败！');
		}
	});
}
//判断是否是直辖市
function isCity(id,str){
	for(var j=0;j<str.length;j++){
		if(id==str[j]){
			return true;
		}
	}
	return false;
}

//初始化城市
function initCity(id,level){
	$.ajax({
		url:$("#basepath").val()+'area/getAreaInfo.do?level='+level+'&pid='+id,
		type:'post',
		dataType:'json',
		async:false,
		success:function(data){
			var obj = eval(data.obj);
			if(obj!=null&&obj.length>0){
				cHtml = '';
				cHtml += '<option value="0">——市——</option>';
				for(var i=0;i<obj.length;i++){
					if(cityCode==obj[i].id){
						cHtml += '<option value="'+obj[i].id+'" selected>'+obj[i].name+'</option>';
					}else{
						cHtml += '<option value="'+obj[i].id+'">'+obj[i].name+'</option>';
					}
				}
				$("#city").html(cHtml);
				aHtml = '';
				aHtml += '<option value="0">——区——</option>';
				$("#area").html(aHtml);
				
				$("select#city").change(function(){
					pid = $('#provice option:selected').val();
					cid = $('#city option:selected').val();
					if(cid == "0"){
						aHtml = '';
						aHtml += '<option value="0">——区——</option>';
						$("#area").html(aHtml);
						
						$("#form-originCode").val(pid);
						originName = $("#provice option:selected").text();
						$("#form-originName").val(originName);
					}else if(cid == "1"){
						initArea(pid,2);
					}else{
						$("#form-originCode").val(cid);
						originName = $("#provice option:selected").text()+$("#city option:selected").text();
						$("#form-originName").val(originName);
						initArea(cid,3);
					}
				});
			}else{
				cHtml = '';
				cHtml += '<option value="0">——市——</option>';
				$("#city").html(cHtml);
				aHtml = '';
				aHtml += '<option value="0">——区——</option>';
				$("#area").html(aHtml);
			}
		},
		error:function(){
			alert('获取市数据失败！！');
		}
	});
}

//初始化区
function initArea(id,level){
	$.ajax({
		url:$("#basepath").val()+'area/getAreaInfo.do?level='+level+'&pid='+id,
		type:'post',
		dataType:'json',
		async:false,
		success:function(data){
			var obj = eval(data.obj);
			if(obj!=null&&obj.length>0){
				aHml = '';
				aHml += '<option value="0">——区——</option>';
				for(var i=0;i<obj.length;i++){
					if(areaCode==obj[i].id){
						aHml += '<option value="'+obj[i].id+'" selected>'+obj[i].name+'</option>'; 
					}else{
						aHml += '<option value="'+obj[i].id+'">'+obj[i].name+'</option>';
					}
				}
				$("#area").html(aHml);
				
				$("select#city").change(function(){
					areaCode = 0;
					pid = $('#provice option:selected').val();
					cid = $('#city option:selected').val();
					if(cid == "0"){
						aHtml = '';
						aHtml += '<option value="0">——区——</option>';
						$("#area").html(aHtml);
						
						$("#form-originCode").val(pid);
						originName = $("#provice option:selected").text();
						$("#form-originName").val(originName);
					}else if(cid == "1"){
						initArea(pid,2);
					}else{
						$("#form-originCode").val(cid);
						originName = $("#provice option:selected").text()+$("#city option:selected").text();
						$("#form-originName").val(originName);
						initArea(cid,3);
					}
				});
				
				$("select#area").change(function(){
					aid = $("#area option:selected").val();
					originName='';
					if(aid=="0"){
						if(level=="2"){
							$("#form-originCode").val($("#provice option:selected").val());
							originName = $("#provice option:selected").text();
						}else if(level=="3"){
							$("#form-originCode").val($("#city option:selected").val());
							originName = $("#provice option:selected").text()+$("#city option:selected").text();
						}
					}else{
						$("#form-originCode").val($("#area option:selected").val());
						if(level=="2"){
							originName = $("#provice option:selected").text()+$("#area option:selected").text();
						}else if(level=="3"){
							originName = $("#provice option:selected").text()+$("#city option:selected").text()+
							$("#area option:selected").text();
						}
					}
					$("#form-originName").val(originName);
				});
			}else{
				aHtml = '';
				aHtml += '<option value="0">——区——</option>';
				$("#area").html(aHtml);
			}
		},
		error:function(){
			alert('获取市数据失败！！');
		}
	});
} 

//填充区域信息
function fullAreaInfo(originCode){
	$.ajax({
		url:$("#basepath").val()+'area/fullAreaInfo.do?originCode='+originCode, 
		type:'post',
		dataType:'json',
		async:false,
		success:function(data){
			//初始化全局变量
			level = '';
			proviceCode='';
			cityCode='';
			areaCode='';
			
			var obj = eval(data.obj);
			var str = eval(data.str);
			if(obj!=null){
				level = obj.level;
				proviceCode = obj.proviceCode;
				cityCode = obj.cityCode;
				areaCode = obj.areaCode;
				if(level==3){
					initProviceInfo(1);
					initCity(proviceCode,2);
					initArea(cityCode,3);
				}else if(level == 2){
					initProviceInfo(1);
					if(isCity(proviceCode.toString(),str)){
						cHtml = '';
						cHtml += '<option value="0">——市——</option>';
						cHtml += '<option value="1" selected>市直辖市</option>';
						$("#city").html(cHtml);
						
						areaCode = cityCode;
						initArea(proviceCode,2);
					}else{
						initCity(proviceCode,2);
						initArea(cityCode,3);
					}
				}else if(level == 1){
					initProviceInfo(1);
					if(isCity(proviceCode.toString(),str)){
						cHtml = '';
						cHtml += '<option value="0">——市——</option>';
						cHtml += '<option value="1">市直辖市</option>';
						$("#city").html(cHtml);
						$("select#city").change(function(){
							pid = $('#provice option:selected').val();
							cid = $('#city option:selected').val();
							if(cid == "0"){
								aHtml = '';
								aHtml += '<option value="0">——区——</option>';
								$("#area").html(aHtml);
								
								$("#form-originCode").val(pid);
								originName = $("#provice option:selected").text();
								$("#form-originName").val(originName);
							}else if(cid == "1"){
								initArea(pid,2);
							}
						});
					}else{
						initCity(proviceCode,2);
					}
				}
			}
		}
	});
}