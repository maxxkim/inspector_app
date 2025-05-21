import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/view/audits_view.dart';
import 'package:inspector_tps/audit/view/checklist/checklist_view.dart';
import 'package:inspector_tps/auth/presentation/login_screen.dart';
import 'package:inspector_tps/auth/presentation/user_profile_view.dart';
import 'package:inspector_tps/claims/claims_view.dart';
import 'package:inspector_tps/claims/pick_asset_screen.dart';
import 'package:inspector_tps/claims/rz_detailed_view.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/photo_params.dart';
import 'package:inspector_tps/error/error_screen.dart';
import 'package:inspector_tps/home/home_screen.dart';
import 'package:inspector_tps/ppr/view/detailed/ppr_detailed_view.dart';
import 'package:inspector_tps/ppr/view/ppr_view.dart';

// final _parentNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root key');
final _shellAudit = GlobalKey<NavigatorState>(debugLabel: 'shellAudit');
final _shellClaims = GlobalKey<NavigatorState>(debugLabel: 'shellClaims');
final _shellTo = GlobalKey<NavigatorState>(debugLabel: 'shellPpr');
final _shellProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

enum AppRoute {
  login,
  audit,
  auditDetailed,
  claims,
  rzDetailed,
  pickAssetRoute,
  ppr,
  pprDetailed,
  profile,
  camera,
  error;

  String get route => '/$name';

  static AppRoute getRouteByIndex(int index) => switch (index) {
        0 => audit,
        1 => claims,
        2 => ppr,
        4 => profile,
        _ => profile,
      };
}

Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}

class AppNavigator {
  static final AppNavigator _instance = AppNavigator._internal();
  late GoRouter router;

  AppNavigator._internal();

  factory AppNavigator() {
    _instance.router = GoRouter(
      // navigatorKey: _parentNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: AppRoute.audit.route,
      routes: [
        StatefulShellRoute.indexedStack(
          // parentNavigatorKey: _parentNavigatorKey,
          pageBuilder: (context, state, navigationShell) {
            return getPage(
                child: BottomNavigationPage(
                  navigationShell: navigationShell,
                ),
                state: state);
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellAudit,
              initialLocation: AppRoute.audit.route,
              routes: [
                GoRoute(
                  path: AppRoute.audit.route,
                  pageBuilder: (context, state) => getPage(
                      child: AuditsView(key: UniqueKey()), state: state),
                ),
                GoRoute(
                  path: AppRoute.auditDetailed.route,
                  pageBuilder: (context, state) => getPage(
                      child: ChecklistView(key: UniqueKey()), state: state),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellClaims,
              routes: [
                GoRoute(
                  path: AppRoute.claims.route,
                  pageBuilder: (context, state) => getPage(
                      child: ClaimsView(key: UniqueKey()), state: state),
                ),
                GoRoute(
                  path: AppRoute.rzDetailed.route,
                  pageBuilder: (context, state) => getPage(
                      child: RzDetailedView(key: UniqueKey()), state: state),
                ),
                GoRoute(
                  path: AppRoute.pickAssetRoute.route,
                  pageBuilder: (context, state) => getPage(
                      child: PickAssetScreen(key: UniqueKey()), state: state),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellTo,
              routes: [
                GoRoute(
                  path: AppRoute.ppr.route,
                  pageBuilder: (context, state) =>
                      getPage(child: PprView(key: UniqueKey()), state: state),
                ),
                GoRoute(
                  path: AppRoute.pprDetailed.route,
                  pageBuilder: (context, state) => getPage(
                      child: PprDetailedView(key: UniqueKey()), state: state),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellProfile,
              routes: [
                GoRoute(
                  path: AppRoute.profile.route,
                  pageBuilder: (context, state) => getPage(
                      child: UserProfileView(
                        key: UniqueKey(),
                      ),
                      state: state),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
            path: AppRoute.login.route,
            builder: (context, state) => const LoginScreen()),
        GoRoute(
            path: AppRoute.error.route,
            builder: (context, state) => const ErrorScreen()),
        GoRoute(
          path: AppRoute.camera.route,
          builder: (context, state) {
            final params = state.extra as PhotoParams;
            return CameraScreen(
              wonum: params.wonum,
              checklistWoId: params.checklistwoid,
              mode: params.mode,
            );
          },
        ),
      ],
      redirect: (context, routerState) {
        final state = context.store.state;
        if (state.hasError) {
          return AppRoute.error.route;
        }
        if (!state.userState.isAuthorized) {
          return AppRoute.login.route;
        }
        return null;
      },
    );
    return _instance;
  }
}
