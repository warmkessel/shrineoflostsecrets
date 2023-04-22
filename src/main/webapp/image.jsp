<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.ai.AIImageManager"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>
<%
String size = Size.SIZE_1024x1024.getSize();
String input = AIConstants.AIIMAGE + AIConstants.AIGENERICINPUT;

if (null != request.getParameter(JspConstants.SIZE) && request.getParameter(JspConstants.SIZE).length() > 0) {
	size = Size.isValidSize(request.getParameter(JspConstants.SIZE)).getSize(); 
}
if (null != request.getParameter(JspConstants.INPUT) && request.getParameter(JspConstants.INPUT).length() > 0) {
	input = request.getParameter(JspConstants.INPUT);
}
%><%=AIImageManager.buildImage(size, input)%>

    