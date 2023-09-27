var Prod = "xcurenet_Venus_InnoFD_IE";
var Enc = new String();

var UseUnicode = "false";
var ChildMode = "false";
var UseFileSizeQueryString = "true";

var	DialogListHeight = "200";
var ListStyle = "list";
var FolderType = "type1";
var ShowStatus = "true";
var ShowFileOpen = "true";
var BkImgURL = new String("");

var UseResume = "true";
var FixResume = "false";
var LimitRate = "0";

var UseFullPath = "false";
var SetFolder = "";
var SetTempFolder = "";

var InnoFD_Cab = contextRoot + "/util/InnoFD6.cab";
var InnoFD_Version = "6,0,4,5150";
var strID =  new String("");

function InnoFDInit(nWidth, nHeight)
{
    LoadInnoFD(nWidth, nHeight);
}

function isActiveX ( ) {
	return false;
	
	try {
		if ( document.InnoFD.GetCount == undefined ) return false;
		else return true;
	} catch(e){}
	return false;
}

function LoadInnoFD( nWidth, nHeight )
{
	return;
	
    if (nWidth == "undefined")
    {
        nWidth = "100%";
    }

    if (nHeight == "undefined")
    {
        nHeight = "100%";
    }

    if (strID == "") strID = "InnoFD";

	var codeMSG = "codebase=\"" + InnoFD_Cab + "#version=" + InnoFD_Version + "\" ";
    var errMSG = " ";
    document.writeln('<object id=\"' + strID + '\" ' + codeMSG + errMSG + ' classid="clsid:DE63F149-9D9C-4478-82B9-8BD5CD3DFE1C" width="'+nWidth+'" height="'+nHeight+'">');
    document.writeln('<param name="Prod" value="'+Prod+'">');
    document.writeln('<param name="Enc" value="'+Enc+'">');

    document.writeln('<param name="UseUnicode" value="'+UseUnicode+'">');
    document.writeln('<param name="ChildMode" value="'+ChildMode+'">');
    document.writeln('<param name="UseFileSizeQueryString" value="'+UseFileSizeQueryString+'">');

    document.writeln('<param name="DialogListHeight" value="'+DialogListHeight+'">');
    document.writeln('<param name="ListStyle" value="'+ListStyle+'">');
    document.writeln('<param name="FolderType" value="'+FolderType+'">');
    document.writeln('<param name="ShowStatus" value="'+ShowStatus+'">');
    document.writeln('<param name="ShowFileOpen" value="'+ShowFileOpen+'">');

    document.writeln('<param name="UseResume" value="'+UseResume+'">');
    document.writeln('<param name="FixResume" value="'+FixResume+'">');
    document.writeln('<param name="LimitRate" value="'+LimitRate+'">');

    document.writeln('<param name="UseFullPath" value="'+UseFullPath+'">');
    document.writeln('<param name="SetFolder" value="'+SetFolder+'">');
    document.writeln('<param name="SetTempFolder" value="'+SetTempFolder+'">');
    document.writeln('<param name="Language" value="'+innoFD_Lang+'">');
    
    document.writeln('</object>');

    if (strID == "") strID = "InnoFD";

	////////////////////
	var bAvailable = false;
	var APObject = document.getElementById(strID);
	if (typeof(APObject) == 'object')
	{
		if (APObject.readyState == 4)
		{
			if (APObject.object != null)
			{
				bAvailable = true;
			}
		}
	}

	if (bAvailable)
	{
		try
		{
			eval("On" + strID + "Load()");
		}
		catch (ex) { }
	}
	else
	{
		document.InnoFD.onreadystatechange = lsn_OnInnoFDLoad;
	}
	////////////////////
}

function lsn_OnInnoFDLoad()
{
    if (strID == "") strID = "InnoFD";

    ////////////////////
    var bAvailable = false;
    var APObject = document.getElementById(strID);
    if (typeof(APObject) == 'object')
    {
        if (APObject.readyState == 4)
        {
            if (APObject.object != null)
            {
                bAvailable = true;
            }
        }
    }

    if (bAvailable)
    {
        try
        {
            eval("On" + strID + "Load()");
        }
        catch (ex) { }
    }
    else
    {
        //
    }
    ////////////////////
}






//Xcn Downloader
function LoadXDFD ( )
{
	var _info = navigator.userAgent;
	var _ie = (_info.indexOf("MSIE") > 0 && _info.indexOf("Win") > 0 && _info.indexOf("Windows 3.1") < 0);
	if (_info.indexOf("Opera") > 0) _ie = false;
	var _ns = (navigator.appName.indexOf("Netscape") >= 0 && ((_info.indexOf("Win") > 0 && _info.indexOf("Win16") < 0) || (_info.indexOf("Sun") > 0) || (_info.indexOf("Linux") > 0) || (_info.indexOf("AIX") > 0) || (_info.indexOf("OS/2") > 0) || (_info.indexOf("IRIX") > 0)));
	var _ns6 = ((_ns == true) && (_info.indexOf("Mozilla/5") >= 0));
	if ( _ie == true )
	{
		document.writeln('<OBJECT classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" WIDTH="0" HEIGHT="0" NAME="InnoFD" codebase="http://java.sun.com/update/1.6.0/jinstall-6u34-windows-i586.cab#Version=6,0,0,4">');
	}
	else if ( _ns == true && _ns6 == false )
	{
		document.write('<EMBED ');
		document.write('type="application/x-java-applet;version=1.6" ');
		document.write('CODE="com.xcn.XDManager.class" ');
		document.write('JAVA_CODEBASE="./" ');
		document.write('ARCHIVE="'+contextRoot+'/ext/util/xdownloader.jar" ');
		document.write('NAME="InnoFD" ');
		document.write('WIDTH="0" ');
		document.write('HEIGHT="0" ');
		document.write('scriptable=true ');
		document.writeln('pluginspage="http://java.sun.com/products/plugin/index.html#download"><NOEMBED>');
	}
	else
	{
		document.write('<APPLET CODE="com.xcn.XDManager.class" JAVA_CODEBASE="./" ARCHIVE="'+contextRoot+'/ext/util/xdownloader.jar" WIDTH="0" HEIGHT="0" NAME="InnoFD">');
	}
	document.writeln('<PARAM NAME=CODE VALUE="com.xcn.XDManager.class">');
	document.writeln('<PARAM NAME=CODEBASE VALUE="./">');
	document.writeln('<PARAM NAME=ARCHIVE VALUE="'+contextRoot+'/ext/util/xdownloader.jar">');
	document.writeln('<PARAM NAME=NAME VALUE="InnoFD">');
	document.writeln('<PARAM NAME="type" VALUE="application/x-java-applet;version=1.6">');
	document.writeln('<PARAM NAME="scriptable" VALUE="true">');
	
	if ( _ie == true )
	{
		document.write('</OBJECT>');
	}
	else if (_ns == true && _ns6 == false)
	{
		document.write('</NOEMBED></EMBED>');
	}
	else
	{
		document.write('</APPLET>');
	}
}