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
    private String status;         // "QUEUED", "ACTIVE", "COMPLETED", "CANCELLED"
    private double totalFare;
    private double durationHours;
    private String packageId;      // optional — null / "" if no package chosen

    // Default constructor
    public Ride() {}

    // Parameterized constructor (legacy — no packageId)
    public Ride(String rideId, String userId, String bikeId, String startStationId,
                String endStationId, String startTime, String endTime,
                String status, double totalFare, double durationHours) {
        this(rideId, userId, bikeId, startStationId, endStationId,
             startTime, endTime, status, totalFare, durationHours, "");
    }

    // Full constructor
    public Ride(String rideId, String userId, String bikeId, String startStationId,
                String endStationId, String startTime, String endTime,
                String status, double totalFare, double durationHours, String packageId) {
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
        this.packageId      = packageId == null ? "" : packageId;
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
    public String getPackageId()       { return packageId; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setRideId(String rideId)                { this.rideId = rideId; }
    public void setUserId(String userId)                { this.userId = userId; }
    public void setBikeId(String bikeId)                { this.bikeId = bikeId; }
    public void setStartStationId(String s)             { this.startStationId = s; }
    public void setEndStationId(String endStationId)    { this.endStationId = endStationId; }
    public void setStartTime(String startTime)          { this.startTime = startTime; }
    public void setEndTime(String endTime)              { this.endTime = endTime; }
    public void setStatus(String status)                { this.status = status; }
    public void setTotalFare(double totalFare)          { this.totalFare = totalFare; }
    public void setDurationHours(double durationHours)  { this.durationHours = durationHours; }
    public void setPackageId(String packageId)          { this.packageId = packageId == null ? "" : packageId; }

    /** Serialize to pipe-delimited string for file storage (11 fields). */
    public String toFileString() {
        return rideId + "|" + userId + "|" + bikeId + "|" + startStationId + "|"
                + endStationId + "|" + startTime + "|" + endTime + "|"
                + status + "|" + totalFare + "|" + durationHours + "|"
                + (packageId == null ? "" : packageId);
    }

    /** Deserialize from pipe-delimited string — handles both 10-field (legacy) and 11-field formats. */
    public static Ride fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 10) return null;
        String pkgId = p.length >= 11 ? p[10] : "";
        return new Ride(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
                Double.parseDouble(p[8]), Double.parseDouble(p[9]), pkgId);
    }

    @Override
    public String toString() {
        return "Ride{rideId='" + rideId + "', userId='" + userId
                + "', status='" + status + "', packageId='" + packageId + "'}";
    }
}
