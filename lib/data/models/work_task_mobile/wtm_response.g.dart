// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wtm_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WtmResponse _$WtmResponseFromJson(Map<String, dynamic> json) => WtmResponse(
      member: (json['member'] as List<dynamic>?)
          ?.map((e) => WorkTaskMobile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WtmResponseToJson(WtmResponse instance) =>
    <String, dynamic>{
      'member': instance.member,
    };
