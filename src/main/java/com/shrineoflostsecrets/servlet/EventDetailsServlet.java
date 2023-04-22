package com.shrineoflostsecrets.servlet;


import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shrineoflostsecrets.entity.Event;




//@WebServlet(
//    name = "EventDetailsServlet",
//    urlPatterns = {"/eventDetails"}
//)
public class EventDetailsServlet extends HttpServlet {
	  /**
	 * 
	 */
	private static final long serialVersionUID = 6060776973623197585L;
	private static final Logger log = Logger.getLogger(EventDetailsServlet.class.getName());


@Override
  public void doGet(HttpServletRequest request, HttpServletResponse response) 
      throws IOException {
	
	String key = request.getParameter("key");
	
	Event event2 = new Event();

	event2.loadEvent(new Long(key).longValue());

    log.info("event2 " + event2.toString());

	
    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");

    response.getWriter().print("Hello App Engine!\r\n");

  }

}