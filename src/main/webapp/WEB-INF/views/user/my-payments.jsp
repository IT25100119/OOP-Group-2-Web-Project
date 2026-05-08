<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Payments — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/user/dashboard">Dashboard</a></li>
    <li><a href="/payments/my" class="active">Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>My Payments</h2>
      <p class="text-muted">Your full transaction history.</p>
    </div>
    <div class="card card-stat" style="padding:1rem 1.5rem; text-align:center;">
      <div class="stat-value text-accent">$${totalSpent}</div>
      <div class="stat-label">Total Spent</div>
    </div>
  </div>

  <div class="card animate-in-1">
    <c:choose>
      <c:when test="${empty payments}">
        <div class="text-center" style="padding:3rem; color:var(--text-500);">
          <div style="font-size:3rem; margin-bottom:1rem;">💳</div>
          <p>No payment history yet. Complete a ride to see transactions here.</p>
          <a href="/rides/rent" class="btn btn-primary mt-2">Rent a Bike</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr><th>Payment ID</th><th>Ride ID</th><th>Amount</th><th>Method</th><th>Status</th><th>Date</th></tr>
            </thead>
            <tbody>
              <c:forEach var="pay" items="${payments}">
              <tr>
                <td><code style="font-size:0.75rem; color:var(--accent);">${pay.paymentId}</code></td>
                <td><code style="font-size:0.75rem;">${pay.rideId}</code></td>
                <td>
                  <span style="font-family:var(--font-display); font-size:1.05rem;
                    color:${pay.status=='REFUNDED'?'var(--orange)':pay.status=='FAILED'?'var(--red)':'var(--accent)'};">
                    $<fmt:formatNumber value="${pay.amount}" pattern="#,##0.00"/>
                  </span>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${pay.paymentMethod=='VISA'}">💳 Visa</c:when>
                    <c:when test="${pay.paymentMethod=='MASTERCARD'}">💳 Mastercard</c:when>
                    <c:when test="${pay.paymentMethod=='PAYPAL'}">🅿️ PayPal</c:when>
                    <c:otherwise>💵 Cash</c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${pay.status=='COMPLETED'}"><span class="badge badge-available">Completed</span></c:when>
                    <c:when test="${pay.status=='REFUNDED'}"> <span class="badge badge-inuse">Refunded</span></c:when>
                    <c:when test="${pay.status=='FAILED'}">   <span class="badge badge-cancelled">Failed</span></c:when>
                    <c:otherwise><span class="badge badge-maintenance">Pending</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="font-size:0.82rem;">${pay.transactionDate}</td>
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
<footer class="footer"><p>© 2025 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
