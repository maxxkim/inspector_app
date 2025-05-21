import 'package:json_annotation/json_annotation.dart';

part 'woactivity.g.dart';

@JsonSerializable()
class Woactivity {
  String? wonum;
  final String? description;
  final String? pprcomment;
  final String? pprresult;
  final String? localref;

  final int? wosequence;
  final double? estdur;
  final int? taskid;

  factory Woactivity.fromJson(Map<String, dynamic> json) =>
      _$WoactivityFromJson(json);

  Woactivity({
    this.wonum,
    this.description,
    this.pprcomment,
    this.pprresult,
    this.wosequence,
    this.estdur,
    this.taskid,
    this.localref,
  });

  Map<String, dynamic> toJson() => _$WoactivityToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'wonum': wonum,
      'description': description,
      'pprcomment': pprcomment,
      'pprresult': pprresult,
      'wosequence': wosequence,
      'estdur': estdur,
      'localref': localref,
      'taskid': taskid,
    };
  }

  static Woactivity fromMap(Map<String, dynamic> map) {
    return Woactivity(
      wonum: map['wonum'],
      description: map['description'],
      pprcomment: map['pprcomment'],
      pprresult: map['pprresult'],
      wosequence: map['wosequence'],
      estdur: map['estdur'],
      localref: map['localref'],
      taskid: map['taskid'],
    );
  }

  static const woactivityTable = 'WoactivityTable';

  static const createWoactivityTable = '''
  CREATE TABLE $woactivityTable (
  wonum TEXT,
  description TEXT,
  pprcomment TEXT,
  pprresult TEXT,
  wosequence INTEGER,
  estdur REAL,
  taskid INTEGER,
  localref TEXT 
  );
  ''';
}
