// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'woactivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Woactivity _$WoactivityFromJson(Map<String, dynamic> json) => Woactivity(
      wonum: json['wonum'] as String?,
      description: json['description'] as String?,
      pprcomment: json['pprcomment'] as String?,
      pprresult: json['pprresult'] as String?,
      wosequence: (json['wosequence'] as num?)?.toInt(),
      estdur: (json['estdur'] as num?)?.toDouble(),
      taskid: (json['taskid'] as num?)?.toInt(),
      localref: json['localref'] as String?,
    );

Map<String, dynamic> _$WoactivityToJson(Woactivity instance) =>
    <String, dynamic>{
      'wonum': instance.wonum,
      'description': instance.description,
      'pprcomment': instance.pprcomment,
      'pprresult': instance.pprresult,
      'localref': instance.localref,
      'wosequence': instance.wosequence,
      'estdur': instance.estdur,
      'taskid': instance.taskid,
    };
