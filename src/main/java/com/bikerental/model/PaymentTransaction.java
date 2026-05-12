package com.bikerental.model;

/**
 * PaymentTransaction — a detailed audit-log entry attached to each Payment.
 * Every status change on a Payment creates a new Transaction record.
 * Demonstrates Encapsulation (OOP Concept).
 */
public class PaymentTransaction {

    private String txId;           // TXN-XXXXXXXX
    private String paymentId;      // parent Payment
    private String rideId;
    private String userId;
    private String username;
    private String adminId;        // who actioned it (null if auto)
    private String adminName;
    private String action;         // CREATED, COMPLETED, REFUNDED, FAILED, EDITED, DELETED
    private double amount;
    private String paymentMethod;
    private String previousStatus;
    private String newStatus;
    private String timestamp;
    private String notes;

    // Default constructor
    public PaymentTransaction() {}

    // Full constructor
    public PaymentTransaction(String txId, String paymentId, String rideId,
                               String userId, String username,
                               String adminId, String adminName,
                               String action, double amount, String paymentMethod,
                               String previousStatus, String newStatus,
                               String timestamp, String notes) {
        this.txId           = txId;
        this.paymentId      = paymentId;
        this.rideId         = rideId;
        this.userId         = userId;
        this.username       = username;
        this.adminId        = adminId;
        this.adminName      = adminName;
        this.action         = action;
        this.amount         = amount;
        this.paymentMethod  = paymentMethod;
        this.previousStatus = previousStatus;
        this.newStatus      = newStatus;
        this.timestamp      = timestamp;
        this.notes          = notes;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getTxId()            { return txId; }
    public String getPaymentId()       { return paymentId; }
    public String getRideId()          { return rideId; }
    public String getUserId()          { return userId; }
    public String getUsername()        { return username; }
    public String getAdminId()         { return adminId; }
    public String getAdminName()       { return adminName; }
    public String getAction()          { return action; }
    public double getAmount()          { return amount; }
    public String getPaymentMethod()   { return paymentMethod; }
    public String getPreviousStatus()  { return previousStatus; }
    public String getNewStatus()       { return newStatus; }
    public String getTimestamp()       { return timestamp; }
    public String getNotes()           { return notes; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setTxId(String txId)                       { this.txId = txId; }
    public void setPaymentId(String paymentId)             { this.paymentId = paymentId; }
    public void setRideId(String rideId)                   { this.rideId = rideId; }
    public void setUserId(String userId)                   { this.userId = userId; }
    public void setUsername(String username)               { this.username = username; }
    public void setAdminId(String adminId)                 { this.adminId = adminId; }
    public void setAdminName(String adminName)             { this.adminName = adminName; }
    public void setAction(String action)                   { this.action = action; }
    public void setAmount(double amount)                   { this.amount = amount; }
    public void setPaymentMethod(String paymentMethod)     { this.paymentMethod = paymentMethod; }
    public void setPreviousStatus(String previousStatus)   { this.previousStatus = previousStatus; }
    public void setNewStatus(String newStatus)             { this.newStatus = newStatus; }
    public void setTimestamp(String timestamp)             { this.timestamp = timestamp; }
    public void setNotes(String notes)                     { this.notes = notes; }

    // ─── Helper ─────────────────────────────────────────────────────────────────

    public boolean isAdminAction() {
        return adminId != null && !adminId.isBlank();
    }

    public String getFormattedAmount() {
        return String.format("$%.2f", amount);
    }

    // ─── Serialise / Deserialise ─────────────────────────────────────────────────

    public String toFileString() {
        return txId + "|" + paymentId + "|" + rideId + "|" + userId + "|" + username + "|"
                + (adminId == null ? "" : adminId) + "|"
                + (adminName == null ? "" : adminName) + "|"
                + action + "|" + amount + "|" + paymentMethod + "|"
                + (previousStatus == null ? "" : previousStatus) + "|"
                + (newStatus == null ? "" : newStatus) + "|"
                + timestamp + "|" + (notes == null ? "" : notes.replace("|", ";"));
    }

    public static PaymentTransaction fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 13) return null;
        try {
            String notes = p.length >= 14 ? p[13] : "";
            return new PaymentTransaction(
                    p[0], p[1], p[2], p[3], p[4],
                    p[5], p[6], p[7],
                    Double.parseDouble(p[8]), p[9],
                    p[10], p[11], p[12], notes);
        } catch (Exception e) { return null; }
    }

    @Override
    public String toString() {
        return "Transaction{txId='" + txId + "', action='" + action
                + "', payment='" + paymentId + "', amount=" + amount + "}";
    }
}
