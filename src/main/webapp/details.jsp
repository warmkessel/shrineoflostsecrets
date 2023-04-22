<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.shrineoflostsecrets.entity.Event"%>
<%@ page import="com.shrineoflostsecrets.datastore.EventsList"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.shrineoflostsecrets.ai.*"%>
<!DOCTYPE html>
<html>
<head>
<%
//5635008819625984l
String id = (String) request.getParameter(JspConstants.ID);
Event event = new Event();
if (null != id && id.length() > 0) {
	event.loadEvent(new Long(id).longValue());
}
long eventDate = 0;
long endDate = 0;
long startDate = 0;
/* 	String kingdom = (String) request.getParameter(JspConstants.KINGDOM);
 */ String world = (String) request.getParameter(JspConstants.WORLD);
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
boolean edit = false;

if (null != request.getParameter(JspConstants.DIRTY) && request.getParameter(JspConstants.DIRTY).length() > 0) {
	dirty = true;
}
if (null != request.getParameter(JspConstants.EDIT) && request.getParameter(JspConstants.EDIT).length() > 0) {
	edit = true;
}
if (null != request.getParameter(JspConstants.START) && request.getParameter(JspConstants.START).length() > 0) {
	startDate = Long.parseLong(request.getParameter(JspConstants.START));
}
if (null != request.getParameter(JspConstants.END) && request.getParameter(JspConstants.END).length() > 0) {
	endDate = Long.parseLong(request.getParameter(JspConstants.END));
	eventDate = endDate;
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
		String[] theSubList = str.toLowerCase().split(" ");
		for (int x = 0; x < theSubList.length; x++) {
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
	if (Boolean.valueOf(request.getParameter(JspConstants.DELETED)))
		event.setDeleted(user);
	else {
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
if(dirty && (event.getLongDesc().length() == 0 || event.getShortDesc().length() == 0 || event.getCompactDesc().length() == 0 || event.getTitle().length() == 0)){
	dirty = false;
}
if (dirty) {
	event.save();
}
if (null == relm || relm.length() == 0) {
	event.setRelm(Constants.MEN);
}
if (null == world || world.length() == 0) {
	event.setWorld(Constants.HOME);
}
if (null != event.getTagsString() && event.getTagsString().length() > 0) {
	tags.addAll(Arrays.asList(event.getTagsString().toLowerCase().split(" ")));
}
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
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>Shrine of Lost Secrets - Details</title>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="40" id="home">

	<!-- First Navigation -->
	<nav class="navbar nav-first navbar-dark bg-dark">
		<div class="container">
			<a class="navbar-brand" href="#"> <img
				src="assets/imgs/logo-sm.jpg" alt="Shrine of Lost Secrets">
			</a>
			<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link text-primary"
					href="#home">CALL US : <span class="pl-2 text-muted">(408)
							768 8654</span></a></li>
			</ul>
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
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.PRAYANCHOR)%>">Pray
							at the Shrine</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.HELPANCHOR)%>">Ask
							for Help</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.CONTACTANCHOR)%>">Make
							an offering</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.CONTACTANCHOR)%>">Contact
							Us</a></li>
				</ul>
				<ul class="navbar-nav ml-auto">
					<li class="nav-item"><a href="login.html"
						class="btn btn-primary btn-sm">Login</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- End Of Second Navigation -->
	<!-- Page Header -->
	<% if(event.getCompactDesc().length() > 0){ %>
	<script>
	function handleSubmit() {
	    const url = new URL('/image.jsp', window.location.href);
	    url.searchParams.append('input', "<%=URLEncoder.encode(event.getCompactDesc(), "UTF-8") %>");
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
	            img.alt = "<%=AIConstants.AIIMAGE + AIManager.removeUnusal(event.getCompactDesc()) %>";
	        })
	        .catch(error => {
	            console.error('Error during image fetch:', error);
	            document.getElementById('output').textContent = 'An error occurred.';
	        });
	}
	handleSubmit();
	</script>
	<%}%>
	<header class="header">
		<div class="overlay">
			<img src="assets/imgs/logo.jpg" alt="Shrine of Lost Secrets" class="logo2" id="eventImage">
		</div>
	</header>
	<!-- End Of Page Header -->

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
	  
  function submissionReady() {
	if(document.getElementsByName("<%=JspConstants.TITLE%>")[0].value.length == 0){
		alert("The title must be set")
		return false;
	}
	else if(document.getElementsByName("<%=JspConstants.TAGS%>")[0].value.length == 0){
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
  function toggleDetails(){
		if("none" == document.getElementById("<%=JspConstants.DETAILS%>").style.display){
			document.getElementById("<%=JspConstants.DETAILS%>").style.display = "block";
		}
		else{
			document.getElementById("<%=JspConstants.DETAILS%>").style.display = "none";

		}
	}
</script>
			<form method="post" action="<%=JspConstants.DETAILS%>" id="<%=JspConstants.SAVEDETAILSFORM%>">
				<input type=hidden name="<%=JspConstants.ID%>"
					value="<%=event.getKeyString()%>"><input type=hidden
					name="<%=JspConstants.USER%>" value="<%=user%>">
				<table>
					<tr>
						<td>Title:</td>
						<td><input name="<%=JspConstants.TITLE%>"
							value="<%=event.getTitle()%>" size=50 maxlength="1500"></td>
						<td><input type="button"
							onClick='prayAtTheShrine("AITITLE", "<%=JspConstants.TITLE%>")'
							value="Generate Title"></td>
					</tr>
					<tr>
						<td>Tag:</td>
						<td><textarea name="<%=JspConstants.TAGS%>" rows="5"
								cols="100"><%=event.getTagsString()%></textarea></td>
						<td><input type="button"
							onClick='prayAtTheShrine("AITAGS", "<%=JspConstants.TAGS%>")'
							value="Generate Tags"></td>
					</tr>
					<tr>
						<td>CompactDesc:</td>
						<td><textarea name="<%=JspConstants.COMPACTDESC%>" rows="10"
								cols="100" maxlength="1500"><%=event.getCompactDesc()%></textarea>
						</td>
						<td><input type="button"
							onClick='prayAtTheShrine("AICOMPACTDESC", "<%=JspConstants.COMPACTDESC%>")'
							value="Generate Compact Desc"></td>
					</tr>

					<tr>
						<td>ShortDesc:</td>
						<td><textarea name="<%=JspConstants.SHORTDESC%>" rows="15"
								cols="100" maxlength="1500"><%=event.getShortDesc()%></textarea>
						</td>
						<td><input type="button"
							onClick='prayAtTheShrine("AISHORTDESC", "<%=JspConstants.SHORTDESC%>")'
							value="Generate Short Desc"></td>
					</tr>
					<tr>
						<td>LongDesc:</td>
						<td><textarea name="<%=JspConstants.LONGDESC%>" rows="20"
								cols="100"><%=event.getLongDesc()%></textarea></td>
						<td><input type="button"
							onClick='prayAtTheShrine("AILONGDESC", "<%=JspConstants.LONGDESC%>")'
							value="Generate Long Desc"></td>
					</tr>
					<tr>
						<td>EventDate:</td>
						<td><input name="<%=JspConstants.EVENTDATE%>"
							value="<%=event.getEventDate()%>"></td>
					</tr>
					<tr>
						<td><a href="" onClick="toggleDetails(); return false;">Details</a></td>
					</tr>
				</table>
				<table id="<%=JspConstants.DETAILS%>" style="display: none">
					<tr>
						<td>Deleted:</td>
						<td><input type="checkbox" name=<%=JspConstants.DELETED%>
							value="true" <%=((event.isDeleted(user)) ? "checked" : "")%>></td>
					<tr>
					<tr>
						<td><input type="button"
							onClick='prayAtTheShrine("AIGENERATEEVENT", "<%=JspConstants.LONGDESC%>")'
							value="Generate Event"></td>
						<td>
					<tr>
						<td>Bookmarked:</td>
						<td><input type="checkbox" name=<%=JspConstants.BOOKMARKED%>
							value="true" <%=((event.isBookmarked()) ? "checked" : "")%>></td>
					</tr>
					<tr>
						<td>CreatedDate:</td>
						<td><%=event.getCreatedDate()%></td>
					</tr>
					<tr>
						<td>UpdatedDate:</td>
						<td><%=event.getUpdatedDate()%></td>
					</tr>
					<tr>
						<td>Revision:</td>
						<td><%=event.getRevision()%><br> UserId:<%=event.getUserId()%></td>
					</tr>
					<tr>
						<td>World:</td>
						<td><input name="<%=JspConstants.WORLD%>"
							value="<%=event.getWorld()%>"></td>
					</tr>
					<tr>
						<td>Relm:</td>
						<td><input name="<%=JspConstants.RELM%>"
							value="<%=event.getRelm()%>"></td>
					</tr>
				</table>
				<input type="button" value="Save" onClick="submissionReady()">
			</form>
		</div>

	</section>
	<%
	} else {
	%>
	<section>
		<div class="container" id="<%=JspConstants.EDIT%>">
			<h6 class="section-subtitle text-center"><%=event.getEventCalendar().getDisplayDate()%></h6>
			<h3 class="section-title mb-6 pb-3 text-center"><%=event.getTitle()%></h3>
			<p>
				<%=event.getLongDesc()%>
			<p>
			<p>
			<small class="font-weight-bold"><%=event.getTagsString()%></small>
			</p>
				<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startDate, endDate, world, relm, user, tag, "",
		JspConstants.ID + "=" + event.getKeyString() + "&" + JspConstants.EDIT + "=true")%>">Edit</a>
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
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.PRAYANCHOR)%>"
						class="px-3"><small class="font-weight-bold">Pray</small></a> <a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
		JspConstants.HELPANCHOR)%>"
						class="px-3"><small class="font-weight-bold">Help</small></a> <a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startDate, endDate, world, relm, user, tag,
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
					</p>
				</div>
				<div class="d-none d-md-block">
					<h6 class="small mb-0">
						<a href="javascript:void(0)" class="px-2"><i
							class="ti-facebook"></i></a> <a href="javascript:void(0)"
							class="px-2"><i class="ti-twitter"></i></a> <a
							href="javascript:void(0)" class="px-2"><i
							class="ti-instagram"></i></a> <a href="javascript:void(0)"
							class="px-2"><i class="ti-google"></i></a>
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


