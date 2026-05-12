<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register Admin — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/admin/list" class="active">Admins</a></li>
    <li><a href="/payments/admin">💳 Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:560px; padding-bottom:4rem;">
  <div class="page-header animate-in">
    <h2 class="page-title">Register New Admin</h2>
    <p class="page-subtitle">Create a new administrator account. Admin access only.</p>
  </div>
  <c:if test="${not empty error}"><div class="alert alert-error"><i class="bi bi-x-circle"></i> ${error}</div></c:if>

  <div class="card animate-in-1">
    <form action="/admin/register" method="post">
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Username *</label>
          <input type="text" name="username" class="form-control" required placeholder="admin_name"/>
        </div>
        <div class="form-group">
          <label class="form-label">Phone</label>
          <input type="tel" name="phone" class="form-control" placeholder="077xxxxxxx"/>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Email *</label>
        <input type="email" name="email" class="form-control" required placeholder="admin@bikerental.com"/>
      </div>
      <div class="form-group">
        <label class="form-label">Password *</label>
        <input type="password" name="password" class="form-control" required minlength="6"/>
      </div>
      <div class="two-col" style="gap:1rem;">
        <div class="form-group">
          <label class="form-label">Admin Level</label>
          <select name="adminLevel" class="form-control">
            <option value="ADMIN">Admin</option>
            <option value="SUPER_ADMIN">Super Admin</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Permissions</label>
          <input type="text" name="permissions" class="form-control"
                 value="BIKES,USERS,STATIONS,FEEDBACK"
                 placeholder="BIKES,USERS,STATIONS,FEEDBACK"/>
        </div>
      </div>
      <div class="d-flex gap-1 mt-2">
        <button type="submit" class="btn btn-primary" style="flex:1;">
          <i class="bi bi-shield-plus"></i> Create Admin
        </button>
        <a href="/admin/list" class="btn btn-ghost">Cancel</a>
      </div>
    </form>
  </div>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
