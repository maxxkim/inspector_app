import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/maximo_repository.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/audit/rs_defect_comment.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> downloadAuditsAction() => (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final audits = await sl<MaximoRepository>().downloadAudits();
        await insertAudits(audits?.member ?? []);
        store.dispatch(readAuditsFromDbAction());
      } catch (err) {
        debugPrint('download audits thunk error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> readAuditsFromDbAction({bool downloadIfEmpty = false}) =>
    (store) async {
      final savedAudits = await readAllAudits();
      if (savedAudits.isEmpty && downloadIfEmpty) {
        store.dispatch(downloadAuditsAction());
        return;
      }
      store.dispatch(SetAuditsAction(savedAudits));
    };

ThunkAction<AppState> updateAuditsListAction() => (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());

      await userController.checkAuthorization();
      try {
        final response = await sl<MaximoRepository>().downloadAudits();
        var audits = response?.member ?? [];
        final alreadyLoaded =
            store.state.auditsState.audits?.map((e) => e.wonum).toList() ?? [];
        audits = audits
            .where((audit) => !alreadyLoaded.contains(audit.wonum))
            .toList();
        await insertAudits(audits);
        store.dispatch(readAuditsFromDbAction());
      } catch (err) {
        debugPrint('update audits error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> downloadAuditCheckListsAction(String href) =>
    (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final checkLists = await maximoRepository.downloadAuditChecklists(href);
        if (checkLists?.isNotEmpty ?? false) {
          final wonum = checkLists!.first.woNum;
          if (wonum != null) {
            await insertAuditCheckList(checkLists, wonum);
            store.dispatch(
                readChecklistFromDbAction(wonum, checkLists.first.href ?? ''));
          }
        }
      } catch (err) {
        debugPrint('download audit error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> readChecklistFromDbAction(String wonum, String href) =>
    (store) async {
      store.dispatch(ShowLoader());
      final checklist = await readAuditChecklists(wonum);
      if (checklist.isNotEmpty) {
        store.dispatch(ReadChecklistAction(checklist));
        store.dispatch(HideLoader());
      } else if (store.state.isConnected) {
        store.dispatch(downloadAuditCheckListsAction(href));
      } else {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> updateChecklistsInMaximo({required String wonum}) =>
    (store) async {
      if (!store.state.isConnected) {
        return;
      }
      await userController.checkAuthorization();

      store.dispatch(SendingAuditCountAction(0));
      store.dispatch(ShowSendingDialogAction(true));
      var count = 0;

      try {
        final List<ChecklistWo> forUploading =
            await readChecklistsForUploading(wonum);
        store.dispatch(TotalToUploadingAction(forUploading.length));

        for (final wo in forUploading) {
          // comments
          final freshComments =
              await readWoCommentsForUploading(wo.checklistOperationId ?? -1);

          for (var c in freshComments) {
            final commentUploaded = await maximoRepository
                .createRsDefectCommentForChecklistWo(rsComment: c);
            if (commentUploaded) {
              store.dispatch(deleteRsDefectCommentAction(
                  comment: c,
                  parentId: wo.parentId ?? -1,
                  checklistwoid: wo.checklistOperationId ?? -1));
            }
            debugPrint(
                'comment ${commentUploaded ? 'uploaded' : 'Failed to upload'}: ${c.comment}');
          }

          final url = await maximoRepository.getWoHref(wo.checklistWoId!);
          if (url == null) {
            continue;
          }
          try {
            final updated = await maximoRepository.updateChecklistWo(
              url: url,
              // comment: wo.goal,
              status: wo.chlistStatus,
              checked: wo.rsMasterpoint,
              factor: wo.numberof,
            );
            final List<String> images =
                await readWoImagesPaths(checklistwoid: wo.checklistWoId!);
            final doclinks = wo.doclinks?.href;
            if (doclinks != null) {
              debugPrint('uploading image to: $doclinks');
              await maximoRepository.uploadImagesToMaximo(
                paths: images,
                docLink: doclinks,
                table: ChecklistWo.chlwoImagesTable,
              );
            }
            if (updated) {
              count++;
              store.dispatch(SendingAuditCountAction(count));
              resetChanged(wo.checklistWoId!);
            }
          } catch (err) {
            debugPrint('Cannot update ${wo.number} in Maximo');
          }
        }
      } finally {
        debugPrint('sent count: $count');
        await Future.delayed(const Duration(seconds: 1));
        store.dispatch(ShowSendingDialogAction(false));
      }
    };

// ThunkAction<AppState> updateCommentAction(
//         {required String wonum,
//         required int checklistwoid,
//         required int checklistOperationId,
//         required String comment}) =>
//     (store) async {
//       await updateComment(checklistwoid, comment);
//       final checklist = await readLastLevel(wonum, checklistOperationId);
//       store.dispatch(UpdateLastLevelAction(checklist));
//       store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
//     };

ThunkAction<AppState> addCommentAction({
  required String wonum,
  required int checklistwoid,
  required int checklistOperationId,
  required int parentId,
  required String comment,
  required String siteId,
}) =>
    (store) async {
      final rsComment = RsDefectComment(
        comment: comment,
        checklistOperationId: checklistOperationId,
        orgId: 'TPS',
        notCreateSr: true,
        woNum: wonum,
        checklistWoId: checklistwoid,
        siteId: siteId,
      );
      await insertRsDefectComments([rsComment]);
      await updateChanged(checklistwoid);
      final checklist = await readLastLevel(wonum, parentId);
      if (checklist.isNotEmpty) {
        store.dispatch(UpdateLastLevelAction(checklist));
      }
      store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
    };

ThunkAction<AppState> deleteRsDefectCommentAction({
  required RsDefectComment comment,
  required int parentId,
  required int checklistwoid,
}) =>
    (store) async {
      await deleteRsDefectCommentDb(comment);
      final checklist = await readLastLevel(comment.woNum ?? '', parentId);
      if (checklist.isNotEmpty) {
        store.dispatch(UpdateLastLevelAction(checklist));
      }
      store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
    };

ThunkAction<AppState> updateStatusAction(
        {required String wonum,
        required int checklistwoid,
        required int parentId,
        required String status}) =>
    (store) async {
      await updateStatus(checklistwoid, status);
      final checklist = await readLastLevel(wonum, parentId);
      if (checklist.isNotEmpty) {
        store.dispatch(UpdateLastLevelAction(checklist));
      }
      store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
    };

ThunkAction<AppState> updateFactorAction(
        {required String wonum,
        required int checklistwoid,
        required int parentId,
        required double factor}) =>
    (store) async {
      await updateFactor(checklistwoid, factor);
      final checklist = await readLastLevel(wonum, parentId);
      if (checklist.isNotEmpty) {
        store.dispatch(UpdateLastLevelAction(checklist));
      }
      store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
    };

ThunkAction<AppState> updateCheckedAction(
        {required String wonum,
        required int checklistwoid,
        required int parentId,
        required int checked}) =>
    (store) async {
      await updateChecked(checklistwoid, checked);
      final checklist = await readLastLevel(wonum, parentId);
      if (checklist.isNotEmpty) {
        store.dispatch(UpdateLastLevelAction(checklist));
      }
      store.dispatch(findAndUpdateWoInLevels(checklistwoid: checklistwoid));
    };

ThunkAction<AppState> findAndUpdateWoInLevels({
  required int checklistwoid,
}) =>
    (store) async {
      final updated = await readWo(checklistwoid);

      final newLevels = [...store.state.auditsState.checkListLevels];
      void update(List<ChecklistWo> input) {
        for (int i = 0; i < input.length; i++) {
          final old = input[i];
          if (old.checklistWoId == updated.checklistWoId) {
            input[i] = updated;
          }
          if (old.checklist.isNotEmpty) {
            update(old.checklist);
          }
        }
      }

      for (var level in newLevels) {
        update(level);
      }
      store.dispatch(UpdateLevelsAction(newLevels));
    };

ThunkAction<AppState> visitInLevels({
  required int checklistwoid,
}) =>
    (store) async {
      // final updated = await readWo(checklistwoid);

      final currentLevels = store.state.auditsState.checkListLevels.last;
      for (final w in currentLevels) {
        if (w.checklistWoId == checklistwoid) {
          w.visited = true;
        }
      }
    };

// deletion
ThunkAction<AppState> deleteAuditAction(String wonum) => (store) async {
      store.dispatch(ShowLoader());
      await deleteAudit(wonum);
      store.dispatch(ClearAuditsStateAction());
      await store.dispatch(readAuditsFromDbAction());
      store.dispatch(HideLoader());
    };
