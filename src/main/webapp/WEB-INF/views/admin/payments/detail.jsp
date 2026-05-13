<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payment ${payment.paymentId} — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .amount-hero {
      text-align: center; padding: 2.5rem 1rem;
      background: var(--bg-700); border-radius: 14px;
      margin-bottom: 1.5rem; position: relative; overflow: hidden;
    }
    .amount-hero::before {
      content:''; position:absolute; inset:0;
      background: radial-gradient(ellipse 60% 60% at 50% 100%,
        rgba(0,229,160,0.1) 0%, transparent 70%);
    }
    .amount-big {
      font-family: var(--font-display);
      font-size: 4rem; line-height: 1;
      position: relative; z-index: 1;
    }
    .detail-row {
      display: flex; justify-content: space-between;
      align-items: center; padding: 0.85rem 0;
      border-bottom: 1px solid var(--border);
      font-size: 0.9rem;
    }
    .detail-row:last-child { border-bottom: none; }
    .detail-key { color: var(--text-300); font-size: 0.82rem; }
    .action-bar {
      display: flex; gap: 0.75rem; flex-wrap: wrap;
      padding: 1.25rem;
      background: var(--bg-700); border-radius: 12px;
      margin-top: 1.5rem;
    }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/payments/admin" class="active">Payments</a></li>
    <li><a href="/admin/transactions">Tx Log</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:720px; padding-bottom:4rem;">

  <%-- Breadcrumb --%>
  <div class="text-muted animate-in" style="font-size:0.85rem; margin-bottom:1.5rem;">
    <a href="/payments/admin" class="text-accent">← Payments</a>
    &nbsp;/&nbsp; ${payment.paymentId}
  </div>

  <%-- Amount hero --%>
  <div class="amount-hero animate-in-1">
    <div class="text-muted" style="font-size:0.82rem; text-transform:uppercase; letter-spacing:-0.03em; margin-bottom:0.5rem;">
      Transaction Amount
    </div>
    <div class="amount-big
      ${payment.status=='REFUNDED' ? 'text-orange' :
        payment.status=='FAILED'   ? 'text-red'    : 'text-accent'}">
      ₨<fmt:formatNumber value="${payment.amount * 320.34}" pattern="#,##0"/>
    </div>
    <div style="margin-top:0.75rem;">
      <c:choose>
        <c:when test="${payment.status=='COMPLETED'}"><span class="badge badge-available" style="font-size:0.85rem; padding:6px 16px;">✅ Completed</span></c:when>
        <c:when test="${payment.status=='REFUNDED'}"> <span class="badge badge-inuse"     style="font-size:0.85rem; padding:6px 16px;">↩️ Refunded</span></c:when>
        <c:when test="${payment.status=='FAILED'}">   <span class="badge badge-cancelled" style="font-size:0.85rem; padding:6px 16px;">❌ Failed</span></c:when>
        <c:when test="${payment.status=='PENDING'}">  <span class="badge badge-maintenance" style="font-size:0.85rem; padding:6px 16px;">⏳ Pending</span></c:when>
      </c:choose>
    </div>
  </div>

  <div class="two-col animate-in-2" style="gap:1.25rem;">

    <%-- Transaction details --%>
    <div class="card">
      <h4 class="mb-2"><i class="bi bi-receipt text-accent"></i> Transaction Details</h4>
      <div class="detail-row">
        <span class="detail-key">Payment ID</span>
        <code style="font-size:0.8rem; color:var(--accent);">${payment.paymentId}</code>
      </div>
      <div class="detail-row">
        <span class="detail-key">Ride ID</span>
        <code style="font-size:0.8rem;">${payment.rideId}</code>
      </div>
      <div class="detail-row">
        <span class="detail-key">Date</span>
        <span>${payment.transactionDate}</span>
      </div>
      <div class="detail-row">
        <span class="detail-key">Payment Method</span>
        <span>
          <c:choose>
            <c:when test="${payment.paymentMethod=='VISA'}">💳 Visa Card</c:when>
            <c:when test="${payment.paymentMethod=='MASTERCARD'}">💳 Mastercard</c:when>
            <c:when test="${payment.paymentMethod=='PAYPAL'}">🅿️ PayPal</c:when>
            <c:otherwise>💵 Cash</c:otherwise>
          </c:choose>
        </span>
      </div>
      <div class="detail-row">
        <span class="detail-key">Notes</span>
        <span class="text-muted" style="font-size:0.82rem; text-align:right; max-width:55%;">${payment.notes}</span>
      </div>
    </div>

    <%-- User details --%>
    <div class="card">
      <h4 class="mb-2"><i class="bi bi-person-circle text-blue"></i> Rider Info</h4>
      <div class="detail-row">
        <span class="detail-key">Username</span>
        <span class="fw-bold">${payment.username}</span>
      </div>
      <div class="detail-row">
        <span class="detail-key">User ID</span>
        <code style="font-size:0.8rem;">${payment.userId}</code>
      </div>
      <c:if test="${not empty user}">
        <div class="detail-row">
          <span class="detail-key">Email</span>
          <span>${user.email}</span>
        </div>
        <div class="detail-row">
          <span class="detail-key">Phone</span>
          <span>${user.phone}</span>
        </div>
        <div class="detail-row">
          <span class="detail-key">Default Payment</span>
          <span>${user.paymentMethod}</span>
        </div>
      </c:if>
    </div>
  </div>

  <%-- Transaction history --%>
  <div class="card animate-in-3" style="margin-bottom:1rem;">
    <h4 class="mb-3"><i class="bi bi-clock-history text-accent"></i> Transaction History</h4>
    <c:choose>
      <c:when test="${empty txHistory}">
        <p class="text-muted" style="font-size:.85rem;">No transaction records for this payment yet.</p>
      </c:when>
      <c:otherwise>
        <div style="display:flex; flex-direction:column; gap:.6rem;">
          <c:forEach var="tx" items="${txHistory}">
          <div style="display:flex; align-items:flex-start; gap:.85rem; padding:.75rem;
                      background:var(--bg-700); border-radius:10px; border:1px solid var(--border);">
            <%-- Action dot --%>
            <div style="width:10px; height:10px; border-radius:50%; flex-shrink:0; margin-top:5px;
              background:${tx.action=='REFUNDED'?'var(--orange)':tx.action=='FAILED'?'var(--red)':tx.action=='EDITED'?'var(--blue)':'var(--accent)'};
              box-shadow:0 0 6px ${tx.action=='REFUNDED'?'var(--orange)':tx.action=='FAILED'?'var(--red)':tx.action=='EDITED'?'var(--blue)':'var(--accent)'};">
            </div>
            <div style="flex:1;">
              <div style="display:flex; justify-content:space-between; margin-bottom:2px;">
                <span style="font-weight:600; font-size:.85rem; color:${tx.action=='REFUNDED'?'var(--orange)':tx.action=='FAILED'?'var(--red)':tx.action=='EDITED'?'var(--blue)':'var(--accent)'};">
                  ${tx.action}
                </span>
                <span class="text-dim" style="font-size:.72rem;">${tx.timestamp}</span>
              </div>
              <div class="text-muted" style="font-size:.78rem;">${tx.notes}</div>
              <div style="font-size:.72rem; margin-top:3px; color:var(--text-500);">
                By:
                <c:choose>
                  <c:when test="${not empty tx.adminId}">
                    <span style="color:var(--orange);">⚙ ${tx.adminName}</span>
                  </c:when>
                  <c:otherwise>
                    <span>🤖 System</span>
                  </c:otherwise>
                </c:choose>
                &nbsp;|&nbsp; ${tx.txId}
                <c:if test="${tx.previousStatus ne tx.newStatus and not empty tx.previousStatus}">
                  &nbsp;|&nbsp; <span style="color:var(--text-500);">${tx.previousStatus}</span>
                  → <span style="color:var(--accent);">${tx.newStatus}</span>
                </c:if>
              </div>
            </div>
          </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- Action bar --%>
  <div class="action-bar animate-in-3">
    <a href="/payments/admin/edit/${payment.paymentId}" class="btn btn-ghost">
      <i class="bi bi-pencil"></i> Edit Payment
    </a>
    <c:if test="${payment.status=='COMPLETED'}">
      <form action="/payments/admin/refund" method="post" style="display:inline;">
        <input type="hidden" name="paymentId" value="${payment.paymentId}"/>
        <button class="btn btn-outline" style="border-color:var(--orange); color:var(--orange);"
                data-confirm="Issue a refund of ₨${payment.amount * 320.34}?">
          <i class="bi bi-arrow-counterclockwise"></i> Issue Refund
        </button>
      </form>
    </c:if>
    <c:if test="${payment.status=='PENDING' || payment.status=='FAILED'}">
      <form action="/payments/admin/complete" method="post" style="display:inline;">
        <input type="hidden" name="paymentId" value="${payment.paymentId}"/>
        <button class="btn btn-primary" data-confirm="Mark this payment as completed?">
          <i class="bi bi-check-circle"></i> Mark Completed
        </button>
      </form>
    </c:if>
    <c:if test="${payment.status=='COMPLETED' || payment.status=='PENDING'}">
      <form action="/payments/admin/fail" method="post" style="display:inline;">
        <input type="hidden" name="paymentId" value="${payment.paymentId}"/>
        <button class="btn btn-ghost" style="color:var(--red);"
                data-confirm="Mark this payment as FAILED?">
          <i class="bi bi-x-circle"></i> Mark Failed
        </button>
      </form>
    </c:if>
    <div style="flex:1;"></div>
    <form action="/payments/admin/delete" method="post" style="display:inline;">
      <input type="hidden" name="paymentId" value="${payment.paymentId}"/>
      <button class="btn btn-danger"
              data-confirm="Permanently delete this payment record?">
        <i class="bi bi-trash"></i> Delete Record
      </button>
    </form>
  </div>

  <div class="mt-3">
    <a href="/payments/admin" class="btn btn-ghost">
      <i class="bi bi-arrow-left"></i> Back to Payments
    </a>
  </div>

</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
