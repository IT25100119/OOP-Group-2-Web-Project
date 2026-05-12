package com.bikerental.service;

import com.bikerental.model.RentalPackage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Manages rental packages (hourly and daily) for each bike.
 * Data is persisted to bike_packages.txt in pipe-delimited format:
 *   packageId|bikeId|type|duration|price
 */
@Service
public class BikePackageService {

    private static final String PACKAGES_FILE = "bike_packages.txt";

    @Autowired private FileHandler fileHandler;

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<RentalPackage> getAllPackages() {
        return fileHandler.readLines(PACKAGES_FILE).stream()
                .map(RentalPackage::fromFileString)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    public List<RentalPackage> getPackagesForBike(String bikeId) {
        return getAllPackages().stream()
                .filter(p -> bikeId.equals(p.getBikeId()))
                .sorted(Comparator
                        .comparing(RentalPackage::getType)        // HOUR before DAY
                        .thenComparingInt(RentalPackage::getDuration))
                .collect(Collectors.toList());
    }

    public List<RentalPackage> getHourPackagesForBike(String bikeId) {
        return getPackagesForBike(bikeId).stream()
                .filter(p -> "HOUR".equals(p.getType()))
                .collect(Collectors.toList());
    }

    public List<RentalPackage> getDayPackagesForBike(String bikeId) {
        return getPackagesForBike(bikeId).stream()
                .filter(p -> "DAY".equals(p.getType()))
                .collect(Collectors.toList());
    }

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    public RentalPackage addPackage(String bikeId, String type, int duration, double price) {
        String id = "PKG-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        RentalPackage pkg = new RentalPackage(id, bikeId, type, duration, price);
        fileHandler.appendLine(PACKAGES_FILE, pkg.toFileString());
        return pkg;
    }

    // ─── UPDATE ───────────────────────────────────────────────────────────────────

    public boolean updatePackage(String packageId, int duration, double price) {
        List<String> lines = fileHandler.readLines(PACKAGES_FILE);
        boolean updated = false;
        for (int i = 0; i < lines.size(); i++) {
            RentalPackage pkg = RentalPackage.fromFileString(lines.get(i));
            if (pkg != null && packageId.equals(pkg.getPackageId())) {
                pkg.setDuration(duration);
                pkg.setPrice(price);
                lines.set(i, pkg.toFileString());
                updated = true;
                break;
            }
        }
        if (updated) fileHandler.writeLines(PACKAGES_FILE, lines);
        return updated;
    }

    // ─── DELETE ───────────────────────────────────────────────────────────────────

    public boolean deletePackage(String packageId) {
        return fileHandler.deleteById(PACKAGES_FILE, packageId);
    }

    /** Remove all packages for a bike (called when bike is deleted). */
    public void deleteAllPackagesForBike(String bikeId) {
        List<String> lines = fileHandler.readLines(PACKAGES_FILE);
        lines.removeIf(line -> {
            RentalPackage p = RentalPackage.fromFileString(line);
            return p != null && bikeId.equals(p.getBikeId());
        });
        fileHandler.writeLines(PACKAGES_FILE, lines);
    }

    /**
     * Bulk-replace all packages for a bike.
     * Called from the edit page: removes existing, inserts new set.
     */
    public void savePackagesForBike(String bikeId,
                                    List<String> types,
                                    List<Integer> durations,
                                    List<Double> prices) {
        // Remove existing packages for this bike
        deleteAllPackagesForBike(bikeId);

        // Add the new set
        if (types == null) return;
        for (int i = 0; i < types.size(); i++) {
            String type    = types.get(i);
            int    dur     = (durations != null && i < durations.size()) ? durations.get(i) : 1;
            double price   = (prices    != null && i < prices.size())    ? prices.get(i)    : 0.0;
            if (type != null && !type.isBlank() && dur > 0 && price >= 0) {
                addPackage(bikeId, type, dur, price);
            }
        }
    }
}
