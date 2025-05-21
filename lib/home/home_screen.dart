import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/connection_indicator.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  bool initialTabSet = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM.fromState(store.state),
        distinct: true,
        onDidChange: (_, vm) {
          if (vm.hasError) {
            context.go(AppRoute.error.route);
          }
        },
        builder: (context, vm) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!initialTabSet && vm.user != null) {
              initialTabSet = true;
              _switchTab(context, initialTab(vm.user), vm.hiddenTabs);
            }
          });
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    widget.navigationShell,
                    const Positioned(
                        top: 20, left: 16, child: ConnectionIndicator()),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: primary,
              unselectedItemColor: primary.withOpacity(0.5),
              showUnselectedLabels: true,
              currentIndex: vm.tabIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(vm.hiddenTabs.contains(0)
                      ? Icons.lock
                      : Icons.work_history_sharp),
                  label: Txt.tabAudit,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.library_books),
                  label: Txt.tabClaims,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.account_tree),
                  label: Txt.tabTo,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_sharp),
                  label: Txt.tabProfile,
                ),
              ],
              onTap: (index) {
                _switchTab(context, index, vm.hiddenTabs);
              },
            ),
          );
        });
  }

  void _switchTab(BuildContext context, int index, List<int> hiddenTabs) {
    if (hiddenTabs.contains(index)) return;
    context.store.dispatch(TabIndexAction(index));
    widget.navigationShell.goBranch(
      index,
    );
  }
}

class _VM extends Equatable {
  final int tabIndex;
  final bool hasError;
  final UserModel? user;

  _VM.fromState(AppState state)
      : hasError = state.hasError,
        tabIndex = state.tabIndex,
        user = state.userState.user;

  List<int> get hiddenTabs => user?.hiddenTabs() ?? [];

  @override
  List<Object?> get props => [tabIndex, hasError, user];
}
