import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/view/checklist/images_row.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/core/widgets/unsaved_icon_button.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/view/detailed/info_card.dart';

class RzInfoView extends StatelessWidget {
  const RzInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        builder: (context, vm) {
          final bool assigned = vm.status == statusAssigned;
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gap10,
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                            title: Txt.statusCond,
                            subTitle: vm.statusDescription,
                            color: assigned ? positive : primary),
                      ),
                      span20,
                      if (vm.savedOffline) const UnsavedIconButton(),
                    ],
                  ),
                  gap10,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        span10,
                        Expanded(
                          child: Text(vm.selectedRz.displayName ??
                              vm.selectedRz.owner ??
                              ''),
                        ),
                      ],
                    ),
                  ),
                  gap10,
                  InfoCard(
                      title: Txt.fromWho,
                      subTitle: vm.fromWho,
                      color: assigned ? positive : primary),
                  gap10,
                  InfoCard(
                      title: Txt.priority,
                      subTitle: vm.priority,
                      color: assigned ? positive : primary),
                  gap10,
                  Row(
                    children: [
                      Expanded(
                          child: InfoCard(
                              title: Txt.claimFrom, subTitle: vm.reportDate)),
                      span5,
                      Expanded(
                          child: InfoCard(
                              title: Txt.finishUntil, subTitle: vm.finish)),
                    ],
                  ),
                  gap10,
                  InfoCard(
                      title: Txt.systemCategory,
                      subTitle: vm.systemCategory,
                      color: assigned ? positive : primary),
                  gap10,
                  Text(
                    Txt.claim,
                  ),
                  Text(
                    vm.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: accent),
                    textAlign: TextAlign.left,
                  ),
                  gap10,
                  if (vm.savedAsset != null) ...[
                    Text(Txt.asset),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vm.savedAsset.toString(),
                            style: const TextStyle(
                                color: positive,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary, // background
                          ),
                          onPressed: () {
                            context.go(AppRoute.pickAssetRoute.route);
                          },
                          icon: const Icon(Icons.sync, color: primary),
                        ),
                      ],
                    ),
                  ],
                  gap10,
                  if (vm.showRzSolvedButtons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                context.store.dispatch(rzProblemSolvedAction(
                                  vm.selectedRz,
                                  vm.selectedRz.href,
                                  vm.selectedRz.doclinks?.href,
                                  solved: false,
                                  assetnum: vm.selectedRz.assetnum!,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: accent),
                              child: Text(Txt.unSolved)),
                        ),
                        span20,
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                context.store.dispatch(rzProblemSolvedAction(
                                    vm.selectedRz,
                                    vm.selectedRz.href,
                                    vm.selectedRz.doclinks?.href,
                                    solved: true,
                                    assetnum: vm.selectedRz.assetnum!));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: positive),
                              child: Text(Txt.solved)),
                        ),
                      ],
                    ),
                  if (vm.showAddCommentsButton)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent, // background
                            ),
                            onPressed: () {
                              _addComment(context, vm.selectedRz);
                            },
                            child: Text(Txt.shouldAddCommentButton),
                          ),
                        ),
                      ],
                    ),
                  if (vm.showPickAssetButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary, // background
                          ),
                          onPressed: () {
                            context.go(AppRoute.pickAssetRoute.route);
                          },
                          child: Text(Txt.pickAsset),
                        ),
                      ],
                    ),
                  gap10,
                  ImagesRow(
                    images: vm.images,
                    wonum: vm.selectedRz.wonum,
                    mode: CameraMode.rz,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _addComment(BuildContext context, WorkTaskMobile ppr) {
    addRzCommentDialog(context, ppr);
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  WorkTaskMobile get selectedRz => appState.claimsState.selectedRz!;

  String get status => selectedRz.status ?? '';

  String get fromWho => selectedRz.fromwho ?? '';

  String get statusDescription => selectedRz.statusDescription ?? '';

  bool get savedOffline => selectedRz.offlineScript != null;

  String get priority => selectedRz.priority ?? '';

  String get systemCategory => selectedRz.ticketdesc ?? '';

  String get finish => dateTimeFromIso(selectedRz.targcompdate ?? '');

  String get reportDate => dateFromIso(selectedRz.reportDate ?? '');

  String get description => selectedRz.description ?? '';

  Asset? get savedAsset => selectedRz.asset;

  List<String> get images => selectedRz.images;

  bool get showPickAssetButton =>
      savedAsset == null && selectedRz.status == statusAssigned;

  bool get showAddCommentsButton =>
      savedAsset != null &&
      selectedRz.status == statusAssigned &&
      !hasFreshComments;

  bool get showRzSolvedButtons =>
      savedAsset != null &&
      selectedRz.status == statusAssigned &&
      hasFreshComments;

  bool get hasFreshComments =>
      (selectedRz.worklog ?? []).where((c) => c.fresh).toList().isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        selectedRz,
        savedAsset,
        hasFreshComments,
      ];
}
