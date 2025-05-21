import 'package:json_annotation/json_annotation.dart';

part 'sr.g.dart';

@JsonSerializable()
class Sr {
  final String? changedate;  // use as generated wonum for images table
  final String? statusDescription;
  final String? reportedpriorityDescription;
  final String? classDescription;
  final String? type;
  final int? ticketuid;
  final String? reportdate;
  final String? orgid;
  final String? description;
  final String? typeDescription;
  final String? siteid;
  final String? href;
  final String? locdesc;
  final String? repcatDescription;
  final String? classstructureid;
  final String? statusdate;
  final String? status;
  final String? changeby;
  final String? repcat;
  final String? ticketdesc;
  final String? fromwho;
  final int? reportedpriority;
  final String? loggeduser;
  final String? targetfinish;
  final String? ticketid;

  // presentation
  final List<String> images = [];

  Sr({
    this.changedate,
    this.statusDescription,
    this.reportedpriorityDescription,
    this.classDescription,
    this.type,
    this.ticketuid,
    this.reportdate,
    this.orgid,
    this.description,
    this.typeDescription,
    this.siteid,
    this.href,
    this.locdesc,
    this.repcatDescription,
    this.classstructureid,
    this.statusdate,
    this.status,
    this.changeby,
    this.repcat,
    this.ticketdesc,
    this.fromwho,
    this.reportedpriority,
    this.loggeduser,
    this.targetfinish,
    this.ticketid,
  });

  factory Sr.fromJson(Map<String, dynamic> json) => _$SrFromJson(json);

  Map<String, dynamic> toJson() => _$SrToJson(this);

  bool get isLocal => ticketid == null;

  bool get sent => ticketid != null;

  void addImages(List<String> paths) {
    images.addAll(paths);
  }

  void removeImage(String path) {
    images.remove(path);
  }

  @override
  String toString() {
    return 'Sr{ticketid: "$ticketid" "$description" "$locdesc"'
        'href: $href}';
  }

  Map<String, dynamic> toMap() {
    return {
      'changedate': changedate,
      'statusDescription': statusDescription,
      'reportedpriorityDescription': reportedpriorityDescription,
      'classDescription': classDescription,
      'type': type,
      'ticketuid': ticketuid,
      'reportdate': reportdate,
      'orgid': orgid,
      'description': description,
      'typeDescription': typeDescription,
      'siteid': siteid,
      'href': href,
      'locdesc': locdesc,
      'repcatDescription': repcatDescription,
      'classstructureid': classstructureid,
      'statusdate': statusdate,
      'status': status,
      'changeby': changeby,
      'repcat': repcat,
      'ticketdesc': ticketdesc,
      'fromwho': fromwho,
      'reportedpriority': reportedpriority,
      'loggeduser': loggeduser,
      'targetfinish': targetfinish,
      'ticketid': ticketid,
    };
  }

  static Sr fromMap(Map<String, dynamic> map) {
    return Sr(
      changedate: map['changedate'] as String?,
      statusDescription: map['statusDescription'] as String?,
      reportedpriorityDescription:
          map['reportedpriorityDescription'] as String?,
      classDescription: map['classDescription'] as String?,
      type: map['type'] as String?,
      ticketuid: map['ticketuid'] as int?,
      reportdate: map['reportdate'] as String?,
      orgid: map['orgid'] as String?,
      description: map['description'] as String?,
      typeDescription: map['typeDescription'] as String?,
      siteid: map['siteid'] as String?,
      href: map['href'] as String?,
      locdesc: map['locdesc'] as String?,
      repcatDescription: map['repcatDescription'] as String?,
      classstructureid: map['classstructureid'] as String?,
      statusdate: map['statusdate'] as String?,
      status: map['status'] as String?,
      changeby: map['changeby'] as String?,
      repcat: map['repcat'] as String?,
      ticketdesc: map['ticketdesc'] as String?,
      fromwho: map['fromwho'] as String?,
      reportedpriority: map['reportedpriority'] as int?,
      loggeduser: map['loggeduser'] as String?,
      targetfinish: map['targetfinish'] as String?,
      ticketid: map['ticketid'] as String?,
    );
  }

  static const srTable = 'srTable';

  static const createSrTable = '''
  CREATE TABLE $srTable (
    ticketid TEXT,
    changedate TEXT,
    statusDescription TEXT,
    reportedpriorityDescription TEXT,
    classDescription TEXT,
    type TEXT,
    ticketuid INTEGER,
    reportdate TEXT,
    orgid TEXT,
    description TEXT,
    typeDescription TEXT,
    siteid TEXT,
    href TEXT,
    locdesc TEXT,
    repcatDescription TEXT,
    classstructureid TEXT,
    statusdate TEXT,
    status TEXT,
    changeby TEXT,
    repcat TEXT,
    ticketdesc TEXT,
    fromwho TEXT,
    reportedpriority INTEGER,
    loggeduser TEXT,
    targetfinish TEXT
);
  ''';
}
