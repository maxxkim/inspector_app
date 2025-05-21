import 'package:inspector_tps/data/models/audit/doc_links.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/ppr/location.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_task_mobile.g.dart';

class WorkTaskMobile {
  final String? wonum;
  final String? description;
  final String? status;
  @JsonKey(name: 'status_description')
  final String? statusDescription;
  final String? targstartdate;
  final String? targcompdate;
  final String? siteid;
  final String? href;
  final String? worktype;
  final String? owner;
  @JsonKey(name: 'rs_week_description')
  final String? weekDescription;
  @JsonKey(name: 'rs_month_description')
  final String? monthDescription;
  @JsonKey(name: 'rs_quarter_description')
  final String? quarterDescription;
  @JsonKey(name: 'rs_year_description')
  final String? yearDescription;
  Asset? asset;
  final Location? location;
  @JsonKey(fromJson: DocLinks.fromJson)
  final DocLinks? doclinks;
  final String? assetnum;

  List<Woactivity>? woactivity;
  List<Worklog>? worklog;

  // Mobile specific fields
  final bool? started;
  final bool? finished;
  final String? displayName;
  final String? reportDate;
  final String? offlineScript;

  // from sr
  final String? priority;
  final String? fromwho;
  final String? ticketdesc;

  final double? timeStampStarted;
  final double? timeStampFinished;
  bool pprTakenInMaximo;

  // presentation
  final List<String> images = [];

  void addImages(List<String> paths) {
    images.addAll(paths);
  }

  void removeImage(String path) {
    images.remove(path);
  }

  WorkTaskMobile({
    this.wonum,
    this.owner,
    this.description,
    this.status,
    this.statusDescription,
    this.targstartdate,
    this.targcompdate,
    this.siteid,
    this.href,
    this.worktype,
    this.started,
    this.finished,
    this.timeStampStarted,
    this.timeStampFinished,
    this.weekDescription,
    this.monthDescription,
    this.quarterDescription,
    this.yearDescription,
    this.asset,
    this.location,
    this.woactivity,
    this.worklog,
    this.doclinks,
    this.pprTakenInMaximo = false,
    this.priority,
    this.displayName,
    this.reportDate,
    this.fromwho,
    this.ticketdesc,
    this.assetnum,
    this.offlineScript,
  });

  bool get isKvosm => worktype == 'КВОСМ';

  factory WorkTaskMobile.fromJson(Map<String, dynamic> json) =>
      _$WorkTaskMobileFromJson(json);

  Map<String, dynamic> toJson() => _$WorkTaskMobileToJson(this);

  @override
  String toString() {
    return '$wonum $siteid  $worktype $description \n'
        'status: $status $statusDescription'
        'displayname: $displayName assetnum: $assetnum '
        'owner: $owner fromWho: $fromwho priority: $priority\n'
        'start: $targstartdate reportDate: $reportDate'
        'comp: $targcompdate, takenInMaximo: $pprTakenInMaximo\n'
        'jobs: ${woactivity?.length} worklog: ${worklog?.length}\n'
        'offlineScript: $offlineScript, doclinks: ${doclinks?.href}\n'
        'href: $href';
  }

  // sqlight

  Map<String, dynamic> toMap() {
    return {
      'wonum': wonum,
      'owner': owner,
      'fromwho': fromwho,
      'displayName': displayName,
      'description': description,
      'status_description': statusDescription,
      'status': status,
      'priority': priority,
      'targstartdate': targstartdate,
      'targcompdate': targcompdate,
      'reportDate': reportDate,
      'rs_week_description': weekDescription,
      'rs_month_description': monthDescription,
      'rs_quarter_description': quarterDescription,
      'rs_year_description': yearDescription,
      'siteid': siteid,
      'ticketdesc': ticketdesc,
      'href': href,
      'worktype': worktype,
      'started': started == null ? null : (started! ? 1 : 0),
      'finished': finished == null ? null : (finished! ? 1 : 0),
      'timeStampStarted': timeStampStarted,
      'timeStampFinished': timeStampFinished,
      assetDescription: asset?.description,
      locationDescription: location?.description,
      locationOldDescription: location?.olddescription,
      'doclinks': doclinks?.href,
      'pprTakenInMaximo': pprTakenInMaximo ? 1 : 0,
      'assetnum': assetnum,
      'offlineScript': offlineScript,
    };
  }

  static WorkTaskMobile fromMap(Map<String, dynamic> map) {
    return WorkTaskMobile(
      wonum: map['wonum'],
      owner: map['owner'],
      fromwho: map['fromwho'],
      displayName: map['displayName'],
      priority: map['priority'],
      description: map['description'],
      statusDescription: map['status_description'],
      status: map['status'],
      targstartdate: map['targstartdate'],
      targcompdate: map['targcompdate'],
      reportDate: map['reportDate'],
      weekDescription: map['rs_week_description'],
      monthDescription: map['rs_month_description'],
      quarterDescription: map['rs_quarter_description'],
      yearDescription: map['rs_year_description'],
      siteid: map['siteid'],
      ticketdesc: map['ticketdesc'],
      href: map['href'],
      worktype: map['worktype'],
      started: map['started'] == null ? null : (map['started'] == 1),
      finished: map['finished'] == null ? null : (map['finished'] == 1),
      pprTakenInMaximo: map['pprTakenInMaximo'] == 1,
      timeStampStarted: map['timeStampStarted'],
      timeStampFinished: map['timeStampFinished'],
      assetnum: map['assetnum'],
      offlineScript: map['offlineScript'],
      doclinks:
          map['doclinks'] != null ? DocLinks(href: map['doclinks']) : null,
      asset: map[assetDescription] == null
          ? null
          : Asset(description: map[assetDescription]),
      location: map[locationDescription] == null
          ? null
          : Location(
              description: map[locationDescription],
              olddescription: map[locationOldDescription]),
    );
  }

  static const auditsTable = 'WorkTaskMobile';

  static const createAuditsTable = '''
  CREATE TABLE $auditsTable (
  wonum TEXT PRIMARY KEY ,
  owner TEXT,
  fromwho TEXT,
  displayName TEXT,
  priority TEXT,
  description TEXT,
  status_description TEXT,
  status TEXT,
  targstartdate TEXT,
  targcompdate TEXT,
  reportDate TEXT,
  rs_week_description TEXT,
  rs_month_description TEXT,
  rs_quarter_description TEXT,
  rs_year_description TEXT,
  siteid TEXT,
  ticketdesc TEXT,
  href TEXT,
  doclinks TEXT,
  worktype TEXT,
  assetnum TEXT,
  offlineScript TEXT,
  $assetDescription TEXT,
  $locationDescription TEXT,
  $locationOldDescription TEXT,
  started INTEGER,
  finished INTEGER,
  pprTakenInMaximo INTEGER,
  timeStampStarted REAL,
  timeStampFinished REAL
  )''';

  static const pprTable = 'pprTable';

  static const createPprTable = '''
  CREATE TABLE $pprTable (
  wonum TEXT PRIMARY KEY ,
  owner TEXT,
  fromwho TEXT,
  displayName TEXT,
  priority TEXT,
  description TEXT,
  status TEXT,
  status_description TEXT,
  targstartdate TEXT,
  targcompdate TEXT,
  reportDate TEXT,
  rs_week_description TEXT,
  rs_month_description TEXT,
  rs_quarter_description TEXT,
  rs_year_description TEXT,
  siteid TEXT,
  ticketdesc TEXT,
  href TEXT,
  doclinks TEXT,
  worktype TEXT,
  assetnum TEXT,
  offlineScript TEXT,
  $assetDescription TEXT,
  $locationDescription TEXT,
  $locationOldDescription TEXT,
  started INTEGER,
  finished INTEGER,
  pprTakenInMaximo INTEGER,
  timeStampStarted REAL,
  timeStampFinished REAL
  )''';

  static const imagesTable = 'imagesTable';

  static const createImagesTable = '''
  CREATE TABLE $imagesTable (
  wonum TEXT,
  path TEXT PRIMARY KEY,
  sent INTEGER 
  );
  ''';

  //rz

  static const rzTable = 'rzTable';

  static const createRzTable = '''
  CREATE TABLE $rzTable (
  wonum TEXT PRIMARY KEY ,
  owner TEXT,
  fromwho TEXT,
  displayName TEXT,
  priority TEXT,
  description TEXT,
  status TEXT,
  status_description TEXT,
  targstartdate TEXT,
  targcompdate TEXT,
  reportDate TEXT,
  rs_week_description TEXT,
  rs_month_description TEXT,
  rs_quarter_description TEXT,
  rs_year_description TEXT,
  siteid TEXT,
  ticketdesc TEXT,
  href TEXT,
  doclinks TEXT,
  worktype TEXT,
  assetnum TEXT,
  offlineScript TEXT,
  $assetDescription TEXT,
  $locationDescription TEXT,
  $locationOldDescription TEXT,
  started INTEGER,
  finished INTEGER,
  pprTakenInMaximo INTEGER,
  timeStampStarted REAL,
  timeStampFinished REAL
  )''';
}

const assetDescription = 'asset_description';
const locationDescription = 'location_description';
const locationOldDescription = 'location_olddescription';
