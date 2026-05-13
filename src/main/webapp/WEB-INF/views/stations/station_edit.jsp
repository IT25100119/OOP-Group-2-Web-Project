<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Station — VeloRide Admin</title>
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
    <h2 class="page-title">Edit Station</h2>
    <p class="page-subtitle">Update details for <code>${station.stationId}</code></p>
  </div>
  <div class="card animate-in-1">
    <form action="/stations/edit" method="post">
      <input type="hidden" name="stationId" value="${station.stationId}"/>
      <div class="form-group">
        <label class="form-label">Station Name *</label>
        <input type="text" name="name" class="form-control" value="${station.name}" required/>
      </div>
      <div class="form-group">
        <label class="form-label">Location *</label>
        <input type="text" name="location" class="form-control" value="${station.location}" required/>
      </div>
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Max Capacity</label>
          <input type="number" name="maxCapacity" class="form-control" value="${station.maxCapacity}" min="1"/>
        </div>
        <div class="form-group">
          <label class="form-label">Status</label>
          <select name="operationalStatus" class="form-control">
            <option value="OPEN"        ${station.operationalStatus=='OPEN'        ? 'selected':''}>Open</option>
            <option value="CLOSED"      ${station.operationalStatus=='CLOSED'      ? 'selected':''}>Closed</option>
            <option value="MAINTENANCE" ${station.operationalStatus=='MAINTENANCE' ? 'selected':''}>Maintenance</option>
          </select>
        </div>
      </div>
      <div class="d-flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary" style="flex:1;">Save Changes</button>
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
