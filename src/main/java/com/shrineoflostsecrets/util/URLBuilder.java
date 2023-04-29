package com.shrineoflostsecrets.util;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.shrineoflostsecrets.constants.JspConstants;

public class URLBuilder {

	
	
	public static String buildRequest(HttpServletRequest request, String page, SOLSCalendar calStart, SOLSCalendar calEnd,
			String world, String relm, String tagString, String anchor) {
		Set<String> tag = new HashSet<String>();
		String[] theArray = tagString.split(" ");
		for(int x=0; x < theArray.length; x++) {
			tag.add(theArray[x]);
		}
		return buildRequest(request, page, calStart, calEnd,
				world, relm, tag, anchor, null);
	}
	
	
	public static String buildRequest(HttpServletRequest request, String page, SOLSCalendar calStart, SOLSCalendar calEnd,
			String world, String relm, Set<String> tag) {
		return buildRequest(request, page, calStart, calEnd,
				world, relm, tag, null, null);
	}
	public static String buildRequest(HttpServletRequest request, String page, SOLSCalendar calStart, SOLSCalendar calEnd,
			String world, String relm, Set<String> tag, String anchor) {
		return buildRequest(request, page, calStart.getTime(), calEnd.getTime(),
				world, relm, tag, anchor, null);
	}
	
	public static String buildRequest(HttpServletRequest request, String page, SOLSCalendar calStart, SOLSCalendar calEnd,
			String world, String relm, Set<String> tag, String anchor, String additional) {
		return buildRequest(request, page, calStart.getTime(), calEnd.getTime(),
				world, relm, tag, anchor, additional);
	}
	
	public static String buildRequest(HttpServletRequest request, String page, long eventStart, long eventEnd,
			String world, String relm, Set<String> tag) {
		return buildRequest(request, page, eventStart, eventEnd,
				world, relm, tag, null);
	}
	public static String buildRequest(HttpServletRequest request, String page, long eventStart, long eventEnd,
			String world, String relm, Set<String> tag, String anchor) {
		return buildRequest(request, page, eventStart, eventEnd,
				world, relm, tag, anchor, null);
	}
	public static String buildRequest(HttpServletRequest request, String page, long eventStart, long eventEnd, String world, String relm, Set<String> tag, String anchor, String additional){
		StringBuffer thePage = new StringBuffer(page).append("?");

			thePage.append(JspConstants.START).append("=").append(eventStart).append("&");
			thePage.append(JspConstants.END).append("=").append(eventEnd).append("&");
		if (null != world && world.length() > 0) {
			thePage.append(JspConstants.WORLD).append("=").append(world).append("&");
		}
		if (null != relm && relm.length() > 0) {
			thePage.append(JspConstants.RELM).append("=").append(relm).append("&");
		}
		if (tag.size() > 0) {
			buildTag(thePage, tag);
		}
		if (null != additional && additional.length() > 0) {
			thePage.append(additional);
		}
		if (null != anchor && anchor.length() > 0) {
			thePage.append("#").append(anchor);
		}
		
		return thePage.toString();
	}

	private static void buildTag(StringBuffer thePage, Set<String> tag) {
		Iterator<String> it = tag.iterator();
		while (it.hasNext())
			thePage.append(JspConstants.TAGS).append("=").append(it.next()).append("&");
	}
}