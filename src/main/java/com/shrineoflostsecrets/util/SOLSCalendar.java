package com.shrineoflostsecrets.util;

import com.shrineoflostsecrets.constants.SOLSCalendarConstants;

public class SOLSCalendar {
	public enum Month {
		JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC
	}

	public enum Season {
		WINTER, SPRING, SUMMER, FALL
	}

	public enum Scale {
		DAY, MONTH, SEASON, YEAR, DECADE, CENTURY
	}

	private final long time;
	private Long century = null;
	private Long decade = null;
	private Long year = null;
	private Long dayOfCentury = null;
	private Long dayOfDecade = null;
	private Long dayOfYear = null;
	private Integer season = null;
	private Integer dayOfSeason = null;
	private Integer month = null;
	private Integer dayOfMonth = null;

	public SOLSCalendar(long time) {
		this.time = time;
	}

	public SOLSCalendar random(long amount) {
		return forward(Math.round(Math.random() * amount));
	}

	public SOLSCalendar backwardSeason() {
		return backward(SOLSCalendarConstants.LENGTHOFSEASON);
	}

	public SOLSCalendar forwardSeason() {
		return forward(SOLSCalendarConstants.LENGTHOFSEASON);
	}

	public SOLSCalendar backwardMonth() {
		return backward(SOLSCalendarConstants.LENTHOFALUNARMONTH);
	}

	public SOLSCalendar forwardMonth() {
		return forward(SOLSCalendarConstants.LENTHOFALUNARMONTH);
	}

	public SOLSCalendar backwardYear() {
		return backward(SOLSCalendarConstants.LENGTHOFYEAR);
	}

	public SOLSCalendar forwardYear() {
		return forward(SOLSCalendarConstants.LENGTHOFYEAR);
	}

	public SOLSCalendar forwardDecade() {
		return forward(SOLSCalendarConstants.LENGTHOFDECADE);
	}

	public SOLSCalendar backwardDecade() {
		return backward(SOLSCalendarConstants.LENGTHOFDECADE);
	}

	public SOLSCalendar forwardCentury() {
		return forward(SOLSCalendarConstants.LENGTHOFCENTURY);
	}

	public SOLSCalendar backwardCentury() {
		return backward(SOLSCalendarConstants.LENGTHOFCENTURY);
	}

	public SOLSCalendar forward(Scale scale) {
		return forward(scale, true);
	}

	public SOLSCalendar backward(Scale scale) {
		return forward(scale, false);

	}

	public SOLSCalendar forward(Scale scale, boolean forward) {
		long theAmount = 0;
		if (Scale.DAY.equals(scale)) {
			theAmount = 1;
		} else if (Scale.MONTH.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENTHOFALUNARMONTH;
		} else if (Scale.SEASON.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFSEASON;
		} else if (Scale.YEAR.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFYEAR;
		} else if (Scale.DECADE.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFDECADE;
		} else if (Scale.CENTURY.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFCENTURY;
		}
		if (!forward) {
			theAmount = -theAmount / 2;
		} else {
			theAmount = theAmount / 2;

		}
		return forward(theAmount);
	}

	public SOLSCalendar forward(long amount) {
		return new SOLSCalendar(getTime() + amount);
	}

	public SOLSCalendar backward(long amount) {
		return forward(-amount);
	}

	public SOLSCalendar justCentury() {
		return new SOLSCalendar(getTime() - getDayOfCentury());
	}

	public SOLSCalendar justDecade() {
		return new SOLSCalendar(getTime() - getDayOfDecade());
	}

	public SOLSCalendar justYear() {
		return new SOLSCalendar(getTime() - getDayOfYear());
	}

	public SOLSCalendar justSeason() {
		return new SOLSCalendar(getTime() - getDayOfSeason());
	}

	public SOLSCalendar justMonth() {
		return new SOLSCalendar(getTime() - getDayOfMonth());
	}

	public SOLSCalendar getRandomDate(SOLSCalendar endDate) {
		double therange = endDate.getTime() - getTime();
		return new SOLSCalendar(getTime() + Math.round(Math.random() * therange));
	}

	public long getTime() {
		return time;
	}

	public long getCentury() {
		if (null == century) {
			century = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFCENTURY);
		}
		return century;

	}

	public long getDecade() {
		if (null == decade) {
			decade = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFDECADE);
		}
		return decade;

	}

	public long getYear() {
		if (null == year) {
			year = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFYEAR);
		}
		return year;

	}

	public int getDayOfCentury() {
		if (null == dayOfCentury) {
			dayOfCentury = Long.valueOf(Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFCENTURY));
		}
		return dayOfCentury.intValue();

	}

	public int getDayOfDecade() {
		if (null == dayOfDecade) {
			dayOfDecade = Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFDECADE);
		}
		return dayOfDecade.intValue();

	}

	public int getDayOfYear() {
		if (null == dayOfYear) {
			dayOfYear = Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFYEAR);
		}
		return dayOfYear.intValue();

	}

	public int getSeason() {
		if (null == season) {
			season = Math.floorMod(Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFSEASON),
					Season.values().length);
		}
		return season.intValue();
	}

	public int getDayOfSeason() {
		if (dayOfSeason == null) {
			dayOfSeason = (int) Math.floorMod(
					getTime() < 0 ? getTime() + SOLSCalendarConstants.LENGTHOFSEASON : getTime(),
					SOLSCalendarConstants.LENGTHOFSEASON);
		}
		return dayOfSeason;
	}

	public int getMonth() {
		if (month == null) {
			month = Math.floorMod((int) Math.floorDiv(getTime(), SOLSCalendarConstants.LENTHOFALUNARMONTH),
					Month.values().length);
		}
		return month;
	}

	public int getDayOfMonth() {
		if (dayOfMonth == null) {
			dayOfMonth = (int) Math.floorMod(
					getTime() < 0 ? getTime() + SOLSCalendarConstants.LENTHOFALUNARMONTH : getTime(),
					SOLSCalendarConstants.LENTHOFALUNARMONTH);
		}
		return dayOfMonth;
	}

	public String getMonthName() {
		if (getMonth() < 0 || getMonth() > 11) {
			throw new IllegalArgumentException("Invalid month number: " + getMonth());
		}
		return Month.values()[getMonth()].toString();
	}

	public String getSeasonName() {
		if (getSeason() < 0 || getSeason() > 3) {
			throw new IllegalArgumentException("Invalid season number: " + getSeason());
		}
		return Season.values()[getSeason()].toString();
	}

	public String getShortDisplayDate() {
		return getMonthName() + " " + (getDayOfMonth() + 1) + ", " + getYear();
	}

	public String getDisplayDate() {
		return getMonthName() + " " + (getDayOfMonth() + 1) + ", " + getYear() + " (" + getSeasonName() + ")";
	}

	public long getElapsedTime(SOLSCalendar endCal) {
		return endCal.getTime() - getTime();
	}

	public Scale getScale(SOLSCalendar endCal) {
		if (getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFCENTURY) {
			return Scale.CENTURY;
		} else if (getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFDECADE) {
			return Scale.DECADE;
		} else if (getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFYEAR) {
			return Scale.YEAR;
		} else if (getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFSEASON) {
			return Scale.SEASON;
		} else if (getElapsedTime(endCal) > SOLSCalendarConstants.LENTHOFALUNARMONTH) {
			return Scale.MONTH;
		} else {
			return Scale.DAY;
		}
	}

	public SOLSCalendar endMustBeAfter(SOLSCalendar endCal) {
		if (getTime() >= endCal.getTime()) {
			return forwardMonth();
		} else {
			return endCal;
		}

	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}

		if (!(obj instanceof SOLSCalendar)) {
			return false;
		}

		SOLSCalendar other = (SOLSCalendar) obj;
		return this.getTime() == other.getTime();
	}

	@Override
	public int hashCode() {
		return Long.hashCode(getTime());
	}

}
