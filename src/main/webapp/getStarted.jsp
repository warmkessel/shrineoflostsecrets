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
<%@ page import="com.google.appengine.api.users.*" %>

<!DOCTYPE html>
<html>
<head>
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
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
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>">Pray
							at the Shrine</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.HELPANCHOR)%>">Ask
							for Help</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>">Get
							Started</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>">Make
							an offering</a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>">Contact
							Us</a></li>
				</ul>
				<ul class="navbar-nav ml-auto">
				<li class="nav-item">
				<%if (currentUser != null) { %>
						<a href="<%= userService.createLogoutURL(URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag,"", ""))%>"
						class="btn btn-primary btn-sm">Welcome <%=currentUser.getNickname() %></a>
					<%}else { %>
					<a href="<%= userService.createLoginURL(URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag,"", ""))%>"
						class="btn btn-primary btn-sm">Login</a>
					<%}%>	
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- End Of Second Navigation -->
	<!-- Page Header -->
	<section id="" class="pattern-style-3">
		<div class="container">
			<h6 class="section-subtitle text-center">Welcome</h6>
			<h3 class="section-title mb-5 text-center">A little about the
				Shrine first</h3>
			<div class="row align-items-center">
				<div class="row">
					<div class="col-md-6 mb-4"></div>
					<div class="card bg-light">
						<div class="card-body px-4 pb-4 text-center">
							<div class="row text-left">
								<div class="col-md-6 my-4">
									<div class="d-flex">
										<div class="flex-grow-1">
											Time Bar:
											<p class="mt-1 mb-0" id="summary">
												The <b>Time Bar</b>, located at the top of the Shrine,
												displays the <span style="text-decoration: underline;">Start
													Time</span> and <span style="text-decoration: underline;">End
													Time</span> that the Shrine will consider when generating
												responses. You can adjust the Start Time and End Time
												independently by moving them forward or backward using the <i
													class="fa fa-angle-down" style="font-size: 24px"></i> and <i
													class="fa fa-angle-up" style="font-size: 24px"></i> arrows.
												You can adjust the current time and explore various events.
												As the span of time grows larger, the scale that they can be
												adjusted will also increase, and vice versa. You can also
												use the arrows at the front and back of the <b>Time Bar</b>
												to move forward and backward in time using the <i
													class="fa fa-arrow-left" style="font-size: 24px"></i> and <i
													class="fa fa-arrow-right" style="font-size: 24px"></i>
												icons.
											</p>
										</div>
									</div>
								</div>
								<div class="col-md-6 my-4">
									<div class="d-flex">
										<div class="flex-grow-1">
											Tag Cloud:
											<p class="mt-1 mb-0" id="summary">
												The <b>Tag Cloud</b> is a list of the most important details
												of all the events available in the selected time. The more
												entries that are available in the Shrine, the larger the
												display of the tag will be. This allows you to limit the
												kinds of events you would like to evaluate. For example, if
												you want to learn about a specific family, you can choose
												their name from the Tag Cloud. You can refine the Tag Cloud
												by delving deeper into any subject and remove any tag by
												choosing the <i class="fa fa-window-close"
													aria-hidden="true"></i> icon.
											</p>
										</div>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<section id="" class="pattern-style-3">
		<div class="container">
			<h6 class="section-subtitle text-center">Get me Started</h6>
			<h3 class="section-title mb-5 text-center">Here are some
				suggestions where to get started</h3>
			<div class="row align-items-center">
				<div class="row">
					<div class="col-md-6 mb-4"></div>
					<div class="card bg-light">
						<div class="card-body px-4 pb-4 text-center">
							<div class="row text-left">
								<div class="col-md-6 my-4">
									<div class="d-flex">
										<div class="flex-grow-1">
											<a
												href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(13494), new SOLSCalendar(29003), "Home",
		"Men", "whisperingwood", JspConstants.PRAYANCHOR)%>"
												target="_blank">The Battle of Whispering Woods &lt;--
												Start Here</a>
											<p class="mt-1 mb-1">Enter Taramond, a small village
												surrounded by a deep forest where residents bravely defend
												their simple life from evil. The ghostly Alexander Maplewood
												inspires them to uncover his death and honor his memory. The
												Knights of the Holy Mantle protect both physical and
												spiritual realms, finding joy in life while upholding honor
												and duty. The struggle of good and evil is embodied by
												Benedict, an isolated child with an unusual pallor. The
												Blackwood and soldiers save Taramond and earn admiration,
												reminding all that heroes are mortal.</p>
											<p class="mt-1 mb-1">How will your adventures impact the
												conflict? Will they aid Aldric, investigate the peculiar
												occurrences, or unintentionally assist Benedict?</p>
											<ul>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(21612), new SOLSCalendar(29003), "Home",
		"Men", "aldrich wise taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">Aldrich the Wise - More about Aldric</a>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(13494), new SOLSCalendar(29003), "Home",
		"Men", "benedict maplewood taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">Benedict Maplewood - Details about
														Benedict Maplewood</a>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(13494), new SOLSCalendar(29003), "Home",
		"Men", "knight mantle taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">Knights of the Holy Mantle - Will the
														adventures intervene</a>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(13494), new SOLSCalendar(29003), "Home",
		"Men", "supernatural taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">And who or what is raising the dead?</a>
											</ul>
										</div>
									</div>
								</div>
								<div class="col-md-6 my-4">
									<div class="d-flex">
										<div class="flex-grow-1">
											<a
												href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(19484), new SOLSCalendar(19670), "Home",
		"Men", "nightsofthebrave taramond", JspConstants.PRAYANCHOR)%>"
												target="_blank">The Night of the Brave &lt;-- Start Here</a>
											<p class="mt-1 mb-1">Arin is enamored with the
												breathtaking beauty of the world around him, where nature
												reigns supreme and the wonders of the land are beyond
												comprehension. However, the arrival of Riven Shadowhand and
												her Darkstar Raiders shatters the peaceful life of Taramond,
												forcing villagers to choose between fight, flee, or pay
												tribute. The Nights of the Brave see Blackwood and his
												soldiers defend Taramond against a powerful enemy with
												fierce pride and bravery, emerging victorious and forever
												remembered.</p>
											<p class="mt-1 mb-1">How will your adventures impact the
												conflict? Will Oakheart burn? Will the Geoffrey Blackwood get killed in the defense of Taramond?
												Will the Darkstar Raiders capture the village?</p>
											<ul>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(643), new SOLSCalendar(19670), "Home",
		"Men", "oakheart taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">The history of Oakheart</a>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(12279), new SOLSCalendar(20500), "Home",
		"Men", "geoffrey blackwood taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">Geoffrey Blackwood</a>
												<li><a
													href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, new SOLSCalendar(19484), new SOLSCalendar(19670), "Home",
		"Men", "darkstar raiders taramond", JspConstants.PRAYANCHOR)%>"
													target="_blank">Darkstar Raiders of Taramond</a>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
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
					<a href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>" class="px-3"><small class="font-weight-bold">Pray</small></a>
					<a href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.HELPANCHOR)%>" class="px-3"><small class="font-weight-bold">Help</small></a>
					<a href="<%=URLBuilder.buildRequest(request, JspConstants.INDEX, startCal, endCal, world, relm, tag,
		JspConstants.CONTACTANCHOR)%>" class="pl-3"><small class="font-weight-bold">Contact</small></a>
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
						, James Warmkessel All rights reserved <%= Constants.VERSION %>
					</p>
				</div>
				<div class="d-none d-md-block">
					<h6 class="small mb-0">
						<a href="https://www.facebook.com/groups/915527066379136/"
							class="px-2" target="_blank"><i class="ti-facebook"></i></a>
						<a href="https://twitter.com/shrinesecrets"
							class="px-2" target="_blank"><i class="ti-twitter"></i></a>
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


