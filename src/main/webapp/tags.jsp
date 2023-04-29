<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.entity.*"%>
<%@ page import="com.shrineoflostsecrets.datastore.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.google.appengine.api.users.*" %>

<%
UserService userService = UserServiceFactory.getUserService();
User currentUser = userService.getCurrentUser();
DungonMaster dm = DungonMasterList.getDungonMaster(currentUser);

long startDate = Constants.BEGININGOFTIME;
long endDate = Constants.ENDOFTIME;
String world = Constants.HOME;
String relm = Constants.MEN;
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

SOLSCalendar startCal = new SOLSCalendar(startDate);
SOLSCalendar endCal = new SOLSCalendar(endDate);
endCal = startCal.endMustBeAfter(endCal);

	List<Entity> entities = EventsList.listEvents(startCal, endCal, world, relm, dm, tag);
	
	TagRepo repo = new TagRepo(entities.size());
	// Loop through the list of entities and print their property values
		for (Entity entity : entities) {
	Event event = new Event();
	event.loadFromEntity(entity);
	repo.addTags(event.getTags());
		}
		Iterator<String> it = tag.iterator();
		while(it.hasNext()){
	repo.getRepo().remove(it.next());

		}
%><%=repo.toJSON() %>