package com.shrineoflostsecrets.util;

public class CaseControl {
	public static String capFirstLetter(String str) {
		if(null == str || str.length() == 0) {
			return "";
		}
		return  str.substring(0, 1).toUpperCase() + str.substring(1);
	}
}
