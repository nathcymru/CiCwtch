import 'package:flutter/widgets.dart';

import 'package:cicwtch/features/auth/application/auth_service.dart';

/// Makes [AuthService] available to the widget tree via [InheritedNotifier].
///
/// Widgets that call [AuthProvider.of] will rebuild when [AuthService] notifies.
class AuthProvider extends InheritedNotifier<AuthService> {
  const AuthProvider({
    super.key,
    required AuthService authService,
    required super.child,
  }) : super(notifier: authService);

  static AuthService of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(provider != null, 'No AuthProvider found in widget tree.');
    return provider!.notifier!;
  }
}
