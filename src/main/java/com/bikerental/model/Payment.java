package com.bikerental.model;

/**
 * Payment model demonstrating Encapsulation (OOP Concept).
 * Tracks all financial transactions linked to rides.
 */
public class Payment {

    private String paymentId;
    private String rideId;
    private String userId;
    private String username;
    private double amount;
    private String paymentMethod;   // CASH, VISA, MASTERCARD, PAYPAL
    private String status;          // PENDING, COMPLETED, FAILED, REFUNDED
    private String transactionDate;
    private String notes;

    // Default constructor
    public Payment() {}

    // Full constructor
    public Payment(String paymentId, String rideId, String userId, String username,
                   double amount, String paymentMethod, String status,
                   String transactionDate, String notes) {
        this.paymentId       = paymentId;
        this.rideId          = rideId;
        this.userId          = userId;
        this.username        = username;
        this.amount          = amount;
        this.paymentMethod   = paymentMethod;
        this.status          = status;
        this.transactionDate = transactionDate;
        this.notes           = notes;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getPaymentId()       { return paymentId; }
    public String getRideId()          { return rideId; }
    public String getUserId()          { return userId; }
    public String getUsername()        { return username; }
    public double getAmount()          { return amount; }
    public String getPaymentMethod()   { return paymentMethod; }
    public String getStatus()          { return status; }
    public String getTransactionDate() { return transactionDate; }
    public String getNotes()           { return notes; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setPaymentId(String paymentId)             { this.paymentId = paymentId; }
    public void setRideId(String rideId)                   { this.rideId = rideId; }
    public void setUserId(String userId)                   { this.userId = userId; }
    public void setUsername(String username)               { this.username = username; }
    public void setAmount(double amount)                   { this.amount = amount; }
    public void setPaymentMethod(String paymentMethod)     { this.paymentMethod = paymentMethod; }
    public void setStatus(String status)                   { this.status = status; }
    public void setTransactionDate(String transactionDate) { this.transactionDate = transactionDate; }
    public void setNotes(String notes)                     { this.notes = notes; }

    // ─── Helper: formatted amount ───────────────────────────────────────────────
    public String getFormattedAmount() {
        return String.format("$%.2f", amount);
    }

    // ─── Serialize / Deserialize ────────────────────────────────────────────────

    public String toFileString() {
        return paymentId + "|" + rideId + "|" + userId + "|" + username + "|"
                + amount + "|" + paymentMethod + "|" + status + "|"
                + transactionDate + "|" + notes.replace("|", ";");
    }

    public static Payment fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 9) return null;
        try {
            return new Payment(p[0], p[1], p[2], p[3],
                    Double.parseDouble(p[4]), p[5], p[6], p[7], p[8]);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return "Payment{id='" + paymentId + "', ride='" + rideId
                + "', amount=" + amount + ", status='" + status + "'}";
    }
}
