import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/view/detailed/comments_view.dart';
import 'package:inspector_tps/ppr/view/detailed/info_view.dart';
import 'package:inspector_tps/ppr/view/detailed/operations_view.dart';
import 'package:inspector_tps/ppr/view/detailed/tabs_switcher.dart';

class PprDetailedView extends StatelessWidget {
  const PprDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        // distinct: true,
        builder: (context, vm) {
          return Scaffold(
            backgroundColor: bg,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => _handleBack(context, vm),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   vm.audit?.wonum ?? '',
                  //   style: const TextStyle(
                  //       fontSize: 12, fontWeight: FontWeight.bold),
                  // ),
                  Text(
                    vm.selectedPpr.description ?? '',
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              actions: [
                if (vm.isConnected)
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (index) =>
                        _handleMenuClick(context, index, vm.selectedPpr),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          value: 0,
                          child: Text(
                            Txt.sendChanges,
                          )),
                    ],
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  gap20,
                  const TabsSwitcher(),
                  gap20,
                  if (vm.selectedTab == PprTab.info) const InfoView(),
                  if (vm.selectedTab == PprTab.operations)
                    const OperationsView(),
                  if (vm.selectedTab == PprTab.comments) const CommentsView(),
                ],
              ),
            ),
            // floatingActionButton: vm.selectedTab == PprTab.operations
            //     ? null
            //     : FloatingActionButton(
            //         heroTag: 'ppr-detailed',
            //         backgroundColor: primary,
            //         onPressed: () => _handleBack(context, vm),
            //         child: const Icon(Icons.arrow_back, size: 40),
            //       ),
          );
        });
  }

  void _handleMenuClick(BuildContext context, int index, WorkTaskMobile ppr) {
    switch (index) {
      case 0:
        context.store.dispatch(
          sendCommentToMaximoAction(
              ppr.wonum ?? '', ppr.href, ppr.doclinks?.href,
              isPpr: true),
        );
        break;
      default:
        break;
    }
  }

  void _handleBack(BuildContext context, _VM vm) {
    context.go(AppRoute.ppr.route);
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  bool get showLoader => appState.showLoader;

  WorkTaskMobile get selectedPpr => appState.pprState.selectedPpr!;

  PprTab get selectedTab => appState.pprState.selectedTab;

  bool get isConnected => appState.isConnected;

  @override
  List<Object?> get props => [
        showLoader,
        selectedTab,
        selectedPpr,
        isConnected,
      ];
}
