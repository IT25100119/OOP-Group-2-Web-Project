package com.bikerental.model;

/**
 * StandardBike class demonstrating Inheritance (OOP Concept).
 * Extends Bike with standard pedal bike features.
 */
public class StandardBike extends Bike {

    private int gearCount;
    private String frameSize;   // "SMALL", "MEDIUM", "LARGE"
    private boolean hasBasket;

    // Default constructor
    public StandardBike() {
        super();
        setType("STANDARD");
    }

    // Full constructor
    public StandardBike(String bikeId, String model, String status,
                        String stationId, double pricePerHour, String addedDate,
                        String imageUrl, int gearCount, String frameSize, boolean hasBasket) {
        super(bikeId, model, "STANDARD", status, stationId, pricePerHour, addedDate, imageUrl);
        this.gearCount  = gearCount;
        this.frameSize  = frameSize;
        this.hasBasket  = hasBasket;
    }

    // ─── Overriding Abstract Methods (Polymorphism) ──────────────────────────────

    @Override
    public String getBikeDescription() {
        return "Standard Bike | Gears: " + gearCount + " | Frame: " + frameSize
                + (hasBasket ? " | With Basket" : "");
    }

    @Override
    public double calculateFare(double hours) {
        // Standard bikes use base rate
        return getPricePerHour() * hours;
    }

    // ─── Getters/Setters ────────────────────────────────────────────────────────

    public int getGearCount()      { return gearCount; }
    public String getFrameSize()   { return frameSize; }
    public boolean isHasBasket()   { return hasBasket; }

    public void setGearCount(int gearCount)       { this.gearCount = gearCount; }
    public void setFrameSize(String frameSize)     { this.frameSize = frameSize; }
    public void setHasBasket(boolean hasBasket)   { this.hasBasket = hasBasket; }

    @Override
    public String toFileString() {
        return super.toFileString() + "|" + gearCount + "|" + frameSize + "|" + hasBasket;
    }

    public static StandardBike fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 11) return null;
        return new StandardBike(p[0], p[1], p[3], p[4],
                Double.parseDouble(p[5]), p[6], p[7],
                Integer.parseInt(p[8]), p[9], Boolean.parseBoolean(p[10]));
    }
}
