package com.bikerental.service;

import com.bikerental.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * UserService handles all CRUD operations for User management.
 * Data is persisted via FileHandler to users.txt
 */
@Service
public class UserService {

    private static final String USERS_FILE = "users.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired
    private FileHandler fileHandler;

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    public boolean registerUser(String username, String email, String password,
                                String phone, String paymentMethod) {
        // Check if username or email already exists
        if (findByUsername(username) != null) return false;
        if (findByEmail(email) != null) return false;

        String userId = "USR-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String createdDate = LocalDateTime.now().format(DTF);

        User newUser = new User(userId, username, email, password,
                phone, paymentMethod, "USER", createdDate);
        fileHandler.appendLine(USERS_FILE, newUser.toFileString());
        return true;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<User> getAllUsers() {
        List<String> lines = fileHandler.readLines(USERS_FILE);
        List<User> users = new ArrayList<>();
        for (String line : lines) {
            User u = User.fromFileString(line);
            if (u != null && "USER".equals(u.getRole())) users.add(u);
        }
        return users;
    }

    public User findById(String userId) {
        String line = fileHandler.findById(USERS_FILE, userId);
        return line != null ? User.fromFileString(line) : null;
    }

    public User findByUsername(String username) {
        List<String> lines = fileHandler.readLines(USERS_FILE);
        for (String line : lines) {
            User u = User.fromFileString(line);
            if (u != null && u.getUsername().equalsIgnoreCase(username)) return u;
        }
        return null;
    }

    public User findByEmail(String email) {
        List<String> lines = fileHandler.readLines(USERS_FILE);
        for (String line : lines) {
            User u = User.fromFileString(line);
            if (u != null && u.getEmail().equalsIgnoreCase(email)) return u;
        }
        return null;
    }

    public User authenticate(String username, String password) {
        User user = findByUsername(username);
        if (user != null && user.getPassword().equals(password)) return user;
        return null;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    public boolean updateUser(String userId, String email, String phone, String paymentMethod) {
        User user = findById(userId);
        if (user == null) return false;
        user.setEmail(email);
        user.setPhone(phone);
        user.setPaymentMethod(paymentMethod);
        return fileHandler.updateById(USERS_FILE, userId, user.toFileString());
    }

    public boolean changePassword(String userId, String oldPassword, String newPassword) {
        User user = findById(userId);
        if (user == null || !user.getPassword().equals(oldPassword)) return false;
        user.setPassword(newPassword);
        return fileHandler.updateById(USERS_FILE, userId, user.toFileString());
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deleteUser(String userId) {
        return fileHandler.deleteById(USERS_FILE, userId);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public int getTotalUserCount() {
        return getAllUsers().size();
    }
}
