package com.bikerental.service;

import com.bikerental.model.AdminUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * AdminService manages admin accounts (restricted to admin access only).
 */
@Service
public class AdminService {

    private static final String ADMINS_FILE = "admins.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired
    private FileHandler fileHandler;

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    public boolean registerAdmin(String username, String email, String password,
                                  String phone, String adminLevel, String permissions) {
        if (findByUsername(username) != null) return false;

        String adminId = "ADM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String createdDate = LocalDateTime.now().format(DTF);

        AdminUser admin = new AdminUser(adminId, username, email, password,
                phone, createdDate, adminLevel, createdDate, permissions);
        fileHandler.appendLine(ADMINS_FILE, admin.toFileString());
        return true;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<AdminUser> getAllAdmins() {
        List<String> lines = fileHandler.readLines(ADMINS_FILE);
        List<AdminUser> admins = new ArrayList<>();
        for (String line : lines) {
            AdminUser a = AdminUser.fromFileString(line);
            if (a != null) admins.add(a);
        }
        return admins;
    }

    public AdminUser findById(String adminId) {
        String line = fileHandler.findById(ADMINS_FILE, adminId);
        return line != null ? AdminUser.fromFileString(line) : null;
    }

    public AdminUser findByUsername(String username) {
        List<String> lines = fileHandler.readLines(ADMINS_FILE);
        for (String line : lines) {
            AdminUser a = AdminUser.fromFileString(line);
            if (a != null && a.getUsername().equalsIgnoreCase(username)) return a;
        }
        return null;
    }

    public AdminUser authenticate(String username, String password) {
        AdminUser admin = findByUsername(username);
        if (admin != null && admin.getPassword().equals(password)) {
            // Update last login date
            admin.setLastLoginDate(LocalDateTime.now().format(DTF));
            fileHandler.updateById(ADMINS_FILE, admin.getUserId(), admin.toFileString());
            return admin;
        }
        return null;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    public boolean updateAdmin(String adminId, String email, String phone,
                                String adminLevel, String permissions) {
        AdminUser admin = findById(adminId);
        if (admin == null) return false;
        admin.setEmail(email);
        admin.setPhone(phone);
        admin.setAdminLevel(adminLevel);
        admin.setPermissions(permissions);
        return fileHandler.updateById(ADMINS_FILE, adminId, admin.toFileString());
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deleteAdmin(String adminId) {
        // Prevent deleting the last admin
        if (getAllAdmins().size() <= 1) return false;
        return fileHandler.deleteById(ADMINS_FILE, adminId);
    }

    // ─── SEED default admin if none exist ────────────────────────────────────────

    public void seedDefaultAdmin() {
        if (fileHandler.countRecords(ADMINS_FILE) == 0) {
            registerAdmin("admin", "admin@bikerental.com", "admin123",
                    "0000000000", "SUPER_ADMIN",
                    "BIKES,USERS,STATIONS,FEEDBACK,ADMINS");
        }
    }
}
