<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Manage Users — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/user/admin/list" class="active">Users</a></li>
    <li><a href="/payments/admin">💳 Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">
  <div class="d-flex justify-between align-center mb-3 animate-in">
    <h2>Rider Accounts</h2>
    <span class="badge badge-available">${users.size()} total riders</span>
  </div>

  <form action="/user/admin/search" method="get" class="d-flex gap-1 mb-4 animate-in-1">
    <div class="search-bar" style="flex:1;">
      <i class="bi bi-search" style="color:var(--text-500);"></i>
      <input type="text" name="query" placeholder="Search by username or email…"
             value="${not empty query ? query : ''}"/>
    </div>
    <button type="submit" class="btn btn-primary">Search</button>
    <c:if test="${not empty query}"><a href="/user/admin/list" class="btn btn-ghost">Clear</a></c:if>
  </form>

  <c:if test="${not empty searchResult}">
    <div class="alert alert-info animate-in-1">
      <i class="bi bi-person-check"></i>
      Found: <strong>${searchResult.username}</strong> — ${searchResult.email}
      (${searchResult.userId})
    </div>
  </c:if>

  <div class="card animate-in-2">
    <c:choose>
      <c:when test="${empty users}">
        <div class="text-center" style="padding:3rem; color:var(--text-500);">No riders registered yet.</div>
      </c:when>
      <c:otherwise>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr><th>User ID</th><th>Username</th><th>Email</th><th>Phone</th><th>Payment</th><th>Joined</th><th>Action</th></tr>
            </thead>
            <tbody>
              <c:forEach var="u" items="${users}">
              <tr>
                <td><code style="font-size:0.75rem;">${u.userId}</code></td>
                <td class="fw-bold">${u.username}</td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td><span class="badge">${u.paymentMethod}</span></td>
                <td style="font-size:0.82rem;">${u.createdDate}</td>
                <td>
                  <form action="/user/admin/delete" method="post" style="display:inline;">
                    <input type="hidden" name="userId" value="${u.userId}"/>
                    <button class="btn btn-danger btn-sm"
                            data-confirm="Delete user ${u.username}? This cannot be undone.">
                      Delete
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
</div>
</div>
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
