package com.bikerental.model;

/**
 * Ride model for tracking bike rental requests and active rides.
 * Used in conjunction with a Queue data structure.
 */
public class Ride {

    private String rideId;
    private String userId;
    private String bikeId;
    private String startStationId;
    private String endStationId;
    private String startTime;
    private String endTime;
    private String status;      // "QUEUED", "ACTIVE", "COMPLETED", "CANCELLED"
    private double totalFare;
    private double durationHours;

    // Default constructor
    public Ride() {}

    // Parameterized constructor
    public Ride(String rideId, String userId, String bikeId, String startStationId,
                String endStationId, String startTime, String endTime,
                String status, double totalFare, double durationHours) {
        this.rideId         = rideId;
        this.userId         = userId;
        this.bikeId         = bikeId;
        this.startStationId = startStationId;
        this.endStationId   = endStationId;
        this.startTime      = startTime;
        this.endTime        = endTime;
        this.status         = status;
        this.totalFare      = totalFare;
        this.durationHours  = durationHours;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getRideId()          { return rideId; }
    public String getUserId()          { return userId; }
    public String getBikeId()          { return bikeId; }
    public String getStartStationId()  { return startStationId; }
    public String getEndStationId()    { return endStationId; }
    public String getStartTime()       { return startTime; }
    public String getEndTime()         { return endTime; }
    public String getStatus()          { return status; }
    public double getTotalFare()       { return totalFare; }
    public double getDurationHours()   { return durationHours; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setRideId(String rideId)               { this.rideId = rideId; }
    public void setUserId(String userId)               { this.userId = userId; }
    public void setBikeId(String bikeId)               { this.bikeId = bikeId; }
    public void setStartStationId(String startStationId){ this.startStationId = startStationId; }
    public void setEndStationId(String endStationId)   { this.endStationId = endStationId; }
    public void setStartTime(String startTime)         { this.startTime = startTime; }
    public void setEndTime(String endTime)             { this.endTime = endTime; }
    public void setStatus(String status)               { this.status = status; }
    public void setTotalFare(double totalFare)         { this.totalFare = totalFare; }
    public void setDurationHours(double durationHours) { this.durationHours = durationHours; }

    /** Serialize to pipe-delimited string for file storage. */
    public String toFileString() {
        return rideId + "|" + userId + "|" + bikeId + "|" + startStationId + "|"
                + endStationId + "|" + startTime + "|" + endTime + "|"
                + status + "|" + totalFare + "|" + durationHours;
    }

    /** Deserialize from pipe-delimited string. */
    public static Ride fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 10) return null;
        return new Ride(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
                Double.parseDouble(p[8]), Double.parseDouble(p[9]));
    }

    @Override
    public String toString() {
        return "Ride{rideId='" + rideId + "', userId='" + userId
                + "', status='" + status + "'}";
    }
}
