import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/auth/redux/actions.dart';
import 'package:inspector_tps/auth/user_repository.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/data/models/user/user_request.dart';

class UserController {
  UserController(this.api);

  final UserRepository api;

  Future<UserModel?> login({required String login, required String pwd}) async {
    saveCreds(login, pwd);
    try {
      api.resetCookie();
      final response =
          await api.login(UserRequest(identifier: login, password: pwd));
      if (response) {
        final whoAmI = await api.whoAmI();
        final response = await api.userGroups();
        final groups = response.$1;
        final role = response.$2;
        final user = whoAmI?.copyWith(userGroups: groups, userRole: role);
        return user;
      }
    } catch (err) {
      debugPrint('login error: $err');
    }
    return null;
  }

  Future<bool> isAuthorized() async {
    final user = await api.whoAmI();
    return user != null;
  }

  Future<void> checkAuthorization() async {
    var authorized = await isAuthorized();
    if (authorized) {
      return;
    }
    api.resetCookie();
    final creds = getCreds();
    await api.login(UserRequest(identifier: creds.$1, password: creds.$2),
        dispatchError: false);
    authorized = await isAuthorized();
    if (!authorized) {
      appStore.dispatch(logoutThunk);
    }
  }

  static const _splitter = '^:^';

  void logout() {
    api.resetCookie();
    // saveCreds('', ''); // https://jira.infoteam.msk.ru/browse/TPTPS-917 2) после выхода сохранять логин пользователя под которым я был авторизован00

  }



  void saveCreds(String login, String pwd) {
    prefs.setString(PrefsKey.creds, '$login$_splitter$pwd');
  }

  (String, String) getCreds() {
    final creds = prefs.getString(PrefsKey.creds);
    if (creds == null) {
      return ('', '');
    }
    final split = creds.split(_splitter);
    return (split.first, split.last);
  }

  void saveUser(UserModel user) {
    final json = user.toJson();
    prefs.setString(PrefsKey.user, jsonEncode(json));
  }

  void getUser() {
    final userString = prefs.getString(PrefsKey.user);
    try {
      final user = jsonDecode(userString ?? '');
      appStore.dispatch(UserAction(UserModel.fromJson(user)));
    } catch (err) {
      debugPrint('user decode err: $err');
    }
  }
}
