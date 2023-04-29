<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>
<%@ page import="com.shrineoflostsecrets.ai.AIManager"%>
<%@ page import="java.util.*"%>
<%@ page import="com.shrineoflostsecrets.entity.*"%>
<%@ page import="com.shrineoflostsecrets.datastore.*"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.google.appengine.api.users.*" %>


<%

UserService userService = UserServiceFactory.getUserService();
User currentUser = userService.getCurrentUser();
DungonMaster dm = DungonMasterList.getDungonMaster(currentUser);


String input = AIConstants.AIGENERICINPUT;
String instruction = AIConstants.FANTISYTOKEN + AIConstants.AIGENERIC;

long startDate = Constants.BEGININGOFTIME;
long endDate = Constants.ENDOFTIME;
String world = Constants.HOME;
String relm = Constants.MEN;
String error = AIConstants.AIERROR;
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
if (null != request.getParameter(JspConstants.TAGS) && request.getParameter(JspConstants.TAGS).length() > 0) {
	List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGS));
	tag.addAll(list);
}
SOLSCalendar startCal = new SOLSCalendar(startDate);
SOLSCalendar endCal = new SOLSCalendar(endDate);
endCal = startCal.endMustBeAfter(endCal);

if (null != request.getParameter(JspConstants.INPUT) && request.getParameter(JspConstants.INPUT).length() > 0) {
	input = (String) request.getParameter(JspConstants.INPUT);
} else {
	List<Entity> entities = EventsList.listEvents(startCal, endCal, world, relm, dm, tag);
	StringBuffer theInputBuffer = new StringBuffer();

	for (Entity entity : entities) {
		Event event = new Event();
		event.loadFromEntity(entity);
		theInputBuffer.append(event.getCompactDesc());

	}
	input = theInputBuffer.toString();
}
if (null != request.getParameter(JspConstants.INSTURCTION)
		&& request.getParameter(JspConstants.INSTURCTION).length() > 0) {
	instruction = (String) request.getParameter(JspConstants.INSTURCTION);
} else {
	if (null != request.getParameter(JspConstants.COMMAND) && request.getParameter(JspConstants.COMMAND).length() > 0) {
		error = input; 
		String command = (String) request.getParameter(JspConstants.COMMAND);
		switch (command) {
	case "AITAGS":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AITAGS;
		break;
	case "AILONGDESC":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AILONGDESC;
		break;
	case "AICOMPACTDESC":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AICOMPACTDESC;
		break;
	case "AISHORTDESC":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AISHORTDESC;
	break;
	case "AISUMMARY":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AISUMMARY;		
	break;
	case "AISUMMARYPEOPLE":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AISUMMARYPEOPLE;		
	break;
	case "AISUMMARYPLACES":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AISUMMARYPLACES;
		break;
	case "AIADDITIONALDETAILS":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AIADDITIONALDETAILS;
		break;
	case "AIGENERIC":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AIGENERIC;
		break;
	case "AIGENERATEEVENT":
	instruction = AIConstants.FANTISYTOKEN + AIConstants.AIGENERATEEVENT;
	break;
		default:
	instruction = AIConstants.AIGENERIC;
		}
	}
}
%><%=AIManager.editText(input, instruction, error)%>