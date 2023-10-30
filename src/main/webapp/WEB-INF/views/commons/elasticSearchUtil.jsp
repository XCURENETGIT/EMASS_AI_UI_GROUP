<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/fragments/baseScript.jsp"%>


<script type="javascript">

  $(document).ready(function() {

    var elsQuery = {
      init : function (){
        /*#################### 필드 ####################*/

        /*서비스*/
        var service = ["service.svc","service.sv1","service.svc2","service.svc12","service.svc3"];

        /*수/발신*/
        var direction_svc = ["direction_svc"];
        /*업무시간구분*/
        var work = ["user.work"];
        /*사업장명*/
        var businm = ["user.businm"];
        /*부서명*/
        var deptnm = ["user.deptnm"];
        /*URL*/
        var url = ["http.host"];

        /*발신자*/
        var sender = ["sender.name","network.srcip"];

        /*수신자*/
        var sender = ["mail.to.[name]","network.dstip"];

        /*수신자 2*/
        var ccSender = ["mail.cc.[name]","mail.bcc.[name]"];

        /*OCR*/
        /*수신자 구분*/
        var allofus = ["allofus"];

        /*첨부 여부*/
         var attached = ["attachcnt"];

        /*실제 존재*/
         var attachexistcnt = ["attachexistcnt"];

        /*DRM*/
         var drm = ["attach.[drm]"];

        /*예약어*/
         var kwd = ["kwd_info.[kwd]","kwd_info.[kwds]"];

        /*패턴*/
         var pi = ["pi.total","pi.[code]"];

        /*사용자*/
        var user = ["user.id","user.name"];

        /*사용자 그룹*/

        /*관심 사용자 그룹*/

        /*크기 (전체,본문,첨부파일)  */
        var size = ["size","body_size","attachSize"];

        /*KNOX 메일 종류*/
        var mailType = ["xmsgkey"];

        var _this = this;
      },
      test : function (){

      }

    }

    elsQuery.init();
  })



</script>