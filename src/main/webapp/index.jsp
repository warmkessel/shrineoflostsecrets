<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.shrineoflostsecrets.entity.Event"%>
<%@ page import="com.shrineoflostsecrets.datastore.EventsList"%>
<%@ page import="com.google.cloud.datastore.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>

<%
String id = null;
Set<String> tag = new HashSet<String>();
long startDate = SOLSCalendarConstants.BEGININGOFTHEAGEOFMAN;
long endDate = SOLSCalendarConstants.MIDPOINTOFMAN;
String world = Constants.HOME;
String relm = Constants.MEN;
String user = Constants.UNIVERSALUSER;

if (null != request.getParameter(JspConstants.RELM) && request.getParameter(JspConstants.RELM).length() > 0) {
	relm = (String) request.getParameter(JspConstants.RELM);
}
if (null != request.getParameter(JspConstants.WORLD) && request.getParameter(JspConstants.WORLD).length() > 0) {
	world = (String) request.getParameter(JspConstants.WORLD);
}
if (null != request.getParameter(JspConstants.USER) && request.getParameter(JspConstants.USER).length() > 0) {
	user = (String) request.getParameter(JspConstants.USER);
}
if (null != request.getParameter(JspConstants.ID) && request.getParameter(JspConstants.ID).length() > 0) {
	id = (String) request.getParameter(JspConstants.ID);
}
if (null != request.getParameter(JspConstants.TAGS) && request.getParameter(JspConstants.TAGS).length() > 0) {
	List<String> list = Arrays.asList(request.getParameterValues(JspConstants.TAGS));
	for (String str : list) {
		tag.add(str.toLowerCase());
	}
}
if (null != request.getParameter(JspConstants.START) && request.getParameter(JspConstants.START).length() > 0) {
	startDate = Long.parseLong(request.getParameter(JspConstants.START));
}
if (null != request.getParameter(JspConstants.END) && request.getParameter(JspConstants.END).length() > 0) {
	endDate = Long.valueOf(request.getParameter(JspConstants.END));
}
SOLSCalendar startCal = new SOLSCalendar(startDate);
SOLSCalendar endCal = new SOLSCalendar(endDate);
endCal = startCal.endMustBeAfter(endCal);
startCal.getScale(endCal);
SOLSCalendar.Scale scale = startCal.getScale(endCal);

//if(SOLSCalendar.Scale.YEAR.equals(scale) || SOLSCalendar.Scale.DECKADE.equals(scale) || SOLSCalendar.Scale.CENTURY.equals(scale)){
	//startCal = startCal.justYear();
//	endCal = endCal.justYear();
//}


%><!DOCTYPE html>
<html lang="en">
<head>
<!-- Google tag (gtag.js) -->
<script async
	src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-N2VTBWYNCJ');
</script>
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
<title>Shrine of Lost Secrets</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/d3-cloud/1.2.5/d3.layout.cloud.min.js"></script>

<style>
.word-cloud {
	width: 512px;
	height: 512px;
}
</style>

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
						href="#<%=JspConstants.PRAYANCHOR%>">Pray at the Shrine</a></li>
					<li class="nav-item"><a class="nav-link"
						href="#<%=JspConstants.HELPANCHOR%>">Ask for Help</a></li>
					<li class="nav-item"><a class="nav-link"
						href="#<%=JspConstants.CONTACTANCHOR%>">Make an offering</a></li>
					<li class="nav-item"><a class="nav-link"
						href="#<%=JspConstants.CONTACTANCHOR%>">Contact Us</a></li>
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
	<header class="header">
		<div class="overlay">
			<img src="assets/imgs/logo.jpg" alt="Shrine of Lost Secrets"
				class="logo">
			<h1 class="subtitle">Welcome To</h1>
			<h1 class="title">Shrine of Lost Secrets</h1>
			<a class="btn btn-primary mt-3" href="#<%=JspConstants.PRAYANCHOR%>">Pray
				at the Shrine</a>
		</div>
	</header>
	<!-- End Of Page Header -->
	<!-- Pray Section -->
	<section id="<%=JspConstants.PRAYANCHOR%>">
		<div class="container">
			<h6 class="section-subtitle text-center">Time</h6>
			<h3 class="section-title mb-6 pb-3 text-center">
				<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal.backward(scale), endCal, world, relm,
		user, tag, JspConstants.PRAYANCHOR)%>"><i
					class="fa fa-angle-down" style="font-size: 24x"></i></a>
				<%=startCal.getDisplayDate()%><a
					href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal.forward(scale), endCal, world, relm,
		user, tag, JspConstants.PRAYANCHOR)%>"><i
					class="fa fa-angle-up" style="font-size: 24px"></i></a>
					-
					<a
					href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal.backward(scale), world, relm,
		user, tag, JspConstants.PRAYANCHOR)%>"><i
					class="fa fa-angle-down" style="font-size: 24x"></i></a>
				<%=endCal.getDisplayDate()%><a
					href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal.forward(scale), world, relm,
		user, tag, JspConstants.PRAYANCHOR)%>"><i
					class="fa fa-angle-up" style="font-size: 24px"></i></a>
			</h3>
			<div id="timeline" class=""
				style="height: 100px; width: 1000px;position:relative; display: block; clear: both:content;margin-bottom:50px;">
			<hr style="height:2px;background-color:black;border:0; margin-top:25px;margin-bottom:25px;margin-left:0px;margin-right:0px;position:relative;top:50px;">
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
  function placeFlag(tip, anchor,  position) {
	  if (!flagSet[position]) {
		  flagSet[position] = true;
		  const icon = document.createElement("i");
		  icon.className = "fa fa-flag";
		  icon.setAttribute("aria-hidden", "true");
		  icon.style.fontSize = "33px"; 
		  const timelineWidth = timelineElement.offsetWidth;
		  const flagWidth = icon.offsetWidth;
		  const leftEdge = startDate;
		  const rightEdge = endDate;
		  const flagPosition = position;
	
		  const flagLeft = (flagPosition/100) * timelineWidth;
	
		  const anchorElement = document.createElement("a");
		  anchorElement.setAttribute("title", tip); // add tooltip to icon element
		  anchorElement.href = anchor;
		  anchorElement.target = "_blank"; // added target attribute
		  anchorElement.style.position = "absolute";
		  anchorElement.style.float = "left";
		  anchorElement.style.bottom = "50px";
		  anchorElement.style.left = (flagLeft) + "px";
		  anchorElement.appendChild(icon);
		  timelineElement.appendChild(anchorElement);
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
	placeForwardArrow("<%=startCal.getDisplayDate()%>","<%=startCal.getShortDisplayDate()%>", "<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal.backward(startCal.getElapsedTime(endCal)), endCal.backward(startCal.getElapsedTime(endCal)), world, relm,
			user, tag, JspConstants.PRAYANCHOR)%>")
	placeBackwardArrow("<%=endCal.getDisplayDate()%>","<%=endCal.getShortDisplayDate()%>", "<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal.forward(startCal.getElapsedTime(endCal)), endCal.forward(startCal.getElapsedTime(endCal)), world, relm,
			user, tag, JspConstants.PRAYANCHOR)%>")	
  <%
	if(SOLSCalendar.Scale.CENTURY.equals(scale)){
		
	}
	else if(SOLSCalendar.Scale.DECKADE.equals(scale)){
			SOLSCalendar futureYear = startCal.forwardYear().justYear();
			double rangeLength = Double.valueOf(startCal.getElapsedTime(endCal));
			double dayOffset = startCal.getDayOfYear();
			double yearOffset = SOLSCalendarConstants.LENGTHOFYEAR;
			while(yearOffset - dayOffset < rangeLength){	
			%>
			placeArrow("<%=futureYear.getDisplayDate()%>", "<%=futureYear.getYear()%>", <%= Math.round((yearOffset/ rangeLength - (dayOffset / rangeLength))*100)%>)
			<%
				futureYear = futureYear.forwardYear();
			yearOffset = yearOffset + SOLSCalendarConstants.LENGTHOFYEAR;
				}
		}
	else if(SOLSCalendar.Scale.MONTH.equals(scale) || SOLSCalendar.Scale.SEASON.equals(scale) || SOLSCalendar.Scale.YEAR.equals(scale) || SOLSCalendar.Scale.DAY.equals(scale)){
		SOLSCalendar futureMonth = startCal.forwardMonth().justMonth();
		double rangeLength = Double.valueOf(startCal.getElapsedTime(endCal));
		double dayOffset = startCal.getDayOfMonth();
		double monthOffset = SOLSCalendarConstants.LENTHOFALUNARMONTH;
		while(monthOffset - dayOffset < rangeLength){
			if(0 == futureMonth.getMonth()){%>
				placeArrow("<%=futureMonth.getDisplayDate()%>", "<%=futureMonth.getMonthName()%>, <%=futureMonth.getYear()%>", <%= Math.round((monthOffset/ rangeLength - (dayOffset / rangeLength))*100)%>)
			<% } else{%>
				placeArrow("<%=futureMonth.getDisplayDate()%>", "<%=futureMonth.getMonthName()%>", <%= Math.round((monthOffset/ rangeLength - (dayOffset / rangeLength))*100)%>)
			<%}
			futureMonth = futureMonth.forwardMonth();
			monthOffset = monthOffset + SOLSCalendarConstants.LENTHOFALUNARMONTH;
			}
	}
 %>
 console.log("Scale: <%=scale%>"); 

/* placeArrow("testa", "",  100)
placeArrow("testb",  "", 0)
placeFlag("testflaga", "", 100);
placeFlag("testflagb", "", 0); */

</script>
		</div>
		<div class="container">
			<div class="row align-items-center">
				<div class="row">
					<div class="col-md-6 mb-4">
						<%
						if (tag.size() > 0) {
							Iterator<String> it = tag.iterator();

							while (it.hasNext()) {
								Set<String> newTag = new HashSet<String>();
								newTag.addAll(tag);
								String key = (String) it.next();
								newTag.remove(key);
						%>


						<div class="info">
							<div class="head clearfix">
								<h4 class="title float-left">
									<a
										href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, user, newTag,
		JspConstants.PRAYANCHOR)%>"><i
										class="fa fa-window-close" aria-hidden="true"></i> <%=CaseControl.capFirstLetter(key)%></a>
								</h4>
							</div>
						</div>
						<%
						}
						}
						%>
					</div>
					<div class="col-md-6 mb-4">
						<div id="word-cloud"></div>
					</div>
					<script>
  fetch('<%=URLBuilder.buildRequest(request, JspConstants.TAG, startCal, endCal, world, relm, user, tag)%>')
    .then(response => response.json())
    .then(data => {
      var width = 512;
      var height = 512;

      var layout = d3.layout.cloud()
        .size([width, height])
        .words(data.map(function(d) {
          return { text: d.word, size: d.frequency };
        }))
        .padding(5)
        .rotate(function() { return ~~(Math.random() * 2) * 90; })
        .fontSize(function(d) { return d.size; })
        .on("end", draw);

      layout.start();

      function draw(words) {
        d3.select("#word-cloud").append("svg")
          .attr("width", layout.size()[0])
          .attr("height", layout.size()[1])
          .append("g")
          .attr("transform", "translate(" + layout.size()[0] / 2 + "," + layout.size()[1] / 2 + ")")
          .selectAll("text")
          .data(words)
          .enter().append("text")
          .style("font-size", function(d) { return d.size + "px"; })
          .style("fill", "black")
          .attr("text-anchor", "middle")
          .attr("transform", function(d) {
            return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
          })
          .text(function(d) { return d.text; })
          .on("click", function(d) {
            window.location.href = '<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, user, tag)%><%=JspConstants.TAGS%>=' + d.text + '#<%=JspConstants.PRAYANCHOR%>';
          });
      }
    })
    .catch(error => {
      console.error(error);
    });
</script>

				</div>
			</div>
		</div>
	</section>
	<!-- End OF Pray Section -->
	<script>
	function prayAtTheShrineWCommand(command, target) {
		const targetName = document.getElementById(target);
		prayAtTheShrineInput("", command, "", target)
	}
	function prayAtTheShrine(instruction, target) {
		const targetName = document.getElementById(target);
		prayAtTheShrineInput(instruction, "", "", target)
	}
	function prayAtTheShrineInput(instruction, command ,input, target) {
	document.getElementById(target).innerHTML = "Loading...";
	  var xhr = new XMLHttpRequest();
	  xhr.open("POST", "<%=URLBuilder.buildRequest(request, JspConstants.PRAY, startCal, endCal, world, relm, user, tag)%>", true);
	  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	  xhr.onreadystatechange = function() {
		  if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
			  document.getElementById(target).innerHTML = xhr.responseText.trim();
	    }
	  };
	  var param = ""
	  if(instruction.length > 0){
		  param = "<%=JspConstants.INSTURCTION%>=" + instruction + "&";
	  }
	  if(command.length > 0){
		  param = "<%=JspConstants.COMMAND%>=" + command + "&";
	  }
	  if(input.length > 0){
		 param = param + "<%=JspConstants.INPUT%>=" + input;
	  }
	xhr.send(param);
	}
	</script>
	<!-- Menu Section -->
	<section class="has-img-bg" id="insite">
		<div class="container">
			<h6 class="section-subtitle text-center">The oracle responds:</h6>
			<h3 class="section-title mb-6 text-center">Oracle Summary</h3>
			<div class="card bg-light">
				<div class="card-body px-4 pb-4 text-center">
					<div class="row text-left">

						<div class="col-md-6 my-4">
							<a href="#"
								onClick='prayAtTheShrineWCommand("AISUMMARY", "<%=JspConstants.SUMMARY%>"); return false;'
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1">
										Oracle Summary:
										<p class="mt-1 mb-0" id="<%=JspConstants.SUMMARY%>">Request
											a reading</p>
									</div>
									<i class="fa fa-refresh" aria-hidden="true"></i>
								</div>
							</a>
						</div>
						<div class="col-md-6 my-4">
							<a href="#"
								onClick='prayAtTheShrineWCommand("AISUMMARYPEOPLE", "<%=JspConstants.SUMMARYPEOPLE%>"); return false;'
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1">
										People Summary:
										<p class="mt-1 mb-0" id="<%=JspConstants.SUMMARYPEOPLE%>">Request
											a reading</p>
									</div>
									<i class="fa fa-refresh" aria-hidden="true"></i>
								</div>
							</a>
						</div>
						<div class="col-md-6 my-4">
							<a href="#"
								onClick='prayAtTheShrineWCommand("AISUMMARYPLACES", "<%=JspConstants.SUMMARYPLACES%>"); return false;'
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1">
										Places Summary:
										<p class="mt-1 mb-0" id="<%=JspConstants.SUMMARYPLACES%>">Request
											a reading</p>
									</div>
									<i class="fa fa-refresh" aria-hidden="true"></i>
								</div>
							</a>
						</div>
						<%
						if (tag.size() > 0) {
							Iterator<String> it = tag.iterator();
							int x = 0;
							while (it.hasNext()) {
								String key = (String) it.next();
								x++;
						%>
						<div class="col-md-6 my-4">
							<a href="#"
								onClick='prayAtTheShrineWCommand("AIADDITIONALDETAILS<%=key%>", "<%=JspConstants.TAG%><%=x%>"); return false;'
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1">
										Additional Details about
										<%=CaseControl.capFirstLetter(key)%>:
										<p class="mt-1 mb-0" id="<%=JspConstants.TAG%><%=x%>">Request
											a reading</p>
									</div>
									<i class="fa fa-refresh" aria-hidden="true"></i>
								</div>
							</a>
						</div>
						<%
						}
						}
						%>
						<div class="col-md-6 my-4">
							<a
								href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal, world, relm, user, tag,
		JspConstants.ID, "edit=true&" + JspConstants.EVENTDATE + "=" + endCal.getTime())%>"
								target="_blank"
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1">Add an event.</div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End of Menu Section -->

	<!-- Team Section -->
	<section class="has-img-bg">
		<div class="container">
			<h6 class="section-subtitle text-center">The oracle responds:</h6>
			<h3 class="section-title mb-6 text-center">Details</h3>
			<div class="card bg-light">
				<div class="card-body px-4 pb-4 text-center">
					<div class="row text-left">
						<%
						List<Entity> entities = EventsList.listEvents(startCal, endCal, world, relm, user, tag);
						for (Entity entity : entities) {
							Event event = new Event();
							event.loadEvent(entity);
						%>
						<div class="col-md-6 my-4">
							<a
								href="<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal.backwardYear(), world, relm,
		user, tag, "", JspConstants.ID + "=" + event.getKeyString())%>"
								target="_blank"
								class="pb-3 mx-3 d-block text-dark text-decoration-none border border-left-0 border-top-0 border-right-0">
								<div class="d-flex">
									<div class="flex-grow-1"><%=event.getTitle()%>-<%=event.getEventCalendar().getDisplayDate()%>
										<p class="mt-1 mb-0"><%=event.getShortDesc()%></p>
									</div>
									<h6 class="float-right text-primary">Details</h6>
							  	<% if(50 > entities.size()){%>
									<script>
									placeFlag("<%=event.getTitle()%>", "<%=URLBuilder.buildRequest(request, JspConstants.DETAILS, startCal, endCal.backwardYear(), world, relm,
							  				user, tag, "", JspConstants.ID + "=" + event.getKeyString())%>", <%
		double totalDays = Double.valueOf(startCal.getElapsedTime(endCal));
		double elapseDays = Double.valueOf(event.getEventCalendar().getElapsedTime(endCal));
		%><%= 100 - Math.round((elapseDays / totalDays) * 100) %>)
  								</script>
								  	<%}%>
								</div>
							</a>
						</div>
						<%}%>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End of Menu Section -->
	<!-- Help Section -->
	<section id="<%=JspConstants.HELPANCHOR%>" class="pattern-style-3">
		<div class="container">
			<h6 class="section-subtitle text-center">Questions</h6>
			<h3 class="section-title mb-5 text-center">Answers</h3>

			<div class="row">
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: A work of fiction</h6>
									<small class="text-muted mb-0">None of anything that
										you read here is real.</small>
								</div>
							</div>
							<p class="mb-0">All the content contained herein is entirely
								fictional. The castles, characters, and events depicted are
								entirely imaginary. It may be a good idea for you to take a
								break and enjoy some outdoor activities. All content is property
								of Shrine of Lost Secrets and all rights are reserved.</p>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-1.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Time Control</h6>
									<small class="text-muted mb-0">You can use the Up and
										Down arrows near the Time to adjust the current time.</small>
								</div>
							</div>
							<p class="mb-0">
								Using the <i class="fa fa-angle-double-up"
									style="font-size: 48px"></i> and <i
									class="fa fa-angle-double-down" style="font-size: 48px"></i>
								arrows, you can adjust the current time and explore various
								periods in time. This allows you to delve into the origins of a
								person or place, as well as venture into the future to gain
								insight into what is yet to come. Its possible that an event has
								yet to happen at the current time.
							</p>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-2.jpg"
									alt="Shrine of Lost Secrets  Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Tag Cloud</h6>
									<small class="text-muted mb-0">Use the Tag Cloud to
										examine important elements.</small>
								</div>
							</div>
							<p class="mb-0">
								Tags that are more significant will be displayed larger in the
								tag cloud. If you click on a tag, it will be added to the list
								of selected tags, which will then limit the details displayed to
								only those associated with the selected tags. If you wish to
								remove a tag from the list, simply click on the <i
									class="fa fa-window-close" aria-hidden="true"></i> icon.
							</p>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-3.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Oracle Summary</h6>
									<small class="text-muted mb-0">A summary and additional
										information.</small>
								</div>
							</div>
							<p class="mb-0">
								To obtain additional details about a particular area of
								interest, simply click on the <i class="fa fa-refresh"
									aria-hidden="true"></i> icon.
							</p>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-4.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Oracle Details.</h6>
									<small class="text-muted mb-0">Details list is
										presented based upon the Tag Cloud that you have selected</small>
								</div>
							</div>
							<p class="mb-0">This is details list of all the events that
								match your Tag Cloud selections. If you want more details on any
								specific item select</p>
							<div style="color: #bc8c4c">Details</div>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-5.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Add an event.</h6>
									<small class="text-muted mb-0">Can be found at the end
										of the Oracle Summary</small>
								</div>
							</div>
							<p class="mb-0">You can add event(s) that will only affect
								your time-line.
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-4 my-3 my-md-0">
				<div class="card">
					<div class="card-body">
						<div class="media align-items-center mb-3">
							<img class="mr-3" src="assets/imgs/avatar-6.jpg"
								alt="Shrine of Lost Secrets Landing page">
							<div class="media-body">
								<h6 class="mt-1 mb-0">Acolyte: Delete an Event</h6>
								<small class="text-muted mb-0">Can be found in the
									Details page</small>
							</div>
						</div>
						<p class="mb-0">You can delete event(s) that will only affect
							your time-line.
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End of Help Section -->


	<!-- Contact Section -->
	<section id="<%=JspConstants.CONTACTANCHOR%>" class="bg-white">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-md-6 d-none d-md-block">
					<img src="assets/imgs/contact.jpg"
						alt="Shrine of Lost Secrets Landing page"
						class="w-100 rounded shadow">
				</div>
				<div class="col-md-6">
					<form>
						<div class="form-group">
							<input type="text" class="form-control" id="exampleInputEmail1"
								aria-describedby="emailHelp" placeholder="Your Name"> <input
								type="text" class="form-control" id="exampleInputEmail1"
								aria-describedby="emailHelp"
								placeholder="Your comment or Question">
						</div>
						<button type="submit" class="btn btn-primary btn-block">Share
							your thoughts</button>
						<small class="form-text text-muted mt-3">We appreciate
							your interest. Check our <a href="#">Privacy Policy</a>
						</small>
					</form>
				</div>
			</div>
		</div>
	</section>
	<!-- End OF Contact Section -->

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
					<a href="#pray" class="px-3"><small class="font-weight-bold">Pray</small></a>
					<a href="#help" class="px-3"><small class="font-weight-bold">Help</small></a>
					<a href="#contact" class="pl-3"><small class="font-weight-bold">Contact</small></a>
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


