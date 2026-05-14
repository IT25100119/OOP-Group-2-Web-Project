<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Leave a Review — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/user/dashboard">My Dashboard</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:520px; padding-bottom:4rem; text-align:center;">

  <div style="font-size:4rem; margin-bottom:1rem; animation:fadeInUp 0.4s ease;">⭐</div>
  <h2 class="animate-in">How was your ride?</h2>
  <p class="text-muted animate-in-1 mb-4">Share your experience to help other riders.</p>

  <div class="card animate-in-2" style="text-align:left;">
    <form action="/feedback/submit" method="post">
      <input type="hidden" name="rideId" value="${rideId}"/>

      <div class="form-group" style="text-align:center;">
        <label class="form-label" style="display:block; margin-bottom:1rem;">Your Rating *</label>
        <div class="star-input" style="justify-content:center;">
          <input type="radio" name="rating" id="s5" value="5" required/><label for="s5" title="5 stars">★</label>
          <input type="radio" name="rating" id="s4" value="4"/><label for="s4" title="4 stars">★</label>
          <input type="radio" name="rating" id="s3" value="3"/><label for="s3" title="3 stars">★</label>
          <input type="radio" name="rating" id="s2" value="2"/><label for="s2" title="2 stars">★</label>
          <input type="radio" name="rating" id="s1" value="1"/><label for="s1" title="1 star">★</label>
        </div>
        <div id="ratingValue" class="text-muted mt-2" style="font-size:0.85rem;">Click to rate</div>
      </div>

      <div class="form-group">
        <label class="form-label">Your Review *</label>
        <textarea name="comment" class="form-control" required rows="4"
                  placeholder="Tell us about your experience…" style="resize:vertical;"></textarea>
      </div>

      <div class="form-group">
        <div style="background:var(--bg-700); padding:0.75rem 1rem; border-radius:var(--radius-sm); font-size:0.82rem; color:var(--text-500);">
          Ride ID: <code>${rideId}</code>
        </div>
      </div>

      <div class="d-flex gap-1">
        <button type="submit" class="btn btn-primary" style="flex:1;">
          <i class="bi bi-send"></i> Submit Review
        </button>
        <a href="/user/dashboard" class="btn btn-ghost">Skip</a>
      </div>
    </form>
  </div>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
