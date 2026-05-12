package com.bikerental.controller;

import com.bikerental.model.AdminUser;
import com.bikerental.service.AdminService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * AdminController handles admin account management (admin-only access).
 * Demonstrates Abstraction: admin-only methods are restricted from regular users.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private AdminService adminService;

    private boolean isAdmin(HttpSession session) {
        return session.getAttribute("loggedAdmin") != null;
    }

    // ─── READ: List all admins ────────────────────────────────────────────────────

    @GetMapping("/list")
    public String listAdmins(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("admins", adminService.getAllAdmins());
        model.addAttribute("currentAdmin", session.getAttribute("loggedAdmin"));
        return "admin/admin-list";
    }

    // ─── CREATE: Register new admin ──────────────────────────────────────────────

    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        return "admin/admin-register";
    }

    @PostMapping("/register")
    public String registerAdmin(@RequestParam String username,
                                @RequestParam String email,
                                @RequestParam String password,
                                @RequestParam String phone,
                                @RequestParam(defaultValue = "ADMIN") String adminLevel,
                                @RequestParam(defaultValue = "BIKES,USERS") String permissions,
                                HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        boolean ok = adminService.registerAdmin(username, email, password, phone, adminLevel, permissions);
        if (ok) return "redirect:/admin/list";
        model.addAttribute("error", "Username already exists.");
        return "admin/admin-register";
    }

    // ─── UPDATE: Edit admin details ──────────────────────────────────────────────

    @GetMapping("/edit/{adminId}")
    public String editPage(@PathVariable String adminId, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        model.addAttribute("targetAdmin", adminService.findById(adminId));
        return "admin/admin-edit";
    }

    @PostMapping("/edit")
    public String updateAdmin(@RequestParam String adminId,
                              @RequestParam String email,
                              @RequestParam String phone,
                              @RequestParam String adminLevel,
                              @RequestParam String permissions,
                              HttpSession session) {
        if (!isAdmin(session)) return "redirect:/login";
        adminService.updateAdmin(adminId, email, phone, adminLevel, permissions);
        return "redirect:/admin/list";
    }

    // ─── DELETE: Remove admin ────────────────────────────────────────────────────

    @PostMapping("/delete")
    public String deleteAdmin(@RequestParam String adminId, HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/login";
        boolean ok = adminService.deleteAdmin(adminId);
        if (!ok) {
            model.addAttribute("error", "Cannot delete the last admin account.");
            model.addAttribute("admins", adminService.getAllAdmins());
            return "admin/admin-list";
        }
        return "redirect:/admin/list";
    }
}
