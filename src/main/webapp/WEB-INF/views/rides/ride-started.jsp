<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ride Started — VeloRide</title>
  <link rel="stylesheet" href="/static/css/style.css"/>
  <link rel="stylesheet" href="/static/css/animations.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css"/>
  <style>
    .success-ring {
      width: 120px; height: 120px;
      border-radius: 50%;
      border: 3px solid var(--accent);
      display: flex; align-items: center; justify-content: center;
      font-size: 3.5rem; margin: 0 auto 1.5rem;
      animation: pulse-ring 2s infinite;
      box-shadow: 0 0 0 0 rgba(0,229,160,0.4);
    }
    @keyframes pulse-ring {
      0%   { box-shadow: 0 0 0 0   rgba(0,229,160,0.4); }
      70%  { box-shadow: 0 0 0 20px rgba(0,229,160,0);   }
      100% { box-shadow: 0 0 0 0   rgba(0,229,160,0);    }
    }
    .timer-display {
      font-family: var(--font-display);
      font-size: 3rem;
      color: var(--accent);
      letter-spacing: 0.1em;
    }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="/" class="nav-brand">VELO<span class="brand-dot">●</span>RIDE</a>
  <ul class="nav-links">
    <li><a href="/user/dashboard">My Dashboard</a></li>
    <li><a href="/logout" class="btn btn-outline btn-sm">Logout</a></li>
  </ul>
</nav>
<div class="page-wrapper">
<div class="container" style="padding-top:3rem; padding-bottom:4rem; max-width:560px; text-align:center;">

  <div class="success-ring animate-in">🚴</div>

  <h2 class="animate-in-1">Ride Started!</h2>
  <p class="text-muted animate-in-2">You're on your way. Ride safely and have fun!</p>

  <div class="card animate-in-3" style="margin:2rem 0; text-align:left;">
    <div style="display:grid; gap:0.75rem;">
      <div class="d-flex justify-between">
        <span class="text-muted">Ride ID</span>
        <code class="text-accent">${ride.rideId}</code>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Bike ID</span>
        <code>${ride.bikeId}</code>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Started At</span>
        <span>${ride.startTime}</span>
      </div>
      <div class="d-flex justify-between">
        <span class="text-muted">Status</span>
        <span class="badge badge-active">Active</span>
      </div>
    </div>
  </div>

  <div class="card animate-in-4" style="margin-bottom:2rem; text-align:center; background:rgba(0,229,160,0.05); border-color:rgba(0,229,160,0.2);">
    <div class="text-muted" style="font-size:0.82rem; margin-bottom:0.5rem; text-transform:uppercase; letter-spacing:-0.03em;">Elapsed Time</div>
    <div class="timer-display" id="timer">00:00:00</div>
  </div>

  <div class="d-flex gap-1 animate-in-5">
    <a href="/rides/return" class="btn btn-primary btn-lg" style="flex:1;">
      <i class="bi bi-stop-circle"></i> Return Bike
    </a>
    <a href="/user/dashboard" class="btn btn-ghost btn-lg">Dashboard</a>
  </div>
</div>
</div>
<footer class="footer"><p>© 2025 VeloRide</p></footer>
<script src="/static/js/main.js"></script>
<script src="/static/js/animations.js"></script>
<script>
  // Ride timer
  let seconds = 0;
  const timerEl = document.getElementById('timer');
  setInterval(() => {
    seconds++;
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    timerEl.textContent =
      String(h).padStart(2,'0') + ':' +
      String(m).padStart(2,'0') + ':' +
      String(s).padStart(2,'0');
  }, 1000);
</script>
</body>
</html>
