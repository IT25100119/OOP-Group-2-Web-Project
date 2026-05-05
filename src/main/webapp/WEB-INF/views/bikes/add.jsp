<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Add Bike — VeloRide Admin</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .type-selector { display:grid; grid-template-columns:repeat(3,1fr); gap:.75rem; margin-bottom:1.5rem; }
    .type-btn {
      padding:1.1rem .75rem; border-radius:12px; border:1.5px solid var(--border);
      background:var(--bg-700); cursor:pointer; text-align:center;
      transition:all .2s ease; display:flex; flex-direction:column; align-items:center; gap:.4rem;
    }
    .type-btn:hover { border-color:rgba(0,229,160,.4); background:rgba(0,229,160,.06); }
    .type-btn.active{ border-color:var(--accent); background:rgba(0,229,160,.1); }
    .type-btn.moto-btn.active{ border-color:var(--orange); background:rgba(255,107,53,.1); }
    .type-btn.std-btn.active { border-color:var(--blue);   background:rgba(78,168,222,.1); }
    .type-icon { font-size:2rem; }
    .type-label{ font-size:.82rem; font-weight:600; }
    .form-section { display:none; animation:fadeInUp .3s ease; }
    .form-section.show { display:block; }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE <span class="badge badge-admin">ADMIN</span></a>
  <ul class="nav-links">
    <li><a href="/admin/dashboard">Dashboard</a></li>
    <li><a href="/bikes" class="active">Bikes</a></li>
    <li><a href="/payments/admin">Payments</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:2rem; max-width:660px; padding-bottom:4rem;">

  <div class="page-header animate-in">
    <h2 class="page-title">Add New Vehicle</h2>
    <p class="page-subtitle">Choose vehicle type then fill in the details.</p>
  </div>

  <%-- ── Success banner with Edit Bike Details button ── --%>
  <c:if test="${not empty success}">
    <div class="card animate-in" style="margin-bottom:1.25rem;
         border-color:rgba(0,229,160,0.35);
         background:rgba(0,229,160,0.05);">
      <div style="display:flex; align-items:center; gap:1rem; flex-wrap:wrap;">
        <div style="display:flex; align-items:center; gap:.6rem; flex:1;">
          <div style="width:38px; height:38px; border-radius:50%;
                      background:rgba(0,229,160,0.15);
                      display:flex; align-items:center; justify-content:center;
                      flex-shrink:0; font-size:1.1rem;">
            <i class="bi bi-check-circle-fill" style="color:var(--accent);"></i>
          </div>
          <div>
            <div class="fw-bold" style="color:var(--accent); font-size:.95rem;">
              ${success}
            </div>
            <div class="text-muted" style="font-size:.78rem; margin-top:1px;">
              Bike ID: <code class="text-accent" style="font-size:.75rem;">${newBikeId}</code>
              &nbsp;·&nbsp; Model: <strong>${newBikeModel}</strong>
            </div>
          </div>
        </div>
        <div style="display:flex; gap:.6rem; flex-shrink:0;">
          <a href="/bikes/edit/${newBikeId}" class="btn btn-primary btn-sm">
            <i class="bi bi-pencil-fill"></i> Edit Bike Details
          </a>
          <a href="/bikes" class="btn btn-ghost btn-sm">
            <i class="bi bi-grid"></i> View Fleet
          </a>
        </div>
      </div>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error animate-in"><i class="bi bi-x-circle"></i> ${error}</div>
  </c:if>

  <div class="card animate-in-1">

    <%-- ── Type selector ──────────────────────────────── --%>
    <div class="type-selector">
      <div class="type-btn active" id="btn-electric" onclick="switchType('electric')">
        <span class="type-icon">⚡</span>
        <span class="type-label text-accent">Electric Bike</span>
      </div>
      <div class="type-btn std-btn" id="btn-standard" onclick="switchType('standard')">
        <span class="type-icon">🚲</span>
        <span class="type-label text-blue">Standard Bike</span>
      </div>
      <div class="type-btn moto-btn" id="btn-moto" onclick="switchType('moto')">
        <span class="type-icon">🏍️</span>
        <span class="type-label text-orange">Motorbike</span>
      </div>
    </div>

    <%-- ── ELECTRIC ────────────────────────────────────── --%>
    <div id="form-electric" class="form-section show">
      <form action="/bikes/add/electric" method="post">
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Model Name *</label>
            <input type="text" name="model2" class="form-control" required placeholder="e.g. Trek Allant+ 7"/></div>
          <div class="form-group"><label class="form-label">Station *</label>
            <select name="stationId" class="form-control" required>
              <option value="">Select station…</option>
              <c:forEach var="st" items="${stations}">
                <option value="${st.stationId}">${st.name}</option>
              </c:forEach>
            </select></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Price / Hour ($) *</label>
            <input type="number" name="price" class="form-control" required step="0.25" min="0.5" placeholder="3.50"/></div>
          <div class="form-group"><label class="form-label">Battery Level (%)</label>
            <input type="number" name="battery" class="form-control" value="100" min="0" max="100"/></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Range (km)</label>
            <input type="number" name="range" class="form-control" step="0.5" value="60" min="10"/></div>
          <div class="form-group"><label class="form-label">Charger Type</label>
            <select name="charger" class="form-control">
              <option value="TYPE_C">Type-C</option>
              <option value="TYPE_A">Type-A</option>
            </select></div>
        </div>
        <button type="submit" class="btn btn-primary w-100 mt-1">⚡ Add Electric Bike</button>
      </form>
    </div>

    <%-- ── STANDARD ─────────────────────────────────────── --%>
    <div id="form-standard" class="form-section">
      <form action="/bikes/add/standard" method="post">
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Model Name *</label>
            <input type="text" name="model2" class="form-control" required placeholder="e.g. Giant Escape 3"/></div>
          <div class="form-group"><label class="form-label">Station *</label>
            <select name="stationId" class="form-control" required>
              <option value="">Select station…</option>
              <c:forEach var="st" items="${stations}">
                <option value="${st.stationId}">${st.name}</option>
              </c:forEach>
            </select></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Price / Hour ($) *</label>
            <input type="number" name="price" class="form-control" required step="0.25" min="0.5" placeholder="1.50"/></div>
          <div class="form-group"><label class="form-label">Gear Count</label>
            <input type="number" name="gears" class="form-control" value="21" min="1" max="30"/></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Frame Size</label>
            <select name="frameSize" class="form-control">
              <option value="SMALL">Small</option>
              <option value="MEDIUM" selected>Medium</option>
              <option value="LARGE">Large</option>
            </select></div>
          <div class="form-group"><label class="form-label">Has Basket?</label>
            <select name="hasBasket" class="form-control">
              <option value="false">No</option>
              <option value="true">Yes</option>
            </select></div>
        </div>
        <button type="submit" class="btn btn-primary w-100 mt-1" style="background:var(--blue); box-shadow:0 4px 16px rgba(78,168,222,.3);">🚲 Add Standard Bike</button>
      </form>
    </div>

    <%-- ── MOTO ────────────────────────────────────────── --%>
    <div id="form-moto" class="form-section">
      <div class="alert alert-info mb-3" style="background:rgba(255,107,53,.1); border-color:rgba(255,107,53,.3); color:var(--orange);">
        <i class="bi bi-info-circle"></i> Motorbikes charge 2× the base hourly rate. Fares are automatically doubled.
      </div>
      <form action="/bikes/add/moto" method="post">
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Model Name *</label>
            <input type="text" name="model2" class="form-control" required placeholder="e.g. Honda CB125F"/></div>
          <div class="form-group"><label class="form-label">Station *</label>
            <select name="stationId" class="form-control" required>
              <option value="">Select station…</option>
              <c:forEach var="st" items="${stations}">
                <option value="${st.stationId}">${st.name}</option>
              </c:forEach>
            </select></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Base Price / Hour ($) *</label>
            <input type="number" name="price" class="form-control" required step="0.50" min="1.00" placeholder="5.00"/></div>
          <div class="form-group"><label class="form-label">Engine (cc) *</label>
            <input type="number" name="engineCC" class="form-control" required min="50" max="1000" placeholder="125"/></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">Moto Class</label>
            <select name="motoClass" class="form-control">
              <option value="SCOOTER">🛵 Scooter</option>
              <option value="SPORT">🏍️ Sport</option>
              <option value="CRUISER">🏍️ Cruiser</option>
            </select></div>
          <div class="form-group"><label class="form-label">Fuel Type</label>
            <select name="fuelType" class="form-control">
              <option value="PETROL">⛽ Petrol</option>
              <option value="ELECTRIC_MOTO">⚡ Electric Moto</option>
            </select></div>
        </div>
        <div class="two-col" style="gap:1rem;">
          <div class="form-group"><label class="form-label">License Required?</label>
            <select name="licenseRequired" class="form-control">
              <option value="false">No (≤125cc)</option>
              <option value="true">Yes (&gt;125cc)</option>
            </select></div>
          <div class="form-group"><label class="form-label">Helmet Provided?</label>
            <select name="helmetProvided" class="form-control">
              <option value="true">Yes</option>
              <option value="false">No</option>
            </select></div>
        </div>
        <button type="submit" class="btn btn-primary w-100 mt-1"
                style="background:var(--orange); box-shadow:0 4px 16px rgba(255,107,53,.3);">
          🏍️ Add Motorbike
        </button>
      </form>
    </div>

  </div><%-- /card --%>

  <div class="mt-3"><a href="/bikes" class="btn btn-ghost"><i class="bi bi-arrow-left"></i> Back to Fleet</a></div>
</div>
</div>
<footer class="footer"><p>© 2025 VeloRide — Admin</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  function switchType(type) {
    // reset buttons
    ['electric','standard','moto'].forEach(t => {
      document.getElementById('btn-'+t).classList.remove('active');
      document.getElementById('form-'+t).classList.remove('show');
    });
    document.getElementById('btn-'+type).classList.add('active');
    document.getElementById('form-'+type).classList.add('show');
  }
</script>
</body>
</html>
