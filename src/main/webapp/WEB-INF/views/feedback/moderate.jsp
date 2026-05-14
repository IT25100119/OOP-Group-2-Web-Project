<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Moderate Reviews — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/feedback/admin/moderate" class="active">Feedback</a></li>
    <li><a href="/payments/admin">💳 Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">
  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <h2>Review Moderation Panel</h2>
      <p class="text-muted">Average rating: <span class="text-accent">${avgRating} ⭐</span> — All user reviews</p>
    </div>
    <a href="/feedback" class="btn btn-ghost btn-sm">Public View</a>
  </div>

  <div class="card animate-in-1">
    <c:choose>
      <c:when test="${empty allFeedback}">
        <div class="text-center" style="padding:3rem; color:var(--text-500);">No feedback submitted yet.</div>
      </c:when>
      <c:otherwise>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr><th>ID</th><th>User</th><th>Ride</th><th>Rating</th><th>Comment</th><th>Date</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <c:forEach var="fb" items="${allFeedback}">
              <tr>
                <td><code style="font-size:0.75rem;">${fb.feedbackId}</code></td>
                <td>${fb.username}</td>
                <td><code style="font-size:0.75rem;">${fb.rideId}</code></td>
                <td>
                  <span class="stars" style="font-size:0.9rem;">
                    <c:forEach begin="1" end="${fb.rating}" var="s">★</c:forEach>
                  </span>
                  <span class="text-dim"> ${fb.rating}/5</span>
                </td>
                <td style="max-width:260px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${fb.comment}</td>
                <td style="font-size:0.8rem;">${fb.submittedDate}</td>
                <td>
                  <c:choose>
                    <c:when test="${fb.status=='VISIBLE'}"><span class="badge badge-available">Visible</span></c:when>
                    <c:otherwise><span class="badge badge-hidden">Hidden</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="d-flex gap-1">
                    <c:choose>
                      <c:when test="${fb.status=='VISIBLE'}">
                        <form action="/feedback/admin/hide" method="post">
                          <input type="hidden" name="feedbackId" value="${fb.feedbackId}"/>
                          <button class="btn btn-ghost btn-sm">Hide</button>
                        </form>
                      </c:when>
                      <c:otherwise>
                        <form action="/feedback/admin/show" method="post">
                          <input type="hidden" name="feedbackId" value="${fb.feedbackId}"/>
                          <button class="btn btn-ghost btn-sm">Show</button>
                        </form>
                      </c:otherwise>
                    </c:choose>
                    <form action="/feedback/admin/delete" method="post">
                      <input type="hidden" name="feedbackId" value="${fb.feedbackId}"/>
                      <button class="btn btn-danger btn-sm"
                              data-confirm="Permanently delete this review?">Delete</button>
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
<footer class="footer"><p>© 2026 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
