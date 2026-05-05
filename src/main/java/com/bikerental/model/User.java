package com.bikerental.model;

/**
 * User model class demonstrating Encapsulation (OOP Concept).
 * Stores user data securely with private fields and public getters/setters.
 */
public class User {

    private String userId;
    private String username;
    private String email;
    private String password;
    private String phone;
    private String paymentMethod;
    private String role; // "USER" or "ADMIN"
    private String createdDate;

    // Default constructor
    public User() {}

    // Parameterized constructor
    public User(String userId, String username, String email, String password,
                String phone, String paymentMethod, String role, String createdDate) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.paymentMethod = paymentMethod;
        this.role = role;
        this.createdDate = createdDate;
    }

    // ─── Getters ────────────────────────────────────────────────────────────────

    public String getUserId(){ 
        return userId;
    }
    public String getUsername(){
        return username;
    }
    public String getEmail(){
        return email; 
    }
    public String getPassword(){ 
        return password;
    }
    public String getPhone(){ 
        return phone; 
    }
    public String getPaymentMethod() { 
        return paymentMethod; 
    }
    public String getRole(){ 
        return role; 
    }
    public String getCreatedDate(){ 
        return createdDate;
    }

    // ─── Setters ────────────────────────────────────────────────────────────────

    public void setUserId(String userId)               { this.userId = userId; }
    public void setUsername(String username)           { this.username = username; }
    public void setEmail(String email)                 { this.email = email; }
    public void setPassword(String password)           { this.password = password; }
    public void setPhone(String phone)                 { this.phone = phone; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public void setRole(String role)                   { this.role = role; }
    public void setCreatedDate(String createdDate)     { this.createdDate = createdDate; }

    /**
     * Serialize user to a pipe-delimited string for file storage.
     */
    public String toFileString() {
        return userId + "|" + username + "|" + email + "|" + password + "|"
                + phone + "|" + paymentMethod + "|" + role + "|" + createdDate;
    }

    /**
     * Deserialize user from a pipe-delimited string.
     */
    public static User fromFileString(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 8) return null;
        return new User(parts[0], parts[1], parts[2], parts[3],
                        parts[4], parts[5], parts[6], parts[7]);
    }

    @Override
    public String toString() {
        return "User{userId='" + userId + "', username='" + username +
               "', email='" + email + "', role='" + role + "'}";
    }
}
