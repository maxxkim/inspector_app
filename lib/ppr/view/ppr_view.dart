import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/core/widgets/round_count_widget.dart';
import 'package:inspector_tps/core/widgets/unsupported_for_groups_widget.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_actions.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/view/no_ppr_widget.dart';
import 'package:inspector_tps/ppr/view/pprs_list.dart';

import '../../core/redux/app_state.dart';

class PprView extends StatelessWidget {
  const PprView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        distinct: true,
        onInit: (store) {
          if (store.state.userState.showPpr) {
            store.dispatch(readPprsFromDbAction(downloadIfEmpty: true));
          }
        },
        builder: (context, vm) {
          return vm.showPpr
              ? Scaffold(
                  backgroundColor: bg,
                  appBar: AppBar(
                    leading: PopupMenuButton<int>(
                      icon: const Icon(Icons.filter_list),
                      onSelected: (index) => handleFilterClick(context, index),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0,
                            enabled: vm.filter != PprFilter.shift,
                            child: Text(
                              Txt.currentShift,
                            )),
                        PopupMenuItem<int>(
                            value: 1,
                            enabled: vm.filter != PprFilter.outdated,
                            child: Text(
                              Txt.outdated,
                              style: const TextStyle(),
                            )),
                        PopupMenuItem<int>(
                            value: 2,
                            enabled: vm.filter != PprFilter.all,
                            child: Text(
                              Txt.allPpr,
                              style: const TextStyle(),
                            )),
                        PopupMenuItem<int>(
                            value: 3,
                            enabled: vm.filter != PprFilter.completed,
                            child: Text(
                              Txt.completedPpr,
                              style: const TextStyle(),
                            )),
                        PopupMenuItem<int>(
                            value: 100,
                            child: Text(
                              Txt.cancel,
                              style: const TextStyle(),
                            )),
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(vm.filterName,
                            style: const TextStyle(fontSize: 15)),
                        span10,
                        RoundCountWidget(count: vm.count),
                      ],
                    ),
                    actions: [
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (index) => _handleMenuClick(context, index, vm),
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                              value: 0,
                              child: Text(
                                Txt.clearPprList,
                                style: const TextStyle(color: Colors.red),
                              )),
                          PopupMenuItem<int>(
                              value: 1,
                              child: Text(
                                Txt.clearCompletedPpr,
                                style: const TextStyle(),
                              )),
                          PopupMenuItem<int>(
                              value: 2,
                              child: Text(
                                Txt.sendReadyPpr,
                                style: const TextStyle(),
                              )),
                          PopupMenuItem<int>(
                              value: 100,
                              child: Text(
                                Txt.closeMenu,
                                style: const TextStyle(),
                              )),
                        ],
                      ),
                    ],
                  ),
                  body: vm.showLoader
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 16),
                          child: LoaderWithDescription(),
                        )
                      : vm.pprs.isEmpty
                          ? const NoPprWidget()
                          : PprsList(pprs: vm.pprs))
              : const UnsupportedForGroupsWidget();
        });
  }

  void _handleMenuClick(BuildContext context, int index, _VM vm) {
    switch (index) {
      case 0:
        context.store.dispatch(deleteAllPprAction(vm.allPprWonums));
        break;
      case 1:
        context.store.dispatch(deleteCompletedPprAction());
        break;
      case 2:
        // empty -  all ready will be sent
        context.store.dispatch(completePprsByDutyEngAction([]));
        break;
      default:
        break;
    }
  }

  void handleFilterClick(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.store.dispatch(SetPprFilterAction(PprFilter.shift));
        context.store.dispatch(readPprsFromDbAction());
        break;
      case 1:
        context.store.dispatch(SetPprFilterAction(PprFilter.outdated));
        context.store.dispatch(readPprsFromDbAction());
        break;
      case 2:
        context.store.dispatch(SetPprFilterAction(PprFilter.all));
        context.store.dispatch(readPprsFromDbAction());
        break;
      case 3:
        context.store.dispatch(SetPprFilterAction(PprFilter.completed));
        context.store.dispatch(readPprsFromDbAction());
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

  List<WorkTaskMobile> get pprs => appState.pprState.pprs ?? [];

  bool get showPpr => appState.userState.showPpr;

  int get count => pprs.length;

  PprFilter get filter => appState.pprState.filter;

  List<String> get allPprWonums => pprs.map((ppr) => ppr.wonum ?? '').toList();

  String get filterName => switch (filter) {
        PprFilter.all => Txt.allPpr,
        PprFilter.shift => Txt.currentShift,
        PprFilter.outdated => Txt.outdated,
        PprFilter.completed => Txt.completedPpr,
      };

  @override
  List<Object?> get props => [pprs, showLoader, filter];
}
