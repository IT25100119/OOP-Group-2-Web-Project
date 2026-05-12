<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Login — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css" />
  <link rel="stylesheet" href="/static/css/animations.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ── Fill exactly the viewport, no scrolling ─── */
    html, body { height: 100%; overflow: hidden; }

    .auth-wrap {
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 3rem;
      padding: 0 1.5rem;
      background:
        radial-gradient(ellipse 60% 80% at 70% 50%, rgba(0,229,160,0.05) 0%, transparent 60%),
        radial-gradient(ellipse 40% 60% at 20% 50%, rgba(78,168,222,0.04) 0%, transparent 50%);
    }

    /* Left decorative panel — hidden on small screens */
    .auth-brand {
      display: flex; flex-direction: column; gap: 1.25rem;
      max-width: 300px; flex-shrink: 0;
    }
    @media (max-width: 820px) { .auth-brand { display: none; } }

    .auth-brand-logo {
      font-family: var(--font-display);
      font-size: 2.4rem; font-weight: 800;
      letter-spacing: -0.04em; color: var(--text-100); line-height: 1;
    }
    .auth-brand-logo span { color: var(--accent); }

    .auth-brand-tagline {
      font-size: 0.95rem; color: var(--text-300); line-height: 1.6;
    }

    .brand-stat {
      display: flex; align-items: center; gap: 0.75rem;
      font-size: 0.82rem; color: var(--text-300);
    }
    .brand-stat-icon {
      width: 30px; height: 30px; border-radius: 8px;
      background: rgba(0,229,160,0.1); border: 1px solid rgba(0,229,160,0.2);
      display: flex; align-items: center; justify-content: center;
      font-size: 0.85rem; flex-shrink: 0;
    }

    /* ── Login card ─── */
    .auth-card {
      width: 100%; max-width: 390px;
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 1.6rem 1.75rem 1.4rem;
      box-shadow: 0 24px 64px rgba(0,0,0,0.55);
      animation: scaleInBounce 0.4s cubic-bezier(0.4,0,0.2,1) both;
      position: relative;
    }
    .auth-card::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
      background: linear-gradient(90deg, transparent, var(--accent), transparent);
      border-radius: 16px 16px 0 0;
    }

    .auth-logo {
      font-family: var(--font-display); font-size: 1.55rem; font-weight: 800;
      color: var(--text-100); letter-spacing: -0.04em;
      margin-bottom: 0.15rem; text-decoration: none; display: block;
    }
    .auth-logo span { color: var(--accent); }

    .login-tabs {
      display: flex; background: var(--bg-700);
      border-radius: var(--radius-sm); padding: 3px; gap: 3px; margin-bottom: 1.1rem;
    }
    .login-tab {
      flex: 1; text-align: center; padding: 0.42rem;
      border-radius: 6px; font-size: 0.82rem; font-weight: 600;
      color: var(--text-300); cursor: pointer;
      transition: var(--transition); border: none; background: transparent;
    }
    .login-tab.active {
      background: var(--bg-card); color: var(--text-100);
      box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }

    /* Compact form fields */
    .auth-card .form-group { margin-bottom: 0.85rem; }
    .auth-card .form-label { font-size: 0.7rem; margin-bottom: 0.35rem; }
    .auth-card .form-control { padding: 0.58rem 0.9rem; font-size: 0.88rem; }
    .auth-card .btn { padding: 0.6rem 1.2rem; }

    .divider-text {
      display: flex; align-items: center; gap: 0.75rem;
      color: var(--text-500); font-size: 0.78rem; margin: 0.85rem 0;
    }
    .divider-text::before, .divider-text::after {
      content: ''; flex: 1; height: 1px; background: var(--border);
    }

    .demo-box {
      margin-top: 0.85rem;
      padding: 0.7rem 0.9rem;
      background: var(--bg-700); border-radius: var(--radius-sm);
      font-size: 0.75rem; color: var(--text-500); line-height: 1.6;
    }
  </style>
</head>
<body>

<div class="auth-wrap">

  <%-- ── Left brand panel ─────────────────────────── --%>
  <div class="auth-brand animate-fade">
    <div class="auth-brand-logo">VELO<span>●</span>RIDE</div>
    <p class="auth-brand-tagline">
      The fastest way to explore the city. Electric &amp; standard bikes at every corner.
    </p>
    <div style="display:flex; flex-direction:column; gap:0.5rem;">
      <div class="brand-stat">
        <div class="brand-stat-icon">🚲</div>
        <span>6+ bikes available right now</span>
      </div>
      <div class="brand-stat">
        <div class="brand-stat-icon">📍</div>
        <span>4 docking stations citywide</span>
      </div>
      <div class="brand-stat">
        <div class="brand-stat-icon">⚡</div>
        <span>Electric &amp; standard options</span>
      </div>
      <div class="brand-stat">
        <div class="brand-stat-icon">💳</div>
        <span>Pay only for what you ride</span>
      </div>
    </div>
  </div>

  <%-- ── Login card ───────────────────────────────── --%>
  <div class="auth-card animated-border">
    <a href="/" class="auth-logo">VELO<span>●</span>RIDE</a>
    <p class="text-muted mb-2" style="font-size:0.82rem;">Sign in to your account</p>

    <%-- Alerts --%>
    <c:if test="${not empty error}">
      <div class="alert alert-error" style="padding:0.6rem 0.9rem; font-size:0.82rem; margin-bottom:0.75rem;">
        <i class="bi bi-exclamation-circle"></i> ${error}
      </div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success" style="padding:0.6rem 0.9rem; font-size:0.82rem; margin-bottom:0.75rem;">
        <i class="bi bi-check-circle"></i> ${success}
      </div>
    </c:if>

    <%-- Role tabs --%>
    <div class="login-tabs">
      <button class="login-tab active" onclick="switchTab('USER', this)">🚴 Rider</button>
      <button class="login-tab" onclick="switchTab('ADMIN', this)">⚙️ Admin</button>
    </div>

    <form action="/login" method="post">
      <input type="hidden" name="loginAs" id="loginAs" value="USER" />

      <div class="form-group">
        <label class="form-label">Username</label>
        <div style="position:relative;">
          <i class="bi bi-person" style="position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--text-500);font-size:0.85rem;"></i>
          <input type="text" name="username" class="form-control" required
                 placeholder="Your username" style="padding-left:32px;" />
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Password</label>
        <div style="position:relative;">
          <i class="bi bi-lock" style="position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--text-500);font-size:0.85rem;"></i>
          <input type="password" name="password" id="passwordInput" class="form-control" required
                 placeholder="Your password" style="padding-left:32px; padding-right:38px;" />
          <button type="button" data-toggle-password="passwordInput"
                  style="position:absolute;right:10px;top:50%;transform:translateY(-50%);
                         background:none;border:none;cursor:pointer;color:var(--text-500);font-size:0.85rem;">👁</button>
        </div>
      </div>

      <button type="submit" class="btn btn-primary w-100" style="margin-top:0.25rem;">
        <i class="bi bi-box-arrow-in-right"></i> Sign In
      </button>
    </form>

    <div class="divider-text">or</div>

    <div class="text-center" style="font-size:0.82rem; color:var(--text-300);">
      No account? <a href="/register" class="text-accent fw-bold">Create one free</a>
    </div>

    <div class="demo-box">
      <strong class="text-dim">Demo:</strong>
      Rider: <code>john_doe</code> / <code>password123</code> &nbsp;|&nbsp;
      Admin: <code>admin</code> / <code>admin123</code>
    </div>
  </div>

</div>

<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  function switchTab(role, btn) {
    document.getElementById('loginAs').value = role;
    document.querySelectorAll('.login-tab').forEach(t => t.classList.remove('active'));
    btn.classList.add('active');
  }
</script>
</body>
</html>
