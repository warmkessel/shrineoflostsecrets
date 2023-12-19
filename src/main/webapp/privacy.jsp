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
<script  async="true"  src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
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
<title>Shrine of Lost Secrets - Privacy</title>
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
					<%if (currentUser != null) { %>
						<a href="<%= userService.createLogoutURL(URLBuilder.buildRequest(request, JspConstants.PIVACY, startCal, endCal, world, relm, tag,"", ""))%>"
						class="btn btn-primary btn-sm">Welcome <%=currentUser.getNickname() %></a>
					<%}else { %>
					<a href="<%= userService.createLoginURL(URLBuilder.buildRequest(request, JspConstants.PIVACY, startCal, endCal, world, relm, tag,"", ""))%>"
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
			<h6 class="section-subtitle text-center">Privacy Policy</h6>
			<h3 class="section-title mb-5 text-center">Our Policy</h3>
			<div class="row align-items-center">
				<div class="row">
					<div class="col-md-6 mb-4"></div>
					<div class="card bg-light">
						<div class="card-body px-4 pb-4 text-center">
							<div class="row text-left">
								<div class="col-md-12 my-4">
									<div class="d-flex">
										<div class="flex-grow-1">
											<p class="mt-1 mb-0" id="summary">
<p>
Last updated: 4/27/2023
</p>
<p>
This Privacy Policy explains how shrineoflostsecrets.com ("we", "us", "our") collects, uses, and discloses your personal information when you use our website located at shrineoflostsecrets.com (the "Site").
</p>
<p>
We respect your privacy and are committed to protecting your personal information. Please read this Privacy Policy carefully before using our Site.
</p>
<p>
Information We Collect
When you use our Site, we may collect certain personal information that you provide to us, such as your name, email address, phone number, and any other information you choose to provide.
</p>
<p>
In addition, we may automatically collect certain information about your device, including your IP address, browser type, referring/exit pages, and operating system.
</p>
<p>
How We Use Your Information
We may use your personal information to:
</p>
<p>
Provide and maintain our Site
Improve our Site and customer service
Send you promotional emails and newsletters
Respond to your inquiries and requests
Provide technical support
Comply with applicable laws, regulations, and legal processes
How We Share Your Information
We may share your personal information with third-party service providers that assist us in providing our Site, such as website hosting, email delivery, and customer support. We require these service providers to use your personal information only to provide services to us and to protect your personal information in accordance with this Privacy Policy.
</p>
<p>
We may also share your personal information if we believe it is necessary to comply with applicable laws, regulations, or legal processes, or to protect our rights, property, or safety or that of others.
</p>
<p>
Cookies
We may use cookies and similar technologies to collect information about how you use our Site and to improve your user experience. You can set your browser to refuse all or some browser cookies, or to alert you when cookies are being sent. However, if you do not consent to our use of cookies, some portions of our Site may not function properly.
</p>
<p>
Security
We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. However, no method of transmission over the internet, or method of electronic storage, is completely secure. Therefore, we cannot guarantee absolute security.
</p>
<p>
Your Rights
You may have certain rights under applicable privacy laws, including the right to access, correct, or delete your personal information. If you would like to exercise any of these rights, please contact us using the contact information provided below.
</p>
<p>
Changes to Our Privacy Policy
We reserve the right to modify or update this Privacy Policy at any time. We will post any changes to this Privacy Policy on our Site, and the updated Privacy Policy will become effective immediately upon posting.
</p>
<p>
Contact Us
If you have any questions or concerns about this Privacy Policy or our use of your personal information, please contact us at info@shrineoflostsecrets.com.
</p>
<p>
Thank you for using shrineoflostsecrets.com
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
					<a href="<%=URLBuilder.buildRequest(request, JspConstants.HELP, startCal, endCal, world, relm, tag,
		JspConstants.HELPANCHOR)%>" class="px-3"><small class="font-weight-bold">Help</small></a>
					<a href="<%=URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag,
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


