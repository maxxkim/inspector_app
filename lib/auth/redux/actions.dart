import 'package:flutter/foundation.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

@immutable
abstract class UserStateAction {}

// Action to log in the user and set authorization
class UserAction implements UserStateAction {
  final UserModel? userModel;

  UserAction(this.userModel);
}

// thunks
ThunkAction<AppState> loginThunk(String login, String pwd) => (store) async {
      store.dispatch(ShowLoader());
      final user = await userController.login(login: login, pwd: pwd);
      store.dispatch(UserAction(user));
      if (user != null) {
        userController.saveUser(user);
        final groups = user.userGroups ?? [];
        if(groups.contains(hoemp) &&  !areSitesLoaded) {
          store.dispatch(downloadSitesAction());
        }
      }
      store.dispatch(HideLoader());
    };

void logoutThunk(Store<AppState> store) {
  userController.logout();
  prefs.remove(PrefsKey.user);
  resetAllDbData();
  store.dispatch(ClearStateAction());
  saveDev(false);
  sl<MaximoSession>().config();
  connectivityService.initConnectivityStatus();
}
