import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/utils.dart';
import 'package:inspector_tps/ppr/view/detailed/job_card.dart';

class OperationsView extends StatelessWidget {
  const OperationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        builder: (context, vm) {
          // if (vm.selectedPpr.status == statusCompleted) {
          //   return const PprCompletedWidget();
          // }
          final listSize = vm.jobs.length + 1;
          return vm.showLoader
              ? const LoaderWithDescription()
              : Expanded(
                  child: ListView.builder(
                      itemCount: listSize,
                      itemBuilder: (context, index) {
                        if (index == listSize - 1) {
                          return vm.selectedPpr.status == statusAssigned
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: vm.completed
                                            ? null
                                            : () {
                                                context.store.dispatch(
                                                    completePprJobsAction(
                                                        wonum: vm.selectedPpr
                                                            .wonum!));
                                              },
                                        style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor: vm.completed
                                                ? grayMiddle
                                                : accent),
                                        child: Text(
                                          Txt.allOperationsCompleted
                                              .toUpperCase(),
                                          style: _buttonTxtStyle,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: vm.completed
                                            ? () {
                                                if (!context
                                                    .store.state.isConnected) {
                                                  infoDialog(context,
                                                      message: Txt.offline);
                                                } else {
                                                  context.store.dispatch(
                                                      completePprsByDutyEngAction(
                                                    [vm.selectedPpr],
                                                  ));
                                                }
                                              }
                                            : () {
                                                infoDialog(context,
                                                    message: Txt
                                                        .completePprDescription);
                                              },
                                        style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor: vm.completed
                                                ? accent
                                                : grayMiddle),
                                        child: Text(Txt.finish.toUpperCase(),
                                            style: _buttonTxtStyle),
                                      ),
                                    ],
                                  ))
                              : const SizedBox.shrink();
                        }
                        final job = vm.jobs[index];
                        return JobCard(job: job);
                      }),
                );
        });
  }
}

const _buttonTxtStyle = TextStyle(fontSize: 12);

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  WorkTaskMobile get selectedPpr => appState.pprState.selectedPpr!;

  List<Woactivity> get jobs => selectedPpr.woactivity ?? [];

  bool get showLoader => appState.showLoader;

  bool get completed => isPprReady(selectedPpr);

  @override
  List<Object?> get props => [jobs, showLoader];
}
