package com.bikerental.controller;

import com.bikerental.model.AdminUser;
import com.bikerental.model.User;
import com.bikerental.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * UserController handles user profile management operations.
 * Covers all 4 CRUD operations for Component 01.
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired private UserService userService;

    // ─── READ: View Profile ───────────────────────────────────────────────────────

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "user/profile";
    }

    // ─── UPDATE: Edit Profile ────────────────────────────────────────────────────

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String userId,
                                @RequestParam String email,
                                @RequestParam String phone,
                                @RequestParam String paymentMethod,
                                HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        boolean ok = userService.updateUser(userId, email, phone, paymentMethod);
        if (ok) {
            // Refresh session user
            User updated = userService.findById(userId);
            session.setAttribute("loggedUser", updated);
            model.addAttribute("user", updated);
            model.addAttribute("success", "Profile updated successfully.");
        } else {
            model.addAttribute("error", "Failed to update profile.");
            model.addAttribute("user", user);
        }
        return "user/profile";
    }

    // ─── UPDATE: Change Password ─────────────────────────────────────────────────

    @PostMapping("/profile/password")
    public String changePassword(@RequestParam String userId,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        boolean ok = userService.changePassword(userId, oldPassword, newPassword);
        model.addAttribute("user", userService.findById(userId));
        if (ok) model.addAttribute("success", "Password changed successfully.");
        else     model.addAttribute("error",   "Old password is incorrect.");
        return "user/profile";
    }

    // ─── DELETE: Delete Account ──────────────────────────────────────────────────

    @PostMapping("/delete")
    public String deleteAccount(@RequestParam String userId, HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null || !user.getUserId().equals(userId)) return "redirect:/login";
        userService.deleteUser(userId);
        session.invalidate();
        return "redirect:/";
    }

    // ─── ADMIN: Manage All Users ──────────────────────────────────────────────────

    @GetMapping("/admin/list")
    public String listUsers(HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        model.addAttribute("users", userService.getAllUsers());
        return "admin/users";
    }

    @GetMapping("/admin/search")
    public String searchUsers(@RequestParam String query, HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        // Search by username
        User found = userService.findByUsername(query);
        if (found == null) found = userService.findByEmail(query);
        model.addAttribute("searchResult", found);
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("query", query);
        return "admin/users";
    }

    @PostMapping("/admin/delete")
    public String adminDeleteUser(@RequestParam String userId, HttpSession session) {
        AdminUser admin = (AdminUser) session.getAttribute("loggedAdmin");
        if (admin == null) return "redirect:/login";
        userService.deleteUser(userId);
        return "redirect:/user/admin/list";
    }
}
