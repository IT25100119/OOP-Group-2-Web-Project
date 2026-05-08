package com.bikerental.controller;

import com.bikerental.service.FeedbackService;
import com.bikerental.service.RideService;
import com.bikerental.service.StationService;
import com.bikerental.service.BikeService;
import com.bikerental.model.Ride;
import com.bikerental.model.Bike;
import com.bikerental.model.AdminUser;
import com.bikerental.model.User;
import com.bikerental.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * RideController manages the full ride/rental lifecycle.
 * Uses Queue internally (via RideService) to process rental requests.
 */
@Controller
@RequestMapping("/rides")
public class RideController {

    @Autowired private RideService    rideService;
    @Autowired private BikeService    bikeService;
    @Autowired private StationService stationService;
    @Autowired private FeedbackService feedbackService;

    // ─── READ: Rental queue dashboard (admin) ─────────────────────────────────────

    @GetMapping("/queue")
    public String queueDashboard(HttpSession session, Model model) {
        AdminUser admin = (AdminUser) session.getAttribute("loggedAdmin");
        if (admin == null) return "redirect:/login";
        model.addAttribute("queuedRides", rideService.getQueuedAndActiveRides());
        model.addAttribute("allRides",    rideService.getAllRides());
        return "rides/queue";
    }

    // ─── CREATE: Rent a bike ──────────────────────────────────────────────────────

    @GetMapping("/rent")
    public String rentPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        // Block if user already has an active ride
        if (rideService.getActiveRideByUser(user.getUserId()) != null) {
            model.addAttribute("error", "You already have an active ride. Please return your bike first.");
            model.addAttribute("user", user);
            model.addAttribute("availBikes",  bikeService.countAvailable());
            model.addAttribute("myRides",     rideService.getRidesByUser(user.getUserId()));
            model.addAttribute("activeRide",  rideService.getActiveRideByUser(user.getUserId()));
            model.addAttribute("myFeedback",  feedbackService.getFeedbackByUser(user.getUserId()));
            return "user/dashboard";
        }
        model.addAttribute("user", user);
        model.addAttribute("availableBikes", bikeService.getAvailableBikes());
        model.addAttribute("stations", stationService.getOpenStations());
        return "rides/rent";
    }

    @PostMapping("/rent")
    public String requestRide(@RequestParam String bikeId,
                              @RequestParam String startStationId,
                              HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        var ride = rideService.requestRide(user.getUserId(), bikeId, startStationId);
        if (ride != null) {
            model.addAttribute("success", "Ride started! Ride ID: " + ride.getRideId());
            model.addAttribute("ride", ride);
            return "rides/ride-started";
        }
        model.addAttribute("error", "Bike is not available. Please try another.");
        model.addAttribute("availableBikes", bikeService.getAvailableBikes());
        model.addAttribute("stations", stationService.getOpenStations());
        return "rides/rent";
    }

    // ─── UPDATE: Return bike / end ride ──────────────────────────────────────────

    @GetMapping("/return")
    public String returnPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        var activeRide = rideService.getActiveRideByUser(user.getUserId());
        if (activeRide == null) return "redirect:/user/dashboard";
        model.addAttribute("activeRide",  activeRide);
        model.addAttribute("bike",        bikeService.findById(activeRide.getBikeId()));
        model.addAttribute("stations",    stationService.getOpenStations());
        return "rides/return";
    }

    @PostMapping("/return")
    public String endRide(@RequestParam String rideId,
                          @RequestParam String endStationId,
                          HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        var completed = rideService.completeRide(rideId, endStationId);
        if (completed != null) {
            model.addAttribute("completedRide", completed);
            model.addAttribute("bike", bikeService.findById(completed.getBikeId()));
            return "rides/ride-complete";
        }
        return "redirect:/user/dashboard";
    }

    // ─── DELETE: Cancel a ride ────────────────────────────────────────────────────

    @PostMapping("/cancel")
    public String cancelRide(@RequestParam String rideId, HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        rideService.cancelRide(rideId);
        return "redirect:/user/dashboard";
    }

    @PostMapping("/admin/delete")
    public String adminDeleteRide(@RequestParam String rideId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        rideService.deleteRide(rideId);
        return "redirect:/rides/queue";
    }
}
