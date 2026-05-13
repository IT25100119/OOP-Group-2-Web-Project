package com.bikerental.service;

import com.bikerental.model.Bike;
import com.bikerental.model.Ride;
import com.bikerental.model.User;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/**
 * RideService manages bike rental requests using a Queue<Ride> (ArrayDeque).
 *
 * Queue behaviour (FIFO):
 *   1. Every requestRide() call enqueues the ride (offer).
 *   2. processQueue() scans from the head; if the requested bike is free
 *      it dequeues the ride (poll) and marks it ACTIVE.
 *   3. When a ride completes or is cancelled the bike is released and
 *      processQueue() is called again so any waiting rider is promoted.
 *   4. On server start @PostConstruct reloads QUEUED rides from file back
 *      into the in-memory queue so state survives restarts.
 */
@Service
public class RideService {

    private static final String RIDES_FILE = "rides.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    // ─── Core Queue (FIFO) — backed by ArrayDeque (resizable array, no linked nodes) ──
    private final Queue<Ride> rentalQueue = new ArrayDeque<>();

    @Autowired private FileHandler            fileHandler;
    @Autowired private BikeService            bikeService;
    @Autowired private UserService            userService;
    @Autowired private PaymentService         paymentService;

    // ─── Startup: restore QUEUED rides from file into in-memory queue ────────────
    @PostConstruct
    public void initQueue() {
        getAllRides().stream()
                .filter(r -> "QUEUED".equals(r.getStatus()))
                .sorted(Comparator.comparing(Ride::getStartTime))   // preserve arrival order
                .forEach(rentalQueue::offer);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // CREATE — enqueue a new ride request
    // ═══════════════════════════════════════════════════════════════════════════

    public Ride requestRide(String userId, String bikeId, String startStationId) {
        return requestRide(userId, bikeId, startStationId, "");
    }

    public Ride requestRide(String userId, String bikeId, String startStationId, String packageId) {
        Bike bike = bikeService.findById(bikeId);
        if (bike == null) return null;

        // Build ride in QUEUED state — all requests enter the queue first
        String rideId    = "RDE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String startTime = LocalDateTime.now().format(DTF);

        Ride ride = new Ride(rideId, userId, bikeId, startStationId,
                "", startTime, "", "QUEUED", 0.0, 0.0,
                packageId == null ? "" : packageId);

        // ── Enqueue (offer) ──────────────────────────────────────────────────
        rentalQueue.offer(ride);
        fileHandler.appendLine(RIDES_FILE, ride.toFileString());

        // ── Try to process head of queue immediately ─────────────────────────
        processQueue();

        // Return the ride with its current status (ACTIVE if bike was free, else QUEUED)
        return findById(rideId);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // QUEUE PROCESSING — promote head-of-queue rides to ACTIVE when bike is free
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * Walks the FIFO queue from head to tail.
     * For each QUEUED ride whose requested bike is now AVAILABLE:
     *   - poll() it from the queue
     *   - mark the bike IN_USE
     *   - mark the ride ACTIVE
     *   - persist the change
     * Stops at the first ride whose bike is still occupied so that strict
     * FIFO order is maintained for any given bike.
     */
    private synchronized void processQueue() {
        // Use an iterator so we can remove specific entries (per-bike FIFO)
        Iterator<Ride> it = rentalQueue.iterator();
        // Track which bikes have already been claimed in this processing pass
        Set<String> claimedBikes = new HashSet<>();

        while (it.hasNext()) {
            Ride queued = it.next();
            String bikeId = queued.getBikeId();

            // Skip this bike if already claimed by an earlier queue entry this pass
            if (claimedBikes.contains(bikeId)) continue;

            Bike bike = bikeService.findById(bikeId);
            if (bike != null && bike.isAvailable()) {
                // ── Dequeue (poll equivalent via iterator) ───────────────────
                it.remove();

                // Activate the ride
                queued.setStatus("ACTIVE");
                bikeService.updateBikeStatus(bikeId, "IN_USE");
                fileHandler.updateById(RIDES_FILE, queued.getRideId(), queued.toFileString());

                claimedBikes.add(bikeId);   // this bike is now taken for this pass
            }
            // If bike is not available, leave the ride in the queue — it waits
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // READ
    // ═══════════════════════════════════════════════════════════════════════════

    public List<Ride> getAllRides() {
        List<Ride> rides = new ArrayList<>();
        for (String line : fileHandler.readLines(RIDES_FILE)) {
            Ride r = Ride.fromFileString(line);
            if (r != null) rides.add(r);
        }
        return rides;
    }

    public List<Ride> getQueuedRides() {
        // Return rides still waiting in queue (QUEUED status), in FIFO order
        return new ArrayList<>(rentalQueue).stream()
                .filter(r -> "QUEUED".equals(r.getStatus()))
                .collect(Collectors.toList());
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

    public Ride getQueuedRideByUser(String userId) {
        return getAllRides().stream()
                .filter(r -> r.getUserId().equals(userId) && "QUEUED".equals(r.getStatus()))
                .findFirst().orElse(null);
    }

    /**
     * Returns the 1-based position of a ride in the in-memory queue.
     * Returns -1 if the ride is not currently waiting.
     */
    public int getQueuePosition(String rideId) {
        int pos = 1;
        for (Ride r : rentalQueue) {
            if (r.getRideId().equals(rideId)) return pos;
            pos++;
        }
        return -1;
    }

    /** Total number of rides currently waiting in queue. */
    public int getQueueSize() {
        return rentalQueue.size();
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // UPDATE — complete a ride, release the bike, re-process queue
    // ═══════════════════════════════════════════════════════════════════════════

    public Ride completeRide(String rideId, String endStationId) {
        Ride ride = findById(rideId);
        if (ride == null || !"ACTIVE".equals(ride.getStatus())) return null;

        String endTime = LocalDateTime.now().format(DTF);
        ride.setEndTime(endTime);
        ride.setEndStationId(endStationId);
        ride.setStatus("COMPLETED");

        try {
            LocalDateTime start = LocalDateTime.parse(ride.getStartTime(), DTF);
            LocalDateTime end   = LocalDateTime.parse(endTime, DTF);
            double hours = ChronoUnit.MINUTES.between(start, end) / 60.0;
            if (hours < 0.1) hours = 0.1;  // minimum 6-minute billing
            ride.setDurationHours(hours);

            Bike bike = bikeService.findById(ride.getBikeId());
            if (bike != null) {
                ride.setTotalFare(Math.round(bike.calculateFare(hours) * 100.0) / 100.0);
                // Release bike → move to end station, mark AVAILABLE
                bikeService.moveAndReleaseBike(bike.getBikeId(), endStationId);
            }
        } catch (Exception e) {
            ride.setDurationHours(1.0);
            ride.setTotalFare(5.0);
        }

        fileHandler.updateById(RIDES_FILE, rideId, ride.toFileString());

        // ── Bike is now free: promote next waiting ride in queue ─────────────
        processQueue();

        // Auto-create payment
        try {
            User user = userService.findById(ride.getUserId());
            String username = user != null ? user.getUsername() : ride.getUserId();
            String method   = user != null ? user.getPaymentMethod() : "CASH";
            paymentService.createPayment(rideId, ride.getUserId(), username,
                    ride.getTotalFare(), method);
        } catch (Exception ignored) {}

        return ride;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // DELETE / CANCEL
    // ═══════════════════════════════════════════════════════════════════════════

    public boolean cancelRide(String rideId) {
        Ride ride = findById(rideId);
        if (ride == null) return false;

        ride.setStatus("CANCELLED");
        ride.setEndTime(LocalDateTime.now().format(DTF));

        // Return bike to start station and mark AVAILABLE
        bikeService.moveAndReleaseBike(ride.getBikeId(), ride.getStartStationId());

        // ── Remove from in-memory queue if it was still waiting ──────────────
        rentalQueue.removeIf(r -> r.getRideId().equals(rideId));

        boolean ok = fileHandler.updateById(RIDES_FILE, rideId, ride.toFileString());

        // ── Bike released: check queue for next waiting rider ────────────────
        processQueue();

        return ok;
    }

    public boolean deleteRide(String rideId) {
        rentalQueue.removeIf(r -> r.getRideId().equals(rideId));
        return fileHandler.deleteById(RIDES_FILE, rideId);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // STATS
    // ═══════════════════════════════════════════════════════════════════════════

    public long countActiveRides() {
        return getAllRides().stream().filter(r -> "ACTIVE".equals(r.getStatus())).count();
    }

    public double getTotalRevenue() {
        return getAllRides().stream()
                .filter(r -> "COMPLETED".equals(r.getStatus()))
                .mapToDouble(Ride::getTotalFare).sum();
    }
}
