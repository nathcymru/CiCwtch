
(function () {
  const assets = window.CICWTCH_ASSETS || {};
  const rules = window.CICWTCH_HOST_RULES || {};
  const COOKIE_STORAGE_KEY = "cicwtch-cookie-preferences-v1";

  function getHost() {
    return window.location.hostname.toLowerCase();
  }

  function isTenantSubdomain(host) {
    const apexHosts = rules.apexHosts || [];
    return host.endsWith('.cicwtch.app') && !apexHosts.includes(host);
  }

  function isMarketingPreviewHost(host) {
    return (rules.marketingPreviewHosts || []).includes(host) || host.endsWith('.pages.dev');
  }

  function isFlutterFirstPath(pathname) {
    return (rules.flutterFirstPaths || []).some((prefix) => pathname === prefix || pathname.startsWith(prefix + '/'));
  }

  function shouldBootFlutter() {
    const page = document.body.dataset.page || 'home';
    if (page !== 'home') return false;

    const host = getHost();
    const apexHosts = rules.apexHosts || [];
    const pathname = window.location.pathname;

    if (isTenantSubdomain(host)) return true;
    if (isFlutterFirstPath(pathname)) return true;
    if (host === '' || host === '0.0.0.0') return true;
    if (apexHosts.includes(host) || isMarketingPreviewHost(host)) return false;

    return true;
  }

  function loadFlutter() {
    const marketingShell = document.getElementById('marketingShell');
    const flutterShell = document.getElementById('flutterShell');
    if (marketingShell) marketingShell.hidden = true;
    if (flutterShell) flutterShell.hidden = false;

    const script = document.createElement('script');
    script.src = 'flutter_bootstrap.js';
    script.async = true;
    document.body.appendChild(script);
  }

  async function loadPartial(path, mountId) {
    const mount = document.getElementById(mountId);
    if (!mount) return;
    const response = await fetch(path, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`Failed to load ${path}`);
    mount.innerHTML = await response.text();
  }

  function setImage(id, src) {
    const el = document.getElementById(id);
    if (el && src) el.src = src;
  }

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

  function getFocusableElements(container) {
    return Array.from(
      container.querySelectorAll('a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), iframe, [tabindex]:not([tabindex="-1"])')
    ).filter((element) => !element.hasAttribute('hidden') && element.offsetParent !== null);
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

  function bindCommonAssets() {
    setImage('appLogoEl', assets.appLogo);
    setImage('footerLogoEl', assets.appLogo);
    setImage('appleBadgeEl', assets.appleBadge);
    setImage('googleBadgeEl', assets.googleBadge);
    setImage('footerAppleBadgeEl', assets.appleBadge);
    setImage('footerGoogleBadgeEl', assets.googleBadge);

    const year = new Date().getFullYear();
    const footerCopyright = document.getElementById('footerCopyright');
    if (footerCopyright) {
      footerCopyright.textContent = `© 2024–${year} Nathan Jones t/a CiCwtch. All rights reserved.`;
    }
  }

  function bindHomeAssets() {
    setImage('heroImageEl', assets.heroImage);
    setImage('warmImageEl', assets.warmImage);
    setImage('cafeImageEl', assets.cafeImage);
    setImage('walkingImageEl', assets.walkingImage);
    setImage('pawsomeWalesImageEl', assets.pawsomeWalesImage);
  }

  function bindNavigation() {
    const siteHeader = document.getElementById('siteHeader');
    const menuToggle = document.getElementById('menuToggle');
    const primaryNav = document.getElementById('primaryNav');
    const mobileBreakpoint = window.matchMedia('(max-width: 760px)');
    const languageMenu = document.getElementById('languageMenu');
    const languageToggle = document.getElementById('languageToggle');
    const languageDropdown = document.getElementById('languageDropdown');
    const languageLinks = languageDropdown ? Array.from(languageDropdown.querySelectorAll('a')) : [];

    if (!siteHeader || !menuToggle || !primaryNav || !languageMenu || !languageToggle || !languageDropdown) return;

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

  function bindVideoModal() {
    const pageShell = document.getElementById('pageShell');
    const modal = document.getElementById('videoModal');
    const openVideoModalBtn = document.getElementById('openVideoModal');
    const closeVideoModalBtn = document.getElementById('closeVideoModal');
    const modalTrialBtn = document.getElementById('modalTrialBtn');
    const videoFrame = document.getElementById('videoFrame');
    if (!pageShell || !modal || !openVideoModalBtn || !closeVideoModalBtn || !modalTrialBtn || !videoFrame) return;

    let lastFocusedElement = null;

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
      videoFrame.src = assets.videoEmbedUrl || '';
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
    modalTrialBtn.addEventListener('click', closeVideoModal);
    modal.addEventListener('click', (event) => { if (event.target === modal) closeVideoModal(); });
    modal.addEventListener('keydown', function (event) {
      trapFocus(event, modal);
      if (event.key === 'Escape') {
        event.preventDefault();
        closeVideoModal();
      }
    });
  }

  function bindCookieSheet() {
    const cookieSheet = document.getElementById('cookieSheet');
    const cookieSettingsPanel = document.getElementById('cookieSettingsPanel');
    const openCookieSettings = document.getElementById('openCookieSettings');
    const acceptAllCookies = document.getElementById('acceptAllCookies');
    const saveCookiePreferences = document.getElementById('saveCookiePreferences');
    const analyticsCheckbox = document.getElementById('cookieAnalytics');
    const marketingCheckbox = document.getElementById('cookieMarketing');
    if (!cookieSheet || !cookieSettingsPanel || !openCookieSettings || !acceptAllCookies || !saveCookiePreferences || !analyticsCheckbox || !marketingCheckbox) return;

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

  async function loadMarketingShell() {
    const marketingShell = document.getElementById('marketingShell');
    if (marketingShell) marketingShell.hidden = false;

    await loadPartial('partials/site-status.html', 'siteStatusMount');
    await loadPartial('partials/nav.html', 'navMount');
    await loadPartial('partials/footer.html', 'footerMount');

    const page = document.body.dataset.page || 'home';
    if (page === 'home') {
      await loadPartial('partials/home-content.html', 'mainMount');
      await loadPartial('partials/cookie-sheet.html', 'cookieMount');
      await loadPartial('partials/video-modal.html', 'videoMount');
    }

    bindCommonAssets();
    bindNavigation();
    if (page === 'home') {
      bindHomeAssets();
      bindCookieSheet();
      bindVideoModal();
    }
  }

  if (shouldBootFlutter()) {
    loadFlutter();
  } else {
    loadMarketingShell().catch(function (error) {
      console.error(error);
      document.body.innerHTML = '<main class="app-loading"><div class="app-loading__box"><strong>CiCwtch page failed to load.</strong><p style="margin:12px 0 0; color: var(--ink-soft);">Please refresh and try again.</p></div></main>';
    });
  }
})();
