import 'package:flutter_test/flutter_test.dart';

import 'package:cicwtch/shared/utils/subdomain_detector.dart';

void main() {
  group('SubdomainDetector.isRootDomainForHost', () {
    test('empty string (non-web) is treated as root domain', () {
      expect(SubdomainDetector.isRootDomainForHost(''), isTrue);
    });

    test('localhost is treated as root domain', () {
      expect(SubdomainDetector.isRootDomainForHost('localhost'), isTrue);
    });

    test('127.0.0.1 is treated as root domain', () {
      expect(SubdomainDetector.isRootDomainForHost('127.0.0.1'), isTrue);
    });

    test('cicwtch.app is the root domain', () {
      expect(SubdomainDetector.isRootDomainForHost('cicwtch.app'), isTrue);
    });

    test('tenant.cicwtch.app is NOT the root domain', () {
      expect(
          SubdomainDetector.isRootDomainForHost('tenant.cicwtch.app'), isFalse);
    });

    test('unknown preview domain is NOT the root domain', () {
      expect(
          SubdomainDetector.isRootDomainForHost('abc123.pages.dev'), isFalse);
    });
  });

  group('SubdomainDetector.isTenantSubdomainForHost', () {
    test('empty string (non-web) is NOT a tenant subdomain', () {
      expect(SubdomainDetector.isTenantSubdomainForHost(''), isFalse);
    });

    test('cicwtch.app is NOT a tenant subdomain', () {
      expect(
          SubdomainDetector.isTenantSubdomainForHost('cicwtch.app'), isFalse);
    });

    test('tenant.cicwtch.app IS a tenant subdomain', () {
      expect(SubdomainDetector.isTenantSubdomainForHost('tenant.cicwtch.app'),
          isTrue);
    });

    test('multi-segment subdomain IS a tenant subdomain', () {
      expect(SubdomainDetector.isTenantSubdomainForHost('a.b.cicwtch.app'),
          isTrue);
    });

    test('unrelated preview domain is NOT a tenant subdomain', () {
      expect(SubdomainDetector.isTenantSubdomainForHost('abc123.pages.dev'),
          isFalse);
    });
  });

  group('SubdomainDetector runtime accessors (non-web)', () {
    // In a non-web test environment, hostname returns '' and therefore the
    // runtime accessors fall back to the root-domain behaviour.

    test('isRootDomain is true in non-web (test) environment', () {
      expect(SubdomainDetector.isRootDomain, isTrue);
    });

    test('isTenantSubdomain is false in non-web (test) environment', () {
      expect(SubdomainDetector.isTenantSubdomain, isFalse);
    });
  });
}
