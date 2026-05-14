<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Rider Reviews — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/stations">Stations</a></li>
    <li><a href="/feedback" class="active">Reviews</a></li>
    <c:choose>
      <c:when test="${not empty sessionAdmin}"><li><a href="/admin/dashboard">Dashboard</a></li></c:when>
      <c:when test="${not empty sessionUser}"><li><a href="/user/dashboard">My Dashboard</a></li></c:when>
    </c:choose>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>Rider Reviews</h2>
      <p class="text-muted">Real feedback from real riders — Average rating: <span class="text-accent fw-bold">${avgRating} ⭐</span></p>
    </div>
    <c:if test="${not empty sessionAdmin}">
      <a href="/feedback/admin/moderate" class="btn btn-ghost btn-sm">
        <i class="bi bi-shield-check"></i> Moderate
      </a>
    </c:if>
  </div>

  <c:choose>
    <c:when test="${empty feedbackList}">
      <div class="card text-center" style="padding:4rem;">
        <div style="font-size:4rem; margin-bottom:1rem;">💬</div>
        <h3 class="text-muted">No reviews yet</h3>
        <p class="text-dim">Be the first to leave a review after a ride!</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="bikes-grid">
        <c:forEach var="fb" items="${feedbackList}" varStatus="st">
        <div class="card reveal" style="animation-delay: ${st.index * 50}ms;">
          <div class="d-flex align-center gap-2 mb-2">
            <div style="width:38px; height:38px; background:var(--bg-700); border-radius:50%;
                        display:flex; align-items:center; justify-content:center; font-size:1.1rem;">
              ${fb.username.substring(0,1).toUpperCase()}
            </div>
            <div>
              <div class="fw-bold" style="font-size:0.9rem;">${fb.username}</div>
              <div class="text-dim" style="font-size:0.75rem;">${fb.submittedDate}</div>
            </div>
          </div>
          <div class="stars mb-2" style="font-size:1.1rem;">
            <c:forEach begin="1" end="${fb.rating}" var="s">★</c:forEach>
            <c:forEach begin="${fb.rating + 1}" end="5" var="s">
              <span style="color:var(--bg-600);">★</span>
            </c:forEach>
          </div>
          <p style="color:var(--text-300); font-size:0.9rem; line-height:1.6;">"${fb.comment}"</p>
          <div class="text-dim" style="font-size:0.75rem; margin-top:0.75rem;">Ride: <code>${fb.rideId}</code></div>
        </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
