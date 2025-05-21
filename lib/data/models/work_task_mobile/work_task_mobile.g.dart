// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_task_mobile.dart';

// manual updating since nov 24

WorkTaskMobile _$WorkTaskMobileFromJson(Map<String, dynamic> json) =>
    WorkTaskMobile(
      wonum: json['wonum'] as String?,
      owner: json['owner'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      statusDescription: json['status_description'] as String?,
      targstartdate: json['targstartdate'] as String?,
      targcompdate: json['targcompdate'] as String?,
      siteid: json['siteid'] as String?,
      href: json['href'] as String?,
      worktype: json['worktype'] as String?,
      assetnum: json['assetnum'] as String?,
      offlineScript: json['offlineScript'] as String?,
      started: json['started'] as bool?,
      finished: json['finished'] as bool?,
      timeStampStarted: (json['timeStampStarted'] as num?)?.toDouble(),
      timeStampFinished: (json['timeStampFinished'] as num?)?.toDouble(),
      weekDescription: json['rs_week_description'] as String?,
      monthDescription: json['rs_month_description'] as String?,
      quarterDescription: json['rs_quarter_description'] as String?,
      yearDescription: json['rs_year_description'] as String?,
      asset: json['asset'] == null
          ? null
          : Asset.fromJson(json['asset'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      woactivity: (json['woactivity'] as List<dynamic>?)
          ?.map((e) => Woactivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      worklog: (json['worklog'] as List<dynamic>?)
          ?.map((e) => Worklog.fromJson(e as Map<String, dynamic>))
          .toList(),
      doclinks: DocLinks.fromJson(json['doclinks'] as Map<String, dynamic>),
      pprTakenInMaximo: json['pprTakenInMaximo'] as bool? ?? false,
      displayName: _getDisplayName(json['person']),
      reportDate: _getReportDateSr(json['sr']),
      priority: _getPrioritySr(json['sr']),
      fromwho: _getFromWhoSr(json['sr']),
      ticketdesc: _getTicketdescSr(json['sr']),
    );

String? _getDisplayName(List<dynamic>? lst) {
  final mp = lst?.first as Map<String, dynamic>?;
  if (mp == null) return null;
  try {
    final name = mp['displayname'];
    return name;
  } catch (ex) {
    print('can not get displayname');
    return null;
  }
}

String? _getReportDateSr(List<dynamic>? lst) {
  final mp = lst?.first as Map<String, dynamic>?;
  if (mp == null) return null;
  try {
    final date = mp['reportdate'];
    return date;
  } catch (ex) {
    print('can not get reportdate');
    return null;
  }
}

String? _getPrioritySr(List<dynamic>? lst) {
  final mp = lst?.first as Map<String, dynamic>?;
  if (mp == null) return null;
  try {
    final priority = mp['reportedpriority_description'];
    return priority;
  } catch (ex) {
    print('can not get priority');
    return null;
  }
}

String? _getFromWhoSr(List<dynamic>? lst) {
  final mp = lst?.first as Map<String, dynamic>?;
  if (mp == null) return null;
  try {
    final fromWho = mp['fromwho'];
    return fromWho;
  } catch (ex) {
    print('can not get fromwho');
    return null;
  }
}

String? _getTicketdescSr(List<dynamic>? lst) {
  final mp = lst?.first as Map<String, dynamic>?;
  if (mp == null) return null;
  try {
    final ticketDesc = mp['ticketdesc'];
    return ticketDesc;
  } catch (ex) {
    print('can not get ticketdesc');
    return null;
  }
}

Map<String, dynamic> _$WorkTaskMobileToJson(WorkTaskMobile instance) =>
    <String, dynamic>{
      'wonum': instance.wonum,
      'description': instance.description,
      'status': instance.status,
      'status_description': instance.statusDescription,
      'targstartdate': instance.targstartdate,
      'targcompdate': instance.targcompdate,
      'siteid': instance.siteid,
      'href': instance.href,
      'worktype': instance.worktype,
      'assetnum': instance.assetnum,
      'offlineScript': instance.offlineScript,
      'owner': instance.owner,
      'rs_week_description': instance.weekDescription,
      'rs_month_description': instance.monthDescription,
      'rs_quarter_description': instance.quarterDescription,
      'rs_year_description': instance.yearDescription,
      'asset': instance.asset,
      'location': instance.location,
      'doclinks': instance.doclinks,
      'woactivity': instance.woactivity,
      'worklog': instance.worklog,
      'started': instance.started,
      'finished': instance.finished,
      'displayName': instance.displayName,
      'priority': instance.priority,
      'timeStampStarted': instance.timeStampStarted,
      'timeStampFinished': instance.timeStampFinished,
      'pprTakenInMaximo': instance.pprTakenInMaximo,
    };
