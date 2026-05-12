<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Transaction Log — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ── Action colour pills ─── */
    .action-pill {
      display:inline-flex; align-items:center; gap:5px;
      padding:3px 11px; border-radius:99px;
      font-size:.73rem; font-weight:700;
      text-transform:uppercase; letter-spacing:.06em;
    }
    .action-CREATED   { background:rgba(0,229,160,.1);  color:var(--accent); }
    .action-COMPLETED { background:rgba(0,229,160,.12); color:var(--accent); }
    .action-REFUNDED  { background:rgba(255,107,53,.12);color:var(--orange); }
    .action-FAILED    { background:rgba(255,71,87,.12);  color:var(--red); }
    .action-EDITED    { background:rgba(78,168,222,.12); color:var(--blue); }
    .action-DELETED   { background:rgba(84,94,119,.2);   color:var(--text-500); }

    /* ── Timeline dot ─────── */
    .tx-row { position:relative; }
    .tx-dot {
      width:10px; height:10px; border-radius:50%; flex-shrink:0;
      margin-top:2px;
    }
    .dot-green  { background:var(--accent);  box-shadow:0 0 6px var(--accent); }
    .dot-orange { background:var(--orange);  box-shadow:0 0 6px var(--orange); }
    .dot-red    { background:var(--red);     box-shadow:0 0 6px var(--red); }
    .dot-blue   { background:var(--blue);    box-shadow:0 0 6px var(--blue); }
    .dot-gray   { background:var(--text-500); }

    /* ── Stat pill row ─────── */
    .action-stat {
      display:flex; align-items:center; justify-content:space-between;
      padding:.6rem .85rem; border-radius:var(--radius-sm);
      background:var(--bg-700); margin-bottom:.5rem;
      font-size:.85rem; transition:var(--transition);
      cursor:pointer; text-decoration:none;
    }
    .action-stat:hover { background:var(--bg-600); }
    .action-stat .count {
      font-family:var(--font-display); font-size:1.2rem;
    }

    /* ── Admin badge ────────── */
    .admin-tag {
      display:inline-flex; align-items:center; gap:4px;
      padding:2px 8px; border-radius:99px; font-size:.7rem;
      background:rgba(255,107,53,.12); color:var(--orange);
    }
    .system-tag {
      display:inline-flex; align-items:center; gap:4px;
      padding:2px 8px; border-radius:99px; font-size:.7rem;
      background:rgba(84,94,119,.18); color:var(--text-500);
    }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/payments/admin">Payments</a></li>
    <li><a href="/admin/transactions" class="active">Transactions</a></li>
    <li><a href="/admin/list">Admins</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <%-- ── Header ─────────────────────────────────────────────── --%>
  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>Payment Transaction Log</h2>
      <p class="text-muted">
        <span class="live-dot"></span>
        Audit trail for every payment event — auto-generated and admin actions.
      </p>
    </div>
    <a href="/payments/admin" class="btn btn-ghost btn-sm">
      <i class="bi bi-credit-card"></i> Back to Payments
    </a>
  </div>

  <%-- ── Two-column layout ──────────────────────────────────── --%>
  <div class="layout-sidebar">

    <%-- ── LEFT: Stats sidebar ────────────────────────────── --%>
    <div>
      <div class="sidebar animate-in-1">
        <div class="sidebar-section">Transaction Types</div>

        <c:forEach var="entry" items="${actionBreakdown}">
          <a href="/admin/transactions/filter?action=${entry.key}" class="action-stat">
            <div class="d-flex align-center gap-2">
              <div class="tx-dot
                ${entry.key=='CREATED'||entry.key=='COMPLETED' ? 'dot-green' :
                  entry.key=='REFUNDED' ? 'dot-orange' :
                  entry.key=='FAILED'   ? 'dot-red'    :
                  entry.key=='EDITED'   ? 'dot-blue'   : 'dot-gray'}">
              </div>
              <span>${entry.key}</span>
            </div>
            <span class="count text-accent">${entry.value}</span>
          </a>
        </c:forEach>

        <div class="section-divider"></div>
        <div class="sidebar-section">Total Refunded</div>
        <div class="card card-stat" style="padding:.85rem;">
          <div class="stat-value text-orange" style="font-size:1.6rem;">₨<fmt:formatNumber value="${totalRefunded * 320.34}" pattern="#,##0"/></div>
          <div class="stat-label">across all refunds</div>
        </div>

        <div class="section-divider"></div>
        <div class="sidebar-section">Quick Filter</div>
        <div style="display:flex; flex-direction:column; gap:.4rem;">
          <a href="/admin/transactions" class="btn btn-ghost btn-sm">All Transactions</a>
          <a href="/admin/transactions/filter?action=REFUNDED"  class="btn btn-ghost btn-sm">Refunds Only</a>
          <a href="/admin/transactions/filter?action=FAILED"    class="btn btn-ghost btn-sm">Failed Only</a>
          <a href="/admin/transactions/filter?action=CREATED"   class="btn btn-ghost btn-sm">Auto-Created</a>
        </div>
      </div>
    </div>

    <%-- ── RIGHT: Transaction table ───────────────────────── --%>
    <div>

      <%-- Search bar --%>
      <form action="/admin/transactions/filter" method="get" class="d-flex gap-1 mb-3 animate-in-1">
        <div class="search-bar" style="flex:1;">
          <i class="bi bi-search" style="color:var(--text-500);"></i>
          <input type="text" name="search" placeholder="Search by Tx ID, Payment ID, username, ride ID…"
                 value="${not empty search ? search : ''}"/>
        </div>
        <button type="submit" class="btn btn-primary">Search</button>
        <c:if test="${not empty search || not empty filterAction}">
          <a href="/admin/transactions" class="btn btn-ghost">Clear</a>
        </c:if>
      </form>

      <div class="card animate-in-2">
        <div class="d-flex justify-between align-center mb-3">
          <h4>
            <c:choose>
              <c:when test="${not empty search}">Results: "${search}"</c:when>
              <c:when test="${not empty filterAction}">${filterAction} transactions</c:when>
              <c:otherwise>All Transactions</c:otherwise>
            </c:choose>
            <span class="text-muted" style="font-size:.85rem; font-weight:400; font-family:var(--font-body);">
              (${transactions.size()})
            </span>
          </h4>
        </div>

        <c:choose>
          <c:when test="${empty transactions}">
            <div class="text-center" style="padding:3rem; color:var(--text-500);">
              <div style="font-size:3rem; margin-bottom:1rem;">📋</div>
              <p>No transaction records found.<br>Complete a ride to generate transactions.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-wrapper">
              <table>
                <thead>
                  <tr>
                    <th>Tx ID</th>
                    <th>Action</th>
                    <th>Payment ID</th>
                    <th>Rider</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Status Change</th>
                    <th>By</th>
                    <th>Timestamp</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="tx" items="${transactions}">
                  <tr class="tx-row">
                    <td><code style="font-size:.72rem; color:var(--accent);">${tx.txId}</code></td>
                    <td>
                      <span class="action-pill action-${tx.action}">
                        <c:choose>
                          <c:when test="${tx.action=='CREATED'}">⊕</c:when>
                          <c:when test="${tx.action=='COMPLETED'}">✓</c:when>
                          <c:when test="${tx.action=='REFUNDED'}">↩</c:when>
                          <c:when test="${tx.action=='FAILED'}">✗</c:when>
                          <c:when test="${tx.action=='EDITED'}">✎</c:when>
                          <c:otherwise>○</c:otherwise>
                        </c:choose>
                        ${tx.action}
                      </span>
                    </td>
                    <td><code style="font-size:.72rem;">${tx.paymentId}</code></td>
                    <td>
                      <div style="font-weight:500; font-size:.88rem;">${tx.username}</div>
                      <div class="text-dim" style="font-size:.7rem;">${tx.userId}</div>
                    </td>
                    <td>
                      <span style="font-family:var(--font-display); font-size:1rem;
                        color:${tx.action=='REFUNDED'?'var(--orange)':tx.action=='FAILED'?'var(--red)':'var(--accent)'};">
                        ₨<fmt:formatNumber value="${tx.amount * 320.34}" pattern="#,##0"/>
                      </span>
                    </td>
                    <td style="font-size:.8rem;">
                      <c:choose>
                        <c:when test="${tx.paymentMethod=='VISA'}">💳 Visa</c:when>
                        <c:when test="${tx.paymentMethod=='MASTERCARD'}">💳 MC</c:when>
                        <c:when test="${tx.paymentMethod=='PAYPAL'}">🅿️ PP</c:when>
                        <c:otherwise>💵 Cash</c:otherwise>
                      </c:choose>
                    </td>
                    <td style="font-size:.78rem; color:var(--text-300);">
                      <c:if test="${not empty tx.previousStatus and tx.previousStatus ne tx.newStatus}">
                        <span style="color:var(--text-500);">${tx.previousStatus}</span>
                        → <span style="color:var(--accent);">${tx.newStatus}</span>
                      </c:if>
                      <c:if test="${empty tx.previousStatus or tx.previousStatus eq tx.newStatus}">
                        <span style="color:var(--accent);">${tx.newStatus}</span>
                      </c:if>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${tx.adminId ne null and not empty tx.adminId}">
                          <span class="admin-tag">
                            <i class="bi bi-shield-fill" style="font-size:.65rem;"></i>
                            ${tx.adminName}
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="system-tag">
                            <i class="bi bi-robot" style="font-size:.65rem;"></i>
                            System
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td style="font-size:.75rem; white-space:nowrap; color:var(--text-500);">
                      ${tx.timestamp}
                    </td>
                    <td>
                      <form action="/admin/transactions/delete" method="post">
                        <input type="hidden" name="txId" value="${tx.txId}"/>
                        <button class="btn btn-ghost btn-sm" style="color:var(--text-500);"
                                data-confirm="Delete this transaction log entry?">
                          <i class="bi bi-trash"></i>
                        </button>
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

    </div><%-- /right --%>
  </div><%-- /layout-sidebar --%>

</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
