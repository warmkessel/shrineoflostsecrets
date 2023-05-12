package com.shrineoflostsecrets.entity;

import java.util.*;
import java.util.stream.Collectors;

import com.google.cloud.datastore.Entity;
import com.shrineoflostsecrets.constants.EventConstants;

public class EventCollection {
	private List<EventCluster> eventsCluster = new ArrayList<EventCluster>();
	private List<Event> events = new ArrayList<Event>();
	private boolean moreEvents = false;
	public static final int MAXRETURNSIZE = 50;
	public static final int MAXNUMBEROFCLUSTERS = 5;

	public EventCollection(List<Entity> entities) {
		moreEvents = (entities.size() >MAXRETURNSIZE );
		for(int x = 0; x < Math.min(entities.size(), MAXRETURNSIZE); x++) {
			Event event = new Event();
			event.loadFromEntity(entities.get(x));
			events.add(event);
		}
		if(isMoreEvents()){
			eventsCluster = kMeansClustering(getEntityIds(entities));
		}
	}

	public static long[] getEntityIds(List<Entity> entities) {
		return entities.stream().mapToLong(entity -> entity.getLong(EventConstants.EVENTDATE)).toArray();
	}

	private static List<EventCluster> kMeansClustering(long[] values) {
		return kMeansClustering(values, Math.round(values.length/20));
		
	}
	private static List<EventCluster> kMeansClustering(long[] values, int numClusters) {
		List<Long> valueList = Arrays.stream(values).boxed().collect(Collectors.toList());
		valueList.sort(Long::compareTo);

		List<Long> initialCentroids = new ArrayList<>();
		for (int i = 0; i < numClusters; i++) {
			initialCentroids.add(valueList.get(i * (valueList.size() / numClusters)));
		}

		List<EventCluster> clusters = new ArrayList<>();
		for (Long centroid : initialCentroids) {
			EventCluster cluster = new EventCluster(centroid);
			cluster.setUpperBound(cluster.getCentroid());
			cluster.setLowerBound(cluster.getCentroid());
			clusters.add(cluster);
		}

		boolean clustersChanged;
		do {
			clustersChanged = false;

			for (Long value : valueList) {
				EventCluster closestCluster = null;
				long minDistance = Long.MAX_VALUE;

				for (EventCluster cluster : clusters) {
					long distance = Math.abs(cluster.getCentroid() - value);
					if (distance < minDistance) {
						minDistance = distance;
						closestCluster = cluster;
					}
				}

				boolean clusterUpdated = closestCluster.addValue(value);
				if (clusterUpdated) {
					clustersChanged = true;
				}
			}

			for (EventCluster cluster : clusters) {
				cluster.updateCentroid();
			}

			// Sort clusters by their centroids
			clusters.sort(Comparator.comparingLong(EventCluster::getCentroid));

			// Update clusters' bounds
			for (int i = 0; i < clusters.size() - 1; i++) {
				EventCluster currentCluster = clusters.get(i);
				EventCluster nextCluster = clusters.get(i + 1);
				long newBound = (currentCluster.getCentroid() + nextCluster.getCentroid()) / 2;
				currentCluster.setUpperBound(newBound);
				nextCluster.setLowerBound(newBound);
			}

		} while (clustersChanged);

		return clusters;
	}

	public List<EventCluster> getEventsCluster() {
	    // Sort eventsCluster by EventCluster size
	    Collections.sort(eventsCluster, Comparator.comparingInt(EventCluster::getNumberOfElements));

	    // Remove clusters with size 0
	    eventsCluster.removeIf(cluster -> cluster.getNumberOfElements() == 0);

	    return eventsCluster;
	}
	
	public List<Event> getEvents() {
		return events;
	}
	

	public boolean isMoreEvents() {
		return moreEvents;
	}
}
