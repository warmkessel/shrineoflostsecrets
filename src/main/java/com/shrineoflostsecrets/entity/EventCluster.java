package com.shrineoflostsecrets.entity;

import java.util.ArrayList;
import java.util.List;

import com.shrineoflostsecrets.util.SOLSCalendar;

public class EventCluster {
	
	private long centroid;
	private long lowerBound;
	private long upperBound;
	private final List<Long> values;

	public EventCluster(long centroid) {
		this.centroid = centroid;
		this.lowerBound = 0l;
		this.upperBound = 0l;
		this.values = new ArrayList<>();
	}

	public long getCentroid() {
		return centroid;
	}
	public long getLowerBound() {
		return lowerBound;
	}
	public long getUpperBound() {
		return upperBound;
	}
	public  SOLSCalendar getCentroidDate() {
		return new SOLSCalendar(getCentroid());
	}
	
	public  SOLSCalendar getLowerBoundDate() {
		return new SOLSCalendar(getLowerBound());
	}
	public  SOLSCalendar getUpperBoundDate() {
		return new SOLSCalendar(getUpperBound());
	}
	public void setLowerBound(long lowerBound) {
		this.lowerBound = lowerBound;
	}

	public void setUpperBound(long upperBound) {
		this.upperBound = upperBound;
	}

	public boolean addValue(long value) {
		if (!values.contains(value)) {
			values.add(value);
			return true;
		}
		return false;
	}

	public void updateCentroid() {
		long sum = 0;
		for (Long value : values) {
			sum += value;
		}
		this.centroid = sum / values.size();
	}

	public int getNumberOfElements() {
		return values.size();
	}
	
}