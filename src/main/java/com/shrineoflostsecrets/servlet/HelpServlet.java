package com.shrineoflostsecrets.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelpServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -474650905771231494L;

	@Override
	protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		setResponseHeaders(resp);
		resp.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");

	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		setResponseHeaders(resp);
		resp.getWriter().write(
				"<p>Welcome, brave adventurers, to the Shrine of Lost Secrets. This OpenAI plugin has been created to assist our Dungeon Masters in crafting immersive histories and environments for their players. If this is your first time using the Shrine of Lost Secrets, we invite you to visit our YouTube channel at https://www.youtube.com/@ShrineofLostSecrets. For those seeking to delve deeper, you can explore the depths at https://shrineoflostsecrets.com/getStarted.jsp.</p><p>To make the most of this plugin, we recommend that you control the Start Date and End Date using the following commands: \"Shrine, move the start date forward by 100 days\" or \"Shrine, move the end date backward by 50 days.\" You can also reset the Start and End Date by using the command \"Shrine, reset the date.\" If you have personal content within the Shrine of Lost Secrets, you can access it by setting your email address to test@test.com with the command \"Shrine, set my email address to test@test.com.\" Once you've chosen your Starting and Ending date ranges, you can request information such as \"Shrine, tell me about the Blackwood Family,\" \"Shrine, what are the key events of the Nights-of-the-Brave,\" or \"Shrine, how are the key figures in the Whispering-Wood.\" If you prefer a list of events with just the titles, you can request that as well, specifying the number of responses you would like to see.</p><p>May your adventures be filled with joy. If you have any questions, please don't hesitate to contact us at https://shrineoflostsecrets.com/contact.jsp#contact or send us an email at info@shrineoflostsecrets.com. We would greatly appreciate your feedback.</p>");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doOptions(req, resp);
	}

	private void setResponseHeaders(HttpServletResponse resp) {
		resp.setHeader("Access-Control-Allow-Origin", "https://chat.openai.com");
		resp.setHeader("Access-Control-Allow-Headers",
				"Content-Type, openai-conversation-id, Authorization, Content-Length, X-Requested-With, openai-ephemeral-user-id");
		resp.setContentType("text/plain");
	}

}