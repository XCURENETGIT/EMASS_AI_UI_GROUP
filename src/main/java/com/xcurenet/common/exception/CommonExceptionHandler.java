//package com.xcurenet.common.exception;
//
//import com.xcurenet.common.vo.XcnResponseVO;
//import com.xcurenet.common.vo.XcnRspCode;
//import org.apache.catalina.connector.ClientAbortException;
//import org.apache.ibatis.javassist.NotFoundException;
//import org.mybatis.spring.MyBatisSystemException;
//import org.springframework.dao.DataIntegrityViolationException;
//import org.springframework.web.bind.MissingServletRequestParameterException;
//import org.springframework.web.bind.WebDataBinder;
//import org.springframework.web.bind.annotation.ControllerAdvice;
//import org.springframework.web.bind.annotation.ExceptionHandler;
//import org.springframework.web.bind.annotation.InitBinder;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import javax.servlet.http.HttpServletResponse;
//
//@ControllerAdvice("com.xcurenet")
//public class CommonExceptionHandler {
//
//	public final static int SC_NETWORK_READ_TIMEOUT_ERROR = 599;
//	public final static int SC_DATABASE_READ_TIMEOUT_ERROR = 800;
//
//	@InitBinder
//	public void setAllowedFields(WebDataBinder dataBinder) {
//		String[] denylist = new String[]{"class.*", "Class.*", "*.class.*", "*.Class.*"};
//		dataBinder.setDisallowedFields(denylist);
//	}
//
//	@ExceptionHandler(Exception.class)
//	@ResponseBody
//	public XcnResponseVO handleException(Exception e, HttpServletResponse response) {
//		e.printStackTrace();
//		return new XcnResponseVO(XcnRspCode.SYSTEM_ERROR).status(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, response);
//	}
//
//	@ExceptionHandler(MyBatisSystemException.class)
//	@ResponseBody
//	public XcnResponseVO handleNotFoundException(MyBatisSystemException e, HttpServletResponse response) {
//		e.printStackTrace();
//		return new XcnResponseVO(XcnRspCode.DATABASE_CONNECT_FAIL).status(SC_DATABASE_READ_TIMEOUT_ERROR, response);
//	}
//
//
//	@ExceptionHandler(ClientAbortException.class)
//	@ResponseBody
//	public void handleClientAbortException(ClientAbortException e, HttpServletResponse response) {
//		// Client 요청 취소 에러 관련
//	}
//
//	@ExceptionHandler(NotFoundException.class)
//	@ResponseBody
//	public XcnResponseVO handleNotFoundException(NotFoundException e, HttpServletResponse response) {
//		e.printStackTrace();
//		return new XcnResponseVO(XcnRspCode.NOT_FOUND_PAGE).status(HttpServletResponse.SC_NOT_FOUND, response);
//	}
//
//	@ExceptionHandler(MissingServletRequestParameterException.class)
//	@ResponseBody
//	public XcnResponseVO handleMissingServletRequestParameterException(MissingServletRequestParameterException e, HttpServletResponse response) {
//		e.printStackTrace();
//		return new XcnResponseVO(XcnRspCode.REQUIRED_PARAMETER_ISNOT_PRESENT).status(HttpServletResponse.SC_BAD_REQUEST, response);
//	}
//
////	@ExceptionHandler(SolrServerException.class)
////	@ResponseBody
////	public XcnResponseVO handleSolrServerException(SolrServerException e, HttpServletResponse response) {
////		e.printStackTrace();
////		return new XcnResponseVO(XcnRspCode.SYSTEM_ERROR).status(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, response);
////	}
//
//	@ExceptionHandler(DataIntegrityViolationException.class)
//	@ResponseBody
//	public XcnResponseVO handleDataIntegrityViolationException(DataIntegrityViolationException e, HttpServletResponse response) {
//		e.printStackTrace();
//		return new XcnResponseVO(XcnRspCode.SYSTEM_ERROR).status(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, response);
//	}
//
//}
