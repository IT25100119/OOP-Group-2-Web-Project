<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Browse Bikes — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ─── Bike Card v2 ─────────────────────────────────────── */
    .bike-card-v2 {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
      position: relative;
      opacity: 0;
      animation: bikeCardIn 0.55s cubic-bezier(0.4,0,0.2,1) both;
      transition: transform 0.35s cubic-bezier(0.4,0,0.2,1),
                  box-shadow 0.35s ease, border-color 0.3s ease;
    }
    .bike-card-v2:hover {
      transform: translateY(-8px) scale(1.01);
      box-shadow: 0 28px 60px rgba(0,0,0,0.55), 0 0 40px rgba(0,229,160,0.1);
      border-color: rgba(0,229,160,0.35);
    }
    .bikes-grid .bike-card-v2:nth-child(1){ animation-delay:.05s; }
    .bikes-grid .bike-card-v2:nth-child(2){ animation-delay:.11s; }
    .bikes-grid .bike-card-v2:nth-child(3){ animation-delay:.17s; }
    .bikes-grid .bike-card-v2:nth-child(4){ animation-delay:.23s; }
    .bikes-grid .bike-card-v2:nth-child(5){ animation-delay:.29s; }
    .bikes-grid .bike-card-v2:nth-child(6){ animation-delay:.35s; }
    .bikes-grid .bike-card-v2:nth-child(n+7){ animation-delay:.40s; }

    /* Top accent line */
    .bike-card-v2::before {
      content:''; position:absolute; top:0; left:0; right:0; height:2px;
      background:linear-gradient(90deg,transparent,var(--accent),transparent);
      opacity:0; transition:opacity 0.3s; z-index:3;
    }
    .bike-card-v2.electric-card::before { background:linear-gradient(90deg,transparent,var(--accent),#00ffcc,transparent); }
    .bike-card-v2.standard-card::before { background:linear-gradient(90deg,transparent,var(--blue),transparent); }
    .bike-card-v2:hover::before { opacity:1; }

    /* ─── Scene (header area with SVG) ─────────────────────── */
    .bike-scene {
      position:relative; height:175px;
      background:var(--bg-700);
      display:flex; align-items:center; justify-content:center;
      overflow:hidden;
    }
    .moto-card .bike-scene {
      background:linear-gradient(160deg,#1a0e06 0%,#1e1408 100%);
    }
    .electric-card .bike-scene {
      background:linear-gradient(160deg,#0b1a14 0%,#0e1c1a 100%);
    }
    .standard-card .bike-scene {
      background:linear-gradient(160deg,#0d1420 0%,#101828 100%);
    }

    /* Scene glow floor */
    .bike-scene::after {
      content:''; position:absolute; bottom:0; left:0; right:0; height:3px;
      opacity:0.5; transition:opacity 0.3s;
    }
    .moto-card .bike-scene::after { background:linear-gradient(90deg,transparent,rgba(255,107,53,.65),transparent); }
    .electric-card .bike-scene::after {
      background:linear-gradient(90deg,transparent,var(--accent),transparent);
    }
    .standard-card .bike-scene::after {
      background:linear-gradient(90deg,transparent,var(--blue),transparent);
    }
    .bike-card-v2:hover .bike-scene::after { opacity:1; }

    /* Radial glow on hover */
    .scene-glow {
      position:absolute; bottom:-20px; left:50%;
      transform:translateX(-50%);
      width:140px; height:60px; border-radius:50%;
      opacity:0; transition:opacity 0.4s;
      filter:blur(18px);
    }
    .electric-card .scene-glow { background:rgba(0,229,160,0.35); }
    .standard-card .scene-glow { background:rgba(78,168,222,0.35); }
    .bike-card-v2:hover .scene-glow { opacity:1; }

    /* SVG wrapper with ride animation on hover */
    .bike-svg-wrap {
      position:relative; z-index:2;
      transition:transform 0.4s cubic-bezier(0.4,0,0.2,1),
                 filter 0.4s ease;
    }
    .bike-card-v2:hover .bike-svg-wrap {
      transform:translateX(8px);
      filter:drop-shadow(0 6px 16px rgba(0,229,160,0.3));
    }
    .standard-card:hover .bike-svg-wrap {
      filter:drop-shadow(0 6px 16px rgba(78,168,222,0.3));
    }

    /* Wheel rotation on hover */
    .bike-card-v2:hover .wheel-rear  { animation:wheelSpin 0.65s linear infinite; }
    .bike-card-v2:hover .wheel-front { animation:wheelSpin 0.65s linear infinite; }

    /* Speed lines */
    .speed-lines {
      position:absolute; left:8px; top:50%;
      transform:translateY(-50%);
      display:flex; flex-direction:column; gap:6px;
      opacity:0; pointer-events:none;
    }
    .bike-card-v2:hover .speed-lines { opacity:1; }
    .speed-line {
      height:2px; border-radius:1px;
      transform:scaleX(0); transform-origin:right;
    }
    .electric-card .speed-line { background:linear-gradient(to right,transparent,rgba(0,229,160,0.6)); }
    .standard-card .speed-line { background:linear-gradient(to right,transparent,rgba(78,168,222,0.5)); }
    .bike-card-v2:hover .speed-line { animation:speedLine 0.5s ease forwards; }
    .bike-card-v2:hover .speed-line:nth-child(1){ width:36px; animation-delay:0.00s; }
    .bike-card-v2:hover .speed-line:nth-child(2){ width:24px; animation-delay:0.07s; }
    .bike-card-v2:hover .speed-line:nth-child(3){ width:30px; animation-delay:0.14s; }
    .bike-card-v2:hover .speed-line:nth-child(4){ width:18px; animation-delay:0.21s; }

    /* Electric sparks */
    .spark { position:absolute; width:5px; height:5px; border-radius:50%;
              background:var(--accent); pointer-events:none; opacity:0; }
    .electric-card:hover .spark { animation:sparkFly 0.65s ease forwards; }
    .spark:nth-child(1){ top:28%; left:62%; --dx:1;  --dy:-1.5; animation-delay:0.0s; }
    .spark:nth-child(2){ top:18%; left:72%; --dx:2;  --dy:-2;   animation-delay:0.1s; }
    .spark:nth-child(3){ top:38%; left:66%; --dx:1;  --dy:1;    animation-delay:0.2s; }
    .spark:nth-child(4){ top:22%; left:57%; --dx:-1; --dy:-1;   animation-delay:0.15s;}

    /* Price pill */
    .price-pill {
      position:absolute; top:12px; right:12px; z-index:5;
      background:rgba(0,0,0,0.6); backdrop-filter:blur(10px);
      border:1px solid rgba(0,229,160,0.3); border-radius:20px;
      padding:4px 12px;
      font-family:var(--font-display); font-size:1.05rem;
      color:var(--accent);
      transition:transform 0.3s, box-shadow 0.3s;
    }
    .standard-card .price-pill { border-color:rgba(78,168,222,0.3); color:var(--blue); }
    .bike-card-v2:hover .price-pill {
      transform:scale(1.05);
      box-shadow:0 4px 16px rgba(0,229,160,0.25);
    }

    /* Status dot */
    .status-dot {
      width:9px; height:9px; border-radius:50%; flex-shrink:0;
    }
    .status-dot.available { background:var(--accent); box-shadow:0 0 7px var(--accent);
                             animation:pulseDot 1.5s ease-out infinite; }
    .status-dot.inuse     { background:var(--orange); }
    .status-dot.maint     { background:var(--yellow); }

    /* Battery bar */
    .battery-wrap { display:flex; align-items:center; gap:7px; }
    .battery-shell { flex:1; height:5px; background:var(--bg-700); border-radius:3px; overflow:hidden; }
    .battery-fill  { height:100%; background:linear-gradient(90deg,var(--accent),#00ffb3);
                     border-radius:3px; transition:width 1.4s cubic-bezier(0.4,0,0.2,1);
                     background-size:200% 100%; animation:shimmer 2.5s linear infinite; }

    /* Gear dots */
    .gear-row { display:flex; align-items:center; gap:4px; }
    .g-dot { width:6px; height:6px; border-radius:50%; background:var(--bg-600);
              transition:background 0.2s, box-shadow 0.2s; }
    .g-dot.on { background:var(--blue); box-shadow:0 0 4px var(--blue); }

    /* Fleet hero banner */
    .fleet-banner {
      background:var(--bg-700); border:1px solid var(--border);
      border-radius:16px; padding:2rem 2.5rem;
      margin-bottom:2rem; position:relative; overflow:hidden;
      display:flex; align-items:center; justify-content:space-between; gap:2rem;
      animation:fadeInUp 0.5s ease both;
    }
    .fleet-banner::before {
      content:''; position:absolute; inset:0;
      background:radial-gradient(ellipse 55% 90% at 85% 50%,
        rgba(0,229,160,0.07) 0%,transparent 65%);
    }

    /* Filter chips */
    .filter-chips { display:flex; gap:.5rem; flex-wrap:wrap; margin-bottom:1.25rem; }
    .chip {
      padding:5px 15px; border-radius:99px; font-size:.8rem;
      border:1px solid var(--border); background:var(--bg-700);
      color:var(--text-300); cursor:pointer; text-decoration:none;
      transition:all 0.2s ease;
    }
    .chip:hover,.chip.active {
      border-color:var(--accent); color:var(--accent);
      background:rgba(0,229,160,0.08);
    }

    /* Keyframes */
    @keyframes bikeCardIn {
      from{ opacity:0; transform:translateY(30px) scale(0.95); }
      to  { opacity:1; transform:translateY(0)     scale(1); }
    }
    @keyframes wheelSpin {
      to{ transform:rotate(360deg); }
    }
    @keyframes speedLine {
      from{ transform:scaleX(0); opacity:0; }
      50% { opacity:1; }
      to  { transform:scaleX(1); opacity:0.5; }
    }
    @keyframes sparkFly {
      0%  { opacity:1; transform:translate(0,0) scale(1); }
      100%{ opacity:0; transform:translate(calc(var(--dx)*20px),calc(var(--dy)*18px)) scale(0); }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes" class="active">Bikes</a></li>
    <li><a href="/stations">Stations</a></li>
    <li><a href="/feedback">Reviews</a></li>
    <c:choose>
      <c:when test="${not empty sessionAdmin}">
        <li><a href="/admin/dashboard">Dashboard</a></li>
        <li><a href="/bikes/add" class="btn btn-primary btn-sm"><i class="bi bi-plus"></i> Add Bike</a></li>
      </c:when>
      <c:when test="${not empty sessionUser}">
        <li><a href="/user/dashboard">My Dashboard</a></li>
        <li><a href="/rides/rent" class="btn btn-primary btn-sm">Rent Now</a></li>
      </c:when>
      <c:otherwise>
        <li><a href="/login">Login</a></li>
      </c:otherwise>
    </c:choose>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem;">

  <%-- ── Fleet Hero Banner ──────────────────────────────────── --%>
  <div class="fleet-banner">
    <div style="position:relative; z-index:1;">
      <div class="hero-eyebrow" style="font-size:.75rem; margin-bottom:.5rem;">
        <span class="live-dot"></span> Live Fleet — Updated in real time
      </div>
      <h2 style="margin-bottom:.5rem; font-size:2.2rem;">Browse Our Bikes</h2>
      <p class="text-muted" style="font-size:.9rem; max-width:360px; line-height:1.6;">
        Electric &amp; standard bikes, sorted by availability.
        Hover a card to see it come alive.
      </p>
    </div>

    <%-- Decorative large hero bike SVG --%>
    <div class="float-slow" style="position:relative; z-index:1; flex-shrink:0;">
      <svg width="230" height="130" viewBox="0 0 230 130" fill="none" xmlns="http://www.w3.org/2000/svg">
        <!-- Rear wheel -->
        <circle cx="52" cy="88" r="36" stroke="rgba(0,229,160,0.28)" stroke-width="3"/>
        <circle cx="52" cy="88" r="28" stroke="rgba(0,229,160,0.14)" stroke-width="1.5"/>
        <circle cx="52" cy="88" r="5" fill="rgba(0,229,160,0.6)"/>
        <line x1="52" y1="52" x2="52" y2="124" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
        <line x1="16" y1="88" x2="88" y2="88"  stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
        <line x1="27" y1="63" x2="77" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
        <line x1="77" y1="63" x2="27" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
        <!-- Front wheel -->
        <circle cx="178" cy="88" r="36" stroke="rgba(0,229,160,0.28)" stroke-width="3"/>
        <circle cx="178" cy="88" r="28" stroke="rgba(0,229,160,0.14)" stroke-width="1.5"/>
        <circle cx="178" cy="88" r="5" fill="rgba(0,229,160,0.6)"/>
        <line x1="178" y1="52" x2="178" y2="124" stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
        <line x1="142" y1="88" x2="214" y2="88"  stroke="rgba(0,229,160,0.22)" stroke-width="1.2"/>
        <line x1="153" y1="63" x2="203" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
        <line x1="203" y1="63" x2="153" y2="113" stroke="rgba(0,229,160,0.15)" stroke-width="1"/>
        <!-- Frame -->
        <path d="M52 88 L100 38 L115 88 Z" stroke="rgba(0,229,160,0.75)" stroke-width="2.8" fill="none" stroke-linejoin="round"/>
        <path d="M100 38 L178 88" stroke="rgba(0,229,160,0.75)" stroke-width="2.8" fill="none" stroke-linecap="round"/>
        <!-- Seat stays -->
        <path d="M52 88 L88 54" stroke="rgba(0,229,160,0.4)" stroke-width="1.8" fill="none" stroke-linecap="round"/>
        <!-- Battery pack -->
        <rect x="98" y="55" width="24" height="11" rx="4" fill="rgba(0,229,160,0.18)" stroke="rgba(0,229,160,0.6)" stroke-width="1.5"/>
        <rect x="100" y="57" width="8" height="7" rx="2" fill="rgba(0,229,160,0.55)"/>
        <!-- Seat post -->
        <line x1="108" y1="60" x2="103" y2="38" stroke="rgba(0,229,160,0.65)" stroke-width="2.5" stroke-linecap="round"/>
        <line x1="95"  y1="36" x2="111" y2="36" stroke="rgba(0,229,160,0.9)"  stroke-width="3.5" stroke-linecap="round"/>
        <!-- Handlebar -->
        <line x1="165" y1="50" x2="160" y2="28" stroke="rgba(0,229,160,0.6)"  stroke-width="2.5" stroke-linecap="round"/>
        <line x1="153" y1="28" x2="167" y2="28" stroke="rgba(0,229,160,0.9)"  stroke-width="3.5" stroke-linecap="round"/>
        <!-- Pedal -->
        <circle cx="115" cy="88" r="9" stroke="rgba(0,229,160,0.45)" stroke-width="2" fill="none"/>
        <line x1="106" y1="88" x2="106" y2="98" stroke="rgba(0,229,160,0.45)" stroke-width="2.5" stroke-linecap="round"/>
        <line x1="124" y1="88" x2="124" y2="78" stroke="rgba(0,229,160,0.45)" stroke-width="2.5" stroke-linecap="round"/>
        <!-- Lightning bolt -->
        <path d="M205 14 L198 26 L205 26 L198 40 L216 22 L209 22 Z" fill="rgba(0,229,160,0.85)"/>
        <!-- Front light beam -->
        <line x1="183" y1="55" x2="196" y2="49" stroke="rgba(0,229,160,0.4)" stroke-width="2" stroke-linecap="round"/>
        <line x1="183" y1="59" x2="198" y2="58" stroke="rgba(0,229,160,0.3)" stroke-width="2" stroke-linecap="round"/>
        <!-- Ground shadow ellipse -->
        <ellipse cx="115" cy="127" rx="95" ry="6" fill="rgba(0,229,160,0.06)"/>
      </svg>
    </div>
  </div>

  <%-- ── Filters + Search ───────────────────────────────────── --%>
  <div class="animate-in-1 mb-3">
    <div class="filter-chips">
      <a href="/bikes"           class="chip ${empty search ? 'active':''}">All Bikes</a>
      <a href="/bikes"           class="chip">⚡ Available First</a>
      <a href="/bikes?sort=price"class="chip">💰 Cheapest First</a>
    </div>
    <form action="/bikes" method="get" class="d-flex gap-1">
      <div class="search-bar" style="flex:1;">
        <i class="bi bi-search" style="color:var(--text-500);"></i>
        <input type="text" name="search" placeholder="Search by model, type, or ID…"
               value="${not empty search ? search : ''}"/>
      </div>
      <button type="submit" class="btn btn-primary">Search</button>
      <c:if test="${not empty search}">
        <a href="/bikes" class="btn btn-ghost">Clear</a>
      </c:if>
    </form>
  </div>

  <%-- ── Bike Grid ──────────────────────────────────────────── --%>
  <c:choose>
    <c:when test="${empty bikes}">
      <div class="card text-center" style="padding:5rem;">
        <svg width="90" height="90" viewBox="0 0 90 90" style="margin:0 auto 1.2rem; opacity:.22;">
          <circle cx="22" cy="62" r="20" stroke="#00e5a0" stroke-width="2.5" fill="none"/>
          <circle cx="68" cy="62" r="20" stroke="#00e5a0" stroke-width="2.5" fill="none"/>
          <path d="M22 62 L40 24 L48 62 Z" stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linejoin="round"/>
          <path d="M40 24 L68 62" stroke="#00e5a0" stroke-width="2.2" fill="none"/>
        </svg>
        <h3 class="text-muted">No bikes found</h3>
        <c:if test="${not empty sessionAdmin}">
          <a href="/bikes/add" class="btn btn-primary mt-2">Add First Bike</a>
        </c:if>
      </div>
    </c:when>

    <c:otherwise>
      <div class="bikes-grid">
        <c:forEach var="bike" items="${bikes}">

        <div class="bike-card-v2 ${bike.type == 'ELECTRIC' ? 'electric-card' : bike.type == 'MOTO' ? 'moto-card' : 'standard-card'}">

          <%-- ── Scene ──────────────────────────────────────── --%>
          <div class="bike-scene">
            <div class="scene-glow"></div>

            <%-- Speed lines --%>
            <div class="speed-lines">
              <div class="speed-line"></div>
              <div class="speed-line"></div>
              <div class="speed-line"></div>
              <div class="speed-line"></div>
            </div>

            <%-- Sparks (electric only) --%>
            <div class="spark"></div>
            <div class="spark"></div>
            <div class="spark"></div>
            <div class="spark"></div>

            <%-- SVG Illustration --%>
            <div class="bike-svg-wrap">
              <c:choose>

                <%-- ── ELECTRIC BIKE ─────────────────────── --%>
                <c:when test="${bike.type == 'ELECTRIC'}">
                  <svg width="155" height="96" viewBox="0 0 155 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <defs>
                      <filter id="eg"><feGaussianBlur stdDeviation="2.5" result="b"/>
                        <feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge>
                      </filter>
                    </defs>
                    <!-- Rear wheel -->
                    <circle class="wheel-rear"  cx="30" cy="66" r="24" stroke="#00e5a0"              stroke-width="2.5" fill="none" transform-origin="30 66"/>
                    <circle                      cx="30" cy="66" r="18" stroke="rgba(0,229,160,.22)" stroke-width="1.2" fill="none"/>
                    <circle                      cx="30" cy="66" r="4"  fill="#00e5a0" opacity=".85"/>
                    <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1.1"/>
                    <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1.1"/>
                    <line x1="13" y1="49" x2="47" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                    <line x1="47" y1="49" x2="13" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                    <!-- Front wheel -->
                    <circle class="wheel-front" cx="125" cy="66" r="24" stroke="#00e5a0"              stroke-width="2.5" fill="none" transform-origin="125 66"/>
                    <circle                      cx="125" cy="66" r="18" stroke="rgba(0,229,160,.22)" stroke-width="1.2" fill="none"/>
                    <circle                      cx="125" cy="66" r="4"  fill="#00e5a0" opacity=".85"/>
                    <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1.1"/>
                    <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1.1"/>
                    <line x1="108" y1="49" x2="142" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                    <line x1="142" y1="49" x2="108" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                    <!-- Battery block on down tube -->
                    <rect x="65" y="42" width="20" height="10" rx="3" fill="rgba(0,229,160,.18)" stroke="rgba(0,229,160,.55)" stroke-width="1.3"/>
                    <rect x="67" y="44" width="6"  height="6"  rx="1.5" fill="rgba(0,229,160,.7)"/>
                    <!-- Main frame -->
                    <path d="M30 66 L68 26 L78 66 Z"  stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                    <path d="M68 26 L125 66"           stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linecap="round"/>
                    <path d="M30 66 L58 42"            stroke="rgba(0,229,160,.45)" stroke-width="1.6" fill="none" stroke-linecap="round"/>
                    <!-- Seat post -->
                    <line x1="76" y1="48" x2="72" y2="30" stroke="rgba(0,229,160,.65)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="65" y1="28" x2="79" y2="28" stroke="#00e5a0"              stroke-width="3.2" stroke-linecap="round"/>
                    <!-- Handlebar -->
                    <line x1="116" y1="42" x2="111" y2="24" stroke="rgba(0,229,160,.65)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="105" y1="24" x2="117" y2="24" stroke="#00e5a0"              stroke-width="3.2" stroke-linecap="round"/>
                    <!-- Pedal crank -->
                    <circle cx="78" cy="66" r="7" stroke="rgba(0,229,160,.5)" stroke-width="1.8" fill="none"/>
                    <line x1="71" y1="66" x2="71" y2="74" stroke="rgba(0,229,160,.5)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="85" y1="66" x2="85" y2="58" stroke="rgba(0,229,160,.5)" stroke-width="2.2" stroke-linecap="round"/>
                    <!-- Front light -->
                    <circle cx="128" cy="47" r="4" fill="rgba(0,229,160,.2)" stroke="rgba(0,229,160,.6)" stroke-width="1.2"/>
                    <line x1="132" y1="45" x2="138" y2="41" stroke="rgba(0,229,160,.45)" stroke-width="1.5" stroke-linecap="round"/>
                    <line x1="132" y1="48" x2="139" y2="48" stroke="rgba(0,229,160,.35)" stroke-width="1.5" stroke-linecap="round"/>
                    <!-- Lightning bolt (glowing) -->
                    <path d="M138 6 L132 17 L138 17 L132 28 L148 13 L142 13 Z"
                          fill="#00e5a0" filter="url(#eg)" opacity=".95"/>
                    <!-- Ground shadow -->
                    <ellipse cx="77" cy="93" rx="58" ry="4" fill="rgba(0,229,160,.07)"/>
                  </svg>
                </c:when>

                <%-- ── MOTO BIKE ──────────────────────────── --%>
                <c:when test="${bike.type == 'MOTO'}">
                  <svg width="155" height="96" viewBox="0 0 155 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <!-- Rear wheel -->
                    <circle class="wheel-rear"  cx="28" cy="68" r="22" stroke="rgba(255,107,53,.9)"  stroke-width="2.5" fill="none" transform-origin="28 68"/>
                    <circle cx="28" cy="68" r="16" stroke="rgba(255,107,53,.2)" stroke-width="1.2" fill="none"/>
                    <circle cx="28" cy="68" r="4"  fill="rgba(255,107,53,.9)"/>
                    <line x1="28" y1="46" x2="28" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                    <line x1="6"  y1="68" x2="50" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                    <line x1="12" y1="52" x2="44" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                    <line x1="44" y1="52" x2="12" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                    <!-- Front wheel -->
                    <circle class="wheel-front" cx="127" cy="68" r="22" stroke="rgba(255,107,53,.9)"  stroke-width="2.5" fill="none" transform-origin="127 68"/>
                    <circle cx="127" cy="68" r="16" stroke="rgba(255,107,53,.2)" stroke-width="1.2" fill="none"/>
                    <circle cx="127" cy="68" r="4"  fill="rgba(255,107,53,.9)"/>
                    <line x1="127" y1="46" x2="127" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                    <line x1="105" y1="68" x2="149" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                    <line x1="111" y1="52" x2="143" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                    <line x1="143" y1="52" x2="111" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                    <!-- Chassis frame (swingarm style) -->
                    <path d="M28 68 L55 38 L95 38 L127 68" stroke="rgba(255,107,53,.85)" stroke-width="2.5" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                    <!-- Engine block -->
                    <rect x="62" y="52" width="32" height="20" rx="4" fill="rgba(255,107,53,.18)" stroke="rgba(255,107,53,.6)" stroke-width="1.5"/>
                    <!-- Exhaust pipe -->
                    <path d="M62 68 L40 75 L35 82" stroke="rgba(255,107,53,.5)" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                    <!-- Fuel tank (curved top) -->
                    <path d="M58 38 Q78 22 98 38" stroke="rgba(255,107,53,.7)" stroke-width="2.5" fill="rgba(255,107,53,.12)" stroke-linecap="round"/>
                    <!-- Seat -->
                    <path d="M82 38 Q95 34 108 36" stroke="rgba(255,107,53,.6)" stroke-width="3" fill="none" stroke-linecap="round"/>
                    <!-- Handlebar (right side) -->
                    <line x1="110" y1="38" x2="118" y2="28" stroke="rgba(255,107,53,.6)" stroke-width="2.5" stroke-linecap="round"/>
                    <line x1="113" y1="25" x2="123" y2="30" stroke="rgba(255,107,53,.85)" stroke-width="3" stroke-linecap="round"/>
                    <!-- Fork (front) -->
                    <line x1="118" y1="44" x2="127" y2="46" stroke="rgba(255,107,53,.5)" stroke-width="2" stroke-linecap="round"/>
                    <!-- Headlight -->
                    <circle cx="130" cy="46" r="5" fill="rgba(255,107,53,.2)" stroke="rgba(255,107,53,.7)" stroke-width="1.5"/>
                    <line x1="135" y1="43" x2="142" y2="39" stroke="rgba(255,107,53,.5)" stroke-width="1.5" stroke-linecap="round"/>
                    <line x1="135" y1="47" x2="143" y2="46" stroke="rgba(255,107,53,.4)" stroke-width="1.5" stroke-linecap="round"/>
                    <!-- Rider silhouette (minimal) -->
                    <circle cx="90" cy="28" r="7" stroke="rgba(255,107,53,.4)" stroke-width="1.5" fill="rgba(255,107,53,.1)"/>
                    <path d="M84 34 Q88 42 85 50" stroke="rgba(255,107,53,.35)" stroke-width="2" fill="none" stroke-linecap="round"/>
                    <!-- Ground shadow -->
                    <ellipse cx="77" cy="93" rx="60" ry="4" fill="rgba(255,107,53,.07)"/>
                  </svg>
                </c:when>

                <%-- ── STANDARD BIKE ──────────────────────── --%>
                <c:otherwise>
                  <svg width="155" height="96" viewBox="0 0 155 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <!-- Rear wheel -->
                    <circle class="wheel-rear"  cx="30" cy="66" r="24" stroke="rgba(78,168,222,.85)"  stroke-width="2.5" fill="none" transform-origin="30 66"/>
                    <circle                      cx="30" cy="66" r="18" stroke="rgba(78,168,222,.2)"   stroke-width="1.2" fill="none"/>
                    <circle                      cx="30" cy="66" r="4"  fill="rgba(78,168,222,.85)"/>
                    <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1.1"/>
                    <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1.1"/>
                    <line x1="13" y1="49" x2="47" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                    <line x1="47" y1="49" x2="13" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                    <!-- Front wheel -->
                    <circle class="wheel-front" cx="125" cy="66" r="24" stroke="rgba(78,168,222,.85)"  stroke-width="2.5" fill="none" transform-origin="125 66"/>
                    <circle                      cx="125" cy="66" r="18" stroke="rgba(78,168,222,.2)"   stroke-width="1.2" fill="none"/>
                    <circle                      cx="125" cy="66" r="4"  fill="rgba(78,168,222,.85)"/>
                    <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1.1"/>
                    <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1.1"/>
                    <line x1="108" y1="49" x2="142" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                    <line x1="142" y1="49" x2="108" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                    <!-- Frame triangle -->
                    <path d="M30 66 L68 26 L78 66 Z"  stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                    <path d="M68 26 L125 66"           stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none" stroke-linecap="round"/>
                    <path d="M30 66 L58 42"            stroke="rgba(78,168,222,.45)" stroke-width="1.6" fill="none" stroke-linecap="round"/>
                    <!-- Top tube -->
                    <line x1="68"  y1="26" x2="108" y2="26" stroke="rgba(78,168,222,.45)" stroke-width="1.5" stroke-linecap="round"/>
                    <!-- Seat post -->
                    <line x1="76"  y1="48" x2="72"  y2="30" stroke="rgba(78,168,222,.65)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="65"  y1="28" x2="79"  y2="28" stroke="rgba(78,168,222,.95)" stroke-width="3.2" stroke-linecap="round"/>
                    <!-- Handlebar stem -->
                    <line x1="108" y1="26" x2="108" y2="16" stroke="rgba(78,168,222,.65)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="102" y1="16" x2="114" y2="16" stroke="rgba(78,168,222,.95)" stroke-width="3.2" stroke-linecap="round"/>
                    <line x1="125" y1="42" x2="116" y2="26" stroke="rgba(78,168,222,.45)" stroke-width="1.6" stroke-linecap="round"/>
                    <!-- Pedal -->
                    <circle cx="78" cy="66" r="7" stroke="rgba(78,168,222,.5)" stroke-width="1.8" fill="none"/>
                    <line x1="71" y1="66" x2="71" y2="74" stroke="rgba(78,168,222,.5)" stroke-width="2.2" stroke-linecap="round"/>
                    <line x1="85" y1="66" x2="85" y2="58" stroke="rgba(78,168,222,.5)" stroke-width="2.2" stroke-linecap="round"/>
                    <!-- Basket (front) -->
                    <rect x="108" y="16" width="16" height="11" rx="2"
                          stroke="rgba(78,168,222,.4)" stroke-width="1.2" fill="rgba(78,168,222,.06)"/>
                    <line x1="108" y1="20" x2="124" y2="20" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                    <line x1="108" y1="24" x2="124" y2="24" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                    <!-- Ground shadow -->
                    <ellipse cx="77" cy="93" rx="58" ry="4" fill="rgba(78,168,222,.06)"/>
                  </svg>
                </c:otherwise>
              </c:choose>
            </div>

            <%-- Price pill --%>
            <div class="price-pill">
              ₨<fmt:formatNumber value="${bike.pricePerHour * 320.34}" pattern="#,##0"/><span style="font-size:.62rem; font-family:var(--font-body); opacity:.7;">/hr</span>
            </div>

          </div><%-- /bike-scene --%>

          <%-- ── Card Body ─────────────────────────────────── --%>
          <div style="padding:1.1rem 1.25rem 1.25rem;">

            <%-- Title + status --%>
            <div class="d-flex justify-between align-center mb-1">
              <div style="font-family:var(--font-display); font-size:1.12rem; letter-spacing:-0.03em;">
                ${bike.model}
              </div>
              <div style="display:flex; align-items:center; gap:6px;">
                <div class="status-dot ${bike.status=='AVAILABLE'?'available':bike.status=='IN_USE'?'inuse':'maint'}"></div>
                <c:choose>
                  <c:when test="${bike.status=='AVAILABLE'}"><span class="badge badge-available" style="font-size:.68rem;">Available</span></c:when>
                  <c:when test="${bike.status=='IN_USE'}">   <span class="badge badge-inuse"      style="font-size:.68rem;">In Use</span></c:when>
                  <c:otherwise>                              <span class="badge badge-maintenance" style="font-size:.68rem;">Maint.</span></c:otherwise>
                </c:choose>
              </div>
            </div>

            <%-- Type badge --%>
            <span class="badge ${bike.type=='ELECTRIC'?'badge-active':bike.type=='MOTO'?'badge-inuse':''}" style="font-size:.68rem; margin-bottom:.65rem; display:inline-block;">
              ${bike.type=='ELECTRIC'?'⚡':bike.type=='MOTO'?'🏍️':'🚲'} ${bike.type}
            </span>

            <%-- Battery / gear / engine indicator --%>
            <c:choose>
              <c:when test="${bike.type == 'MOTO'}">
                <div class="gear-row mb-2">
                  <i class="bi bi-speedometer2" style="color:var(--orange); font-size:.85rem; margin-right:5px;"></i>
                  <span class="text-muted" style="font-size:.8rem;">Motorbike</span>
                  <span class="text-dim" style="font-size:.72rem; margin-left:auto;">2× fare rate</span>
                </div>
              </c:when>
              <c:when test="${bike.type == 'ELECTRIC'}">
                <div class="battery-wrap mb-2">
                  <i class="bi bi-battery-half" style="color:var(--accent); font-size:.82rem;"></i>
                  <div class="battery-shell">
                    <div class="battery-fill" data-pct="80" style="width:0;"></div>
                  </div>
                  <span class="text-dim" style="font-size:.72rem; white-space:nowrap;">80%</span>
                </div>
              </c:when>
              <c:otherwise>
                <div class="gear-row mb-2">
                  <i class="bi bi-gear-wide-connected" style="color:var(--blue); font-size:.8rem; margin-right:4px;"></i>
                  <c:forEach begin="1" end="7" var="g">
                    <div class="g-dot" data-gear="${g}"></div>
                  </c:forEach>
                  <span class="text-dim" style="font-size:.72rem; margin-left:5px;">21 gears</span>
                </div>
              </c:otherwise>
            </c:choose>

            <%-- Rental Packages --%>
            <c:set var="bikePkgs" value="${packagesByBike[bike.bikeId]}"/>
            <c:if test="${not empty bikePkgs}">
            <div style="margin-bottom:.85rem;">
              <div style="font-size:.68rem; color:var(--text-400); text-transform:uppercase; letter-spacing:.06em; margin-bottom:.35rem;">
                <i class="bi bi-tags"></i> Packages
              </div>
              <div style="display:flex; flex-wrap:wrap; gap:.3rem;">
                <c:forEach var="pkg" items="${bikePkgs}">
                <span style="font-size:.72rem; padding:.2rem .55rem; border-radius:99px;
                  background:${pkg.type=='HOUR'?'rgba(0,229,160,.1)':'rgba(78,168,222,.1)'};
                  color:${pkg.type=='HOUR'?'var(--accent)':'var(--blue)'};
                  border:1px solid ${pkg.type=='HOUR'?'rgba(0,229,160,.3)':'rgba(78,168,222,.3)'};
                  white-space:nowrap;">
                  ${pkg.duration}${pkg.type=='HOUR'?'h':'d'} — ₨<fmt:formatNumber value="${pkg.price * 320.34}" pattern="#,##0"/>
                </span>
                </c:forEach>
              </div>
            </div>
            </c:if>

            <%-- Station --%>
            <div class="text-muted" style="font-size:.78rem; margin-bottom:1rem; display:flex; align-items:center; gap:5px;">
              <i class="bi bi-geo-alt-fill" style="color:${bike.type=='ELECTRIC'?'var(--accent)':'var(--blue)'};"></i>
              <code style="font-size:.72rem; color:var(--text-400);">${bike.stationId}</code>
            </div>

            <%-- Actions --%>
            <c:choose>
              <c:when test="${not empty sessionUser && bike.status=='AVAILABLE'}">
                <a href="/rides/rent?bikeId=${bike.bikeId}" class="btn btn-primary btn-sm w-100 btn-magnetic">
                  <i class="bi bi-play-circle-fill"></i> Rent This Bike
                </a>
              </c:when>
              <c:when test="${not empty sessionAdmin}">
                <div class="d-flex gap-1">
                  <a href="/bikes/edit/${bike.bikeId}" class="btn btn-outline btn-sm" style="flex:1; border-color:rgba(0,229,160,0.35); color:var(--accent);">
                    <i class="bi bi-pencil-fill"></i> Edit
                  </a>
                  <form action="/bikes/delete" method="post">
                    <input type="hidden" name="bikeId" value="${bike.bikeId}"/>
                    <button class="btn btn-danger btn-sm" data-confirm="Remove this bike?">
                      <i class="bi bi-trash"></i>
                    </button>
                  </form>
                </div>
              </c:when>
              <c:when test="${bike.status=='IN_USE'}">
                <button class="btn btn-ghost btn-sm w-100" disabled style="opacity:.45; cursor:not-allowed;">
                  <i class="bi bi-clock-history"></i> Currently In Use
                </button>
              </c:when>
              <c:otherwise>
                <a href="/login" class="btn btn-outline btn-sm w-100">
                  <i class="bi bi-box-arrow-in-right"></i> Login to Rent
                </a>
              </c:otherwise>
            </c:choose>

          </div><%-- /card body --%>
        </div><%-- /bike-card-v2 --%>

        </c:forEach>
      </div><%-- /bikes-grid --%>
    </c:otherwise>
  </c:choose>

</div>
</div>

<footer class="footer"><p>© 2026 VeloRide — Bike Rental Platform</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  // ── Animate battery bars ────────────────────────────────────
  document.querySelectorAll('.battery-fill').forEach(bar => {
    const pct = bar.dataset.pct || '80';
    setTimeout(() => {
      bar.style.transition = 'width 1.5s cubic-bezier(.4,0,.2,1)';
      bar.style.width = pct + '%';
    }, 350);
  });

  // ── Animate gear dots sequentially ─────────────────────────
  document.querySelectorAll('.gear-row').forEach(row => {
    const dots = row.querySelectorAll('.g-dot');
    dots.forEach((d, i) => {
      setTimeout(() => d.classList.add('on'), 500 + i * 90);
    });
  });

  // ── 3-D tilt on bike cards ──────────────────────────────────
  document.querySelectorAll('.bike-card-v2').forEach(card => {
    card.addEventListener('mousemove', e => {
      const r   = card.getBoundingClientRect();
      const dx  = (e.clientX - r.left - r.width  / 2) / (r.width  / 2);
      const dy  = (e.clientY - r.top  - r.height / 2) / (r.height / 2);
      card.style.transform = `perspective(700px) rotateX(${-dy*5}deg) rotateY(${dx*5}deg) translateY(-8px) scale(1.01)`;
      card.style.transition = 'transform 0.05s ease';
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform  = '';
      card.style.transition = 'transform 0.45s cubic-bezier(.4,0,.2,1), box-shadow .35s ease, border-color .3s ease';
    });
  });
</script>
</body>
</html>
