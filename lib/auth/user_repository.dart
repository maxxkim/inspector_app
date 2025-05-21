import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/data/models/user/user_request.dart';

class UserRepository {
  UserRepository(this._session);

  final MaximoSession _session;

  Future<bool> login(UserRequest request, {bool dispatchError = true}) async {
    final response = await _session.get(Endpoints.login,
        headers: request.headers, dispatchError: dispatchError);
    debugPrint(
        'response code: ${response?.statusCode} headers: ${response?.headers}');
    if (response is Response && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<UserModel?> whoAmI({bool dispatchError = false}) async {
    try {
      final response =
          await _session.get(Endpoints.whoAmI, dispatchError: dispatchError);
      final user = UserModel.fromJson(response.data);
      debugPrint(user.toString());
      return user;
    } catch (ex) {
      debugPrint('err whoAmI: $ex');
      return null;
    }
  }

  Future<(List<String>?, String)> userGroups() async {
    try {
      final Response urlResponse = await _session.get(Endpoints.userGroups);
      final data = (urlResponse.data['member'] as List<dynamic>).first;
      final href = data['href'];
      final groupsResponse = await _session.get(href);
      final groups = groupsResponse.data['groupuser'] as List<dynamic>;
      String role = '';
      try {
        role = ((groupsResponse.data['ipcrole'] as List<dynamic>).first
            as Map<String, dynamic>)['description'];
      } catch (ex) {
        debugPrint('cannot get role: $ex');
      }
      final res = <String>[];
      for (var map in groups) {
        res.add(map['groupname']);
      }
      return (res, role);
    } catch (ex) {
      debugPrint('err userGroups: $ex');
      return (null, '');
    }
  }

  void resetCookie() {
    _session.resetCookie();
  }
}
