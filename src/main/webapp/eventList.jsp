<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
if (null != request.getParameter(JspConstants.RELM) && request.getParameter(JspConstants.RELM).length() > 0) {
	relm = (String) request.getParameter(JspConstants.RELM);
}
if (null != request.getParameter(JspConstants.WORLD) && request.getParameter(JspConstants.WORLD).length() > 0) {
	world = (String) request.getParameter(JspConstants.WORLD);
}
if (null != request.getParameter(JspConstants.USER) && request.getParameter(JspConstants.USER).length() > 0) {
	user = (String) request.getParameter(JspConstants.USER);
}
if (null != request.getParameter(JspConstants.TAGS) && request.getParameter(JspConstants.TAGS).length() > 0) {
	List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGS));
	for (String str : list) {
		tag.add(str.toLowerCase());
	}
}

TagRepo repo = new TagRepo();
%>
<!DOCTYPE html>
<html>
<style>
table, th, td {
	border: 1px solid black;
}
</style>
<head>
<meta charset="UTF-8">
<title>EventList</title>
</head>
<body>
	<a href="/prayAtTheShrine.jsp">Pray at the Shrine</a>

	<%
	List<Entity> entities = EventsList.listEvents(startDate, endDate, world, relm, user, tag);
	%>

	Entries:<%=entities.size()%>
	<table>
		<tr>
			<th>Key</th>
			<th>Event Date<br>Month, Day, Year(Season)</th>
			<th>Title</th>
			<th>Tags</th>
			<th>Short Desc</th>
		</tr>
		<%
		// Loop through the list of entities and print their property values
		for (Entity entity : entities) {
			Event event = new Event();
			event.loadEvent(entity);
			SOLSCalendar cal = new SOLSCalendar(event.getEventDate());
			repo.addTags(event.getTags());
		%>
		<tr>
			<td><a href="/eventDetails.jsp?<%= JspConstants.ID %>=<%=event.getKeyString()%>"><%=event.getKeyString()%></a></td>
			<td><%=cal.getDisplayDate()%></td>
			<td><%=event.getTitle()%></td>
			<td><%=event.getTagsString()%></td>
			<td><%=event.getShortDesc()%></td>
		</tr>
		<%
		}
		%>
	</table>
	
	<form method="post" action="eventList.jsp">
		StartDate:<input name="<%=JspConstants.START%>"
			value="<%=startDate%>"><br>
		EndDate:<input name="<%=JspConstants.END%>"
			value="<%=endDate%>"><br>
		World:<input name="<%=JspConstants.WORLD%>"
			value="<%=world%>">Relm:<input
			name="<%=JspConstants.RELM%>" value="<%=relm%>"><br>User:<input
			name="<%=JspConstants.USER%>" value="<%=user%>"><br>
			<br> Tag:<input
			name="<%=JspConstants.TAGS%>" value="<%=tag%>">
		<input type="submit">
	</form>
	<%=repo.toJSON() %>
</body>
</html>