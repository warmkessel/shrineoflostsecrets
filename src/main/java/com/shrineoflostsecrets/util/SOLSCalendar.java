package com.shrineoflostsecrets.util;

import com.shrineoflostsecrets.constants.SOLSCalendarConstants;

public class SOLSCalendar {
	public enum Month {
	    JAN,
	    FEB,
	    MAR,
	    APR,
	    MAY,
	    JUN,
	    JUL,
	    AUG,
	    SEP,
	    OCT,
	    NOV,
	    DEC
	}
	public enum Season {
	    WINTER,
	    SPRING,
	    SUMMER,
	    FALL
	}
	public enum Scale {
	    DAY,
		MONTH,
	    SEASON,
	    YEAR,
	    DECADE,
	    CENTURY
	}
	



	private final long time;
	private Long centry = null;
	private Long decade = null;
	private Long year = null;
	private Long dayofcentury = null;
	private Long dayofdecade = null;
	private Long dayofyear = null;
	private Integer season = null;
	private Integer dayofSeason = null;
	private Integer month = null;
	private Integer dayofMonth = null;

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
		if(Scale.DAY.equals(scale)) {
			theAmount = 1;
		}
		else if(Scale.MONTH.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENTHOFALUNARMONTH;
		}
		else if(Scale.SEASON.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFSEASON;
		}
		else if(Scale.YEAR.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFYEAR;
		}
		else if(Scale.DECADE.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFDECADE;
		}
		else if(Scale.CENTURY.equals(scale)) {
			theAmount = SOLSCalendarConstants.LENGTHOFCENTURY;
		}
		if(!forward) {
			theAmount = -theAmount/2;
		}
		else {
			theAmount = theAmount/2;

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

	public long getTime() {
		return time;
	}
	public long getCentury() {
		if (null == centry) {
			centry = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFCENTURY);
		}
//		Math.floorMod(getTime(), SOLSCalendarConstants.LENGTHOFDECADE);

		return centry;

	}
	public long getDecade() {
		if (null == decade) {
			decade = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFDECADE);
		}
//		Math.floorMod(getTime(), SOLSCalendarConstants.LENGTHOFDECADE);

		return decade;

	}

	public long getYear() {
		if (null == year) {
			year = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFYEAR);
		}
//		Math.floorMod(getTime(), SOLSCalendarConstants.LENTHOFALUNARMONTH);

		return year;

	}

	
	public int getDayOfCentury() {
		if (null == dayofcentury) {
			dayofcentury = new Long(Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFCENTURY));
		}
		return dayofcentury.intValue();

	}
	
	
	public int getDayOfDecade() {
		if (null == dayofdecade) {
			dayofdecade = new Long(Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFDECADE));
		}

		return dayofdecade.intValue();

	}
	
	public int getDayOfYear() {

		if (null == dayofyear) {
			dayofyear = new Long(Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTHOFYEAR));
		}

		return dayofyear.intValue();

	}
	public int getSeason() {
		if (null == season) {
			season = Math.floorMod(new Long(Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTHOFSEASON)).intValue(), Season.values().length);
		}
		return season.intValue();
	}

	public int getDayOfSeason() {
		if (null == dayofSeason) {
			if(getTime() < 0) {
				dayofSeason = new Long(Math.floorMod(getTime() + SOLSCalendarConstants.LENGTHOFSEASON, SOLSCalendarConstants.LENGTHOFSEASON)).intValue();

			}else {
				dayofSeason = new Long(Math.floorMod(getTime(), SOLSCalendarConstants.LENGTHOFSEASON)).intValue();
			}
		}
		return dayofSeason;
	}

	public int getMonth() {
		if (null == month) {
			month = Math.floorMod((new Long(Math.floorDiv(getTime(), SOLSCalendarConstants.LENTHOFALUNARMONTH)).intValue()), Month.values().length);
		}
		return month.intValue();
	}

	public int getDayOfMonth() {
		if (null == dayofMonth) {
			if(getTime() < 0) {
				dayofMonth = new Long(Math.floorMod(getTime() + SOLSCalendarConstants.LENTHOFALUNARMONTH, SOLSCalendarConstants.LENTHOFALUNARMONTH)).intValue();

			}
			else {
				dayofMonth = new Long(Math.floorMod(getTime(), SOLSCalendarConstants.LENTHOFALUNARMONTH)).intValue();
			}
		}
		return dayofMonth.intValue();
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
		return new StringBuffer().append(getMonthName()).append(" ").append(getDayOfMonth()+1).append(", ").append(getYear()).toString();

}
	public String getDisplayDate() {
				return new StringBuffer().append(getMonthName()).append(" ").append(getDayOfMonth()+1).append(", ").append(getYear()).append(" (").append(getSeasonName()).append(")").toString();
	}
	public long getElapsedTime(SOLSCalendar endCal) {
		return endCal.getTime() - getTime();
	}
	public Scale getScale(SOLSCalendar endCal) {
		if(getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFCENTURY) {
			return Scale.CENTURY;
		} 
		else if(getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFDECADE) {
			return Scale.DECADE;
		}
		else if(getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFYEAR) {
			return Scale.YEAR;
		}
		else if(getElapsedTime(endCal) > SOLSCalendarConstants.LENGTHOFSEASON) {
			return Scale.SEASON;
		}
		else if(getElapsedTime(endCal) > SOLSCalendarConstants.LENTHOFALUNARMONTH) {
			return Scale.MONTH;
		}
		else{
			return Scale.DAY;
		}
	}
//	public Scale getScale(SOLSCalendar endCal) {
//		if(endCal.getTime() - getTime() > LENGTHOFCENTURY) {
//			return Scale.CENTURY;
//		} 
//		else if(endCal.getTime() - getTime() > LENGTHOFDECADE) {
//			return Scale.DECKADE;
//		}
//		else if(endCal.getTime() - getTime() > LENGTHOFYEAR ) {
//			return Scale.YEAR;
//		}
//		else if(endCal.getTime() - getTime() > LENGTHOFSEASON) {
//			return Scale.SEASON;
//		}
//		else if(endCal.getTime() - getTime() > LENTHOFALUNARMONTH) {
//			return Scale.MONTH;
//		}
//		else{
//			return Scale.DAY;
//		}
//	}
	public SOLSCalendar endMustBeAfter(SOLSCalendar endCal) {
		if(getTime()  >= endCal.getTime()) {
			return forwardMonth();
		}
		else {
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
