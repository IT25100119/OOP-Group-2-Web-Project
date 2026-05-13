package com.bikerental.service;

import com.bikerental.model.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * PaymentService — CRUD + stats for Payment management.
 * Uses PaymentTransactionService (direct inject, no circular dep).
 */
@Service
public class PaymentService {

    private static final String PAYMENTS_FILE = "payments.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired private FileHandler fileHandler;
    @Autowired private PaymentTransactionService txService;   // no @Lazy needed

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    /** Auto-called when a ride completes. */
    public Payment createPayment(String rideId, String userId, String username,
                                  double amount, String paymentMethod) {
        // Guard: prevent duplicate payments for the same ride
        Payment existing = findByRideId(rideId);
        if (existing != null) return existing;

        // Round to 2 decimal places to avoid floating-point artifacts
        amount = Math.round(amount * 100.0) / 100.0;

        String paymentId = "PAY-" + UUID.randomUUID().toString().substring(0,8).toUpperCase();
        String date      = LocalDateTime.now().format(DTF);
        String status    = amount > 0 ? "COMPLETED" : "FAILED";

        Payment p = new Payment(paymentId, rideId, userId, username,
                amount, paymentMethod, status, date, "Auto-generated on ride completion");
        fileHandler.appendLine(PAYMENTS_FILE, p.toFileString());

        txService.logSystem(paymentId, rideId, userId, username,
                "CREATED", amount, paymentMethod, status,
                "Auto-generated on ride completion");
        return p;
    }

    /** Admin creates a payment manually. */
    public Payment createManualPayment(String rideId, String userId, String username,
                                        double amount, String paymentMethod,
                                        String adminId, String adminName, String notes) {
        // Round to 2 decimal places
        amount = Math.round(amount * 100.0) / 100.0;
        String paymentId = "PAY-" + UUID.randomUUID().toString().substring(0,8).toUpperCase();
        String date      = LocalDateTime.now().format(DTF);
        String note      = (notes == null || notes.isBlank()) ? "Manual entry by admin" : notes;

        Payment p = new Payment(paymentId, rideId, userId, username,
                amount, paymentMethod, "COMPLETED", date, note);
        fileHandler.appendLine(PAYMENTS_FILE, p.toFileString());

        txService.logAdmin(paymentId, rideId, userId, username,
                adminId, adminName, "CREATED", amount, paymentMethod,
                "", "COMPLETED", note);
        return p;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<Payment> getAllPayments() {
        List<String> lines = fileHandler.readLines(PAYMENTS_FILE);
        List<Payment> list = new ArrayList<>();
        for (String line : lines) {
            Payment p = Payment.fromFileString(line);
            if (p != null) list.add(p);
        }
        list.sort(Comparator.comparing(Payment::getTransactionDate).reversed());
        return list;
    }

    public Payment findById(String paymentId) {
        String line = fileHandler.findById(PAYMENTS_FILE, paymentId);
        return line != null ? Payment.fromFileString(line) : null;
    }

    public Payment findByRideId(String rideId) {
        return getAllPayments().stream()
                .filter(p -> p.getRideId().equals(rideId))
                .findFirst().orElse(null);
    }

    public List<Payment> getPaymentsByUser(String userId) {
        return getAllPayments().stream()
                .filter(p -> p.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<Payment> getByStatus(String status) {
        return getAllPayments().stream()
                .filter(p -> p.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
    }

    public List<Payment> getByMethod(String method) {
        return getAllPayments().stream()
                .filter(p -> p.getPaymentMethod().equalsIgnoreCase(method))
                .collect(Collectors.toList());
    }

    public List<Payment> searchPayments(String query) {
        String q = query.toLowerCase();
        return getAllPayments().stream()
                .filter(p -> p.getPaymentId().toLowerCase().contains(q)
                          || p.getRideId().toLowerCase().contains(q)
                          || p.getUsername().toLowerCase().contains(q)
                          || p.getUserId().toLowerCase().contains(q))
                .collect(Collectors.toList());
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    /** Admin changes status — logs who did it. */
    public boolean updateStatus(String paymentId, String newStatus,
                                 String adminId, String adminName, String notes) {
        Payment p = findById(paymentId);
        if (p == null) return false;
        String oldStatus = p.getStatus();
        p.setStatus(newStatus);
        if (notes != null && !notes.isBlank()) p.setNotes(notes);
        boolean ok = fileHandler.updateById(PAYMENTS_FILE, paymentId, p.toFileString());
        if (ok) {
            String note = (notes == null || notes.isBlank()) ? newStatus + " by " + adminName : notes;
            txService.logAdmin(paymentId, p.getRideId(), p.getUserId(), p.getUsername(),
                    adminId, adminName, newStatus,
                    p.getAmount(), p.getPaymentMethod(),
                    oldStatus, newStatus, note);
        }
        return ok;
    }

    /** Fully edit a payment record (admin). */
    public boolean updatePayment(String paymentId, double amount,
                                  String method, String status, String notes,
                                  String adminId, String adminName) {
        Payment p = findById(paymentId);
        if (p == null) return false;
        String oldStatus = p.getStatus();
        p.setAmount(amount);
        p.setPaymentMethod(method);
        p.setStatus(status);
        p.setNotes(notes == null ? "" : notes);
        boolean ok = fileHandler.updateById(PAYMENTS_FILE, paymentId, p.toFileString());
        if (ok) {
            txService.logAdmin(paymentId, p.getRideId(), p.getUserId(), p.getUsername(),
                    adminId, adminName, "EDITED",
                    amount, method, oldStatus, status,
                    "Edited by " + adminName + ". " + (notes == null ? "" : notes));
        }
        return ok;
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deletePayment(String paymentId, String adminId, String adminName) {
        Payment p = findById(paymentId);
        if (p != null) {
            txService.logAdmin(paymentId, p.getRideId(), p.getUserId(), p.getUsername(),
                    adminId, adminName, "DELETED",
                    p.getAmount(), p.getPaymentMethod(),
                    p.getStatus(), "DELETED", "Deleted by " + adminName);
        }
        return fileHandler.deleteById(PAYMENTS_FILE, paymentId);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public double getTotalRevenue() {
        return getAllPayments().stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .mapToDouble(Payment::getAmount).sum();
    }

    public double getTotalRefunded() {
        return getAllPayments().stream()
                .filter(p -> "REFUNDED".equals(p.getStatus()))
                .mapToDouble(Payment::getAmount).sum();
    }

    public long countByStatus(String status) {
        return getAllPayments().stream()
                .filter(p -> p.getStatus().equalsIgnoreCase(status)).count();
    }

    public Map<String, Double> getRevenueByMethod() {
        Map<String, Double> map = new LinkedHashMap<>();
        map.put("CASH", 0.0); map.put("VISA", 0.0);
        map.put("MASTERCARD", 0.0); map.put("PAYPAL", 0.0);
        getAllPayments().stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .forEach(p -> map.merge(p.getPaymentMethod(), p.getAmount(), Double::sum));
        return map;
    }

    public Map<String, Double> getLast7DaysRevenue() {
        Map<String, Double> daily = new TreeMap<>();
        getAllPayments().stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .forEach(p -> {
                    String day = p.getTransactionDate().substring(0, 10);
                    daily.merge(day, p.getAmount(), Double::sum);
                });
        Map<String, Double> result = new LinkedHashMap<>();
        for (int i = 6; i >= 0; i--) {
            String day = LocalDateTime.now().minusDays(i)
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            result.put(day, daily.getOrDefault(day, 0.0));
        }
        return result;
    }

    public int getTotalCount() { return getAllPayments().size(); }

    public double getAveragePayment() {
        List<Payment> done = getByStatus("COMPLETED");
        if (done.isEmpty()) return 0.0;
        return done.stream().mapToDouble(Payment::getAmount).average().orElse(0.0);
    }
}
