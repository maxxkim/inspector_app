import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/audit/view/audits_list.dart';
import 'package:inspector_tps/audit/view/no_audits_widget.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/unsupported_for_groups_widget.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class AuditsView extends StatelessWidget {
  const AuditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        distinct: true,
        onInit: (store) {
          if (store.state.userState.showAudits) {
            store.dispatch(readAuditsFromDbAction(downloadIfEmpty: true));
          }
        },
        builder: (context, vm) {
          print('show audits: ${vm.showAudits}');
          return vm.showAudits
              ? Scaffold(
                  appBar: AppBar(
                    title: Text(Txt.audits),
                    actions: [
                      PopupMenuButton<int>(
                        onSelected: (index) => handleClick(context, index),
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                              value: 0, child: Text(Txt.updateAuditsList)),
                        ],
                      ),
                    ],
                  ),
                  body: vm.showLoader
                      ? const Center(child: CircularProgressIndicator())
                      : vm.audits.isEmpty
                          ? const NoAuditsWidget()
                          : AuditsList(audits: vm.audits),
                )
              : const UnsupportedForGroupsWidget();
        });
  }

  void handleClick(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.store.dispatch(updateAuditsListAction());
        break;
      default:
        break;
    }
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  bool get showLoader => appState.showLoader;

  List<WorkTaskMobile> get audits => appState.auditsState.audits ?? [];

  bool get showAudits => appState.userState.showAudits;

  @override
  List<Object?> get props => [audits, showLoader];
}
