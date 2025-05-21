import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/audit/redux/audits_state.dart';
import 'package:inspector_tps/audit/view/checklist/bread_crumbs_widget.dart';
import 'package:inspector_tps/audit/view/checklist/checklist_widget.dart';
import 'package:inspector_tps/audit/view/checklist/download_checklist_widget.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class ChecklistView extends StatelessWidget {
  const ChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
      distinct: true,
      converter: (store) => _VM(store.state),
      onInit: (store) {
        final wonum = store.state.auditsState.selectedAudit?.wonum;
        final href = store.state.auditsState.selectedAudit?.href;
        if (wonum != null) {
          store.dispatch(
              store.dispatch(readChecklistFromDbAction(wonum, href ?? '')));
        }
      },
      onDidChange: (_, vm) {
        if (vm.showSentAuditResultDialog) {
          sentChecklistsResultDialog(
            context,
            vm.audit!.wonum!,
          );
          context.store.dispatch(ShowSendingDialogAction(false));
        }
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.audit?.wonum ?? '',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  vm.audit?.description ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            leading: InkWell(
              onTap: () => _handleBack(context, vm),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    context.store
                        .dispatch(ShowUncheckedOnly(!vm.showUncheckedOnly));
                  },
                  icon: vm.showUncheckedOnly
                      ? const Icon(Icons.check_box)
                      : const Icon(Icons.check_box_outline_blank)),
              PopupMenuButton<int>(
                onSelected: (item) => _handleMenuClick(context, item, vm),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 0, child: Text(Txt.deleteAudit)),
                  PopupMenuItem(value: 1, child: Text(Txt.sendAuditToMaximo)),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'checklist',
            backgroundColor: primary,
            onPressed: () => _handleBack(context, vm),
            child: const Icon(Icons.arrow_back, size: 40),
          ),
          body: vm.showLoader
              ? const Center(child: CircularProgressIndicator())
              : (vm.hasChecklist)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BreadCrumbsWidget(
                            crumbs: vm.breadCrumbs,
                            tapCrumbCallback: _onCrumbTap,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                              child: ChecklistWidget(
                            checklist: vm.checklist,
                            isTechExploitation: vm.isTechExploitation,
                          )),
                        ],
                      ),
                    )
                  : DownloadChecklistWidget(href: vm.audit?.href ?? ''),
        );
      },
    );
  }

  void _handleBack(BuildContext context, _VM vm) {
    if (vm.navigateToAuditsList) {
      context.go(AppRoute.audit.route);
    }
    context.store.dispatch(PreviousAction());
    context.store.dispatch(BackCrumbAction());
  }

  void _handleMenuClick(BuildContext context, int index, _VM vm) {
    final audit = vm.audit!;
    switch (index) {
      case 0:
        deleteAuditDialog(context, audit);
        break;
      case 1:
        if (vm.isConnected) {
          context.store.dispatch(updateChecklistsInMaximo(wonum: audit.wonum!));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Txt.internetNeededForDataSending),
          ));
        }
        break;
      default:
        break;
    }
  }

  void _onCrumbTap(int index) {
    final size = appStore.state.auditsState.breadcrumbs.length;
    final stepsBack = size - index - 1;
    for (int i = 0; i < stepsBack; i++) {
      appStore.dispatch(PreviousAction());
      appStore.dispatch(BackCrumbAction());
    }
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  AuditsState get auditsState => appState.auditsState;

  WorkTaskMobile? get audit => auditsState.selectedAudit;

  bool get navigateToAuditsList => auditsState.checkListLevels.length < 2;

  List<List<ChecklistWo>> get levels => auditsState.checkListLevels;

  List<ChecklistWo> get _checklist => levels.isNotEmpty ? levels.last : [];

  List<ChecklistWo> get checklist =>
      showUncheckedOnly ? filterUnchecked(_checklist) : _checklist;

  bool get hasChecklist => _checklist.isNotEmpty;

  bool get showLoader => appState.showLoader;

  List<String> get breadCrumbs => appState.auditsState.breadcrumbs;

  bool get isTechExploitation => breadCrumbs.contains(Txt.tech);

  bool get showSentAuditResultDialog => auditsState.showSendingDialog;

  bool get isConnected => appState.isConnected;

  bool get showUncheckedOnly => auditsState.showUncheckedOnly;

  @override
  List<Object?> get props => [
        audit,
        _checklist,
        levels.hashCode,
        showSentAuditResultDialog,
        showLoader,
        isConnected,
        showUncheckedOnly,
      ];
}
