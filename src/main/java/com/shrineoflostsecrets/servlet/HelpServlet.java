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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException
        {
        	doOptions(req, resp);
        }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    { 
        // pre-flight request processing
    	resp.setHeader("Access-Control-Allow-Origin", "https://chat.openai.com");
    	resp.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
    	resp.setHeader("Access-Control-Allow-Headers", "Content-Type");   
    	resp.setHeader("Access-Control-Allow-Headers", "openai-conversation-id, Content-Type, Authorization, Content-Length, X-Requested-With, openai-ephemeral-user-id");    	
    	resp.setContentType("text/plain");
    	resp.getWriter().write("The Shrine is here to help, you might try to address the shrine:taramond");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    {
    	doOptions(req, resp);
    }
    
}