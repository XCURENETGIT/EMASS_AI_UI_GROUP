<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<script>
    var messageGridColumn = {
        msgid: '<s:message code="common.msg.msgid"/>',
        userId: '<s:message code="common.msg.id"/>',
        readYn: '<s:message code="condition.read"/>',
        epmsg_type: '<s:message code="condition.epmsgType.list"/>',
        xrootmtr: '<s:message code="common.msg.xrootmtr"/>',
        interestUserYn: '<s:message code="message.msg.interest"/>',
        read_yn: '<s:message code="condition.read"/>',
        ml_confd_class: '<s:message code="condition.infotype"/>',
        ml_confd_feedback: '<s:message code="condition.feedback"/>',
        ml_confd_prob: '<s:message code="condition.prob"/>',
        attachcnt: '<s:message code="message.msg.file"/>',
        inside: '<s:message code="message.msg.inout"/>',
        msgin: '<s:message code="message.msg.in"/>',
        msgout: '<s:message code="message.msg.out"/>',
        direction_svc: '<s:message code="condition.receive_send"/>',
        receive: '<s:message code="condition.receive"/>',
        send: '<s:message code="condition.send"/>',
        svcNm: '<s:message code="condition.service"/>',
        subject: '<s:message code="condition.subject"/>',
        ctimeFormat: '<s:message code="condition.date"/>',
        user: '<s:message code="common.org.user"/>',
        businm: '<s:message code="common.org.businm"/>',
        deptnm: '<s:message code="common.org.dept"/>',
        jikgubnm: '<s:message code="common.org.jikgub"/>',
        sender: '<s:message code="condition.sender"/>',
        allofus: '<s:message code="condition.allofus"/>',
        recvs: '<s:message code="condition.recv"/>',
        to: '<s:message code="condition.to"/>',
        cc: '<s:message code="condition.cc"/>',
        bcc: '<s:message code="condition.bcc"/>',
        srcip: '<s:message code="condition.source"/>',
        dstip: '<s:message code="condition.destination"/>',
        sizeStr: '<s:message code="condition.size.all"/>',
        bodySizeStr: '<s:message code="condition.size.body"/>',
        attachSizeStr: '<s:message code="condition.size.attach.total"/>',
        kwds: '<s:message code="condition.keyword"/>',
        pi_total: '<s:message code="condition.regexp"/>',
        ocr: 'OCR <s:message code="message.msg.file"/>',
        attachname: '<s:message code="condition.attach_name"/>',
        reprocess: '<s:message code="condition.reprocess"/>',
	    sabun: '<s:message code="common.msg.userid"/>'

    }
    var baseMsg1 = '<s:message code="analysis.ui.basemsg1"/>';
    var baseMsg2 = '<s:message code="analysis.ui.basemsg2"/>';

    var allofusMsg = {
        IA : '<s:message code="condition.allofus1"/>',
        ET : '<s:message code="condition.allofus8"/>',
        IT : '<s:message code="condition.allofus7"/>',
        EA : '<s:message code="condition.allofus2"/>',
        PT : '<s:message code="condition.allofus9"/>',
        PA : '<s:message code="condition.allofus3"/>'
    };

    function addMonth2(day) {
        var today = new Date();
        today.setMonth(today.getMonth() + parseInt(day));

        return getDate(today);
    }

</script>