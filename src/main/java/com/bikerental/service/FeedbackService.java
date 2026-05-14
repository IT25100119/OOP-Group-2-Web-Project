package com.bikerental.service;

import com.bikerental.model.Feedback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * FeedbackService manages ride reviews and ratings.
 * Demonstrates Polymorphism: different display modes for users vs admins.
 */
@Service
public class FeedbackService {

    private static final String FEEDBACK_FILE = "feedback.txt";
    private static final DateTimeFormatter DTF =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Autowired
    private FileHandler fileHandler;

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    public boolean submitFeedback(String userId, String username, String rideId,
                                   int rating, String comment) {
        // One feedback per ride
        if (feedbackExistsForRide(rideId)) return false;

        String feedbackId = "FBK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String date = LocalDateTime.now().format(DTF);

        Feedback fb = new Feedback(feedbackId, userId, username, rideId,
                rating, comment, date, "VISIBLE");
        fileHandler.appendLine(FEEDBACK_FILE, fb.toFileString());
        return true;
    }

    // ─── READ ─────────────────────────────────────────────────────────────────────

    public List<Feedback> getAllFeedback() {
        List<String> lines = fileHandler.readLines(FEEDBACK_FILE);
        List<Feedback> list = new ArrayList<>();
        for (String line : lines) {
            Feedback f = Feedback.fromFileString(line);
            if (f != null) list.add(f);
        }
        return list;
    }

    /** Returns only VISIBLE feedback — for regular users. */
    public List<Feedback> getVisibleFeedback() {
        return getAllFeedback().stream()
                .filter(f -> "VISIBLE".equals(f.getStatus()))
                .collect(Collectors.toList());
    }

    public List<Feedback> getFeedbackByUser(String userId) {
        return getAllFeedback().stream()
                .filter(f -> f.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    public Feedback findById(String feedbackId) {
        String line = fileHandler.findById(FEEDBACK_FILE, feedbackId);
        return line != null ? Feedback.fromFileString(line) : null;
    }

    public boolean feedbackExistsForRide(String rideId) {
        return getAllFeedback().stream()
                .anyMatch(f -> f.getRideId().equals(rideId));
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    public boolean updateFeedback(String feedbackId, int rating, String comment) {
        Feedback fb = findById(feedbackId);
        if (fb == null) return false;
        fb.setRating(rating);
        fb.setComment(comment);
        return fileHandler.updateById(FEEDBACK_FILE, feedbackId, fb.toFileString());
    }

    /** Admin: hide inappropriate review */
    public boolean hideFeedback(String feedbackId) {
        Feedback fb = findById(feedbackId);
        if (fb == null) return false;
        fb.setStatus("HIDDEN");
        return fileHandler.updateById(FEEDBACK_FILE, feedbackId, fb.toFileString());
    }

    /** Admin: restore hidden review */
    public boolean showFeedback(String feedbackId) {
        Feedback fb = findById(feedbackId);
        if (fb == null) return false;
        fb.setStatus("VISIBLE");
        return fileHandler.updateById(FEEDBACK_FILE, feedbackId, fb.toFileString());
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    public boolean deleteFeedback(String feedbackId) {
        return fileHandler.deleteById(FEEDBACK_FILE, feedbackId);
    }

    // ─── STATS ───────────────────────────────────────────────────────────────────

    public double getAverageRating() {
        List<Feedback> visible = getVisibleFeedback();
        if (visible.isEmpty()) return 0.0;
        return visible.stream().mapToInt(Feedback::getRating).average().orElse(0.0);
    }
}
