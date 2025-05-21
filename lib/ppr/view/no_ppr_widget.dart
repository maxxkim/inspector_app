import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';

class NoPprWidget extends StatelessWidget {
  const NoPprWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        builder: (context, vm) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(vm.shouldDownload ? Txt.noPpr : Txt.noPprForShift,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25)),
                const SizedBox(height: 150),
                if (vm.shouldDownload)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      onPressed: () {
                        context.store
                            .dispatch(downloadPprAction(date: monthAgoIso(monthsCount: 6)));
                      },
                      child: Text(Txt.downloadPprMonth)),
                const Spacer(),
              ],
            ),
          );
        });
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  List<WorkTaskMobile> get pprs => appState.pprState.pprs ?? [];

  PprFilter get filter => appState.pprState.filter;

  bool get shouldDownload => pprs.isEmpty && filter == PprFilter.all;

  @override
  List<Object?> get props => [pprs, filter];
}
