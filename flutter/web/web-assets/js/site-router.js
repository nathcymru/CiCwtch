(function () {
  const PUBLIC_ROOT_HOSTS = new Set(['cicwtch.app', 'www.cicwtch.app']);
  const DEV_PUBLIC_HOSTS = new Set(['localhost', '127.0.0.1']);
  const host = window.location.hostname.toLowerCase();
  const path = window.location.pathname;
  const isDev = DEV_PUBLIC_HOSTS.has(host) || host.endsWith('.pages.dev') || host.endsWith('.workers.dev');
  const isPublicRoot = PUBLIC_ROOT_HOSTS.has(host) || isDev;
  const isPublicMarketingPath = path === '/' || path === '/index.html' || path === '/tos.htm' || path === '/trust.htm' || path === '/legal_trust.htm';
  const shouldRenderMarketingSite = isPublicRoot && isPublicMarketingPath;

  window.CICWTCH_ROUTING = {
    host,
    path,
    isPublicRoot,
    isPublicMarketingPath,
    shouldRenderMarketingSite
  };

  if (!shouldRenderMarketingSite) {
    document.documentElement.classList.add('flutter-app-mode');
    document.addEventListener('DOMContentLoaded', function () {
      const marketingRoot = document.getElementById('marketingRoot');
      if (marketingRoot) {
        marketingRoot.classList.add('flutter-host-hidden');
      }
      const flutterScript = document.createElement('script');
      flutterScript.src = 'flutter_bootstrap.js';
      flutterScript.async = true;
      document.body.appendChild(flutterScript);
    });
  }
})();
