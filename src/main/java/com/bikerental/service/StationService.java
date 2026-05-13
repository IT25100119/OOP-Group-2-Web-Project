package com.bikerental.service;

import com.bikerental.model.Station;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * StationService manages docking station CRUD operations.
 * currentBikes is always kept in sync with the actual bikes at each station.
 */
@Service
public class StationService {

    private static final String STATIONS_FILE = "stations.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired
    private FileHandler fileHandler;

    // @Lazy breaks the BikeService → StationService → BikeService cycle
    @Autowired @Lazy
    private BikeService bikeService;

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    public boolean addStation(String name, String location, int maxCapacity,
                               double latitude, double longitude) {
        String stationId = "STA-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String date = LocalDateTime.now().format(DTF);
        Station station = new Station(stationId, name, location, maxCapacity,
                0, "OPEN", date, latitude, longitude);
        fileHandler.appendLine(STATIONS_FILE, station.toFileString());
        return true;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<Station> getAllStations() {
        List<String> lines = fileHandler.readLines(STATIONS_FILE);
        List<Station> stations = new ArrayList<>();
        for (String line : lines) {
            Station s = Station.fromFileString(line);
            if (s != null) stations.add(s);
        }
        return stations;
    }

    public List<Station> getOpenStations() {
        return getAllStations().stream()
                .filter(s -> "OPEN".equalsIgnoreCase(s.getOperationalStatus()))
                .collect(Collectors.toList());
    }

    public Station findById(String stationId) {
        String line = fileHandler.findById(STATIONS_FILE, stationId);
        return line != null ? Station.fromFileString(line) : null;
    }

    public List<Station> searchByLocation(String query) {
        String q = query.toLowerCase();
        return getAllStations().stream()
                .filter(s -> s.getLocation().toLowerCase().contains(q)
                          || s.getName().toLowerCase().contains(q))
                .collect(Collectors.toList());
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    public boolean updateStation(String stationId, String name, String location,
                                  int maxCapacity, String status) {
        Station station = findById(stationId);
        if (station == null) return false;
        station.setName(name);
        station.setLocation(location);
        station.setMaxCapacity(maxCapacity);
        station.setOperationalStatus(status);
        return fileHandler.updateById(STATIONS_FILE, stationId, station.toFileString());
    }

    /**
     * Recalculate currentBikes for a station by counting bikes actually parked there.
     * A bike is "at the station" when its stationId matches AND status == AVAILABLE.
     * Called automatically by BikeService on every add / remove / status change.
     */
    public void recalculateCurrentBikes(String stationId) {
        if (stationId == null || stationId.isBlank()) return;
        Station station = findById(stationId);
        if (station == null) return;

        long count = bikeService.getAllBikes().stream()
                .filter(b -> stationId.equals(b.getStationId())
                          && "AVAILABLE".equalsIgnoreCase(b.getStatus()))
                .count();

        station.setCurrentBikes((int) count);
        fileHandler.updateById(STATIONS_FILE, stationId, station.toFileString());
    }

    /**
     * Recalculate ALL stations at once (useful on startup or after bulk imports).
     */
    public void recalculateAllStations() {
        getAllStations().forEach(s -> recalculateCurrentBikes(s.getStationId()));
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deleteStation(String stationId) {
        return fileHandler.deleteById(STATIONS_FILE, stationId);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public int getTotalStationCount() {
        return getAllStations().size();
    }

    // ─── Seed sample stations ────────────────────────────────────────────────────

    public void seedSampleStations() {
        if (fileHandler.countRecords(STATIONS_FILE) == 0) {
            addStation("City Center Hub",       "Main Street, Downtown",           20, 7.2906, 80.6337);
            addStation("University Gate",       "Peradeniya Road, Kandy",          15, 7.2543, 80.5928);
            addStation("Peradeniya Botanical",  "Botanical Gardens, Peradeniya",   10, 7.2685, 80.5956);
            addStation("Kandy Lake Side",       "Lake Round, Kandy",               12, 7.2935, 80.6412);
        }
    }
}
