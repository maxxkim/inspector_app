// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sr _$SrFromJson(Map<String, dynamic> json) => Sr(
      changedate: json['changedate'] as String?,
      statusDescription: json['statusDescription'] as String?,
      reportedpriorityDescription:
          json['reportedpriorityDescription'] as String?,
      classDescription: json['classDescription'] as String?,
      type: json['type'] as String?,
      ticketuid: (json['ticketuid'] as num?)?.toInt(),
      reportdate: json['reportdate'] as String?,
      orgid: json['orgid'] as String?,
      description: json['description'] as String?,
      typeDescription: json['typeDescription'] as String?,
      siteid: json['siteid'] as String?,
      href: json['href'] as String?,
      locdesc: json['locdesc'] as String?,
      repcatDescription: json['repcatDescription'] as String?,
      classstructureid: json['classstructureid'] as String?,
      statusdate: json['statusdate'] as String?,
      status: json['status'] as String?,
      changeby: json['changeby'] as String?,
      repcat: json['repcat'] as String?,
      ticketdesc: json['ticketdesc'] as String?,
      fromwho: json['fromwho'] as String?,
      reportedpriority: (json['reportedpriority'] as num?)?.toInt(),
      loggeduser: json['loggeduser'] as String?,
      targetfinish: json['targetfinish'] as String?,
      ticketid: json['ticketid'] as String?,
    );

Map<String, dynamic> _$SrToJson(Sr instance) => <String, dynamic>{
      'changedate': instance.changedate,
      'statusDescription': instance.statusDescription,
      'reportedpriorityDescription': instance.reportedpriorityDescription,
      'classDescription': instance.classDescription,
      'type': instance.type,
      'ticketuid': instance.ticketuid,
      'reportdate': instance.reportdate,
      'orgid': instance.orgid,
      'description': instance.description,
      'typeDescription': instance.typeDescription,
      'siteid': instance.siteid,
      'href': instance.href,
      'locdesc': instance.locdesc,
      'repcatDescription': instance.repcatDescription,
      'classstructureid': instance.classstructureid,
      'statusdate': instance.statusdate,
      'status': instance.status,
      'changeby': instance.changeby,
      'repcat': instance.repcat,
      'ticketdesc': instance.ticketdesc,
      'fromwho': instance.fromwho,
      'reportedpriority': instance.reportedpriority,
      'loggeduser': instance.loggeduser,
      'targetfinish': instance.targetfinish,
      'ticketid': instance.ticketid,
    };
