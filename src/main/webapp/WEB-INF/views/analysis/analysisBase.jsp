<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<script>
		var messageGridColumn = {
			msgid : '<s:message code="common.msg.msgid"/>',
 			epmsg_type : '<s:message code="condition.epmsgType.list"/>',
			xrootmtr : '<s:message code="common.msg.xrootmtr"/>',
			interestUserYn : '<s:message code="message.msg.interest"/>',
			readYn : '<s:message code="condition.read"/>',
			ml_confd_class : '<s:message code="condition.infotype"/>',
			ml_confd_feedback : '<s:message code="condition.feedback"/>',
			ml_confd_prob : '<s:message code="condition.prob"/>',
			attachcnt : '<s:message code="message.msg.file"/>',
			inside : '<s:message code="message.msg.inout"/>',
			msgin : '<s:message code="message.msg.in"/>',
			msgout : '<s:message code="message.msg.out"/>',
			direction_svc : '<s:message code="condition.receive_send"/>',
			receive : '<s:message code="condition.receive"/>',
			send : '<s:message code="condition.send"/>',
			svcNm : '<s:message code="condition.service"/>',
			subject : '<s:message code="condition.subject"/>',
			ctimeFormat : '<s:message code="condition.date"/>',
			user : '<s:message code="common.org.user"/>',
			businm : '<s:message code="common.org.businm"/>',
			deptnm : '<s:message code="common.org.dept"/>',
			jikgubnm : '<s:message code="common.org.jikgub"/>',
			sender : '<s:message code="condition.sender"/>',
			allofus : '<s:message code="condition.allofus"/>',
			recvs : '<s:message code="condition.recv"/>',
			to : '<s:message code="condition.to"/>',
			cc : '<s:message code="condition.cc"/>',
			bcc : '<s:message code="condition.bcc"/>',
			srcip : '<s:message code="condition.source"/>',
			dstip : '<s:message code="condition.destination"/>',
			sizeStr : '<s:message code="condition.size.all"/>',
			bodySizeStr : '<s:message code="condition.size.body"/>',
			attachSizeStr : '<s:message code="condition.size.attach"/>',
			kwds : '<s:message code="condition.keyword"/>',
			pi_total : '<s:message code="condition.regexp"/>',
			ocr : 'OCR <s:message code="message.msg.file"/>',
			attachname: '<s:message code="condition.attach_name"/>'
		}
		var baseMsg1 = '<s:message code="analysis.ui.basemsg1"/>';
		var baseMsg2 = '<s:message code="analysis.ui.basemsg2"/>';
		
		var allofusMsg = {
			IA : '<s:message code="condition.allofus1"/>',
			ET : '<s:message code="condition.allofus8"/>',
			IT : '<s:message code="condition.allofus7"/>',
			EA : '<s:message code="condition.allofus2"/>',
			PT : '<s:message code="condition.allofus9"/>',
			PA : '<s:message code="condition.allofus3"/>',
			SO : '<s:message code="condition.allofus13"/>',
			SI : '<s:message code="condition.allofus14"/>'
		};
		
		var mlConfdClassMsg = {
			C4 : '<s:message code="condition.info.class4"/>',
			C3 : '<s:message code="condition.info.class3"/>',
			C2 : '<s:message code="condition.info.class2"/>',
			C1 : '<s:message code="condition.info.class1"/>',
			C0 : '<s:message code="common.msg.noinfo"/>'
		};
		
		var mlConfdFeedbackMsg = {
			F1 : '<s:message code="condition.info.feedback1"/>',
			F2 : '<s:message code="condition.info.feedback2"/>',
			F3 : '<s:message code="condition.info.feedback3"/>',
			F4 : '<s:message code="condition.info.feedback4"/>',
			F0 : '<s:message code="condition.info.feedback0"/>',
			F9 : '<s:message code="condition.info.feedback9"/>'
		};
		//SK 하이닉스
		var skMlConfdClassMsg = {
			SC2 : '<s:message code="condition.info.Y"/>',
			SC1 : '<s:message code="condition.info.N"/>',
		};
			
		var skMlConfdFeedbackMsg = {
			SF1 : '<s:message code="condition.info.secretFeedbackY"/>',
			SF2 : '<s:message code="condition.info.secretFeedbackN"/>',
		};

		function addMonth2(day) {
			var today = new Date();
			today.setMonth(today.getMonth() + parseInt(day));
			
			return getDate(today);
		}

</script>