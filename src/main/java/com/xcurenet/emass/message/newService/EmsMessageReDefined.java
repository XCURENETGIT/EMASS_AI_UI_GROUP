package com.xcurenet.emass.message.newService;


import com.xcurenet.config.service.ConfigAdminService;
import com.xcurenet.emass.message.service.EmsRecvVO;
import com.xcurenet.emass.message.vo.emass.mongo.EmassMessage;
import com.xcurenet.emass.message.vo.emass.mongo.EmassMessageResponse;
import com.xcurenet.minio.MinioFileAdapter;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/* mongo Db */
@Component
public class EmsMessageReDefined {

    @Resource
    public ConfigAdminService configAdminService;

    @Resource
    public MinioFileAdapter minioFileAdapter;



    public EmassMessageResponse reDefined(EmassMessage emassMessage) throws IOException {
        EmassMessageResponse responses = new EmassMessageResponse();

        responses.setSubject(emassMessage.getSubject());
        responses.setAllOfUs("Wefwefwe");

        /*############ w#############*/
         //제목
         //분류

        /*####################################*/
        /*############ 메시지 사용자 정보 #############*/
        //출발지 IP
        //날짜
        //목적지 IP
        //크기
        //사용자
        //보낸사람 (아이피)
        //실제 사업장 실제 부서
        //HOST/PATH
        /*####################################*/

//			// 예약어
//			if (!Common.isEmpty(emassMessage.getKwdInfo()) && Common.isEquals(emassMessage.getKwdInfo().getKwd(), "Y")) {
//				List<EmsKeywordVO> emsKeywordVOList = this.getEmassKeyword(msgId);
//				for (int i = 0; i < emsKeywordVOList.size(); i++) {
//					EmsKeywordVO emsKeywordVO = emsKeywordVOList.get(i);
//					String type = emsKeywordVO.getType();
//					String keyword = emsKeywordVO.getKeyword();
//					if (Common.isEquals(type, "A")) {
////						if (Common.isEmpty(emassMessage.getAttach())) emassMessage.setAttach(keyword);
////						else emassMessage.setAttachStr(emassMessage.getAttachStr() + ", " + keyword);
//					} else if (Common.isEquals(type, "F")) {
//						if (Common.isEmpty(emassMessage.getFileName())) emassMessage.setFileName(keyword);
//						else emassMessage.setFileName(emassMessage.getFileName() + ", " + keyword);
//					} else if (Common.isEquals(type, "S")) {
//						if (Common.isEmpty(emassMessage.getSubject())) emassMessage.setSubject(keyword);
//						else emassMessage.setSubject(emassMessage.getSubject() + ", " + keyword);
//					} else if (Common.isEquals(type, "B")) {
////						if (Common.isEmpty(emassMessage.getBody())) emassMessage.setBody(keyword);
////						else emassMessage.setBodyStr(emassMessage.getBodyStr() + ", " + keyword);
//					}
//				}
//			}


        //	RecvVo_Mgo  users = this.getEmassUserInfo(msgId);
        List<EmsRecvVO> userList = new ArrayList<>();
        List<EmsRecvVO> senderList = new ArrayList<>();
        List<EmsRecvVO> recvsList = new ArrayList<>();
        List<EmsRecvVO> toList = new ArrayList<>();
        List<EmsRecvVO> ccList = new ArrayList<>();
        List<EmsRecvVO> bccList = new ArrayList<>();


//        ConfigAdminVO configAdminVO = configAdminService.getConfAdmin(Config.USER_FORMAT, adminId);
//        if (configAdminVO == null || Common.isEmpty(configAdminVO.getVal())) {
//            configAdminVO = new ConfigAdminVO();
//            configAdminVO.setVal(Config.getString(Config.USER_FORMAT, "#name#/#email#/#businm#/#deptnm#/#jikgubnm#/#ip#"));
//        }
//			String formatval = configAdminVO.getVal();
//			log.info("Message : " + emassMessage);
//			for (int i = 0; i < users.size(); i++) {
//				ComProperties_Mgo u = EmsReDefined.reUserIp(users.get(i)., Common.nvl(emassMessage.getNetwork().getSrcIp()), Common.nvl(emassMessage.getNetwork().getDstIp()), Common.nvl(emassMessage.getUsrIp()));
//				if (Common.isEquals(u.getUType(), "U")) {
//					u.setEMail(EmsReDefined.reUserEmail(users.get(i), Common.nvl(emassMessage.getUser())));
//					u.setViewStr(EmsReDefined.reUser(u, formatval));
//					userList.add(u);
//				} else if (Common.isEquals(u.getUType(), "F")) {
//					u.setEMail(EmsReDefined.reUserEmail(users.get(i), Common.nvl(emassMessage.getSender())));
//					u.setViewStr(EmsReDefined.reUser(u, formatval));
//					senderList.add(u);
//				} else if (Common.isEquals(u.getUType(), "T")) {
//					u.setEMail(EmsReDefined.reUserEmail(users.get(i)));
//					u.setViewStr(EmsReDefined.reUser(u, formatval));
//					recvsList.add(u);
//					toList.add(u);
//				} else if (Common.isEquals(u.getUType(), "C")) {
//					u.setEMail(EmsReDefined.reUserEmail(users.get(i)));
//					u.setViewStr(EmsReDefined.reUser(u, formatval));
//					recvsList.add(u);
//					ccList.add(u);
//				} else if (Common.isEquals(u.getUType(), "B")) {
//					u.setEMail(EmsReDefined.reUserEmail(users.get(i)));
//					u.setViewStr(EmsReDefined.reUser(u, formatval));
//					recvsList.add(u);
//					bccList.add(u);
//				}
//			}
//			emassMessage.setUserList(userList);
//			emassMessage.setSenderList(senderList);
//			emassMessage.setRecvsList(recvsList);
//			emassMessage.setToList(toList);
//			emassMessage.setCcList(ccList);
//			emassMessage.setCcList(bccList);


//        if (Common.isNotEmpty(emassMessage.getUser())) {
//            emassMessage.getUser().setIpBusiNm(Common.nvl(getIpBusiNm(emassMessage.getUser().getIpBusiCd())).equals("") ? "unknown" : getIpBusiNm(emassMessage.getUser().getIpBusiCd()));
//            emassMessage.getUser().setIpDeptNm(Common.nvl(getIpDeptNm(emassMessage.getUser().getIpDeptCd())).equals("") ? "unknown" : getIpDeptNm(emassMessage.getUser().getIpDeptCd()));
//        }else {
//            emassMessage.setUser(new UserVo_Mgo());
//            emassMessage.getUser().setIpBusiCd("");
//            emassMessage.getUser().setIpDeptCd("");
//        }
//
//        //	emassMessage.setFileName(getEmassAttachInfoConsent(msgId, firstAdminYn, adminType));
//        emassMessage.setPi(this.getEmassPattern(msgId));
             responses.setConsentFlag(emassMessage.isConsentFlag());

        return responses;
    }
}
