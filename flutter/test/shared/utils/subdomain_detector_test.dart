import 'package:flutter_test/flutter_test.dart';

import 'package:cicwtch/shared/utils/subdomain_detector.dart';

void main() {
  group('SubdomainDetector', () {
    // The test environment is non-web, so hostname returns '' and
    // isRootDomain returns true by design.

    test('isRootDomain is true in non-web (test) environment', () {
      expect(SubdomainDetector.isRootDomain, isTrue);
    });

    test('isTenantSubdomain is the inverse of isRootDomain', () {
      expect(SubdomainDetector.isTenantSubdomain,
          equals(!SubdomainDetector.isRootDomain));
    });
  });
}
