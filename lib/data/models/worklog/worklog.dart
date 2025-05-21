import 'package:json_annotation/json_annotation.dart';

part 'worklog.g.dart';

@JsonSerializable()
class Worklog {
  String? wonum;
  final int? worklogid;
  final String? createby;
  @JsonKey(name: 'createdby_displayname')
  final String? fromName;
  final String? createdate;
  final String? localref;
  final String? description;
  final String? recordkey;

  final bool fresh;

  factory Worklog.fromJson(Map<String, dynamic> json) =>
      _$WorklogFromJson(json);

  Worklog({
    this.wonum,
    this.worklogid,
    this.createby,
    this.fromName,
    this.createdate,
    this.localref,
    this.description,
    this.recordkey,
    this.fresh = false,
  });

  Map<String, dynamic> toJson() => _$WorklogToJson(this);

  Map<String, dynamic> toMap() => {
        'wonum': wonum,
        'worklogid': worklogid,
        'description': description,
        'createby': createby,
        'fromName': fromName,
        'createdate': createdate,
        'recordkey': recordkey,
        'fresh': fresh ? 1 : 0,
      };

  static Worklog fromMap(Map<String, dynamic> map) {
    return Worklog(
      wonum: map['wonum'],
      worklogid: map['worklogid'],
      description: map['description'],
      createby: map['createby'],
      fromName: map['fromName'],
      createdate: map['createdate'],
      recordkey: map['recordkey'],
      fresh: map['fresh'] == 1,
    );
  }

  static const worklogTable = 'WorklogTable';

  static const createWorklogTable = '''
  CREATE TABLE $worklogTable (
  wonum TEXT,
  worklogid INTEGER,
  description TEXT,
  createby TEXT,
  fromName TEXT,
  createdate TEXT,
  recordkey TEXT,
  fresh INTEGER
  );
  ''';
}
