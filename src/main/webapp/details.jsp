<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.shrineoflostsecrets.entity.*"%>
<%@ page import="com.shrineoflostsecrets.datastore.*"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.shrineoflostsecrets.ai.*"%>
<%@ page import="com.google.appengine.api.users.*"%>
<!DOCTYPE html>
<html>
<head>

<!-- Google tag (gtag.js) -->
<script async="true"
	src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-N2VTBWYNCJ');
</script>
<%
UserService userService = UserServiceFactory.getUserService();
User currentUser = userService.getCurrentUser();
DungonMaster dm = DungonMasterList.getDungonMaster(currentUser);

String id = (String) request.getParameter(JspConstants.ID);
Event event = new Event();
if (null != id && id.length() > 0) {
	event.loadEvent(Long.parseLong(id));
}
long idLong = 0L;
try {
	idLong = Long.parseLong(id);
} catch (NumberFormatException e) {
	idLong = 0L; // Set value to 0 in case of NumberFormatException
}
long eventDate = 0;
long endDate = 0;
long startDate = 0;
String world = Constants.HOME;
String relm = Constants.MEN;
if (null != request.getParameter(JspConstants.RELM) && request.getParameter(JspConstants.RELM).length() > 0) {
	relm = (String) request.getParameter(JspConstants.RELM);
}
if (null != request.getParameter(JspConstants.WORLD) && request.getParameter(JspConstants.WORLD).length() > 0) {
	world = (String) request.getParameter(JspConstants.WORLD);
}

/* 	String kingdom = (String) request.getParameter(JspConstants.KINGDOM);
 */
Set<String> tag = new HashSet<String>();
Set<String> tags = new HashSet<String>();
String title = (String) request.getParameter(JspConstants.TITLE);
String compactDesc = (String) request.getParameter(JspConstants.COMPACTDESC);
String shortDesc = (String) request.getParameter(JspConstants.SHORTDESC);
String longDesc = (String) request.getParameter(JspConstants.LONGDESC);
String deleted = (String) request.getParameter(JspConstants.DELETED);
String bookmarked = (String) request.getParameter(JspConstants.BOOKMARKED);
String promote = (String) request.getParameter(JspConstants.PROMOTE);
String media = (String) request.getParameter(JspConstants.MEDIA);

boolean dirty = false;
boolean edit = false;
boolean save = false;

if (null != request.getParameter(JspConstants.DIRTY) && request.getParameter(JspConstants.DIRTY).length() > 0) {
	dirty = true;
}
if (null != request.getParameter(JspConstants.EDIT) && request.getParameter(JspConstants.EDIT).length() > 0) {
	edit = true;
}
if (null != request.getParameter(JspConstants.SAVE) && request.getParameter(JspConstants.SAVE).length() > 0) {
	save = true;
}
if (null != request.getParameter(JspConstants.START) && request.getParameter(JspConstants.START).length() > 0) {
	startDate = Long.parseLong(request.getParameter(JspConstants.START));
}
if (null != request.getParameter(JspConstants.END) && request.getParameter(JspConstants.END).length() > 0) {
	endDate = Long.parseLong(request.getParameter(JspConstants.END));
	eventDate = startDate + (endDate - startDate)/2;
}

if (null != request.getParameter(JspConstants.EVENTDATE) && request.getParameter(JspConstants.EVENTDATE).length() > 0) {
	eventDate = Long.parseLong(request.getParameter(JspConstants.EVENTDATE));
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
		tag.add(str.toLowerCase());
	}
}
if (null != request.getParameter(JspConstants.TAGINPUT) && request.getParameter(JspConstants.TAGINPUT).length() > 0) {
	List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGINPUT));
	for (String str : list) {
		String[] theSubList = str.toLowerCase().split(" ");
		for (int x = 0; x < theSubList.length; x++) {
	tags.add(theSubList[x]);
		}
	}
	event.setTags(tags);
	dirty = true;
} else if (0 == event.getTags().size()) {
	tags.addAll(tag);
	event.setTags(tags);

}

if (null != request.getParameter(JspConstants.TITLE) && request.getParameter(JspConstants.TITLE).length() > 0) {
	title = (String) CaseControl.cleanHTML(request.getParameter(JspConstants.TITLE));
	event.setTitle(title);
	dirty = true;
}
if (null != request.getParameter(JspConstants.COMPACTDESC)
		&& request.getParameter(JspConstants.COMPACTDESC).length() > 0) {
	compactDesc = (String) CaseControl.cleanHTML(request.getParameter(JspConstants.COMPACTDESC));
	event.setCompactDesc(compactDesc);
	dirty = true;
}
if (null != request.getParameter(JspConstants.SHORTDESC) && request.getParameter(JspConstants.SHORTDESC).length() > 0) {
	shortDesc = (String) CaseControl.cleanHTML(request.getParameter(JspConstants.SHORTDESC));
	event.setShortDesc(shortDesc);
	dirty = true;
}
if (null != request.getParameter(JspConstants.LONGDESC) && request.getParameter(JspConstants.LONGDESC).length() > 0) {
	longDesc = (String) CaseControl.cleanHTML(request.getParameter(JspConstants.LONGDESC));
	event.setLongDesc(longDesc);
	dirty = true;
}
if (event.isDeleted(dm) != Boolean.valueOf(request.getParameter(JspConstants.DELETED))) {
	if (Boolean.valueOf(request.getParameter(JspConstants.DELETED)))
		event.setDeleted(dm);
	else {
		event.setUnDeleted(dm);
	}
	dirty = true;
}
if (null != request.getParameter(JspConstants.BOOKMARKED)
		&& request.getParameter(JspConstants.BOOKMARKED).length() > 0) {
	bookmarked = (String) request.getParameter(JspConstants.BOOKMARKED);
	event.setBookmarked(bookmarked);
	dirty = true;
}

if (currentUser != null && userService.isUserLoggedIn() && userService.isUserAdmin()
		&& null != request.getParameter(JspConstants.MEDIA) && request.getParameter(JspConstants.MEDIA).length() > 0) {
	event.setMedia(media);
	dirty = true;
}
if (currentUser != null && userService.isUserLoggedIn() && userService.isUserAdmin()
		&& null != request.getParameter(JspConstants.PROMOTE)
		&& request.getParameter(JspConstants.PROMOTE).length() > 0) {
	event.setUserId(Constants.UNIVERSALUSER);
	dirty = true;
} else if (save && currentUser != null) {
	event.setUserId(dm.getKeyLong());
	dirty = true;
}

if (dirty && save
		&& (event.getLongDesc().length() == 0 || event.getShortDesc().length() == 0
		|| event.getCompactDesc().length() == 0 || event.getTitle().length() == 0
		|| event.getShortDesc().length() >= 1500 || event.getCompactDesc().length() >= 1500
		|| event.getTitle().length() >= 1500)) {
%>
<script>
	alert("Please check the Detailed Description, Short Description and Shrine Description and title");
	</script>
<%
dirty = false;
}
if (dirty && save && currentUser != null && userService.isUserLoggedIn()
		&& (dm.getKeyLong() == event.getUserId() || userService.isUserAdmin())) {
event.save();
}
if (null == relm || relm.length() == 0) {
event.setRelm(Constants.MEN);
}
if (null == world || world.length() == 0) {
event.setWorld(Constants.HOME);
}

SOLSCalendar startCal = new SOLSCalendar(startDate);
SOLSCalendar endCal = new SOLSCalendar(endDate);
SOLSCalendar eventCal = new SOLSCalendar(eventDate);
endCal = startCal.endMustBeAfter(endCal);
SOLSCalendar.Scale scale = startCal.getScale(endCal);
double totalDays = Double.valueOf(startCal.getElapsedTime(endCal));
%>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="Welcome to the Shrine of Lost Secrets">
<meta name="author" content="warmkessel">
<!-- font icons -->
<link rel="stylesheet"
	href="assets/vendors/themify-icons/css/themify-icons.css">
<!-- Bootstrap + SOLS main styles -->
<link rel="stylesheet" href="assets/css/sols.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<title>Shrine of Lost Secrets - Details</title>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="40" id="home">

	<!-- First Navigation -->
	<nav class="navbar nav-first navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand"
				href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR, "#")%>">
				<img src="assets/imgs/logo-sm.jpg" alt="Shrine of Lost Secrets">
			</a>
			<div class="d-none d-md-block">
				<h6 class="mb-0">
					<a href="https://www.youtube.com/@ShrineofLostSecrets"
						class="px-2" target="_blank"><i class="ti-youtube"></i></a>
						<a href="https://www.facebook.com/groups/915527066379136/"
						class="px-2" target="_blank"><i class="ti-facebook"></i></a> <a
						href="https://twitter.com/shrinesecrets" class="px-2"
						target="_blank"><i class="ti-twitter"></i></a> <a
						href="https://patreon.com/TheShrineOfLostSecrets" class="px-2"
						target="_blank"><i class="fab fa-patreon"></i></a>
				</h6>
			</div>
		</div>
	</nav>
	<!-- End of First Navigation -->
	<!-- Second Navigation -->
	<nav
		class="nav-second navbar custom-navbar navbar-expand-sm navbar-dark bg-dark sticky-top">
		<div class="container">
			<button class="navbar-toggler ml-auto" type="button"
				data-toggle="collapse" data-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav mr-auto">
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>">Pray
							at the Shrine</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.HELPANCHOR)%>">Ask
							for Help</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag)%>">Get
							Started</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>">Make
							an offering</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>">Contact
							Us</a></li>
				</ul>
				<ul class="navbar-nav ml-auto">
					<li class="nav-item">
						<%
						if (currentUser != null) {
						%> <a
						href="<%=userService.createLogoutURL(URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal, world,
		relm, tag, "", JspConstants.ID + "=" + id))%>"
						class="btn btn-primary btn-sm">Welcome <%=currentUser.getNickname()%></a>
						<%
						} else {
						%> <a
						href="<%=userService.createLoginURL(URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal, world,
		relm, tag, "", JspConstants.ID + "=" + id))%>"
						class="btn btn-primary btn-sm">Login</a> <%}%>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- End Of Second Navigation -->
	<!-- Page Header -->
	<%
	if (event.getCompactDesc().length() > 0) {
	%>
	<script>
	function handleSubmit() {
	    const url = new URL('/image.jsp', window.location.href);
	    url.searchParams.append('input', "<%=URLEncoder.encode(event.getCompactDesc(), "UTF-8")%>");
	    url.searchParams.append('size', "<%=Size.SIZE_512x512.getSize()%>");

	    const requestOptions = {
	        method: 'GET'
	    };
	    fetch(url, requestOptions)
	        .then(response => {
	            if (!response.ok) {
	                throw new Error('Network response was not ok');
	            }
	            return response.text();
	        })
	        .then(data => {
	            const imageUrl = data.trim();
	            const img = document.getElementById('eventImage');
	            img.src = imageUrl;
	            img.alt = "<%=AIConstants.AIIMAGE + AIManager.removeUnusal(event.getCompactDesc())%>";
	        })
	        .catch(error => {
	            console.error('Error during image fetch:', error);
	            document.getElementById('output').textContent = 'An error occurred.';
	        });
	}
	<%if (!event.hasMedia() && (currentUser == null || !userService.isUserAdmin())) {%>
		handleSubmit();
	<%}%>
	</script>
	<%}%>

	<%
	if (!event.hasMedia()) {
	%>
	<header class="header">
		<div class="overlay">
			<img src="assets/imgs/logo.jpg" alt="Shrine of Lost Secrets"
				class="logo2" id="eventImage">
		</div>
	</header>
	<%
	} else {
	%>
	<header class="header" style="min-height: 861px;">
		<div class="overlay">
			<%=event.getMedia()%>
		</div>
	</header>

	<%}%>

	<!-- End Of Page Header -->

	<section id="<%=JspConstants.PRAYANCHOR%>">
		<div class="container">
			<h6 class="section-subtitle text-center">
				Time -
				<%=scale%></h6>
			<h3 class="section-title mb-6 pb-3 text-center">
				<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal.backward(scale), endCal, world, relm, tag,
		JspConstants.PRAYANCHOR, JspConstants.ID + "=" + event.getKeyString())%>"><i
					class="fa fa-angle-down" style="font-size: 24x"></i></a>
				<%=startCal.getDisplayDate()%><a
					href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal.forward(scale), endCal, world, relm, tag,
		JspConstants.PRAYANCHOR, JspConstants.ID + "=" + event.getKeyString())%>"><i
					class="fa fa-angle-up" style="font-size: 24px"></i></a> - <a
					href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal.backward(scale), world, relm, tag,
		JspConstants.PRAYANCHOR, JspConstants.ID + "=" + event.getKeyString())%>"><i
					class="fa fa-angle-down" style="font-size: 24x"></i></a>
				<%=endCal.getDisplayDate()%><a
					href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal.forward(scale), world, relm, tag,
		JspConstants.PRAYANCHOR, JspConstants.ID + "=" + event.getKeyString())%>"><i
					class="fa fa-angle-up" style="font-size: 24px"></i></a>
			</h3>
			<div id="timeline" class=""
				style="height: 100px; width: 1000px; position: relative; display: block; clear: both:content; margin-bottom: 10px;">
				<hr
					style="height: 2px; background-color: black; border: 0; margin-top: 25px; margin-bottom: 25px; margin-left: 0px; margin-right: 0px; position: relative; top: 50px;">
			</div>

			<script>
  const startDate = 0;
  const endDate = 100;
  const timelineElement = document.getElementById("timeline");
  
  function placeForwardArrow(tip, text, anchor) {
	  const icon = document.createElement("i");
	    icon.className = "fa fa-arrow-left";
	    icon.setAttribute("aria-hidden", "true");
		icon.setAttribute("title", tip); // add tooltip to icon element
	    icon.style.float = "left";
	    icon.style.fontSize = "33px";
	    
	    const textElement = document.createElement("div");
	    textElement.style.writingMode = "vertical-lr";
	    textElement.setAttribute("title", tip); // add tooltip to icon element
		textElement.style.left = "7px";    
		textElement.style.position = "relative";
		textElement.style.fontSize = "small";
		textElement.innerHTML = text;
		
		const anchorElement = document.createElement("a");
		anchorElement.href = anchor;
		anchorElement.style.position = "absolute";
		anchorElement.style.left="-33px";
		anchorElement.style.top = "33px";
		anchorElement.style.height = "75px";
		anchorElement.style.width = "33px";
		anchorElement.appendChild(icon);
		anchorElement.appendChild(textElement);
		timelineElement.appendChild(anchorElement);
    
  }
  function placeBackwardArrow(tip, text, anchor) {
	  const icon = document.createElement("i");
	    icon.className = "fa fa-arrow-right";
	    icon.setAttribute("aria-hidden", "true");
		icon.setAttribute("title", tip); // add tooltip to icon element
	    icon.style.fontSize = "33px";
	    const textElement = document.createElement("div");
	    textElement.setAttribute("title", tip); // add tooltip to icon element
		textElement.style.writingMode = "vertical-lr";
		textElement.style.right = "-6px";    
		textElement.style.position = "relative";
		textElement.style.fontSize = "small";
		textElement.innerHTML = text;
		const anchorElement = document.createElement("a");
		anchorElement.href = anchor;
		anchorElement.style.position = "absolute";
		anchorElement.style.left= timelineElement.offsetWidth + 2 + "px";
		anchorElement.style.top = "33px";
		anchorElement.style.height = "75px";
		anchorElement.style.width = "33px";
		anchorElement.appendChild(icon);
		anchorElement.appendChild(textElement);
		timelineElement.appendChild(anchorElement);
  }
  const flagSet = {};
  var flag = null;
  
  function placeFlagLocation(element, position) {
	  const timelineWidth = timelineElement.offsetWidth;
	  const flagLeft = (position/100) * timelineWidth;
	  element.style.left = (flagLeft) + "px";

  }
  function placeFlag(tip, anchor,  position, focus, personalEvent) {
	  if (!flagSet[position] || focus) {
		  flagSet[position] = true;
		  const icon = document.createElement("i");
		  icon.className = "fa fa-flag";
		  icon.setAttribute("aria-hidden", "true");
		  icon.style.fontSize = "33px"; 
		  if(focus){
			  icon.style.color="<%=JspConstants.FOCUSFLAGCOLOR%>";
		  }
		  else if(personalEvent){
			  icon.style.color="<%=JspConstants.PERSONALFAGCOLOR%>";
		  }
		  const timelineWidth = timelineElement.offsetWidth;
		  const flagWidth = icon.offsetWidth;
//		  const leftEdge = startDate;
//		  const rightEdge = endDate;
//		  const flagPosition = position;
	
		  const flagLeft = (position/100) * timelineWidth;
	
		  const anchorElement = document.createElement("a");
		  anchorElement.setAttribute("title", tip); // add tooltip to icon element
		  anchorElement.href = anchor;
		  anchorElement.target = "_blank"; // added target attribute
		  anchorElement.style.position = "absolute";
		  anchorElement.style.float = "left";
		  anchorElement.style.bottom = "50px";
		  placeFlagLocation(anchorElement, position);
		  //anchorElement.style.left = (flagLeft) + "px";
		  anchorElement.appendChild(icon);
		  timelineElement.appendChild(anchorElement);
		  return anchorElement;
	  }
	}
  
  function placeMultiEvent(tip, anchor,  position) {
	  if (!flagSet[position]) {
		  flagSet[position] = true;
		  const icon = document.createElement("i");
		  icon.className = "fa-solid fa-timeline";
		  icon.setAttribute("aria-hidden", "true");
		  icon.style.fontSize = "33px"; 
		  icon.style.color="<%=JspConstants.MULTIEVENTCOLOR%>";

		  const timelineWidth = timelineElement.offsetWidth;
		  const flagWidth = icon.offsetWidth;
	
		  const flagLeft = (position/100) * timelineWidth;
	
		  const anchorElement = document.createElement("a");
		  anchorElement.setAttribute("title", tip); // add tooltip to icon element
		  anchorElement.href = anchor;
//		  anchorElement.target = "_blank"; // added target attribute
		  anchorElement.style.position = "absolute";
		  anchorElement.style.float = "left";
		  anchorElement.style.bottom = "50px";
		  placeFlagLocation(anchorElement, position);
		  //anchorElement.style.left = (flagLeft) + "px";
		  anchorElement.appendChild(icon);
		  timelineElement.appendChild(anchorElement);
		  return anchorElement;
	  }
	}
  
  function placeArrow(tip, text, position) {
		const icon = document.createElement("i");
		const timelineWidth = timelineElement.offsetWidth;
	    const flagWidth = icon.offsetWidth;
		const flagLeft = (position/100) * timelineWidth;
	   
	    icon.className = "fa fa-long-arrow-up";
	    icon.setAttribute("aria-hidden", "true");
	 	icon.setAttribute("title", tip); // add tooltip to icon element
	    icon.style.top = "20px";
	    icon.style.clear = "top";
	    icon.style.fontSize = "13pt";
	    
	    const textElement = document.createElement("div");
	    textElement.style.writingMode = "vertical-lr";
	    textElement.setAttribute("title", tip); // add tooltip to icon element
		textElement.style.left = "-7px";    
		textElement.style.position = "relative";
		textElement.style.fontSize = "small";
		textElement.style.clear = "top";
		textElement.style.height = "50px";
	
		textElement.innerHTML = text;
	 	timelineElement.appendChild(icon);
	    timelineElement.appendChild(textElement);
	    
	    const div = document.createElement("div");
	    div.style.left = (flagLeft) + "px";
	    div.style.top = "50px";
	    div.style.position = "absolute";
	    div.style.height = "25px";
	    div.style.width = "25px";
	
		div.appendChild(icon);
		div.appendChild(textElement);
	    
		timelineElement.appendChild(div);
    }
	placeForwardArrow("<%=startCal.getDisplayDate()%>","<%=startCal.getShortDisplayDate()%>", "<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal.backward(startCal.getElapsedTime(endCal) / 2),
		endCal.backward(startCal.getElapsedTime(endCal) / 2), world, relm, tag, JspConstants.PRAYANCHOR,
		JspConstants.ID + "=" + event.getKeyString())%>")
	placeBackwardArrow("<%=endCal.getDisplayDate()%>","<%=endCal.getShortDisplayDate()%>", "<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal.forward(startCal.getElapsedTime(endCal) / 2),
		endCal.forward(startCal.getElapsedTime(endCal) / 2), world, relm, tag, JspConstants.PRAYANCHOR,
		JspConstants.ID + "=" + event.getKeyString())%>")	
  <%if (SOLSCalendar.Scale.CENTURY.equals(scale)) {
	SOLSCalendar futureYear = startCal.forwardCentury().justCentury();
	double rangeLength = Double.valueOf(startCal.getElapsedTime(endCal));
	double dayOffset = startCal.getDayOfCentury();
	double yearOffset = SOLSCalendarConstants.LENGTH_OF_CENTURY;
	while (yearOffset - dayOffset < rangeLength) {%>
		placeArrow("<%=futureYear.getDisplayDate()%>", "<%=futureYear.getYear()%>", <%=Math.round((yearOffset / rangeLength - (dayOffset / rangeLength)) * 100)%>)
		<%futureYear = futureYear.forwardCentury();
yearOffset = yearOffset + SOLSCalendarConstants.LENGTH_OF_CENTURY;
}
} else if (SOLSCalendar.Scale.DECADE.equals(scale)) {
SOLSCalendar futureYear = startCal.forwardDecade().justDecade();
double rangeLength = Double.valueOf(startCal.getElapsedTime(endCal));
double dayOffset = startCal.getDayOfDecade();
double yearOffset = SOLSCalendarConstants.LENGTH_OF_DECADE;
while (yearOffset - dayOffset < rangeLength) {%>
			placeArrow("<%=futureYear.getDisplayDate()%>", "<%=futureYear.getYear()%>", <%=Math.round((yearOffset / rangeLength - (dayOffset / rangeLength)) * 100)%>)
			<%futureYear = futureYear.forwardDecade();
yearOffset = yearOffset + SOLSCalendarConstants.LENGTH_OF_DECADE;
}
} else if (SOLSCalendar.Scale.MONTH.equals(scale) || SOLSCalendar.Scale.SEASON.equals(scale)
		|| SOLSCalendar.Scale.YEAR.equals(scale) || SOLSCalendar.Scale.DAY.equals(scale)) {
SOLSCalendar futureMonth = startCal.forwardMonth().justMonth();
double rangeLength = Double.valueOf(startCal.getElapsedTime(endCal));
double dayOffset = startCal.getDayOfMonth();
double monthOffset = SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH;
while (monthOffset - dayOffset < rangeLength) {
if (0 == futureMonth.getMonth()) {%>
				placeArrow("<%=futureMonth.getDisplayDate()%>", "<%=futureMonth.getMonthName()%>, <%=futureMonth.getYear()%>", <%=Math.round((monthOffset / rangeLength - (dayOffset / rangeLength)) * 100)%>)
			<%} else if (rangeLength <= SOLSCalendarConstants.LENGTH_OF_YEAR * 3) {%>
				placeArrow("<%=futureMonth.getDisplayDate()%>", "<%=futureMonth.getMonthName()%>", <%=Math.round((monthOffset / rangeLength - (dayOffset / rangeLength)) * 100)%>)
			<%}
futureMonth = futureMonth.forwardMonth();
monthOffset = monthOffset + SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH;
}
}

List<Entity> entities = EventsList.listEvents(startCal, endCal, world, relm, dm, tag);
EventCollection collection = new EventCollection(entities);
if (!collection.isMoreEvents()) {
for (Event events : collection.getEvents()) {%>
<%if (idLong == events.getKeyLong()) {%>flag = <%}%>placeFlag("<%=events.getTitle()%>", "<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal, world, relm, tag, "",
		JspConstants.ID + "=" + events.getKeyString())%>", <%
double elapseDays = Double.valueOf(events.getEventCalendar().getElapsedTime(endCal));%><%=100 - Math.round((elapseDays / totalDays) * 100)%>, <%=event.equals(events)%>, <%=Constants.UNIVERSALUSER != dm.getKeyLong() && dm.getKeyLong() == events.getUserId()%>)
	<%}
} else {
for (EventCluster cluser : collection.getEventsCluster()) {%>
					placeMultiEvent("<%=cluser.getNumberOfElements()%> Events", "<%=URLBuilder.buildRequest(request, JspConstants.INDEX, cluser.getLowerBoundDate(), cluser.getUpperBoundDate(),
		world, relm, tag, JspConstants.PRAYANCHOR)%>", <%double elapseDays = Double.valueOf(cluser.getCentroidDate().getElapsedTime(endCal));%><%=100 - Math.round((elapseDays / totalDays) * 100)%>)
		<%}
}%>
	</script>
		</div>
	</section>
	<%
	if (edit) {
	%>
	<section>
		<div class="container" id="<%=JspConstants.EDIT%>">
			<h6 class="section-subtitle text-center">
				Key:<a
					href="<%=JspConstants.DETAILS%>?<%=JspConstants.ID%>=<%=event.getKeyString()%>"><%=event.getKeyString()%></a>
			</h6>
			<h3 class="section-title mb-6 pb-3 text-center"></h3>
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
  xhr.open("POST", "<%=URLBuilder.buildRequest(request, JspConstants.PRAY, 0l, eventDate, world, relm, tag)%>", true);
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
	  
  function submissionReady() {
	if(document.getElementsByName("<%=JspConstants.TITLE%>")[0].value.length == 0){
		alert("The title must be set")
		return false;
	}
	else if(document.getElementsByName("<%=JspConstants.TAGINPUT%>")[0].value.length == 0){
		alert("The tag(s) must be set")
		return false;
	}
	else if(document.getElementsByName("<%=JspConstants.COMPACTDESC%>")[0].value.length == 0){
		alert("The compact description must be set")
		return false;
	}
	else if(document.getElementsByName("<%=JspConstants.SHORTDESC%>")[0].value.length == 0){
		alert("The short description must be set")
		return false;
	}
	else if(document.getElementsByName("<%=JspConstants.LONGDESC%>")[0].value.length == 0){
		alert("The long description must be set")
		return false;
	}
	else{
		document.getElementById("<%=JspConstants.SAVEDETAILSFORM%>").submit();
		return true
	}
  }
	function createStepper() {
		  var currentStep = 0;
		  var totalSteps = 5;
		  var steps = [];
		  var advanceds = [];
		  var details = [];
		  var advancedMode = false;

		  function hideAllSteps() {
		    steps.forEach(function(step) {
		      step.style.display = "none";
		    });
		  }

		  function showStep(step) {
		    step.style.display = "block";
		  }

		  function stepForward() {
		    if (currentStep < totalSteps) {
		      hideAllSteps();
		      currentStep++;
		      showStep(steps[currentStep]);
		    }
		  }

		  function stepBackward() {
		    if (currentStep > 0) {
		      hideAllSteps();
		      currentStep--;
		      showStep(steps[currentStep]);
		    }
		  }

		  function toggleMode() {
		    advancedMode = !advancedMode;
		    if (advancedMode) {
		      steps.forEach(function(step) {
		        step.style.display = "block";
		      });
		      advanceds.forEach(function(advance) {
		        advance.style.display = "block";
		      });
		      details.forEach(function(detail) {
		        detail.style.display = "none";      
		      });
		    } else {
		      hideAllSteps();
		      showStep(steps[currentStep]);
		      advanceds.forEach(function(advance) {
		        advance.style.display = "none";
		      });
		      details.forEach(function(detail) {
		        detail.style.display = "none";      
		      }); 
		    }
		  }

		  function initialize() {
		    for (var i = 0; i <= totalSteps; i++) {
		      var step = document.getElementById("step" + i);
		      if (step) {
		        steps.push(step);
		      }
		    }
		    for (var i = 0; i <= totalSteps; i++) {
		      var advanced = document.getElementById("advanced" + i);
		      if (advanced) {
		        advanceds.push(advanced);
		      }
		    }  
		    advanceds.forEach(function(advance) {
		        advance.style.display = "none";
		      });
		    
		    for (var i = 0; i <= totalSteps; i++) {
		      var detail = document.getElementById("details" + i);
		      if (detail) {
		        details.push(detail);
		      }
		    }  
		    hideAllSteps();
		    showStep(steps[currentStep]);
		  }

		  return {
		    stepForward: stepForward,
		    stepBackward: stepBackward,
		    toggleMode: toggleMode,
		    initialize: initialize
		  };
		}

</script>
			<div class="card-body px-4 pb-4 text-center">
				<div class="row text-left">
					<div class="col-md-6 my-4">
						<h6 class="section-title mb-5">
							<input type="button" value="Backward"
								onClick="stepper.stepBackward();">
						</h6>
					</div>
					<div class="col-md-6  my-4">
						<h6 class="section-title mb-5 text-right">
							<input type="button" value="Forward"
								onClick="stepper.stepForward();">
						</h6>
					</div>
					<form method="post" action="<%=JspConstants.DETAILS%>"
						id="<%=JspConstants.SAVEDETAILSFORM%>">
						<input type=hidden name="<%=JspConstants.ID%>"
							value="<%=event.getKeyString()%>"><input type=hidden
							name="<%=JspConstants.START%>" value="<%=startDate%>"><input
							type=hidden name="<%=JspConstants.END%>" value="<%=endDate%>"><input
							type=hidden name="<%=JspConstants.SAVE%>" value="true">

						<%
						for (String element : tag) {
						%>
						<input type=hidden name="<%=JspConstants.TAGS%>"
							value=<%=element%>>
						<%
						}
						%>
						<div id="step4" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Title:</h6>
									<p class="mt-1 mb-0" id="details4">"The Event Title: An
										Essential Tool for Dungeon Masters. As a key component of any
										Dungeons & Dragons game or similar role-playing event, the
										title may indeed be the most critical element. It aids Dungeon
										Masters in locating and selecting their desired content."</p>
									<br> <input name="<%=JspConstants.TITLE%>"
										value="<%=event.getTitle()%>" size=50 maxlength="1500">
								</div>
							</div>
						</div>
						<div id="step3" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Tags:</h6>
									<p class="mt-1 mb-0" id="details3">The tags associated with
										the event are the content that should be included. They should
										be separated by spaces. If a tag needs to be displayed with a
										space, such as "Whispering woods," use an underscore instead
										("Whispering_woods"). All tags will be converted to lowercase,
										and the first letter will be automatically capitalized.</p>
									<br> <input name="<%=JspConstants.TAGINPUT%>"
										value="<%=event.getTagsString()%>" size=50 maxlength="1500">
								</div>
							</div>
						</div>
						<div id="step2" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Shrine Description:</h6>
									<p class="mt-1 mb-0" id="details2">The content displayed
										most compact information, with just the bare details. Most
										often, just choose the "Generate the Shrine Description"
										button to have the shrine rewrite the detailed content. You
										can then make any desired modifications to the details.</p>
									<br>
									<textarea name="<%=JspConstants.COMPACTDESC%>" rows="10"
										cols="100" maxlength="1500"><%=event.getCompactDesc()%></textarea>
									<input type="button"
										onClick='prayAtTheShrine("AICOMPACTDESC", "<%=JspConstants.COMPACTDESC%>")'
										value="Generate Shrine Desc">
								</div>
							</div>
						</div>
						<div id="step1" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Short Description:</h6>
									<p class="mt-1 mb-0" id="details1">The content displayed
										most often, this should summarize the content in detailed
										description in a couple of sentences. Most often, just choose
										the "Generate the Short Description" button to have the shrine
										rewrite the detailed content. You can then make any desired
										modifications to the details.</p>
									<br>
									<textarea name="<%=JspConstants.SHORTDESC%>" rows="15"
										cols="100" maxlength="1500"><%=event.getShortDesc()%></textarea>
									<br> <input type="button"
										onClick='prayAtTheShrine("AISHORTDESC", "<%=JspConstants.SHORTDESC%>")'
										value="Generate Short Desc">
								</div>
							</div>
						</div>
						<div id="step0" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Detailed Description:</h6>
									<p class="mt-1 mb-0" id="details0">The content displayed on
										the details page when selected by the user is called the
										detailed description. To start, you can write a sentence or
										two with the essential information about the event. Afterward,
										click the "Generate the Detailed Description" button to expand
										the content. You can then make any desired modifications to
										the details.</p>
									<br>
									<textarea name="<%=JspConstants.LONGDESC%>" rows="20"
										cols="100"><%=event.getLongDesc()%></textarea>
									<br> <input type="button"
										onClick='prayAtTheShrine("AILONGDESC", "<%=JspConstants.LONGDESC%>")'
										value="Generate Detailed Desc">
								</div>
							</div>
						</div>
						<div id="step5" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>EventDate:</h6>
									<p class="mt-1 mb-0" id="details5">Arguably the most
										critical piece of information, this indicates the date when
										the event occurred.</p>
									<br>

									<script type="text/javascript">
									function updateLoc(){ 
									var input = document.getElementById("eventdate");
									var now =  parseInt(input.value, 0);
									if(flag === null && now >= <%=startCal.getTime()%> && now <= <%=endCal.getTime()%>) { 
										flag = placeFlag("new Event", "",  100 - ((<%=endCal.getTime()%> - now) / <%=totalDays%>)*100, true, true);			 
									 }
									 else  if(now >= <%=startCal.getTime()%> && now <= <%=endCal.getTime()%>){
										placeFlagLocation(flag,100 - ((<%=endCal.getTime()%> - now) / <%=totalDays%>)*100);
									 }		 
									}
									</script>
									<input id="eventdate" onchange="forwardeventdate(0, 'eventdate')"
										name="<%=JspConstants.EVENTDATE%>"
										value="<%=(event.getEventDate() == 0 ? startCal.getRandomDate(endCal).getTime() : event.getEventDate())%>" size="7">
									<jsp:include page="/componenets/datepicker.jsp">
										<jsp:param name="datepicker" value="eventdate" />
									</jsp:include>
								</div>
							</div>
						</div>
						<%
						if (currentUser != null && userService.isUserLoggedIn() && userService.isUserAdmin()) {
						%>
						<div id="advanced1" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Promote To World Wide:</h6>
									<input type="checkbox" name=<%=JspConstants.PROMOTE%>
										value="true"
										<%=((Constants.UNIVERSALUSER == event.getUserId()) ? "checked" : "")%>>
								</div>
							</div>
						</div>
						<%}%>
						<div id="advanced2" class="step col-md-12 my-4">
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										Deleted: <input type="checkbox" name=<%=JspConstants.DELETED%>
											value="true" <%=((event.isDeleted(dm)) ? "checked" : "")%>>
									</h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										Bookmarked: <input type="checkbox"
											name=<%=JspConstants.BOOKMARKED%> value="true"
											<%=((event.isBookmarked()) ? "checked" : "")%>>
									</h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										CreatedDate:<%=event.getCreatedDate()%></h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										UpdatedDate:<%=event.getUpdatedDate()%></h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										Revision:<%=event.getRevision()%></h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>
										UserId:<%=event.getUserId()%></h6>
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>World:</h6>
									<input name="<%=JspConstants.WORLD%>"
										value="<%=event.getWorld()%>">
								</div>
							</div>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Relm:</h6>
									<input name="<%=JspConstants.RELM%>"
										value="<%=event.getRelm()%>">
								</div>
							</div>

							<%
							if (currentUser != null && userService.isUserLoggedIn() && userService.isUserAdmin()) {
							%>
							<div class="d-flex">
								<div class="flex-grow-1">
									<h6>Media:</h6>
									<textarea name="<%=JspConstants.MEDIA%>" rows="5" cols="100"><%=event.getMedia()%></textarea>
								</div>
							</div>
							<%
							}
							%>
						</div>
					</form>
					<script>var stepper = createStepper(); stepper.initialize();</script>
					<div class="col-md-6 my-4">
						<h6 class="section-title mb-5">
							<%
							if (currentUser != null) {
							%>
							<input type="button" value="Save" onClick="submissionReady()">
							<%
							} else {
							%>
							<input type="button" value="Save"
								onClick="alert('Creating Events requieres that you are logged in.')">
							<%}%>
						</h6>
					</div>
					<div class="col-md-6 my-4">
						<h6 class="section-title mb-5 text-right">
							<input type="button" value="Advanced"
								onClick="stepper.toggleMode();">
						</h6>
					</div>
				</div>
				<h1 class="section-title mb-6 pb-3 text-center">
					<a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR, "pray")%>">Return
						to the Shrine</a>
				</h1>

			</div>
		</div>
	</section>
	<%
	} else {
	%>
	<section>
		<div class="container" id="<%=JspConstants.EDIT%>">
			<h6 class="section-subtitle text-center"><%=event.getEventCalendar().getDisplayDate()%></h6>
			<h3 class="section-title mb-6 pb-3 text-center"><%=CaseControl.capFirstLetter(event.getTitle())%></h3>
			<p>
				<%=CaseControl.capAndLb(event.getLongDesc())%>
			<p>
			<p>
				<small class="font-weight-bold"><%=event.getTagsString()%> :
					<%=event.getEventCalendar().getTime()%></small>
			</p>
			<%
			if (currentUser != null && userService.isUserLoggedIn()
					&& (dm.getKeyLong() == event.getUserId() || userService.isUserAdmin())) {
			%>
			<a
				href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal, world, relm, tag, "",
		JspConstants.ID + "=" + event.getKeyString() + "&" + JspConstants.EDIT + "=true")%>">Edit</a>
			<%}%>
			<%
			if (currentUser != null && userService.isUserLoggedIn() && dm.getKeyLong() == event.getUserId()) {
			%>
			<h3 class="section-title mb-6 pb-3 text-center">
				<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR,
		"subject=request%20global%20consideration&body=https://shrineoflostsecrets.com/details.jsp?id="
				+ event.getKeyLong())%>">Submitting
					this event to the Global Repository!</a>
			</h3>
			<%
			}
			%>
			<h1 class="section-title mb-6 pb-3 text-center">
				<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR, "#")%>">Return
					to the Shrine</a>
			</h1>
		</div>

	</section>
	<%}%>
	<!-- Prefooter Section  -->
	<div
		class="py-4 border border-lighter border-bottom-0 border-left-0 border-right-0 bg-dark">
		<div class="container">
			<div
				class="row justify-content-between align-items-center text-center">
				<div class="col-md-3 text-md-left mb-3 mb-md-0">
					<img src="assets/imgs/logo-sm.jpg" width="100"
						alt="Shrine of Lost Secrets" class="mb-0">
				</div>
				<div class="col-md-9 text-md-right">
					<a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>"
						class="px-3"><small class="font-weight-bold">Pray</small></a> <a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.HELPANCHOR)%>"
						class="px-3"><small class="font-weight-bold">Help</small></a> <a
						href="<%=URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>"
						class="pl-3"><small class="font-weight-bold">Contact</small></a>
				</div>
			</div>
		</div>
	</div>
	<!-- End of PreFooter Section -->

	<!-- Page Footer -->
	<footer
		class="border border-dark border-left-0 border-right-0 border-bottom-0 p-4 bg-dark">
		<div class="container">
			<div class="row align-items-center text-center text-md-left">
				<div class="col">
					<p class="mb-0 small">
						&copy;
						<script>document.write(new Date().getFullYear())</script>
						, James Warmkessel All rights reserved
						<%=Constants.VERSION%>
					</p>
				</div>
				<div class="d-none d-md-block">
					<h6 class="small mb-0">
						<a href="https://www.youtube.com/@ShrineofLostSecrets"
						class="px-2" target="_blank"><i class="ti-youtube"></i></a>
						<a href="https://www.facebook.com/groups/915527066379136/"
							class="px-2" target="_blank"><i class="ti-facebook"></i></a> <a
							href="https://twitter.com/shrinesecrets" class="px-2"
							target="_blank"><i class="ti-twitter"></i></a> <a
							href="https://patreon.com/TheShrineOfLostSecrets" class="px-2"
							target="_blank"><i class="fab fa-patreon"></i></a>
					</h6>
				</div>
			</div>
		</div>

	</footer>
	<!-- End of Page Footer -->

	<!-- core  -->
	<script src="assets/vendors/jquery/jquery-3.4.1.js"></script>
	<script src="assets/vendors/bootstrap/bootstrap.bundle.js"></script>

	<!-- bootstrap affix -->
	<script src="assets/vendors/bootstrap/bootstrap.affix.js"></script>

</body>
</html>


