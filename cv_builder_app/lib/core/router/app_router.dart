import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import feature screens (will be created later)
// import '../../features/auth/presentation/screens/auth_screen.dart';
// import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
// import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
// import '../../features/ai_cv_builder/presentation/screens/ai_chat_screen.dart';
// import '../../features/manual_cv_builder/presentation/screens/template_gallery_screen.dart';

/// App Router Configuration
/// Handles navigation and routing throughout the application
class AppRouter {
  AppRouter._();

  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String aiCvBuilder = '/ai-cv-builder';
  static const String manualCvBuilder = '/manual-cv-builder';
  static const String templateGallery = '/templates';
  static const String cvEditor = '/cv-editor';
  static const String coverLetter = '/cover-letter';
  static const String preview = '/preview';
  static const String export = '/export';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Router Configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Flow
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Main Dashboard
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // AI CV Builder Flow
          GoRoute(
            path: 'ai-cv-builder',
            name: 'ai-cv-builder',
            builder: (context, state) => const AIChatScreen(),
            routes: [
              GoRoute(
                path: 'preview',
                name: 'ai-preview',
                builder: (context, state) {
                  final cvId = state.pathParameters['cvId'];
                  return PreviewScreen(cvId: cvId);
                },
              ),
            ],
          ),

          // Manual CV Builder Flow
          GoRoute(
            path: 'manual-cv-builder',
            name: 'manual-cv-builder',
            builder: (context, state) => const TemplateGalleryScreen(),
            routes: [
              GoRoute(
                path: 'editor/:templateId',
                name: 'cv-editor',
                builder: (context, state) {
                  final templateId = state.pathParameters['templateId']!;
                  final cvId = state.uri.queryParameters['cvId'];
                  return CVEditorScreen(templateId: templateId, cvId: cvId);
                },
              ),
            ],
          ),

          // Cover Letter Generator
          GoRoute(
            path: 'cover-letter',
            name: 'cover-letter',
            builder: (context, state) {
              final cvId = state.uri.queryParameters['cvId'];
              return CoverLetterScreen(cvId: cvId);
            },
          ),

          // Export & Preview
          GoRoute(
            path: 'preview/:cvId',
            name: 'preview',
            builder: (context, state) {
              final cvId = state.pathParameters['cvId']!;
              return PreviewScreen(cvId: cvId);
            },
            routes: [
              GoRoute(
                path: 'export',
                name: 'export',
                builder: (context, state) {
                  final cvId = state.pathParameters['cvId']!;
                  return ExportScreen(cvId: cvId);
                },
              ),
            ],
          ),

          // User Profile
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Settings
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Redirect logic for authentication
    redirect: (context, state) {
      // This will be implemented with authentication provider
      return null;
    },
  );
}

/// Navigation Helper
class AppNavigation {
  AppNavigation._();

  /// Navigate to splash screen
  static void toSplash(BuildContext context) {
    context.go(AppRouter.splash);
  }

  /// Navigate to onboarding
  static void toOnboarding(BuildContext context) {
    context.go(AppRouter.onboarding);
  }

  /// Navigate to authentication
  static void toAuth(BuildContext context) {
    context.go(AppRouter.auth);
  }

  /// Navigate to dashboard
  static void toDashboard(BuildContext context) {
    context.go(AppRouter.dashboard);
  }

  /// Navigate to AI CV builder
  static void toAICVBuilder(BuildContext context) {
    context.go('${AppRouter.dashboard}/ai-cv-builder');
  }

  /// Navigate to manual CV builder
  static void toManualCVBuilder(BuildContext context) {
    context.go('${AppRouter.dashboard}/manual-cv-builder');
  }

  /// Navigate to template gallery
  static void toTemplateGallery(BuildContext context) {
    context.go('${AppRouter.dashboard}/manual-cv-builder');
  }

  /// Navigate to CV editor
  static void toCVEditor(
    BuildContext context,
    String templateId, {
    String? cvId,
  }) {
    final uri = Uri(
      path: '${AppRouter.dashboard}/manual-cv-builder/editor/$templateId',
      queryParameters: cvId != null ? {'cvId': cvId} : null,
    );
    context.go(uri.toString());
  }

  /// Navigate to cover letter generator
  static void toCoverLetter(BuildContext context, {String? cvId}) {
    final uri = Uri(
      path: '${AppRouter.dashboard}/cover-letter',
      queryParameters: cvId != null ? {'cvId': cvId} : null,
    );
    context.go(uri.toString());
  }

  /// Navigate to preview
  static void toPreview(BuildContext context, String cvId) {
    context.go('${AppRouter.dashboard}/preview/$cvId');
  }

  /// Navigate to export
  static void toExport(BuildContext context, String cvId) {
    context.go('${AppRouter.dashboard}/preview/$cvId/export');
  }

  /// Navigate to profile
  static void toProfile(BuildContext context) {
    context.go('${AppRouter.dashboard}/profile');
  }

  /// Navigate to settings
  static void toSettings(BuildContext context) {
    context.go('${AppRouter.dashboard}/settings');
  }

  /// Go back
  static void back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      toDashboard(context);
    }
  }
}

// Placeholder screens (will be replaced with actual implementations)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash Screen - Coming Soon')),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Onboarding Screen - Coming Soon')),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Auth Screen - Coming Soon')),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard Screen - Coming Soon')),
    );
  }
}

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('AI Chat Screen - Coming Soon')),
    );
  }
}

class TemplateGalleryScreen extends StatelessWidget {
  const TemplateGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Template Gallery Screen - Coming Soon')),
    );
  }
}

class CVEditorScreen extends StatelessWidget {
  final String templateId;
  final String? cvId;

  const CVEditorScreen({super.key, required this.templateId, this.cvId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('CV Editor Screen - Template: $templateId, CV: $cvId'),
      ),
    );
  }
}

class CoverLetterScreen extends StatelessWidget {
  final String? cvId;

  const CoverLetterScreen({super.key, this.cvId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Cover Letter Screen - Coming Soon')),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final String? cvId;

  const PreviewScreen({super.key, this.cvId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Preview Screen - CV: $cvId')));
  }
}

class ExportScreen extends StatelessWidget {
  final String cvId;

  const ExportScreen({super.key, required this.cvId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Export Screen - CV: $cvId')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen - Coming Soon')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Screen - Coming Soon')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Something went wrong'),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error.toString()),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => AppNavigation.toDashboard(context),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
