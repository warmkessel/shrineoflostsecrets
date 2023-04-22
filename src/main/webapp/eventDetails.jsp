<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.entity.Event"%>
<%@ page import="com.shrineoflostsecrets.constants.JspConstants"%>
<%@ page import="com.shrineoflostsecrets.constants.AIConstants"%>
<%@ page import="com.shrineoflostsecrets.ai.AIManager"%>
<%@ page import="com.shrineoflostsecrets.constants.Constants"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Event Details</title>
</head>
<body><%
	//5635008819625984l
	String id = (String) request.getParameter(JspConstants.ID);
	Event event = new Event();
	if (null != id && id.length() > 0) {
		event.loadEvent(new Long(id).longValue());
	}
	long eventDate = 0;
/* 	String kingdom = (String) request.getParameter(JspConstants.KINGDOM);
 */	String world = (String) request.getParameter(JspConstants.WORLD);
	String relm = (String) request.getParameter(JspConstants.RELM);
	Set<String> tag = new HashSet<String>();
	Set<String> tags = new HashSet<String>();
	String title = (String) request.getParameter(JspConstants.TITLE);
	String compactDesc = (String) request.getParameter(JspConstants.COMPACTDESC);
	String shortDesc = (String) request.getParameter(JspConstants.SHORTDESC);
	String longDesc = (String) request.getParameter(JspConstants.LONGDESC);
	String deleted = (String) request.getParameter(JspConstants.DELETED);
	String bookmarked = (String) request.getParameter(JspConstants.BOOKMARKED);
	String user = Constants.UNIVERSALUSER;
	if (null != request.getParameter(JspConstants.USER) && request.getParameter(JspConstants.USER).length() > 0) {
		user = (String) request.getParameter(JspConstants.USER);
	}
	
	boolean dirty = false;
	
	if(null != request.getParameter(JspConstants.DIRTY) && request.getParameter(JspConstants.DIRTY).length() > 0){
		dirty=true;
	}
	if (null != request.getParameter(JspConstants.END) && request.getParameter(JspConstants.END).length() > 0) {
		eventDate = Long.parseLong(request.getParameter(JspConstants.END));
		event.setEventDate(eventDate);
		dirty = true;

	}
	
	if (null != request.getParameter(JspConstants.WORLD) && request.getParameter(JspConstants.WORLD).length() > 0) {
		world = (String) request.getParameter(JspConstants.WORLD);
		event.setWorld(world);
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.RELM) && request.getParameter(JspConstants.RELM).length() > 0) {
		relm = (String) request.getParameter(JspConstants.RELM);
		event.setRelm(relm);
		dirty = true;
	}
	/* if (null != request.getParameter(JspConstants.KINGDOM) && request.getParameter(JspConstants.KINGDOM).length() > 0) {
		kingdom = (String) request.getParameter(JspConstants.KINGDOM);
		event.setKingdom(kingdom);
		dirty = true;
	} */
	if (null != request.getParameter(JspConstants.TAGS) && request.getParameter(JspConstants.TAGS).length() > 0) {
		List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGS));
		for (String str : list) {
			String[] theSubList = str.toLowerCase().split(" ");
			for(int x=0; x < theSubList.length;x++){
				tag.add(theSubList[x]);
			}
		}
		event.setTags(tag);
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.TITLE) && request.getParameter(JspConstants.TITLE).length() > 0) {
		title = (String) request.getParameter(JspConstants.TITLE);
		event.setTitle(title);
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.COMPACTDESC)
			&& request.getParameter(JspConstants.COMPACTDESC).length() > 0) {
		compactDesc = (String) request.getParameter(JspConstants.COMPACTDESC);
		event.setCompactDesc(compactDesc);
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.SHORTDESC) && request.getParameter(JspConstants.SHORTDESC).length() > 0) {
		shortDesc = (String) request.getParameter(JspConstants.SHORTDESC);
		event.setShortDesc(shortDesc);
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.LONGDESC) && request.getParameter(JspConstants.LONGDESC).length() > 0) {
		longDesc = (String) request.getParameter(JspConstants.LONGDESC);
		event.setLongDesc(longDesc);
		dirty = true;
	}
	if (event.isDeleted(user) != Boolean.valueOf(request.getParameter(JspConstants.DELETED))) {
		if(Boolean.valueOf(request.getParameter(JspConstants.DELETED)))
			event.setDeleted(user);
		else{
			event.setUnDeleted(user);
		}
		dirty = true;
	}
	if (null != request.getParameter(JspConstants.BOOKMARKED)
			&& request.getParameter(JspConstants.BOOKMARKED).length() > 0) {
		bookmarked = (String) request.getParameter(JspConstants.BOOKMARKED);
		event.setBookmarked(bookmarked);
		dirty = true;
	}
	if (dirty) {
		event.save();
	}
	if(null == relm || relm.length() == 0){
		event.setRelm(Constants.MEN);
	}
	if(null == world || world.length() == 0){
		event.setWorld(Constants.HOME);
	}
	if(null != event.getTagsString() && event.getTagsString().length() > 0){
		tags.addAll(Arrays.asList(event.getTagsString().toLowerCase().split(" ")));
	}

	%>
	<script>
function prayAtTheShrine(instruction, target) {
	const targetName = document.getElementsByName(target)[0];
	const shortDescName = document.getElementsByName('<%=JspConstants.SHORTDESC%>')[0];
	const longDescName = document.getElementsByName('<%=JspConstants.LONGDESC%>')[0];

	let input = shortDescName.value || longDescName.value || '';
	prayAtTheShrineInput(instruction, input, target)
}
function prayAtTheShrineInput(instruction, input, target) {
  document.getElementsByName(target)[0].value = "Loading...";
  var xhr = new XMLHttpRequest();
  xhr.open("POST", "<%=URLBuilder.buildRequest(request, JspConstants.PRAY, 0l, eventDate, world, relm, user, tag)%>", true);
  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhr.onreadystatechange = function() {
	  if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
		  document.getElementsByName(target)[0].value = xhr.responseText.trim();
    }
  };
  var param = ""
  if(instruction.length > 0){
	  param = "<%=JspConstants.COMMAND%>=" + instruction + "&";
  }
  if(input.length > 0){
	  param = param + "<%=JspConstants.INPUT%>=" + input;
	}
	xhr.send(param);
	}
</script>
	<a href="/eventList.jsp">List</a><br>
	
	<a href="<%=URLBuilder.buildRequest(request, JspConstants.EVENTDETAILS, 0l,  Long.valueOf(event.getEventDate() + Math.round((Math.random() * 500))), world, relm,
		user, tags)%>">New Event</a>
	
	<form method="post" action="eventDetails.jsp">
		<input type=hidden name="<%=JspConstants.ID%>"
			value="<%=event.getKeyString()%>"><input type=hidden name="<%=JspConstants.USER%>"
			value="<%=user%>">Key:<a
			href="/eventDetails.jsp?<%=JspConstants.ID%>=<%=event.getKeyString()%>"><%=event.getKeyString()%></a><br>
		CreatedDate:<%=event.getCreatedDate()%><br> UpdatedDate:<%=event.getUpdatedDate()%><br>
		Revision:<%=event.getRevision()%><br> UserId:<%=event.getUserId()%><br>
		EventDate:<input name="<%=JspConstants.END%>"
			value="<%=event.getEventDate()%>"><br> 
		World:<input name="<%=JspConstants.WORLD%>"
			value="<%=event.getWorld()%>"><br>Relm:<input
			name="<%=JspConstants.RELM%>" value="<%=event.getRelm()%>"><br> Tag:<textarea name="<%=JspConstants.TAGS%>" rows="5" cols="100"><%=event.getTagsString()%></textarea><input type="button"
			onClick='prayAtTheShrine("AITAGS", "<%=JspConstants.TAGS%>")'
			value="Generate Tags"><br>
		Title:<input name="<%=JspConstants.TITLE%>"
			value="<%=event.getTitle()%>" size=50 maxlength="1500"> <input type="button"
			onClick='prayAtTheShrine("AITITLE", "<%=JspConstants.TITLE%>")'
			value="Generate Title"><br> CompactDesc:<textarea name="<%=JspConstants.COMPACTDESC%>" rows="10" cols="100" maxlength="1500"><%=event.getCompactDesc()%></textarea><input type="button"
			onClick='prayAtTheShrine("AICOMPACTDESC", "<%=JspConstants.COMPACTDESC%>")'
			value="Generate Compact Desc"><br> ShortDesc:
		<textarea name="<%=JspConstants.SHORTDESC%>" rows="15" cols="100" maxlength="1500"><%=event.getShortDesc()%></textarea><input type="button"
			onClick='prayAtTheShrine("AISHORTDESC", "<%=JspConstants.SHORTDESC%>")'
			value="Generate Short Desc">
		<br> LongDesc:
		<textarea name="<%=JspConstants.LONGDESC%>" rows="20" cols="100"><%=event.getLongDesc()%></textarea><input type="button"
			onClick='prayAtTheShrine("AILONGDESC", "<%=JspConstants.LONGDESC%>")'
			value="Generate Long Desc">
		<br> Deleted:<input type="checkbox"
			name=<%=JspConstants.DELETED%> value="true"
			<%=((event.isDeleted(user)) ? "checked" : "")%>><br>
		Bookmarked:<input type="checkbox" name=<%=JspConstants.BOOKMARKED%>
			value="true" <%=((event.isBookmarked()) ? "checked" : "")%>><br>
			<input type="button"
			onClick='prayAtTheShrine("AIGENERATEEVENT", "<%=JspConstants.LONGDESC%>")'
			value="Generate Event">
		<input type="submit">
	</form>


</body>
</html>

