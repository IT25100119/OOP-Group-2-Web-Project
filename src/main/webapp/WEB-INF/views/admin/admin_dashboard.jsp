<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard" class="active">Dashboard</a></li>
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/stations">Stations</a></li>
    <li><a href="/user/admin/list">Users</a></li>
    <li><a href="/rides/queue">Ride Queue</a></li>
    <li><a href="/payments/admin">Payments</a></li>
    <li><a href="/feedback/admin/moderate">Feedback</a></li>
    <li><a href="/admin/list">Admins</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
  <div class="container" style="padding-top:2rem; padding-bottom:4rem;">

    <%-- ── Header ─────────────────────────────────────────── --%>
    <div class="d-flex justify-between align-center mb-4 animate-in">
      <div>
        <h2>Admin Dashboard</h2>
        <p class="text-muted">Welcome, <span class="text-accent">${admin.username}</span>
          <span class="badge badge-admin ms-1">${admin.adminLevel}</span></p>
      </div>
      <div class="d-flex gap-1">
        <a href="/bikes/add" class="btn btn-ghost btn-sm"><i class="bi bi-plus-circle"></i> Add Bike</a>
        <a href="/stations/add" class="btn btn-ghost btn-sm"><i class="bi bi-geo-alt"></i> Add Station</a>
        <a href="/admin/register" class="btn btn-primary btn-sm"><i class="bi bi-person-plus"></i> New Admin</a>
      </div>
    </div>

    <%-- ── Stats Grid ──────────────────────────────────────── --%>
    <div class="stats-grid stagger animate-in-1">
      <div class="card card-stat">
        <div class="stat-value">${totalUsers}</div>
        <div class="stat-label"><i class="bi bi-people"></i> Total Riders</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${totalBikes}</div>
        <div class="stat-label"><i class="bi bi-bicycle"></i> Total Bikes</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${availBikes}</div>
        <div class="stat-label"><i class="bi bi-check-circle"></i> Available</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${activeRides}</div>
        <div class="stat-label"><i class="bi bi-activity"></i> Active Rides</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">₨<fmt:formatNumber value="${totalRevenue * 320.34}" pattern="#,##0"/></div>
        <div class="stat-label"><i class="bi bi-cash-coin"></i> Total Revenue</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${totalStations}</div>
        <div class="stat-label"><i class="bi bi-geo-alt"></i> Stations</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${avgRating}<small>/5</small></div>
        <div class="stat-label"><i class="bi bi-star-fill"></i> Avg Rating</div>
      </div>
      <div class="card card-stat animated-border">
        <div class="stat-value text-accent">₨<fmt:formatNumber value="${totalPayRevenue * 320.34}" pattern="#,##0"/></div>
        <div class="stat-label"><i class="bi bi-credit-card"></i> Pay Revenue</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value text-orange">${pendingPayments}</div>
        <div class="stat-label"><i class="bi bi-hourglass-split"></i> Pending Pays</div>
      </div>
    </div>

    <%-- ── Quick Actions ───────────────────────────────────── --%>
    <h3 class="animate-in-2" style="margin-bottom:1rem;">Quick Actions</h3>
    <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:1.1rem; margin-bottom:2rem;" class="animate-in-3 stagger">
      <a href="/bikes" class="card card-hover-lift" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">🚲</div>
        <div class="fw-bold mb-1">Manage Bikes</div>
        <div class="text-muted" style="font-size:0.8rem;">Add, edit, or remove bikes</div>
      </a>
      <a href="/rides/queue" class="card card-hover-lift card-gradient-border" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">📋</div>
        <div class="fw-bold mb-1">Ride Queue</div>
        <div class="text-muted" style="font-size:0.8rem;">View active rental queue</div>
      </a>
      <a href="/payments/admin" class="card card-hover-lift" style="text-decoration:none; display:block; padding:1.4rem; text-align:center; border-color:rgba(0,229,160,0.2);">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">💳</div>
        <div class="fw-bold mb-1">Payments</div>
        <div class="text-muted" style="font-size:0.8rem;">Revenue, refunds, analytics</div>
      </a>
      <a href="/user/admin/list" class="card card-hover-lift" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">👥</div>
        <div class="fw-bold mb-1">Manage Users</div>
        <div class="text-muted" style="font-size:0.8rem;">Search &amp; manage riders</div>
      </a>
      <a href="/stations" class="card card-hover-lift" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">📍</div>
        <div class="fw-bold mb-1">Stations</div>
        <div class="text-muted" style="font-size:0.8rem;">Manage docking stations</div>
      </a>
      <a href="/admin/transactions" class="card card-hover-lift animated-border" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">📊</div>
        <div class="fw-bold mb-1">Transaction Log</div>
        <div class="text-muted" style="font-size:0.8rem;">Full payment audit trail</div>
      </a>
      <a href="/feedback/admin/moderate" class="card card-hover-lift" style="text-decoration:none; display:block; padding:1.4rem; text-align:center;">
        <div style="font-size:2.2rem; margin-bottom:0.6rem;" class="feature-icon">💬</div>
        <div class="fw-bold mb-1">Feedback</div>
        <div class="text-muted" style="font-size:0.8rem;">Moderate user reviews</div>
      </a>
    </div>

    <%-- ── Recent Rides ─────────────────────────────────────── --%>
    <div class="card animate-in-4">
      <div class="d-flex justify-between align-center mb-3">
        <h4>Recent Ride Activity</h4>
        <a href="/rides/queue" class="btn btn-ghost btn-sm">View All</a>
      </div>
      <c:choose>
        <c:when test="${empty recentRides}">
          <div class="text-center" style="padding:2rem; color:var(--text-500);">
            <p>No ride data yet.</p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="table-wrapper">
            <table>
              <thead>
                <tr><th>Ride ID</th><th>User ID</th><th>Bike ID</th><th>Start</th><th>Fare</th><th>Status</th></tr>
              </thead>
              <tbody>
                <c:forEach var="ride" items="${recentRides}">
                <tr>
                  <td><code style="font-size:0.78rem;">${ride.rideId}</code></td>
                  <td><code style="font-size:0.78rem;">${ride.userId}</code></td>
                  <td><code style="font-size:0.78rem;">${ride.bikeId}</code></td>
                  <td>${ride.startTime}</td>
                  <td class="text-accent">${ride.totalFare > 0 ? '₨'.concat(String.format("%.0f", ride.totalFare * 320.34)) : '—'}</td>
                  <td>
                    <c:choose>
                      <c:when test="${ride.status == 'ACTIVE'}"><span class="badge badge-active">Active</span></c:when>
                      <c:when test="${ride.status == 'COMPLETED'}"><span class="badge badge-completed">Done</span></c:when>
                      <c:when test="${ride.status == 'CANCELLED'}"><span class="badge badge-cancelled">Cancelled</span></c:when>
                      <c:when test="${ride.status == 'QUEUED'}"><span class="badge badge-maintenance">Queued</span></c:when>
                      <c:otherwise><span class="badge">${ride.status}</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>


    <%-- ── Bike Fleet ───────────────────────────────────────── --%>
    <div class="card animate-in-4" style="margin-top:2rem;">
      <div class="d-flex justify-between align-center mb-3">
        <h4><i class="bi bi-bicycle" style="color:var(--accent); margin-right:0.5rem;"></i>Bike Fleet</h4>
        <div class="d-flex gap-1">
          <a href="/bikes/add" class="btn btn-ghost btn-sm"><i class="bi bi-plus-circle"></i> Add Bike</a>
          <a href="/bikes" class="btn btn-outline btn-sm">View All</a>
        </div>
      </div>
      <c:choose>
        <c:when test="${empty allBikes}">
          <div class="text-center" style="padding:2rem; color:var(--text-500);">
            <p>No bikes in the fleet yet.</p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>Bike ID</th>
                  <th>Model</th>
                  <th>Type</th>
                  <th>Status</th>
                  <th>Station</th>
                  <th>Price/hr</th>
                  <th style="text-align:center;">Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="bike" items="${allBikes}">
                <tr>
                  <td><code style="font-size:0.78rem;">${bike.bikeId}</code></td>
                  <td>${bike.model}</td>
                  <td>
                    <c:choose>
                      <c:when test="${bike.type == 'ELECTRIC'}">
                        <span class="badge badge-active"><i class="bi bi-lightning-fill"></i> Electric</span>
                      </c:when>
                      <c:when test="${bike.type == 'MOTO'}">
                        <span class="badge" style="background:rgba(255,107,53,0.15); color:#ff6b35; border-color:rgba(255,107,53,0.3);"><i class="bi bi-motorcycle"></i> Moto</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge" style="background:rgba(78,168,222,0.15); color:var(--blue); border-color:rgba(78,168,222,0.3);"><i class="bi bi-bicycle"></i> Standard</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <c:choose>
                      <c:when test="${bike.status == 'AVAILABLE'}"><span class="badge badge-active">Available</span></c:when>
                      <c:when test="${bike.status == 'IN_USE'}"><span class="badge badge-completed">In Use</span></c:when>
                      <c:when test="${bike.status == 'MAINTENANCE'}"><span class="badge badge-maintenance">Maintenance</span></c:when>
                      <c:otherwise><span class="badge">${bike.status}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td><code style="font-size:0.78rem;">${bike.stationId}</code></td>
                  <td class="text-accent">₨<fmt:formatNumber value="${bike.pricePerHour * 320.34}" pattern="#,##0"/>/hr</td>
                  <td style="text-align:center;">
                    <div class="d-flex gap-1" style="justify-content:center;">
                      <a href="/bikes/edit/${bike.bikeId}"
                         class="btn btn-outline btn-sm"
                         style="border-color:rgba(0,229,160,0.35); color:var(--accent); padding:0.3rem 0.75rem;">
                        <i class="bi bi-pencil-fill"></i> Edit
                      </a>
                      <form action="/bikes/delete" method="post" style="margin:0;">
                        <input type="hidden" name="bikeId" value="${bike.bikeId}"/>
                        <input type="hidden" name="redirectTo" value="/"/>
                        <button class="btn btn-danger btn-sm" style="padding:0.3rem 0.75rem;"
                                data-confirm="Remove bike ${bike.bikeId}?">
                          <i class="bi bi-trash"></i>
                        </button>
                      </form>
                    </div>
                  </td>
                </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin Panel</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
