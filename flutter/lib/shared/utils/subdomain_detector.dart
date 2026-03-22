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

  /// True when the app is running on the root domain (cicwtch.app) or on
  /// localhost / a non-web platform.  In these cases the landing page is
  /// shown to unauthenticated users.
  static bool get isRootDomain {
    final host = hostname;
    // Non-web or localhost — treat as root so developers see the full flow.
    if (host.isEmpty || host == 'localhost' || host == '127.0.0.1') {
      return true;
    }
    // Exact match: cicwtch.app (with or without port, just in case).
    final hostWithoutPort = host.split(':').first;
    return hostWithoutPort == _rootDomain;
  }

  /// True when the app is running on a tenant subdomain (*.cicwtch.app).
  static bool get isTenantSubdomain => !isRootDomain;
}
