import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';

class Endpoints {
  // base
  static const protocol = 'https://';
  static const devHost = 'maximodev.itps.ru:7889';
  static const prodHost = 'maximo.itps.ru:7890';
  static const oslc = '/oslc';
  static const oslcOs = '$oslc/os';
  static const script = '$oslc/script';

  static const checklistWo = '/checklistwo';
  static const doclinks = '/doclinks';

  // auth
  static const login = '$oslc/login';
  static const whoAmI = '$oslc/whoami';
  static const userGroups = '$oslc/os/oslcmaxuser?savedQuery=currentUser';

  // audits
  static downloadAudits({String? siteId, required String workType}) =>
      '$oslc/os/work_task_mobile?'
      'oslc.select=description,worktype,wonum,targstartdate,targcompdate,'
      'doclinks,'
      'asset.description,'
      'location.description,'
      'location.olddescription,'
      'rs_week,rs_month,rs_quarter,rs_year'
      '&oslc.where=worktype in $workType '
      'and status in ["СФОРМИРОВАНО"]'
      '${siteId != null ? ' and siteid="$siteId"' : ''}';

  // 'and siteid="МОРЕМОЛЛ"';

  // queries
  static Map<String, dynamic> lean = {'lean': 1};
  static String selectChecklistwo = '?oslc.select=checklistwo';

  static const createRsDefectComment = '$oslcOs/rs_defectcomment';
  // PPR
  static const String _selectForPpr =
      'oslc.select=description,wonum,targstartdate,targcompdate,'
      'worktype,status,worklog,siteid,'
      'asset.description,'
      'location.description,'
      'location.olddescription,'
      'doclinks,'
      'woactivity';

  static downloadPprByWonum(String wonum) => '$oslcOs/work_task_mobile?'
      'oslc.where=wonum=$wonum&$_selectForPpr';

  static downloadPpr(
          {required String? siteId,
          required String date,
          required pprStatuses}) =>
      '$oslc/os/work_task_mobile?$_selectForPpr'
      '&oslc.where=worktype in ["ТО2","ТО3","ТО4","ТО4Г"] '
      'and status in $pprStatuses '
      'and woclass="WORKORDER" '
      'and targstartdate>"$date" '
      'and targstartdate<"${theTwoDayAfterTomorrowIso()}"'
      '${siteId != null ? ' and siteid="$siteId"' : ''}';

  // Rz

  static const String _selectForRz =
      'oslc.select=description,wonum,targstartdate,targcompdate,asset'
      'worktype,status,siteid,sr,'
      'worklog,'
      'owner,'
      'person,'
      'doclinks';

  static downloadRzList({
    required String? siteId,
  }) =>
      '$oslc/os/work_task_mobile?$_selectForRz'
      '&oslc.where=worktype in ["ДИАГ"] '
      'and status in ["$statusAssigned"] '
      'and woclass="WORKORDER"'
      '${siteId != null ? 'and siteid="$siteId"' : ''}';

  static downloadAssetsCatalog({
    required String? siteId,
  }) =>
      '$oslc/os/IPC_MOB_ASSET?'
      'oslc.select=description,assetnum,locations,classstructure&'
      'oslc.where=siteid="$siteId" and status="OPERATING"';

  static const downloadSites = '$oslc/os/ALNDOMAIN'
      '?oslc.where=domainid="SITEWITHCO"&oslc.select=description,value';

  // Sr
  static const createSr = '$oslcOs/mxsr';
}

// /maximo/oslc/os/work_task_mobile?lean=1&
// oslc.select=description,wonum,targstartdate,targcompdate,worktype,status,worklog,asset.description,location.description,location.olddescription,woactivity
// &oslc.where=worktype in ["ДИАГ"] and status in ["НАЗНАЧЕНО"] and siteid="СБ"

String get getHost =>
    Endpoints.protocol + (isDev() ? devHost : Endpoints.prodHost);

String get devHost => readHost() ?? Endpoints.devHost;

String get getBaseUrl => '$getHost/maxmob';

String get baseUrlOslcOs => '$getBaseUrl${Endpoints.oslc}/os';

class Header {
  static Map<String, String> contentJson = {'Content-Type': 'application/json'};
}
