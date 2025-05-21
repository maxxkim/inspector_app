import 'package:flutter/foundation.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

@immutable
class UserState {
  const UserState._({
    this.user,
  });

  factory UserState.initial() => const UserState._();

  final UserModel? user;

  UserState copyWith({
    UserModel? user,
  }) {
    return UserState._(
      user: user ?? this.user,
    );
  }

  bool get isAuthorized => user != null;

  bool get showAudits {
    final groups = user?.userGroups ?? [];
    return groups.contains(ceew) ||
        groups.contains(hoemp) ||
        groups.contains(bdd);
  }

  // bool get showPpr {
  //   return (user?.isItr ?? false) ||
  //       (user?.isDutyEng ?? false) ||
  //       (user?.isFilManager ?? false);
  // }

  bool get showPpr => true;

  bool get showRz => true;
}
