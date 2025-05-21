// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worklog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Worklog _$WorklogFromJson(Map<String, dynamic> json) => Worklog(
      wonum: json['wonum'] as String?,
      worklogid: (json['worklogid'] as num?)?.toInt(),
      createby: json['createby'] as String?,
      fromName: json['createdby_displayname'] as String?,
      createdate: json['createdate'] as String?,
      localref: json['localref'] as String?,
      description: json['description'] as String?,
      recordkey: json['recordkey'] as String?,
      fresh: json['fresh'] as bool? ?? false,
    );

Map<String, dynamic> _$WorklogToJson(Worklog instance) => <String, dynamic>{
      'wonum': instance.wonum,
      'worklogid': instance.worklogid,
      'createby': instance.createby,
      'createdby_displayname': instance.fromName,
      'createdate': instance.createdate,
      'localref': instance.localref,
      'description': instance.description,
      'recordkey': instance.recordkey,
      'fresh': instance.fresh,
    };
