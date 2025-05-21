import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/claims/claims_tabs_switcher.dart';
import 'package:inspector_tps/claims/create_claim_dialog.dart';
import 'package:inspector_tps/claims/create_claim_view.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/claims/rz_view.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/core/widgets/round_count_widget.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class ClaimsView extends StatelessWidget {
  const ClaimsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        distinct: true,
        onInit: (store) {
          store.dispatch(readSrListAndAssetsFromDbAction());
        },
        // onDidChange: (_, vm) {
        //   if (!vm.showLoader && vm.assets.isEmpty) {
        //     downloadAssetsDialog(context);
        //   }
        // },
        builder: (context, vm) {
          final body = !vm.isDutyEng
              ? CreateClaimView(
                  localClaims: vm.localClaims,
                  sentClaims: vm.sentClaims,
                  user: vm.user,
                )
              : Column(
                  children: [
                    gap20,
                    const ClaimsTabsSwitcher(),
                    gap10,
                    if (vm.selectedTab == ClaimsTab.rzList)
                      const Expanded(child: RzView()),
                    if (vm.selectedTab == ClaimsTab.createClaim)
                      Expanded(
                        child: CreateClaimView(
                          localClaims: vm.localClaims,
                          sentClaims: vm.sentClaims,
                          user: vm.user,
                        ),
                      ),
                  ],
                );
          return Scaffold(
            backgroundColor: positive.withOpacity(0.05),
            appBar: AppBar(
              centerTitle: true,
              title: vm.isDutyEng
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        span40,
                        Text(
                          Txt.rzs,
                          style: const TextStyle(fontSize: 13),
                        ),
                        span10,
                        RoundCountWidget(count: vm.count),
                      ],
                    )
                  : Text(Txt.claims),
              actions: [
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (index) => _handleMenuClick(context, index, vm),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                        value: 5,
                        child: Text(
                          Txt.createNewClaim,
                        )),
                    PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          Txt.sendSavedClaims,
                        )),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          Txt.sendSavedRz,
                        )),
                    PopupMenuItem<int>(
                        value: 2,
                        child: Text(
                          Txt.renewAssets,
                        )),
                    if (vm.user.isCo)
                      PopupMenuItem<int>(
                          value: 6,
                          child: Text(
                            Txt.downloadSites,
                          )),
                    PopupMenuItem<int>(
                        value: 3,
                        child: Text(
                          Txt.clearRzList,
                          style: const TextStyle(color: Colors.red),
                        )),
                    PopupMenuItem<int>(
                        value: 4,
                        child: Text(
                          Txt.clearPreApprovedRz,
                          style: const TextStyle(),
                        )),
                  ],
                ),
              ],
            ),
            body: vm.showLoader
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
                    child: LoaderWithDescription(),
                  )
                : body,
          );
        });
  }

  void _handleMenuClick(BuildContext context, int index, _VM vm) {
    switch (index) {
      case 0:
        _processSavedClaims(context, vm.user);
        break;
      case 1:
        _processSavedRzs(context);
        break;
      case 2:
        downloadAssets(context);
        break;
      case 3:
        context.store.dispatch(deleteAllRzAction(vm.allRzWonums));
      case 4:
        context.store.dispatch(deletePreAcceptedRzAction());
      case 5:
        createClaimDialog(context, vm.user);
        break;
      case 6:
        context.store.dispatch(downloadSitesAction());
        break;
      default:
        break;
    }
  }

  void _processSavedClaims(BuildContext context, UserModel user) {
    final isConnected = context.store.state.isConnected;
    if (!isConnected) {
      infoDialog(context, message: Txt.internetNeededForDataSending);
    } else {
      sendAllSavedSr(context, user);
    }
  }

  void _processSavedRzs(BuildContext context) {
    final isConnected = context.store.state.isConnected;
    if (!isConnected) {
      infoDialog(context, message: Txt.internetNeededForDataSending);
    } else {
      context.store.dispatch(sendLocallyProcessedRzs());
    }
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  bool get showLoader => appState.showLoader;

  // WorkTaskMobile get selectedRz => appState.claimsState.selectedRz!;

  ClaimsTab get selectedTab => appState.claimsState.selectedTab;

  List<WorkTaskMobile> get rzList => appState.claimsState.rzList ?? [];

  List<String> get allRzWonums => rzList.map((rz) => rz.wonum ?? '').toList();

  int get count => rzList.length;

  List<Sr> get claims => appState.claimsState.srList ?? [];

  List<Sr> get localClaims => claims.where((sr) => sr.isLocal).toList();

  List<Sr> get sentClaims => claims.where((sr) => sr.sent).toList();

  bool get isDutyEng => appState.userState.user?.isDutyEng ?? false;

  List<Asset> get assets => appState.claimsState.assets;

  UserModel get user => appState.userState.user!;

  get imagesHash => localClaims
      .map((e) => e.images.fold('', (acc, e) => '$acc$e'))
      .fold('', (acc, e) => '$acc$e');

  @override
  List<Object?> get props => [
        showLoader,
        selectedTab,
        count,
        claims,
        assets,
        localClaims,
        imagesHash,
      ];
}
