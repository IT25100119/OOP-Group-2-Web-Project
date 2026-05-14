package com.bikerental.controller;

import com.bikerental.model.AdminUser;
import com.bikerental.model.User;
import com.bikerental.service.FeedbackService;
import com.bikerental.service.RideService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/feedback")
public class FeedbackController {

    @Autowired private FeedbackService feedbackService;
    @Autowired private RideService     rideService;

    // ─── READ: Public reviews page ────────────────────────────────────────────────

    @GetMapping
    public String viewFeedback(Model model, HttpSession session) {
        model.addAttribute("feedbackList", feedbackService.getVisibleFeedback());
        model.addAttribute("avgRating",    String.format("%.1f", feedbackService.getAverageRating()));
        model.addAttribute("sessionUser",  session.getAttribute("loggedUser"));
        model.addAttribute("sessionAdmin", session.getAttribute("loggedAdmin"));
        return "feedback/list";
    }

    // ─── CREATE: Submit review ────────────────────────────────────────────────────

    @GetMapping("/submit/{rideId}")
    public String submitPage(@PathVariable String rideId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        // Block access if feedback already exists for this ride
        if (feedbackService.feedbackExistsForRide(rideId)) {
            session.setAttribute("feedbackError", "You have already submitted a review for this ride.");
            return "redirect:/user/dashboard";
        }

        model.addAttribute("rideId", rideId);
        model.addAttribute("user", user);
        return "feedback/submit";
    }

    @PostMapping("/submit")
    public String submitFeedback(@RequestParam String rideId,
                                 @RequestParam int rating,
                                 @RequestParam String comment,
                                 HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        boolean ok = feedbackService.submitFeedback(user.getUserId(), user.getUsername(), rideId, rating, comment);
        if (!ok) {
            session.setAttribute("feedbackError", "You have already submitted a review for this ride.");
        }
        return "redirect:/user/dashboard";
    }

    // ─── UPDATE: Edit own review ──────────────────────────────────────────────────

    @GetMapping("/edit/{feedbackId}")
    public String editPage(@PathVariable String feedbackId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        com.bikerental.model.Feedback fb = feedbackService.findById(feedbackId);
        if (fb == null || !fb.getUserId().equals(user.getUserId())) {
            session.setAttribute("feedbackError", "Review not found or access denied.");
            return "redirect:/user/dashboard";
        }
        model.addAttribute("feedback", fb);
        return "feedback/edit";
    }

    @PostMapping("/edit")
    public String updateFeedback(@RequestParam String feedbackId,
                                 @RequestParam int rating,
                                 @RequestParam String comment,
                                 HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";
        com.bikerental.model.Feedback fb = feedbackService.findById(feedbackId);
        if (fb == null || !fb.getUserId().equals(user.getUserId())) {
            session.setAttribute("feedbackError", "Review not found or access denied.");
            return "redirect:/user/dashboard";
        }
        feedbackService.updateFeedback(feedbackId, rating, comment);
        return "redirect:/user/dashboard";
    }

    // ─── DELETE: User deletes their own review ────────────────────────────────────

    @PostMapping("/delete")
    public String deleteOwnFeedback(@RequestParam String feedbackId, HttpSession session) {
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) return "redirect:/login";

        // Ownership check — only the author may delete their own review
        com.bikerental.model.Feedback fb = feedbackService.findById(feedbackId);
        if (fb == null || !fb.getUserId().equals(user.getUserId())) {
            session.setAttribute("feedbackError", "You can only delete your own reviews.");
            return "redirect:/user/dashboard";
        }

        feedbackService.deleteFeedback(feedbackId);
        return "redirect:/user/dashboard";
    }

    // ─── DELETE / MODERATE: Admin ─────────────────────────────────────────────────

    @GetMapping("/admin/moderate")
    public String moderatePage(HttpSession session, Model model) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        model.addAttribute("allFeedback", feedbackService.getAllFeedback());
        model.addAttribute("avgRating",   String.format("%.1f", feedbackService.getAverageRating()));
        return "feedback/moderate";
    }

    @PostMapping("/admin/hide")
    public String hideFeedback(@RequestParam String feedbackId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        feedbackService.hideFeedback(feedbackId);
        return "redirect:/feedback/admin/moderate";
    }

    @PostMapping("/admin/show")
    public String showFeedback(@RequestParam String feedbackId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        feedbackService.showFeedback(feedbackId);
        return "redirect:/feedback/admin/moderate";
    }

    @PostMapping("/admin/delete")
    public String deleteFeedback(@RequestParam String feedbackId, HttpSession session) {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        feedbackService.deleteFeedback(feedbackId);
        return "redirect:/feedback/admin/moderate";
    }
}
