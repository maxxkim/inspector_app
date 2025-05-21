// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      defaultOrg: json['defaultOrg'] as String?,
      defaultSite: json['defaultSite'] as String?,
      personId: json['personId'] as String?,
      loginID: json['loginID'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      userRole: json['userRole'] as String?,
      userGroups: (json['userGroups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'defaultOrg': instance.defaultOrg,
      'defaultSite': instance.defaultSite,
      'personId': instance.personId,
      'loginID': instance.loginID,
      'email': instance.email,
      'displayName': instance.displayName,
      'userRole': instance.userRole,
      'userGroups': instance.userGroups,
    };
