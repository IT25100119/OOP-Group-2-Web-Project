package com.bikerental.model;

/**
 * MotoBike class demonstrating Inheritance (OOP Concept).
 * Extends Bike and adds motorbike-specific attributes.
 * Motorbikes have higher fare rates and require a valid license.
 */
public class MotoBike extends Bike {

    private int     engineCC;       // e.g. 125, 150, 250
    private String  fuelType;       // "PETROL", "ELECTRIC_MOTO"
    private boolean licenseRequired; // true for >125cc
    private boolean helmetProvided;
    private String  motoClass;      // "SCOOTER", "SPORT", "CRUISER"

    // Default constructor
    public MotoBike() {
        super();
        setType("MOTO");
    }

    // Full constructor
    public MotoBike(String bikeId, String model, String status,
                    String stationId, double pricePerHour, String addedDate,
                    String imageUrl, int engineCC, String fuelType,
                    boolean licenseRequired, boolean helmetProvided, String motoClass) {
        super(bikeId, model, "MOTO", status, stationId, pricePerHour, addedDate, imageUrl);
        this.engineCC        = engineCC;
        this.fuelType        = fuelType;
        this.licenseRequired = licenseRequired;
        this.helmetProvided  = helmetProvided;
        this.motoClass       = motoClass;
    }

    // ─── Overriding Abstract Methods (Polymorphism) ──────────────────────────────

    /**
     * Motorbikes charge 2× the base rate (higher running cost & insurance).
     */
    @Override
    public double calculateFare(double hours) {
        return getPricePerHour() * hours * 2.0;
    }

    @Override
    public String getBikeDescription() {
        return motoClass + " | " + engineCC + "cc " + fuelType
                + (licenseRequired ? " | License Required" : " | No License")
                + (helmetProvided  ? " | Helmet Included"  : "");
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public int     getEngineCC()         { return engineCC; }
    public String  getFuelType()         { return fuelType; }
    public boolean isLicenseRequired()   { return licenseRequired; }
    public boolean isHelmetProvided()    { return helmetProvided; }
    public String  getMotoClass()        { return motoClass; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setEngineCC(int engineCC)                 { this.engineCC = engineCC; }
    public void setFuelType(String fuelType)               { this.fuelType = fuelType; }
    public void setLicenseRequired(boolean licenseRequired){ this.licenseRequired = licenseRequired; }
    public void setHelmetProvided(boolean helmetProvided)  { this.helmetProvided = helmetProvided; }
    public void setMotoClass(String motoClass)             { this.motoClass = motoClass; }

    // ─── Serialise / Deserialise ─────────────────────────────────────────────────

    @Override
    public String toFileString() {
        return super.toFileString() + "|" + engineCC + "|" + fuelType
                + "|" + licenseRequired + "|" + helmetProvided + "|" + motoClass;
    }

    public static MotoBike fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 13) return null;
        try {
            return new MotoBike(p[0], p[1], p[3], p[4],
                    Double.parseDouble(p[5]), p[6], p[7],
                    Integer.parseInt(p[8]), p[9],
                    Boolean.parseBoolean(p[10]),
                    Boolean.parseBoolean(p[11]), p[12]);
        } catch (Exception e) { return null; }
    }
}
