package com.bikerental.service;

import com.bikerental.model.Bike;
import com.bikerental.model.ElectricBike;
import com.bikerental.model.MotoBike;
import com.bikerental.model.StandardBike;
import com.bikerental.util.QuickSort;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * BikeService handles all CRUD operations for Bike Fleet Management.
 * Every add / delete / status-change automatically syncs the parent
 * station's currentBikes count via StationService.recalculateCurrentBikes().
 */
@Service
public class BikeService {

    private static final String BIKES_FILE = "bikes.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired private FileHandler     fileHandler;
    @Autowired private StationService  stationService;   // safe — no cycle here

    // ─── Internal helper: sync station count after any bike change ────────────────

    private void syncStation(String stationId) {
        if (stationId != null && !stationId.isBlank()) {
            stationService.recalculateCurrentBikes(stationId);
        }
    }

    // ─── CREATE (Admin Only) ─────────────────────────────────────────────────────

    public String addElectricBike(String model, String stationId, double price,
                                   int battery, double range, String charger) {
        String bikeId = "BKE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String date = LocalDateTime.now().format(DTF);
        ElectricBike bike = new ElectricBike(bikeId, model, "AVAILABLE",
                stationId, price, date, "electric.png", battery, range, charger);
        fileHandler.appendLine(BIKES_FILE, bike.toFileString());
        syncStation(stationId);
        return bikeId;
    }

    public String addStandardBike(String model, String stationId, double price,
                                   int gears, String frameSize, boolean hasBasket) {
        String bikeId = "BKS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String date = LocalDateTime.now().format(DTF);
        StandardBike bike = new StandardBike(bikeId, model, "AVAILABLE",
                stationId, price, date, "standard.png", gears, frameSize, hasBasket);
        fileHandler.appendLine(BIKES_FILE, bike.toFileString());
        syncStation(stationId);
        return bikeId;
    }

    public String addMotoBike(String model, String stationId, double price,
                                int engineCC, String fuelType, boolean licenseRequired,
                                boolean helmetProvided, String motoClass) {
        String bikeId = "BKM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String date = LocalDateTime.now().format(DTF);
        MotoBike bike = new MotoBike(bikeId, model, "AVAILABLE",
                stationId, price, date, "moto.png",
                engineCC, fuelType, licenseRequired, helmetProvided, motoClass);
        fileHandler.appendLine(BIKES_FILE, bike.toFileString());
        syncStation(stationId);
        return bikeId;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<Bike> getAllBikes() {
        List<String> lines = fileHandler.readLines(BIKES_FILE);
        List<Bike> bikes = new ArrayList<>();
        for (String line : lines) {
            Bike b = parseBike(line);
            if (b != null) bikes.add(b);
        }
        return bikes;
    }

    public List<Bike> getAllBikesSortedByAvailability() {
        List<Bike> bikes = getAllBikes();
        QuickSort.sortByAvailability(bikes);
        return bikes;
    }

    public List<Bike> getAvailableBikes() {
        return getAllBikes().stream()
                .filter(Bike::isAvailable)
                .collect(Collectors.toList());
    }

    public Bike findById(String bikeId) {
        String line = fileHandler.findById(BIKES_FILE, bikeId);
        return line != null ? parseBike(line) : null;
    }

    public List<Bike> searchBikes(String query) {
        String q = query.toLowerCase();
        return getAllBikes().stream()
                .filter(b -> b.getModel().toLowerCase().contains(q)
                          || b.getType().toLowerCase().contains(q)
                          || b.getBikeId().toLowerCase().contains(q))
                .collect(Collectors.toList());
    }

    // ─── UPDATE (Admin Only) ─────────────────────────────────────────────────────

    /**
     * Status-only update — called when a ride starts (AVAILABLE→IN_USE)
     * or ends (IN_USE→AVAILABLE). Both changes affect the station count.
     */
    public boolean updateBikeStatus(String bikeId, String newStatus) {
        Bike bike = findById(bikeId);
        if (bike == null) return false;
        String stationId = bike.getStationId();
        bike.setStatus(newStatus);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) syncStation(stationId);  // AVAILABLE count changed
        return ok;
    }


    /**
     * Move bike to a new station AND set it AVAILABLE in one atomic operation.
     * Syncs both the old station (−1) and the new station (+1).
     * Called when a ride ends or is cancelled.
     */
    public boolean moveAndReleaseBike(String bikeId, String newStationId) {
        Bike bike = findById(bikeId);
        if (bike == null) return false;
        String oldStationId = bike.getStationId();
        bike.setStatus("AVAILABLE");
        bike.setStationId(newStationId);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) {
            syncStation(newStationId);                          // +1 at return station
            if (!newStationId.equals(oldStationId)) {
                syncStation(oldStationId);                      // fix old station too
            }
        }
        return ok;
    }

    /**
     * Full edit — model, status, station, price.
     * If the station changed, sync BOTH the old and new station.
     */
    public boolean updateBike(String bikeId, String model, String status,
                               String newStationId, double price) {
        Bike bike = findById(bikeId);
        if (bike == null) return false;
        String oldStationId = bike.getStationId();

        bike.setModel(model);
        bike.setStatus(status);
        bike.setStationId(newStationId);
        bike.setPricePerHour(price);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) {
            syncStation(newStationId);
            if (!newStationId.equals(oldStationId)) {
                syncStation(oldStationId); // also fix the station it left
            }
        }
        return ok;
    }

    // ─── Type-specific update methods ────────────────────────────────────────────

    /** Update electric bike — base fields + battery/range/charger. */
    public boolean updateElectricBike(String bikeId, String model, String status,
                                       String stationId, double price,
                                       int batteryLevel, double rangeKm, String chargerType) {
        Bike b = findById(bikeId);
        if (!(b instanceof ElectricBike)) return false;
        ElectricBike bike = (ElectricBike) b;
        String oldStationId = bike.getStationId();
        bike.setModel(model);
        bike.setStatus(status);
        bike.setStationId(stationId);
        bike.setPricePerHour(price);
        bike.setBatteryLevel(batteryLevel);
        bike.setRangeKm(rangeKm);
        bike.setChargerType(chargerType);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) { syncStation(stationId); if (!stationId.equals(oldStationId)) syncStation(oldStationId); }
        return ok;
    }

    /** Update standard bike — base fields + gears/frame/basket. */
    public boolean updateStandardBike(String bikeId, String model, String status,
                                       String stationId, double price,
                                       int gearCount, String frameSize, boolean hasBasket) {
        Bike b = findById(bikeId);
        if (!(b instanceof StandardBike)) return false;
        StandardBike bike = (StandardBike) b;
        String oldStationId = bike.getStationId();
        bike.setModel(model);
        bike.setStatus(status);
        bike.setStationId(stationId);
        bike.setPricePerHour(price);
        bike.setGearCount(gearCount);
        bike.setFrameSize(frameSize);
        bike.setHasBasket(hasBasket);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) { syncStation(stationId); if (!stationId.equals(oldStationId)) syncStation(oldStationId); }
        return ok;
    }

    /** Update moto bike — base fields + engineCC/fuel/license/helmet/class. */
    public boolean updateMotoBike(String bikeId, String model, String status,
                                   String stationId, double price,
                                   int engineCC, String fuelType,
                                   boolean licenseRequired, boolean helmetProvided,
                                   String motoClass) {
        Bike b = findById(bikeId);
        if (!(b instanceof MotoBike)) return false;
        MotoBike bike = (MotoBike) b;
        String oldStationId = bike.getStationId();
        bike.setModel(model);
        bike.setStatus(status);
        bike.setStationId(stationId);
        bike.setPricePerHour(price);
        bike.setEngineCC(engineCC);
        bike.setFuelType(fuelType);
        bike.setLicenseRequired(licenseRequired);
        bike.setHelmetProvided(helmetProvided);
        bike.setMotoClass(motoClass);
        boolean ok = fileHandler.updateById(BIKES_FILE, bikeId, bike.toFileString());
        if (ok) { syncStation(stationId); if (!stationId.equals(oldStationId)) syncStation(oldStationId); }
        return ok;
    }

    // ─── DELETE (Admin Only) ─────────────────────────────────────────────────────

    public boolean deleteBike(String bikeId) {
        Bike bike = findById(bikeId);
        String stationId = bike != null ? bike.getStationId() : null;
        boolean ok = fileHandler.deleteById(BIKES_FILE, bikeId);
        if (ok) syncStation(stationId);  // -1 at its station
        return ok;
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public long countAvailable() {
        return getAllBikes().stream().filter(Bike::isAvailable).count();
    }

    public long countByType(String type) {
        return getAllBikes().stream()
                .filter(b -> type.equalsIgnoreCase(b.getType())).count();
    }

    public long countInUse() {
        return getAllBikes().stream()
                .filter(b -> "IN_USE".equals(b.getStatus())).count();
    }

    // ─── Private Helpers ─────────────────────────────────────────────────────────

    private Bike parseBike(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 2) return null;
        String type = parts[2];
        if ("ELECTRIC".equalsIgnoreCase(type)) {
            return ElectricBike.fromFileString(line);
        } else if ("MOTO".equalsIgnoreCase(type)) {
            return MotoBike.fromFileString(line);
        } else {
            return StandardBike.fromFileString(line);
        }
    }
}
