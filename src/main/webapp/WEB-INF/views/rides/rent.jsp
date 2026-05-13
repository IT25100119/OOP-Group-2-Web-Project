<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Rent a Bike — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ─── Step indicator ─────────────────────────────── */
    .steps { display:flex; align-items:center; gap:.5rem; margin-bottom:1.75rem; flex-wrap:wrap; }
    .step-node { display:flex; align-items:center; gap:.5rem; }
    .step-dot {
      width:28px; height:28px; border-radius:50%; flex-shrink:0;
      display:flex; align-items:center; justify-content:center;
      font-size:.78rem; font-weight:700; transition:all .3s ease;
    }
    .step-dot.pending  { background:var(--bg-700); color:var(--text-500); border:1.5px solid var(--border); }
    .step-dot.active   { background:var(--accent); color:#000; }
    .step-dot.complete { background:rgba(0,229,160,.2); color:var(--accent); border:1.5px solid var(--accent); }
    .step-label { font-size:.8rem; font-weight:600; color:var(--text-500); transition:color .3s; }
    .step-label.active   { color:var(--text-100); }
    .step-label.complete { color:var(--accent); }
    .step-line { flex:1; height:1.5px; background:var(--border); transition:background .4s; min-width:20px; }
    .step-line.complete { background:var(--accent); }

    /* ─── Station cards ──────────────────────────────── */
    .station-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(210px,1fr)); gap:.75rem; }
    .station-card {
      background:var(--bg-700); border:1.5px solid var(--border);
      border-radius:12px; padding:1.1rem 1.15rem; cursor:pointer;
      transition:all .2s ease; position:relative; user-select:none;
    }
    .station-card:hover { border-color:rgba(0,229,160,.4); background:rgba(0,229,160,.04); }
    .station-card.selected { border-color:var(--accent); background:rgba(0,229,160,.08); box-shadow:0 0 0 3px rgba(0,229,160,.15); }
    .station-card.no-bikes { opacity:.55; cursor:not-allowed; }
    .station-card.no-bikes:hover { border-color:var(--border); background:var(--bg-700); }
    .station-tick { position:absolute; top:9px; right:9px; width:20px; height:20px; border-radius:50%; background:var(--accent); color:#000; font-size:.7rem; font-weight:900; display:none; align-items:center; justify-content:center; }
    .station-card.selected .station-tick { display:flex; }
    .station-name { font-weight:700; font-size:.92rem; margin-bottom:.2rem; }
    .station-loc  { font-size:.75rem; color:var(--text-300); margin-bottom:.65rem; }
    .avail-badge  { display:inline-flex; align-items:center; gap:5px; padding:3px 10px; border-radius:99px; font-size:.72rem; font-weight:700; }
    .avail-badge.has  { background:rgba(0,229,160,.12); color:var(--accent); }
    .avail-badge.none { background:rgba(84,94,119,.2);  color:var(--text-500); }

    /* ─── Bike panel ─────────────────────────────────── */
    .section-panel { display:none; }
    .section-panel.show { display:block; animation:fadeInUp .35s ease both; }
    .station-context-bar {
      display:flex; align-items:center; justify-content:space-between;
      background:rgba(0,229,160,.07); border:1px solid rgba(0,229,160,.2);
      border-radius:10px; padding:.75rem 1.1rem; margin-bottom:1rem;
    }
    .ctx-label { font-size:.72rem; text-transform:uppercase; letter-spacing:.1em; color:var(--accent); }
    .ctx-name  { font-weight:700; font-size:1rem; }
    .ctx-count { font-size:.82rem; color:var(--text-300); }
    .bikes-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(200px,1fr)); gap:.75rem; }

    /* ─── Bike select card ───────────────────────────── */
    .bike-pick-card {
      background:var(--bg-card); border:1.5px solid var(--border);
      border-radius:12px; overflow:hidden; cursor:pointer;
      transition:all .25s ease; position:relative;
    }
    .bike-pick-card:hover { border-color:rgba(0,229,160,.35); transform:translateY(-3px); box-shadow:0 8px 20px rgba(0,0,0,.3); }
    .bike-pick-card.chosen { border-color:var(--accent); box-shadow:0 0 0 3px rgba(0,229,160,.2), 0 8px 24px rgba(0,0,0,.4); transform:translateY(-4px); }
    .bike-pick-card .chosen-badge { display:none; position:absolute; top:8px; right:8px; background:var(--accent); color:#000; padding:2px 9px; border-radius:99px; font-size:.65rem; font-weight:800; text-transform:uppercase; letter-spacing:.06em; }
    .bike-pick-card.chosen .chosen-badge { display:block; }
    .at-station-tag { display:inline-flex; align-items:center; gap:4px; background:rgba(0,229,160,.12); color:var(--accent); border:1px solid rgba(0,229,160,.25); border-radius:99px; padding:2px 8px; font-size:.65rem; font-weight:700; letter-spacing:.04em; margin-top:4px; }
    .bike-scene-mini { height:95px; display:flex; align-items:center; justify-content:center; position:relative; overflow:hidden; }
    .e-bg { background:linear-gradient(160deg,#0b1a14,#0e1c1a); }
    .s-bg { background:linear-gradient(160deg,#0d1420,#101828); }
    .m-bg { background:linear-gradient(160deg,#1a0e06,#1e1408); }
    .e-bg::after,.s-bg::after,.m-bg::after { content:''; position:absolute; bottom:0; left:0; right:0; height:2px; }
    .e-bg::after { background:linear-gradient(90deg,transparent,var(--accent),transparent); }
    .s-bg::after { background:linear-gradient(90deg,transparent,var(--blue),transparent); }
    .m-bg::after { background:linear-gradient(90deg,transparent,var(--orange),transparent); }
    .rate-tag { position:absolute; bottom:5px; right:7px; font-family:var(--font-display); font-size:.78rem; font-weight:700; }
    .bike-info { padding:.75rem .9rem .85rem; }
    .bike-name { font-weight:700; font-size:.9rem; margin-bottom:2px; }
    .bike-desc { font-size:.72rem; color:var(--text-300); line-height:1.4; }
    .empty-state { text-align:center; padding:2.5rem 1rem; color:var(--text-500); }
    .empty-state i { font-size:2.8rem; display:block; margin-bottom:.75rem; opacity:.4; }

    /* ─── Package selection panel ────────────────────── */
    .pkg-section-header {
      display:flex; align-items:center; justify-content:space-between;
      margin-bottom:1rem;
    }
    .pkg-group-title {
      font-size:.72rem; text-transform:uppercase; letter-spacing:.1em;
      color:var(--text-500); font-weight:700; margin-bottom:.6rem; margin-top:1rem;
    }
    .pkg-group-title:first-child { margin-top:0; }
    .pkg-cards-row { display:grid; grid-template-columns:repeat(auto-fill, minmax(150px, 1fr)); gap:.65rem; }

    .pkg-card {
      border:1.5px solid var(--border); border-radius:12px;
      padding:.9rem 1rem; cursor:pointer; transition:all .22s ease;
      background:var(--bg-700); position:relative; text-align:center;
      user-select:none;
    }
    .pkg-card:hover { border-color:rgba(0,229,160,.4); background:rgba(0,229,160,.04); transform:translateY(-2px); }
    .pkg-card.selected {
      border-color:var(--accent); background:rgba(0,229,160,.09);
      box-shadow:0 0 0 3px rgba(0,229,160,.15);
    }
    .pkg-card.no-pkg-card { border-style:dashed; }
    .pkg-card.no-pkg-card:hover { border-color:rgba(255,255,255,.3); background:rgba(255,255,255,.03); }
    .pkg-card.no-pkg-card.selected { border-color:var(--text-300); border-style:solid; background:rgba(255,255,255,.05); box-shadow:none; }

    .pkg-tick { position:absolute; top:7px; right:7px; width:18px; height:18px; border-radius:50%; background:var(--accent); color:#000; font-size:.6rem; font-weight:900; display:none; align-items:center; justify-content:center; }
    .pkg-card.selected .pkg-tick { display:flex; }

    .pkg-icon  { font-size:1.6rem; margin-bottom:.35rem; line-height:1; }
    .pkg-dur   { font-size:1.05rem; font-weight:800; color:var(--text-100); }
    .pkg-unit  { font-size:.7rem; color:var(--text-500); margin-bottom:.4rem; }
    .pkg-price { font-size:.88rem; font-weight:700; color:var(--accent); }
    .pkg-nopkg-label { font-size:.82rem; font-weight:700; color:var(--text-300); margin-bottom:.15rem; }
    .pkg-nopkg-sub   { font-size:.68rem; color:var(--text-500); }

    .chosen-bike-bar {
      display:flex; align-items:center; gap:.75rem;
      background:rgba(0,229,160,.06); border:1px solid rgba(0,229,160,.2);
      border-radius:10px; padding:.7rem 1rem; margin-bottom:1rem;
    }
    .cbb-icon { font-size:1.4rem; }
    .cbb-name { font-weight:700; font-size:.9rem; }
    .cbb-rate { font-size:.75rem; color:var(--text-300); }

    /* ─── Confirm strip ──────────────────────────────── */
    .confirm-strip {
      display:none;
      background:var(--bg-700); border:1.5px solid rgba(0,229,160,.3);
      border-radius:12px; padding:1rem 1.25rem;
      gap:1.25rem; align-items:center; flex-wrap:wrap;
      animation:slideDown .3s ease;
    }
    .confirm-strip.show { display:flex; }
    .cs-item { display:flex; flex-direction:column; gap:1px; }
    .cs-lbl  { font-size:.65rem; text-transform:uppercase; letter-spacing:.1em; color:var(--text-500); }
    .cs-val  { font-size:.9rem; font-weight:600; }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/bikes">Bikes</a></li>
    <li><a href="/user/dashboard">My Dashboard</a></li>
    <li><a href="/payments/my"><i class="bi bi-credit-card"></i> Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:860px;">

  <%-- Header --%>
  <div class="d-flex justify-between align-center mb-3 animate-in">
    <div>
      <h2>Rent a Bike</h2>
      <p class="text-muted" style="font-size:.88rem;">Pick a station, choose a bike, then select a rental package.</p>
    </div>
    <a href="/user/dashboard" class="btn btn-ghost btn-sm">
      <i class="bi bi-arrow-left"></i> Back
    </a>
  </div>

  <%-- Error --%>
  <c:if test="${not empty error}">
    <div class="alert alert-error animate-in"><i class="bi bi-exclamation-circle"></i> ${error}</div>
  </c:if>

  <%-- Step indicators — 4 steps now --%>
  <div class="steps animate-in-1">
    <div class="step-node">
      <div class="step-dot active" id="d1">1</div>
      <div class="step-label active" id="l1">Station</div>
    </div>
    <div class="step-line" id="line1"></div>
    <div class="step-node">
      <div class="step-dot pending" id="d2">2</div>
      <div class="step-label" id="l2">Bike</div>
    </div>
    <div class="step-line" id="line2"></div>
    <div class="step-node">
      <div class="step-dot pending" id="d3">3</div>
      <div class="step-label" id="l3">Package</div>
    </div>
    <div class="step-line" id="line3"></div>
    <div class="step-node">
      <div class="step-dot pending" id="d4">4</div>
      <div class="step-label" id="l4">Confirm</div>
    </div>
  </div>

  <%-- Embed full package data as JSON for each bike — safe in JSP attribute value --%>
  <%-- Format: {"bikeId": [...packages]} stored as data attrs on each bike card --%>

  <form action="/rides/rent" method="post" id="rentForm">
    <input type="hidden" id="startStationId" name="startStationId" value=""/>
    <input type="hidden" id="bikeId"         name="bikeId"         value=""/>
    <input type="hidden" id="packageId"      name="packageId"      value=""/>

    <%-- ═══════════════════════════════════
         STEP 1 — Station cards
    ══════════════════════════════════════ --%>
    <div class="card animate-in-2 mb-3">
      <h4 style="margin-bottom:1rem;">
        <i class="bi bi-geo-alt-fill text-accent"></i> Step 1 — Pickup Station
      </h4>
      <div class="station-grid">
        <c:forEach var="st" items="${stations}">
        <div class="station-card ${st.currentBikes == 0 ? 'no-bikes' : ''}"
             id="sc-${st.stationId}"
             data-id="${st.stationId}"
             data-name="${st.name}"
             data-count="${st.currentBikes}"
             onclick="handleStationClick(this)">
          <div class="station-tick">✓</div>
          <div class="station-name">${st.name}</div>
          <div class="station-loc"><i class="bi bi-pin-map" style="font-size:.72rem;"></i> ${st.location}</div>
          <c:choose>
            <c:when test="${st.currentBikes > 0}">
              <span class="avail-badge has">
                <i class="bi bi-bicycle" style="font-size:.75rem;"></i>
                ${st.currentBikes} bike<c:if test="${st.currentBikes != 1}">s</c:if> available
              </span>
            </c:when>
            <c:otherwise>
              <span class="avail-badge none">
                <i class="bi bi-x-circle" style="font-size:.75rem;"></i> No bikes here
              </span>
            </c:otherwise>
          </c:choose>
        </div>
        </c:forEach>
      </div>
    </div>

    <%-- ═══════════════════════════════════
         STEP 2 — Bikes at chosen station
    ══════════════════════════════════════ --%>
    <div class="card mb-3 section-panel" id="bikePanel">
      <div class="station-context-bar">
        <div>
          <div class="ctx-label"><i class="bi bi-geo-alt-fill"></i> Showing bikes at</div>
          <div class="ctx-name"  id="ctxName">—</div>
          <div class="ctx-count" id="ctxCount"></div>
        </div>
        <button type="button" class="btn btn-ghost btn-sm" onclick="resetStation()">
          <i class="bi bi-arrow-left"></i> Change Station
        </button>
      </div>

      <div class="bikes-grid" id="bikesGrid">
        <c:forEach var="bike" items="${availableBikes}">
        <%-- Encode full package JSON in a data attribute (JSP EL in attr values is fine) --%>
        <div class="bike-pick-card"
             data-station="${bike.bikeId != null ? bike.stationId : ''}"
             data-id="${bike.bikeId}"
             data-model="${bike.model}"
             data-rate="${bike.pricePerHour}"
             data-type="${bike.type}"
             id="bc-${bike.bikeId}"
             data-pkgjson='[<c:forEach var="pkg" items="${packagesByBike[bike.bikeId]}" varStatus="vs">{"id":"${pkg.packageId}","type":"${pkg.type}","dur":${pkg.duration},"price":${pkg.price}}<c:if test="${!vs.last}">,</c:if></c:forEach>]'
             style="display:none;"
             onclick="handleBikeClick(this)">
          <span class="chosen-badge">Selected</span>

          <div class="bike-scene-mini ${bike.type=='ELECTRIC'?'e-bg':bike.type=='MOTO'?'m-bg':'s-bg'}">
            <c:choose>
              <c:when test="${bike.type=='ELECTRIC'}">
                <svg width="88" height="56" viewBox="0 0 155 96" fill="none">
                  <circle cx="30" cy="66" r="24" stroke="#00e5a0" stroke-width="2" fill="none"/>
                  <circle cx="30" cy="66" r="4" fill="#00e5a0" opacity=".85"/>
                  <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                  <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                  <line x1="13" y1="49" x2="47" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                  <line x1="47" y1="49" x2="13" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                  <circle cx="125" cy="66" r="24" stroke="#00e5a0" stroke-width="2" fill="none"/>
                  <circle cx="125" cy="66" r="4" fill="#00e5a0" opacity=".85"/>
                  <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                  <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                  <path d="M30 66 L68 26 L78 66 Z" stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linejoin="round"/>
                  <path d="M68 26 L125 66" stroke="#00e5a0" stroke-width="2.2" fill="none"/>
                  <line x1="76" y1="48" x2="72" y2="30" stroke="rgba(0,229,160,.65)" stroke-width="2" stroke-linecap="round"/>
                  <line x1="65" y1="28" x2="79" y2="28" stroke="#00e5a0" stroke-width="3" stroke-linecap="round"/>
                  <path d="M138 6 L132 17 L138 17 L132 28 L148 13 L142 13 Z" fill="#00e5a0" opacity=".9"/>
                </svg>
              </c:when>
              <c:when test="${bike.type=='MOTO'}">
                <svg width="88" height="56" viewBox="0 0 155 96" fill="none">
                  <circle cx="28" cy="68" r="22" stroke="rgba(255,107,53,.9)" stroke-width="2.5" fill="none"/>
                  <circle cx="28" cy="68" r="4" fill="rgba(255,107,53,.9)"/>
                  <line x1="28" y1="46" x2="28" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                  <line x1="6"  y1="68" x2="50" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                  <circle cx="127" cy="68" r="22" stroke="rgba(255,107,53,.9)" stroke-width="2.5" fill="none"/>
                  <circle cx="127" cy="68" r="4" fill="rgba(255,107,53,.9)"/>
                  <line x1="127" y1="46" x2="127" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                  <line x1="105" y1="68" x2="149" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                  <path d="M28 68 L55 38 L95 38 L127 68" stroke="rgba(255,107,53,.85)" stroke-width="2.5" fill="none" stroke-linejoin="round"/>
                  <rect x="62" y="52" width="32" height="20" rx="4" fill="rgba(255,107,53,.18)" stroke="rgba(255,107,53,.6)" stroke-width="1.5"/>
                  <path d="M58 38 Q78 22 98 38" stroke="rgba(255,107,53,.7)" stroke-width="2.5" fill="rgba(255,107,53,.12)" stroke-linecap="round"/>
                </svg>
              </c:when>
              <c:otherwise>
                <svg width="88" height="56" viewBox="0 0 155 96" fill="none">
                  <circle cx="30" cy="66" r="24" stroke="rgba(78,168,222,.85)" stroke-width="2" fill="none"/>
                  <circle cx="30" cy="66" r="4" fill="rgba(78,168,222,.85)"/>
                  <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                  <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                  <circle cx="125" cy="66" r="24" stroke="rgba(78,168,222,.85)" stroke-width="2" fill="none"/>
                  <circle cx="125" cy="66" r="4" fill="rgba(78,168,222,.85)"/>
                  <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                  <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                  <path d="M30 66 L68 26 L78 66 Z" stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none" stroke-linejoin="round"/>
                  <path d="M68 26 L125 66" stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none"/>
                  <line x1="76" y1="48" x2="72" y2="30" stroke="rgba(78,168,222,.65)" stroke-width="2" stroke-linecap="round"/>
                  <line x1="65" y1="28" x2="79" y2="28" stroke="rgba(78,168,222,.95)" stroke-width="3" stroke-linecap="round"/>
                  <line x1="108" y1="26" x2="108" y2="16" stroke="rgba(78,168,222,.65)" stroke-width="2" stroke-linecap="round"/>
                  <line x1="102" y1="16" x2="114" y2="16" stroke="rgba(78,168,222,.95)" stroke-width="3" stroke-linecap="round"/>
                </svg>
              </c:otherwise>
            </c:choose>
            <div class="rate-tag" style="color:${bike.type=='ELECTRIC'?'var(--accent)':bike.type=='MOTO'?'var(--orange)':'var(--blue)'};">
              &#8360;<fmt:formatNumber value="${bike.pricePerHour * 320.34}" pattern="#,##0"/>/hr
            </div>
          </div>

          <div class="bike-info">
            <div class="bike-name">${bike.model}</div>
            <div class="at-station-tag" id="tag-${bike.bikeId}">
              <i class="bi bi-check-circle-fill" style="font-size:.65rem;"></i>
              Available here
            </div>
            <div class="bike-desc" style="margin-top:5px;">${bike.getBikeDescription()}</div>
          </div>
        </div>
        </c:forEach>
      </div>

      <div class="empty-state" id="noBikesHere" style="display:none;">
        <i class="bi bi-exclamation-circle"></i>
        No available bikes at this station.<br>
        <span style="font-size:.8rem;">Please choose a different station.</span>
      </div>
    </div>

    <%-- ═══════════════════════════════════
         STEP 3 — Package selection
    ══════════════════════════════════════ --%>
    <div class="card mb-3 section-panel" id="packagePanel">

      <%-- Which bike was chosen --%>
      <div class="chosen-bike-bar">
        <div class="cbb-icon" id="pkgBikeIcon">🚲</div>
        <div>
          <div class="cbb-name" id="pkgBikeName">—</div>
          <div class="cbb-rate" id="pkgBikeRate">—</div>
        </div>
        <div style="margin-left:auto;">
          <button type="button" class="btn btn-ghost btn-sm" onclick="resetBike()">
            <i class="bi bi-arrow-left"></i> Change Bike
          </button>
        </div>
      </div>

      <div class="pkg-section-header">
        <h4 style="margin:0;"><i class="bi bi-box-seam text-accent"></i> Step 3 — Choose a Package</h4>
      </div>

      <%-- No-package option always shown --%>
      <div id="pkgCardsArea">
        <%-- Populated dynamically by JS --%>
      </div>

    </div>

    <%-- ═══════════════════════════════════
         STEP 4 — Confirm strip
    ══════════════════════════════════════ --%>
    <div class="confirm-strip mb-3" id="confirmStrip">
      <div style="font-size:1.6rem; flex-shrink:0;">🚴</div>
      <div class="cs-item">
        <span class="cs-lbl">Station</span>
        <span class="cs-val" id="csStation">—</span>
      </div>
      <div class="cs-item">
        <span class="cs-lbl">Bike</span>
        <span class="cs-val" id="csBike">—</span>
      </div>
      <div class="cs-item">
        <span class="cs-lbl">Rate</span>
        <span class="cs-val" id="csRate">—</span>
      </div>
      <div class="cs-item" id="csPackageItem">
        <span class="cs-lbl">Package</span>
        <span class="cs-val" id="csPackage">—</span>
      </div>
      <div style="flex:1;"></div>
      <button type="submit" class="btn btn-primary btn-lg">
        <i class="bi bi-play-circle-fill"></i> Start Ride
      </button>
    </div>

    <div class="d-flex gap-1 mt-2">
      <button type="submit" id="mainBtn" class="btn btn-primary btn-lg" style="flex:1;" disabled>
        <i class="bi bi-play-circle"></i> Start Ride
      </button>
      <a href="/user/dashboard" class="btn btn-ghost btn-lg">Cancel</a>
    </div>

  </form>

</div>
</div>
<footer class="footer"><p>© 2026 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  var curStation = null, curStationName = null;
  var curBike = null, curBikeModel = null, curRate = null, curBikeType = null;
  var curPackageId = null;
  var RATE = 320.34;

  /* ── Data-attribute wrappers ─────────────────────────────── */
  function handleStationClick(el) {
    var count = parseInt(el.dataset.count, 10);
    if (count <= 0) return;
    pickStation(el.dataset.id, el.dataset.name, count);
  }

  function handleBikeClick(el) {
    pickBike(el.dataset.id, el.dataset.model, el.dataset.rate, el.dataset.type,
             el.dataset.pkgjson);
  }

  /* ── Step 1: station ─────────────────────────────────────── */
  function pickStation(id, name, count) {
    curStation = id; curStationName = name;
    curBike = null; curPackageId = null;
    document.getElementById('startStationId').value = id;
    document.getElementById('bikeId').value = '';
    document.getElementById('packageId').value = '';

    document.querySelectorAll('.station-card').forEach(function(c) { c.classList.remove('selected'); });
    document.getElementById('sc-' + id).classList.add('selected');
    document.getElementById('ctxName').textContent  = name;
    document.getElementById('ctxCount').textContent = count + ' bike' + (count != 1 ? 's' : '') + ' available here';

    var panel = document.getElementById('bikePanel');
    panel.classList.add('show');
    panel.scrollIntoView({ behavior: 'smooth', block: 'start' });

    // Filter bikes
    var cards = document.querySelectorAll('#bikesGrid .bike-pick-card');
    var visible = 0;
    cards.forEach(function(card) {
      card.classList.remove('chosen');
      if (card.getAttribute('data-station') === id) {
        card.style.display = 'block'; visible++;
      } else {
        card.style.display = 'none';
      }
    });
    document.getElementById('noBikesHere').style.display = visible === 0 ? 'block' : 'none';

    // Hide later steps
    document.getElementById('packagePanel').classList.remove('show');
    hideConfirm();
    setStep(2);
  }

  /* ── Step 2: bike ────────────────────────────────────────── */
  function pickBike(id, model, rate, type, pkgjsonRaw) {
    curBike = id; curBikeModel = model; curRate = rate; curBikeType = type;
    curPackageId = null;
    document.getElementById('bikeId').value = id;
    document.getElementById('packageId').value = '';

    // Highlight card
    document.querySelectorAll('.bike-pick-card').forEach(function(c) { c.classList.remove('chosen'); });
    document.getElementById('bc-' + id).classList.add('chosen');

    // Parse packages JSON (safe — no EL in JS)
    var packages = [];
    try { packages = JSON.parse(pkgjsonRaw || '[]'); } catch(e) { packages = []; }

    // Fill package panel header
    var icon = type === 'ELECTRIC' ? '⚡' : type === 'MOTO' ? '🏍️' : '🚲';
    document.getElementById('pkgBikeIcon').textContent = icon;
    document.getElementById('pkgBikeName').textContent = model;
    document.getElementById('pkgBikeRate').textContent =
      '&#8360;' + Math.round(parseFloat(rate) * RATE).toLocaleString() + '/hr base rate';
    // Fix innerHTML so the rupee symbol renders
    document.getElementById('pkgBikeRate').innerHTML =
      '&#8360;' + Math.round(parseFloat(rate) * RATE).toLocaleString() + '/hr base rate';

    // Build package cards
    buildPackageCards(packages, type);

    // Show package panel
    var pkgPanel = document.getElementById('packagePanel');
    pkgPanel.classList.add('show');
    pkgPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });

    hideConfirm();
    setStep(3);
  }

  /* ── Build package cards (pure JS — no EL) ───────────────── */
  function buildPackageCards(packages, bikeType) {
    var area = document.getElementById('pkgCardsArea');
    area.innerHTML = '';

    var accentColor = bikeType === 'ELECTRIC' ? 'var(--accent)' :
                      bikeType === 'MOTO'     ? 'var(--orange)' : 'var(--blue)';

    var hourPkgs = packages.filter(function(p) { return p.type === 'HOUR'; });
    var dayPkgs  = packages.filter(function(p) { return p.type === 'DAY'; });

    // Hour packages
    if (hourPkgs.length > 0) {
      var h2 = document.createElement('div');
      h2.className = 'pkg-group-title';
      h2.innerHTML = '<i class="bi bi-clock"></i> Hourly Packages';
      area.appendChild(h2);
      var row = document.createElement('div');
      row.className = 'pkg-cards-row';
      hourPkgs.forEach(function(pkg) { row.appendChild(makePkgCard(pkg, accentColor)); });
      area.appendChild(row);
    }

    // Day packages
    if (dayPkgs.length > 0) {
      var h3 = document.createElement('div');
      h3.className = 'pkg-group-title';
      h3.innerHTML = '<i class="bi bi-calendar3"></i> Daily Packages';
      area.appendChild(h3);
      var row2 = document.createElement('div');
      row2.className = 'pkg-cards-row';
      dayPkgs.forEach(function(pkg) { row2.appendChild(makePkgCard(pkg, accentColor)); });
      area.appendChild(row2);
    }

    // "No package" option
    var noRow = document.createElement('div');
    noRow.className = 'pkg-group-title';
    noRow.innerHTML = packages.length > 0
      ? '<i class="bi bi-dash-circle"></i> Or ride without a package'
      : '<i class="bi bi-info-circle"></i> No packages available for this bike';
    area.appendChild(noRow);
    var noGrid = document.createElement('div');
    noGrid.className = 'pkg-cards-row';
    noGrid.appendChild(makeNoPkgCard());
    area.appendChild(noGrid);
  }

  function makePkgCard(pkg, accentColor) {
    var lkrPrice = Math.round(pkg.price * RATE);
    var isHour = pkg.type === 'HOUR';
    var durLabel = pkg.dur + (isHour ? (pkg.dur === 1 ? ' Hour' : ' Hours')
                                     : (pkg.dur === 1 ? ' Day'  : ' Days'));
    var card = document.createElement('div');
    card.className = 'pkg-card';
    card.setAttribute('data-pkgid', pkg.id);
    card.setAttribute('data-dur-label', durLabel);
    card.setAttribute('data-price-lkr', lkrPrice);
    card.innerHTML =
      '<div class="pkg-tick">&#10003;</div>' +
      '<div class="pkg-icon">' + (isHour ? '&#x23F1;' : '&#x1F4C5;') + '</div>' +
      '<div class="pkg-dur" style="color:' + accentColor + '">' + pkg.dur + '</div>' +
      '<div class="pkg-unit">' + (isHour ? (pkg.dur === 1 ? 'Hour' : 'Hours') : (pkg.dur === 1 ? 'Day' : 'Days')) + '</div>' +
      '<div class="pkg-price">&#8360;' + lkrPrice.toLocaleString() + '</div>';
    card.onclick = function() { selectPackage(card, pkg.id, durLabel, lkrPrice); };
    return card;
  }

  function makeNoPkgCard() {
    var card = document.createElement('div');
    card.className = 'pkg-card no-pkg-card';
    card.setAttribute('data-pkgid', '');
    card.innerHTML =
      '<div class="pkg-tick">&#10003;</div>' +
      '<div class="pkg-icon">&#x1F551;</div>' +
      '<div class="pkg-nopkg-label">No Package</div>' +
      '<div class="pkg-nopkg-sub">Pay per hour<br>when you return</div>';
    card.onclick = function() { selectPackage(card, '', 'Pay per hour', null); };
    return card;
  }

  /* ── Step 3: select a package ────────────────────────────── */
  function selectPackage(cardEl, pkgId, durLabel, lkrPrice) {
    curPackageId = pkgId;
    document.getElementById('packageId').value = pkgId;

    // Highlight chosen card
    document.querySelectorAll('#pkgCardsArea .pkg-card').forEach(function(c) { c.classList.remove('selected'); });
    cardEl.classList.add('selected');

    // Fill confirm strip
    document.getElementById('csStation').textContent = curStationName;
    document.getElementById('csBike').textContent    = curBikeModel;
    document.getElementById('csRate').innerHTML =
      '&#8360;' + Math.round(parseFloat(curRate) * RATE).toLocaleString() + '/hr';
    document.getElementById('csPackage').textContent =
      pkgId ? durLabel + ' — &#8360;' + (lkrPrice ? lkrPrice.toLocaleString() : '') : 'None (pay per hour)';
    document.getElementById('csPackage').innerHTML =
      pkgId ? durLabel + ' &mdash; &#8360;' + (lkrPrice ? lkrPrice.toLocaleString() : '') : 'None &mdash; pay per hour';

    // Show confirm strip
    document.getElementById('confirmStrip').classList.add('show');
    document.getElementById('confirmStrip').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    document.getElementById('mainBtn').disabled = false;

    setStep(4);
  }

  /* ── Reset helpers ───────────────────────────────────────── */
  function resetStation() {
    curStation = null; curBike = null; curPackageId = null;
    document.getElementById('startStationId').value = '';
    document.getElementById('bikeId').value = '';
    document.getElementById('packageId').value = '';
    document.querySelectorAll('.station-card').forEach(function(c) { c.classList.remove('selected'); });
    document.getElementById('bikePanel').classList.remove('show');
    document.getElementById('packagePanel').classList.remove('show');
    document.getElementById('mainBtn').disabled = true;
    hideConfirm();
    setStep(1);
  }

  function resetBike() {
    curBike = null; curPackageId = null;
    document.getElementById('bikeId').value = '';
    document.getElementById('packageId').value = '';
    document.querySelectorAll('.bike-pick-card').forEach(function(c) { c.classList.remove('chosen'); });
    document.getElementById('packagePanel').classList.remove('show');
    document.getElementById('mainBtn').disabled = true;
    hideConfirm();
    setStep(2);
    document.getElementById('bikePanel').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function hideConfirm() {
    document.getElementById('confirmStrip').classList.remove('show');
    document.getElementById('mainBtn').disabled = true;
  }

  /* ── Step indicator ──────────────────────────────────────── */
  function setStep(n) {
    var dots   = ['d1','d2','d3','d4'].map(function(id) { return document.getElementById(id); });
    var labels = ['l1','l2','l3','l4'].map(function(id) { return document.getElementById(id); });
    var lines  = ['line1','line2','line3'].map(function(id) { return document.getElementById(id); });

    dots.forEach(function(d, i) {
      d.className = 'step-dot ' + (i + 1 < n ? 'complete' : i + 1 === n ? 'active' : 'pending');
      d.textContent = i + 1 < n ? '✓' : String(i + 1);
      labels[i].className = 'step-label' + (i + 1 <= n ? (i + 1 === n ? ' active' : ' complete') : '');
    });
    lines.forEach(function(l, i) {
      l.className = 'step-line' + (i + 1 < n ? ' complete' : '');
    });
  }

  /* ── Validate before submit ──────────────────────────────── */
  document.getElementById('rentForm').addEventListener('submit', function(e) {
    if (!document.getElementById('startStationId').value) {
      e.preventDefault(); alert('Please select a pickup station.'); return;
    }
    if (!document.getElementById('bikeId').value) {
      e.preventDefault(); alert('Please select a bike to rent.'); return;
    }
    // packageId can be empty — that means "no package"
  });
</script>
</body>
</html>
