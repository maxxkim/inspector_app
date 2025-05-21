import 'package:inspector_tps/auth/redux/actions.dart';
import 'package:inspector_tps/auth/redux/user_state.dart';

UserState userReducer(UserState state, dynamic action) {
  if (action is UserAction) {
    return state.copyWith(
      user: action.userModel,
    );
  }
  return state;
}
