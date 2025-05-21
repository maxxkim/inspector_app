import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/claims/redux/claims_actions.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';

class ClaimsTabsSwitcher extends StatelessWidget {
  const ClaimsTabsSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (MediaQuery.of(context).size.width - 32 - 20) / 2;
    return StoreConnector<AppState, ClaimsTab>(
        converter: (store) => store.state.claimsState.selectedTab,
        builder: (context, tab) {
          return ToggleButtons(
            onPressed: (int index) {
              context.store.dispatch(SetClaimsTabAction(_tabs[index]));
            },
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderWidth: 5,
            borderColor: grayMiddle,
            selectedColor: primary,
            color: primary,
            constraints: BoxConstraints(
              minHeight: 30.0,
              minWidth: buttonWidth,
            ),
            isSelected: [
              tab == ClaimsTab.rzList,
              tab == ClaimsTab.createClaim,
            ],
            children: [
              _getTabWidget(0, buttonWidth, tab),
              _getTabWidget(1, buttonWidth, tab),
            ],
          );
        });
  }
}

const _tabs = ClaimsTab.values;

Widget _getTabWidget(
  int index,
  double width,
  ClaimsTab selectedTab,
) {
  final tab = _tabs[index];
  final bool isSelected = tab == selectedTab;
  return Container(
      height: 30,
      width: width,
      color: isSelected ? Colors.white : grayMiddle,
      child: Center(
        child: Text(
          tab.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ));
}
