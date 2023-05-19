package com.shrineoflostsecrets.servlet;

import java.io.IOException;
import java.util.*;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.cloud.datastore.*;

import com.shrineoflostsecrets.datastore.*;
import com.google.appengine.api.memcache.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.shrineoflostsecrets.constants.*;
import com.shrineoflostsecrets.entity.*;
import com.shrineoflostsecrets.util.*;

public class EventServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5214329767452507374L;
	private static final Logger log = Logger.getLogger(ForwardDate.class.getName());

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doOptions(req, resp);
	}

	protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		setResponseHeaders(resp);
		long startDate = SOLSCalendarConstants.BEGININGOFTHEAGEOFMAN;
		long endDate = SOLSCalendarConstants.MIDPOINTOFMAN;
		Set<String> tag = extractTagsFromRequest(req);

		SOLSCalendar startCal = new SOLSCalendar(startDate);
		SOLSCalendar endCal = new SOLSCalendar(endDate);
		endCal = startCal.endMustBeAfter(endCal);

		String ephemeralUserId = req.getHeader(JspConstants.OPENAIEPHEMERALUSERID);
//		log.info(JspConstants.OPENAIEPHEMERALUSERID +  " "  + ephemeralUserId);

		if (ephemeralUserId != null) {
			String cookieStart = getSessionValue(ephemeralUserId, JspConstants.START);

			if (null != cookieStart && cookieStart.length() > 0) {
				try {
					startCal = startCal.forward(Long.parseLong(cookieStart));
				} catch (NumberFormatException e) {
				}
			}

			String cookieEnd = getSessionValue(ephemeralUserId, JspConstants.END);
			if (null != cookieEnd && cookieEnd.length() > 0) {
				try {
					endCal = endCal.forward(Long.parseLong(cookieStart));
//					log.info("cookie endCal " + endCal.getShortDisplayDate());

				} catch (NumberFormatException e) {
				}
			}
		}
		boolean listOnly = false;
		if (null != req.getParameter(JspConstants.LIST) && req.getParameter(JspConstants.LIST).length() > 0) {
			listOnly = true;
		}
		int count = 5;
		String countParam = req.getParameter(JspConstants.COUNT);
		if (null != countParam && countParam.length() > 0) {
			count = Integer.parseInt(countParam);
		}
		JSONObject jsonReturn = createJsonResponse(startCal, endCal, tag, req, listOnly, count);
		resp.getWriter().write(jsonReturn.toString());
//		for (String paramName : req.getParameterMap().keySet()) {
//			String[] paramValues = req.getParameterValues(paramName);
//			for (String paramValue : paramValues) {
//				log.info("" + paramName + " = " + paramValue + ";");
//			}
//		}

	}

	private void setResponseHeaders(HttpServletResponse resp) {
		resp.setHeader("Access-Control-Allow-Origin", "https://chat.openai.com");
		resp.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
		resp.setHeader("Access-Control-Allow-Headers",
				"Content-Type, openai-conversation-id, Authorization, Content-Length, X-Requested-With, openai-ephemeral-user-id");
		resp.setContentType("text/plain");
	}

	private Set<String> extractTagsFromRequest(HttpServletRequest req) {
		Set<String> tag = new HashSet<>();
		if (req.getParameter(JspConstants.TAGS) != null && req.getParameter(JspConstants.TAGS).length() > 0) {
			List<String> list = Arrays.asList(req.getParameterValues(JspConstants.TAGS));
			for (String str : list) {
				for (String spl : str.split(" ")) {
					tag.add(spl.toLowerCase());
				}
			}
		}
		return tag;
	}

	private JSONObject createJsonResponse(SOLSCalendar startCal, SOLSCalendar endCal, Set<String> tag,
			HttpServletRequest req, boolean listOnly, int count) {
		String world = Constants.HOME;
		String relm = Constants.MEN;

		UserService userService = UserServiceFactory.getUserService();
		User currentUser = userService.getCurrentUser();
		DungonMaster dm = DungonMasterList.getDungonMaster(currentUser);

		JSONObject jsonReturn = new JSONObject();
		jsonReturn.put("eventDateRange", startCal.getShortDisplayDate() + endCal.getShortDisplayDate());
		jsonReturn.put("shrineurl", JspConstants.SHRINEULR + URLBuilder.buildRequest(req, JspConstants.INDEX, startCal,
				endCal, world, relm, tag, JspConstants.PRAYANCHOR));

		List<Entity> entities = EventsList.listEvents(startCal, endCal, world, relm, dm, tag);

		JSONArray jsonArray = new JSONArray();
		EventCollection collection = new EventCollection(entities, count, false);
		for (Event event : collection.getEvents()) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("eventTitle", event.getTitle());
			if (!listOnly) {
				jsonObject.put("eventDescription", event.getShortDesc());
			}
			jsonObject.put("additionalDetails",
					JspConstants.SHRINEULR + URLBuilder.buildRequest(req, JspConstants.DETAILS, startCal, endCal, world,
							relm, tag, "", JspConstants.ID + "=" + event.getKeyString()));
			Set<String> eventTag = convert(event.getTagsString().split(" "));

			jsonObject.put("additionalTags", convertToString(removeExistingTags(eventTag, tag)));
			jsonArray.put(jsonObject);
		}
		jsonReturn.put("events", jsonArray);
		return jsonReturn;
	}

	private String convertToString(Set<String> theNew) {
		StringBuilder theReturn = new StringBuilder();
		for (String tag : theNew) {
			theReturn.append(tag).append(" ");
		}
		return theReturn.toString();
	}

	
	private Set<String> convert(String[] theNew) {
	    return new HashSet<>(Arrays.asList(theNew));

	}
	private Set<String> removeExistingTags(Set<String> newTags, Set<String> existingTags) {
	    newTags.removeAll(existingTags);
	    return newTags;
	}
//	private void setSessionValue(String ephemeralUserId, String parameterName,
//			long parameterValue) {
//		setSessionValue(ephemeralUserId, parameterName, Long.toString(parameterValue));
//	}

//	private void setSessionValue(String ephemeralUserId, String parameterName, String parameterValue) {
//	    String sessionKey = ephemeralUserId + parameterName;
//	    MemcacheService memcache = MemcacheServiceFactory.getMemcacheService();
//	    memcache.put(sessionKey, parameterValue, Expiration.byDeltaSeconds(3600*24*7));
//	}

	private String getSessionValue(String ephemeralUserId, String parameterName) {
		String sessionKey = ephemeralUserId + parameterName;
		MemcacheService memcache = MemcacheServiceFactory.getMemcacheService();
		String value = (String) memcache.get(sessionKey);
		return value;
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doOptions(req, resp);
	}

}