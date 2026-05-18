<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payment Management — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ── Payment-specific styles ───────────────────────────── */
    .method-icon { font-size:1.2rem; }
    .revenue-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 1.4rem;
      position: relative;
      overflow: hidden;
      transition: transform 0.25s ease, box-shadow 0.25s ease;
    }
    .revenue-card:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(0,0,0,0.4); }
    .revenue-card::before {
      content: '';
      position: absolute; top: 0; left: 0; right: 0; height: 3px;
    }
    .revenue-card.green::before  { background: linear-gradient(90deg, transparent, var(--accent), transparent); }
    .revenue-card.orange::before { background: linear-gradient(90deg, transparent, var(--orange), transparent); }
    .revenue-card.blue::before   { background: linear-gradient(90deg, transparent, var(--blue), transparent); }
    .revenue-card.red::before    { background: linear-gradient(90deg, transparent, var(--red), transparent); }

    .revenue-value {
      font-family: var(--font-display);
      font-size: 2.2rem;
      line-height: 1;
      margin: 0.4rem 0 0.3rem;
    }
    .revenue-label {
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--text-500);
    }

    /* Method breakdown bars */
    .method-bar { margin-bottom: 1rem; }
    .method-bar-label {
      display: flex; justify-content: space-between;
      font-size: 0.82rem; margin-bottom: 4px;
      color: var(--text-300);
    }
    .method-bar-track {
      height: 8px; background: var(--bg-700);
      border-radius: 4px; overflow: hidden;
    }
    .method-bar-fill {
      height: 100%; border-radius: 4px;
      transition: width 1.2s cubic-bezier(0.4,0,0.2,1);
      background-size: 200% 100%;
      animation: shimmer 2.5s linear infinite;
    }
    .fill-green  { background: linear-gradient(90deg, var(--accent), #00ffcc); }
    .fill-blue   { background: linear-gradient(90deg, var(--blue), #7ec8f5); }
    .fill-orange { background: linear-gradient(90deg, var(--orange), #ffaa80); }
    .fill-purple { background: linear-gradient(90deg, #8b5cf6, #a78bfa); }

    /* Mini chart bars */
    .chart-wrap {
      display: flex; align-items: flex-end; gap: 5px;
      height: 80px; padding: 0 4px;
    }
    .chart-bar-col {
      flex: 1; display: flex; flex-direction: column;
      align-items: center; gap: 3px;
    }
    .chart-bar {
      width: 100%; border-radius: 4px 4px 0 0;
      background: var(--accent);
      opacity: 0.8;
      transition: height 1s cubic-bezier(0.4,0,0.2,1), opacity 0.2s;
      min-height: 4px;
    }
    .chart-bar:hover { opacity: 1; }
    .chart-day {
      font-size: 0.65rem; color: var(--text-500);
      white-space: nowrap; transform: rotate(-30deg);
    }

    /* Filter chips */
    .filter-strip { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 1.2rem; }
    .fchip {
      padding: 5px 14px; border-radius: 99px; font-size: 0.8rem;
      border: 1px solid var(--border); background: var(--bg-700);
      color: var(--text-300); text-decoration: none;
      transition: all 0.2s ease; cursor: pointer;
    }
    .fchip:hover, .fchip.active {
      color: var(--accent); border-color: var(--accent);
      background: rgba(0,229,160,0.08);
    }
    .fchip.status-completed{ border-color: rgba(0,229,160,0.3); color: var(--accent); }
    .fchip.status-refunded { border-color: rgba(255,107,53,0.3); color: var(--orange); }
    .fchip.status-failed   { border-color: rgba(255,71,87,0.3);  color: var(--red); }
    .fchip.status-pending  { border-color: rgba(255,193,7,0.3);  color: var(--yellow); }

    /* Payment row hover */
    tbody tr { cursor: pointer; }
    tbody tr:hover td { background: rgba(0,229,160,0.04); }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/user/admin/list">Users</a></li>
    <li><a href="/rides/queue">Rides</a></li>
    <li><a href="/payments/admin" class="active">Payments</a></li>
    <li><a href="/feedback/admin/moderate">Feedback</a></li>
    <li><a href="/admin/list">Admins</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <%-- ── Header ─────────────────────────────────────────────── --%>
  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>Payment Management</h2>
      <p class="text-muted">Track revenue, manage transactions, issue refunds.</p>
    </div>
    <a href="/payments/admin/create" class="btn btn-primary">
      <i class="bi bi-plus-circle"></i> Manual Payment
    </a>
  </div>

  <%-- ── Success/Error alert ─────────────────────────────────────── --%>
  <c:if test="${not empty success}">
    <div class="alert alert-success animate-in">
      <i class="bi bi-check-circle"></i> ${success}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error animate-in">
      <i class="bi bi-exclamation-circle"></i> ${error}
    </div>
  </c:if>

  <%-- ── Revenue Stats ───────────────────────────────────────── --%>
  <div class="stats-grid stagger" style="grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); margin-bottom:1.5rem;">

    <div class="revenue-card green animate-in-1">
      <div class="revenue-label"><i class="bi bi-cash-coin"></i> Total Revenue</div>
      <div class="revenue-value text-accent">₨<fmt:formatNumber value="${totalRevenue * 320.34}" pattern="#,##0"/></div>
      <div class="text-dim" style="font-size:0.75rem;">${completedCount} completed</div>
    </div>

    <div class="revenue-card orange animate-in-2">
      <div class="revenue-label"><i class="bi bi-arrow-counterclockwise"></i> Refunded</div>
      <div class="revenue-value text-orange">₨<fmt:formatNumber value="${totalRefunded * 320.34}" pattern="#,##0"/></div>
      <div class="text-dim" style="font-size:0.75rem;">${refundedCount} refunds</div>
    </div>

    <div class="revenue-card blue animate-in-3">
      <div class="revenue-label"><i class="bi bi-receipt"></i> Total Transactions</div>
      <div class="revenue-value text-blue">${totalCount}</div>
      <div class="text-dim" style="font-size:0.75rem;">${pendingCount} pending</div>
    </div>

    <div class="revenue-card red animate-in-4">
      <div class="revenue-label"><i class="bi bi-x-circle"></i> Failed</div>
      <div class="revenue-value text-red">${failedCount}</div>
      <div class="text-dim" style="font-size:0.75rem;">need review</div>
    </div>

    <div class="revenue-card green animate-in-5">
      <div class="revenue-label"><i class="bi bi-graph-up"></i> Avg Payment</div>
      <div class="revenue-value text-accent">₨<fmt:formatNumber value="${avgPayment * 320.34}" pattern="#,##0"/></div>
      <div class="text-dim" style="font-size:0.75rem;">per transaction</div>
    </div>

  </div>

  <%-- ── Two-column analysis ─────────────────────────────────── --%>
  <div class="two-col animate-in-2" style="margin-bottom:2rem;">

    <%-- Method breakdown --%>
    <div class="card">
      <h4 class="mb-3"><i class="bi bi-pie-chart text-accent"></i> Revenue by Method</h4>
      <c:forEach var="entry" items="${revenueByMethod}">
        <div class="method-bar">
          <div class="method-bar-label">
            <span>
              <c:choose>
                <c:when test="${entry.key == 'VISA'}">💳 Visa</c:when>
                <c:when test="${entry.key == 'MASTERCARD'}">💳 Mastercard</c:when>
                <c:when test="${entry.key == 'PAYPAL'}">🅿️ PayPal</c:when>
                <c:otherwise>💵 Cash</c:otherwise>
              </c:choose>
            </span>
            <span class="fw-bold">₨<fmt:formatNumber value="${entry.value * 320.34}" pattern="#,##0"/></span>
          </div>
          <div class="method-bar-track">
            <%-- data-val and data-total are plain numbers — percentage computed in JS --%>
            <div class="method-bar-fill
              ${entry.key == 'CASH' ? 'fill-green' :
                entry.key == 'VISA' ? 'fill-blue' :
                entry.key == 'MASTERCARD' ? 'fill-orange' : 'fill-purple'}"
                 data-val="${entry.value}"
                 data-total="${rawTotalRevenue}"
                 style="width:0%;"></div>
          </div>
        </div>
      </c:forEach>
    </div>

    <%-- 7-day mini chart — heights computed in JS from data-val/data-max --%>
    <div class="card">
      <h4 class="mb-3"><i class="bi bi-bar-chart text-accent"></i> Revenue — Last 7 Days</h4>
      <div class="chart-wrap" id="dailyChart">
        <c:forEach var="d" items="${last7Days}">
          <div class="chart-bar-col">
            <div class="chart-bar"
                 data-val="${d.value}"
                 data-label="${d.key}: ₨${d.value * 320.34}"
                 style="height:4px;"></div>
            <div class="chart-day">${d.key.substring(5)}</div>
          </div>
        </c:forEach>
      </div>
      <div class="text-center text-muted mt-2" style="font-size:0.78rem;" id="maxDayLabel">
        Loading chart…
      </div>
    </div>

  </div>

  <%-- ── Filter Strip + Search ───────────────────────────────── --%>
  <div class="animate-in-3 mb-2">
    <div class="filter-strip">
      <a href="/payments/admin" class="fchip ${empty filterStatus && empty filterMethod && empty search ? 'active':''}">All</a>
      <a href="/payments/admin/filter?status=COMPLETED"  class="fchip status-completed">✅ Completed</a>
      <a href="/payments/admin/filter?status=PENDING"    class="fchip status-pending">⏳ Pending</a>
      <a href="/payments/admin/filter?status=REFUNDED"   class="fchip status-refunded">↩️ Refunded</a>
      <a href="/payments/admin/filter?status=FAILED"     class="fchip status-failed">❌ Failed</a>
      <span style="color:var(--border); align-self:center;">|</span>
      <a href="/payments/admin/filter?method=CASH"       class="fchip">💵 Cash</a>
      <a href="/payments/admin/filter?method=VISA"       class="fchip">💳 Visa</a>
      <a href="/payments/admin/filter?method=MASTERCARD" class="fchip">💳 Mastercard</a>
      <a href="/payments/admin/filter?method=PAYPAL"     class="fchip">🅿️ PayPal</a>
    </div>

    <form action="/payments/admin/filter" method="get" class="d-flex gap-1">
      <div class="search-bar" style="flex:1;">
        <i class="bi bi-search" style="color:var(--text-500);"></i>
        <input type="text" name="search" placeholder="Search by Payment ID, Ride ID, or username…"
               value="${not empty search ? search : ''}"/>
      </div>
      <button type="submit" class="btn btn-primary">Search</button>
      <c:if test="${not empty search || not empty filterStatus || not empty filterMethod}">
        <a href="/payments/admin" class="btn btn-ghost">Clear</a>
      </c:if>
    </form>
  </div>

  <%-- ── Payments Table ──────────────────────────────────────── --%>
  <div class="card animate-in-4">
    <div class="d-flex justify-between align-center mb-3">
      <h4>
        <c:choose>
          <c:when test="${not empty search}">Search: "${search}"</c:when>
          <c:when test="${not empty filterStatus}">Filtered: ${filterStatus}</c:when>
          <c:when test="${not empty filterMethod}">Method: ${filterMethod}</c:when>
          <c:otherwise>All Transactions</c:otherwise>
        </c:choose>
        <span class="text-muted" style="font-size:0.85rem; font-family:var(--font-body); font-weight:400;">
          (${allPayments.size()})
        </span>
      </h4>
    </div>

    <c:choose>
      <c:when test="${empty allPayments}">
        <div class="text-center" style="padding:3rem; color:var(--text-500);">
          <div style="font-size:3rem; margin-bottom:1rem;">💳</div>
          <p>No payment records found.</p>
          <a href="/payments/admin/create" class="btn btn-primary mt-2">Create First Payment</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Payment ID</th>
                <th>Ride ID</th>
                <th>User</th>
                <th>Amount</th>
                <th>Method</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="pay" items="${allPayments}">
              <tr onclick="window.location='/payments/admin/${pay.paymentId}'">
                <td>
                  <code style="font-size:0.75rem; color:var(--accent);">${pay.paymentId}</code>
                </td>
                <td><code style="font-size:0.75rem;">${pay.rideId}</code></td>
                <td>
                  <div style="font-weight:500;">${pay.username}</div>
                  <div class="text-dim" style="font-size:0.72rem;">${pay.userId}</div>
                </td>
                <td>
                  <span style="font-family:var(--font-display); font-size:1.1rem;
                    color:${pay.status=='REFUNDED'?'var(--orange)':pay.status=='FAILED'?'var(--red)':'var(--accent)'};">
                    ₨<fmt:formatNumber value="${pay.amount * 320.34}" pattern="#,##0"/>
                  </span>
                </td>
                <td>
                  <span class="badge">
                    <c:choose>
                      <c:when test="${pay.paymentMethod=='VISA'}">💳 Visa</c:when>
                      <c:when test="${pay.paymentMethod=='MASTERCARD'}">💳 MC</c:when>
                      <c:when test="${pay.paymentMethod=='PAYPAL'}">🅿️ PayPal</c:when>
                      <c:otherwise>💵 Cash</c:otherwise>
                    </c:choose>
                  </span>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${pay.status=='COMPLETED'}"> <span class="badge badge-available">Completed</span></c:when>
                    <c:when test="${pay.status=='REFUNDED'}">  <span class="badge badge-inuse">Refunded</span></c:when>
                    <c:when test="${pay.status=='FAILED'}">    <span class="badge badge-cancelled">Failed</span></c:when>
                    <c:when test="${pay.status=='PENDING'}">   <span class="badge badge-maintenance">Pending</span></c:when>
                    <c:otherwise><span class="badge">${pay.status}</span></c:otherwise>
                  </c:choose>
                </td>
                <td style="font-size:0.82rem;">${pay.transactionDate}</td>
                <td onclick="event.stopPropagation();">
                  <div class="d-flex gap-1">
                    <a href="/payments/admin/${pay.paymentId}" class="btn btn-ghost btn-sm"
                       data-tooltip="View Details">
                      <i class="bi bi-eye"></i>
                    </a>
                    <c:if test="${pay.status=='COMPLETED'}">
                      <form action="/payments/admin/refund" method="post" style="display:inline;">
                        <input type="hidden" name="paymentId" value="${pay.paymentId}"/>
                        <button class="btn btn-ghost btn-sm" data-tooltip="Refund"
                                data-confirm="Refund ₨${pay.amount * 320.34} for ${pay.username}?">
                          <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                      </form>
                    </c:if>
                    <c:if test="${pay.status=='PENDING' || pay.status=='FAILED'}">
                      <form action="/payments/admin/complete" method="post" style="display:inline;">
                        <input type="hidden" name="paymentId" value="${pay.paymentId}"/>
                        <button class="btn btn-ghost btn-sm" style="color:var(--accent);"
                                data-tooltip="Mark Completed">
                          <i class="bi bi-check-circle"></i>
                        </button>
                      </form>
                    </c:if>
                    <form action="/payments/admin/delete" method="post" style="display:inline;">
                      <input type="hidden" name="paymentId" value="${pay.paymentId}"/>
                      <button class="btn btn-danger btn-sm" data-tooltip="Delete"
                              data-confirm="Delete payment ${pay.paymentId}? This cannot be undone.">
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
<script>
  // ── Method bars: compute % from data-val / data-total ─────────────────────
  document.querySelectorAll('.method-bar-fill').forEach(bar => {
    const val   = parseFloat(bar.dataset.val)   || 0;
    const total = parseFloat(bar.dataset.total) || 0;
    const pct   = total > 0 ? Math.min((val / total) * 100, 100) : 0;
    setTimeout(() => {
      bar.style.transition = 'width 1.2s cubic-bezier(.4,0,.2,1)';
      bar.style.width = pct.toFixed(1) + '%';
    }, 300);
  });

  // ── Daily chart: compute heights from data-val ─────────────────────────────
  const chartBars = document.querySelectorAll('#dailyChart .chart-bar');
  const vals = Array.from(chartBars).map(b => parseFloat(b.dataset.val) || 0);
  const maxVal = Math.max(...vals, 0.01);
  chartBars.forEach(bar => {
    const v   = parseFloat(bar.dataset.val) || 0;
    const h   = Math.max((v / maxVal) * 72, 4);
    bar.title = bar.dataset.label || '';
    bar.addEventListener('click', () => alert(bar.dataset.label));
    setTimeout(() => {
      bar.style.transition = 'height 0.8s cubic-bezier(.4,0,.2,1)';
      bar.style.height = h.toFixed(1) + 'px';
    }, 400);
  });
  const maxLabel = document.getElementById('maxDayLabel');
  if (maxLabel) maxLabel.textContent = 'Max day: ₨' + Math.round(maxVal * 320.34).toLocaleString();
</script>
</body>
</html>
