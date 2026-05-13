<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Add Station — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/stations" class="active">Stations</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:580px; padding-bottom:4rem;">
  <div class="page-header animate-in">
    <h2 class="page-title">Add New Station</h2>
    <p class="page-subtitle">Register a new docking station or pickup zone.</p>
  </div>
  <c:if test="${not empty success}"><div class="alert alert-success"><i class="bi bi-check-circle"></i> ${success}</div></c:if>
  <div class="card animate-in-1">
    <form action="/stations/add" method="post">
      <div class="form-group">
        <label class="form-label">Station Name *</label>
        <input type="text" name="name" class="form-control" required placeholder="e.g. City Center Hub"/>
      </div>
      <div class="form-group">
        <label class="form-label">Location / Address *</label>
        <input type="text" name="location" class="form-control" required placeholder="e.g. Main Street, Downtown"/>
      </div>
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Max Bike Capacity *</label>
          <input type="number" name="maxCapacity" class="form-control" required min="1" max="100" placeholder="20"/>
        </div>
        <div class="form-group"></div>
      </div>
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Latitude (optional)</label>
          <input type="number" name="latitude" class="form-control" step="0.0001" placeholder="7.2906"/>
        </div>
        <div class="form-group">
          <label class="form-label">Longitude (optional)</label>
          <input type="number" name="longitude" class="form-control" step="0.0001" placeholder="80.6337"/>
        </div>
      </div>
      <div class="d-flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary" style="flex:1;">
          <i class="bi bi-geo-alt-fill"></i> Add Station
        </button>
        <a href="/stations" class="btn btn-ghost">Cancel</a>
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
