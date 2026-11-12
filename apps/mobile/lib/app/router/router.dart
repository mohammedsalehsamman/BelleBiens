import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/core/widgets/bb_bottom_nav.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/placeholder_screen.dart';
import 'package:belle_biens/features/account/presentation/account_screen.dart';
import 'package:belle_biens/features/auth/domain/otp_challenge.dart';
import 'package:belle_biens/features/auth/presentation/complete_profile_screen.dart';
import 'package:belle_biens/features/auth/presentation/login_screen.dart';
import 'package:belle_biens/features/auth/presentation/otp_screen.dart';
import 'package:belle_biens/features/auth/presentation/register_screen.dart';
import 'package:belle_biens/features/catalog/presentation/branch_screen.dart';
import 'package:belle_biens/features/catalog/presentation/favorites_screen.dart';
import 'package:belle_biens/features/catalog/presentation/home_screen.dart';
import 'package:belle_biens/features/catalog/presentation/occasion_screen.dart';
import 'package:belle_biens/features/catalog/presentation/product_screen.dart';
import 'package:belle_biens/features/catalog/presentation/search_screen.dart';
import 'package:belle_biens/features/catalog/presentation/shop_screen.dart';
import 'package:belle_biens/features/catalog/presentation/today_screen.dart';
import 'package:belle_biens/features/designer/presentation/designer_screen.dart';
import 'package:belle_biens/features/notifications/presentation/notification_permission_screen.dart';
import 'package:belle_biens/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

export 'routes.dart';

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    // The welcome screen comes first, once (screen 01).
    redirect: (context, state) {
      final prefs = ref.read(appPreferencesProvider);
      if (!prefs.onboardingSeen &&
          !Routes.isPreOnboarding(state.matchedLocation)) {
        return Routes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.otp,
        // The code screen only makes sense right after a code was sent.
        redirect: (context, state) =>
            state.extra is OtpChallenge ? null : Routes.login,
        builder: (context, state) =>
            OtpScreen(challenge: state.extra! as OtpChallenge),
      ),
      GoRoute(
        path: Routes.completeProfile,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: Routes.notificationPermission,
        builder: (context, state) => const NotificationPermissionScreen(),
      ),
      // Full-screen catalog pages, above the tab bar (screens 08, 12-14, 32,
      // 34). Today's flowers and occasions keep the tabs (screens 10, 11).
      GoRoute(
        path: Routes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/p/:slug',
        builder: (context, state) =>
            ProductScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: Routes.branch,
        builder: (context, state) => const BranchScreen(),
      ),
      GoRoute(
        path: '/pages/:slug',
        builder: (context, state) =>
            PolicyPageScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: Routes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _TabShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'today',
                    builder: (context, state) => const TodayScreen(),
                  ),
                  GoRoute(
                    path: 'occasions/:slug',
                    builder: (context, state) =>
                        OccasionScreen(slug: state.pathParameters['slug']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.shop,
                builder: (context, state) => const ShopScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.designer,
                builder: (context, state) => const DesignerScreen(),
              ),
            ],
          ),
          _placeholderTab(Routes.orders, (l) => l.navOrders, sprint: 'S6'),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _placeholderTab(
  String path,
  String Function(AppLocalizations) title, {
  required String sprint,
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => PlaceholderScreen(
          title: title(AppLocalizations.of(context)),
          sprint: sprint,
        ),
      ),
    ],
  );
}

class _TabShell extends StatelessWidget {
  const new({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: BBBottomNav(
        currentIndex: shell.currentIndex,
        onSelect: (index) =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        items: [
          BBNavItem(icon: BBIcons.home, label: l10n.navHome),
          BBNavItem(icon: BBIcons.grid, label: l10n.navShop),
          BBNavItem(icon: BBIcons.flower, label: l10n.navDesigner),
          BBNavItem(icon: BBIcons.receipt, label: l10n.navOrders),
          BBNavItem(icon: BBIcons.user, label: l10n.navAccount),
        ],
      ),
    );
  }
}
