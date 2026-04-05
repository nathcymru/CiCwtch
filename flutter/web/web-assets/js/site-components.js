(function () {
  const config = window.CICWTCH_SITE_CONFIG || {};
  const routing = window.CICWTCH_ROUTING || {};

  function currentPageName() {
    const page = document.body?.dataset?.page || 'home';
    return page;
  }

  function buildHeaderNav(page) {
    const sectionLinks = `
          <a href="/contact-us.htm">Contact Us</a>
          <a href="/legal_trust.htm">Legal and Trust Centre</a>
          <a href="#">Enterprise <span style="font-size:0.8em;opacity:0.7">(coming soon)</span></a>
          <a href="https://github.com/users/nathcymru/projects/2" target="_blank" rel="noopener noreferrer">Roadmap</a>
        `;

    return `
      <div class="site-status-banner" role="status" aria-live="polite">
        <div class="container site-status-inner">
          <span class="site-status-icon" aria-hidden="true">
            <span class="material-symbols-rounded">warning</span>
          </span>
          <div class="site-status-copy">Preview environment. This site is a live demo and still under construction. Some features, flows, and content may change.</div>
        </div>
      </div>

      <header class="topbar" id="siteHeader">
        <div class="container topbar-inner">
          <button class="menu-toggle" id="menuToggle" type="button" aria-label="Open navigation menu" aria-controls="primaryNav" aria-expanded="false">
            <span class="menu-toggle-inner" aria-hidden="true">
              <span class="menu-toggle-line"></span>
              <span class="menu-toggle-line"></span>
              <span class="menu-toggle-line"></span>
            </span>
          </button>

          <a href="/" class="brand" aria-label="CiCwtch home">
            <span class="brand-mark"><img id="appLogoEl" alt="" /></span>
            <span class="brand-name">CiCwtch</span>
          </a>

          <div class="topbar-actions">
            <div class="language-menu" id="languageMenu">
              <button type="button" class="language-toggle" id="languageToggle" aria-label="Choose language" aria-expanded="false" aria-controls="languageDropdown">
                <span class="material-symbols-rounded" aria-hidden="true">language</span>
                <span class="language-label">Language</span>
                <span class="material-symbols-rounded language-caret" aria-hidden="true">expand_more</span>
              </button>
              <ul class="language-dropdown" id="languageDropdown" aria-label="Language options">
                <li><a href="https://cicwtch.app/ga" lang="ga">Gaeilge</a></li>
                <li><a href="https://cicwtch.app/en" lang="en" aria-current="page">English</a></li>
                <li><a href="https://cicwtch.app/cy" lang="cy">Cymraeg</a></li>
                <li><a href="https://cicwtch.app/gd" lang="gd">Gàidhlig</a></li>
                <li><a href="https://cicwtch.app/sco" lang="sco">Ullans</a></li>
                <li><a href="https://cicwtch.app/kw" lang="kw">Kernowek</a></li>
                <li><a href="https://cicwtch.app/gv" lang="gv">Gaelg</a></li>
                <li><a href="https://cicwtch.app/fr" lang="fr">Français</a></li>
                <li><a href="https://cicwtch.app/nrf" lang="nrf">Jèrriais</a></li>
                <li><a href="https://cicwtch.app/nrf" lang="nrf">Guernésiais</a></li>
              </ul>
            </div>
            <a href="/login" class="login-btn">Login</a>
          </div>

          <nav class="nav" id="primaryNav" aria-label="Primary">
            ${sectionLinks}
          </nav>
        </div>
      </header>
    `;
  }

  function buildFooter() {
    return `
      <footer>
        <div class="container footer-grid">
          <div class="footer-copy">
            <a href="/" class="brand" aria-label="CiCwtch home">
              <span class="brand-mark"><img id="footerLogoEl" alt="" /></span>
              <span class="brand-name">CiCwtch</span>
            </a>

            <p class="footer-pitch">
              The digital "Cwtch" for your dog walking business. We handle the heavy lifting of admin, scheduling, and client updates, so you can focus on the dogs.
            </p>

            <div class="footer-columns">
              <div class="footer-link-list">
                <h2 class="footer-column-h5">CiCwtch</h2>
                <a href="/">Home</a>
                <a href="/contact-us.htm">Contact Us</a>
                <a href="/legal_trust.htm">Legal and Trust Centre</a>
              </div>

              <div class="footer-link-list">
                <h2 class="footer-column-h5">Technical</h2>
                <a href="/login">Login</a>
                <a href="https://status.cicwtch.com">System Status</a>
                <a href="https://github.com/users/nathcymru/projects/2" target="_blank" rel="noopener noreferrer">Roadmap</a>
              </div>

              <div class="footer-link-list">
                <h2 class="footer-column-h5">Legal</h2>
                <a href="/legal_trust.htm#terms">Terms of Service</a>
                <a href="/legal_trust.htm#privacy">Privacy Policy</a>
                <a href="/legal_trust.htm#security">Security &amp; Trust</a>
              </div>

              <div class="footer-link-list">
                <h2 class="footer-column-h5">App stores</h2>
                <div class="store-badges footer-store-badges">
                  <img id="footerAppleBadgeEl" alt="Pre-order on the App Store badge" />
                  <img id="footerGoogleBadgeEl" alt="Pre-register on Google Play badge" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="container footer-bottom" id="footerCopyright"></div>
      </footer>
    `;
  }

  function applySharedImages() {
    const mappings = {
      appLogoEl: config.appLogo,
      footerLogoEl: config.appLogo,
      heroImageEl: config.heroImage,
      warmImageEl: config.warmImage,
      cafeImageEl: config.cafeImage,
      walkingImageEl: config.walkingImage,
      pawsomeWalesImageEl: config.pawsomeWalesImage,
      appleBadgeEl: config.appleBadge,
      googleBadgeEl: config.googleBadge,
      footerAppleBadgeEl: config.appleBadge,
      footerGoogleBadgeEl: config.googleBadge
    };

    Object.entries(mappings).forEach(([id, src]) => {
      const el = document.getElementById(id);
      if (el && src) el.src = src;
    });

    const year = new Date().getFullYear();
    const copyright = document.getElementById('footerCopyright');
    if (copyright) {
      copyright.textContent = `© 2024–${year} Nathan Jones t/a CiCwtch. All rights reserved.`;
    }
  }

  function initMenuAndLanguage() {
    const siteHeader = document.getElementById('siteHeader');
    const menuToggle = document.getElementById('menuToggle');
    const primaryNav = document.getElementById('primaryNav');
    const languageMenu = document.getElementById('languageMenu');
    const languageToggle = document.getElementById('languageToggle');
    const languageDropdown = document.getElementById('languageDropdown');
    if (!siteHeader || !menuToggle || !primaryNav || !languageMenu || !languageToggle || !languageDropdown) return;

    const languageLinks = Array.from(languageDropdown.querySelectorAll('a'));
    const mobileBreakpoint = window.matchMedia('(max-width: 760px)');

    function closeMenu() {
      siteHeader.classList.remove('nav-open');
      menuToggle.setAttribute('aria-expanded', 'false');
      menuToggle.setAttribute('aria-label', 'Open navigation menu');
    }

    function toggleMenu() {
      const isOpen = siteHeader.classList.toggle('nav-open');
      menuToggle.setAttribute('aria-expanded', String(isOpen));
      menuToggle.setAttribute('aria-label', isOpen ? 'Close navigation menu' : 'Open navigation menu');
    }

    function closeLanguageMenu() {
      languageMenu.classList.remove('is-open');
      languageToggle.setAttribute('aria-expanded', 'false');
    }

    function openLanguageMenu() {
      languageMenu.classList.add('is-open');
      languageToggle.setAttribute('aria-expanded', 'true');
    }

    function toggleLanguageMenu() {
      if (languageMenu.classList.contains('is-open')) closeLanguageMenu();
      else openLanguageMenu();
    }

    menuToggle.addEventListener('click', toggleMenu);
    languageToggle.addEventListener('click', function (event) {
      event.stopPropagation();
      toggleLanguageMenu();
    });
    languageToggle.addEventListener('keydown', function (event) {
      if (event.key === 'ArrowDown') {
        event.preventDefault();
        openLanguageMenu();
        if (languageLinks.length) languageLinks[0].focus();
      }
    });

    languageLinks.forEach((link, index) => {
      link.addEventListener('keydown', function (event) {
        if (event.key === 'ArrowDown') {
          event.preventDefault();
          languageLinks[(index + 1) % languageLinks.length].focus();
        }
        if (event.key === 'ArrowUp') {
          event.preventDefault();
          languageLinks[(index - 1 + languageLinks.length) % languageLinks.length].focus();
        }
        if (event.key === 'Home') {
          event.preventDefault();
          languageLinks[0].focus();
        }
        if (event.key === 'End') {
          event.preventDefault();
          languageLinks[languageLinks.length - 1].focus();
        }
        if (event.key === 'Escape') {
          event.preventDefault();
          closeLanguageMenu();
          languageToggle.focus();
        }
      });
    });

    primaryNav.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeMenu));
    if (mobileBreakpoint.addEventListener) mobileBreakpoint.addEventListener('change', closeMenu);
    else if (mobileBreakpoint.addListener) mobileBreakpoint.addListener(closeMenu);

    document.addEventListener('click', function (event) {
      if (!languageMenu.contains(event.target)) closeLanguageMenu();
    });
    window.addEventListener('keydown', function (event) {
      if (event.key === 'Escape' && languageMenu.classList.contains('is-open')) {
        closeLanguageMenu();
        languageToggle.focus();
      }
    });
  }

  function initVideoModal() {
    const pageShell = document.getElementById('pageShell');
    const modal = document.getElementById('videoModal');
    const openVideoModalBtn = document.getElementById('openVideoModal');
    const closeVideoModalBtn = document.getElementById('closeVideoModal');
    const modalTrialBtn = document.getElementById('modalTrialBtn');
    const videoFrame = document.getElementById('videoFrame');
    if (!modal || !openVideoModalBtn || !closeVideoModalBtn || !videoFrame || !pageShell) return;

    let lastFocusedElement = null;

    function getFocusableElements(container) {
      return Array.from(container.querySelectorAll('a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), iframe, [tabindex]:not([tabindex="-1"])')).filter((element) => !element.hasAttribute('hidden') && element.offsetParent !== null);
    }

    function trapFocus(event, container) {
      if (event.key !== 'Tab') return;
      const focusableElements = getFocusableElements(container);
      if (!focusableElements.length) return;
      const firstElement = focusableElements[0];
      const lastElement = focusableElements[focusableElements.length - 1];
      if (event.shiftKey && document.activeElement === firstElement) {
        event.preventDefault();
        lastElement.focus();
      } else if (!event.shiftKey && document.activeElement === lastElement) {
        event.preventDefault();
        firstElement.focus();
      }
    }

    function setPageInert(isInert) {
      if ('inert' in pageShell) pageShell.inert = isInert;
      pageShell.setAttribute('aria-hidden', isInert ? 'true' : 'false');
    }

    function openVideoModal() {
      lastFocusedElement = document.activeElement;
      modal.classList.add('is-open');
      modal.setAttribute('aria-hidden', 'false');
      document.body.classList.add('modal-open');
      setPageInert(true);
      videoFrame.src = config.videoEmbedUrl || '';
      const focusable = getFocusableElements(modal);
      if (focusable.length) focusable[0].focus();
    }

    function closeVideoModal() {
      modal.classList.remove('is-open');
      modal.setAttribute('aria-hidden', 'true');
      videoFrame.src = '';
      document.body.classList.remove('modal-open');
      setPageInert(false);
      if (lastFocusedElement && typeof lastFocusedElement.focus === 'function') lastFocusedElement.focus();
    }

    openVideoModalBtn.addEventListener('click', openVideoModal);
    closeVideoModalBtn.addEventListener('click', closeVideoModal);
    if (modalTrialBtn) modalTrialBtn.addEventListener('click', closeVideoModal);
    modal.addEventListener('click', function (event) {
      if (event.target === modal) closeVideoModal();
    });
    modal.addEventListener('keydown', function (event) {
      trapFocus(event, modal);
      if (event.key === 'Escape') {
        event.preventDefault();
        closeVideoModal();
      }
    });
  }

  function initCookies() {
    const COOKIE_STORAGE_KEY = 'cicwtch-cookie-preferences-v1';
    const cookieSheet = document.getElementById('cookieSheet');
    const cookieSettingsPanel = document.getElementById('cookieSettingsPanel');
    const openCookieSettings = document.getElementById('openCookieSettings');
    const acceptAllCookies = document.getElementById('acceptAllCookies');
    const saveCookiePreferences = document.getElementById('saveCookiePreferences');
    const analyticsCheckbox = document.getElementById('cookieAnalytics');
    const marketingCheckbox = document.getElementById('cookieMarketing');

    if (!cookieSheet || !cookieSettingsPanel || !openCookieSettings || !acceptAllCookies || !saveCookiePreferences || !analyticsCheckbox || !marketingCheckbox) return;

    function getStoredCookiePreferences() {
      try {
        const raw = localStorage.getItem(COOKIE_STORAGE_KEY);
        return raw ? JSON.parse(raw) : null;
      } catch (error) {
        return null;
      }
    }

    function setStoredCookiePreferences(preferences) {
      localStorage.setItem(COOKIE_STORAGE_KEY, JSON.stringify(preferences));
    }

    function showCookieSheet() { cookieSheet.classList.add('is-visible'); }
    function hideCookieSheet() { cookieSheet.classList.remove('is-visible'); }
    function expandCookieSettings() {
      cookieSettingsPanel.hidden = false;
      openCookieSettings.setAttribute('aria-expanded', 'true');
      openCookieSettings.textContent = 'Hide settings';
    }
    function collapseCookieSettings() {
      cookieSettingsPanel.hidden = true;
      openCookieSettings.setAttribute('aria-expanded', 'false');
      openCookieSettings.textContent = 'Settings';
    }

    openCookieSettings.setAttribute('aria-expanded', 'false');
    openCookieSettings.addEventListener('click', function () {
      if (cookieSettingsPanel.hidden) expandCookieSettings();
      else collapseCookieSettings();
    });
    acceptAllCookies.addEventListener('click', function () {
      analyticsCheckbox.checked = true;
      marketingCheckbox.checked = true;
      setStoredCookiePreferences({ necessary: true, analytics: true, marketing: true, consentedAt: new Date().toISOString() });
      hideCookieSheet();
    });
    saveCookiePreferences.addEventListener('click', function () {
      setStoredCookiePreferences({ necessary: true, analytics: analyticsCheckbox.checked, marketing: marketingCheckbox.checked, consentedAt: new Date().toISOString() });
      hideCookieSheet();
    });

    const existingCookiePreferences = getStoredCookiePreferences();
    if (!existingCookiePreferences) showCookieSheet();
    else {
      analyticsCheckbox.checked = !!existingCookiePreferences.analytics;
      marketingCheckbox.checked = !!existingCookiePreferences.marketing;
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    if (!routing.shouldRenderMarketingSite) return;

    const page = currentPageName();
    const pageShell = document.getElementById('pageShell');
    const headerMount = document.getElementById('headerMount');
    const footerMount = document.getElementById('footerMount');
    if (headerMount) headerMount.innerHTML = buildHeaderNav(page);
    if (footerMount) footerMount.innerHTML = buildFooter();

    applySharedImages();
    initMenuAndLanguage();
    initVideoModal();
    initCookies();

    if (pageShell) pageShell.hidden = false;
  });
})();
