import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cicwtch/app/auth/auth_provider.dart';
import 'package:cicwtch/app/routing/app_router.dart';
import 'package:cicwtch/app/shell/app_shell.dart';
import 'package:cicwtch/features/auth/application/auth_service.dart';
import 'package:cicwtch/features/auth/data/auth_repository.dart';
import 'package:cicwtch/features/auth/presentation/login_screen.dart';
import 'package:cicwtch/features/landing/presentation/landing_page.dart';
import 'package:cicwtch/shared/data/api_client.dart';
import 'package:cicwtch/shared/data/api_config.dart';
import 'package:cicwtch/shared/utils/subdomain_detector.dart';
import 'package:cicwtch/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CiCwtchApp());
}

class CiCwtchApp extends StatefulWidget {
  const CiCwtchApp({super.key});

  @override
  State<CiCwtchApp> createState() => _CiCwtchAppState();
}

class _CiCwtchAppState extends State<CiCwtchApp> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    // Use a token-free client for auth calls; ApiConfig.bearerToken is
    // updated by AuthService once a session token is available.
    final api = ApiClient(
      baseUrl: ApiConfig.baseUrl,
      bearerToken: ApiConfig.bearerToken,
    );
    _authService = AuthService(AuthRepository(api));
    _authService.restoreSession();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      authService: _authService,
      child: ListenableBuilder(
        listenable: _authService,
        builder: (context, _) {
          return MaterialApp(
            title: 'CiCwtch',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            onGenerateRoute: AppRouter.generateRoute,
            home: _buildHome(),
          );
        },
      ),
    );
  }

  Widget _buildHome() {
    if (_authService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_authService.isAuthenticated) {
      return const AppShell();
    }
    // Show the landing page only on Flutter web AND on the root domain
    // (cicwtch.app).  Tenant subdomains and native platforms (iOS/Android)
    // bypass the landing page and go straight to the login screen.
    if (kIsWeb && SubdomainDetector.isRootDomain) {
      return LandingPage(
        onCtaTapped: () {
          Navigator.of(context).pushNamed(AppRoutes.login);
        },
      );
    }
    return const LoginScreen();
  }
}
