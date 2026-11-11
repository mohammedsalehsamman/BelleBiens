import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/core/widgets/bb_bottom_nav.dart';
import 'package:belle_biens/core/widgets/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Route paths (plan 4.8). Screens replace the placeholders sprint by sprint.
abstract final class Routes {
  static const home = '/';
  static const shop = '/shop';
  static const designer = '/designer';
  static const orders = '/orders';
  static const account = '/account';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _TabShell(shell: shell),
        branches: [
          _tab(Routes.home, (l) => l.navHome, sprint: 'S2'),
          _tab(Routes.shop, (l) => l.navShop, sprint: 'S2'),
          _tab(Routes.designer, (l) => l.navDesigner, sprint: 'S3'),
          _tab(Routes.orders, (l) => l.navOrders, sprint: 'S6'),
          _tab(Routes.account, (l) => l.navAccount, sprint: 'S7'),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _tab(
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
          BBNavItem(icon: Icons.home_outlined, label: l10n.navHome),
          BBNavItem(icon: Icons.grid_view_outlined, label: l10n.navShop),
          BBNavItem(
            icon: Icons.local_florist_outlined,
            label: l10n.navDesigner,
          ),
          BBNavItem(icon: Icons.receipt_long_outlined, label: l10n.navOrders),
          BBNavItem(icon: Icons.person_outline, label: l10n.navAccount),
        ],
      ),
    );
  }
}
