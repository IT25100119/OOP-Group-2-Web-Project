<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Stations — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/stations" class="active">Stations</a></li>
    <li><a href="/feedback">Reviews</a></li>
    <c:if test="${not empty sessionAdmin}">
      <li><a href="/admin/dashboard">Dashboard</a></li>
      <li><a href="/stations/add" class="btn btn-primary btn-sm"><i class="bi bi-plus"></i> Add Station</a></li>
    </c:if>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <div class="d-flex justify-between align-center mb-3 animate-in">
    <div>
      <h2>Docking Stations</h2>
      <p class="text-muted">Find your nearest pickup or drop-off point.</p>
    </div>
  </div>

  <form action="/stations" method="get" class="d-flex gap-1 mb-4 animate-in-1">
    <div class="search-bar" style="flex:1;">
      <i class="bi bi-search" style="color:var(--text-500);"></i>
      <input type="text" name="search" placeholder="Search by name or location…"
             value="${not empty search ? search : ''}"/>
    </div>
    <button type="submit" class="btn btn-primary">Search</button>
    <c:if test="${not empty search}"><a href="/stations" class="btn btn-ghost">Clear</a></c:if>
  </form>

  <div class="bikes-grid animate-in-2">
    <c:forEach var="st" items="${stations}" varStatus="idx">
    <div class="card reveal">
      <div style="font-size:2rem; margin-bottom:0.75rem;">📍</div>
      <div class="d-flex justify-between align-center mb-1">
        <h4>${st.name}</h4>
        <c:choose>
          <c:when test="${st.operationalStatus == 'OPEN'}"><span class="badge badge-open">Open</span></c:when>
          <c:when test="${st.operationalStatus == 'CLOSED'}"><span class="badge badge-closed">Closed</span></c:when>
          <c:otherwise><span class="badge badge-maintenance">Maintenance</span></c:otherwise>
        </c:choose>
      </div>
      <p class="text-muted" style="font-size:0.85rem; margin-bottom:0.75rem;">
        <i class="bi bi-geo-alt"></i> ${st.location}
      </p>
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:0.5rem; margin-bottom:1rem;">
        <div style="background:var(--bg-700); padding:0.6rem; border-radius:var(--radius-sm); text-align:center;">
          <div class="fw-bold text-accent">${st.currentBikes}</div>
          <div class="text-dim" style="font-size:0.75rem;">Bikes Here</div>
        </div>
        <div style="background:var(--bg-700); padding:0.6rem; border-radius:var(--radius-sm); text-align:center;">
          <div class="fw-bold">${st.maxCapacity}</div>
          <div class="text-dim" style="font-size:0.75rem;">Capacity</div>
        </div>
      </div>
      <div style="height:4px; background:var(--bg-700); border-radius:2px; overflow:hidden; margin-bottom:1rem;">
        <div style="height:100%; width:${st.maxCapacity > 0 ? (st.currentBikes * 100 / st.maxCapacity) : 0}%;
                    background:var(--accent); border-radius:2px; transition:width 0.5s ease;"></div>
      </div>
      <code class="text-dim" style="font-size:0.75rem;">${st.stationId}</code>
      <c:if test="${not empty sessionAdmin}">
        <div class="d-flex gap-1 mt-2">
          <a href="/stations/edit/${st.stationId}" class="btn btn-ghost btn-sm" style="flex:1;">Edit</a>
          <form action="/stations/delete" method="post" style="display:inline;">
            <input type="hidden" name="stationId" value="${st.stationId}"/>
            <button class="btn btn-danger btn-sm"
                    data-confirm="Remove this station permanently?">Delete</button>
          </form>
        </div>
      </c:if>
    </div>
    </c:forEach>
  </div>

  <c:if test="${empty stations}">
    <div class="card text-center" style="padding:4rem;">
      <div style="font-size:4rem; margin-bottom:1rem;">🗺️</div>
      <h3 class="text-muted">No stations found</h3>
    </div>
  </c:if>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
