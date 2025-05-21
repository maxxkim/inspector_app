import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/audit/view/checklist/images_row.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/core/widgets/unsaved_icon_button.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/view/detailed/info_card.dart';

class InfoView extends StatefulWidget {
  const InfoView({super.key});

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  bool dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        onWillChange: (_, vm) {
          if (vm.shouldAddComment && !dialogShown) {
            dialogShown = true;
            _addComment(context, vm.selectedPpr);
          }
        },
        builder: (context, vm) {
          final bool assigned = vm.status == statusAssigned;
          if (vm.showLoader) {
            return const LoaderWithDescription();
          } else {
            return Expanded(
              child: Column(
                children: [
                  InfoCard(title: Txt.plannedJob, subTitle: vm.plannedJob),
                  gap10,
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                            title: Txt.statusCond,
                            subTitle: vm.statusDescription.toUpperCase(),
                            color: assigned ? positive : primary),
                      ),
                      if (assigned && !vm.selectedPpr.pprTakenInMaximo)
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: UnsavedIconButton(),
                        ),
                    ],
                  ),
                  gap10,
                  InfoCard(title: Txt.assetLocation, subTitle: vm.location),
                  gap10,
                  InfoCard(
                      title: Txt.assetDescription,
                      subTitle: vm.assetDescription),
                  gap10,
                  InfoCard(title: Txt.plannedStart, subTitle: vm.start),
                  gap10,
                  InfoCard(title: Txt.plannedFinish, subTitle: vm.finish),
                  gap10,
                  if (vm.showTakeInWork)
                    ElevatedButton(
                      onPressed: () {
                        context.store.dispatch(
                            takeInWorkPprAction(vm.selectedPpr.wonum!));
                      },
                      style: _buttonStyle(),
                      child: Text(Txt.takeInWork.toUpperCase()),
                    ),
                  if (vm.showSendForApprovalZde)
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.store.dispatch(sendForApprovalZdePprAction(
                                vm.selectedPpr.wonum!,
                                vm.selectedPpr.href,
                                vm.selectedPpr.doclinks?.href));
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const StadiumBorder(),
                              backgroundColor: primary),
                          child: Text(Txt.sendForApprovalZde),
                        ),
                        gap20,
                        ElevatedButton(
                          onPressed: () {
                            addPprCommentDialogWithAction(
                                context, vm.selectedPpr,
                                reportEquipmentFailure: true,
                                isPhotoComment: false);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const StadiumBorder(),
                              backgroundColor: accent),
                          child: Text(
                            Txt.reportEquipmentFailure,
                          ),
                        ),
                        gap10,
                        Text(Txt.registerToDescription,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  if (vm.showButtonsConfirmAndReject)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.store.dispatch(confirmPprAction(
                                vm.selectedPpr.wonum!,
                                vm.selectedPpr.href,
                                vm.selectedPpr.doclinks?.href));
                          },
                          style: _buttonStyle(),
                          child: Text(Txt.confirm),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addPprCommentDialogWithAction(
                                context, vm.selectedPpr,
                                reject: true, isPhotoComment: false);
                            // context.store.dispatch(cancelPprAction(
                            //     vm.selectedPpr.wonum!, vm.selectedPpr.href));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: accent),
                          child: Text(Txt.reject),
                        ),
                      ],
                    ),
                  if (vm.images.length < 6)
                    ElevatedButton(
                        onPressed: () {
                          dialogShown = false;
                          attachPhoto(context,
                              wonum: vm.selectedPpr.wonum!,
                              checklistwoid: null,
                              mode: CameraMode.ppr);
                        },
                        child: const Icon(Icons.camera_alt_outlined)),
                  gap10,
                  ImagesRow(
                    images: vm.images,
                    wonum: vm.selectedPpr.wonum,
                    mode: CameraMode.ppr,
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
        });
  }

  void _addComment(BuildContext context, WorkTaskMobile ppr) {
    addPprCommentDialogWithAction(context, ppr, isPhotoComment: true);
  }

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
      shape: const StadiumBorder(), backgroundColor: primary);
}

class _VM extends Equatable {
  _VM(this.appState);

  final AppState appState;

  WorkTaskMobile get selectedPpr => appState.pprState.selectedPpr!;

  bool get showTakeInWork =>
      (status == statusApproved || status == statusRejected) &&
      (appState.userState.user?.isDutyEng ?? false);

  bool get showSendForApprovalZde =>
      status == statusCompleted && (appState.userState.user?.isItr ?? false);

  bool get showButtonsConfirmAndReject =>
      status == statusPreApproved &&
      (appState.userState.user?.isFilManager ?? false);

  String get status => selectedPpr.status ?? '';

  String get statusDescription => selectedPpr.statusDescription ?? '';

  String get start => dateTimeFromIso(selectedPpr.targstartdate ?? '');

  String get finish => dateTimeFromIso(selectedPpr.targcompdate ?? '');

  bool get showLoader => appState.showLoader;

  List<String> get images => selectedPpr.images;

  String get plannedJob => '${selectedPpr.wonum} \u2022 '
      '${selectedPpr.worktype} \u2022 '
      '${selectedPpr.description?.replaceFirst('ТО', '')}';

  String get assetDescription => selectedPpr.asset?.description ?? '';

  String get location => '${(selectedPpr.location?.description ?? '')} \u2022 '
      '${(selectedPpr.location?.olddescription ?? '')}';

  List<Worklog> get comments => selectedPpr.worklog ?? [];

  List<Worklog> get downloadedComments =>
      comments.where((c) => !c.fresh).toList();

  List<Worklog> get freshComments => comments.where((c) => c.fresh).toList();

  PprTab get selectedTab => appState.pprState.selectedTab;

  bool get shouldAddComment =>
      images.isNotEmpty &&
      freshComments.isEmpty &&
      (selectedTab == PprTab.info);

  @override
  List<Object?> get props =>
      [appState, showLoader, status, images, comments, selectedTab];
}
