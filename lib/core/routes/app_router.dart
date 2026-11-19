import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/widgets/custom_transition_page_widget.dart';
import 'package:teqbae_test/view/dashboard/dashboard_screen.dart';
import 'package:teqbae_test/view/leave/leave_apply_screen.dart';
import 'package:teqbae_test/view/leave/leave_screen.dart';
import 'package:teqbae_test/view/settings/profile/profile_screen.dart';
import 'package:teqbae_test/view/settings/settings_screen.dart';

class GlobalContextService {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

final GoRouter appRouter = GoRouter(
  navigatorKey: GlobalContextService.rootNavigatorKey,
  observers: [appRouteObserver],
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RouteNames.dashboard,
      pageBuilder: (context, state) => customTransitionPageWidget(
        child: const DashboardScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/leave',
      name: RouteNames.leave,
      pageBuilder: (context, state) => customTransitionPageWidget(
        child: const LeaveScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/leave/apply',
      name: RouteNames.applyLeave,
      pageBuilder: (context, state) => customTransitionPageWidget(
        child: const LeaveApplyScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/settings',
      name: RouteNames.settings,
      pageBuilder: (context, state) => customTransitionPageWidget(
        child: const SettingsScreen(),
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      pageBuilder: (context, state) => customTransitionPageWidget(
        child: const ProfileScreen(),
        key: state.pageKey,
      ),
    ),
  ],
);
