import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/audit/rs_defect_comment.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openAuditDatabase() async {
  final db = openDatabase(
    join(await getDatabasesPath(), 'audit_db.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(WorkTaskMobile.createAuditsTable);
      await db.execute(ChecklistWo.createTable);
      await db.execute(ChecklistWo.createChlwoImagesTable);
      await db.execute(RsDefectComment.createTable);
      // ppr
      await db.execute(WorkTaskMobile.createPprTable);
      await db.execute(Woactivity.createWoactivityTable);
      await db.execute(Worklog.createWorklogTable);
      await db.execute(WorkTaskMobile.createImagesTable);
      // rz
      await db.execute(WorkTaskMobile.createRzTable);
      await db.execute(Asset.createAssetsTable);
      // sr
      await db.execute(Sr.createSrTable);
    },
  );
  return db;
}

Future<void> resetAllDbData() async {
  await db.execute('DELETE FROM ${ChecklistWo.checkListWoTable}');
  await db.execute('DELETE FROM ${WorkTaskMobile.auditsTable}');
  await db.execute('DELETE FROM ${ChecklistWo.chlwoImagesTable}');
  await db.execute('DELETE FROM ${RsDefectComment.commentsTable}');
  // ppr
  await db.execute('DELETE FROM ${WorkTaskMobile.pprTable}');
  await db.execute('DELETE FROM ${Woactivity.woactivityTable}');
  await db.execute('DELETE FROM ${Worklog.worklogTable}');
  await db.execute('DELETE FROM ${WorkTaskMobile.imagesTable}');
  // rz
  await db.execute('DELETE FROM ${WorkTaskMobile.rzTable}');
  await db.execute('DELETE FROM ${Asset.assetsTable}');
  // sr
  await db.execute('DELETE FROM ${Sr.srTable}');
}

// audits

Future<void> insertAudits(List<WorkTaskMobile> audits) async {
  final batch = db.batch();
  for (var a in audits) {
    batch.insert(
      WorkTaskMobile.auditsTable,
      a.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<List<WorkTaskMobile>> readAllAudits() async {
  final List<Map<String, dynamic>> auditsMap =
      await db.query(WorkTaskMobile.auditsTable);
  return auditsMap.map((e) => WorkTaskMobile.fromMap(e)).toList();
}

Future<void> insertAuditCheckList(
    List<ChecklistWo> checkLists, String wonum) async {
  final batch = db.batch();
  for (var wo in checkLists) {
    if (wo.rsDefectcomment?.isNotEmpty ?? false) {
      final comments = wo.rsDefectcomment!;
      for (var c in comments) {
        c.woNum = wonum;
      }
      await insertRsDefectComments(comments);
    }
    if ((wo.number?.toLowerCase().startsWith('k') ?? false) &&
        wo.classid != null) continue;
    batch.insert(
      ChecklistWo.checkListWoTable,
      wo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<void> insertRsDefectComments(List<RsDefectComment> comments) async {
  final batch = db.batch();
  for (var rsComment in comments) {
    batch.insert(
      RsDefectComment.commentsTable,
      rsComment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<void> deleteRsDefectCommentDb(RsDefectComment comment) async {
  String query = 'DELETE FROM ${RsDefectComment.commentsTable} '
      'WHERE wonum = "${comment.woNum}" '
      'AND checklistwoid = "${comment.checklistWoId}" '
      'AND comment = "${comment.comment}"';
  await db.rawQuery(query);
}

// Future<void> insertRsDefectComment(RsDefectComment comment) async {
//   final batch = db.batch();
//   batch.insert(
//     RsDefectComment.commentsTable,
//     comment.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await batch.commit();
// }

Future<List<RsDefectComment>> readRsWorklogByChecklistoperationid(
    int checklistoperationid) async {
  final result =
      await db.rawQuery('SELECT * FROM ${RsDefectComment.commentsTable} '
          'WHERE checklistoperationid = "$checklistoperationid"');

  final comments = result.map((e) => RsDefectComment.fromMap(e)).toList();
  return comments;
}

Future<List<RsDefectComment>> readWoCommentsForUploading(
    int checklistoperationid) async {
  final comments =
      await readRsWorklogByChecklistoperationid(checklistoperationid);
  return comments
      .where((comment) => comment.rsDefectCommentId == null)
      .toList();
}

Future<List<ChecklistWo>> readAuditChecklists(String? wonum) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${ChecklistWo.checkListWoTable} WHERE wonum = ? AND number IS NULL',
      [wonum]);

  final checklists = result.map((e) => ChecklistWo.fromMap(e)).toList();
  checklists.sort((a, b) => (a.number ?? (a.description ?? ''))
      .compareTo(b.number ?? (b.description ?? '')));

  for (var chl in checklists) {
    await addChildren(chl);
  }

  return checklists;
}

Future<void> addChildren(ChecklistWo parent) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${ChecklistWo.checkListWoTable} WHERE wonum = ? AND parentId = ?',
      [parent.woNum, parent.checklistOperationId]);

  final checklists = result.map((e) => ChecklistWo.fromMap(e)).toList();

  checklists.sort((a, b) => (a.number ?? '').compareTo(b.number ?? ''));

  for (var chl in checklists) {
    addChildren(chl);
  }
  parent.checklist.addAll(checklists);
}

Future<List<ChecklistWo>> readLastLevel(
    String wonum, int parentId) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${ChecklistWo.checkListWoTable} WHERE wonum = ? AND parentId = ?',
      [wonum, parentId]);

  final checklists = result.map((e) => ChecklistWo.fromMap(e)).toList();
  checklists.sort((a, b) => (a.number ?? '').compareTo(b.number ?? ''));
  for (var chl in checklists) {
    await _addChecklistWoComments(chl);
  }
  return checklists;
}

Future<List<ChecklistWo>> readChecklistsForUploading(String wonum) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${ChecklistWo.checkListWoTable} WHERE wonum = "$wonum"'
      ' AND haschildren = 0 AND changed = 1');

  final leafs = result.map((e) => ChecklistWo.fromMap(e)).toList();

  for (var chl in leafs) {
    await _addChecklistWoComments(chl);
  }
  return leafs;
}

Future<ChecklistWo> readWo(int id) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${ChecklistWo.checkListWoTable} WHERE checklistwoid = ?',
      [id]);

  final checklist = ChecklistWo.fromMap(result.first);

  await _addChecklistWoComments(checklist);

  final List<String> images =
      await readWoImagesPaths(checklistwoid: id, forSending: false);
  if (images.isNotEmpty) {
    checklist.addImages(images);
  }
  return checklist;
}

Future<void> _addChecklistWoComments(ChecklistWo checklist) async {
  if (!(checklist.hasChildren ?? false)) {
    final id = checklist.checklistOperationId ?? -1;
    final comments = await readRsWorklogByChecklistoperationid(id);
    if (comments.isNotEmpty) {
      for (var e in comments) {
        debugPrint('comment: ${checklist.number} ${e.comment}');
      }
      checklist.rsDefectcomment = comments;
    }
  }
}

// Future<void> updateComment(int checklistwoid, String comment) async {
//   await db.rawQuery(
//     'UPDATE ${ChecklistWo.checkListWoTable} '
//     'SET goal = "$comment", changed = "1" '
//     'WHERE checklistwoid = "$checklistwoid"',
//   );
// }

Future<void> updateStatus(int checklistwoid, String status) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET chliststatus = "$status", changed = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> updateChanged(int checklistwoid) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET changed = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> updateFactor(int checklistwoid, double factor) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET numberof  = "$factor", changed = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> updateChecked(int checklistwoid, int isChecked) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET rs_masterpoint = "$isChecked", changed = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> setChanged(int checklistwoid) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET changed = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> resetChanged(int checklistwoid) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET changed = "0" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> setVisited(int checklistwoid) async {
  await db.rawQuery(
    'UPDATE ${ChecklistWo.checkListWoTable} '
    'SET visited = "1" '
    'WHERE checklistwoid = "$checklistwoid"',
  );
}

Future<void> insertChlwoImagePath({
  required int checklistwoid,
  required String wonum,
  required String path,
}) async {
  await db.rawQuery(
      'INSERT INTO ${ChecklistWo.chlwoImagesTable}(wonum, checklistwoid, path, sent) '
      'VALUES("$wonum", "$checklistwoid", "$path", "0")');
  await setChanged(checklistwoid);
}

Future<void> markImageAsSent(String path, String table) async {
  await db.rawQuery(
    'UPDATE $table '
    'SET sent = "1" '
    'WHERE path = "$path"',
  );
}

Future<void> deleteImagePath({
  required String path,
}) async {
  await db.rawQuery(
      'DELETE FROM ${ChecklistWo.chlwoImagesTable} WHERE path = "$path"');
}

Future<List<String>> readWoImagesPaths({
  required int checklistwoid,
  bool forSending = true,
}) async {
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM ${ChecklistWo.chlwoImagesTable} '
    'WHERE checklistwoid = "$checklistwoid"${forSending ? 'AND sent = "0"' : ''}',
  );
  final result = <String>[];
  for (var m in queryResult) {
    result.add('${m['path']}');
  }
  return result;
}

// deletion
Future<void> deleteAudit(String wonum) async {
  await db.rawQuery(
    'DELETE FROM ${ChecklistWo.chlwoImagesTable} WHERE wonum = $wonum',
  );
  await db.rawQuery(
    'DELETE  FROM ${ChecklistWo.checkListWoTable} WHERE wonum = $wonum',
  );
  await db.rawQuery(
    'DELETE FROM ${WorkTaskMobile.auditsTable} WHERE wonum = $wonum',
  );
  await db.rawQuery(
    'DELETE FROM ${RsDefectComment.commentsTable} WHERE wonum = $wonum',
  );
}

// ppr
Future<void> insertPpr(List<WorkTaskMobile> ppr,
    {bool fromMaximo = false}) async {
  final batch = db.batch();

  for (var p in ppr) {
    final jobBatch = db.batch();
    for (var job in p.woactivity ?? <Woactivity>[]) {
      // print(job.description);

      job.wonum = p.wonum;
      jobBatch.insert(
        Woactivity.woactivityTable,
        job.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await jobBatch.commit();
    final worklogBatch = db.batch();
    for (var log in p.worklog ?? <Worklog>[]) {
      print(log.description);
      log.wonum = p.wonum;
      worklogBatch.insert(
        Worklog.worklogTable,
        log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await worklogBatch.commit();
    p.pprTakenInMaximo = fromMaximo;
    batch.insert(
      WorkTaskMobile.pprTable,
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<List<WorkTaskMobile>> readAllPpr() async {
  final List<Map<String, dynamic>> pprMap =
      await db.query(WorkTaskMobile.pprTable, orderBy: 'targcompdate, wonum');
  final pprList = await _addJobsAndComments(pprMap);
  for (var ppr in pprList) {
    _addImagesToWtm(ppr);
  }
  return pprList;
}

Future<List<WorkTaskMobile>> _addJobsAndComments(
    List<Map<String, dynamic>> pprMap) async {
  final pprs = pprMap.map((e) => WorkTaskMobile.fromMap(e)).toList();
  for (final ppr in pprs) {
    final List<Woactivity> jobs = await readJobTasksByWonum(ppr.wonum ?? '');
    ppr.woactivity = jobs;
  }
  return _addComments(pprs);
}

Future<List<WorkTaskMobile>> _addComments(List<WorkTaskMobile> pprs) async {
  for (final ppr in pprs) {
    final List<Worklog> comments = await readWorklogByWonum(ppr.wonum ?? '');
    ppr.worklog = comments;
  }
  return pprs;
}

Future<WorkTaskMobile> _addJobsAndCommentsToPpr(
    Map<String, dynamic> pprMap) async {
  final ppr = WorkTaskMobile.fromMap(pprMap);
  final List<Woactivity> jobs = await readJobTasksByWonum(ppr.wonum ?? '');
  ppr.woactivity = jobs;
  return _addCommentsToPpr(ppr);
}

Future<WorkTaskMobile> _addCommentsToPpr(WorkTaskMobile ppr) async {
  final List<Worklog> comments = await readWorklogByWonum(ppr.wonum ?? '');
  ppr.worklog = comments;
  return ppr;
}

Future<WorkTaskMobile> _addImagesToWtm(WorkTaskMobile wtm) async {
  final List<String> images =
      await readImagesPaths(wonum: wtm.wonum!, forSending: false);
  if (images.isNotEmpty) {
    wtm.addImages(images);
  }
  return wtm;
}

Future<WorkTaskMobile> readPprByWonum(String wonum) async {
  final query = ''
      'SELECT * FROM ${WorkTaskMobile.pprTable} '
      'WHERE wonum= $wonum'
      '';
  final List<Map<String, dynamic>> pprMap = await db.rawQuery(query);
  final ppr = await _addJobsAndCommentsToPpr(pprMap.first);
  await _addImagesToWtm(ppr);
  return ppr;
}

Future<List<WorkTaskMobile>> readTodayPpr() async {
  final query = ''
      'SELECT * FROM ${WorkTaskMobile.pprTable} '
      'WHERE targstartdate LIKE \'%${todayIso()}%\''
      'OR targcompdate LIKE \'%${todayIso()}%\''
      '';
  final List<Map<String, dynamic>> pprMap = await db.rawQuery(query);
  return _addJobsAndComments(pprMap);
}

Future<Iterable<String>> readCompletedPprWonums() async {
  const query = 'SELECT wonum FROM ${WorkTaskMobile.pprTable} '
      'WHERE status = "$statusCompleted" OR status = "$statusFullyCompleted"';
  final List<Map<String, dynamic>> pprWonums = await db.rawQuery(query);
  return pprWonums.map((e) => e['wonum']);
}

Future<Iterable<String>> readFreshCommentsByWonum(String wonum) async {
  final List<Map<String, dynamic>> result = await db.rawQuery(''
      'SELECT description FROM ${Worklog.worklogTable} '
      'WHERE wonum = "$wonum" AND fresh = "1"'
      '');
  return result.map((e) => e['description']);
}

Future<List<WorkTaskMobile>> readOutdatedPpr() async {
  final today = DateTime.now();
  final pprs = (await readAllPpr()).where((ppr) {
    final compDate = DateTime.parse(ppr.targcompdate ?? '');

    return compDate.compareTo(today) < 0;
  });

  return pprs.toList();
}

Future<List<WorkTaskMobile>> readCompletedPpr() async {
  final pprs = (await readAllPpr()).where((ppr) {
    return ppr.status == statusCompleted;
  });

  return pprs.toList();
}

Future<void> deletePpr(String wonum) async {
  await deleteJobTasksByWonum(wonum);
  await deleteCommentsByWonum(wonum);
  await db.rawQuery(
    'DELETE FROM ${WorkTaskMobile.pprTable} WHERE wonum = "$wonum"',
  );
}

Future<void> deleteAllPpr(List<String> wonums) async {
  await deleteAllJobTasks();
  await deleteAllWorklog(wonums);
  await deleteImagesByWonums(WorkTaskMobile.imagesTable, wonums);
  await db.rawQuery('DELETE FROM ${WorkTaskMobile.pprTable}');
}

Future<void> deleteImagesByWonums(String table, List<String> wonums) async {
  String join = wonums.join('","');
  String query = 'DELETE FROM $table WHERE wonum IN ("$join")';
  await db.rawQuery(query);
}

Future<void> deleteSentImages(String table) async {
  String query = 'DELETE FROM $table WHERE sent = "1"';
  await db.rawQuery(query);
}

Future<List<Woactivity>> readJobTasksByWonum(String wonum) async {
  final result = await db.rawQuery(
      'SELECT * FROM ${Woactivity.woactivityTable} WHERE wonum = "$wonum"');

  final tasks = result.map((e) => Woactivity.fromMap(e)).toList();
  return tasks;
}

Future<void> updateJobtaskResult({
  required String wonum,
  required int wosequence,
  required String result,
}) async {
  await db.rawQuery(
    'UPDATE ${Woactivity.woactivityTable} '
    'SET pprresult = "$result" '
    'WHERE wonum = "$wonum" AND wosequence="$wosequence"',
  );
}

Future<void> takePprInWorkLocally(String wonum) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.pprTable} '
    'SET status = "$statusAssigned",  pprTakenInMaximo = "0"'
    'WHERE wonum = "$wonum"',
  );
}

Future<void> pprTakenInMaximo(String wonum) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.pprTable} '
    'SET pprTakenInMaximo = "1" '
    'WHERE wonum = "$wonum"',
  );
}

Future<void> completePprJobs({
  required String wonum,
}) async {
  await db.rawQuery(
    'UPDATE ${Woactivity.woactivityTable} '
    'SET pprresult = "$good" '
    'WHERE wonum = "$wonum"',
  );
}

Future<void> addJobtaskComment({
  required String wonum,
  required int wosequence,
  required String comment,
}) async {
  await db.rawQuery(
    'UPDATE ${Woactivity.woactivityTable} '
    'SET pprcomment= "$comment" '
    'WHERE wonum = "$wonum" AND wosequence="$wosequence"',
  );
}

Future<void> addCommentToWorklogTable(String wonum, String comment) async {
  await db.rawQuery(
      'INSERT INTO ${Worklog.worklogTable}(wonum, description, fresh) '
      'VALUES("$wonum", "$comment", "1")');
}

Future<void> deleteAllJobTasks() async {
  await db.rawQuery('DELETE FROM ${Woactivity.woactivityTable}');
}

Future<void> deleteJobTasksByWonum(String wonum) async {
  await db.rawQuery(
    'DELETE FROM ${Woactivity.woactivityTable} WHERE wonum = "$wonum"',
  );
}

Future<List<Worklog>> readWorklogByWonum(String wonum) async {
  final result = await db
      .rawQuery('SELECT * FROM ${Worklog.worklogTable} WHERE wonum = "$wonum"');

  final comments = result.map((e) => Worklog.fromMap(e)).toList();
  return comments;
}

Future<void> deleteAllWorklog(List<String> wonums) async {
  String join = wonums.join('","');
  await db
      .rawQuery('DELETE FROM ${Worklog.worklogTable} WHERE wonum IN ("$join")');
}

Future<void> deleteCommentsByWonum(String wonum) async {
  await db.rawQuery(
    'DELETE FROM ${Worklog.worklogTable} WHERE wonum = "$wonum"',
  );
}

Future<void> deleteComment(String wonum, String comment) async {
  await db
      .rawQuery('DELETE FROM ${Worklog.worklogTable} WHERE wonum = "$wonum" '
          'AND  description = "$comment"');
}

// ppr images

Future<void> insertWtmImagePath({
  required String wonum,
  required String path,
}) async {
  await db
      .rawQuery('INSERT INTO ${WorkTaskMobile.imagesTable}(wonum, path, sent) '
          'VALUES("$wonum", "$path", "0")');
}

Future<void> deleteWtmImagePath({
  required String path,
}) async {
  await db.rawQuery(
      'DELETE FROM ${WorkTaskMobile.imagesTable} WHERE path = "$path"');
}

Future<List<String>> readImagesPaths({
  required String wonum,
  bool forSending = true,
}) async {
  final List<Map<String, Object?>> queryResult = await db.rawQuery(
    'SELECT * FROM ${WorkTaskMobile.imagesTable} '
    'WHERE wonum = "$wonum"${forSending ? 'AND sent = "0"' : ''}',
  );
  final result = <String>[];
  for (var m in queryResult) {
    result.add('${m['path']}');
  }
  return result;
}

// rz
Future<void> insertRz(List<WorkTaskMobile> rzList) async {
  final batch = db.batch();

  for (var rz in rzList) {
    final worklogBatch = db.batch();
    for (var log in rz.worklog ?? <Worklog>[]) {
      print('inserting rz comment ${log.description}');
      log.wonum = rz.wonum;
      worklogBatch.insert(
        Worklog.worklogTable,
        log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await worklogBatch.commit();

    batch.insert(
      WorkTaskMobile.rzTable,
      rz.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<void> deleteRz(String wonum) async {
  await deleteCommentsByWonum(wonum);
  await deleteImagesByWonums(WorkTaskMobile.imagesTable, [wonum]);
  await db.rawQuery(
    'DELETE FROM ${WorkTaskMobile.rzTable} WHERE wonum = "$wonum"',
  );
}

Future<void> deleteAllRz(List<String> wonums) async {
  await deleteAllWorklog(wonums);
  await deleteImagesByWonums(WorkTaskMobile.imagesTable, wonums);
  await db.rawQuery('DELETE FROM ${WorkTaskMobile.rzTable}');
}

Future<Iterable<String>> readPreAcceptedRzWonums() async {
  const query = 'SELECT wonum FROM ${WorkTaskMobile.rzTable} '
      'WHERE status = "$statusPreApproved" OR status = "$statusDefecting"';
  final List<Map<String, dynamic>> rzWonums = await db.rawQuery(query);
  return rzWonums.map((e) => e['wonum']);
}

Future<List<WorkTaskMobile>> readAllRz() async {
  final List<Map<String, dynamic>> rzMap =
      await db.query(WorkTaskMobile.rzTable, orderBy: 'targcompdate');
  final rzList =
      rzMap.map((e) => WorkTaskMobile.fromMap(e)).toList().reversed.toList();
  for (final rz in rzList) {
    await _addImagesToWtm(rz);
  }
  return _addComments(rzList);
}

Future<List<WorkTaskMobile>> readAllReadyRzs() async {
  final allRzs = await readAllRz();
  return allRzs.where((rz) => rz.offlineScript != null).toList();
}

Future<WorkTaskMobile> readRzByWonum(String wonum) async {
  final query = ''
      'SELECT * FROM ${WorkTaskMobile.rzTable} '
      'WHERE wonum= $wonum'
      '';
  final List<Map<String, dynamic>> rzMap = (await db.rawQuery(query));
  final rz = WorkTaskMobile.fromMap(rzMap.first);
  if (rz.assetnum != null) {
    final asset = await readAssetByAssetnum(rz.assetnum!);
    rz.asset = asset;
  }
  final List<Worklog> comments = await readWorklogByWonum(rz.wonum ?? '');
  rz.worklog = comments;
  await _addImagesToWtm(rz);
  return rz;
}

// Assets

Future<void> insertAssets(List<Asset> assets) async {
  final batch = db.batch();
  for (var a in assets) {
    batch.insert(
      Asset.assetsTable,
      a.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await batch.commit();
}

Future<List<Asset>> readAssets() async {
  final List<Map<String, dynamic>> assetsMap =
      await db.query(Asset.assetsTable);
  final assets =
      assetsMap.map((e) => Asset.fromMap(e)).toList().reversed.toList();
  return assets;
}

Future<void> updateRzAssetnum({
  required String wonum,
  required String assetnum,
}) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.rzTable} '
    'SET assetnum = "$assetnum" '
    'WHERE wonum = "$wonum"',
  );
}

Future<void> updateRzOfflineScript({
  required String wonum,
  required String script,
}) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.rzTable} '
    'SET offlineScript = "$script" '
    'WHERE wonum = "$wonum"',
  );
}

Future<void> removeRzOfflineScript({
  required String wonum,
}) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.rzTable} '
    'SET offlineScript = NULL '
    'WHERE wonum = "$wonum"',
  );
}

Future<void> updateRzStatus({
  required String wonum,
  required String status,
  required String statusDescription,
}) async {
  await db.rawQuery(
    'UPDATE ${WorkTaskMobile.rzTable} '
    'SET status = "$status", status_description = "$statusDescription"'
    'WHERE wonum = "$wonum"',
  );
}

Future<Asset?> readAssetByAssetnum(String assetnum) async {
  final query = ''
      'SELECT * FROM ${Asset.assetsTable} '
      'WHERE assetnum = "$assetnum"'
      '';
  try {
    final List<Map<String, dynamic>> assetMap = (await db.rawQuery(query));
    return Asset.fromMap(assetMap.first);
  } catch (err) {
    debugPrint('cannot read asset by assetnum: $assetnum');
    return null;
  }
}

// Sr

Future<void> insertSr(Sr sr) async {
  final batch = db.batch();
  batch.insert(Sr.srTable, sr.toMap());
  await batch.commit();
}

Future<void> deleteSr({
  required Sr sr,
}) async {
  if (sr.ticketid != null && (sr.ticketid?.isNotEmpty ?? false)) {
    await db.rawQuery('DELETE FROM ${Sr.srTable} WHERE '
        'ticketid  = "${sr.ticketid}"');
  } else {
    await deleteSrByDescriptions(sr: sr);
  }
}

Future<void> deleteSrByDescriptions({
  required Sr sr,
}) async {
  await db.rawQuery('DELETE FROM ${Sr.srTable} WHERE '
      'description = "${sr.description}" AND locdesc = "${sr.locdesc}"');
}

Future<List<Sr>> readAllSr() async {
  final List<Map<String, dynamic>> srMap = await db.query(
    Sr.srTable,
  );
  final srList = srMap.map((e) => Sr.fromMap(e)).toList();
  for (final sr in srList) {
    _addImagesToSr(sr);
  }
  return srList;
}

Future<Sr> _addImagesToSr(Sr sr) async {
  final List<String> images =
      await readImagesPaths(wonum: sr.changedate!, forSending: false);
  if (images.isNotEmpty) {
    sr.addImages(images);
  }
  return sr;
}

Future<List<Sr>> readSavedSr() async {
  return (await readAllSr()).where((sr) => sr.ticketid == null).toList();
}
