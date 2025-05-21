import 'package:inspector_tps/data/models/audit/checklistoperation.dart';
import 'package:inspector_tps/data/models/audit/doc_links.dart';
import 'package:inspector_tps/data/models/audit/rs_defect_comment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_list_wo.g.dart';

@JsonSerializable()
class ChecklistWo {
  @JsonKey(name: 'rs_agr')
  final bool? rsAgr;
  @JsonKey(name: 'checklistoperationid')
  final int? checklistOperationId;
  @JsonKey(name: 'locations_collectionref')
  final String? locationsCollectionRef;
  @JsonKey(name: 'rs_mpactive')
  final bool? rsMpactive;
  @JsonKey(name: 'ipc_ticketscount')
  final String? ipcTicketscount;
  @JsonKey(name: 'orderbynumber')
  final int? orderbyNumber;
  @JsonKey(name: 'parentid')
  final int? parentId;
  @JsonKey(name: 'chliststatus')
  final String? chlistStatus;
  @JsonKey(name: 'wonum')
  final String? woNum;
  @JsonKey(name: 'countlevel')
  final int? countLevel;
  @JsonKey(name: 'haschildren')
  final bool? hasChildren;
  @JsonKey(name: 'checklistwoid')
  final int? checklistWoId;
  final String? description;
  @JsonKey(name: 'siteid')
  final String? siteId;
  @JsonKey(name: 'rs_masterpoint')
  final bool? rsMasterpoint;
  final bool? skanned;
  final String? href;
  @JsonKey(name: 'jpnum')
  final String? jpNum;
  @JsonKey(name: 'rs_defectcomment_collectionref')
  final String? rsDefectcommentCollectionRef;
  final String? localref;
  final String? number;
  final String? goal;
  final String? classid;
  @JsonKey(name: 'rs_qtypoint')
  final bool? rsQtypoint;
  @JsonKey(fromJson: DocLinks.fromJson)
  final DocLinks? doclinks;
  final List<Checklistoperation>? checklistoperation;
  @JsonKey(name: 'rs_defectcomment')
  List<RsDefectComment>? rsDefectcomment;
  final double? numberof;

  @JsonKey(name: 'ipc_hasdiag')
  final bool? ipcHasdiag;

  // local
  final bool? changed;
  bool? visited;

  // presentation
  final List<ChecklistWo> checklist = [];
  final List<String> images = [];

  void addImages(List<String> paths) {
    images.addAll(paths);
  }

  void removeImage(String path) {
    images.remove(path);
  }

  bool get hasFactor => checklistoperation?.first.usingfweight ?? false;

  ChecklistWo({
    this.rsAgr,
    this.checklistOperationId,
    this.locationsCollectionRef,
    this.rsMpactive,
    this.ipcTicketscount,
    this.orderbyNumber,
    this.parentId,
    this.chlistStatus,
    this.woNum,
    this.countLevel,
    this.hasChildren,
    this.checklistWoId,
    this.description,
    this.siteId,
    this.rsMasterpoint,
    this.skanned,
    this.href,
    this.jpNum,
    this.rsDefectcommentCollectionRef,
    this.localref,
    this.number,
    this.goal,
    this.classid,
    this.rsQtypoint,
    this.ipcHasdiag,
    this.changed,
    this.visited,
    this.doclinks,
    this.checklistoperation,
    this.rsDefectcomment,
    this.numberof,
  });

  factory ChecklistWo.fromJson(Map<String, dynamic> json) =>
      _$ChecklistWoFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistWoToJson(this);

  static const statusMap = {
    0: 'Нет (ведутся работы)',
    1: 'Нет',
    2: 'Да',
    4: 'Не применяется',
  };

  static const statusDescriptionMap = {
    'Нет (ведутся работы)': '0',
    'Нет': '1',
    'Да': '2',
    'Не применяется': '4',
  };

  // sqlight

  Map<String, dynamic> toMap() {
    return {
      'rs_agr': rsAgr == null ? null : (rsAgr! ? 1 : 0),
      // Convert bool to int
      'checklistoperationid': checklistOperationId,
      'locations_collectionref': locationsCollectionRef,
      'rs_mpactive': rsMpactive == null ? null : (rsMpactive! ? 1 : 0),
      // Convert bool to int
      'ipc_ticketscount': ipcTicketscount,
      'orderbynumber': orderbyNumber,
      'parentid': parentId,
      'wonum': woNum,
      'countlevel': countLevel,
      'haschildren': hasChildren == null ? null : (hasChildren! ? 1 : 0),
      // Convert bool to int
      'checklistwoid': checklistWoId,
      'description': description,
      // Assuming doclinks is handled separately or not included
      'siteid': siteId,
      'rs_masterpoint': rsMasterpoint == null ? null : (rsMasterpoint! ? 1 : 0),
      // Convert bool to int
      'skanned': skanned == null ? null : (skanned! ? 1 : 0),
      // Convert bool to int
      'href': href,
      'jpnum': jpNum,
      'rs_defectcomment_collectionref': rsDefectcommentCollectionRef,
      'localref': localref,
      'number': number,
      'numberof': numberof,
      'goal': goal,
      'classid': classid,
      'rs_qtypoint': rsQtypoint == null ? null : (rsQtypoint! ? 1 : 0),
      // Convert bool to int
      'chliststatus': chlistStatus,
      'ipc_hasdiag': ipcHasdiag == null ? null : (ipcHasdiag! ? 1 : 0),
      // Convert bool to int
      'changed': changed == null ? null : (changed! ? 1 : 0),
      'visited': visited == null ? null : (visited! ? 1 : 0),
      'doclinks': doclinks?.href,
      'usingfweight': checklistoperation?.first.usingfweight == null
          ? 0
          : (checklistoperation!.first.usingfweight! ? 1 : 0),
    };
  }

  static ChecklistWo fromMap(Map<String, dynamic> map) {
    // print('usingfweight: ${map['usingfweight']}');
    final checklistoperation = map['usingfweight'] == null
        ? null
        : [Checklistoperation(usingfweight: (map['usingfweight'] == 1))];
    // print(checklistoperation?.first.usingfweight);
    return ChecklistWo(
      rsAgr: map['rs_agr'] == null ? null : (map['rs_agr'] == 1),
      checklistOperationId: map['checklistoperationid'],
      locationsCollectionRef: map['locations_collectionref'],
      rsMpactive: map['rs_mpactive'] == null ? null : (map['rs_mpactive'] == 1),
      ipcTicketscount: map['ipc_ticketscount'],
      orderbyNumber: map['orderbynumber'],
      parentId: map['parentid'],
      woNum: map['wonum'],
      countLevel: map['countlevel'],
      hasChildren:
          map['haschildren'] == null ? null : (map['haschildren'] == 1),
      checklistWoId: map['checklistwoid'],
      description: map['description'],
      // Assuming doclinks is handled separately or not included
      siteId: map['siteid'],
      rsMasterpoint:
          map['rs_masterpoint'] == null ? null : (map['rs_masterpoint'] == 1),
      skanned: map['skanned'] == null ? null : (map['skanned'] == 1),
      href: map['href'],
      jpNum: map['jpnum'],
      rsDefectcommentCollectionRef: map['rs_defectcomment_collectionref'],
      localref: map['localref'],
      number: map['number'],
      numberof: map['numberof'],
      goal: map['goal'],
      classid: map['classid'],
      rsQtypoint: map['rs_qtypoint'] == null ? null : (map['rs_qtypoint'] == 1),
      chlistStatus: map['chliststatus'],
      ipcHasdiag: map['ipc_hasdiag'] == null ? null : (map['ipc_hasdiag'] == 1),
      changed: map['changed'] == null ? null : (map['changed'] == 1),
      visited: map['visited'] == null ? null : (map['visited'] == 1),
      doclinks: DocLinks(href: map['doclinks']),
      checklistoperation: checklistoperation,
    );
  }

  static const checkListWoTable = 'CheckListWo';

  static const createTable = '''
  CREATE TABLE $checkListWoTable (
  rs_agr INTEGER, -- SQLite uses INTEGER for Boolean
  checklistoperationid INTEGER,
  locations_collectionref TEXT,
  rs_mpactive INTEGER, -- SQLite uses INTEGER for Boolean
  ipc_ticketscount TEXT,
  orderbynumber INTEGER,
  parentid INTEGER,
  chliststatus_description TEXT,
  wonum TEXT,
  countlevel INTEGER,
  rowstamp TEXT,
  haschildren INTEGER, -- SQLite uses INTEGER for Boolean
  checklistwoid INTEGER PRIMARY KEY, -- checklistWoId is the primary key
  description TEXT,
  -- doclinks TEXT, -- Assuming you are storing JSON as text or just the href from DocLinks
  siteid TEXT,
  rs_masterpoint INTEGER, -- SQLite uses INTEGER for Boolean
  skanned INTEGER, -- SQLite uses INTEGER for Boolean
  href TEXT,
  doclinks TEXT,
  jpnum TEXT,
  rs_defectcomment_collectionref TEXT,
  localref TEXT,
  number TEXT,
  numberof REAL,
  goal TEXT,
  classid TEXT,
  rs_qtypoint INTEGER,
  chliststatus TEXT,
  ipc_hasdiag INTEGER,
  changed INTEGER,
  visited INTEGER,
  usingfweight INTEGER 
  );
  ''';

  static const chlwoImagesTable = 'chlwoImagesTable';

  static const createChlwoImagesTable = '''
  CREATE TABLE $chlwoImagesTable (
  wonum TEXT,
  checklistwoid INTEGER,
  path TEXT PRIMARY KEY,
  sent INTEGER 
  );
  ''';

}
