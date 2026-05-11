<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Return Bike — VeloRide</title>
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
<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:580px;">

  <div class="page-header animate-in">
    <h2 class="page-title">Return Your Bike</h2>
    <p class="page-subtitle">End your ride and calculate your fare.</p>
  </div>

  <div class="card animate-in-1 mb-3" style="background:rgba(0,229,160,0.04); border-color:rgba(0,229,160,0.2);">
    <div class="d-flex align-center gap-2 mb-2">
      <span style="font-size:1.8rem;"><span class="live-dot"></span></span>
      <h4>Active Ride Details</h4>
    </div>
    <div style="display:grid; gap:0.65rem;">
      <div class="d-flex justify-between">
        <span class="text-muted">Ride ID</span>
        <code class="text-accent">${activeRide.rideId}</code>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Bike</span>
        <span>${not empty bike ? bike.model : activeRide.bikeId}
          <span class="badge ${not empty bike && bike.type=='ELECTRIC' ? 'badge-active' : ''}">
            ${not empty bike ? bike.type : ''}
          </span>
        </span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Started</span>
        <span>${activeRide.startTime}</span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Price Rate</span>
        <span class="text-accent">${not empty bike ? '$'.concat(String.valueOf(bike.pricePerHour)) : '—'}/hr</span>
      </div>
    </div>
  </div>

  <form action="/rides/return" method="post" class="card animate-in-2">
    <input type="hidden" name="rideId" value="${activeRide.rideId}"/>
    <h4 class="mb-3"><i class="bi bi-geo-alt-fill text-accent"></i> Return Station</h4>
    <div class="form-group">
      <label class="form-label">Select Drop-off Station *</label>
      <select name="endStationId" class="form-control" required>
        <option value="">Choose a return station…</option>
        <c:forEach var="st" items="${stations}">
          <option value="${st.stationId}">${st.name} — ${st.location}</option>
        </c:forEach>
      </select>
    </div>
    <div class="d-flex gap-1 mt-3">
      <button type="submit" class="btn btn-primary btn-lg" style="flex:1;">
        <i class="bi bi-stop-circle"></i> End Ride & Pay
      </button>
      <a href="/user/dashboard" class="btn btn-ghost btn-lg">Back</a>
    </div>
  </form>
</div>
</div>
<footer class="footer"><p>© 2025 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
