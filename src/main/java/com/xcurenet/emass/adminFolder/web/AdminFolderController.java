import com.xcurenet.common.vo.XcnResponseVO;
import com.xcurenet.emass.adminFolder.service.AdminFolderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@Controller
public class AdminFolderController {

	@Resource(name = "adminFolderService")
	public AdminFolderService adminFolderService;
//
//	@Autowired
//	private AuditService auditService;
//
//	private static final String ENTER = "┌";
//
//	@RequestMapping(value = "/getFolderDataList.xcn")
//	@Description("EDC Solr 메시지 검색")
//	@ResponseBody
//	public XcnResponseVO getFolderDataList(final HttpServletRequest request, final HttpSession session) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String folder_seq = Common.nvl(param.get("folder_seq"));
//		String folder_name = Common.nvl(param.get("folder_name"));
//		AdminFolderMessageVO msg = new AdminFolderMessageVO();
//		msg.setFolderSeq(folder_seq);
//		SolrEdcMessageVO rtnSolrVo = new SolrEdcMessageVO();
//		List<SolrEdcVO> emass = new ArrayList<>();
//
//		int queryBreak = 500;
//		List<AdminFolderMessageVO> msgs = adminFolderService.getUserFolderMessage(msg);
//
//		StringBuffer query = new StringBuffer();
//		for( int i=0; i<msgs.size(); i++) {
//			AdminFolderMessageVO fmsg = msgs.get(i);
//			query.append(Common.nvl(fmsg.getMsgId())).append(" ");
//
//			if( (i % queryBreak == 0 && i>0) || msgs.size() == (i+1)) {
//
//				SolrCreateQuery solrCreateQuery = new SolrCreateQuery();
//				SolrQuery sq = solrCreateQuery.createQuery("+msgid : ("+query.toString() + ")");
//				sq.setStart(Common.nvz(param.get("offset"), 0));
//				sq.setRows(queryBreak);
//				sq.setSort(SortClause.desc("ctime"));
//
//				SolrEdcMessageVO solrVo = solrEdcService.getEmassMessage(sq, Common.getAdminId(session) );
//				List<SolrEdcVO> userList = solrVo.getEmass();
//				if(userList == null) {
//
//				}else {
//					for (int j = 0; j < userList.size(); j++) {
//						SolrEdcVO userobj = userList.get(j);
//						for (int k = 0; k < msgs.size(); k++) {
//							AdminFolderMessageVO usermsgObj = msgs.get(k);
//							if( Common.isEmpty(usermsgObj.getConsentNo())) continue;
//							if ( Common.isEquals(userobj.getMsgid(), usermsgObj.getMsgId())) {
//								userobj.setConsentNo(usermsgObj.getConsentNo());
//								userList.set(j, userobj);
//								break;
//							}
//						}
//					}
//					emass.addAll(userList);
//				}
//				query = new StringBuffer();
//			}
//
//
//		}
//
//		rtnSolrVo.setEmass(emass);
//		rtnSolrVo.setNumFound(emass.size());
//
//		AuditRequestVO auditVo = new AuditRequestVO();
//		StringBuffer info = new StringBuffer();
//		info.append("["+Prop.propFormat("java.log.search.msg_list")+"]").append(ENTER);
//		info.append(Prop.propFormat("filterInfo.messageFolder")).append(" : ").append(folder_name);
//
//		auditVo.setPMenuId( ParentMenu.DATA_MONITOR.getParentMenuId() );
//		auditVo.setMenuId( Menu.MESSAGE_INFO.getMenuId() );
//		auditVo.setOperation(Operation.SEARCH.getOperation());
//		auditVo.setInformation(info.toString());
//		auditService.insertAudit(request, auditVo);
//
//		return new XcnResponseVO(XcnRspCode.OK, rtnSolrVo, rtnSolrVo.getNumFound());
//	}
//
	@RequestMapping(value = "/getAdminFolderList.xcn")
	@Description("관리자 메시지 폴더 리스트 조회")
	@ResponseBody
	public XcnResponseVO getAdminFolderList(final HttpServletRequest request, final HttpSession session) throws Exception {
//		JSONObject param = Common.getParam(request);
//		String adminId = Common.getAdminId(session);
//
//		List<AdminFolderVO> users = adminFolderService.getAdminFolderList(adminId, Common.nvl(param.get("searchStr")), request.getContextPath());
//		return new XcnResponseVO(XcnRspCode.OK, users);
		return null;
	}
//
//	@RequestMapping(value = "/insertAdminFolder.xcn")
//	@Description("관리자 메시지 폴더 등록")
//	@ResponseBody
//	public XcnResponseVO insertAdminFolder(final HttpSession session, AdminFolderVO adminFolder) throws Exception {
//		adminFolder.setAdminId(Common.getAdminId(session));
//		return new XcnResponseVO(XcnRspCode.OK, adminFolderService.insertAdminFolder(adminFolder));
//	}
//
//	@RequestMapping(value = "/updateAdminFolder.xcn")
//	@Description("관리자 메시지 폴더 수정")
//	@ResponseBody
//	public XcnResponseVO updateAdminFolder(final HttpSession session, AdminFolderVO adminFolder) throws Exception {
//		adminFolder.setAdminId(Common.getAdminId(session));
//		return new XcnResponseVO(XcnRspCode.OK, adminFolderService.updateAdminFolder(adminFolder));
//	}
//
//	@RequestMapping(value = "/updateFolderStatus.xcn")
//	@Description("관리자 메시지 폴더 상태 변경")
//	@ResponseBody
//	public XcnResponseVO updateFolderStatus(final HttpSession session, AdminFolderVO adminFolder) throws Exception {
//		adminFolder.setAdminId(Common.getAdminId(session));
//		return new XcnResponseVO(XcnRspCode.OK, adminFolderService.updateFolderStatus(adminFolder));
//	}
//
//	@RequestMapping(value = "/deleteAdminFolder.xcn")
//	@Description("관리자 메시지 폴더 삭제")
//	@ResponseBody
//	public XcnResponseVO deleteAdminFolder(final HttpServletRequest request) throws Exception {
//		String adminId = Common.getAdminId(request);
//		String FolderData = Common.nvl(request.getParameter("folderData"));
//		JSONArray data = Common.toJSONArray(FolderData);
//		List<AdminFolderVO> folderVos = new ArrayList<>();
//		for (int i = 0; i < data.size(); i++) {
//			AdminFolderVO folderVo = (AdminFolderVO) JSONObject.toBean(data.getJSONObject(i), AdminFolderVO.class);
//			folderVo.setAdminId(adminId);
//			folderVos.add(folderVo);
//		}
//		int rtnVal = adminFolderService.deleteAdminFolder(folderVos);
//		if( rtnVal == -1) {
//			return new XcnResponseVO(XcnRspCode.SYSTEM_ERROR);
//		}else {
//			return new XcnResponseVO(XcnRspCode.OK);
//		}
//	}
//
//	@RequestMapping(value = "/updateFolderOrder.xcn")
//	@Description("관리자 메시지 폴더 위치 이동")
//	@ResponseBody
//	public XcnResponseVO updateFolderOrder(final HttpServletRequest request) throws Exception {
//		String adminId = Common.getAdminId(request);
//		String folderData = Common.nvl(request.getParameter("folderData"));
//		JSONArray data = Common.toJSONArray(folderData);
//
//		List<AdminFolderVO> folderVos = new ArrayList<>();
//		for (int i = 0; i < data.size(); i++) {
//			AdminFolderVO folderVo = (AdminFolderVO) JSONObject.toBean(data.getJSONObject(i), AdminFolderVO.class);
//			folderVo.setAdminId(adminId);
//			folderVos.add(folderVo);
//		}
//		adminFolderService.updateFolderOrder(folderVos);
//		return new XcnResponseVO(XcnRspCode.OK);
//	}
//
//	@RequestMapping(value = "/insertAdminFolderData.xcn")
//	@Description("관리자 메시지 폴더 데이터 등록")
//	@ResponseBody
//	public XcnResponseVO insertAdminFolderData (final AdminFolderMessageVO list, final HttpSession session, final HttpServletRequest request) throws Exception {
//		list.setAdminId(Common.getAdminId(request));
//		return new XcnResponseVO(XcnRspCode.OK, adminFolderService.insertUserFolderMessage(list));
//	}
//
//	@RequestMapping(value = "/deleteAdminFolderData.xcn")
//	@Description("관리자 메시지 폴더 데이터 삭제")
//	@ResponseBody
//	public XcnResponseVO deleteAdminFolderData (final AdminFolderMessageVO list, final HttpSession session, final HttpServletRequest request) throws Exception {
//		list.setAdminId(Common.getAdminId(request));
//		return new XcnResponseVO(XcnRspCode.OK, adminFolderService.deleteUserFolderMessage(list));
//	}
//
//	@SuppressWarnings("unchecked")
//	@RequestMapping(value = "/changeAdminFolderData.xcn")
//	@Description("관리자 메시지 폴더 데이터 이동")
//	@ResponseBody
//	public XcnResponseVO changeAdminFolderData (final AdminFolderMessageVO list, final HttpSession session, final HttpServletRequest request) throws Exception {
//		list.setAdminId(Common.getAdminId(request));
//		List<AdminFolderMessageVO> duplicateList = adminFolderService.getAdminFolderMessage(list);
//		List<String> msgids = new ArrayList<String>(Arrays.asList(list.getMsgIds()));
//
//		if(!duplicateList.isEmpty()) {
//			String result = "";
//
//			for(AdminFolderMessageVO data : duplicateList) {
//				if(msgids.contains(data.getMsgId())) msgids.remove(data.getMsgId());
//			}
//
//			result = msgids.toString().replaceAll("\\[", "").replaceAll("\\]", "").replaceAll(" ", "");
//
//			if(Common.isEmpty(result)) return new XcnResponseVO(XcnRspCode.OK_CUSTOM).setMessage(Prop.propFormat("filterInfo.moveMsgFolderSameDataMsg", Common.getLocale(session)));
//
//			list.setMsgIds(result);
//			return new XcnResponseVO(XcnRspCode.OK_CUSTOM, adminFolderService.updateUserFolderMessage(list)).setMessage(Prop.propFormat("filterInfo.moveMsgFolderSameDataMsg2", Common.getLocale(session), duplicateList.size(), msgids.size()));
//		} else {
//			return new XcnResponseVO(XcnRspCode.OK, adminFolderService.updateUserFolderMessage(list));
//		}
//	}
}
