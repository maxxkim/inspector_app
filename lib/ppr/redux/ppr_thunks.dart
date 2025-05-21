import 'package:flutter/foundation.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/maximo_repository.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_actions.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';
import 'package:inspector_tps/ppr/utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> downloadPprAction({required String date}) =>
    (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final ppr = await sl<MaximoRepository>().downloadPprs(date: date);

        await insertPpr(ppr?.member ?? [], fromMaximo: true);
        store.dispatch(readPprsFromDbAction());
      } catch (err) {
        debugPrint('download ppr thunk error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> readPprsFromDbAction({bool downloadIfEmpty = false}) =>
    (store) async {
      final filter = store.state.pprState.filter;
      store.dispatch(ShowLoader());
      final List<WorkTaskMobile> savedPpr;
      switch (filter) {
        case PprFilter.shift:
          savedPpr = await readTodayPpr();
          break;
        case PprFilter.outdated:
          savedPpr = await readOutdatedPpr();
          break;
        case PprFilter.completed:
          savedPpr = await readCompletedPpr();
          break;
        default:
          savedPpr = await readAllPpr();
          break;
      }
      store.dispatch(SetPprAction(savedPpr));
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> readSelectedPprFromDbAction(String wonum) =>
    (store) async {
      final ppr = await readPprByWonum(wonum);
      store.dispatch(SelectedPprAction(ppr));
    };

ThunkAction<AppState> addCommentToPprAction(
        {required String wonum, required String comment}) =>
    (store) async {
      await addCommentToWorklogTable(wonum, comment);
      store.dispatch(readSelectedPprFromDbAction(wonum));
    };

ThunkAction<AppState> updateJobtaskResultAction({
  required String wonum,
  required int wosequence,
  required String result,
}) =>
    (store) async {
      await updateJobtaskResult(
          wonum: wonum, wosequence: wosequence, result: result);
      store.dispatch(readSelectedPprFromDbAction(wonum));
    };

ThunkAction<AppState> completePprJobsAction({
  required String wonum,
}) =>
    (store) async {
      await completePprJobs(wonum: wonum);
      store.dispatch(readSelectedPprFromDbAction(wonum));
    };

ThunkAction<AppState> addJobtaskCommentAction({
  required String wonum,
  required int wosequence,
  required String comment,
}) =>
    (store) async {
      await addJobtaskComment(
          wonum: wonum, wosequence: wosequence, comment: comment);
      store.dispatch(readSelectedPprFromDbAction(wonum));
    };

ThunkAction<AppState> takeInWorkPprAction(String wonum) => (store) async {
      store.dispatch(ShowLoader());
      final repo = sl<MaximoRepository>();
      try {
        if (!store.state.isConnected) {
          await takePprInWorkLocally(wonum);
        } else {
          await userController.checkAuthorization();
          final success = await repo.runScript(wonum,
              script: scriptTakeInWork, description: 'take ppr in work');
          if (success) {
            await _downloadAndInsertUpdatedPpr(wonum);
          }
        }
      } catch (err) {
        debugPrint('take in work ppr thunk error: $err');
      } finally {
        _finallyPpr(store, wonum);
      }
    };

ThunkAction<AppState> completePprsByDutyEngAction(List<WorkTaskMobile> pprs) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      final repo = sl<MaximoRepository>();
      try {
        await userController.checkAuthorization();
        if (pprs.isEmpty) {
          pprs = await getReadyPprs();
        }
        for (final ppr in pprs) {
          final wonum = ppr.wonum!;
          final List<Woactivity> jobs = await readJobTasksByWonum(wonum ?? '');
          for (final job in jobs) {
            await repo.updateWoactivity(job);
          }
          await sendComments(wonum, ppr.href);
          await uploadWtmImages(wonum, ppr.doclinks?.href);
          final success = await repo.runScript(wonum,
              script: scriptDutyComp, description: 'complete ppr by Duty eng.');
          if (success) {
            await _downloadAndInsertUpdatedPpr(wonum);
          }
        }
      } catch (err) {
        debugPrint('complete ppr by duty thunk error: $err');
      } finally {
        _finallyPpr(store, pprs.length == 1 ? pprs.first.wonum : null);
      }
    };

ThunkAction<AppState> sendForApprovalZdePprAction(
        String wonum, String? href, String? doclinks) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      try {
        await userController.checkAuthorization();
        await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        final success = await sl<MaximoRepository>().runScript(wonum,
            script: scriptItrComp, description: 'send for approval');
        if (success) {
          await _downloadAndInsertUpdatedPpr(wonum);
        }
      } catch (err) {
        debugPrint('send for zde approval thunk error: $err');
      } finally {
        _finallyPpr(store, wonum);
      }
    };

ThunkAction<AppState> reportEquipmentFailureWithCommentAction(
        String wonum, String? href, String comment, String? doclinks) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      await addCommentToWorklogTable(wonum, comment);
      try {
        await userController.checkAuthorization();
        await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        final success = await sl<MaximoRepository>().runScript(wonum,
            script: scriptReportEquipmentFailure,
            description: 'reportEquipmentFailureWithCommentAction');
        if (success) {
          await _downloadAndInsertUpdatedPpr(wonum);
        }
      } catch (err) {
        debugPrint('send for zde approval thunk error: $err');
      } finally {
        _finallyPpr(store, wonum);
      }
    };

ThunkAction<AppState> confirmPprAction(
        String wonum, String? href, String? doclinks) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      try {
        await userController.checkAuthorization();
        await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        final success = await sl<MaximoRepository>().runScript(wonum,
            script: scriptZdeConfirm, description: 'confirm ppr');
        if (success) {
          await _downloadAndInsertUpdatedPpr(wonum);
        }
      } catch (err) {
        debugPrint('confirm ppr thunk error: $err');
      } finally {
        _finallyPpr(store, wonum);
      }
    };

ThunkAction<AppState> cancelPprAction(
        String wonum, String? href, String comment, String? doclinks) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      await addCommentToWorklogTable(wonum, comment);
      try {
        await userController.checkAuthorization();
        await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        final success = await sl<MaximoRepository>().runScript(wonum,
            script: scriptZdeCancel, description: 'cancel ppr');
        if (success) {
          await _downloadAndInsertUpdatedPpr(wonum);
        }
      } catch (err) {
        debugPrint('cancel ppr thunk error: $err');
      } finally {
        _finallyPpr(store, wonum);
      }
    };

ThunkAction<AppState> sendCommentToMaximoAction(
  String wonum,
  String? href,
  String? doclinks, {
  bool isPpr = true,
}) =>
    (store) async {
      if (!store.state.isConnected) return;
      store.dispatch(ShowLoader());
      try {
        await userController.checkAuthorization();
        final success = await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        if (success) {
          if (isPpr) {
            await _downloadAndInsertUpdatedPpr(wonum);
          } else {
            await downloadAndInsertUpdatedRz(wonum);
          }
        }
      } catch (err) {
        debugPrint('sendCommentToMaximoAction error: $err');
      } finally {
        if (isPpr) {
          _finallyPpr(store, wonum);
        } else {
          finallyRz(store, wonum);
        }
      }
    };

Future<void> uploadWtmImages(String wonum, String? doclinks) async {
  if (doclinks == null) return;
  final List<String> images = await readImagesPaths(wonum: wonum);
  debugPrint('uploading ${images.length} images to: $doclinks');
  await maximoRepository.uploadImagesToMaximo(
    paths: images,
    docLink: doclinks,
    table: WorkTaskMobile.imagesTable,
  );
  await deleteSentImages(WorkTaskMobile.imagesTable);
}

void _finallyPpr(Store<AppState> store, String? wonum) {
  if (wonum != null) {
    store.dispatch(readSelectedPprFromDbAction(wonum));
  }
  store.dispatch(readPprsFromDbAction());
  store.dispatch(HideLoader());
}

Future<void> _downloadAndInsertUpdatedPpr(String wonum) async {
  final repo = sl<MaximoRepository>();
  final pprResponse = await repo.downloadWtmByWonum(wonum);
  final updatedPpr = pprResponse?.member?.first;
  debugPrint('upd ppr: $updatedPpr');
  if (updatedPpr != null && updatedPpr.wonum != null) {
    await deletePpr(updatedPpr.wonum!);
    await insertPpr([updatedPpr], fromMaximo: true);
  }
}

// deletion
ThunkAction<AppState> deleteAllPprAction(List<String> wonums) => (store) async {
      await deleteAllPpr(wonums);
      store.dispatch(ClearPprStateAction());
      await store.dispatch(readPprsFromDbAction());
    };

ThunkAction<AppState> deleteCompletedPprAction() => (store) async {
      final delWonums = await readCompletedPprWonums();
      print(delWonums);
      for (final w in delWonums) {
        await deletePpr(w);
      }
      await store.dispatch(readPprsFromDbAction());
    };

ThunkAction<AppState> deletePprCommentAction(
        {required String wonum, required String comment}) =>
    (store) async {
      await deleteComment(wonum, comment);
      store.dispatch(readSelectedPprFromDbAction(wonum));
    };
