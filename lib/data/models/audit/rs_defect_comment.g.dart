// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rs_defect_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RsDefectComment _$RsDefectCommentFromJson(Map<String, dynamic> json) =>
    RsDefectComment(
      checklistOperationId: (json['checklistoperationid'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      orgId: json['orgid'] as String?,
      notCreateSr: json['notcreatesr'] as bool?,
      woNum: json['wonum'] as String?,
      checklistWoId: (json['checklistwoid'] as num?)?.toInt(),
      siteId: json['siteid'] as String?,
      rsDefectCommentId: (json['rs_defectcommentid'] as num?)?.toInt(),
      href: json['href'] as String?,
    );

Map<String, dynamic> _$RsDefectCommentToJson(RsDefectComment instance) =>
    <String, dynamic>{
      'checklistoperationid': instance.checklistOperationId,
      'comment': instance.comment,
      'orgid': instance.orgId,
      'notcreatesr': instance.notCreateSr,
      'wonum': instance.woNum,
      'checklistwoid': instance.checklistWoId,
      'siteid': instance.siteId,
      'rs_defectcommentid': instance.rsDefectCommentId,
      'href': instance.href,
    };
