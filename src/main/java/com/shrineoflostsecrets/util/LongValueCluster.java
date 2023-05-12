package com.shrineoflostsecrets.util;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

public class LongValueCluster {

    public static void main(String[] args) {
        int numValues = 500;
        long[] values = generateRandomLongs(numValues);
        int numClusters = 10;

        List<Cluster> clusters = kMeansClustering(values, numClusters);

        for (int i = 0; i < clusters.size(); i++) {
            Cluster cluster = clusters.get(i);
            System.out.println("Cluster " + (i + 1) + ":");
            System.out.println("  Number of elements: " + cluster.getNumberOfElements());
            System.out.println("  lowerBound: " + cluster.lowerBound);
            System.out.println("  upperBound " + cluster.upperBound);
            for(int j=0; j < cluster.values.size(); j++) {
                System.out.println("  cluster.values "+ j + " " + cluster.values.get(j));

            }
        }
    }

    private static long[] generateRandomLongs(int numValues) {
        long[] values = new long[numValues];
        Random random = new Random();
        for (int i = 0; i < numValues; i++) {
            values[i] = random.nextLong();
        }
        return values;
    }

    private static List<Cluster> kMeansClustering(long[] values, int numClusters) {
        List<Long> valueList = Arrays.stream(values).boxed().collect(Collectors.toList());
        valueList.sort(Long::compareTo);

        List<Long> initialCentroids = new ArrayList<>();
        for (int i = 0; i < numClusters; i++) {
            initialCentroids.add(valueList.get(i * (valueList.size() / numClusters)));
        }

        List<Cluster> clusters = new ArrayList<>();
        for (Long centroid : initialCentroids) {
            clusters.add(new Cluster(centroid));
        }

        boolean clustersChanged;
        do {
            clustersChanged = false;

            for (Long value : valueList) {
                Cluster closestCluster = null;
                long minDistance = Long.MAX_VALUE;

                for (Cluster cluster : clusters) {
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

            for (Cluster cluster : clusters) {
                cluster.updateCentroid();
            }

            // Sort clusters by their centroids
            clusters.sort(Comparator.comparingLong(Cluster::getCentroid));

            // Update clusters' bounds
            for (int i = 0; i < clusters.size() - 1; i++) {
                Cluster currentCluster = clusters.get(i);
                Cluster nextCluster = clusters.get(i + 1);
                long newBound = (currentCluster.getCentroid() + nextCluster.getCentroid()) / 2;
                currentCluster.setUpperBound(newBound);
                nextCluster.setLowerBound(newBound);
            }

        } while (clustersChanged);

        return clusters;
    }

    public static class Cluster {
        private long centroid;
        private long lowerBound;
        private long upperBound;
        private final List<Long> values;

        public Cluster(long centroid) {
            this.centroid = centroid;
            this.lowerBound = Long.MIN_VALUE;
            this.upperBound = Long.MAX_VALUE;
            this.values = new ArrayList<>();
        }

        public long getCentroid() {
            return centroid;
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
}