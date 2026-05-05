<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Dashboard — VeloRide</title>
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
    <li><a href="/feedback">Reviews</a></li>
    <li><a href="/user/dashboard" class="active">My Dashboard</a></li>
    <li><a href="/payments/my"><i class="bi bi-credit-card"></i> My Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
  <div class="container" style="padding-top:2rem; padding-bottom:4rem;">

    <%-- ── Alerts ─────────────────────────────────────────── --%>
    <c:if test="${not empty error}">
      <div class="alert alert-error"><i class="bi bi-exclamation-circle"></i> ${error}</div>
    </c:if>

    <%-- ── Header ─────────────────────────────────────────── --%>
    <div class="d-flex justify-between align-center mb-4 animate-in">
      <div>
        <h2>Welcome back, <span class="text-accent">${user.username}</span></h2>
        <p class="text-muted">Manage your rides, profile, and reviews.</p>
      </div>
      <c:choose>
        <c:when test="${not empty activeRide}">
          <a href="/rides/return" class="btn btn-primary">
            <i class="bi bi-stop-circle"></i> End Active Ride
          </a>
        </c:when>
        <c:otherwise>
          <a href="/rides/rent" class="btn btn-primary">
            <i class="bi bi-bicycle"></i> Rent a Bike
          </a>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- ── Active Ride Banner ──────────────────────────────── --%>
    <c:if test="${not empty activeRide}">
    <div class="card animate-in-1" style="border-color:var(--accent); margin-bottom:1.5rem; background:rgba(0,229,160,0.05);">
      <div class="d-flex justify-between align-center">
        <div class="d-flex align-center gap-2">
          <div style="font-size:2rem;">🚴</div>
          <div>
            <div class="fw-bold"><span class="live-dot"></span>Active Ride</div>
            <div class="text-muted" style="font-size:0.85rem;">
              Ride ID: ${activeRide.rideId} &nbsp;|&nbsp; Started: ${activeRide.startTime}
            </div>
          </div>
        </div>
        <div class="d-flex gap-1">
          <a href="/rides/return" class="btn btn-primary btn-sm">Return Bike</a>
          <form action="/rides/cancel" method="post" style="display:inline;">
            <input type="hidden" name="rideId" value="${activeRide.rideId}"/>
            <button type="submit" class="btn btn-danger btn-sm"
                    data-confirm="Cancel this ride?">Cancel</button>
          </form>
        </div>
      </div>
    </div>
    </c:if>

    <%-- ── Stats ──────────────────────────────────────────── --%>
    <div class="stats-grid animate-in-2">
      <div class="card card-stat">
        <div class="stat-value">${myRides.size()}</div>
        <div class="stat-label"><i class="bi bi-bicycle"></i> Total Rides</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${availBikes}</div>
        <div class="stat-label"><i class="bi bi-check-circle"></i> Bikes Available</div>
      </div>
      <div class="card card-stat">
        <div class="stat-value">${myFeedback.size()}</div>
        <div class="stat-label"><i class="bi bi-star"></i> Reviews Given</div>
      </div>
    </div>

    <%-- ── Main Content Tabs ───────────────────────────────── --%>
    <div data-tabs class="animate-in-3">
      <div class="tab-nav">
        <button class="tab-btn active" data-tab-target="rides">My Rides</button>
        <button class="tab-btn" data-tab-target="profile">Profile</button>
        <button class="tab-btn" data-tab-target="reviews">My Reviews</button>
      </div>

      <%-- ── Rides Tab ─────────────────────────────────────── --%>
      <div data-tab-content="rides">
        <div class="card">
          <div class="d-flex justify-between align-center mb-3">
            <h4>Ride History</h4>
            <a href="/rides/rent" class="btn btn-primary btn-sm"><i class="bi bi-plus"></i> New Ride</a>
          </div>
          <c:choose>
            <c:when test="${empty myRides}">
              <div class="text-center" style="padding:3rem; color:var(--text-500);">
                <div style="font-size:3rem; margin-bottom:1rem;">🚲</div>
                <p>No rides yet. <a href="/rides/rent">Rent your first bike!</a></p>
              </div>
            </c:when>
            <c:otherwise>
              <div class="table-wrapper">
                <table>
                  <thead>
                    <tr>
                      <th>Ride ID</th><th>Bike ID</th><th>Start Time</th>
                      <th>End Time</th><th>Duration</th><th>Fare</th><th>Status</th><th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="ride" items="${myRides}">
                    <tr>
                      <td><code style="font-size:0.78rem;">${ride.rideId}</code></td>
                      <td><code style="font-size:0.78rem;">${ride.bikeId}</code></td>
                      <td>${ride.startTime}</td>
                      <td>${not empty ride.endTime ? ride.endTime : '—'}</td>
                      <td>${ride.durationHours > 0 ? String.format("%.1f", ride.durationHours).concat("h") : '—'}</td>
                      <td class="text-accent">${ride.totalFare > 0 ? '$'.concat(String.format("%.2f", ride.totalFare)) : '—'}</td>
                      <td>
                        <c:choose>
                          <c:when test="${ride.status == 'ACTIVE'}"><span class="badge badge-active">Active</span></c:when>
                          <c:when test="${ride.status == 'COMPLETED'}"><span class="badge badge-completed">Done</span></c:when>
                          <c:when test="${ride.status == 'CANCELLED'}"><span class="badge badge-cancelled">Cancelled</span></c:when>
                          <c:otherwise><span class="badge">${ride.status}</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:if test="${ride.status == 'COMPLETED'}">
                          <a href="/feedback/submit/${ride.rideId}" class="btn btn-ghost btn-sm">Review</a>
                        </c:if>
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

      <%-- ── Profile Tab ────────────────────────────────────── --%>
      <div data-tab-content="profile">
        <div class="two-col" style="gap:1.5rem;">
          <div class="card">
            <h4 class="mb-3">Edit Profile</h4>
            <form action="/user/profile/update" method="post">
              <input type="hidden" name="userId" value="${user.userId}"/>
              <div class="form-group">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" value="${user.username}" disabled/>
              </div>
              <div class="form-group">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="${user.email}" required/>
              </div>
              <div class="form-group">
                <label class="form-label">Phone</label>
                <input type="tel" name="phone" class="form-control" value="${user.phone}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Payment Method</label>
                <select name="paymentMethod" class="form-control">
                  <option value="CASH"       ${user.paymentMethod=='CASH'       ? 'selected':''}> Cash</option>
                  <option value="VISA"       ${user.paymentMethod=='VISA'       ? 'selected':''}> Visa</option>
                  <option value="MASTERCARD" ${user.paymentMethod=='MASTERCARD' ? 'selected':''}> Mastercard</option>
                  <option value="PAYPAL"     ${user.paymentMethod=='PAYPAL'     ? 'selected':''}> PayPal</option>
                </select>
              </div>
              <button type="submit" class="btn btn-primary w-100">Save Changes</button>
            </form>
          </div>

          <div class="card">
            <h4 class="mb-3">Change Password</h4>
            <form action="/user/profile/password" method="post">
              <input type="hidden" name="userId" value="${user.userId}"/>
              <div class="form-group">
                <label class="form-label">Current Password</label>
                <input type="password" name="oldPassword" class="form-control" required/>
              </div>
              <div class="form-group">
                <label class="form-label">New Password</label>
                <input type="password" name="newPassword" class="form-control" required minlength="6"/>
              </div>
              <button type="submit" class="btn btn-outline w-100 mb-2">Update Password</button>
            </form>
            <div class="section-divider"></div>
            <h4 class="mb-2" style="color:var(--red);">Danger Zone</h4>
            <p class="text-muted mb-2" style="font-size:0.85rem;">Permanently delete your account. This cannot be undone.</p>
            <form action="/user/delete" method="post">
              <input type="hidden" name="userId" value="${user.userId}"/>
              <button type="submit" class="btn btn-danger w-100"
                      data-confirm="Are you sure you want to delete your account? This is permanent!">
                Delete My Account
              </button>
            </form>
          </div>
        </div>
      </div>

      <%-- ── Reviews Tab ────────────────────────────────────── --%>
      <div data-tab-content="reviews">
        <div class="card">
          <h4 class="mb-3">My Reviews</h4>
          <c:choose>
            <c:when test="${empty myFeedback}">
              <div class="text-center" style="padding:2rem; color:var(--text-500);">
                <p>No reviews yet. Complete a ride and leave feedback!</p>
              </div>
            </c:when>
            <c:otherwise>
              <c:forEach var="fb" items="${myFeedback}">
              <div class="ride-item mb-2">
                <div class="ride-icon">⭐</div>
                <div class="ride-details">
                  <div class="ride-id">${fb.feedbackId} | ${fb.submittedDate}</div>
                  <div class="ride-info">
                    <c:forEach begin="1" end="${fb.rating}" var="s">⭐</c:forEach>
                    — "${fb.comment}"
                  </div>
                </div>
                <a href="/feedback/edit/${fb.feedbackId}" class="btn btn-ghost btn-sm">Edit</a>
              </div>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

    </div><%-- /data-tabs --%>
  </div>
</div>

<footer class="footer"><p>© 2025 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
