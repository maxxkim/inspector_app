import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/claims/no_rz_widget.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/claims/rz_list.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class RzView extends StatelessWidget {
  const RzView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        distinct: true,
        onInit: (store) {
          if (store.state.claimsState.rzList?.isEmpty ?? true) {
            store.dispatch(readRzListFromDbAction());
          }
        },
        builder: (context, vm) {
          // return NoRzWidget();
          return vm.showLoader
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
                  child: LoaderWithDescription(),
                )
              : vm.rzList.isEmpty
                  ? const NoRzWidget()
                  : RzList(rzList: vm.rzList);
        });
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  bool get showLoader => appState.showLoader;

  List<WorkTaskMobile> get rzList => appState.claimsState.rzList ?? [];

  bool get showRz => appState.userState.showRz;

  int get count => rzList.length;

  RzFilter get filter => appState.claimsState.rzFilter;

  String get filterName => switch (filter) {
        RzFilter.all => Txt.rzList,
      };

  @override
  List<Object?> get props => [rzList, showLoader, filter];
}
