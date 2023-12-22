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
        return forward((long) (Math.random() * amount));
    }

    public SOLSCalendar backwardSeason() {
        return backward(SOLSCalendarConstants.LENGTH_OF_SEASON);
    }

    public SOLSCalendar forwardSeason() {
        return forward(SOLSCalendarConstants.LENGTH_OF_SEASON);
    }

    public SOLSCalendar backwardMonth() {
        return backward(SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH);
    }

    public SOLSCalendar forwardMonth() {
        return forward(SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH);
    }

    public SOLSCalendar backwardYear() {
        return backward(SOLSCalendarConstants.LENGTH_OF_YEAR);
    }

    public SOLSCalendar forwardYear() {
        return forward(SOLSCalendarConstants.LENGTH_OF_YEAR);
    }

    public SOLSCalendar forwardDecade() {
        return forward(SOLSCalendarConstants.LENGTH_OF_DECADE);
    }

    public SOLSCalendar backwardDecade() {
        return backward(SOLSCalendarConstants.LENGTH_OF_DECADE);
    }

    public SOLSCalendar forwardCentury() {
        return forward(SOLSCalendarConstants.LENGTH_OF_CENTURY);
    }

    public SOLSCalendar backwardCentury() {
        return backward(SOLSCalendarConstants.LENGTH_OF_CENTURY);
    }

    public SOLSCalendar forward(Scale scale) {
        return forward(scale, true);
    }

    public SOLSCalendar backward(Scale scale) {
        return forward(scale, false);
    }

    public SOLSCalendar forward(Scale scale, boolean forward) {
        long amount = 0;
        switch (scale) {
            case DAY:
                amount = 1;
                break;
            case MONTH:
                amount = SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH;
                break;
            case SEASON:
                amount = SOLSCalendarConstants.LENGTH_OF_SEASON;
                break;
            case YEAR:
                amount = SOLSCalendarConstants.LENGTH_OF_YEAR;
                break;
            case DECADE:
                amount = SOLSCalendarConstants.LENGTH_OF_DECADE;
                break;
            case CENTURY:
                amount = SOLSCalendarConstants.LENGTH_OF_CENTURY;
                break;
        }
        return forward(forward ? amount : -amount);
    }

    public SOLSCalendar forward(long amount) {
        return new SOLSCalendar(this.time + amount);
    }

    public SOLSCalendar backward(long amount) {
        return forward(-amount);
    }

    public SOLSCalendar justCentury() {
        return new SOLSCalendar(this.time - getDayOfCentury());
    }

    public SOLSCalendar justDecade() {
        return new SOLSCalendar(this.time - getDayOfDecade());
    }

    public SOLSCalendar justYear() {
        return new SOLSCalendar(this.time - getDayOfYear());
    }

    public SOLSCalendar justSeason() {
        return new SOLSCalendar(this.time - getDayOfSeason());
    }

    public SOLSCalendar justMonth() {
        return new SOLSCalendar(this.time - getDayOfMonth());
    }

    public SOLSCalendar getRandomDate(SOLSCalendar endDate) {
        long range = endDate.getTime() - this.time;
        return new SOLSCalendar(this.time + (long) (Math.random() * range));
    }

    public long getTime() {
        return this.time;
    }

	public long getCentury() {
		if (null == century) {
			century = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTH_OF_CENTURY);
		}
		return century;

	}

	public long getDecade() {
		if (null == decade) {
			decade = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTH_OF_DECADE);
		}
		return decade;

	}

	public long getYear() {
		if (null == year) {
			year = Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTH_OF_YEAR);
		}
		return year;

	}

	public int getDayOfCentury() {
		if (null == dayOfCentury) {
			dayOfCentury = Long.valueOf(Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTH_OF_CENTURY));
		}
		return dayOfCentury.intValue();

	}

	public int getDayOfDecade() {
		if (null == dayOfDecade) {
			dayOfDecade = Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTH_OF_DECADE);
		}
		return dayOfDecade.intValue();

	}

	public int getDayOfYear() {
		if (null == dayOfYear) {
			dayOfYear = Math.floorMod(Math.abs(getTime()), SOLSCalendarConstants.LENGTH_OF_YEAR);
		}
		return dayOfYear.intValue();

	}

	public int getSeason() {
		if (null == season) {
			season = Math.floorMod(Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTH_OF_SEASON),
					Season.values().length);
		}
		return season.intValue();
	}

	public int getDayOfSeason() {
		if (dayOfSeason == null) {
			dayOfSeason = (int) Math.floorMod(
					getTime() < 0 ? getTime() + SOLSCalendarConstants.LENGTH_OF_SEASON : getTime(),
					SOLSCalendarConstants.LENGTH_OF_SEASON);
		}
		return dayOfSeason;
	}

	public int getMonth() {
		if (month == null) {
			month = Math.floorMod((int) Math.floorDiv(getTime(), SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH),
					Month.values().length);
		}
		return month;
	}

	public int getDayOfMonth() {
		if (dayOfMonth == null) {
			dayOfMonth = (int) Math.floorMod(
					getTime() < 0 ? getTime() + SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH : getTime(),
					SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH);
		}
		return dayOfMonth;
	}

	public String getMonthName() {
        int monthIndex = getMonth();
        if (monthIndex < 0 || monthIndex >= Month.values().length) {
            throw new IllegalArgumentException("Invalid month number: " + monthIndex);
        }
        return Month.values()[monthIndex].toString();
    }

    public String getSeasonName() {
        int seasonIndex = getSeason();
        if (seasonIndex < 0 || seasonIndex >= Season.values().length) {
            throw new IllegalArgumentException("Invalid season number: " + seasonIndex);
        }
        return Season.values()[seasonIndex].toString();
    }

    public String getShortDisplayDate() {
        return getMonthName() + " " + (getDayOfMonth() + 1) + ", " + getYear();
    }

    public String getDisplayDate() {
        return getShortDisplayDate() + " (" + getSeasonName() + ")";
    }

    public long getElapsedTime(SOLSCalendar endCal) {
        return endCal.getTime() - this.time;
    }

    public Scale getScale(SOLSCalendar endCal) {
        long elapsedTime = getElapsedTime(endCal);
        if (elapsedTime > SOLSCalendarConstants.LENGTH_OF_CENTURY) {
            return Scale.CENTURY;
        } else if (elapsedTime > SOLSCalendarConstants.LENGTH_OF_DECADE) {
            return Scale.DECADE;
        } else if (elapsedTime > SOLSCalendarConstants.LENGTH_OF_YEAR) {
            return Scale.YEAR;
        } else if (elapsedTime > SOLSCalendarConstants.LENGTH_OF_SEASON) {
            return Scale.SEASON;
        } else if (elapsedTime > SOLSCalendarConstants.LENGTH_OF_A_LUNAR_MONTH) {
            return Scale.MONTH;
        } else {
            return Scale.DAY;
        }
    }

    public SOLSCalendar endMustBeAfter(SOLSCalendar endCal) {
        if (this.time >= endCal.getTime()) {
            return this.forwardMonth();
        } else {
            return endCal;
        }
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof SOLSCalendar)) {
            return false;
        }
        SOLSCalendar other = (SOLSCalendar) obj;
        return this.time == other.getTime();
    }

    @Override
    public int hashCode() {
        return Long.hashCode(this.time);
    }
}