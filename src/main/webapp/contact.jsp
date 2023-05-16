<%@ page import="java.util.Properties"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.MessagingException"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.internet.AddressException"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
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
<script async="true" src="https://www.googletagmanager.com/gtag/js?id=G-N2VTBWYNCJ"></script>
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

boolean error = false;


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

// Get the subject and body parameters from the request
String subject = request.getParameter("subject");
String body = request.getParameter("body");
String pageurl = request.getParameter("pageurl");
String errorString = request.getParameter("error");
error = Boolean.valueOf(errorString);



String emailResp = null;
if ((error || null != currentUser) && subject != null && body != null) {
    Properties props = new Properties();
    Session mailSession = Session.getDefaultInstance(props, null);

    try {
        // Create a new email message
        Message msg = new MimeMessage(mailSession);
        msg.setFrom(new InternetAddress(currentUser.getEmail(), currentUser.getNickname()));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress("comment@shrineoflostsecrets.com", "Shrine of Lost Secrets"));
        msg.setSubject("SOLS:" + subject);
        msg.setText(body + "\r" + pageurl);

        // Send the email
        Transport.send(msg);

        emailResp = "We got it!";
    } catch (AddressException e) {
        //out.println("Error: " + e.getMessage());
        emailResp = "Error: " + e.getMessage();

    } catch (MessagingException e) {
        emailResp = "Error: " + e.getMessage();
    }
}// else {
//    emailResp = "Error: Missing subject or body.";
//}
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
<title>Shrine of Lost Secrets - Contact</title>
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
						href="<%=URLBuilder.buildRequest(request, JspConstants.GETSTARTED, startCal, endCal, world, relm, tag,
		JspConstants.PRAYANCHOR)%>">Get
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
		URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag))%>"
						class="btn btn-primary btn-sm">Welcome <%=currentUser.getNickname()%></a>
						<%
						} else {
						%> <a
						href="<%=userService.createLoginURL(
		URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag))%>"
						class="btn btn-primary btn-sm">Login</a> <%}%>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	<!-- End Of Second Navigation -->


<%
						if (currentUser != null) {
						%> 
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
					<h3 class="section-title mb-5 text-center" id="reponse"></h3>
					<form action="<%= JspConstants.CONTACT %>" method="get"
						enctype="text/plain">
						<input type="hidden" name="pageurl"
							value="<%=request.getRequestURI() + (request.getQueryString() == null ? "" : "?" + request.getQueryString())%>">
						<div class="form-group">
							<input type="text" class="form-control" id="name"
								aria-describedby="emailHelp" placeholder="Subject"
								name="subject">
							<textarea class="form-control" id="message"
								aria-describedby="emailHelp"
								placeholder="Your comment or question" name="body" rows="4"
								cols="50"></textarea>
						</div>
						<button type="submit" class="btn btn-primary btn-block">Share
							your thoughts</button>
						<br> <a href="https://www.patreon.com/your_profile"
							target="_blank"> <i class="fab fa-patreon"></i> Become a
							Patron
						</a> <small class="form-text text-muted mt-3">We appreciate
							your interest. Check our <a
							href="<%=URLBuilder.buildRequest(request, JspConstants.PIVACY, startCal, endCal, world, relm, tag)%>">Privacy
								Policy</a>
						</small>

						<%if(null != emailResp){ %>
						<script>
							var modal = document.getElementById('reponse');
							modal.innerHTML = "<%=emailResp%>";
						</script>
						<%}%>
					</form>
				</div>
			</div>
		</div>
	</section>
	<!-- End OF Contact Section -->
	<%
						} else {
						%>
							<section id="<%=JspConstants.CONTACTANCHOR%>" class="bg-white">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-md-6 d-none d-md-block">
					<img src="assets/imgs/contact.jpg"
						alt="Shrine of Lost Secrets Landing page"
						class="w-100 rounded shadow">
				</div>
				<div class="col-md-6">				
					<h3 class="section-title mb-5 text-center" id="reponse">We'd love to hear your thoughts. Kindly login so we can receive your message.</h3>
					<a href="<%=userService.createLoginURL(
		URLBuilder.buildRequest(request, JspConstants.CONTACT, startCal, endCal, world, relm, tag, "", ""))%>"
						class="btn btn-primary btn-sm">Login</a> 
						<br> <a href="https://www.patreon.com/your_profile"
							target="_blank"> <i class="fab fa-patreon"></i> Become a
							Patron
						</a> <small class="form-text text-muted mt-3">We appreciate
							your interest. Check our <a
							href="<%=URLBuilder.buildRequest(request, JspConstants.PIVACY, startCal, endCal, world, relm, tag)%>">Privacy
								Policy</a>
						</small>

				</div>
			</div>
		</div>
	</section>
	<%} %>
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