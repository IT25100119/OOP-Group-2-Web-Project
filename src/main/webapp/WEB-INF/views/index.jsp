<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>VeloRide — Bike Rental Platform</title>
  <link rel="stylesheet" href="/static/css/style.css" />
  <link rel="stylesheet" href="/static/css/animations.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ── Above-the-fold: hero + stats fill exactly one screen ── */
    .home-screen {
      height: 100vh;
      display: flex;
      flex-direction: column;
      padding-top: 64px; /* navbar height */
      overflow: hidden;
    }

    /* Hero row — takes remaining space above stats */
    .home-hero {
      flex: 1;
      display: flex;
      align-items: center;
      position: relative;
      overflow: hidden;
      padding: 0 0 1rem;
    }

    /* Stats strip at bottom of first screen */
    .home-stats {
      flex-shrink: 0;
      padding: 1rem 0 1.25rem;
      border-top: 1px solid var(--border);
      background: rgba(10,11,13,0.6);
      backdrop-filter: blur(10px);
    }

    .stats-row {
      display: flex;
      gap: 0;
    }
    .stat-pill {
      flex: 1;
      display: flex;
      align-items: center;
      gap: 0.85rem;
      padding: 0.6rem 1.5rem;
      border-right: 1px solid var(--border);
      transition: background 0.2s;
    }
    .stat-pill:last-child { border-right: none; }
    .stat-pill:hover { background: rgba(255,255,255,0.03); }
    .stat-pill-icon {
      width: 38px; height: 38px;
      border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1rem; flex-shrink: 0;
    }
    .stat-pill-icon.green  { background: rgba(0,229,160,0.12); color: var(--accent); }
    .stat-pill-icon.blue   { background: rgba(78,168,222,0.12);  color: var(--blue); }
    .stat-pill-icon.orange { background: rgba(255,107,53,0.12);  color: var(--orange); }
    .stat-pill-icon.yellow { background: rgba(255,193,7,0.12);   color: var(--yellow); }
    .stat-pill-number {
      font-family: var(--font-display);
      font-size: 1.6rem;
      font-weight: 700;
      line-height: 1;
      letter-spacing: -0.02em;
    }
    .stat-pill-label {
      font-size: 0.72rem;
      color: var(--text-500);
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-top: 2px;
    }

    /* Hero left content */
    .hero-left {
      position: relative; z-index: 1;
      max-width: 580px;
    }
    .hero-eyebrow-home {
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.25em;
      color: var(--accent);
      margin-bottom: 0.75rem;
      display: flex; align-items: center; gap: 10px;
    }
    .hero-eyebrow-home::before {
      content: ''; display: block;
      width: 28px; height: 2px; background: var(--accent);
    }
    .hero-h1 {
      font-family: var(--font-display);
      font-size: clamp(2.4rem, 5vw, 3.8rem);
      font-weight: 800;
      line-height: 1.05;
      letter-spacing: -0.03em;
      margin-bottom: 1rem;
      color: var(--text-100);
    }
    .hero-sub {
      font-size: 0.975rem;
      color: var(--text-300);
      line-height: 1.7;
      max-width: 420px;
      margin-bottom: 1.5rem;
    }
    .hero-ctas { display: flex; gap: 0.75rem; flex-wrap: wrap; }

    /* SVG bike — right side */
    .hero-bike {
      position: absolute; right: 0; top: 50%;
      transform: translateY(-50%);
      opacity: 0.9;
      pointer-events: none;
    }
    @media (max-width: 900px) { .hero-bike { opacity: 0.25; right: -40px; } }
    @media (max-width: 600px) {
      .hero-bike { display: none; }
      .stats-row { flex-wrap: wrap; }
      .stat-pill { flex: 0 0 50%; border-bottom: 1px solid var(--border); }
    }

    /* ── Below the fold — scroll for more ──────────────────── */
    .below-fold { position: relative; z-index: 1; }
    .scroll-hint {
      text-align: center;
      padding: 0.75rem;
      color: var(--text-500);
      font-size: 0.75rem;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      border-top: 1px solid var(--border);
      animation: fadeInUp 0.6s 1.2s ease both;
    }
    .scroll-hint i { display: block; animation: float 2s ease-in-out infinite; margin-bottom: 2px; }
  </style>
</head>
<body>

<%-- ── Navbar ─────────────────────────────────────────── --%>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/stations">Stations</a></li>
    <li><a href="/feedback">Reviews</a></li>
    <c:choose>
      <c:when test="${not empty sessionScope.loggedAdmin}">
        <li><a href="/admin/dashboard">Dashboard</a></li>
        <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
      </c:when>
      <c:when test="${not empty sessionScope.loggedUser}">
        <li><a href="/user/dashboard">My Rides</a></li>
        <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
      </c:when>
      <c:otherwise>
        <li><a href="/login">Login</a></li>
        <li><a href="/register" class="btn btn-primary btn-sm">Get Started</a></li>
      </c:otherwise>
    </c:choose>
  </ul>
</nav>

<%-- ══════════════════════════════════════════════════════════
     ABOVE THE FOLD — visible immediately, no scrolling needed
════════════════════════════════════════════════════════════ --%>
<div class="home-screen">

  <%-- Hero background glows --%>
  <div style="position:absolute; inset:0; pointer-events:none; z-index:0;">
    <div class="hero-blob hero-blob-1"></div>
    <div class="hero-blob hero-blob-2"></div>
  </div>

  <%-- ── Hero section ──────────────────────────────────── --%>
  <div class="home-hero">
    <div class="container" style="position:relative;">

      <%-- Left: Text --%>
      <div class="hero-left">
        <div class="hero-eyebrow-home animate-in">Urban Mobility, Redefined</div>

        <h1 class="hero-h1 animate-in-1">
          Ride the<br><span class="gradient-text">City Free.</span>
        </h1>

        <p class="hero-sub animate-in-2">
          Electric &amp; standard bikes across the city. Rent in seconds,
          ride anywhere, return at any docking station.
        </p>

        <div class="hero-ctas animate-in-3">
          <a href="/bikes" class="btn btn-primary btn-lg btn-magnetic">
            <i class="bi bi-bicycle"></i> Browse Bikes
          </a>
          <a href="/register" class="btn btn-ghost btn-lg">
            <i class="bi bi-person-plus"></i> Create Account
          </a>
        </div>
      </div>

      <%-- Right: SVG bike illustration --%>
      <div class="hero-bike float-slow">
        <svg width="320" height="220" viewBox="0 0 230 130" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="52" cy="88" r="36" stroke="rgba(0,229,160,0.3)" stroke-width="3"/>
          <circle cx="52" cy="88" r="28" stroke="rgba(0,229,160,0.14)" stroke-width="1.5"/>
          <circle cx="52" cy="88" r="5" fill="rgba(0,229,160,0.6)"/>
          <line x1="52" y1="52" x2="52" y2="124" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
          <line x1="16" y1="88" x2="88" y2="88" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
          <line x1="27" y1="63" x2="77" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
          <line x1="77" y1="63" x2="27" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
          <circle cx="178" cy="88" r="36" stroke="rgba(0,229,160,0.3)" stroke-width="3"/>
          <circle cx="178" cy="88" r="28" stroke="rgba(0,229,160,0.14)" stroke-width="1.5"/>
          <circle cx="178" cy="88" r="5" fill="rgba(0,229,160,0.6)"/>
          <line x1="178" y1="52" x2="178" y2="124" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
          <line x1="142" y1="88" x2="214" y2="88" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
          <line x1="153" y1="63" x2="203" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
          <line x1="203" y1="63" x2="153" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
          <path d="M52 88 L100 38 L115 88 Z" stroke="rgba(0,229,160,0.75)" stroke-width="2.8" fill="none" stroke-linejoin="round"/>
          <path d="M100 38 L178 88" stroke="rgba(0,229,160,0.75)" stroke-width="2.8" fill="none" stroke-linecap="round"/>
          <path d="M52 88 L88 54" stroke="rgba(0,229,160,0.4)" stroke-width="1.8" fill="none" stroke-linecap="round"/>
          <rect x="98" y="55" width="24" height="11" rx="4" fill="rgba(0,229,160,0.18)" stroke="rgba(0,229,160,0.6)" stroke-width="1.5"/>
          <rect x="100" y="57" width="8" height="7" rx="2" fill="rgba(0,229,160,0.55)"/>
          <line x1="108" y1="60" x2="103" y2="38" stroke="rgba(0,229,160,0.65)" stroke-width="2.5" stroke-linecap="round"/>
          <line x1="95" y1="36" x2="111" y2="36" stroke="rgba(0,229,160,0.9)" stroke-width="3.5" stroke-linecap="round"/>
          <line x1="165" y1="50" x2="160" y2="28" stroke="rgba(0,229,160,0.65)" stroke-width="2.5" stroke-linecap="round"/>
          <line x1="153" y1="28" x2="167" y2="28" stroke="rgba(0,229,160,0.9)" stroke-width="3.5" stroke-linecap="round"/>
          <circle cx="115" cy="88" r="9" stroke="rgba(0,229,160,0.5)" stroke-width="2" fill="none"/>
          <line x1="106" y1="88" x2="106" y2="96" stroke="rgba(0,229,160,0.5)" stroke-width="2.5" stroke-linecap="round"/>
          <line x1="124" y1="88" x2="124" y2="80" stroke="rgba(0,229,160,0.5)" stroke-width="2.5" stroke-linecap="round"/>
          <path d="M205 14 L198 26 L205 26 L198 40 L216 22 L209 22 Z" fill="rgba(0,229,160,0.85)"/>
          <ellipse cx="115" cy="127" rx="95" ry="5" fill="rgba(0,229,160,0.06)"/>
        </svg>
      </div>

    </div>
  </div>

  <%-- ── Stats strip — bottom of first screen ──────────── --%>
  <div class="home-stats animate-in-4">
    <div class="container">
      <div class="stats-row">
        <div class="stat-pill">
          <div class="stat-pill-icon green"><i class="bi bi-bicycle"></i></div>
          <div>
            <div class="stat-pill-number text-accent">${totalBikes}</div>
            <div class="stat-pill-label">Total Bikes</div>
          </div>
        </div>
        <div class="stat-pill">
          <div class="stat-pill-icon green"><i class="bi bi-check-circle-fill"></i></div>
          <div>
            <div class="stat-pill-number text-accent">${availBikes}</div>
            <div class="stat-pill-label">Available Now</div>
          </div>
        </div>
        <div class="stat-pill">
          <div class="stat-pill-icon blue"><i class="bi bi-geo-alt-fill"></i></div>
          <div>
            <div class="stat-pill-number text-blue">${totalStations}</div>
            <div class="stat-pill-label">Stations</div>
          </div>
        </div>
        <div class="stat-pill">
          <div class="stat-pill-icon yellow"><i class="bi bi-star-fill"></i></div>
          <div>
            <div class="stat-pill-number" style="color:var(--yellow);">${avgRating}</div>
            <div class="stat-pill-label">Avg Rating</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <%-- Scroll hint --%>
  <div class="scroll-hint">
    <i class="bi bi-chevron-down"></i>
    Scroll to explore
  </div>

</div><%-- /home-screen --%>

<%-- ══════════════════════════════════════════════════════════
     BELOW THE FOLD — scroll to see features & reviews
════════════════════════════════════════════════════════════ --%>
<div class="below-fold">

  <%-- ── Why VeloRide ─────────────────────────────────── --%>
  <section style="padding: 4rem 0;">
    <div class="container">
      <h2 class="text-center reveal" style="margin-bottom:2.5rem;">Why VeloRide?</h2>
      <div class="three-col stagger">
        <div class="card card-hover-lift" style="text-align:center; padding:2rem 1.5rem;">
          <div class="feature-icon" style="font-size:2.5rem; margin-bottom:0.85rem;">⚡</div>
          <h4 class="text-accent mb-1">Electric Bikes</h4>
          <p class="text-muted" style="font-size:0.88rem;">Long-range electric bikes for effortless commuting across the city.</p>
        </div>
        <div class="card card-hover-lift card-gradient-border" style="text-align:center; padding:2rem 1.5rem;">
          <div class="feature-icon" style="font-size:2.5rem; margin-bottom:0.85rem;">📍</div>
          <h4 class="text-accent mb-1">Multiple Stations</h4>
          <p class="text-muted" style="font-size:0.88rem;">Pick up or drop off at any of our conveniently located docking stations.</p>
        </div>
        <div class="card card-hover-lift" style="text-align:center; padding:2rem 1.5rem;">
          <div class="feature-icon" style="font-size:2.5rem; margin-bottom:0.85rem;">💳</div>
          <h4 class="text-accent mb-1">Pay Per Ride</h4>
          <p class="text-muted" style="font-size:0.88rem;">Transparent fare calculation — only pay for the time you ride.</p>
        </div>
      </div>
    </div>
  </section>

  <%-- ── Recent Reviews ──────────────────────────────── --%>
  <c:if test="${not empty recentFeedback}">
  <section style="padding: 3rem 0 4rem; border-top: 1px solid var(--border);">
    <div class="container">
      <div class="d-flex justify-between align-center mb-3">
        <h2 class="reveal">What Riders Say</h2>
        <a href="/feedback" class="btn btn-ghost btn-sm">View All <i class="bi bi-arrow-right"></i></a>
      </div>
      <div class="three-col stagger">
        <c:forEach var="fb" items="${recentFeedback}">
        <div class="card reveal">
          <div class="d-flex align-center gap-2 mb-2">
            <div style="width:36px;height:36px;background:var(--bg-700);border-radius:50%;
                        display:flex;align-items:center;justify-content:center;
                        font-family:var(--font-display);font-weight:700;color:var(--accent);font-size:0.9rem;">
              ${fb.username.substring(0,1).toUpperCase()}
            </div>
            <div>
              <div class="fw-bold" style="font-size:0.88rem;">${fb.username}</div>
              <div class="text-dim" style="font-size:0.72rem;">${fb.submittedDate}</div>
            </div>
          </div>
          <div class="stars mb-2" style="font-size:0.95rem;">
            <c:forEach begin="1" end="${fb.rating}" var="s">★</c:forEach>
            <c:forEach begin="${fb.rating+1}" end="5" var="s">
              <span style="color:var(--bg-600);">★</span>
            </c:forEach>
          </div>
          <p style="color:var(--text-300);font-size:0.875rem;line-height:1.6;">"${fb.comment}"</p>
        </div>
        </c:forEach>
      </div>
    </div>
  </section>
  </c:if>

  <%-- ── CTA ──────────────────────────────────────────── --%>
  <section style="padding:4rem 0; text-align:center;">
    <div class="container reveal">
      <h2 style="margin-bottom:0.75rem;">Ready to ride?</h2>
      <p class="text-muted" style="margin-bottom:1.75rem;">Join thousands of riders. Create your free account today.</p>
      <a href="/register" class="btn btn-primary btn-lg">Start Riding Free</a>
    </div>
  </section>

</div><%-- /below-fold --%>

<footer class="footer">
  <p>© 2026 VeloRide — Bike Rental And Ride Sharing Platform &nbsp;|&nbsp;
     SE1020 OOP Project &nbsp;|&nbsp; Group G2</p>
</footer>

<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
</body>
</html>
