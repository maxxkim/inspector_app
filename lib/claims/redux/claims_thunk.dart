import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/claims/redux/claims_actions.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';
import 'package:inspector_tps/data/maximo_repository.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// rz
ThunkAction<AppState> downloadRzListAction() => (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final rzListResponse = await sl<MaximoRepository>().downloadRzList();

        await insertRz(rzListResponse?.member ?? []);
        store.dispatch(readRzListFromDbAction());
      } catch (err) {
        debugPrint('download ppr thunk error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> downloadAssetsCatalogAction() => (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final assetsJson =
            await sl<MaximoRepository>().downloadAssetsCatalog() ?? [];
        final assets = <Asset>[];

        for (var ass in assetsJson) {
          final asset = Asset.fromJson(ass);
          try {
            final location = (ass['locations'] as List).first['description'];
            asset.locationDescription = location;
          } catch (err) {
            debugPrint(
                'no location for asset: ${asset.assetnum} ${asset.description}');
          }
          try {
            final equipment =
                (ass['classstructure'] as List).first['description'];
            asset.classstructureDescription = equipment;
          } catch (err) {
            debugPrint(
                'no equipment for asset: ${asset.assetnum} ${asset.description}');
          }
          assets.add(asset);
        }
        await insertAssets(assets);
        store.dispatch(SetAssetsAction(assets));
      } catch (err) {
        debugPrint('download assets thunk error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> downloadSitesAction() => (store) async {
      if (!store.state.isConnected) {
        return;
      }
      store.dispatch(ShowLoader());
      await userController.checkAuthorization();
      try {
        final sites = await sl<MaximoRepository>().downloadSites();
        if (sites == null) {
          throw 'no sites downloaded';
        }
        saveSites(sites);

        final savedSites = readSites();

        print('saved sites: $savedSites');
      } catch (err) {
        debugPrint('download sites thunk error: $err');
      } finally {
        store.dispatch(HideLoader());
      }
    };

ThunkAction<AppState> readRzListFromDbAction() => (store) async {
      final filter = store.state.claimsState.rzFilter;
      store.dispatch(ShowLoader());
      final List<WorkTaskMobile> savedRzList;
      switch (filter) {
        case RzFilter.all:
          savedRzList = await readAllRz();
          break;
        default:
          savedRzList = await readAllRz();
          break;
      }
      store.dispatch(SetRzListAction(savedRzList));
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> readAssetsFromDbAction() => (store) async {
      store.dispatch(ShowLoader());
      final List<Asset> assets = await readAssets();
      store.dispatch(SetAssetsAction(assets));
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> addCommentToRzAction(
        {required String wonum, required String comment}) =>
    (store) async {
      await addCommentToWorklogTable(wonum, comment);
      store.dispatch(readSelectedRzFromDbAction(wonum));
    };

ThunkAction<AppState> readSelectedRzFromDbAction(String wonum) =>
    (store) async {
      final rz = await readRzByWonum(wonum);
      store.dispatch(SelectedRzAction(rz));
    };

ThunkAction<AppState> deleteRzCommentAction(
        {required String wonum, required String comment}) =>
    (store) async {
      await deleteComment(wonum, comment);
      store.dispatch(readSelectedRzFromDbAction(wonum));
    };

ThunkAction<AppState> updateRzAssetnumAction({
  required String wonum,
  required String assetnum,
}) =>
    (store) async {
      await updateRzAssetnum(wonum: wonum, assetnum: assetnum);
      store.dispatch(readSelectedRzFromDbAction(wonum));
    };

ThunkAction<AppState> rzProblemSolvedAction(
        WorkTaskMobile rz, String? href, String? doclinks,
        {required bool solved, required String assetnum}) =>
    (store) async {
      final wonum = rz.wonum!;
      store.dispatch(ShowLoader());
      if (!store.state.isConnected) {
        await updateRzOfflineScript(
            wonum: wonum,
            script: solved ? rzProblemSolvedScript : rzProblemUnSolvedScript);
        finallyRz(store, wonum);
        return;
      }
      try {
        await userController.checkAuthorization();
        await sendComments(wonum, href);
        await uploadWtmImages(wonum, doclinks);
        final assetnumUploaded = await sl<MaximoRepository>()
            .uploadAssetnumToWorkTaskMobile(href!, assetnum);
        if (!assetnumUploaded) throw 'cannot upload assetnum';
        final success = await sl<MaximoRepository>().runScript(wonum,
            script: solved ? rzProblemSolvedScript : rzProblemUnSolvedScript,
            description: 'rzProblemSolvedAction: $solved script');
        if (success) {
          await downloadAndInsertUpdatedRzStatus(wonum);
          await deleteCommentsByWonum(wonum);
        }
      } catch (err) {
        debugPrint('rzProblemSolvedAction error: $err');
      } finally {
        finallyRz(store, wonum);
      }
    };

ThunkAction<AppState> sendLocallyProcessedRzs() => (store) async {
      store.dispatch(ShowLoader());
      final rzs = await readAllReadyRzs();
      await userController.checkAuthorization();
      try {
        for (var rz in rzs) {
          await sendComments(rz.wonum!, rz.href!);
          await uploadWtmImages(rz.wonum!, rz.doclinks!.href!);
          final assetnumUploaded = await sl<MaximoRepository>()
              .uploadAssetnumToWorkTaskMobile(rz.href!, rz.assetnum!);
          if (!assetnumUploaded) throw 'cannot upload assetnum';
          final success = await sl<MaximoRepository>().runScript(rz.wonum!,
              script: rz.offlineScript!,
              description:
                  'rzProblemSolvedAction: ${rz.offlineScript!} script');
          if (success) {
            await downloadAndInsertUpdatedRzStatus(rz.wonum!);
            await deleteCommentsByWonum(rz.wonum!);
            await removeRzOfflineScript(wonum: rz.wonum!);
          }
        }
      } catch (err) {
        debugPrint('rzProblemSolvedAction error: $err');
      } finally {
        finallyRz(store, null);
      }
    };

ThunkAction<AppState> deleteAllRzAction(List<String> wonums) => (store) async {
      await deleteAllRz(wonums);
      store.dispatch(ClearClaimsStateAction());
      await store.dispatch(readRzListFromDbAction());
    };

ThunkAction<AppState> deletePreAcceptedRzAction() => (store) async {
      final delWonums = await readPreAcceptedRzWonums();
      print(delWonums);
      for (final w in delWonums) {
        await deleteRz(w);
      }
      await store.dispatch(readRzListFromDbAction());
    };

// helpers analog _d.... for ppr
Future<void> downloadAndInsertUpdatedRz(String wonum) async {
  final repo = sl<MaximoRepository>();
  final rzResponse = await repo.downloadWtmByWonum(wonum);
  final updatedRz = rzResponse?.member?.first;
  debugPrint('upd rz: $updatedRz');
  if (updatedRz != null && updatedRz.wonum != null) {
    await deleteRz(updatedRz.wonum!);
    await insertRz([updatedRz]);
  }
}

Future<void> downloadAndInsertUpdatedRzStatus(String wonum) async {
  final repo = sl<MaximoRepository>();
  final rzResponse = await repo.downloadWtmByWonum(wonum);
  final updatedRz = rzResponse?.member?.first;
  final status = updatedRz?.status;
  debugPrint('updated rz status: $status');
  if (updatedRz != null &&
      updatedRz.wonum != null &&
      updatedRz.status != null) {
    await updateRzStatus(
        wonum: wonum,
        status: updatedRz.status!,
        statusDescription: updatedRz.statusDescription ?? '');
  }
}

void finallyRz(Store<AppState> store, String? wonum) {
  if (wonum != null) {
    store.dispatch(readSelectedRzFromDbAction(wonum));
  }
  store.dispatch(readRzListFromDbAction());
  store.dispatch(HideLoader());
}
// end helpers analog _d.... for ppr

// sr
ThunkAction<AppState> createClaimAction(
        {required String location,
        required String description,
        required String? pickedSite,
        bool finallyHideLoader = true}) =>
    (store) async {
      store.dispatch(ShowLoader());
      // if (!store.state.isConnected) {
      final sr = Sr(
          changedate: DateTime.now().millisecondsSinceEpoch.toString(),
          locdesc: location,
          siteid: pickedSite,
          description: description);
      await insertSr(sr);
      store.dispatch(readSrListFromDbAction());
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> sendClaimToMaximoAction({
  required Sr savedSr,
  bool finallyHideLoader = true,
  required UserModel user,
}) =>
    (store) async {
      store.dispatch(ShowLoader());

      await userController.checkAuthorization();
      try {
        final sr = await sl<MaximoRepository>().createSr(
            location: savedSr.locdesc ?? '',
            siteId: savedSr.siteid ?? user.defaultSite ?? '',
            description: savedSr.description ?? 'n/a');
        if (sr != null) {
          final doclink = '${sr.href}${Endpoints.doclinks}'
              .replaceFirst('mxsr', 'ilcmobsr');
          debugPrint('sr doclink: $doclink');
          await uploadWtmImages(savedSr.changedate ?? '', doclink);

          await deleteSrByDescriptions(sr: sr);
          await insertSr(sr);
          store.dispatch(readSrListFromDbAction());
        }
      } catch (err) {
        debugPrint('thunk create sr error: $err');
      } finally {
        if (finallyHideLoader) {
          store.dispatch(HideLoader());
        }
      }
      store.dispatch(readSrListFromDbAction());
      store.dispatch(HideLoader());
    };

sendAllSavedSr(BuildContext context, UserModel user) async {
  final List<Sr> savedSr = await readSavedSr();
  for (final sr in savedSr) {
    final action = sendClaimToMaximoAction(savedSr: sr, user: user);
    if (context.mounted) {
      context.store.dispatch(action);
    }
  }
}

ThunkAction<AppState> readSrListFromDbAction() => (store) async {
      store.dispatch(ShowLoader());
      final srList = await readAllSr();
      store.dispatch(SetSrListAction(srList));
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> readSrListAndAssetsFromDbAction() => (store) async {
      store.dispatch(ShowLoader());
      final srList = await readAllSr();
      store.dispatch(SetSrListAction(srList));
      final assets = await readAssets();
      store.dispatch(SetAssetsAction(assets));
      store.dispatch(HideLoader());
    };

ThunkAction<AppState> deleteSrAction(Sr sr) => (store) async {
      store.dispatch(ShowLoader());
      await deleteSr(sr: sr);
      store.dispatch(readSrListFromDbAction());
      store.dispatch(HideLoader());
    };
