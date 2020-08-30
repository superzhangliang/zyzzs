<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta charset="utf-8"/>
    <title>种养殖溯源管理平台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
    <link rel="stylesheet" href="${basepath}js/assets/css/bootstrap.min.css"/>
    <link href="${basepath}js/assets/css/bootstrap-dialog.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${basepath}js/assets/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="${basepath}js/assets/css/ace-fonts.css"/>
    <link rel="stylesheet" href="${basepath}js/assets/css/ace.min.css" id="main-ace-style"/>
    <link rel="stylesheet" href="${basepath}js/assets/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="${basepath}js/assets/css/ace-rtl.min.css"/>
    <link rel="stylesheet" href="${basepath}css/iconfont/iconfont.css"/>
    <link rel="stylesheet" href="${basepath}asset/tabSelecter/css/tabSelecter.css"/>
    <%--JoeChow start--%>
    <%--JoeChow end--%>
    <script src="${basepath}js/assets/js/ace-extra.min.js"></script>
    <script src="${basepath}js/dist/template.js"></script>
    
    <style>
        .main-container {
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        .main-content {
            width: 100%;
            height: 100%;
        }

        .nav-user-i {
            font-size: 40px;
            position: relative;
		    top: -10px;
		    left: -5px;
        }
        
        td{
        	padding:5px;
        }
    </style>

    <style>
        div.l-dialog-buttons {
            height: 40px;
        }
    </style>
</head>
<body class="no-skin">
<input type="hidden" id="basepath" value="${basepath}"/>
<!-- #section:basics/navbar.layout -->
<div id="navbar" class="navbar navbar-default  navbar-fixed-top"
     style="z-index: 998;background-image:url('${basepath}/images/topcszs_index.jpg');background-repeat:no-repeat;background-position-y:top;background-position-x:left">
    <script type="text/javascript">
        try {
            ace.settings.check('navbar', 'fixed');
        } catch (e) {
            console.log(e);
        }
    </script>

    <div class="navbar-container" id="navbar-container">
        <button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler">
            <span class="sr-only">Toggle sidebar</span>

            <span class="icon-bar"></span>

            <span class="icon-bar"></span>

            <span class="icon-bar"></span>
        </button>

        <div class="navbar-header pull-left">
            <div class="navbar-brand logo_img"
                 style="padding-top:4px;padding-bottom:2px;height:40px;color:#ffffff;font-family: Microsoft Yahei;">
                <img src="${basepath}images/logo.png" style="height:60px;width:60px;"/>
                <%--<span style="font-size: 34px;position: absolute;padding-left: 64px;top: 25px;">${organization.name}</span>--%>
            </div>
        </div>

        <div class="navbar-header pull-left" role="navigation">
            <div style="font-size: 34px;margin-top:10px;color: #000;">
                	种养殖溯源管理平台
            </div>
        </div>

        <div class="navbar-header pull-right" role="navigation">


            <ul class="nav ace-nav">
                <!-- #section:basics/navbar.user_menu -->
                <li>
                    <a data-toggle="dropdown" href="#" class="dropdown-toggle">
                        <!-- <img class="nav-user-photo" src="js/assets/avatars/avatar2.png" alt="Jason's Photo"> -->
                        <i class="nav-user-i iconfont icon-iconmy" style=""></i>
                        <span class="user-info">
									您好！<br>
									<span id="userSpan">${user.name }</span>
								</span>

                        <i class="ace-icon fa fa-caret-down"  style="position: relative;top: -20px;"></i>
                    </a>

                    <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close"
                        style="min-width: 120px;">
                        <li>
                            <a href="javascript:settingShow();">
                                <i class="iconfont icon-set"></i>
                                设置
                            </a>
                        </li>
                        <li>
                            <a href="javascript:helpShow();">
                                <i class="iconfont icon-yuyueshuoming"></i>
                                帮助
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="javascript:logout();">
                                <i class="iconfont icon-icon4"></i>
                                注销
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- /section:basics/navbar.user_menu -->
            </ul>
            <!-- <a href="${basepath}logout.do" style="color:#fff;">
						<i class="ace-icon fa fa-power-off" style="color:#fff;font-size:xx-large"></i>
					</a> -->
        </div>

    </div>
</div>

<div class="main-container" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.check('main-container', 'fixed');
        } catch (e) {
            console.log(e);
        }
    </script>
			
    <div id="sidebar" class="sidebar responsive ace-save-state sidebar-fixed sidebar-scroll" style="z-index: 998;">
        <script type="text/javascript">
            try {
                ace.settings.check('sidebar', 'fixed');
            } catch (e) {
                console.log(e);
            }
        </script>

        <ul class="nav nav-list">
            <%--动态生成菜单列表,递归子菜单 --%>
            <c:forEach var="menu" items="${menuList }" varStatus="status">
                <c:if test="${status.index == 0 }">
                    <li class="open">
                </c:if>
                <c:if test="${status.index != 0 }">
                    <li >
                </c:if>
                <c:choose>
                    <c:when test="${menu.children != null }">
                        <a href="#" class="dropdown-toggle">
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:f_addTab('menu${menu.id }','${menu.name }','${menu.url }');" menuName="${menu.name }">
                    </c:otherwise>
                </c:choose>
                <i class="${menu.icon }" style="font-size: 18px;"></i>
                <span class="menu-text"> ${menu.name } </span>
                <c:if test="${menu.children != null}">
                    <b class="arrow fa fa-angle-down"></b>
                </c:if>
                </a>
                <b class="arrow"></b>
                <c:if test="${menu.children != null}">
                    <ul class="submenu">
                        <c:forEach var="menu2" items="${menu.children}">
                            <c:choose>
                                <c:when test="${menu2.children != null}">
                                    <li>
                                        <a href="javascript:void(0);" class="dropdown-toggle">
                                            <i class="${menu2.icon }" style="font-size: 18px;"></i>
                                            <span class="menu-text"> ${menu2.name } </span>
                                            <b class="arrow fa fa-angle-down"></b>
                                        </a>
                                        <ul class="submenu">
                                            <c:forEach var="menu3" items="${menu2.children}">
                                                <li class="">
                                                    <a href="javascript:f_addTab('menu${menu3.id }','${menu3.prefix }${menu3.name }','${menu3.url }');"
                                                       menuName="${menu3.name }">
                                                        <i class="${menu3.icon }" style="font-size: 17px;"></i>
                                                            ${menu3.name }
                                                    </a>
                                                    <b class="arrow"></b>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="">
                                        <a href="javascript:f_addTab('menu${menu2.id }','${menu2.name }','${menu2.url }');"
                                           menuName="${menu2.name }">
                                            <i class="iconfont ${menu2.icon }" style="font-size: 18px;"></i>
                                                ${menu2.name }
                                        </a>
                                        <b class="arrow"></b>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </ul>
                </c:if>
                </li>
            </c:forEach>
        </ul>

        <div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
            <i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left"
               data-icon2="ace-icon fa fa-angle-double-right"></i>
        </div>

        <script type="text/javascript">
            try {
                ace.settings.check('sidebar', 'collapsed');
            } catch (e) {
                console.log(e);
            }
        </script>
    </div>

    <div class="main-content">
        <div class="page-content">
            <div class="tab-box" id="tabArea" style="width:100%;height:100%;overflow:hidden;">
            
            </div>
        </div>
    </div>

    <a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
        <i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
    </a>
    
</div>
<script type="text/javascript">
    window.jQuery || document.write("<script src='${basepath}js/assets/js/jquery.min.js'>" + "<" + "/script>");
</script>

<script type="text/javascript">
    if ('ontouchstart' in document.documentElement) document.write("<script src='${basepath}js/assets/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
</script>

<script src="${basepath}js/assets/js/bootstrap.min.js"></script>

<script src="${basepath}js/assets/js/ace-elements.min.js"></script>
<script src="${basepath}js/assets/js/ace.min.js"></script>

<script src="${basepath}asset/tabSelecter/js/frameRouter.js"></script>
<script src="${basepath}asset/tabSelecter/js/tabSelecter.js"></script>
<script src="${basepath}js/assets/js/bootstrap-dialog.min.js"></script>
<script src="${basepath}js/common.js" type="text/javascript"></script>
<script src="${basepath}js/bootstrapDialogUtil.js" type="text/javascript"></script>
	<script id="settingTemple" type="text/html">
		<div id="settingMessage">
			<div class="alert alert-block hide" id="msgDiv">
				<strong id="returnMsg"></strong>
			</div>
			<form id="settingForm" role="form">
				<table style="margin: 0 auto;">
					<tr>
						<td>
							姓名：
						</td>
						<td>
							<input type="text" id="name" name="name">
						</td>					
					</tr>

					<tr>
						<td>
							原密码：
						</td>			
						<td>
							<input type="password" id="password" name="password" onchange="pwChange()" value="">
							<i class="fa fa-check" aria-hidden="true" id="pwCheck" style="display:none;"></i>
						</td>		
					</tr>
			
					<tr>
						<td>
							新密码：
						</td>		
						<td>
							<input type="password" id="newPw" name="newPw"  onchange="newPwChange()" readOnly>
							<i class="fa fa-check" aria-hidden="true" id="npwCheck" style="display:none;"></i>
						</td>			
					</tr>

					<tr>	
						<td>
							新密码确认：
						</td>
						<td>
							<input type="password" id="comfirmPw" name="comfirmPw" onchange="comfirmPwChange()" readOnly>
							<i class="fa fa-check" aria-hidden="true" id="cpwCheck" style="display:none;"></i>
						</td>
					</tr>
				</table>
			</form>
		</div>	
	</script>
<style>
.imgcontent{
	padding:18px 26px;overflow:hidden;width:100%;height:100%;
}
</style>
<script type="text/javascript">
    function resize() {
        var bodyH = $(document.body).height(),
            navH = $("#navbar").outerHeight();
        $("#main-container").height(bodyH - navH);
    }
    window.onload = function () {
        resize();
    };
    window.onresize = function () {
        resize();
    };
    var taber;
    $(function () {

        //tab分页
        taber = $("#tabArea").tabSelecter();

        if ($($(".nav-list").children()[0]).children("ul")) {
            $($(".nav-list").children()[0]).children("ul").css("display", "block");
        }
    
    	var addhtml ="<img class='imgcontent' src='${basepath}images/home_image_yz.jpg'/>";
    	if( '${node}' != null && '${node.type}' == '2'){
    		addhtml ="<img class='imgcontent' src='${basepath}images/home_image_zz.jpg'/>";
    	}
        $(".tab-page").html(addhtml);

    });

    function f_addTab(tabid, text, url) {
    	$(".imgcontent").attr("style"," display:none");//不显示首页图片
        taber.newTab(tabid, text, url, true, true);
    }

    // 注销登录
    function logout() {
    	$.showConfirm('是否确定退出系统 ？', function() {
    		window.location.href = "${basepath}logout.do";
    	});
    }

    //超时登出
    function timeOutLogout() {
    	$.showErr('登录超时,请重新登陆', function () {
            window.location.href = "${basepath}logout.do";
        });
    }

    function helpShow() {
        f_addTab('menu169', '帮助专栏', 'listpages/helpList.jsp');
    }
    
    var secondAccount = '${seconAccount}';
    function settingShow() {
       // openDialog("usersetting.jsp", "个人设置", 500, 350);
       var buttons = [ 
			{
				label: "取消",
				action: function(dialog){
                  		dialog.close();
              		}
			},
			{
				label: "确认修改",
				cssClass: 'btn-primary',
				action: function(dialog){
					var $button = this;
              			$button.disable();//提交按钮不可用,防止重复提交
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					if (checkNotNull()) {
						$.ajax({
							url: "${basepath}modifySetting.do",
							type: "post",
							data: {"name":$("#name").val(), "password":$("#newPw").val() },
							dataType:"json",
							success:function(data){
								if (data != undefined) {
									if (data.success) {
										$("#msgDiv").addClass("alert-success");
										$("#userSpan").html($("#name").val());
										BootstrapDialog.alert(data.msg);
										dialog.close();
									}  else {
										$button.enable();
										$("#msgDiv").addClass("alert-danger");
									}
									$("#msgDiv").removeClass("hide");
									$("#returnMsg").html(data.msg);
								}
							},
							error: function() {
								$("#msgDiv").addClass("alert-danger").removeClass("hide");
								$("#returnMsg").html("提交异常");
								$button.enable();
							}
						});
					} else {
						$button.enable();//验证失败,提交按钮可用
					}
				} 
			}
		];
		//显示对话框
		BootstrapDialog.show({
            title: "<h5>个人设置</h5>",
            message: template('settingTemple', {}),
            //size: BootstrapDialog.SIZE_NORMAL,
            nl2br: false,
            closeByBackdrop: false,
            draggable: true,
            onshown: function(dialog) {
		         //隐藏提示信息
				$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
				//回填数据
				$("#name").val($("#userSpan").html());
            },
			buttons: buttons
		});
    }
    
    function pwChange(){
		var pwEnter = $("#password").val();
		var pwOld = '${user.password }';
		
		$.ajax({
			url: "${basepath}validatePw.do",
			type:"post",
			data: {pwEnter: pwEnter, pwOld: pwOld},
			dataType:"json",
			success:function(data){
				if (!data.success) {
					$("#msgDiv").addClass("alert-danger").removeClass("hide");
					$("#returnMsg").html("原密码错误！");
					$("#pwCheck").attr("style","display:none");
					$("#newPw").attr("readOnly","readOnly");
				}else{
					$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
					$("#pwCheck").attr("style","display:");
					$("#newPw").attr("readOnly",false);
				}
			}
		});
	}
	
	function newPwChange(){
		if( $("#newPw").val() == $("#password").val() ){
			$("#msgDiv").addClass("alert-danger").removeClass("hide");
			$("#returnMsg").html("新密码与原密码相同！");
			$("#npwCheck").attr("style","display:none");
			$("#comfirmPw").attr("readOnly","readOnly");
		}else{
			if( $("#newPw").val().length < 6 || $("#newPw").val().length > 16){
				$("#msgDiv").addClass("alert-danger").removeClass("hide");
				$("#returnMsg").html("密码长度不能大于16位或小于6位！");
				$("#npwCheck").attr("style","display:none");
				$("#comfirmPw").attr("readOnly","readOnly");
			}else{
				$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
				$("#npwCheck").attr("style","display:");
				$("#comfirmPw").attr("readOnly",false);
			}
		}
	}
	
	function comfirmPwChange(){
		if( $("#comfirmPw").val() != $("#newPw").val()){
			$("#msgDiv").addClass("alert-danger").removeClass("hide");
			$("#returnMsg").html("两次输入密码不同！");
			$("#cpwCheck").attr("style","display:none");
		}else{
			$("#msgDiv").removeClass("alert-success").removeClass("alert-danger").addClass("hide");
			$("#cpwCheck").attr("style","display:");
		}
	}
	
	function checkNotNull() {
		var msg = "";
		var name = $("#name").val();
		var pw = $("#password").val();
		var newPw = $("#newPw").val();
		var comfirmPw = $("#comfirmPw").val();
		if( name == '' ){
			msg += "姓名不能为空！";
		}
		if( pw =='' ){
			msg += "原密码不能为空！";
		}
		if( newPw == '' ){
			msg += "新密码不能为空！";
		}
		if( comfirmPw == '' ){
			msg += "新密码确认不能为空！";
		}
		if(msg != '') {
			$("#msgDiv").addClass("alert-danger").removeClass("hide");
			$("#returnMsg").html(msg);
			return false;
		} else {
			return true;
		}
	}
</script>
</body>
</html>
