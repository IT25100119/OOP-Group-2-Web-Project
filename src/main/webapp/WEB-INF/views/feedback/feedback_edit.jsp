<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Review — VeloRide</title>
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
<div class="container" style="padding-top:2rem; max-width:500px; padding-bottom:4rem;">
  <div class="page-header animate-in">
    <h2 class="page-title">Edit Review</h2>
    <p class="page-subtitle">Update your feedback for ride <code>${feedback.rideId}</code></p>
  </div>
  <div class="card animate-in-1">
    <form action="/feedback/edit" method="post">
      <input type="hidden" name="feedbackId" value="${feedback.feedbackId}"/>
      <div class="form-group" style="text-align:center;">
        <label class="form-label" style="display:block; margin-bottom:1rem;">Rating *</label>
        <div class="star-input" style="justify-content:center;">
          <input type="radio" name="rating" id="s5" value="5" ${feedback.rating==5?'checked':''}  required/><label for="s5">★</label>
          <input type="radio" name="rating" id="s4" value="4" ${feedback.rating==4?'checked':''}         /><label for="s4">★</label>
          <input type="radio" name="rating" id="s3" value="3" ${feedback.rating==3?'checked':''}         /><label for="s3">★</label>
          <input type="radio" name="rating" id="s2" value="2" ${feedback.rating==2?'checked':''}         /><label for="s2">★</label>
          <input type="radio" name="rating" id="s1" value="1" ${feedback.rating==1?'checked':''}         /><label for="s1">★</label>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Comment *</label>
        <textarea name="comment" class="form-control" required rows="4">${feedback.comment}</textarea>
      </div>
      <div class="d-flex gap-1">
        <button type="submit" class="btn btn-primary" style="flex:1;">Update Review</button>
        <a href="/user/dashboard" class="btn btn-ghost">Cancel</a>
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
