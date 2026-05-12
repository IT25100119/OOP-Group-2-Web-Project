package com.bikerental.controller;

import com.bikerental.service.PaymentTransactionService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * TransactionController provides the admin transaction audit log.
 * Shows every payment event with filtering, search, and detail views.
 */
@Controller
@RequestMapping("/admin/transactions")
public class TransactionController {

    @Autowired private PaymentTransactionService txService;

    private boolean isAdmin(HttpSession session) {
        return session.getAttribute("loggedAdmin") != null;
    }

    // ─── Main log page ────────────────────────────────────────────────────────────

    @GetMapping
    public String transactionLog(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("transactions",     txService.getAll());
        model.addAttribute("actionBreakdown",  txService.getActionBreakdown());
        model.addAttribute("totalRefunded",    String.format("%.2f", txService.totalRefundedAmount()));
        model.addAttribute("recentCount",      txService.getRecent(10).size());
        model.addAttribute("admin",            session.getAttribute("loggedAdmin"));
        return "admin/transactions";
    }

    // ─── Filter / Search ─────────────────────────────────────────────────────────

    @GetMapping("/filter")
    public String filterTransactions(@RequestParam(required = false) String action,
                                      @RequestParam(required = false) String search,
                                      @RequestParam(required = false) String userId,
                                      HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";

        var list = (search != null && !search.isBlank())
                ? txService.search(search)
                : (action != null && !action.isBlank())
                ? txService.getByAction(action)
                : (userId != null && !userId.isBlank())
                ? txService.getByUser(userId)
                : txService.getAll();

        model.addAttribute("transactions",    list);
        model.addAttribute("actionBreakdown", txService.getActionBreakdown());
        model.addAttribute("totalRefunded",   String.format("%.2f", txService.totalRefundedAmount()));
        model.addAttribute("filterAction",    action);
        model.addAttribute("search",          search);
        model.addAttribute("admin",           session.getAttribute("loggedAdmin"));
        return "admin/transactions";
    }

    // ─── Delete single transaction log entry ─────────────────────────────────────

    @PostMapping("/delete")
    public String deleteTransaction(@RequestParam String txId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        txService.deleteById(txId);
        return "redirect:/admin/transactions";
    }
}
