<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Payment — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
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
<div class="container" style="padding-top:2rem; max-width:560px; padding-bottom:4rem;">

  <div class="page-header animate-in">
    <h2 class="page-title">Edit Payment</h2>
    <p class="page-subtitle">Update record for <code class="text-accent">${payment.paymentId}</code></p>
  </div>

  <div class="card animate-in-1">
    <form action="/payments/admin/edit" method="post">
      <input type="hidden" name="paymentId" value="${payment.paymentId}"/>

      <div class="form-group">
        <label class="form-label">Rider</label>
        <input type="text" class="form-control" value="${payment.username} (${payment.userId})" disabled/>
      </div>
      <div class="form-group">
        <label class="form-label">Ride ID</label>
        <input type="text" class="form-control" value="${payment.rideId}" disabled/>
      </div>

      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Amount (₨) *</label>
          <input type="number" name="amount" id="paymentAmountLkr" class="form-control" required
                 step="1" min="0" value="${payment.amount * 320.34}"/>
        </div>
        <div class="form-group">
          <label class="form-label">Status *</label>
          <select name="status" class="form-control" required>
            <option value="COMPLETED" ${payment.status=='COMPLETED' ? 'selected':''}>✅ Completed</option>
            <option value="PENDING"   ${payment.status=='PENDING'   ? 'selected':''}>⏳ Pending</option>
            <option value="REFUNDED"  ${payment.status=='REFUNDED'  ? 'selected':''}>↩️ Refunded</option>
            <option value="FAILED"    ${payment.status=='FAILED'    ? 'selected':''}>❌ Failed</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Payment Method *</label>
        <select name="paymentMethod" class="form-control" required>
          <option value="CASH"       ${payment.paymentMethod=='CASH'       ? 'selected':''}>💵 Cash</option>
          <option value="VISA"       ${payment.paymentMethod=='VISA'       ? 'selected':''}>💳 Visa</option>
          <option value="MASTERCARD" ${payment.paymentMethod=='MASTERCARD' ? 'selected':''}>💳 Mastercard</option>
          <option value="PAYPAL"     ${payment.paymentMethod=='PAYPAL'     ? 'selected':''}>🅿️ PayPal</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Notes</label>
        <textarea name="notes" class="form-control" rows="2">${payment.notes}</textarea>
      </div>

      <div class="d-flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary" style="flex:1;">Save Changes</button>
        <a href="/payments/admin/${payment.paymentId}" class="btn btn-ghost">Cancel</a>
      </div>
    </form>
  </div>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  // Convert LKR input → USD before submitting (amounts stored internally in USD)
  document.querySelector('form[action="/payments/admin/edit"]').addEventListener('submit', function() {
    var inp = document.getElementById('paymentAmountLkr');
    if (inp) {
      inp.value = (parseFloat(inp.value) / 320.34).toFixed(4);
    }
  });
</script>
</body>
</html>
