package com.bikerental.model;

/**
 * Feedback model demonstrating Polymorphism (OOP Concept).
 * Supports different display modes for admins vs regular users.
 */
public class Feedback {

    private String feedbackId;
    private String userId;
    private String username;
    private String rideId;
    private int rating;           // 1–5 stars
    private String comment;
    private String submittedDate;
    private String status;        // "VISIBLE", "HIDDEN" (admin can hide)

    // Default constructor
    public Feedback() {}

    // Parameterized constructor
    public Feedback(String feedbackId, String userId, String username, String rideId,
                    int rating, String comment, String submittedDate, String status) {
        this.feedbackId    = feedbackId;
        this.userId        = userId;
        this.username      = username;
        this.rideId        = rideId;
        this.rating        = rating;
        this.comment       = comment;
        this.submittedDate = submittedDate;
        this.status        = status;
    }

    // ─── Polymorphic Display Methods ─────────────────────────────────────────────

    /** Display format for regular users — hides user ID details. */
    public String displayForUser() {
        return username + " rated " + rating + "/5 stars: \"" + comment + "\"";
    }

    /** Display format for admins — shows full details including status. */
    public String displayForAdmin() {
        return "[" + feedbackId + "] " + username + " (uid:" + userId + ") | "
                + "Ride: " + rideId + " | " + rating + "★ | Status: " + status
                + " | " + submittedDate + " | " + comment;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getFeedbackId()    { return feedbackId; }
    public String getUserId()        { return userId; }
    public String getUsername()      { return username; }
    public String getRideId()        { return rideId; }
    public int getRating()           { return rating; }
    public String getComment()       { return comment; }
    public String getSubmittedDate() { return submittedDate; }
    public String getStatus()        { return status; }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setFeedbackId(String feedbackId)     { this.feedbackId = feedbackId; }
    public void setUserId(String userId)             { this.userId = userId; }
    public void setUsername(String username)         { this.username = username; }
    public void setRideId(String rideId)             { this.rideId = rideId; }
    public void setRating(int rating)                { this.rating = rating; }
    public void setComment(String comment)           { this.comment = comment; }
    public void setSubmittedDate(String submittedDate){ this.submittedDate = submittedDate; }
    public void setStatus(String status)             { this.status = status; }

    public String toFileString() {
        return feedbackId + "|" + userId + "|" + username + "|" + rideId + "|"
                + rating + "|" + comment + "|" + submittedDate + "|" + status;
    }

    public static Feedback fromFileString(String line) {
        String[] p = line.split("\\|", -1);
        if (p.length < 8) return null;
        return new Feedback(p[0], p[1], p[2], p[3],
                Integer.parseInt(p[4]), p[5], p[6], p[7]);
    }

    @Override
    public String toString() {
        return "Feedback{feedbackId='" + feedbackId + "', rating=" + rating + "}";
    }
}
