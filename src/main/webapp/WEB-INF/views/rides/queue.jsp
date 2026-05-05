<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Rental Queue — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/rides/queue" class="active">Ride Queue</a></li>
    <li><a href="/payments/admin">💳 Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <div class="page-header animate-in">
    <h2 class="page-title">Rental Queue Dashboard</h2>
    <p class="page-subtitle">
      <span class="live-dot"></span>
      Real-time ride queue — managed via Queue data structure (FIFO order)
    </p>
  </div>

  <%-- ── Active / Queued ───────────────────────────────────── --%>
  <h3 class="animate-in-1 mb-2">Active & Queued Rides</h3>
  <div class="card animate-in-2 mb-4">
    <c:choose>
      <c:when test="${empty queuedRides}">
        <div class="text-center" style="padding:3rem; color:var(--text-500);">
          <div style="font-size:3rem; margin-bottom:1rem;">📭</div>
          <p>Queue is empty — no active rides at the moment.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>#</th><th>Ride ID</th><th>User ID</th><th>Bike ID</th>
                <th>Start Time</th><th>Start Station</th><th>Status</th><th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="ride" items="${queuedRides}" varStatus="st">
              <tr>
                <td class="text-accent fw-bold">${st.index + 1}</td>
                <td><code style="font-size:0.78rem;">${ride.rideId}</code></td>
                <td><code style="font-size:0.78rem;">${ride.userId}</code></td>
                <td><code style="font-size:0.78rem;">${ride.bikeId}</code></td>
                <td>${ride.startTime}</td>
                <td><code style="font-size:0.78rem;">${ride.startStationId}</code></td>
                <td>
                  <c:choose>
                    <c:when test="${ride.status == 'ACTIVE'}">
                      <span class="badge badge-active"><span class="live-dot" style="width:5px;height:5px;margin-right:3px;"></span>Active</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-maintenance">Queued</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <form action="/rides/admin/delete" method="post" style="display:inline;">
                    <input type="hidden" name="rideId" value="${ride.rideId}"/>
                    <button class="btn btn-danger btn-sm"
                            data-confirm="Remove this ride from queue?">Remove</button>
                  </form>
                </td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- ── All Rides History ──────────────────────────────────── --%>
  <h3 class="animate-in-3 mb-2">Full Ride History</h3>
  <div class="card animate-in-4">
    <div class="table-wrapper">
      <c:choose>
        <c:when test="${empty allRides}">
          <div class="text-center" style="padding:2rem; color:var(--text-500);">
            <p>No ride records yet.</p>
          </div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>Ride ID</th><th>User</th><th>Bike</th><th>Start</th>
                <th>End</th><th>Duration</th><th>Fare</th><th>Status</th><th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="ride" items="${allRides}">
              <tr>
                <td><code style="font-size:0.75rem;">${ride.rideId}</code></td>
                <td><code style="font-size:0.75rem;">${ride.userId}</code></td>
                <td><code style="font-size:0.75rem;">${ride.bikeId}</code></td>
                <td style="font-size:0.82rem;">${ride.startTime}</td>
                <td style="font-size:0.82rem;">${not empty ride.endTime ? ride.endTime : '—'}</td>
                <td>${ride.durationHours > 0 ? String.format("%.1fh", ride.durationHours) : '—'}</td>
                <td class="text-accent">${ride.totalFare > 0 ? '$'.concat(String.format("%.2f", ride.totalFare)) : '—'}</td>
                <td>
                  <c:choose>
                    <c:when test="${ride.status=='ACTIVE'}">   <span class="badge badge-active">Active</span></c:when>
                    <c:when test="${ride.status=='COMPLETED'}"><span class="badge badge-completed">Done</span></c:when>
                    <c:when test="${ride.status=='CANCELLED'}"><span class="badge badge-cancelled">Cancelled</span></c:when>
                    <c:when test="${ride.status=='QUEUED'}">   <span class="badge badge-maintenance">Queued</span></c:when>
                    <c:otherwise><span class="badge">${ride.status}</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:if test="${ride.status=='COMPLETED' || ride.status=='CANCELLED'}">
                    <form action="/rides/admin/delete" method="post" style="display:inline;">
                      <input type="hidden" name="rideId" value="${ride.rideId}"/>
                      <button class="btn btn-ghost btn-sm"
                              data-confirm="Delete this ride record?">Delete</button>
                    </form>
                  </c:if>
                </td>
              </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

</div>
</div>
<footer class="footer"><p>© 2025 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
