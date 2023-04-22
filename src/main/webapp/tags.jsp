<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.entity.Event"%>
<%@ page import="com.shrineoflostsecrets.datastore.EventsList"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.shrineoflostsecrets.constants.Constants"%>
<%@ page import="com.shrineoflostsecrets.constants.JspConstants"%>
<%@ page import="com.shrineoflostsecrets.util.SOLSCalendar"%>
<%@ page import="com.shrineoflostsecrets.util.TagRepo"%>
<%@ page import="java.util.*"%>

<%
//5635008819625984l
long startDate = Constants.BEGININGOFTIME;
long endDate = Constants.ENDOFTIME;
String world = Constants.HOME;
String relm = Constants.MEN;
String user = Constants.UNIVERSALUSER;
Set<String> tag = new HashSet<String>();


if (null != request.getParameter(JspConstants.START) && request.getParameter(JspConstants.START).length() > 0) {
	startDate = Long.parseLong(request.getParameter(JspConstants.START));
}
if (null != request.getParameter(JspConstants.END) && request.getParameter(JspConstants.END).length() > 0) {
	endDate = Long.parseLong(request.getParameter(JspConstants.END));
}
if (null != request.getParameter(JspConstants.WORLD) && request.getParameter(JspConstants.WORLD).length() > 0) {
	world = (String) request.getParameter(JspConstants.WORLD);
}
if (null != request.getParameter(JspConstants.RELM) && request.getParameter(JspConstants.RELM).length() > 0) {
	relm = (String) request.getParameter(JspConstants.RELM);
}
if (null != request.getParameter(JspConstants.TAGS) && request.getParameter(JspConstants.TAGS).length() > 0) {
	List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGS));
	tag.addAll(list);	
}
if (null != request.getParameter(JspConstants.USER) && request.getParameter(JspConstants.USER).length() > 0) {
	user = (String) request.getParameter(JspConstants.USER);
}

	List<Entity> entities = EventsList.listEvents(startDate, endDate, world, relm, user, tag);
	TagRepo repo = new TagRepo(entities.size());
	// Loop through the list of entities and print their property values
		for (Entity entity : entities) {
			Event event = new Event();
			event.loadEvent(entity);
			repo.addTags(event.getTags());
		}
		Iterator<String> it = tag.iterator();
		while(it.hasNext()){
			repo.getRepo().remove(it.next());

		}
		%><%=repo.toJSON() %>