import 'package:json_annotation/json_annotation.dart';

part 'rs_defect_comment.g.dart';

@JsonSerializable()
class RsDefectComment {
  @JsonKey(name: 'checklistoperationid')
  final int? checklistOperationId;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'orgid')
  final String? orgId;

  @JsonKey(name: 'notcreatesr')
  final bool? notCreateSr;

  @JsonKey(name: 'wonum')
  String? woNum;

  @JsonKey(name: 'checklistwoid')
  final int? checklistWoId;

  @JsonKey(name: 'siteid')
  final String? siteId;

  @JsonKey(name: 'rs_defectcommentid')
  final int? rsDefectCommentId;

  @JsonKey(name: 'href')
  final String? href;

  RsDefectComment({
    this.checklistOperationId,
    this.comment,
    this.orgId,
    this.notCreateSr,
    this.woNum,
    this.checklistWoId,
    this.siteId,
    this.rsDefectCommentId,
    this.href,
  });

  factory RsDefectComment.fromJson(Map<String, dynamic> json) =>
      _$RsDefectCommentFromJson(json);

  Map<String, dynamic> toJson() => _$RsDefectCommentToJson(this);

  // SQLite-related methods
  static RsDefectComment fromMap(Map<String, dynamic> map) {
    return RsDefectComment(
      checklistOperationId: map['checklistoperationid'] as int?,
      comment: map['comment'] as String?,
      orgId: map['orgid'] as String?,
      notCreateSr: map['notcreatesr'] == 1,
      // Assuming SQLite stores booleans as integers 0 (false) or 1 (true)
      woNum: map['wonum'] as String?,
      checklistWoId: map['checklistwoid'] as int?,
      siteId: map['siteid'] as String?,
      rsDefectCommentId: map['rs_defectcommentid'] as int?,
      href: map['href'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'checklistoperationid': checklistOperationId,
      'comment': comment,
      'orgid': orgId,
      'notcreatesr': notCreateSr == true ? 1 : 0,
      // Convert boolean to integer for SQLite
      'wonum': woNum,
      'checklistwoid': checklistWoId,
      'siteid': siteId,
      'rs_defectcommentid': rsDefectCommentId,
      'href': href,
    };
  }

  static const commentsTable = 'commentsTable';

  static const createTable = '''
    CREATE TABLE $commentsTable (
    checklistoperationid INTEGER,
    comment TEXT,
    orgid TEXT,
    notcreatesr INTEGER,
    wonum TEXT,
    checklistwoid INTEGER,
    siteid TEXT,
    rs_defectcommentid INTEGER,
    href TEXT
    );
  ''';
}
