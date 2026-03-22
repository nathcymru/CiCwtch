import 'package:flutter/foundation.dart';

/// Detects whether the app is running on the root domain or a tenant subdomain.
///
/// On the root domain (cicwtch.app) unauthenticated visitors should see the
/// landing page.  On any tenant subdomain (*.cicwtch.app) the app skips the
/// landing page and goes directly to the login / app flow.
///
/// Non-web platforms always return [isRootDomain] == true so that the normal
/// app flow is used during development and for native builds.
class SubdomainDetector {
  SubdomainDetector._();

  static const String _rootDomain = 'cicwtch.app';

  /// Returns the current hostname.  On non-web platforms returns an empty
  /// string so that [isRootDomain] evaluates to true.
  static String get hostname {
    if (kIsWeb) {
      return Uri.base.host;
    }
    return '';
  }

  // ---------------------------------------------------------------------------
  // Pure host-string helpers — extracted so they can be unit-tested without
  // any platform / web context.
  // ---------------------------------------------------------------------------

  /// Returns true when [host] is the root domain, localhost, or empty
  /// (non-web platform).
  static bool isRootDomainForHost(String host) {
    if (host.isEmpty || host == 'localhost' || host == '127.0.0.1') {
      return true;
    }
    final hostWithoutPort = host.split(':').first;
    return hostWithoutPort == _rootDomain;
  }

  /// Returns true when [host] is an explicit tenant subdomain
  /// (`*.cicwtch.app`).  Any other host (preview domains, unknown hosts, etc.)
  /// is NOT treated as a tenant subdomain; it falls through to the root /
  /// landing-page flow.
  static bool isTenantSubdomainForHost(String host) {
    if (host.isEmpty) return false;
    final hostWithoutPort = host.split(':').first;
    return hostWithoutPort != _rootDomain &&
        hostWithoutPort.endsWith('.$_rootDomain');
  }

  // ---------------------------------------------------------------------------
  // Runtime accessors
  // ---------------------------------------------------------------------------

  /// True when the app is running on the root domain (cicwtch.app) or on
  /// localhost / a non-web platform.  In these cases the landing page is
  /// shown to unauthenticated users (web only).
  static bool get isRootDomain => isRootDomainForHost(hostname);

  /// True when the app is running on a tenant subdomain (*.cicwtch.app).
  /// Preview domains and other unrecognised hosts are treated as root.
  static bool get isTenantSubdomain => isTenantSubdomainForHost(hostname);
}
