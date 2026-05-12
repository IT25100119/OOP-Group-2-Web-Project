<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Accounts — VeloRide</title>
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
    <li><a href="/admin/register" class="btn btn-primary btn-sm"><i class="bi bi-plus"></i> New Admin</a></li>
    <li><a href="/payments/admin">💳 Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">
  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>Admin Management Panel</h2>
      <p class="text-muted">Manage admin accounts and their permissions. (Admin access only)</p>
    </div>
    <span class="badge badge-admin">${admins.size()} admins</span>
  </div>

  <c:if test="${not empty error}">
    <div class="alert alert-error animate-in-1"><i class="bi bi-exclamation-circle"></i> ${error}</div>
  </c:if>

  <div class="card animate-in-2">
    <div class="table-wrapper">
      <table>
        <thead>
          <tr><th>Admin ID</th><th>Username</th><th>Email</th><th>Level</th><th>Permissions</th><th>Last Login</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <c:forEach var="adm" items="${admins}">
          <tr>
            <td><code style="font-size:0.75rem;">${adm.userId}</code></td>
            <td class="fw-bold">${adm.username}
              <c:if test="${adm.userId == currentAdmin.userId}">
                <span class="badge badge-active" style="font-size:0.65rem;">You</span>
              </c:if>
            </td>
            <td>${adm.email}</td>
            <td><span class="badge badge-admin">${adm.adminLevel}</span></td>
            <td style="font-size:0.78rem; color:var(--text-300);">${adm.permissions}</td>
            <td style="font-size:0.8rem;">${adm.lastLoginDate}</td>
            <td>
              <div class="d-flex gap-1">
                <a href="/admin/edit/${adm.userId}" class="btn btn-ghost btn-sm">Edit</a>
                <c:if test="${adm.userId != currentAdmin.userId}">
                  <form action="/admin/delete" method="post" style="display:inline;">
                    <input type="hidden" name="adminId" value="${adm.userId}"/>
                    <button class="btn btn-danger btn-sm"
                            data-confirm="Delete admin ${adm.username}?">Delete</button>
                  </form>
                </c:if>
              </div>
            </td>
          </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
