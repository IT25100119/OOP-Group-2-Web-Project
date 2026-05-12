package com.bikerental.model;

/**
 * ElectricBike class demonstrating Inheritance (OOP Concept).
 * Extends Bike and adds electric-specific attributes.
 */
public class ElectricBike extends Bike {

    private int batteryLevel;    // 0–100 (%)
    private double rangeKm;      // range per full charge
    private String chargerType;  // "TYPE_A", "TYPE_C"

    // Default constructor
    public ElectricBike() {
        super();
        setType("ELECTRIC");
    }

    // Full constructor
    public ElectricBike(String bikeId, String model, String status,
                        String stationId, double pricePerHour, String addedDate,
                        String imageUrl, int batteryLevel, double rangeKm, String chargerType) {
        super(bikeId, model, "ELECTRIC", status, stationId, pricePerHour, addedDate, imageUrl);
        this.batteryLevel = batteryLevel;
        this.rangeKm      = rangeKm;
        this.chargerType  = chargerType;
    }

    // ─── Overriding Abstract Methods (Polymorphism) ──────────────────────────────

    @Override
    public String getBikeDescription() {
        return "Electric Bike | Battery: " + batteryLevel + "% | Range: " + rangeKm + " km";
    }

    @Override
    public double calculateFare(double hours) {
        // Electric bikes cost 1.5x standard rate
        return getPricePerHour() * hours * 1.5;
    }

    // ─── Getters/Setters ────────────────────────────────────────────────────────

    public int getBatteryLevel()     { return batteryLevel; }
    public double getRangeKm()       { return rangeKm; }
    public String getChargerType()   { return chargerType; }

    public void setBatteryLevel(int batteryLevel) { this.batteryLevel = batteryLevel; }
    public void setRangeKm(double rangeKm)        { this.rangeKm = rangeKm; }
    public void setChargerType(String chargerType){ this.chargerType = chargerType; }

    @Override
    public String toFileString() {
        return super.toFileString() + "|" + batteryLevel + "|" + rangeKm + "|" + chargerType;
    }

    public static ElectricBike fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 11) return null;
        ElectricBike b = new ElectricBike(p[0], p[1], p[3], p[4],
                Double.parseDouble(p[5]), p[6], p[7],
                Integer.parseInt(p[8]), Double.parseDouble(p[9]), p[10]);
        return b;
    }
}
