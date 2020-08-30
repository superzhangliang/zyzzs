<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html >
<html>
<head>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>资料下载</title>
	<style type="text/css">
	body {
		background-color: #F4FEFF;
	}
	.c1 {
		font-family: "宋体";
		font-size: 15px;
		line-height: 30px;
		color: #336633;
	}
	.c2 {
		font-size: 14px;
		font-weight: bold;
		color: #336633;
	}
	a img{border:0px;}
	
	.td_1{
		width:972px;
		padding: 0px;
	    height: 64px;
	    background-image: url(../images/download_1.gif);
	}
	.td_2{
		width:972px;
		padding: 0px;
	    height: 88px;
	    background-image: url(../images/download_2.jpg);
	}
	.td_3{
		width:972px;
		padding: 0px;
	    height: 52px;
	    background-image: url(../images/download_3.gif);
	}
	.td_4{
		width:972px;
		padding: 0px;
	    height: 28px;
	    background-image: url(../images/download_4.gif);
	}
	</style>
</head>
<body>
	<table  width="972" border="0" align="center" cellspacing="0" cellpadding="0">
		<tr>
			<td class="td_1"></td>
		</tr>
		<tr>
			<td class="td_2"></td>
		</tr>
		<tr>
			<td class="td_3"></td>
		</tr>
		<tr>
			<td class="td_4">&nbsp;</td>
		</tr>
			
		<tr>
			<td height="100%" valign="top">
				<div align="center">
					<table width="800" border="0" cellpadding="0" cellspacing="1"
						bordercolor="#67A735" bgcolor="#67A735" style="margin-top: 20px;">
						<tr>
							<td width="10%" height="35" background="<%=basePath%>images/download_5.gif"
								bgcolor="#FFFFFF"><div align="center" class="c2">序号</div>
							</td>
							<td width="40%" height="35" background="<%=basePath%>images/download_5.gif"
								bgcolor="#FFFFFF"><div align="center" class="c2">功能操作</div>
							</td>
							<td width="40%" height="35" background="<%=basePath%>images/download_5.gif"
								bgcolor="#FFFFFF"><div align="center" class="c2">功能说明</div>
							</td>
							<td width="10%" background="<%=basePath%>images/download_5.gif" bgcolor="#FFFFFF"><div
									align="center" class="c2">下载</div>
							</td>
						</tr>

						<tr class="c1">
							<td bgcolor="#FFFFFF"><div align="center">1</div></td>
							<td bgcolor="#FFFFFF"><div align="center">CLodap页面打印控件</div>
							</td>
							<td bgcolor="#FFFFFF"><div align="center">CLodap页面打印控件</div>
							</td>
							<td bgcolor="#FFFFFF" style="padding-top: 10px;">
								<div align="center">
									<a href='<%=basePath%>jsp/dataFiles/CLodop_Setup.exe'> 
										<img src="<%=basePath%>images/inde_download.gif" width="19" height="22"> 
									</a>
								</div>
							</td>
						</tr>
						<tr class="c1">
							<td bgcolor="#FFFFFF"><div align="center">2</div></td>
							<td bgcolor="#FFFFFF"><div align="center">平台操作手册</div></td>
							<td bgcolor="#FFFFFF"><div align="center">平台操作手册</div></td>
							<td bgcolor="#FFFFFF" style="padding-top: 10px;">
								<div align="center">
									<a href='<%=basePath%>jsp/dataFiles/czsc.doc'> 
									<img src="<%=basePath%>images/inde_download.gif" width="19" height="22"> 
									</a>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>