package com.xcurenet.code.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.xcurenet.code.service.CodeService;
import com.xcurenet.code.service.CodeVO;
import com.xcurenet.common.dao.XcnAbstractDAO;
import com.xcurenet.common.util.Common;

@Service("codeService")
public class CodeServiceImpl extends XcnAbstractDAO implements CodeService {

	@Override
	public List<CodeVO> getCodeList(CodeVO code) {
		if (Common.isEquals(code.getCodeType(), "co")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeCoList", code);
		} else if (Common.isEquals(code.getCodeType(), "general")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeGeneralList", code);
		} else if (Common.isEquals(code.getCodeType(), "busi")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeBusiList", code);
		} else if (Common.isEquals(code.getCodeType(), "deptByCo")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeptList", code);
		} else if (Common.isEquals(code.getCodeType(), "dept")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeptList", code);
		} else if (Common.isEquals(code.getCodeType(), "service")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeSvcList", code);
		} else if (Common.isEquals(code.getCodeType(), "regexp")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodePatternList", code);
		} else if (Common.isEquals(code.getCodeType(), "attach")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeAttachList", code);
		} else if (Common.isEquals(code.getCodeType(), "keyword")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeKwdList", code);
		} else if (Common.isEquals(code.getCodeType(), "jikgub")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeJikgubList", code);
		} else if (Common.isEquals(code.getCodeType(), "jikin")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeJikinList", code);
		} else if (Common.isEquals(code.getCodeType(), "senders") || Common.isEquals(code.getCodeType(), "receivers") || Common.isEquals(code.getCodeType(), "user")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeUserList", code);
		}
		
		return new ArrayList<CodeVO>();
	}

	@Override
	public List<CodeVO> getCodeListAll(CodeVO code) {
		if (Common.isEquals(code.getCodeType(), "co")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeCoListAll", code);
		} else if (Common.isEquals(code.getCodeType(), "busi")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeBusiListAll", code);
		} else if (Common.isEquals(code.getCodeType(), "service")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeSvcListAll", code);
		} else if (Common.isEquals(code.getCodeType(), "regexp")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodePatternListAll", code);
		} else if (Common.isEquals(code.getCodeType(), "device")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeviceListAll", code);
		} else if(Common.isEquals(code.getCodeType(),"readAuth")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getUserCodeGroupListAll", code);
		}
		//부서권한
//		 else if (Common.isEquals(code.getCodeType(), "dept")) {
//				return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getCodeDeptListAll", code);
//		}
		
		return new ArrayList<CodeVO>();
	}

	@Override
	public List<CodeVO> getAdminCodeList(CodeVO code) {
		if (Common.isEquals(code.getCodeType(), "co")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodeCoList", code);
		} else if (Common.isEquals(code.getCodeType(), "busi")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodeBusiList", code);
		}  else if (Common.isEquals(code.getCodeType(), "dept")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodeDeptList", code);
		} else if (Common.isEquals(code.getCodeType(), "service")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodeSvcList", code);
		} else if (Common.isEquals(code.getCodeType(), "regexp")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodePatternList", code);
		} else if (Common.isEquals(code.getCodeType(), "menu")) {
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getAdminCodeMenuList", code);
		} else if (Common.isEquals(code.getCodeType(), "readAuth")) {
			code.setCeoReadAuth(code.getAdminId());
			return selectList("com.xcurenet.sqlmap.mappers.mysql.code.getUserCodeGroupListAll", code);
		}
		return new ArrayList<CodeVO>();
	}

}
