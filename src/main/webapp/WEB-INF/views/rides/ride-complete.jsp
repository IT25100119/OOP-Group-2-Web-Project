<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ride Complete — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .fare-display {
      font-family: var(--font-display);
      font-size: 4rem;
      color: var(--accent);
      line-height: 1;
    }
    .confetti { position:fixed; top:0; left:0; width:100%; height:100%; pointer-events:none; z-index:9999; }
  </style>
</head>
<body>
<canvas class="confetti" id="confetti"></canvas>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/user/dashboard">My Dashboard</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:3rem; padding-bottom:4rem; max-width:520px; text-align:center;">

  <div style="font-size:5rem; margin-bottom:1rem; animation: fadeInUp 0.5s ease;">🎉</div>
  <h2 class="animate-in">Ride Complete!</h2>
  <p class="text-muted animate-in-1">Great ride! Here's your summary.</p>

  <div class="card animate-in-2" style="margin:2rem 0; text-align:center;">
    <div class="text-muted" style="font-size:0.82rem; text-transform:uppercase; letter-spacing:-0.03em; margin-bottom:0.5rem;">Total Fare</div>
    <div class="fare-display">$<jsp:expression>String.format("%.2f", ((com.bikerental.model.Ride)request.getAttribute("completedRide")).getTotalFare())</jsp:expression></div>
    <div class="text-muted" style="font-size:0.85rem; margin-top:0.5rem;">
      <jsp:expression>String.format("%.1f", ((com.bikerental.model.Ride)request.getAttribute("completedRide")).getDurationHours())</jsp:expression> hours
    </div>
  </div>

  <div class="card animate-in-3" style="text-align:left; margin-bottom:1.5rem;">
    <div style="display:grid; gap:0.75rem;">
      <div class="d-flex justify-between">
        <span class="text-muted">Ride ID</span>
        <code class="text-accent">${completedRide.rideId}</code>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Bike</span>
        <span>${not empty bike ? bike.model : completedRide.bikeId}</span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Start</span>
        <span>${completedRide.startTime}</span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">End</span>
        <span>${completedRide.endTime}</span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Status</span>
        <span class="badge badge-completed">Completed</span>
      </div>
    </div>
  </div>

  <div class="d-flex gap-1 animate-in-4">
    <a href="/feedback/submit/${completedRide.rideId}" class="btn btn-primary btn-lg" style="flex:1;">
      <i class="bi bi-star"></i> Leave a Review
    </a>
    <a href="/rides/rent" class="btn btn-ghost btn-lg">Ride Again</a>
  </div>
  <div class="mt-2 d-flex gap-1">
    <a href="/payments/my" class="btn btn-ghost w-100">
      <i class="bi bi-credit-card"></i> View Payment Receipt
    </a>
    <a href="/user/dashboard" class="btn btn-ghost w-100">Back to Dashboard</a>
  </div>
</div>
</div>
<footer class="footer"><p>© 2025 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  // Simple confetti burst
  const canvas = document.getElementById('confetti');
  const ctx = canvas.getContext('2d');
  canvas.width = window.innerWidth; canvas.height = window.innerHeight;
  const particles = Array.from({length:80}, () => ({
    x: Math.random() * canvas.width, y: Math.random() * -200,
    w: Math.random()*8+4, h: Math.random()*12+6,
    color: ['#00e5a0','#4ea8de','#ff6b35','#ffc107'][Math.floor(Math.random()*4)],
    vy: Math.random()*3+2, vx: (Math.random()-0.5)*2,
    rot: Math.random()*360, rotV: (Math.random()-0.5)*6
  }));
  let frame = 0;
  (function draw() {
    ctx.clearRect(0,0,canvas.width,canvas.height);
    particles.forEach(p => {
      ctx.save(); ctx.translate(p.x, p.y); ctx.rotate(p.rot*Math.PI/180);
      ctx.fillStyle = p.color; ctx.globalAlpha = Math.max(0, 1 - frame/120);
      ctx.fillRect(-p.w/2, -p.h/2, p.w, p.h);
      ctx.restore();
      p.y += p.vy; p.x += p.vx; p.rot += p.rotV;
    });
    if (++frame < 120) requestAnimationFrame(draw);
    else canvas.remove();
  })();
</script>
</body>
</html>
