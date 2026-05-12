/* ============================================================
   Bike Rental Platform – Main JavaScript
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {

  // ── Navbar scroll effect ──────────────────────────────────
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    window.addEventListener('scroll', () => {
      navbar.classList.toggle('scrolled', window.scrollY > 20);
    }, { passive: true });
  }

  // ── Active nav link highlighting ──────────────────────────
  const currentPath = window.location.pathname;
  document.querySelectorAll('.nav-links a').forEach(link => {
    if (link.getAttribute('href') && currentPath.startsWith(link.getAttribute('href'))
        && link.getAttribute('href') !== '/') {
      link.classList.add('active');
    } else if (link.getAttribute('href') === '/' && currentPath === '/') {
      link.classList.add('active');
    }
  });

  // ── Auto-dismiss alerts ────────────────────────────────────
  document.querySelectorAll('.alert').forEach(alert => {
    setTimeout(() => {
      alert.style.transition = 'opacity 0.5s, transform 0.5s';
      alert.style.opacity = '0';
      alert.style.transform = 'translateY(-8px)';
      setTimeout(() => alert.remove(), 500);
    }, 4000);
  });

  // ── Animate stat counters ─────────────────────────────────
  function animateCounter(el) {
    const target = parseFloat(el.textContent.replace(/[^0-9.]/g, ''));
    if (isNaN(target) || target === 0) return;
    const isDecimal = el.textContent.includes('.');
    const prefix    = el.textContent.match(/^[^0-9]*/)?.[0] || '';
    const suffix    = el.textContent.match(/[^0-9.]*$/)?.[0] || '';
    const duration  = 1200;
    const start     = performance.now();

    function update(now) {
      const elapsed  = now - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased    = 1 - Math.pow(1 - progress, 3);
      const current  = eased * target;
      el.textContent = prefix + (isDecimal ? current.toFixed(1) : Math.floor(current)) + suffix;
      if (progress < 1) requestAnimationFrame(update);
    }
    requestAnimationFrame(update);
  }

  // Trigger counters when visible
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        counterObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });

  document.querySelectorAll('.stat-value').forEach(el => {
    counterObserver.observe(el);
  });

  // ── Scroll reveal ──────────────────────────────────────────
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('.reveal').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(24px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    revealObserver.observe(el);
  });

  // ── Tab system ────────────────────────────────────────────
  document.querySelectorAll('[data-tab-target]').forEach(btn => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.tabTarget;
      const parent = btn.closest('[data-tabs]') || document;

      parent.querySelectorAll('[data-tab-target]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      parent.querySelectorAll('[data-tab-content]').forEach(pane => {
        const isTarget = pane.dataset.tabContent === target;
        pane.style.display = isTarget ? 'block' : 'none';
        if (isTarget) pane.style.animation = 'fadeIn 0.3s ease';
      });
    });
  });

  // Init: show first tab pane, hide others
  document.querySelectorAll('[data-tabs]').forEach(container => {
    const panes = container.querySelectorAll('[data-tab-content]');
    panes.forEach((pane, i) => {
      pane.style.display = i === 0 ? 'block' : 'none';
    });
  });

  // ── Delete confirm ────────────────────────────────────────
  document.querySelectorAll('[data-confirm]').forEach(btn => {
    btn.addEventListener('click', e => {
      const msg = btn.dataset.confirm || 'Are you sure?';
      if (!confirm(msg)) e.preventDefault();
    });
  });

  // ── Bike type toggle on Add Bike form ─────────────────────
  const typeRadios  = document.querySelectorAll('input[name="bikeType"]');
  const elecFields  = document.getElementById('electric-fields');
  const stdFields   = document.getElementById('standard-fields');

  if (typeRadios.length && elecFields && stdFields) {
    function updateFields() {
      const val = document.querySelector('input[name="bikeType"]:checked')?.value;
      elecFields.style.display = val === 'ELECTRIC' ? 'block' : 'none';
      stdFields.style.display  = val === 'STANDARD' ? 'block' : 'none';
    }
    typeRadios.forEach(r => r.addEventListener('change', updateFields));
    updateFields();
  }

  // ── Star rating interactivity ─────────────────────────────
  document.querySelectorAll('.star-input').forEach(group => {
    const inputs = group.querySelectorAll('input');
    inputs.forEach(input => {
      input.addEventListener('change', () => {
        const val = document.getElementById('ratingValue');
        if (val) val.textContent = input.value + ' / 5';
      });
    });
  });

  // ── Mobile menu ───────────────────────────────────────────
  const menuToggle = document.getElementById('menuToggle');
  const mobileMenu = document.getElementById('mobileMenu');
  if (menuToggle && mobileMenu) {
    menuToggle.addEventListener('click', () => {
      const isOpen = mobileMenu.classList.toggle('open');
      menuToggle.setAttribute('aria-expanded', isOpen);
      mobileMenu.style.maxHeight = isOpen
        ? mobileMenu.scrollHeight + 'px'
        : '0';
    });
  }

  // ── Tooltip ───────────────────────────────────────────────
  document.querySelectorAll('[data-tooltip]').forEach(el => {
    const tip = document.createElement('div');
    tip.className = 'tooltip-popup';
    tip.textContent = el.dataset.tooltip;
    tip.style.cssText = `
      position:absolute; background:var(--bg-600); color:var(--text-100);
      padding:5px 10px; border-radius:6px; font-size:0.78rem;
      white-space:nowrap; pointer-events:none; z-index:9999;
      border:1px solid var(--border); opacity:0; transition:opacity 0.2s;
      transform:translateY(-6px);
    `;
    document.body.appendChild(tip);

    el.addEventListener('mouseenter', e => {
      const rect = el.getBoundingClientRect();
      tip.style.left = rect.left + window.scrollX + 'px';
      tip.style.top  = rect.top  + window.scrollY - 36 + 'px';
      tip.style.opacity = '1';
    });
    el.addEventListener('mouseleave', () => { tip.style.opacity = '0'; });
  });

  // ── Form validation visual feedback ──────────────────────
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', e => {
      const required = form.querySelectorAll('[required]');
      let valid = true;
      required.forEach(field => {
        if (!field.value.trim()) {
          field.style.borderColor = 'var(--red)';
          field.style.boxShadow   = '0 0 0 3px rgba(255,71,87,0.15)';
          valid = false;
          field.addEventListener('input', () => {
            field.style.borderColor = '';
            field.style.boxShadow   = '';
          }, { once: true });
        }
      });
      if (!valid) e.preventDefault();
    });
  });

  // ── Password show/hide ────────────────────────────────────
  document.querySelectorAll('[data-toggle-password]').forEach(btn => {
    const targetId = btn.dataset.togglePassword;
    const input    = document.getElementById(targetId);
    if (!input) return;
    btn.addEventListener('click', () => {
      const isPass = input.type === 'password';
      input.type = isPass ? 'text' : 'password';
      btn.textContent = isPass ? '🙈' : '👁';
    });
  });

});

// ── Global: ripple on button click ───────────────────────────
document.addEventListener('click', e => {
  const btn = e.target.closest('.btn');
  if (!btn) return;
  const ripple = document.createElement('span');
  const rect   = btn.getBoundingClientRect();
  ripple.style.cssText = `
    position:absolute; border-radius:50%;
    width:4px; height:4px;
    background:rgba(255,255,255,0.35);
    transform:scale(0);
    animation:ripple 0.5s linear;
    left:${e.clientX - rect.left - 2}px;
    top:${e.clientY  - rect.top  - 2}px;
    pointer-events:none;
  `;
  if (!document.querySelector('#ripple-style')) {
    const s = document.createElement('style');
    s.id = 'ripple-style';
    s.textContent = '@keyframes ripple{to{transform:scale(60);opacity:0}}';
    document.head.appendChild(s);
  }
  btn.style.position = 'relative';
  btn.appendChild(ripple);
  setTimeout(() => ripple.remove(), 600);
});
