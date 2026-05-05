package com.bikerental.service;

import com.bikerental.service.BikeService;
import com.bikerental.model.Bike;
import com.bikerental.model.Ride;
import com.bikerental.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/**
 * RideService manages bike rental requests using a Queue data structure.
 * Implements CRUD operations for Ride & Rental Management.
 */
@Service
public class RideService {

    private static final String RIDES_FILE = "rides.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    // ─── Queue: In-memory queue for active rental requests ───────────────────────
    private final Queue<Ride> rentalQueue = new LinkedList<>();

    @Autowired
    private FileHandler fileHandler;

    @Autowired
    private BikeService bikeService;

    @Autowired
    private UserService userService;

    @Autowired
    private PaymentService paymentService;

    // ─── CREATE: Record a new ride request ──────────────────────────────────────

    public Ride requestRide(String userId, String bikeId, String startStationId) {
        Bike bike = bikeService.findById(bikeId);
        if (bike == null || !bike.isAvailable()) return null;

        String rideId = "RDE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String startTime = LocalDateTime.now().format(DTF);

        Ride ride = new Ride(rideId, userId, bikeId, startStationId,
                "", startTime, "", "QUEUED", 0.0, 0.0);

        // Add to in-memory queue
        rentalQueue.offer(ride);

        // Persist to file
        fileHandler.appendLine(RIDES_FILE, ride.toFileString());

        // Mark bike as in use
        bikeService.updateBikeStatus(bikeId, "IN_USE");

        // Process queue — set QUEUED→ACTIVE
        processNextInQueue();

        return ride;
    }

    /** Process the next QUEUED ride and mark it ACTIVE. */
    private void processNextInQueue() {
        Ride next = rentalQueue.peek();
        if (next != null && "QUEUED".equals(next.getStatus())) {
            rentalQueue.poll();
            next.setStatus("ACTIVE");
            fileHandler.updateById(RIDES_FILE, next.getRideId(), next.toFileString());
        }
    }

    // ─── READ: View rental requests ─────────────────────────────────────────────

    public List<Ride> getAllRides() {
        List<String> lines = fileHandler.readLines(RIDES_FILE);
        List<Ride> rides = new ArrayList<>();
        for (String line : lines) {
            Ride r = Ride.fromFileString(line);
            if (r != null) rides.add(r);
        }
        return rides;
    }

    public List<Ride> getQueuedAndActiveRides() {
        return getAllRides().stream()
                .filter(r -> "QUEUED".equals(r.getStatus()) || "ACTIVE".equals(r.getStatus()))
                .collect(Collectors.toList());
    }

    public List<Ride> getRidesByUser(String userId) {
        return getAllRides().stream()
                .filter(r -> r.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public Ride findById(String rideId) {
        String line = fileHandler.findById(RIDES_FILE, rideId);
        return line != null ? Ride.fromFileString(line) : null;
    }

    public Ride getActiveRideByUser(String userId) {
        return getAllRides().stream()
                .filter(r -> r.getUserId().equals(userId) && "ACTIVE".equals(r.getStatus()))
                .findFirst().orElse(null);
    }

    // ─── UPDATE: Complete a ride and calculate fare ──────────────────────────────

    public Ride completeRide(String rideId, String endStationId) {
        Ride ride = findById(rideId);
        if (ride == null || !"ACTIVE".equals(ride.getStatus())) return null;

        String endTime = LocalDateTime.now().format(DTF);
        ride.setEndTime(endTime);
        ride.setEndStationId(endStationId);
        ride.setStatus("COMPLETED");

        // Calculate duration
        try {
            LocalDateTime start = LocalDateTime.parse(ride.getStartTime(), DTF);
            LocalDateTime end = LocalDateTime.parse(endTime, DTF);
            double hours = ChronoUnit.MINUTES.between(start, end) / 60.0;
            if (hours < 0.1) hours = 0.1; // minimum 6 minutes
            ride.setDurationHours(hours);

            // Polymorphic fare calculation
            Bike bike = bikeService.findById(ride.getBikeId());
            if (bike != null) {
                ride.setTotalFare(bike.calculateFare(hours));
                // Move bike to end station and mark AVAILABLE — syncs BOTH stations
                bikeService.moveAndReleaseBike(bike.getBikeId(), endStationId);
            }
        } catch (Exception e) {
            ride.setDurationHours(1.0);
            ride.setTotalFare(5.0);
        }

        fileHandler.updateById(RIDES_FILE, rideId, ride.toFileString());

        // Auto-create payment record
        try {
            User user = userService.findById(ride.getUserId());
            String username = user != null ? user.getUsername() : ride.getUserId();
            String method   = user != null ? user.getPaymentMethod() : "CASH";
            paymentService.createPayment(rideId, ride.getUserId(), username,
                    ride.getTotalFare(), method);
        } catch (Exception ignored) {}

        return ride;
    }

    // ─── DELETE: Remove cancelled/completed ride ─────────────────────────────────

    public boolean cancelRide(String rideId) {
        Ride ride = findById(rideId);
        if (ride == null) return false;
        ride.setStatus("CANCELLED");
        ride.setEndTime(LocalDateTime.now().format(DTF));
        // Return bike to start station and mark AVAILABLE — syncs station count
        bikeService.moveAndReleaseBike(ride.getBikeId(), ride.getStartStationId());
        rentalQueue.removeIf(r -> r.getRideId().equals(rideId));
        return fileHandler.updateById(RIDES_FILE, rideId, ride.toFileString());
    }

    public boolean deleteRide(String rideId) {
        return fileHandler.deleteById(RIDES_FILE, rideId);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public long countActiveRides() {
        return getAllRides().stream().filter(r -> "ACTIVE".equals(r.getStatus())).count();
    }

    public double getTotalRevenue() {
        return getAllRides().stream()
                .filter(r -> "COMPLETED".equals(r.getStatus()))
                .mapToDouble(Ride::getTotalFare).sum();
    }
}
