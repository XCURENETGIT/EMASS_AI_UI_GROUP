<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String url = request.getParameter("imgUrl");
	String fileName = request.getParameter("fileName");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<title><%=fileName%></title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/ext/css/default.css" type="text/css"  charset="utf-8" />
<style type="text/css" media="screen">
canvas { 
	border: 1px solid black;
}
.rotateBtnArea button {
	background-color: #fff;
	border: 1px solid #9a9a9a;
	cursor: pointer;
}
.rotateBtnArea button:hover {
	background-color: #ececec;
}
</style>


<script type="text/javascript">
function rotate(p_deg)
{
    if(document.getElementById('canvas'))
	{
        var image = document.getElementById('image');
        var canvas = document.getElementById('canvas');
        var canvasContext = canvas.getContext('2d');
        
        switch(p_deg)
       	{
            default :
            case 0 :
                canvas.setAttribute('width', image.width);
                canvas.setAttribute('height', image.height);
                canvasContext.rotate(p_deg * Math.PI / 180);
                canvasContext.drawImage(image, 0, 0);
                break;
            case 90 :
                canvas.setAttribute('width', image.height);
                canvas.setAttribute('height', image.width);
                canvasContext.rotate(p_deg * Math.PI / 180);
                canvasContext.drawImage(image, 0, -image.height);
                break;
            case 180 :
                canvas.setAttribute('width', image.width);
                canvas.setAttribute('height', image.height);
                canvasContext.rotate(p_deg * Math.PI / 180);
                canvasContext.drawImage(image, -image.width, -image.height);
                break;
            case 270 :
            case -90 :
                canvas.setAttribute('width', image.height);
                canvas.setAttribute('height', image.width);
                canvasContext.rotate(p_deg * Math.PI / 180);
                canvasContext.drawImage(image, -image.width, 0);
                break;
        }
        
    }
    else
	{
        var image = document.getElementById('image');
        switch(p_deg)
		{
            default :
            case 0 :
                image.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=0)';
                break;
            case 90 :
                image.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=1)';
                break;
            case 180 :
                image.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=2)';
                break;
            case 270 :
            case -90 :
                image.style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation=3)';
                break;
        }
    }
}

function onloadEvent( )
{
	addLoadEvent( );
}

function addLoadEvent( )
{
    var image = document.getElementById('image');
    var canvas = document.getElementById('canvas');
    if(canvas.getContext)
	{
        image.style.visibility = 'hidden';
        image.style.position = 'absolute';
    }
	else
	{
        canvas.parentNode.removeChild( canvas );
    };
    rotate(0);
}
</script>
</head>

<body style="overflow: hidden; min-width: 290px;" onload="onloadEvent()">

<div class="rotateBtnArea">
	<span style="font-size: 13px;"><s:message code="message.msg.img.rotate"/> : </span> 
	<button onclick="rotate(0);">0°</button>
	<button onclick="rotate(90);">90°</button>
	<button onclick="rotate(180);">180°</button>
	<button onclick="rotate(-90);">-90°</button>
</div>
<div style="position: absolute; top: 40px; left: 10px; right: 10px; bottom: 10px;">
	<div style="overflow: auto;width: 100%;height: 100%;text-align: center;vertical-align: middle;">
		<div id='noneImage' style='padding-left:0px;padding-top:50px;text-align:center;'><img src='<c:url value="/img/loading/Loading.gif"/>'/></div>
		<img onclick="self.close();" title="<s:message code="message.msg.click.close"/>" id="image" src="<%=url%>" style="display: none;" onerror="this.style.display='';this.src='<c:url value="/img/noneImage.png"/>';" onload="noneImage.style.display='none';this.style.display='';" />
		<canvas id="canvas" style="width: 90%; height: 90%;"></canvas>
	</div>
</div>
</body>
</html>