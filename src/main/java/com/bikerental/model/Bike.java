package com.bikerental.model;

/**
 * Abstract Bike class demonstrating Abstraction and serving as base for Inheritance.
 * ElectricBike and StandardBike inherit from this class.
 */
public abstract class Bike {

    private String bikeId;
    private String model;
    private String type;         // "ELECTRIC" or "STANDARD"
    private String status;       // "AVAILABLE", "IN_USE", "MAINTENANCE"
    private String stationId;
    private double pricePerHour;
    private String addedDate;
    private String imageUrl;

    // Default constructor
    public Bike() {}

    // Parameterized constructor
    public Bike(String bikeId, String model, String type, String status,
                String stationId, double pricePerHour, String addedDate, String imageUrl) {
        this.bikeId       = bikeId;
        this.model        = model;
        this.type         = type;
        this.status       = status;
        this.stationId    = stationId;
        this.pricePerHour = pricePerHour;
        this.addedDate    = addedDate;
        this.imageUrl     = imageUrl;
    }

    // ─── Abstract Methods (Abstraction) ─────────────────────────────────────────

    /** Returns a human-readable description of this bike type. */
    public abstract String getBikeDescription();

    /** Calculate fare based on hours ridden — overridden per bike type. */
    public abstract double calculateFare(double hours);

    // ─── Concrete Method: check availability ────────────────────────────────────

    public boolean isAvailable() {
        return "AVAILABLE".equalsIgnoreCase(this.status);
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getBikeId()       { return bikeId; }
    public String getModel()        { return model; }
    public String getType()         { return type; }
    public String getStatus()       { return status; }
    public String getStationId()    { return stationId; }
    public double getPricePerHour() { return pricePerHour; }
    public String getAddedDate()    { return addedDate; }
    public String getImageUrl()     { return imageUrl; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setBikeId(String bikeId)             { this.bikeId = bikeId; }
    public void setModel(String model)               { this.model = model; }
    public void setType(String type)                 { this.type = type; }
    public void setStatus(String status)             { this.status = status; }
    public void setStationId(String stationId)       { this.stationId = stationId; }
    public void setPricePerHour(double pricePerHour) { this.pricePerHour = pricePerHour; }
    public void setAddedDate(String addedDate)       { this.addedDate = addedDate; }
    public void setImageUrl(String imageUrl)         { this.imageUrl = imageUrl; }

    /** Serialize to file storage string. */
    public String toFileString() {
        return bikeId + "|" + model + "|" + type + "|" + status + "|"
                + stationId + "|" + pricePerHour + "|" + addedDate + "|" + imageUrl;
    }

    @Override
    public String toString() {
        return "Bike{bikeId='" + bikeId + "', model='" + model
                + "', type='" + type + "', status='" + status + "'}";
    }
}
