<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create Account — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .auth-wrap { min-height:100vh; display:flex; align-items:center; justify-content:center; padding:2rem 1rem; }
    .auth-card { width:100%; max-width:460px; background:var(--bg-card); border:1px solid var(--border);
                 border-radius:16px; padding:2.5rem; box-shadow:0 24px 64px rgba(0,0,0,0.6); animation:fadeInUp 0.5s ease; }
    .auth-logo { font-family:var(--font-display); font-size:1.85rem; font-weight:800; color:var(--text-100); letter-spacing:-0.04em; margin-bottom:0.5rem; }
    .auth-logo span { color:var(--accent); }
  </style>
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">
    <a href="/" class="auth-logo">VELO<span>●</span>RIDE</a>
    <p class="text-muted mb-3" style="font-size:0.9rem;">Join thousands of riders today</p>

    <c:if test="${not empty error}">
      <div class="alert alert-error"><i class="bi bi-exclamation-circle"></i> ${error}</div>
    </c:if>

    <form action="/register" method="post">
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Username *</label>
          <input type="text" name="username" class="form-control" required placeholder="johndoe" minlength="3"/>
        </div>
        <div class="form-group">
          <label class="form-label">Phone *</label>
          <input type="tel" name="phone" class="form-control" required placeholder="077xxxxxxx"/>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Email Address *</label>
        <input type="email" name="email" class="form-control" required placeholder="you@example.com"/>
      </div>

      <div class="form-group">
        <label class="form-label">Password *</label>
        <div style="position:relative;">
          <input type="password" name="password" id="regPass" class="form-control" required
                 placeholder="Min. 6 characters" minlength="6" style="padding-right:42px;"/>
          <button type="button" data-toggle-password="regPass"
                  style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--text-500);">👁</button>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Payment Method</label>
        <select name="paymentMethod" class="form-control">
          <option value="CASH">💵 Cash</option>
          <option value="VISA">💳 Visa Card</option>
          <option value="MASTERCARD">💳 Mastercard</option>
          <option value="PAYPAL">🅿️ PayPal</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary w-100 mt-2">
        <i class="bi bi-person-check"></i> Create Account
      </button>
    </form>

    <div class="divider-text">already have an account</div>
    <a href="/login" class="btn btn-ghost w-100">
      <i class="bi bi-box-arrow-in-right"></i> Sign In
    </a>
  </div>
</div>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
