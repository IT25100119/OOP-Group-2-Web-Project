package com.bikerental.model;

/**
 * AdminUser class demonstrating Inheritance (OOP Concept).
 * AdminUser extends User and adds admin-specific functionality.
 */
public class AdminUser extends User {

    private String adminLevel;       // "SUPER_ADMIN" or "ADMIN"
    private String lastLoginDate;
    private String permissions;      // comma-separated: "BIKES,USERS,STATIONS,FEEDBACK"

    // Default constructor
    public AdminUser() {
        super();
        this.setRole("ADMIN");
    }

    // Parameterized constructor
    public AdminUser(String userId, String username, String email, String password,
                     String phone, String createdDate,
                     String adminLevel, String lastLoginDate, String permissions) {
        super(userId, username, email, password, phone, "N/A", "ADMIN", createdDate);
        this.adminLevel   = adminLevel;
        this.lastLoginDate = lastLoginDate;
        this.permissions  = permissions;
    }

    // ─── Admin-specific Getters/Setters ─────────────────────────────────────────

    public String getAdminLevel()    { return adminLevel; }
    public String getLastLoginDate() { return lastLoginDate; }
    public String getPermissions()   { return permissions; }

    public void setAdminLevel(String adminLevel)       { this.adminLevel = adminLevel; }
    public void setLastLoginDate(String lastLoginDate) { this.lastLoginDate = lastLoginDate; }
    public void setPermissions(String permissions)     { this.permissions = permissions; }

    /**
     * Abstraction: Admin-only method to check if admin has a specific permission.
     */
    public boolean hasPermission(String permission) {
        if (permissions == null) return false;
        return permissions.contains(permission);
    }

    /**
     * Abstraction: Admin-only method to grant a permission.
     */
    public void grantPermission(String permission) {
        if (!hasPermission(permission)) {
            this.permissions = (permissions == null || permissions.isEmpty())
                    ? permission : permissions + "," + permission;
        }
    }

    @Override
    public String toFileString() {
        return getUserId() + "|" + getUsername() + "|" + getEmail() + "|"
                + getPassword() + "|" + getPhone() + "|" + getCreatedDate() + "|"
                + adminLevel + "|" + lastLoginDate + "|" + permissions;
    }

    public static AdminUser fromFileString(String line) {
        String[] parts = line.split("\\|", -1);
        if (parts.length < 9) return null;
        return new AdminUser(parts[0], parts[1], parts[2], parts[3],
                             parts[4], parts[5], parts[6], parts[7], parts[8]);
    }

    @Override
    public String toString() {
        return "AdminUser{userId='" + getUserId() + "', username='" + getUsername()
                + "', adminLevel='" + adminLevel + "'}";
    }
}
