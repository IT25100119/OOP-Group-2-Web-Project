package com.bikerental.model;

/**
 * Station model demonstrating Encapsulation (OOP Concept).
 * Stores docking station details securely.
 */
public class Station {

    private String stationId;
    private String name;
    private String location;
    private int maxCapacity;
    private int currentBikes;
    private String operationalStatus;  // "OPEN", "CLOSED", "MAINTENANCE"
    private String addedDate;
    private double latitude;
    private double longitude;

    // Default constructor
    public Station() {}

    // Parameterized constructor
    public Station(String stationId, String name, String location, int maxCapacity,
                   int currentBikes, String operationalStatus, String addedDate,
                   double latitude, double longitude) {
        this.stationId         = stationId;
        this.name              = name;
        this.location          = location;
        this.maxCapacity       = maxCapacity;
        this.currentBikes      = currentBikes;
        this.operationalStatus = operationalStatus;
        this.addedDate         = addedDate;
        this.latitude          = latitude;
        this.longitude         = longitude;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getStationId()         { return stationId; }
    public String getName()              { return name; }
    public String getLocation()          { return location; }
    public int getMaxCapacity()          { return maxCapacity; }
    public int getCurrentBikes()         { return currentBikes; }
    public String getOperationalStatus() { return operationalStatus; }
    public String getAddedDate()         { return addedDate; }
    public double getLatitude()          { return latitude; }
    public double getLongitude()         { return longitude; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setStationId(String stationId)                  { this.stationId = stationId; }
    public void setName(String name)                            { this.name = name; }
    public void setLocation(String location)                    { this.location = location; }
    public void setMaxCapacity(int maxCapacity)                 { this.maxCapacity = maxCapacity; }
    public void setCurrentBikes(int currentBikes)               { this.currentBikes = currentBikes; }
    public void setOperationalStatus(String operationalStatus)  { this.operationalStatus = operationalStatus; }
    public void setAddedDate(String addedDate)                  { this.addedDate = addedDate; }
    public void setLatitude(double latitude)                    { this.latitude = latitude; }
    public void setLongitude(double longitude)                  { this.longitude = longitude; }

    /** Returns available slots at the station. */
    public int getAvailableSlots() {
        return maxCapacity - currentBikes;
    }

    /** Serialise to pipe-delimited string for file storage. */
    public String toFileString() {
        return stationId + "|" + name + "|" + location + "|" + maxCapacity + "|"
                + currentBikes + "|" + operationalStatus + "|" + addedDate
                + "|" + latitude + "|" + longitude;
    }

    /** Deserialise from pipe-delimited string. */
    public static Station fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 9) return null;
        return new Station(p[0], p[1], p[2],
                Integer.parseInt(p[3]), Integer.parseInt(p[4]),
                p[5], p[6],
                Double.parseDouble(p[7]), Double.parseDouble(p[8]));
    }

    @Override
    public String toString() {
        return "Station{stationId='" + stationId + "', name='" + name
                + "', location='" + location + "'}";
    }
}
