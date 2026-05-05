package com.bikerental.util;

import com.bikerental.model.Bike;
import java.util.List;

/**
 * QuickSort utility for sorting bikes by availability status.
 * Required by Component 02: Bike Fleet Management.
 */
public class QuickSort {

    /**
     * Sort bikes by status: AVAILABLE first, then IN_USE, then MAINTENANCE.
     * Uses the QuickSort algorithm as required.
     */
    public static void sortByAvailability(List<Bike> bikes) {
        if (bikes == null || bikes.size() <= 1) return;
        quickSort(bikes, 0, bikes.size() - 1);
    }

    private static void quickSort(List<Bike> bikes, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(bikes, low, high);
            quickSort(bikes, low, pivotIndex - 1);
            quickSort(bikes, pivotIndex + 1, high);
        }
    }

    private static int partition(List<Bike> bikes, int low, int high) {
        Bike pivot = bikes.get(high);
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (statusRank(bikes.get(j).getStatus()) <= statusRank(pivot.getStatus())) {
                i++;
                swap(bikes, i, j);
            }
        }
        swap(bikes, i + 1, high);
        return i + 1;
    }

    private static void swap(List<Bike> bikes, int i, int j) {
        Bike temp = bikes.get(i);
        bikes.set(i, bikes.get(j));
        bikes.set(j, temp);
    }

    /** Lower rank = comes first in sorted order. AVAILABLE = 0 (best). */
    private static int statusRank(String status) {
        if (status == null) return 99;
        return switch (status.toUpperCase()) {
            case "AVAILABLE"   -> 0;
            case "IN_USE"      -> 1;
            case "MAINTENANCE" -> 2;
            default            -> 99;
        };
    }

    /**
     * Sort bikes by price per hour (ascending).
     */
    public static void sortByPrice(List<Bike> bikes) {
        if (bikes == null || bikes.size() <= 1) return;
        quickSortByPrice(bikes, 0, bikes.size() - 1);
    }

    private static void quickSortByPrice(List<Bike> bikes, int low, int high) {
        if (low < high) {
            int pivotIndex = partitionByPrice(bikes, low, high);
            quickSortByPrice(bikes, low, pivotIndex - 1);
            quickSortByPrice(bikes, pivotIndex + 1, high);
        }
    }

    private static int partitionByPrice(List<Bike> bikes, int low, int high) {
        double pivot = bikes.get(high).getPricePerHour();
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (bikes.get(j).getPricePerHour() <= pivot) {
                i++;
                swap(bikes, i, j);
            }
        }
        swap(bikes, i + 1, high);
        return i + 1;
    }
}
