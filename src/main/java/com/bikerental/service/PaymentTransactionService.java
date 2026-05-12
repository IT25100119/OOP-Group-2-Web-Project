package com.bikerental.service;

import com.bikerental.model.PaymentTransaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * PaymentTransactionService — audit log for every payment event.
 * Only depends on FileHandler (no circular dependencies).
 */
@Service
public class PaymentTransactionService {

    private static final String TX_FILE = "transactions.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private FileHandler fileHandler;

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    /**
     * Log any payment event. adminId/adminName may be empty for system events.
     */
    public PaymentTransaction log(String paymentId, String rideId,
                                   String userId,   String username,
                                   String adminId,  String adminName,
                                   String action,   double amount,
                                   String paymentMethod,
                                   String previousStatus, String newStatus,
                                   String notes) {
        String txId = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String ts   = LocalDateTime.now().format(DTF);

        PaymentTransaction tx = new PaymentTransaction(
                txId, paymentId, rideId, userId, username,
                adminId  == null ? "" : adminId,
                adminName== null ? "System" : adminName,
                action, amount, paymentMethod,
                previousStatus == null ? "" : previousStatus,
                newStatus      == null ? "" : newStatus,
                ts, notes == null ? "" : notes.replace("|", ";"));

        fileHandler.appendLine(TX_FILE, tx.toFileString());
        return tx;
    }

    /** Convenience: system-generated event (no admin). */
    public PaymentTransaction logSystem(String paymentId, String rideId,
                                         String userId,   String username,
                                         String action,   double amount,
                                         String paymentMethod,
                                         String newStatus, String notes) {
        return log(paymentId, rideId, userId, username,
                "", "System", action, amount, paymentMethod, "", newStatus, notes);
    }

    /** Convenience: admin-triggered event. */
    public PaymentTransaction logAdmin(String paymentId, String rideId,
                                        String userId,   String username,
                                        String adminId,  String adminName,
                                        String action,   double amount,
                                        String paymentMethod,
                                        String previousStatus, String newStatus,
                                        String notes) {
        return log(paymentId, rideId, userId, username,
                adminId, adminName, action, amount, paymentMethod,
                previousStatus, newStatus, notes);
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<PaymentTransaction> getAll() {
        List<String> lines = fileHandler.readLines(TX_FILE);
        List<PaymentTransaction> list = new ArrayList<>();
        for (String line : lines) {
            PaymentTransaction tx = PaymentTransaction.fromFileString(line);
            if (tx != null) list.add(tx);
        }
        list.sort(Comparator.comparing(PaymentTransaction::getTimestamp).reversed());
        return list;
    }

    public List<PaymentTransaction> getByPayment(String paymentId) {
        return getAll().stream()
                .filter(t -> t.getPaymentId().equals(paymentId))
                .collect(Collectors.toList());
    }

    public List<PaymentTransaction> getByUser(String userId) {
        return getAll().stream()
                .filter(t -> t.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public List<PaymentTransaction> getByAction(String action) {
        return getAll().stream()
                .filter(t -> t.getAction().equalsIgnoreCase(action))
                .collect(Collectors.toList());
    }

    public List<PaymentTransaction> search(String query) {
        String q = query.toLowerCase();
        return getAll().stream()
                .filter(t -> t.getTxId().toLowerCase().contains(q)
                          || t.getPaymentId().toLowerCase().contains(q)
                          || t.getUsername().toLowerCase().contains(q)
                          || t.getRideId().toLowerCase().contains(q)
                          || t.getAdminName().toLowerCase().contains(q))
                .collect(Collectors.toList());
    }

    public List<PaymentTransaction> getRecent(int limit) {
        return getAll().stream().limit(limit).collect(Collectors.toList());
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deleteById(String txId) {
        return fileHandler.deleteById(TX_FILE, txId);
    }

    public void deleteAllForPayment(String paymentId) {
        List<String> lines = fileHandler.readLines(TX_FILE);
        lines.removeIf(l -> {
            PaymentTransaction t = PaymentTransaction.fromFileString(l);
            return t != null && t.getPaymentId().equals(paymentId);
        });
        fileHandler.writeLines(TX_FILE, lines);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public long countByAction(String action) {
        return getAll().stream()
                .filter(t -> t.getAction().equalsIgnoreCase(action)).count();
    }

    public double totalRefundedAmount() {
        return getAll().stream()
                .filter(t -> "REFUNDED".equals(t.getAction()))
                .mapToDouble(PaymentTransaction::getAmount).sum();
    }

    public Map<String, Long> getActionBreakdown() {
        Map<String, Long> map = new LinkedHashMap<>();
        map.put("CREATED",   countByAction("CREATED"));
        map.put("COMPLETED", countByAction("COMPLETED"));
        map.put("REFUNDED",  countByAction("REFUNDED"));
        map.put("FAILED",    countByAction("FAILED"));
        map.put("EDITED",    countByAction("EDITED"));
        return map;
    }
}
