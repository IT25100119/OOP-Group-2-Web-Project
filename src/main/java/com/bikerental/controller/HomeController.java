package com.bikerental.controller;

import com.bikerental.service.FeedbackService;
import com.bikerental.service.AdminService;
import com.bikerental.service.UserService;
import com.bikerental.service.RideService;
import com.bikerental.service.StationService;
import com.bikerental.service.BikeService;
import com.bikerental.model.AdminUser;
import com.bikerental.model.User;
import com.bikerental.service.*;
import com.bikerental.service.PaymentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * HomeController handles the landing page, login, logout, and dashboard routing.
 */
@Controller
public class HomeController {

    @Autowired private UserService    userService;
    @Autowired private AdminService   adminService;
    @Autowired private BikeService    bikeService;
    @Autowired private RideService    rideService;
    @Autowired private StationService stationService;
    @Autowired private FeedbackService feedbackService;
    @Autowired private PaymentService paymentService;

    // ─── Landing Page ────────────────────────────────────────────────────────────

    @GetMapping("/")
    public String index(HttpSession session, Model model) {
        model.addAttribute("totalBikes",    bikeService.getAllBikes().size());
        model.addAttribute("availBikes",    bikeService.countAvailable());
        model.addAttribute("totalStations", stationService.getTotalStationCount());
        model.addAttribute("avgRating",     String.format("%.1f", feedbackService.getAverageRating()));
        model.addAttribute("recentFeedback", feedbackService.getVisibleFeedback().stream()
                .limit(3).toList());
        return "index";
    }

    // ─── Login Page ──────────────────────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error, Model model) {
        if (error != null) model.addAttribute("error", "Invalid username or password.");
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          @RequestParam(defaultValue = "USER") String loginAs,
                          HttpSession session, Model model) {
        if ("ADMIN".equals(loginAs)) {
            AdminUser admin = adminService.authenticate(username, password);
            if (admin != null) {
                session.setAttribute("loggedAdmin", admin);
                session.setAttribute("sessionUser", admin);
                return "redirect:/admin/dashboard";
            }
        } else {
            User user = userService.authenticate(username, password);
            if (user != null) {
                session.setAttribute("loggedUser", user);
                session.setAttribute("sessionUser", user);
                return "redirect:/user/dashboard";
            }
        }
        model.addAttribute("error", "Invalid username or password.");
        return "login";
    }

    // ─── Logout ──────────────────────────────────────────────────────────────────

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ─── Register Page ────────────────────────────────────────────────────────────

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(@RequestParam String username,
                             @RequestParam String email,
                             @RequestParam String password,
                             @RequestParam String phone,
                             @RequestParam(defaultValue = "CASH") String paymentMethod,
                             Model model) {
        boolean ok = userService.registerUser(username, email, password, phone, paymentMethod);
        if (ok) {
            model.addAttribute("success", "Account created! Please log in.");
            return "login";
        }
        model.addAttribute("error", "Username or email already in use.");
        return "register";
    }

    // ─── User Dashboard ──────────────────────────────────────────────────────────

    @GetMapping("/user/dashboard")
    public String userDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        model.addAttribute("availBikes",  bikeService.countAvailable());
        model.addAttribute("myRides",     rideService.getRidesByUser(user.getUserId()));
        model.addAttribute("activeRide",  rideService.getActiveRideByUser(user.getUserId()));
        model.addAttribute("myFeedback",  feedbackService.getFeedbackByUser(user.getUserId()));
        return "user/dashboard";
    }

    // ─── Admin Dashboard ─────────────────────────────────────────────────────────

    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        AdminUser admin = (AdminUser) session.getAttribute("loggedAdmin");
        if (admin == null) return "redirect:/login";
        model.addAttribute("admin",         admin);
        model.addAttribute("totalUsers",    userService.getTotalUserCount());
        model.addAttribute("totalBikes",    bikeService.getAllBikes().size());
        model.addAttribute("availBikes",    bikeService.countAvailable());
        model.addAttribute("activeRides",   rideService.countActiveRides());
        model.addAttribute("totalRevenue",  String.format("%.2f", rideService.getTotalRevenue()));
        model.addAttribute("totalStations", stationService.getTotalStationCount());
        model.addAttribute("avgRating",     String.format("%.1f", feedbackService.getAverageRating()));
        model.addAttribute("totalPayRevenue", String.format("%.2f", paymentService.getTotalRevenue()));
        model.addAttribute("pendingPayments", paymentService.countByStatus("PENDING"));
        model.addAttribute("refundedCount",   paymentService.countByStatus("REFUNDED"));
        model.addAttribute("recentRides",   rideService.getAllRides().stream().limit(5).toList());
        return "admin/dashboard";
    }
}
