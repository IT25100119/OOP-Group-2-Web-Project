/* ============================================================
   VeloRide — Animation Engine
   ============================================================ */

(function () {
  'use strict';

  // ── Scroll Progress Bar ─────────────────────────────────────
  const progressBar = document.createElement('div');
  progressBar.id = 'scrollProgress';
  document.body.appendChild(progressBar);

  window.addEventListener('scroll', () => {
    const scrolled = window.scrollY;
    const total    = document.documentElement.scrollHeight - window.innerHeight;
    progressBar.style.width = total > 0 ? (scrolled / total * 100) + '%' : '0%';
  }, { passive: true });

  // ── Cursor Glow ─────────────────────────────────────────────
  const cursorGlow = document.createElement('div');
  cursorGlow.id = 'cursorGlow';
  document.body.appendChild(cursorGlow);

  let mouseX = -999, mouseY = -999;
  let glowX = -999, glowY = -999;

  document.addEventListener('mousemove', e => {
    mouseX = e.clientX;
    mouseY = e.clientY;
  });

  (function animateGlow() {
    glowX += (mouseX - glowX) * 0.08;
    glowY += (mouseY - glowY) * 0.08;
    cursorGlow.style.left = glowX + 'px';
    cursorGlow.style.top  = glowY + 'px';
    requestAnimationFrame(animateGlow);
  })();

  // ── Particle Canvas ─────────────────────────────────────────
  const canvas = document.createElement('canvas');
  canvas.id = 'particleCanvas';
  document.body.prepend(canvas);

  const ctx = canvas.getContext('2d');
  let W = canvas.width  = window.innerWidth;
  let H = canvas.height = window.innerHeight;

  window.addEventListener('resize', () => {
    W = canvas.width  = window.innerWidth;
    H = canvas.height = window.innerHeight;
  });

  const PARTICLE_COUNT = 55;
  const particles = Array.from({ length: PARTICLE_COUNT }, () => createParticle());

  function createParticle() {
    return {
      x:   Math.random() * W,
      y:   Math.random() * H,
      r:   Math.random() * 1.5 + 0.4,
      vx:  (Math.random() - 0.5) * 0.35,
      vy:  (Math.random() - 0.5) * 0.35,
      alpha: Math.random() * 0.5 + 0.1,
      color: Math.random() > 0.65 ? '0,229,160' : Math.random() > 0.5 ? '78,168,222' : '255,255,255',
    };
  }

  function drawParticles() {
    ctx.clearRect(0, 0, W, H);
    particles.forEach((p, i) => {
      // Move
      p.x += p.vx; p.y += p.vy;
      if (p.x < -10) p.x = W + 10;
      if (p.x > W + 10) p.x = -10;
      if (p.y < -10) p.y = H + 10;
      if (p.y > H + 10) p.y = -10;

      // Draw dot
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(${p.color},${p.alpha})`;
      ctx.fill();

      // Connect nearby particles
      for (let j = i + 1; j < particles.length; j++) {
        const q    = particles[j];
        const dist = Math.hypot(p.x - q.x, p.y - q.y);
        if (dist < 100) {
          ctx.beginPath();
          ctx.moveTo(p.x, p.y);
          ctx.lineTo(q.x, q.y);
          ctx.strokeStyle = `rgba(0,229,160,${0.06 * (1 - dist / 100)})`;
          ctx.lineWidth = 0.5;
          ctx.stroke();
        }
      }
    });
    requestAnimationFrame(drawParticles);
  }
  drawParticles();

  // ── Bike Trail ──────────────────────────────────────────────
  function spawnBikeTrail() {
    const trail = document.createElement('div');
    trail.className = 'bike-trail';
    trail.textContent = '🚴';
    trail.style.bottom = (Math.random() * 30 + 10) + 'vh';
    trail.style.animationDuration = (Math.random() * 8 + 10) + 's';
    trail.style.opacity = '0';
    trail.style.fontSize = (Math.random() * 10 + 18) + 'px';
    document.body.appendChild(trail);
    setTimeout(() => trail.remove(), 22000);
  }
  spawnBikeTrail();
  setInterval(spawnBikeTrail, 14000);

  // ── Intersection Observer: Scroll Reveal ────────────────────
  const revealObs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        revealObs.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('.reveal, [data-reveal]').forEach(el => {
    el.style.opacity    = '0';
    el.style.transform  = 'translateY(24px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.65s cubic-bezier(0.4,0,0.2,1)';
    revealObs.observe(el);
  });

  document.addEventListener('animationend', () => {});
  // Trigger reveal for already-visible
  document.querySelectorAll('.is-visible').forEach(el => {
    el.style.opacity   = '1';
    el.style.transform = 'none';
  });

  // Polyfill: apply .is-visible via CSS too
  const revealStyle = document.createElement('style');
  revealStyle.textContent = `.is-visible { opacity: 1 !important; transform: none !important; }`;
  document.head.appendChild(revealStyle);

  // ── Animated Stat Counters ─────────────────────────────────
  function animateCount(el) {
    const raw    = el.textContent.trim();
    const prefix = raw.match(/^[^0-9]*/)?.[0] ?? '';
    const suffix = raw.match(/[^0-9.]*$/)?.[0] ?? '';
    const target = parseFloat(raw.replace(/[^0-9.]/g, ''));
    if (isNaN(target) || target === 0) return;
    const isFloat   = raw.includes('.');
    const duration  = 1400;
    const startTime = performance.now();

    function tick(now) {
      const p  = Math.min((now - startTime) / duration, 1);
      const e  = 1 - Math.pow(1 - p, 3);
      const v  = e * target;
      el.textContent = prefix + (isFloat ? v.toFixed(1) : Math.floor(v)) + suffix;
      if (p < 1) requestAnimationFrame(tick);
      else el.textContent = raw; // Snap to exact value
    }
    requestAnimationFrame(tick);
  }

  const countObs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCount(entry.target);
        countObs.unobserve(entry.target);
      }
    });
  }, { threshold: 0.6 });

  document.querySelectorAll('.stat-value').forEach(el => countObs.observe(el));

  // ── 3D Tilt Cards ──────────────────────────────────────────
  document.querySelectorAll('.tilt-card, .bike-card').forEach(card => {
    card.addEventListener('mousemove', e => {
      const rect   = card.getBoundingClientRect();
      const cx     = rect.left + rect.width / 2;
      const cy     = rect.top  + rect.height / 2;
      const dx     = (e.clientX - cx) / (rect.width / 2);
      const dy     = (e.clientY - cy) / (rect.height / 2);
      const rotX   = -dy * 6;
      const rotY   =  dx * 6;
      card.style.transform = `perspective(600px) rotateX(${rotX}deg) rotateY(${rotY}deg) translateY(-4px)`;
      card.style.transition = 'transform 0.05s ease';
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform  = '';
      card.style.transition = 'transform 0.4s cubic-bezier(0.4,0,0.2,1)';
    });
  });

  // ── Magnetic Buttons ───────────────────────────────────────
  document.querySelectorAll('.btn-primary, .btn-magnetic').forEach(btn => {
    btn.addEventListener('mousemove', e => {
      const rect  = btn.getBoundingClientRect();
      const dx    = e.clientX - (rect.left + rect.width / 2);
      const dy    = e.clientY - (rect.top  + rect.height / 2);
      btn.style.transform = `translate(${dx * 0.15}px, ${dy * 0.15}px)`;
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.transform  = '';
      btn.style.transition = 'transform 0.4s cubic-bezier(0.4,0,0.2,1), box-shadow 0.2s ease';
    });
  });

  // ── Ripple on Click ────────────────────────────────────────
  document.addEventListener('click', e => {
    const btn = e.target.closest('.btn');
    if (!btn) return;
    const rect    = btn.getBoundingClientRect();
    const ripple  = document.createElement('span');
    const size    = Math.max(rect.width, rect.height) * 2;
    ripple.style.cssText = `
      position: absolute;
      width:  ${size}px;
      height: ${size}px;
      left:   ${e.clientX - rect.left - size / 2}px;
      top:    ${e.clientY - rect.top  - size / 2}px;
      border-radius: 50%;
      background: rgba(255,255,255,0.2);
      transform: scale(0);
      animation: rippleOut 0.55s linear forwards;
      pointer-events: none;
    `;
    btn.style.position = 'relative';
    btn.style.overflow = 'hidden';
    btn.appendChild(ripple);
    setTimeout(() => ripple.remove(), 600);
  });

  // Inject rippleOut keyframe
  if (!document.querySelector('#ripple-kf')) {
    const s = document.createElement('style');
    s.id = 'ripple-kf';
    s.textContent = '@keyframes rippleOut { to { transform: scale(1); opacity: 0; } }';
    document.head.appendChild(s);
  }

  // ── Stagger grid children ──────────────────────────────────
  document.querySelectorAll('.bikes-grid, .three-col, .stats-grid').forEach(grid => {
    Array.from(grid.children).forEach((child, i) => {
      child.style.animationDelay = `${i * 55}ms`;
    });
  });

  // ── Number flip for badges (activity items) ────────────────
  document.querySelectorAll('.ride-item').forEach((item, i) => {
    item.style.opacity   = '0';
    item.style.transform = 'translateX(-16px)';
    item.style.transition = `opacity 0.4s ease ${i * 60}ms, transform 0.4s ease ${i * 60}ms`;
    setTimeout(() => {
      item.style.opacity   = '1';
      item.style.transform = 'none';
    }, 100 + i * 60);
  });

  // ── Tab switch animation ───────────────────────────────────
  document.querySelectorAll('[data-tab-target]').forEach(btn => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.tabTarget;
      const parent = btn.closest('[data-tabs]') || document;
      parent.querySelectorAll('[data-tab-content]').forEach(pane => {
        if (pane.dataset.tabContent === target) {
          pane.style.animation = 'fadeInUp 0.3s cubic-bezier(0.4,0,0.2,1)';
        }
      });
    });
  });

  // ── Hero title word-by-word reveal ────────────────────────
  const heroTitle = document.querySelector('.hero-title');
  if (heroTitle) {
    const words = heroTitle.innerHTML.split(' ');
    heroTitle.innerHTML = words.map((w, i) =>
      `<span style="display:inline-block;opacity:0;transform:translateY(20px);
        animation:fadeInUp 0.5s cubic-bezier(0.4,0,0.2,1) ${0.3 + i * 0.08}s both">${w}</span>`
    ).join(' ');
  }

  // ── Animate alert auto-dismiss with slide ─────────────────
  document.querySelectorAll('.alert').forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.5s, transform 0.5s, max-height 0.4s 0.3s, margin 0.4s 0.3s, padding 0.4s 0.3s';
      alert.style.opacity    = '0';
      alert.style.transform  = 'translateX(20px)';
      setTimeout(() => {
        alert.style.maxHeight = '0';
        alert.style.margin    = '0';
        alert.style.padding   = '0';
        setTimeout(() => alert.remove(), 500);
      }, 500);
    }, 4500);
  });

  // ── Add .card-scan to all cards ──────────────────────────
  document.querySelectorAll('.card').forEach(c => c.classList.add('card-scan'));

  // ── Animate page title chars (for auth pages) ─────────────
  document.querySelectorAll('.page-title').forEach(h => {
    if (h.dataset.animated) return;
    h.dataset.animated = '1';
    const text = h.textContent;
    h.innerHTML = '';
    text.split('').forEach((ch, i) => {
      const span = document.createElement('span');
      span.textContent = ch === ' ' ? '\u00A0' : ch;
      span.style.cssText = `
        display: inline-block;
        opacity: 0;
        transform: translateY(12px);
        animation: fadeInUp 0.35s ease ${0.1 + i * 0.025}s both;
      `;
      h.appendChild(span);
    });
  });

  // ── Progress bar animate on page load ─────────────────────
  document.querySelectorAll('.progress-fill').forEach(bar => {
    const target = bar.style.width;
    bar.style.width = '0';
    setTimeout(() => { bar.style.width = target; }, 200);
  });

  // ── Hover glow trail on navbar links ──────────────────────
  document.querySelectorAll('.nav-links a').forEach(a => {
    a.classList.add('underline-anim');
  });

  // ── Form field focus label animation ──────────────────────
  document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('focus', () => {
      const label = input.closest('.form-group')?.querySelector('.form-label');
      if (label) {
        label.style.color     = 'var(--accent)';
        label.style.transform = 'translateY(-1px)';
        label.style.transition = 'color 0.2s, transform 0.2s';
      }
    });
    input.addEventListener('blur', () => {
      const label = input.closest('.form-group')?.querySelector('.form-label');
      if (label) {
        label.style.color     = '';
        label.style.transform = '';
      }
    });
  });

})();
