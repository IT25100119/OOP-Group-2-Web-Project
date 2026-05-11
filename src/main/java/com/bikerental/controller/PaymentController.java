package com.bikerental.controller;

import com.bikerental.model.AdminUser;
import com.bikerental.model.Payment;
import com.bikerental.model.User;
import com.bikerental.service.PaymentService;
import com.bikerental.service.PaymentTransactionService;
import com.bikerental.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * PaymentController — admin payment management + user payment history.
 * Every status action records who the admin was via session.
 */
@Controller
@RequestMapping("/payments")
public class PaymentController {

    @Autowired private PaymentService            paymentService;
    @Autowired private PaymentTransactionService txService;
    @Autowired private UserService               userService;

    // ── helper: get admin info from session ──────────────────────────────────────

    private boolean isAdmin(HttpSession session) {
        return session.getAttribute("loggedAdmin") != null;
    }

    private String adminId(HttpSession session) {
        AdminUser a = (AdminUser) session.getAttribute("loggedAdmin");
        return a != null ? a.getUserId() : "unknown";
    }

    private String adminName(HttpSession session) {
        AdminUser a = (AdminUser) session.getAttribute("loggedAdmin");
        return a != null ? a.getUsername() : "Admin";
    }

    // ── helper: populate dashboard model ─────────────────────────────────────────

    private void populateDashModel(Model model, List<Payment> payments, HttpSession session) {
        model.addAttribute("allPayments",     payments);
        model.addAttribute("totalRevenue",    String.format("%.2f", paymentService.getTotalRevenue()));
        model.addAttribute("rawTotalRevenue",  paymentService.getTotalRevenue());
        model.addAttribute("totalRefunded",   String.format("%.2f", paymentService.getTotalRefunded()));
        model.addAttribute("totalCount",      paymentService.getTotalCount());
        model.addAttribute("completedCount",  paymentService.countByStatus("COMPLETED"));
        model.addAttribute("pendingCount",    paymentService.countByStatus("PENDING"));
        model.addAttribute("refundedCount",   paymentService.countByStatus("REFUNDED"));
        model.addAttribute("failedCount",     paymentService.countByStatus("FAILED"));
        model.addAttribute("avgPayment",      String.format("%.2f", paymentService.getAveragePayment()));
        model.addAttribute("revenueByMethod", paymentService.getRevenueByMethod());
        model.addAttribute("last7Days",       paymentService.getLast7DaysRevenue());
        model.addAttribute("admin",           session.getAttribute("loggedAdmin"));
        model.addAttribute("recentTx",        txService.getRecent(5));
    }

    // ─── ADMIN: Main dashboard ───────────────────────────────────────────────────

    
    @GetMapping("/admin")
    public String adminDashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        populateDashModel(model, paymentService.getAllPayments(), session);

        // Fix: Get the attribute first, then remove it
        if (model.getAttribute("success") == null && model.getAttribute("error") == null) {
            Object flash = session.getAttribute("pay_flash");
            if (flash != null) {
                model.addAttribute("success", (String) flash);
                session.removeAttribute("pay_flash"); // removeAttribute returns void
            }
        }

        return "admin/payments/dashboard";
    }
    // ─── ADMIN: Filter / search ──────────────────────────────────────────────────

    @GetMapping("/admin/filter")
    public String filterPayments(@RequestParam(required=false) String status,
                                  @RequestParam(required=false) String method,
                                  @RequestParam(required=false) String search,
                                  HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        List<Payment> payments;
        if (search != null && !search.isBlank()) {
            payments = paymentService.searchPayments(search);
            model.addAttribute("search", search);
        } else if (status != null && !status.isBlank()) {
            payments = paymentService.getByStatus(status);
            model.addAttribute("filterStatus", status);
        } else if (method != null && !method.isBlank()) {
            payments = paymentService.getByMethod(method);
            model.addAttribute("filterMethod", method);
        } else {
            payments = paymentService.getAllPayments();
        }
        populateDashModel(model, payments, session);
        return "admin/payments/dashboard";
    }

    // ─── ADMIN: View detail ──────────────────────────────────────────────────────

    @GetMapping("/admin/{paymentId}")
    public String viewPayment(@PathVariable String paymentId,
                               HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        Payment p = paymentService.findById(paymentId);
        if (p == null) return "redirect:/payments/admin";
        model.addAttribute("payment",  p);
        model.addAttribute("user",     userService.findById(p.getUserId()));
        model.addAttribute("txHistory", txService.getByPayment(paymentId));
        return "admin/payments/detail";
    }

    // ─── ADMIN: CREATE manual payment ────────────────────────────────────────────

    @GetMapping("/admin/create")
    public String createPage(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("users", userService.getAllUsers());
        return "admin/payments/create";
    }

    @PostMapping("/admin/create")
    public String createPayment(@RequestParam String rideId,
                                 @RequestParam String userId,
                                 @RequestParam double amount,
                                 @RequestParam String paymentMethod,
                                 @RequestParam(defaultValue="") String notes,
                                 HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        User user = userService.findById(userId);
        String username = user != null ? user.getUsername() : userId;
        paymentService.createManualPayment(rideId, userId, username, amount,
                paymentMethod, adminId(session), adminName(session), notes);
        session.setAttribute("pay_flash", "Payment created successfully.");
        return "redirect:/payments/admin";
    }

    // ─── ADMIN: EDIT ─────────────────────────────────────────────────────────────

    @GetMapping("/admin/edit/{paymentId}")
    public String editPage(@PathVariable String paymentId,
                            HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("payment", paymentService.findById(paymentId));
        return "admin/payments/edit";
    }

    @PostMapping("/admin/edit")
    public String updatePayment(@RequestParam String paymentId,
                                 @RequestParam double amount,
                                 @RequestParam String paymentMethod,
                                 @RequestParam String status,
                                 @RequestParam(defaultValue="") String notes,
                                 HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.updatePayment(paymentId, amount, paymentMethod, status, notes,
                adminId(session), adminName(session));
        return "redirect:/payments/admin/" + paymentId;
    }

    // ─── ADMIN: Quick status actions (all pass admin identity) ───────────────────

    @PostMapping("/admin/refund")
    public String refund(@RequestParam String paymentId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.updateStatus(paymentId, "REFUNDED",
                adminId(session), adminName(session),
                "Refunded by " + adminName(session));
        return "redirect:/payments/admin/" + paymentId;
    }

    @PostMapping("/admin/complete")
    public String markComplete(@RequestParam String paymentId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.updateStatus(paymentId, "COMPLETED",
                adminId(session), adminName(session),
                "Marked completed by " + adminName(session));
        return "redirect:/payments/admin/" + paymentId;
    }

    @PostMapping("/admin/fail")
    public String markFail(@RequestParam String paymentId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.updateStatus(paymentId, "FAILED",
                adminId(session), adminName(session),
                "Marked failed by " + adminName(session));
        return "redirect:/payments/admin/" + paymentId;
    }

    @PostMapping("/admin/pending")
    public String markPending(@RequestParam String paymentId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.updateStatus(paymentId, "PENDING",
                adminId(session), adminName(session),
                "Reset to pending by " + adminName(session));
        return "redirect:/payments/admin/" + paymentId;
    }

    // ─── ADMIN: DELETE ────────────────────────────────────────────────────────────

    @PostMapping("/admin/delete")
    public String deletePayment(@RequestParam String paymentId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        paymentService.deletePayment(paymentId, adminId(session), adminName(session));
        session.setAttribute("pay_flash", "Payment deleted.");
        return "redirect:/payments/admin";
    }

    // ─── USER: Own payment history ────────────────────────────────────────────────

    @GetMapping("/my")
    public String myPayments(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        List<Payment> payments = paymentService.getPaymentsByUser(user.getUserId());
        double total = payments.stream()
                .filter(p -> "COMPLETED".equals(p.getStatus()))
                .mapToDouble(Payment::getAmount).sum();
        model.addAttribute("payments",   payments);
        model.addAttribute("totalSpent", String.format("%.2f", total));
        model.addAttribute("user",       user);
        return "user/my-payments";
    }
}
