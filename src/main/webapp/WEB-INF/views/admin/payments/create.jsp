<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create Payment — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .method-card {
      border: 2px solid var(--border); border-radius: 12px;
      padding: 1rem; cursor: pointer; transition: all 0.2s ease;
      text-align: center; background: var(--bg-700);
    }
    .method-card:hover { border-color: rgba(0,229,160,0.4); background: rgba(0,229,160,0.05); }
    .method-card input:checked + .method-card,
    .method-card.selected { border-color: var(--accent); background: rgba(0,229,160,0.08); }
    .method-icon { font-size: 1.8rem; margin-bottom: 0.3rem; display: block; }
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
<div class="container" style="padding-top:2rem; max-width:600px; padding-bottom:4rem;">

  <div class="page-header animate-in">
    <h2 class="page-title">Create Manual Payment</h2>
    <p class="page-subtitle">Manually log a payment record for a ride (e.g. cash collected offline).</p>
  </div>

  <div class="card animate-in-1">
    <form action="/payments/admin/create" method="post">

      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Ride ID *</label>
          <input type="text" name="rideId" class="form-control" required
                 placeholder="RDE-XXXXXXXX"/>
        </div>
        <div class="form-group">
          <label class="form-label">Amount ($) *</label>
          <input type="number" name="amount" class="form-control" required
                 step="0.01" min="0.01" placeholder="5.00"/>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Rider *</label>
        <select name="userId" class="form-control" required>
          <option value="">Select rider…</option>
          <c:forEach var="u" items="${users}">
            <option value="${u.userId}">${u.username} (${u.userId})</option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Payment Method *</label>
        <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:0.75rem;">
          <label>
            <input type="radio" name="paymentMethod" value="CASH" checked style="display:none;" onchange="selectMethod(this)"/>
            <div class="method-card selected" id="method-CASH">
              <span class="method-icon">💵</span>
              <div style="font-size:0.8rem; font-weight:600;">Cash</div>
            </div>
          </label>
          <label>
            <input type="radio" name="paymentMethod" value="VISA" style="display:none;" onchange="selectMethod(this)"/>
            <div class="method-card" id="method-VISA">
              <span class="method-icon">💳</span>
              <div style="font-size:0.8rem; font-weight:600;">Visa</div>
            </div>
          </label>
          <label>
            <input type="radio" name="paymentMethod" value="MASTERCARD" style="display:none;" onchange="selectMethod(this)"/>
            <div class="method-card" id="method-MASTERCARD">
              <span class="method-icon">💳</span>
              <div style="font-size:0.8rem; font-weight:600;">Mastercard</div>
            </div>
          </label>
          <label>
            <input type="radio" name="paymentMethod" value="PAYPAL" style="display:none;" onchange="selectMethod(this)"/>
            <div class="method-card" id="method-PAYPAL">
              <span class="method-icon">🅿️</span>
              <div style="font-size:0.8rem; font-weight:600;">PayPal</div>
            </div>
          </label>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Notes (optional)</label>
        <textarea name="notes" class="form-control" rows="2"
                  placeholder="e.g. Cash collected at City Center Hub station…"></textarea>
      </div>

      <div class="d-flex gap-1 mt-3">
        <button type="submit" class="btn btn-primary" style="flex:1;">
          <i class="bi bi-plus-circle"></i> Create Payment
        </button>
        <a href="/payments/admin" class="btn btn-ghost">Cancel</a>
      </div>
    </form>
  </div>

</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  function selectMethod(radio) {
    document.querySelectorAll('.method-card').forEach(c => c.classList.remove('selected'));
    document.getElementById('method-' + radio.value).classList.add('selected');
  }
</script>
</body>
</html>
