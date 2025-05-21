import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class NoRzWidget extends StatelessWidget {
  const NoRzWidget({super.key});

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
                Text(vm.shouldDownload ? Txt.noRz : Txt.noRzForShift,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25)),
                const SizedBox(height: 150),
                if (vm.shouldDownload)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      onPressed: () {
                        context.store
                            .dispatch(downloadRzListAction());
                      },
                      child: Text(Txt.downloadRz)),
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

  List<WorkTaskMobile> get rzList => appState.claimsState.rzList ?? [];

  RzFilter get filter => appState.claimsState.rzFilter;

  bool get shouldDownload => rzList.isEmpty && filter == RzFilter.all;

  @override
  List<Object?> get props => [rzList, filter];
}
