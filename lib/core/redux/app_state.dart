import 'package:flutter/foundation.dart';
import 'package:inspector_tps/audit/redux/audits_state.dart';
import 'package:inspector_tps/auth/redux/user_state.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/error/app_error.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';

@immutable
class AppState {
  final UserState userState;
  final AuditsState auditsState;
  final PprState pprState;
  final ClaimsState claimsState;
  final bool showLoader;
  final AppError? error;
  final int tabIndex;
  final bool isDev;
  final bool isConnected;

  const AppState._({
    required this.userState,
    required this.auditsState,
    required this.pprState,
    required this.claimsState,
    this.error,
    this.showLoader = false,
    this.isDev = false,
    this.tabIndex = 0,
    this.isConnected = false,
  });

  factory AppState.initial() => AppState._(
        userState: UserState.initial(),
        auditsState: AuditsState.initial(),
        pprState: PprState.initial(),
        claimsState: ClaimsState.initial(),
        error: null,
        showLoader: false,
        isDev: false,
        tabIndex: 0,
        isConnected: false,
      );

  AppState copyWith({
    UserState? userState,
    AuditsState? auditsState,
    PprState? pprState,
    ClaimsState? claimsState,
    bool? showLoader,
    bool? isDev,
    AppError? error,
    int? tabIndex,
    bool clearError = false,
    bool? isConnected,
  }) {
    return AppState._(
      userState: userState ?? this.userState,
      auditsState: auditsState ?? this.auditsState,
      pprState: pprState ?? this.pprState,
      claimsState: claimsState ?? this.claimsState,
      showLoader: showLoader ?? this.showLoader,
      isDev: isDev ?? this.isDev,
      error: clearError ? null : (error ?? this.error),
      tabIndex: tabIndex ?? this.tabIndex,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  bool get hasError => error != null;
}
