(function () {
  'use strict';

  var ROOT_DOMAIN = 'cicwtch.app';
  var siteRoot = document.getElementById('site-root');

  function normaliseHost(host) {
    return (host || '').toLowerCase().split(':')[0].trim();
  }

  function isLocalHost(host) {
    return host === '' || host === 'localhost' || host === '127.0.0.1';
  }

  function isRootDomain(host) {
    return isLocalHost(host) || host === ROOT_DOMAIN || host === 'www.' + ROOT_DOMAIN;
  }

  function isTenantSubdomain(host) {
    return !isRootDomain(host) && host.endsWith('.' + ROOT_DOMAIN);
  }

  function shouldRenderLanding() {
    var host = normaliseHost(window.location.hostname);
    var path = window.location.pathname || '/';

    if (isTenantSubdomain(host)) {
      return false;
    }

    if (!isRootDomain(host)) {
      return false;
    }

    return path === '/' || path === '' || path === '/index.html';
  }

  function setRobotsNoIndex() {
    var meta = document.querySelector('meta[name="robots"]');
    if (!meta) {
      meta = document.createElement('meta');
      meta.setAttribute('name', 'robots');
      document.head.appendChild(meta);
    }
    meta.setAttribute('content', 'noindex,nofollow');
  }

  function bootstrapFlutterApp() {
    setRobotsNoIndex();
    document.body.classList.add('app-shell-mode');
    siteRoot.innerHTML = '';
    var script = document.createElement('script');
    script.src = 'flutter_bootstrap.js';
    script.async = true;
    document.body.appendChild(script);
  }

  function renderLanding() {
    siteRoot.innerHTML = [
      '<div class="site-shell">',
      '  <header class="topbar">',
      '    <div class="container topbar-inner">',
      '      <a class="brand" href="/" aria-label="CiCwtch home">',
      '        <img src="favicon.png" alt="CiCwtch logo">',
      '        <span class="brand-lockup">CiCwtch<small>The professional heart of your dog walking business</small></span>',
      '      </a>',
      '      <nav class="nav-links" aria-label="Primary">',
      '        <a href="#features">Features</a>',
      '        <a href="#benefits">Benefits</a>',
      '        <a href="#trust">Trust</a>',
      '      </nav>',
      '      <div class="actions">',
      '        <a class="button-secondary" href="/login">Log in</a>',
      '        <a class="button" href="mailto:hello@cicwtch.app?subject=CiCwtch%20demo%20request">Book a demo</a>',
      '      </div>',
      '    </div>',
      '  </header>',
      '',
      '  <main>',
      '    <section class="hero">',
      '      <div class="container hero-grid">',
      '        <div>',
      '          <div class="kicker">🐾 Built for professional dog walking businesses</div>',
      '          <h1>Run the pack without the paperwork chaos.</h1>',
      '          <p>CiCwtch brings clients, dogs, walks, staff, records, and billing together in one secure platform, so you can look more professional to clients and spend less time chasing admin.</p>',
      '          <div class="hero-actions">',
      '            <a class="button" href="/login">Open the platform</a>',
      '            <a class="button-secondary" href="#features">See what it does</a>',
      '          </div>',
      '          <div class="hero-points" aria-label="Key highlights">',
      '            <div><strong>Client-ready</strong><span>Present updates, records, and communication in a cleaner, more trustworthy way.</span></div>',
      '            <div><strong>Operationally tidy</strong><span>Keep dogs, walkers, visits, and invoices where you actually need them.</span></div>',
      '            <div><strong>Tenant-aware</strong><span>Public website on the main domain. Workspace access on tenant subdomains.</span></div>',
      '          </div>',
      '        </div>',
      '        <div class="showcase" aria-label="Application overview">',
      '          <div class="showcase-panel">',
      '            <div class="showcase-top">',
      '              <strong>CiCwtch workspace</strong>',
      '              <span class="pill">Dog walking operations</span>',
      '            </div>',
      '            <div class="stats-grid">',
      '              <div class="stat-card"><strong>Clients & dogs</strong><span>Profiles, records, contacts, notes, and important details kept together.</span><em>Less digging, fewer mistakes.</em></div>',
      '              <div class="stat-card"><strong>Walk planning</strong><span>Track appointments, team workloads, and what is happening day to day.</span><em>More clarity for the whole pack.</em></div>',
      '              <div class="stat-card"><strong>Invoices</strong><span>Stay on top of billing without yet another spreadsheet lurking in a dark corner.</span><em>Admin, but less feral.</em></div>',
      '              <div class="stat-card"><strong>Professional image</strong><span>Give clients a more structured, modern service experience from the first enquiry onward.</span><em>Better trust, better retention.</em></div>',
      '            </div>',
      '          </div>',
      '        </div>',
      '      </div>',
      '    </section>',
      '',
      '    <section id="features" class="section">',
      '      <div class="container">',
      '        <div class="section-heading">',
      '          <div class="kicker">Features</div>',
      '          <h2>Everything important in one place.</h2>',
      '          <p>CiCwtch is designed for real operational work: managing people, dogs, schedules, invoicing, and records without bouncing between five systems and a WhatsApp search mission.</p>',
      '        </div>',
      '        <div class="features-grid">',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">📋</div><h3>Client management</h3><p>Store client details, contact information, notes, and service information in a structured way your business can actually rely on.</p></article>',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">🐶</div><h3>Dog profiles</h3><p>Keep key dog records close at hand so the right information is available to the right person at the right time.</p></article>',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">🚶</div><h3>Walk operations</h3><p>Organise visits and day-to-day activity without the usual tangle of messages, reminders, and half-finished notes.</p></article>',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">🧾</div><h3>Billing</h3><p>Create a more consistent back-office process around invoices and chargeable work.</p></article>',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">👥</div><h3>Walker records</h3><p>Support team visibility and accountability with clearer information around the people delivering the service.</p></article>',
      '          <article class="feature-card"><div class="feature-icon" aria-hidden="true">🔒</div><h3>Professional trust</h3><p>Built with a serious SaaS structure in mind, so your front-end image does not look lovely while the back-end is held together with hope.</p></article>',
      '        </div>',
      '      </div>',
      '    </section>',
      '',
      '    <section id="benefits" class="section">',
      '      <div class="container two-col">',
      '        <div class="section-copy">',
      '          <div class="section-heading">',
      '            <div class="kicker">Benefits</div>',
      '            <h2>Built to help you look sharper and work calmer.</h2>',
      '            <p>For dog walking businesses, professionalism is not just branding. It is the everyday experience clients have when they book, ask questions, receive updates, and pay invoices. CiCwtch helps you deliver that more consistently.</p>',
      '          </div>',
      '          <div class="feature-card">',
      '            <h3>What that means in practice</h3>',
      '            <p>Less duplicated admin. Clearer records. Fewer missed details. A cleaner service for clients. A more credible business for you.</p>',
      '          </div>',
      '        </div>',
      '        <div class="cta-panel">',
      '          <h3>Ready to explore CiCwtch?</h3>',
      '          <p>Use the main domain for the public website. Use your tenant subdomain for workspace access. The split is deliberate and keeps the experience tidy.</p>',
      '          <div class="hero-actions">',
      '            <a class="button" href="/login">Go to login</a>',
      '            <a class="button-secondary" href="mailto:hello@cicwtch.app?subject=CiCwtch%20enquiry">Contact CiCwtch</a>',
      '          </div>',
      '        </div>',
      '      </div>',
      '    </section>',
      '',
      '    <section id="trust" class="section">',
      '      <div class="container">',
      '        <div class="section-heading">',
      '          <div class="kicker">Trust</div>',
      '          <h2>Clear domain behaviour, so the right thing shows in the right place.</h2>',
      '          <p>The public landing page is shown on the main domain. Tenant subdomains bypass it and load the application directly. That means fewer wrong-door moments for clients and staff.</p>',
      '        </div>',
      '        <div class="quote-grid">',
      '          <article class="quote-card"><h3>Main domain</h3><p><strong>cicwtch.app</strong> serves the public-facing landing page, search content, and brand entry point.</p></article>',
      '          <article class="quote-card"><h3>Tenant subdomains</h3><p><strong>client123.cicwtch.app</strong> and similar hosts skip the landing page and boot straight into the Flutter application.</p></article>',
      '        </div>',
      '      </div>',
      '    </section>',
      '  </main>',
      '',
      '  <footer class="site-footer">',
      '    <div class="container footer-panel">',
      '      <div>© <span id="year"></span> CiCwtch. Built for professional dog walking businesses.</div>',
      '      <div class="footer-links">',
      '        <a href="/login">Login</a>',
      '        <a href="robots.txt">robots.txt</a>',
      '        <a href="sitemap.xml">Sitemap</a>',
      '      </div>',
      '    </div>',
      '  </footer>',
      '</div>'
    ].join('');

    var yearEl = document.getElementById('year');
    if (yearEl) {
      yearEl.textContent = String(new Date().getFullYear());
    }
  }

  if (shouldRenderLanding()) {
    renderLanding();
  } else {
    bootstrapFlutterApp();
  }
})();
