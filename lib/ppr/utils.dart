import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:package_info_plus/package_info_plus.dart';

bool isPprReady(WorkTaskMobile ppr) {
  final ready = ppr.woactivity
          ?.map((job) =>
              (job.pprresult == bad &&
                  (job.pprcomment != null && job.pprcomment!.isNotEmpty)) ||
              job.pprresult == good)
          .every((e) => e) ??
      false;
  return ppr.status == statusAssigned && ready;
}

Future<List<WorkTaskMobile>> getReadyPprs() async {
  final all = await readAllPpr();
  return all.where((ppr) => isPprReady(ppr)).toList();
}

Future<String> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // String appName = packageInfo.appName;
  // String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  return '${Txt.version} $buildNumber';
}
