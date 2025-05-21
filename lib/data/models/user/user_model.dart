import 'package:inspector_tps/core/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? defaultOrg;
  String? defaultSite;
  String? personId;
  String? loginID;
  String? email;
  String? displayName;
  String? userRole;
  List<String>? userGroups;

  UserModel({
    this.defaultOrg,
    this.defaultSite,
    this.personId,
    this.loginID,
    this.email,
    this.displayName,
    this.userRole,
    this.userGroups,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? defaultOrg,
    String? defaultSite,
    String? personId,
    String? loginID,
    String? email,
    String? displayName,
    String? userRole,
    List<String>? userGroups,
  }) {
    return UserModel(
      defaultOrg: defaultOrg ?? this.defaultOrg,
      defaultSite: defaultSite ?? this.defaultSite,
      personId: personId ?? this.personId,
      loginID: loginID ?? this.loginID,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      userRole: userRole ?? this.userRole,
      userGroups: userGroups ?? this.userGroups,
    );
  }

  bool get isFilManager {
    final List<String> groups = userGroups ?? [];
    return groups.contains(bdd) || groups.contains(hoemp);
  }

  bool get isDutyEng {
    final List<String> groups = userGroups ?? [];
    return groups.contains(dutyEngGroup);
  }

  bool get isItr {
    final List<String> groups = userGroups ?? [];
    return groups.contains(ceew);
  }

  bool get isCo {
    final List<String> groups = userGroups ?? [];
    return groups.contains(hoemp);
  }

  bool get isItrAndDutyEng => isItr && isDutyEng;

  List<int> hiddenTabs() {
    if (isDutyEng && !isItr) {
      return [0];
    }
    return [];
  }

  @override
  String toString() {
    return 'UserModel{defaultOrg: $defaultOrg, defaultSite: $defaultSite,'
        'personId: $personId, loginID: $loginID, email: $email,'
        'displayName: $displayName}, userRole: $userRole';
  }
}
