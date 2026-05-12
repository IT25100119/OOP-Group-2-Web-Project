<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Profile — VeloRide</title>
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
    <li><a href="/user/profile" class="active">Profile</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:700px; padding-bottom:4rem;">

  <div class="page-header animate-in">
    <h2 class="page-title">My Profile</h2>
    <p class="page-subtitle">Manage your account details and password.</p>
  </div>

  <c:if test="${not empty success}"><div class="alert alert-success animate-in"><i class="bi bi-check-circle"></i> ${success}</div></c:if>
  <c:if test="${not empty error}"><div class="alert alert-error animate-in"><i class="bi bi-x-circle"></i> ${error}</div></c:if>

  <div class="two-col animate-in-1">
    <div class="card">
      <h4 class="mb-3">Edit Details</h4>
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
            <option value="CASH"       ${user.paymentMethod=='CASH'       ? 'selected':''}>Cash</option>
            <option value="VISA"       ${user.paymentMethod=='VISA'       ? 'selected':''}>Visa</option>
            <option value="MASTERCARD" ${user.paymentMethod=='MASTERCARD' ? 'selected':''}>Mastercard</option>
            <option value="PAYPAL"     ${user.paymentMethod=='PAYPAL'     ? 'selected':''}>PayPal</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary w-100">Save Changes</button>
      </form>
    </div>

    <div>
      <div class="card mb-3">
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
          <button type="submit" class="btn btn-outline w-100">Update Password</button>
        </form>
      </div>
      <div class="card" style="border-color:rgba(255,71,87,0.2);">
        <h4 class="mb-2" style="color:var(--red);">Danger Zone</h4>
        <p class="text-muted mb-2" style="font-size:0.85rem;">Permanently delete your account.</p>
        <form action="/user/delete" method="post">
          <input type="hidden" name="userId" value="${user.userId}"/>
          <button type="submit" class="btn btn-danger w-100"
                  data-confirm="This will permanently delete your account. Are you sure?">
            Delete My Account
          </button>
        </form>
      </div>
    </div>
  </div>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
