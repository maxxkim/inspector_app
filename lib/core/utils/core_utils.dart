import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/auth/redux/user_state.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/maximo_repository.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/photo_params.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:redux/redux.dart';

extension ContextUtils on BuildContext {
  Store<AppState> get store => StoreProvider.of<AppState>(this);

  AppState get appState => store.state;

  UserState get userState => store.state.userState;
}

List<ChecklistWo> filterUnchecked(List<ChecklistWo> input) {
  if (input.isEmpty) return input;

  final bool areLeafs = input.last.checklist.isEmpty;

  if (areLeafs) return input.where((e) => !(e.rsMasterpoint ?? false)).toList();

  return input.where((e) => !isChecked(e)).toList();
}

bool isChecked(ChecklistWo chl) {
  return filterUnchecked(chl.checklist).isEmpty;
}

int initialTab(UserModel? user) {
  if ((user?.isDutyEng ?? false) || (user?.isItr ?? false)) {
    return 2;
  }
  return 0;
}

String getInitialHomeRoute(UserModel? user) {
  final index = initialTab(user);
  switch (index) {
    case 0:
      return AppRoute.audit.route;
    case 1:
      return AppRoute.claims.route;
    case 2:
      return AppRoute.ppr.route;
    default:
      return AppRoute.profile.route;
  }
}

void attachPhoto(
  BuildContext context, {
  required String wonum,
  required CameraMode mode,
  required int? checklistwoid,
}) {
  context.push(AppRoute.camera.route,
      extra:
          PhotoParams(wonum: wonum, mode: mode, checklistwoid: checklistwoid));
}

Future<void> deletePhoto(BuildContext context,
    {int? id,
    String? wonum,
    required String path,
    required CameraMode mode}) async {
  if (id != null) {
    await deleteImagePath(path: path);
  } else if (wonum != null) {
    await deleteWtmImagePath(path: path);
  }
  final image = File(path);
  await image.delete();
  if (!context.mounted) return;
  switch (mode) {
    case CameraMode.checklist:
      context.store.dispatch(findAndUpdateWoInLevels(checklistwoid: id ?? -1));
      break;
    case CameraMode.ppr:
      context.store.dispatch(readSelectedPprFromDbAction(wonum ?? ''));
      break;
    case CameraMode.rz:
      context.store.dispatch(readSelectedRzFromDbAction(wonum ?? ''));
      break;
    case CameraMode.claim:
      context.store.dispatch(readSrListFromDbAction());
      break;
  }
}

void downloadAssets(BuildContext context) {
  final isConnected = context.store.state.isConnected;
  if (!isConnected) {
    infoDialog(context, message: Txt.internetNeededForDataLoading);
  } else {
    context.store.dispatch(downloadAssetsCatalogAction());
  }
}

Future<bool> sendComments(String wonum, String? href) async {
  final freshComments = await readFreshCommentsByWonum(wonum);

  int count = 0;
  for (final comment in freshComments) {
    final success = await sl<MaximoRepository>()
        .addCommentToWorkTaskMobile(href ?? '', comment);
    if (success) count++;
  }
  return freshComments.length == count;
}
