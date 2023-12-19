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
<script  async="true" 
	src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
<script>
	window.dataLayer = window.dataLayer || [];
	function gtag() {
		dataLayer.push(arguments);
	}
	gtag('js', new Date());
	gtag('config', 'G-N2VTBWYNCJ');
</script>
<%
UserService userService = UserServiceFactory.getUserService();
User currentUser = userService.getCurrentUser();
DungonMaster dm = DungonMasterList.getDungonMaster(currentUser);

long endDate = 0;
long startDate = 0;

String world = (String) request.getParameter(JspConstants.WORLD);
String relm = (String) request.getParameter(JspConstants.RELM);
Set<String> tag = new HashSet<String>();
Set<String> tags = new HashSet<String>();

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

SOLSCalendar startCal = new SOLSCalendar(startDate);
SOLSCalendar endCal = new SOLSCalendar(endDate);
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
<title>Shrine of Lost Secrets - Help</title>
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
						href="<%=URLBuilder.buildRequest(request, JspConstants.HELP, startCal, endCal, world, relm, tag,
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
						href="<%=userService.createLogoutURL(
		URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag, "", ""))%>"
						class="btn btn-primary btn-sm">Welcome <%=currentUser.getNickname()%></a>
						<%
						} else {
						%> <a
						href="<%=userService.createLoginURL(
		URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag, "", ""))%>"
						class="btn btn-primary btn-sm">Login</a> <%}%>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- End Of Second Navigation -->
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
								<img class="mr-3" src="assets/imgs/avatar-2.jpg"
									alt="Shrine of Lost Secrets  Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Tag Cloud</h6>
									<small class="text-muted mb-0">Use the Tag Cloud to
										examine important elements.</small>
								</div>
							</div>
							<p class="mb-0">
								<b>Tags</b> that are more significant will be displayed larger
								in the Tag Cloud. If you click on a <b>tag</b>, it will be added
								to the list of selected tags, which will then limit the details
								displayed to only those associated with all of the selected
								tags. If you wish to remove a tag from the list, simply click on
								the <i class="fa fa-window-close" aria-hidden="true"></i> icon.
							</p>
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
										Down arrows near the Time to adjust the Start and End time.</small>
								</div>
							</div>
							<p class="mb-0">
								Using the <i class="fa fa-angle-down" style="font-size: 48px"></i>
								and <i class="fa fa-angle-up" style="font-size: 48px"></i>
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
								<img class="mr-3" src="assets/imgs/avatar-7.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Time Control</h6>
									<small class="text-muted mb-0">You can use the Left and
										Right arrows near the Time Bar to move forward or backward in
										time</small>
								</div>
							</div>
							<p class="mb-0">
								Using the <i class="fa fa-arrow-left" style="font-size: 48px"></i>
								and <i class="fa fa-arrow-right" style="font-size: 48px"></i>
								arrows, you have the ability to modify the current time and
								explore different periods in history by moving either forward or
								backward in time.
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
									<h6 class="mt-1 mb-0">Acolyte: Add and Delete an event.</h6>
									<small class="text-muted mb-0">Can be found at the end
										of the Oracle Summary</small>
								</div>
							</div>
							<p class="mb-0">You can add event(s) or delete event(s) that
								will only affect your time-line.</p>
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
									<h6 class="mt-1 mb-0">Acolyte: Flag</h6>
									<small class="text-muted mb-0">The appearance of being
										real.</small>
								</div>
							</div>
							<p class="mb-0">
								I am pleased to inform you that the TimeBar has flags that can
								be of great assistance in comprehending the individual events
								you have selected in your Time Frame and tagCloud. These flags
								are represented by icons, each with a unique significance. The
								icons with the <i class="fa fa-flag" aria-hidden="true"
									style="color:<%=JspConstants.DEFAULTFAGCOLOR%>;"></i>
								symbolize universal events. The icons with the <i
									class="fa fa-flag" aria-hidden="true"
									style="color:<%=JspConstants.PERSONALFAGCOLOR%>;"></i> signify
								personal events. The icons with the <i class="fa fa-flag"
									aria-hidden="true"
									style="color:<%=JspConstants.FOCUSFLAGCOLOR%>;"></i> represent
								the selected events.
							</p>
						</div>
					</div>
				</div>
				<div class="col-md-4 my-3 my-md-0">
					<div class="card">
						<div class="card-body">
							<div class="media align-items-center mb-3">
								<img class="mr-3" src="assets/imgs/avatar-7.jpg"
									alt="Shrine of Lost Secrets Landing page">
								<div class="media-body">
									<h6 class="mt-1 mb-0">Acolyte: Verisimilitude</h6>
									<small class="text-muted mb-0">The appearance of being
										real.</small>
								</div>
							</div>
							<p class="mb-0">As you explore the depths of the Shrine,
								immerse your players in a world of vivid detail. If you find
								that the Shrine lacks specific information, seize the
								opportunity to craft and incorporate your own creative elements
								within its framework.</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- End of Help Section -->

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
					<a
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>"
						class="px-3"><small class="font-weight-bold">Pray</small></a> <a
						href="<%=URLBuilder.buildRequest(request, JspConstants.HELP, startCal, endCal, world, relm, tag,
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
						<script>
							document.write(new Date().getFullYear())
						</script>
						, James Warmkessel All rights reserved
						<%=Constants.VERSION%>
					</p>
				</div>
				<div class="d-none d-md-block">
					<h6 class="small mb-0">
						<a href="https://www.youtube.com/@ShrineofLostSecrets"
						class="px-2" target="_blank"><i class="ti-youtube"></i></a>
						<a href="https://www.facebook.com/groups/915527066379136/"
							class="px-2" target="_blank"><i class="ti-facebook"></i></a>
						<a href="https://twitter.com/shrinesecrets" class="px-2"
							target="_blank"><i class="ti-twitter"></i></a>
						<a href="https://patreon.com/TheShrineOfLostSecrets" class="px-2"
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


