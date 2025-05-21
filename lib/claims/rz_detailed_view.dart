import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/claims/redux/claims_actions.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/claims/rz_comments_view.dart';
import 'package:inspector_tps/claims/rz_info_view.dart';
import 'package:inspector_tps/claims/rz_tabs_switcher.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class RzDetailedView extends StatelessWidget {
  const RzDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        builder: (context, vm) {
          return Scaffold(
            backgroundColor: positive.withOpacity(0.05),
            appBar: AppBar(
              title: Text('${Txt.rz}: ${vm.selectedRz.wonum ?? ''}'),
              leading: InkWell(
                onTap: () => _handleBack(context, vm),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              actions: [
                if (vm.images.length < 7)
                  IconButton(
                      onPressed: () {
                        attachPhoto(context,
                            checklistwoid: null,
                            wonum: vm.selectedRz.wonum!,
                            mode: CameraMode.rz);
                      },
                      icon: const Icon(Icons.camera_alt_outlined)),
              ],
            ),
            body: vm.showLoader
                ? const Column(
                    children: [
                      Spacer(),
                      LoaderWithDescription(),
                      Spacer(),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gap10,
                        const RzTabsSwitcher(),
                        gap10,
                        if (vm.selectedTab == RzTab.info) const RzInfoView(),
                        if (vm.selectedTab == RzTab.comments)
                          const RzCommentsView(),
                      ],
                    ),
                  ),
          );
        });
  }

  void _handleBack(BuildContext context, _VM vm) {
    context.store.dispatch(ClearSelectedAssetAction());
    context.go(AppRoute.claims.route);
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  RzTab get selectedTab => appState.claimsState.selectedRzTab;

  WorkTaskMobile get selectedRz => appState.claimsState.selectedRz!;

  bool get showLoader => appState.showLoader;

  bool get isConnected => appState.isConnected;

  List<String> get images => selectedRz.images;

  @override
  List<Object?> get props => [
        showLoader,
        selectedTab,
        isConnected,
        selectedRz,
      ];
}
