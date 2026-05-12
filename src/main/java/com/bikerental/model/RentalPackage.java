package com.bikerental.model;

/**
 * Represents a pre-defined rental package for a bike.
 * Type is either "HOUR" (e.g. 2-hour block) or "DAY" (e.g. 3-day block).
 * Prices stored in USD in the flat file; converted to LKR at display time.
 */
public class RentalPackage {

    private String packageId;   // PKG-XXXXXXXX
    private String bikeId;
    private String type;        // "HOUR" | "DAY"
    private int    duration;    // e.g. 2 (hours) or 1 (day)
    private double price;       // USD base price

    public RentalPackage() {}

    public RentalPackage(String packageId, String bikeId,
                         String type, int duration, double price) {
        this.packageId = packageId;
        this.bikeId    = bikeId;
        this.type      = type;
        this.duration  = duration;
        this.price     = price;
    }

    // ─── Convenience ────────────────────────────────────────────────────────────

    public String getLabel() {
        if ("HOUR".equals(type)) {
            return duration == 1 ? "1 Hour" : duration + " Hours";
        } else {
            return duration == 1 ? "1 Day" : duration + " Days";
        }
    }

    // ─── Serialization ──────────────────────────────────────────────────────────

    public String toFileString() {
        return packageId + "|" + bikeId + "|" + type + "|" + duration + "|" + price;
    }

    public static RentalPackage fromFileString(String line) {
        String[] p = line.split("\\|");
        if (p.length < 5) return null;
        try {
            return new RentalPackage(p[0], p[1], p[2],
                    Integer.parseInt(p[3]), Double.parseDouble(p[4]));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // ─── Getters & Setters ───────────────────────────────────────────────────────

    public String getPackageId() { return packageId; }
    public String getBikeId()    { return bikeId; }
    public String getType()      { return type; }
    public int    getDuration()  { return duration; }
    public double getPrice()     { return price; }

    public void setPackageId(String packageId) { this.packageId = packageId; }
    public void setBikeId(String bikeId)       { this.bikeId = bikeId; }
    public void setType(String type)           { this.type = type; }
    public void setDuration(int duration)      { this.duration = duration; }
    public void setPrice(double price)         { this.price = price; }
}
