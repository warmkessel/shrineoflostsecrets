package com.shrineoflostsecrets.servlet;

import java.io.IOException;
import java.util.*;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.google.appengine.api.memcache.Expiration;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.shrineoflostsecrets.constants.*;
import com.shrineoflostsecrets.datastore.DungonMasterList;
import com.shrineoflostsecrets.entity.DungonMaster;
import com.shrineoflostsecrets.util.*;

public class DateServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5214329767452507374L;
	private static final Logger log = Logger.getLogger(DateServlet.class.getName());

	@Override
	protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		setResponseHeaders(resp);
		resp.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		setResponseHeaders(resp);
		long startDate = SOLSCalendarConstants.BEGININGOFTHEAGEOFMAN;
		long endDate = SOLSCalendarConstants.MIDPOINTOFMAN;
		Set<String> tag = extractTagsFromRequest(req);

		SOLSCalendar startCal = new SOLSCalendar(startDate);
		SOLSCalendar endCal = new SOLSCalendar(endDate);
		endCal = startCal.endMustBeAfter(endCal);

		String ephemeralUserId = req.getHeader(JspConstants.OPENAIEPHEMERALUSERID);
//		log.info(JspConstants.OPENAIEPHEMERALUSERID +  " "  + ephemeralUserId);

		DungonMaster dm = null;

		if (ephemeralUserId != null) {
			String cookieStart = getSessionValue(ephemeralUserId, JspConstants.START);

			if (null != cookieStart && cookieStart.length() > 0) {
				try {
					startCal = new SOLSCalendar(Long.parseLong(cookieStart));

				} catch (NumberFormatException e) {
				}
			}

			String cookieEnd = getSessionValue(ephemeralUserId, JspConstants.END);
			if (null != cookieEnd && cookieEnd.length() > 0) {
				try {
					endCal = new SOLSCalendar(Long.parseLong(cookieEnd));
//					log.info("cookie endCal " + endCal.getShortDisplayDate());

				} catch (NumberFormatException e) {
				}
			}
			String startValue = req.getParameter(JspConstants.START);
			if (null != startValue && startValue.length() > 0) {
				try {
					startCal = startCal.forward(Long.parseLong(startValue));
					setSessionValue(ephemeralUserId, JspConstants.START, startCal.getTime());

				} catch (NumberFormatException e) {
				}

			}
			String endValue = req.getParameter(JspConstants.END);
			if (null != endValue && endValue.length() > 0) {
				try {
					endCal = endCal.forward(Long.parseLong(endValue));

					setSessionValue(ephemeralUserId, JspConstants.END, endCal.getTime());
				} catch (NumberFormatException e) {
				}
			}
			if (null == dm) {
				String emailValue = req.getParameter(JspConstants.EMAIL);
				if (null != emailValue && emailValue.length() > 0) {
					setSessionValue(ephemeralUserId, JspConstants.EMAIL, emailValue);
				} else {
					emailValue = getSessionValue(ephemeralUserId, JspConstants.EMAIL);
				}
				if(null != emailValue && emailValue.length() > 0) {
					dm = DungonMasterList.getDungonMaster(emailValue);
				}
			}

		}
		if (null == dm) {
			UserService userService = UserServiceFactory.getUserService();
			User currentUser = userService.getCurrentUser();
			dm = DungonMasterList.getDungonMaster(currentUser);
		}
		if (null != req.getParameter(JspConstants.RESET) && req.getParameter(JspConstants.RESET).length() > 0) {
			startCal = new SOLSCalendar(SOLSCalendarConstants.BEGININGOFTHEAGEOFMAN);
			endCal = new SOLSCalendar(SOLSCalendarConstants.MIDPOINTOFMAN);
			setSessionValue(ephemeralUserId, JspConstants.START, startCal.getTime());
			setSessionValue(ephemeralUserId, JspConstants.END, endCal.getTime());
			log.info("reset " + startCal.getTime());
		}

		JSONObject jsonReturn = createJsonResponse(startCal, endCal, tag, req, dm);
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
			HttpServletRequest req, DungonMaster dm) {
		JSONObject jsonReturn = new JSONObject();
		if (null != dm) {
			jsonReturn.put("userName", dm.getUsername());
		}
		jsonReturn.put("eventDateRange", startCal.getShortDisplayDate() + " - "+ endCal.getShortDisplayDate());
		jsonReturn.put("shrineurl", JspConstants.SHRINEULR + URLBuilder.buildRequest(req, JspConstants.INDEX, startCal,
				endCal, Constants.HOME, Constants.MEN, tag, JspConstants.PRAYANCHOR));
		return jsonReturn;
	}

	private void setSessionValue(String ephemeralUserId, String parameterName, long parameterValue) {
		setSessionValue(ephemeralUserId, parameterName, Long.toString(parameterValue));
	}

	private void setSessionValue(String ephemeralUserId, String parameterName, String parameterValue) {
		String sessionKey = ephemeralUserId + parameterName;
		MemcacheService memcache = MemcacheServiceFactory.getMemcacheService();
		memcache.put(sessionKey, parameterValue, Expiration.byDeltaSeconds(3600 * 24 * 7));
	}

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