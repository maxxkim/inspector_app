import 'package:inspector_tps/audit/redux/audits_reducer.dart';
import 'package:inspector_tps/auth/redux/reducer.dart';
import 'package:inspector_tps/claims/redux/claims_reducer.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/ppr/redux/ppr_reducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is ShowLoader) {
    return state.copyWith(showLoader: true);
  } else if (action is IsDevAction) {
    return state.copyWith(isDev: action.isDev);
  } else if (action is HideLoader) {
    return state.copyWith(showLoader: false);
  } else if (action is AppErrorAction) {
    return state.copyWith(error: action.error);
  } else if (action is ClearErrorAction) {
    return state.copyWith(clearError: true);
  } else if (action is TabIndexAction) {
    return state.copyWith(tabIndex: action.index);
  } else if (action is IsConnectedAction) {
    return state.copyWith(isConnected: action.connected);
  } else if (action is ClearStateAction) {
    return AppState.initial();
  }
  return state.copyWith(
    userState: userReducer(state.userState, action),
    auditsState: auditsReducer(state.auditsState, action),
    pprState: pprReducer(state.pprState, action),
    claimsState: claimsReducer(state.claimsState, action),
  );
}
