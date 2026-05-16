<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit ${bike.model} — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    /* ── Edit page layout ─────────────────────────────────── */
    .edit-grid {
      display: grid;
      grid-template-columns: 300px 1fr;
      gap: 1.5rem;
      align-items: start;
    }
    @media(max-width:860px){ .edit-grid{ grid-template-columns:1fr; } }

    /* ── Bike preview card (left) ─────────────────────────── */
    .preview-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
      position: sticky;
      top: 80px;
    }
    .preview-scene {
      height: 180px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
    }
    .preview-scene.electric { background: linear-gradient(160deg,#0b1a14 0%,#0e1c1a 100%); }
    .preview-scene.standard { background: linear-gradient(160deg,#0d1420 0%,#101828 100%); }
    .preview-scene.moto     { background: linear-gradient(160deg,#1a0e06 0%,#1e1408 100%); }

    .preview-scene::after {
      content:''; position:absolute; bottom:0; left:0; right:0; height:2px;
    }
    .preview-scene.electric::after { background:linear-gradient(90deg,transparent,var(--accent),transparent); }
    .preview-scene.standard::after { background:linear-gradient(90deg,transparent,var(--blue),transparent); }
    .preview-scene.moto::after     { background:linear-gradient(90deg,transparent,var(--orange),transparent); }

    .preview-glow {
      position:absolute; bottom:-10px; left:50%; transform:translateX(-50%);
      width:130px; height:45px; border-radius:50%; filter:blur(14px);
    }
    .electric .preview-glow { background:rgba(0,229,160,0.45); }
    .standard .preview-glow { background:rgba(78,168,222,0.4); }
    .moto     .preview-glow { background:rgba(255,107,53,0.5); }

    .preview-info { padding:1.1rem 1.25rem; }
    .preview-id   { font-size:.72rem; color:var(--text-500); font-family:var(--font-body); margin-bottom:.3rem; }
    .preview-model{ font-family:var(--font-display); font-size:1.2rem; font-weight:700; letter-spacing:-.02em; margin-bottom:.4rem; }
    .preview-desc { font-size:.8rem; color:var(--text-300); line-height:1.5; }

    /* ── Status toggle pills ──────────────────────────────── */
    .status-pills { display:flex; gap:6px; margin-top:.75rem; }
    .status-pill {
      flex:1; padding:6px 4px; border-radius:8px; border:1.5px solid var(--border);
      background:var(--bg-700); cursor:pointer; text-align:center;
      font-size:.72rem; font-weight:600; text-transform:uppercase; letter-spacing:.06em;
      color:var(--text-500); transition:all .2s ease;
    }
    .status-pill:hover { border-color:rgba(255,255,255,.2); color:var(--text-300); }
    .status-pill.pill-available.selected { border-color:var(--accent); color:var(--accent); background:rgba(0,229,160,.1); }
    .status-pill.pill-inuse.selected     { border-color:var(--orange); color:var(--orange); background:rgba(255,107,53,.1); }
    .status-pill.pill-maint.selected     { border-color:var(--yellow); color:var(--yellow); background:rgba(255,193,7,.1); }

    /* ── Field group section ──────────────────────────────── */
    .field-section {
      background: var(--bg-700);
      border-radius: 10px;
      padding: 1rem 1.1rem;
      margin-bottom: 1rem;
    }
    .field-section-title {
      font-size:.72rem; font-weight:700; text-transform:uppercase;
      letter-spacing:.1em; color:var(--text-500); margin-bottom:.85rem;
      display:flex; align-items:center; gap:6px;
    }

    /* ── Range slider for battery ─────────────────────────── */
    .range-row { display:flex; align-items:center; gap:.75rem; }
    .range-row input[type=range] { flex:1; accent-color:var(--accent); }
    .range-val {
      font-family:var(--font-display); font-size:1.1rem; font-weight:700;
      color:var(--accent); min-width:42px; text-align:right;
    }

    /* ── Change type warning ──────────────────────────────── */
    .type-badge {
      display:inline-flex; align-items:center; gap:6px;
      padding:4px 12px; border-radius:99px; font-size:.75rem; font-weight:600;
    }
    .type-electric { background:rgba(0,229,160,.12); color:var(--accent); border:1px solid rgba(0,229,160,.3); }
    .type-standard { background:rgba(78,168,222,.12); color:var(--blue);   border:1px solid rgba(78,168,222,.3); }
    .type-moto     { background:rgba(255,107,53,.12); color:var(--orange); border:1px solid rgba(255,107,53,.3); }

    /* ── Success / Error banner ───────────────────────────── */
    .save-banner {
      display:flex; align-items:center; gap:.75rem;
      padding:.9rem 1.1rem; border-radius:10px; margin-bottom:1rem;
      font-size:.9rem; animation:slideDown .3s ease;
    }
    .save-success { background:rgba(0,229,160,.1); border:1px solid rgba(0,229,160,.3); color:var(--accent); }
    .save-error   { background:rgba(255,71,87,.1);  border:1px solid rgba(255,71,87,.3);  color:var(--red); }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/bikes" class="active">Bikes</a></li>
    <li><a href="/stations">Stations</a></li>
    <li><a href="/payments/admin">Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>

<div class="page-wrapper">
<div style="padding:.75rem 0 0;">
    <a href="/" class="btn btn-ghost btn-sm" style="font-size:.8rem;">
      <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    <a href="/bikes" class="btn btn-ghost btn-sm" style="font-size:.8rem; margin-left:.25rem;">
      <i class="bi bi-bicycle"></i> Bike Fleet List
    </a>
  </div>
<div class="container" style="padding-top:2rem; padding-bottom:4rem; max-width:960px;">

  <%-- ── Header ─────────────────────────────────────────── --%>
  <div class="d-flex justify-between align-center mb-4 animate-in">
    <div>
      <div class="text-muted" style="font-size:.82rem; margin-bottom:.3rem;">
        <a href="/bikes" class="text-accent">← Fleet</a> / Edit Bike
      </div>
      <h2 style="margin-bottom:.3rem;">${bike.model}</h2>
      <div style="display:flex; align-items:center; gap:.6rem;">
        <code class="text-dim" style="font-size:.75rem;">${bike.bikeId}</code>
        <c:choose>
          <c:when test="${bike.type == 'ELECTRIC'}"><span class="type-badge type-electric">⚡ Electric</span></c:when>
          <c:when test="${bike.type == 'MOTO'}">    <span class="type-badge type-moto">🏍️ Motorbike</span></c:when>
          <c:otherwise>                             <span class="type-badge type-standard">🚲 Standard</span></c:otherwise>
        </c:choose>
      </div>
    </div>
    <a href="/bikes" class="btn btn-ghost"><i class="bi bi-arrow-left"></i> Back to Fleet</a>
  </div>

  <%-- ── Flash messages ─────────────────────────────────── --%>
  <c:if test="${not empty param.success}">
    <div class="save-banner save-success animate-in">
      <i class="bi bi-check-circle-fill"></i> Bike updated successfully! Changes saved to fleet.
    </div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="save-banner save-error animate-in">
      <i class="bi bi-x-circle-fill"></i> Failed to save changes. Please check the form and try again.
    </div>
  </c:if>

  <div class="edit-grid">

    <%-- ══════════════════════════════════════════════════
         LEFT — Bike preview + quick status toggle
    ══════════════════════════════════════════════════ --%>
    <div class="animate-in-1">
      <div class="preview-card">

        <%-- Scene with SVG illustration --%>
        <div class="preview-scene ${bike.type == 'ELECTRIC' ? 'electric' : bike.type == 'MOTO' ? 'moto' : 'standard'}">
          <div class="preview-glow"></div>

          <c:choose>
            <%-- ELECTRIC SVG --%>
            <c:when test="${bike.type == 'ELECTRIC'}">
              <svg width="160" height="100" viewBox="0 0 155 96" fill="none" class="float-slow">
                <circle cx="30" cy="66" r="24" stroke="#00e5a0" stroke-width="2.5" fill="none"/>
                <circle cx="30" cy="66" r="18" stroke="rgba(0,229,160,.2)" stroke-width="1.2" fill="none"/>
                <circle cx="30" cy="66" r="4"  fill="#00e5a0" opacity=".85"/>
                <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                <line x1="13" y1="49" x2="47" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                <line x1="47" y1="49" x2="13" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                <circle cx="125" cy="66" r="24" stroke="#00e5a0" stroke-width="2.5" fill="none"/>
                <circle cx="125" cy="66" r="18" stroke="rgba(0,229,160,.2)" stroke-width="1.2" fill="none"/>
                <circle cx="125" cy="66" r="4"  fill="#00e5a0" opacity=".85"/>
                <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(0,229,160,.3)" stroke-width="1"/>
                <line x1="108" y1="49" x2="142" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                <line x1="142" y1="49" x2="108" y2="83" stroke="rgba(0,229,160,.2)" stroke-width="1"/>
                <rect x="65" y="42" width="20" height="10" rx="3" fill="rgba(0,229,160,.18)" stroke="rgba(0,229,160,.55)" stroke-width="1.3"/>
                <rect x="67" y="44" width="6"  height="6"  rx="1.5" fill="rgba(0,229,160,.7)"/>
                <path d="M30 66 L68 26 L78 66 Z"  stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                <path d="M68 26 L125 66"           stroke="#00e5a0" stroke-width="2.2" fill="none" stroke-linecap="round"/>
                <path d="M30 66 L58 42"            stroke="rgba(0,229,160,.45)" stroke-width="1.6" fill="none" stroke-linecap="round"/>
                <line x1="76" y1="48" x2="72" y2="30" stroke="rgba(0,229,160,.65)" stroke-width="2.2" stroke-linecap="round"/>
                <line x1="65" y1="28" x2="79" y2="28" stroke="#00e5a0"              stroke-width="3.2" stroke-linecap="round"/>
                <line x1="116" y1="42" x2="111" y2="24" stroke="rgba(0,229,160,.65)" stroke-width="2.2" stroke-linecap="round"/>
                <line x1="105" y1="24" x2="117" y2="24" stroke="#00e5a0"              stroke-width="3.2" stroke-linecap="round"/>
                <circle cx="78" cy="66" r="7" stroke="rgba(0,229,160,.5)" stroke-width="1.8" fill="none"/>
                <path d="M138 6 L132 17 L138 17 L132 28 L148 13 L142 13 Z" fill="#00e5a0" opacity=".95"/>
                <ellipse cx="77" cy="93" rx="58" ry="4" fill="rgba(0,229,160,.07)"/>
              </svg>
            </c:when>

            <%-- MOTO SVG --%>
            <c:when test="${bike.type == 'MOTO'}">
              <svg width="160" height="100" viewBox="0 0 155 96" fill="none" class="float-slow">
                <circle cx="28" cy="68" r="22" stroke="rgba(255,107,53,.9)"  stroke-width="2.5" fill="none"/>
                <circle cx="28" cy="68" r="16" stroke="rgba(255,107,53,.2)"  stroke-width="1.2" fill="none"/>
                <circle cx="28" cy="68" r="4"  fill="rgba(255,107,53,.9)"/>
                <line x1="28" y1="46" x2="28" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                <line x1="6"  y1="68" x2="50" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                <line x1="12" y1="52" x2="44" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                <line x1="44" y1="52" x2="12" y2="84" stroke="rgba(255,107,53,.2)" stroke-width="1"/>
                <circle cx="127" cy="68" r="22" stroke="rgba(255,107,53,.9)"  stroke-width="2.5" fill="none"/>
                <circle cx="127" cy="68" r="16" stroke="rgba(255,107,53,.2)"  stroke-width="1.2" fill="none"/>
                <circle cx="127" cy="68" r="4"  fill="rgba(255,107,53,.9)"/>
                <line x1="127" y1="46" x2="127" y2="90" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                <line x1="105" y1="68" x2="149" y2="68" stroke="rgba(255,107,53,.3)" stroke-width="1"/>
                <path d="M28 68 L55 38 L95 38 L127 68" stroke="rgba(255,107,53,.85)" stroke-width="2.5" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                <rect x="62" y="52" width="32" height="20" rx="4" fill="rgba(255,107,53,.18)" stroke="rgba(255,107,53,.6)" stroke-width="1.5"/>
                <path d="M62 68 L40 75 L35 82" stroke="rgba(255,107,53,.5)" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M58 38 Q78 22 98 38" stroke="rgba(255,107,53,.7)" stroke-width="2.5" fill="rgba(255,107,53,.12)" stroke-linecap="round"/>
                <path d="M82 38 Q95 34 108 36" stroke="rgba(255,107,53,.6)" stroke-width="3" fill="none" stroke-linecap="round"/>
                <line x1="110" y1="38" x2="118" y2="28" stroke="rgba(255,107,53,.6)" stroke-width="2.5" stroke-linecap="round"/>
                <line x1="113" y1="25" x2="123" y2="30" stroke="rgba(255,107,53,.85)" stroke-width="3" stroke-linecap="round"/>
                <circle cx="130" cy="46" r="5" fill="rgba(255,107,53,.2)" stroke="rgba(255,107,53,.7)" stroke-width="1.5"/>
                <ellipse cx="77" cy="93" rx="60" ry="4" fill="rgba(255,107,53,.07)"/>
              </svg>
            </c:when>

            <%-- STANDARD SVG --%>
            <c:otherwise>
              <svg width="160" height="100" viewBox="0 0 155 96" fill="none" class="float-slow">
                <circle cx="30" cy="66" r="24" stroke="rgba(78,168,222,.85)" stroke-width="2.5" fill="none"/>
                <circle cx="30" cy="66" r="18" stroke="rgba(78,168,222,.2)"  stroke-width="1.2" fill="none"/>
                <circle cx="30" cy="66" r="4"  fill="rgba(78,168,222,.85)"/>
                <line x1="30" y1="42" x2="30" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                <line x1="6"  y1="66" x2="54" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                <line x1="13" y1="49" x2="47" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                <line x1="47" y1="49" x2="13" y2="83" stroke="rgba(78,168,222,.2)" stroke-width="1"/>
                <circle cx="125" cy="66" r="24" stroke="rgba(78,168,222,.85)" stroke-width="2.5" fill="none"/>
                <circle cx="125" cy="66" r="18" stroke="rgba(78,168,222,.2)"  stroke-width="1.2" fill="none"/>
                <circle cx="125" cy="66" r="4"  fill="rgba(78,168,222,.85)"/>
                <line x1="125" y1="42" x2="125" y2="90" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                <line x1="101" y1="66" x2="149" y2="66" stroke="rgba(78,168,222,.3)" stroke-width="1"/>
                <path d="M30 66 L68 26 L78 66 Z" stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
                <path d="M68 26 L125 66"         stroke="rgba(78,168,222,.9)" stroke-width="2.2" fill="none" stroke-linecap="round"/>
                <path d="M30 66 L58 42"          stroke="rgba(78,168,222,.45)" stroke-width="1.6" fill="none" stroke-linecap="round"/>
                <line x1="68"  y1="26" x2="108" y2="26" stroke="rgba(78,168,222,.45)" stroke-width="1.5" stroke-linecap="round"/>
                <line x1="76"  y1="48" x2="72"  y2="30" stroke="rgba(78,168,222,.65)" stroke-width="2.2" stroke-linecap="round"/>
                <line x1="65"  y1="28" x2="79"  y2="28" stroke="rgba(78,168,222,.95)" stroke-width="3.2" stroke-linecap="round"/>
                <line x1="108" y1="26" x2="108" y2="16" stroke="rgba(78,168,222,.65)" stroke-width="2.2" stroke-linecap="round"/>
                <line x1="102" y1="16" x2="114" y2="16" stroke="rgba(78,168,222,.95)" stroke-width="3.2" stroke-linecap="round"/>
                <circle cx="78" cy="66" r="7" stroke="rgba(78,168,222,.5)" stroke-width="1.8" fill="none"/>
                <ellipse cx="77" cy="93" rx="58" ry="4" fill="rgba(78,168,222,.06)"/>
              </svg>
            </c:otherwise>
          </c:choose>

        </div>

        <%-- Preview info --%>
        <div class="preview-info">
          <div class="preview-id">${bike.bikeId}</div>
          <div class="preview-model" id="previewModel">${bike.model}</div>
          <div class="preview-desc">${bike.getBikeDescription()}</div>

          <%-- Quick status toggle --%>
          <div style="margin-top:.85rem;">
            <div class="form-label" style="margin-bottom:.5rem;">Current Status</div>
            <div class="status-pills">
              <div class="status-pill pill-available ${bike.status == 'AVAILABLE' ? 'selected' : ''}"
                   onclick="setStatus('AVAILABLE',this)">
                <i class="bi bi-check-circle" style="font-size:.8rem;"></i> Available
              </div>
              <div class="status-pill pill-inuse ${bike.status == 'IN_USE' ? 'selected' : ''}"
                   onclick="setStatus('IN_USE',this)">
                <i class="bi bi-bicycle" style="font-size:.8rem;"></i> In Use
              </div>
              <div class="status-pill pill-maint ${bike.status == 'MAINTENANCE' ? 'selected' : ''}"
                   onclick="setStatus('MAINTENANCE',this)">
                <i class="bi bi-tools" style="font-size:.8rem;"></i> Maint.
              </div>
            </div>
          </div>

          <%-- Station info --%>
          <div style="margin-top:.85rem; padding:.7rem; background:var(--bg-700); border-radius:8px; font-size:.8rem;">
            <span class="text-muted">Current station:</span><br>
            <span class="text-accent fw-bold" style="font-size:.85rem;">
              <c:forEach var="st" items="${stations}">
                <c:if test="${st.stationId == bike.stationId}">${st.name}</c:if>
              </c:forEach>
            </span>
            <div class="text-dim" style="font-size:.72rem; margin-top:2px;">${bike.stationId}</div>
          </div>
        </div>
      </div>
    </div>

    <%-- ══════════════════════════════════════════════════
         RIGHT — Edit form (type-specific)
    ══════════════════════════════════════════════════ --%>
    <div class="animate-in-2">

      <%-- ── ELECTRIC BIKE FORM ─────────────────────── --%>
      <c:if test="${bike.type == 'ELECTRIC'}">
        <form action="/bikes/edit/electric" method="post" id="editForm">
          <input type="hidden" name="bikeId"  value="${bike.bikeId}"/>
          <input type="hidden" name="status"  id="statusInput" value="${bike.status}"/>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-info-circle"></i> Basic Information</div>
            <div class="form-group">
              <label class="form-label">Model Name *</label>
              <input type="text" name="bikeModel" class="form-control" required
                     value="${bike.model}" oninput="document.getElementById('previewModel').textContent=this.value"/>
            </div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Price / Hour (₨) *</label>
                <input type="number" name="price" id="priceInputE" class="form-control price-lkr-input" required
                       step="1" min="100" value="${bike.pricePerHour * 320.34}"
                       data-usd="${bike.pricePerHour}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Station *</label>
                <select name="stationId" class="form-control" required>
                  <c:forEach var="st" items="${stations}">
                    <option value="${st.stationId}" ${bike.stationId == st.stationId ? 'selected':''}>
                      ${st.name}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-lightning-charge"></i> Electric Specifications</div>
            <div class="form-group">
              <label class="form-label">Battery Level (%)</label>
              <div class="range-row">
                <input type="range" name="batteryLevel" min="0" max="100"
                       value="${eBike.batteryLevel}"
                       oninput="document.getElementById('batteryVal').textContent=this.value+'%'"/>
                <span class="range-val" id="batteryVal">${eBike.batteryLevel}%</span>
              </div>
            </div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Range (km)</label>
                <input type="number" name="rangeKm" class="form-control"
                       step="0.5" min="5" value="${eBike.rangeKm}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Charger Type</label>
                <select name="chargerType" class="form-control">
                  <option value="TYPE_C" ${eBike.chargerType == 'TYPE_C' ? 'selected':''}>Type-C</option>
                  <option value="TYPE_A" ${eBike.chargerType == 'TYPE_A' ? 'selected':''}>Type-A</option>
                </select>
              </div>
            </div>
          </div>

          <div class="d-flex gap-1">
            <button type="submit" class="btn btn-primary" style="flex:1; background:var(--accent); box-shadow:0 4px 16px rgba(0,229,160,.3);">
              <i class="bi bi-check-circle-fill"></i> Save Changes
            </button>
            <a href="/bikes" class="btn btn-ghost">Cancel</a>
            <button type="button" class="btn btn-danger" onclick="confirmDelete()"><i class="bi bi-trash"></i></button>
          </div>
        </form>
      </c:if>

      <%-- ── STANDARD BIKE FORM ──────────────────────── --%>
      <c:if test="${bike.type == 'STANDARD'}">
        <form action="/bikes/edit/standard" method="post" id="editForm">
          <input type="hidden" name="bikeId"  value="${bike.bikeId}"/>
          <input type="hidden" name="status"  id="statusInput" value="${bike.status}"/>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-info-circle"></i> Basic Information</div>
            <div class="form-group">
              <label class="form-label">Model Name *</label>
              <input type="text" name="bikeModel" class="form-control" required
                     value="${bike.model}" oninput="document.getElementById('previewModel').textContent=this.value"/>
            </div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Price / Hour (₨) *</label>
                <input type="number" name="price" id="priceInputS" class="form-control price-lkr-input" required
                       step="1" min="100" value="${bike.pricePerHour * 320.34}"
                       data-usd="${bike.pricePerHour}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Station *</label>
                <select name="stationId" class="form-control" required>
                  <c:forEach var="st" items="${stations}">
                    <option value="${st.stationId}" ${bike.stationId == st.stationId ? 'selected':''}>
                      ${st.name}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-gear"></i> Bike Specifications</div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Gear Count</label>
                <input type="number" name="gearCount" class="form-control"
                       min="1" max="30" value="${sBike.gearCount}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Frame Size</label>
                <select name="frameSize" class="form-control">
                  <option value="SMALL"  ${sBike.frameSize == 'SMALL'  ? 'selected':''}>Small</option>
                  <option value="MEDIUM" ${sBike.frameSize == 'MEDIUM' ? 'selected':''}>Medium</option>
                  <option value="LARGE"  ${sBike.frameSize == 'LARGE'  ? 'selected':''}>Large</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Has Basket?</label>
              <select name="hasBasket" class="form-control">
                <option value="false" ${!sBike.hasBasket ? 'selected':''}>No</option>
                <option value="true"  ${sBike.hasBasket  ? 'selected':''}>Yes</option>
              </select>
            </div>
          </div>

          <div class="d-flex gap-1">
            <button type="submit" class="btn btn-primary" style="flex:1; background:var(--blue); box-shadow:0 4px 16px rgba(78,168,222,.3);">
              <i class="bi bi-check-circle-fill"></i> Save Changes
            </button>
            <a href="/bikes" class="btn btn-ghost">Cancel</a>
            <button type="button" class="btn btn-danger" onclick="confirmDelete()"><i class="bi bi-trash"></i></button>
          </div>
        </form>
      </c:if>

      <%-- ── MOTO BIKE FORM ──────────────────────────── --%>
      <c:if test="${bike.type == 'MOTO'}">
        <form action="/bikes/edit/moto" method="post" id="editForm">
          <input type="hidden" name="bikeId"  value="${bike.bikeId}"/>
          <input type="hidden" name="status"  id="statusInput" value="${bike.status}"/>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-info-circle"></i> Basic Information</div>
            <div class="form-group">
              <label class="form-label">Model Name *</label>
              <input type="text" name="bikeModel" class="form-control" required
                     value="${bike.model}" oninput="document.getElementById('previewModel').textContent=this.value"/>
            </div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Base Price / Hour (₨) *</label>
                <input type="number" name="price" id="priceInputM" class="form-control price-lkr-input" required
                       step="1" min="100" value="${bike.pricePerHour * 320.34}"
                       data-usd="${bike.pricePerHour}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Station *</label>
                <select name="stationId" class="form-control" required>
                  <c:forEach var="st" items="${stations}">
                    <option value="${st.stationId}" ${bike.stationId == st.stationId ? 'selected':''}>
                      ${st.name}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <div class="field-section">
            <div class="field-section-title"><i class="bi bi-speedometer2"></i> Engine & Class</div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Engine (cc) *</label>
                <input type="number" name="engineCC" class="form-control" required
                       min="50" max="1000" value="${mBike.engineCC}"/>
              </div>
              <div class="form-group">
                <label class="form-label">Moto Class</label>
                <select name="motoClass" class="form-control">
                  <option value="SCOOTER" ${mBike.motoClass == 'SCOOTER' ? 'selected':''}>🛵 Scooter</option>
                  <option value="SPORT"   ${mBike.motoClass == 'SPORT'   ? 'selected':''}>🏍️ Sport</option>
                  <option value="CRUISER" ${mBike.motoClass == 'CRUISER' ? 'selected':''}>🏍️ Cruiser</option>
                </select>
              </div>
            </div>
            <div class="two-col" style="gap:1rem;">
              <div class="form-group">
                <label class="form-label">Fuel Type</label>
                <select name="fuelType" class="form-control">
                  <option value="PETROL"        ${mBike.fuelType == 'PETROL'        ? 'selected':''}>⛽ Petrol</option>
                  <option value="ELECTRIC_MOTO" ${mBike.fuelType == 'ELECTRIC_MOTO' ? 'selected':''}>⚡ Electric Moto</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Helmet Provided?</label>
                <select name="helmetProvided" class="form-control">
                  <option value="true"  ${mBike.helmetProvided  ? 'selected':''}>Yes</option>
                  <option value="false" ${!mBike.helmetProvided ? 'selected':''}>No</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">License Required?</label>
              <select name="licenseRequired" class="form-control">
                <option value="false" ${!mBike.licenseRequired ? 'selected':''}>No (≤125cc)</option>
                <option value="true"  ${mBike.licenseRequired  ? 'selected':''}>Yes (&gt;125cc)</option>
              </select>
            </div>
          </div>

          <div class="d-flex gap-1">
            <button type="submit" class="btn btn-primary" style="flex:1; background:var(--orange); box-shadow:0 4px 16px rgba(255,107,53,.3);">
              <i class="bi bi-check-circle-fill"></i> Save Changes
            </button>
            <a href="/bikes" class="btn btn-ghost">Cancel</a>
            <button type="button" class="btn btn-danger" onclick="confirmDelete()"><i class="bi bi-trash"></i></button>
          </div>
        </form>
      </c:if>

      <%-- ── Bike History / metadata ──────────────────── --%>
      <div class="card animate-in-3" style="margin-top:1.5rem;">
        <h4 class="mb-3" style="font-size:.95rem;"><i class="bi bi-clock-history text-accent"></i> Bike Information</h4>
        <div style="display:grid; gap:.55rem;">
          <div class="d-flex justify-between" style="font-size:.85rem;">
            <span class="text-muted">Added to fleet</span>
            <span>${bike.addedDate}</span>
          </div>
          <div class="d-flex justify-between" style="font-size:.85rem;">
            <span class="text-muted">Bike ID</span>
            <code class="text-accent" style="font-size:.78rem;">${bike.bikeId}</code>
          </div>
          <div class="d-flex justify-between" style="font-size:.85rem;">
            <span class="text-muted">Type</span>
            <c:choose>
              <c:when test="${bike.type == 'ELECTRIC'}"><span class="badge badge-active" style="font-size:.72rem;">⚡ Electric</span></c:when>
              <c:when test="${bike.type == 'MOTO'}">    <span class="badge badge-inuse"   style="font-size:.72rem;">🏍️ Moto</span></c:when>
              <c:otherwise>                             <span class="badge"               style="font-size:.72rem;">🚲 Standard</span></c:otherwise>
            </c:choose>
          </div>
          <div class="d-flex justify-between" style="font-size:.85rem;">
            <span class="text-muted">Fare multiplier</span>
            <span class="fw-bold">
              <c:choose>
                <c:when test="${bike.type == 'ELECTRIC'}">1.5×</c:when>
                <c:when test="${bike.type == 'MOTO'}">2.0×</c:when>
                <c:otherwise>1.0×</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>
      </div>


      <%-- ── Rental Packages ──────────────────────────── --%>
      <div class="card animate-in-4" style="margin-top:1.5rem;" id="packagesCard">
        <div class="d-flex justify-between align-center mb-3">
          <h4 style="font-size:.95rem;"><i class="bi bi-tags-fill text-accent"></i> Rental Packages</h4>
          <span class="badge" style="font-size:.68rem; background:rgba(0,229,160,.12); color:var(--accent); border-color:rgba(0,229,160,.3);">Admin Editable</span>
        </div>

        <form action="/bikes/packages/save" method="post" id="pkgForm">
          <input type="hidden" name="bikeId" value="${bike.bikeId}"/>

          <%-- Hour Packages --%>
          <div style="margin-bottom:1.25rem;">
            <div class="d-flex justify-between align-center" style="margin-bottom:.6rem;">
              <span style="font-size:.8rem; font-weight:500; color:var(--text-300); text-transform:uppercase; letter-spacing:.06em;">
                <i class="bi bi-clock"></i> Hour Packages
              </span>
              <button type="button" class="btn btn-ghost btn-sm" style="font-size:.75rem; padding:.2rem .6rem;" onclick="addRow('HOUR')">
                <i class="bi bi-plus-circle"></i> Add
              </button>
            </div>
            <div id="hourRows">
              <c:forEach var="pkg" items="${hourPackages}">
              <div class="pkg-row" data-id="${pkg.packageId}">
                <input type="hidden" name="pkgType" value="HOUR"/>
                <div style="display:grid; grid-template-columns:80px 1fr auto; gap:.5rem; align-items:center; margin-bottom:.45rem;">
                  <div>
                    <label style="font-size:.7rem; color:var(--text-500); display:block;">Hours</label>
                    <input type="number" name="pkgDuration" value="${pkg.duration}"
                           min="1" max="23" step="1" required
                           style="width:100%; padding:.3rem .5rem; font-size:.85rem;"/>
                  </div>
                  <div>
                    <label style="font-size:.7rem; color:var(--text-500); display:block;">Price (₨)</label>
                    <input type="number" name="pkgPrice" value="${pkg.price * 320.34}"
                           min="0" step="1" required
                           style="width:100%; padding:.3rem .5rem; font-size:.85rem;"
                           data-usd="${pkg.price}" class="lkr-price-input"/>
                  </div>
                  <button type="button" class="btn btn-danger btn-sm" style="margin-top:1rem; padding:.25rem .55rem; font-size:.8rem;"
                          onclick="removeRow(this)">
                    <i class="bi bi-trash"></i>
                  </button>
                </div>
              </div>
              </c:forEach>
              <c:if test="${empty hourPackages}">
              <p class="text-muted" style="font-size:.8rem; text-align:center; padding:.5rem 0;" id="hourEmpty">No hour packages yet.</p>
              </c:if>
            </div>
          </div>

          <%-- Day Packages --%>
          <div style="margin-bottom:1.25rem;">
            <div class="d-flex justify-between align-center" style="margin-bottom:.6rem;">
              <span style="font-size:.8rem; font-weight:500; color:var(--text-300); text-transform:uppercase; letter-spacing:.06em;">
                <i class="bi bi-calendar3"></i> Day Packages
              </span>
              <button type="button" class="btn btn-ghost btn-sm" style="font-size:.75rem; padding:.2rem .6rem;" onclick="addRow('DAY')">
                <i class="bi bi-plus-circle"></i> Add
              </button>
            </div>
            <div id="dayRows">
              <c:forEach var="pkg" items="${dayPackages}">
              <div class="pkg-row" data-id="${pkg.packageId}">
                <input type="hidden" name="pkgType" value="DAY"/>
                <div style="display:grid; grid-template-columns:80px 1fr auto; gap:.5rem; align-items:center; margin-bottom:.45rem;">
                  <div>
                    <label style="font-size:.7rem; color:var(--text-500); display:block;">Days</label>
                    <input type="number" name="pkgDuration" value="${pkg.duration}"
                           min="1" max="30" step="1" required
                           style="width:100%; padding:.3rem .5rem; font-size:.85rem;"/>
                  </div>
                  <div>
                    <label style="font-size:.7rem; color:var(--text-500); display:block;">Price (₨)</label>
                    <input type="number" name="pkgPrice" value="${pkg.price * 320.34}"
                           min="0" step="1" required
                           style="width:100%; padding:.3rem .5rem; font-size:.85rem;"
                           data-usd="${pkg.price}" class="lkr-price-input"/>
                  </div>
                  <button type="button" class="btn btn-danger btn-sm" style="margin-top:1rem; padding:.25rem .55rem; font-size:.8rem;"
                          onclick="removeRow(this)">
                    <i class="bi bi-trash"></i>
                  </button>
                </div>
              </div>
              </c:forEach>
              <c:if test="${empty dayPackages}">
              <p class="text-muted" style="font-size:.8rem; text-align:center; padding:.5rem 0;" id="dayEmpty">No day packages yet.</p>
              </c:if>
            </div>
          </div>

          <button type="submit" class="btn btn-primary w-100" style="font-size:.88rem;">
            <i class="bi bi-check-circle"></i> Save Packages
          </button>
        </form>
      </div>

    </div><%-- /right col --%>
  </div><%-- /edit-grid --%>

</div>
</div>

<footer class="footer"><p>© 2026 VeloRide — Admin Panel</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>

  // ── Rental Package rows ──────────────────────────────────────────────────────
  const RATE = 320.34;

  function addRow(type) {
    const containerId = type === 'HOUR' ? 'hourRows' : 'dayRows';
    const maxDur      = type === 'HOUR' ? 23 : 30;
    const emptyId     = type === 'HOUR' ? 'hourEmpty' : 'dayEmpty';
    const container   = document.getElementById(containerId);

    // Remove the "No packages" placeholder if present
    const empty = document.getElementById(emptyId);
    if (empty) empty.remove();

    const row = document.createElement('div');
    row.className = 'pkg-row';
    row.innerHTML =
      '<input type="hidden" name="pkgType" value="' + type + '"/>' +
      '<div style="display:grid; grid-template-columns:80px 1fr auto; gap:.5rem; align-items:center; margin-bottom:.45rem;">' +
        '<div>' +
          '<label style="font-size:.7rem; color:var(--text-500); display:block;">' + (type === 'HOUR' ? 'Hours' : 'Days') + '</label>' +
          '<input type="number" name="pkgDuration" value="1" min="1" max="' + maxDur + '" step="1" required' +
                 ' style="width:100%; padding:.3rem .5rem; font-size:.85rem;"/>' +
        '</div>' +
        '<div>' +
          '<label style="font-size:.7rem; color:var(--text-500); display:block;">Price (&#8360;)</label>' +
          '<input type="number" name="pkgPrice" value="" placeholder="e.g. 1500"' +
                 ' min="0" step="1" required' +
                 ' style="width:100%; padding:.3rem .5rem; font-size:.85rem;" class="lkr-price-input"/>' +
        '</div>' +
        '<button type="button" class="btn btn-danger btn-sm"' +
                ' style="margin-top:1rem; padding:.25rem .55rem; font-size:.8rem;"' +
                ' onclick="removeRow(this)"><i class="bi bi-trash"></i></button>' +
      '</div>';
    container.appendChild(row);
  }

  function removeRow(btn) {
    btn.closest('.pkg-row').remove();
  }

  // Convert LKR input → USD before submitting
  document.getElementById('pkgForm').addEventListener('submit', function() {
    document.querySelectorAll('.lkr-price-input').forEach(input => {
      const lkr = parseFloat(input.value) || 0;
      input.value = (lkr / RATE).toFixed(4);
    });
  });


  // ── Price: LKR → USD conversion on submit ───────────────────────────────────
  const PRICE_RATE = 320.34;
  document.querySelectorAll('form[action^="/bikes/edit/electric"], form[action^="/bikes/edit/standard"], form[action^="/bikes/edit/moto"]').forEach(function(form) {
    form.addEventListener('submit', function() {
      var inp = form.querySelector('.price-lkr-input');
      if (inp) {
        var lkr = parseFloat(inp.value) || 0;
        inp.value = (lkr / PRICE_RATE).toFixed(4);
      }
    });
  });

  function setStatus(val, pill) {
    document.querySelectorAll('.status-pill').forEach(p => {
      p.classList.remove('selected');
    });
    pill.classList.add('selected');
    document.getElementById('statusInput').value = val;
  }

  // ── Delete bike (standalone form, outside edit forms) ────────────────────────
  function confirmDelete() {
    if (confirm('Delete this bike? This cannot be undone.')) {
      document.getElementById('deleteBikeForm').submit();
    }
  }

  // Animate battery slider
  document.querySelectorAll('input[type=range]').forEach(r => {
    r.style.transition = 'accent-color .2s';
  });
</script>
<%-- ── Standalone delete form (placed outside all edit forms to avoid nesting) --%>
<form id="deleteBikeForm" action="/bikes/delete" method="post" style="display:none;">
  <input type="hidden" name="bikeId" value="${bike.bikeId}"/>
</form>
</body>
</html>
