import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/ppr/redux/ppr_actions.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';

class TabsSwitcher extends StatelessWidget {
  const TabsSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (MediaQuery.of(context).size.width - 32 - 20) / 3;
    return StoreConnector<AppState, PprTab>(
        converter: (store) => store.state.pprState.selectedTab,
        builder: (context, tab) {
          return ToggleButtons(
            onPressed: (int index) {
              context.store.dispatch(SetPprTabAction(_tabs[index]));
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
              tab == PprTab.info,
              tab == PprTab.operations,
              tab == PprTab.comments,
            ],
            children: [
              _getTabWidget(0, buttonWidth, tab),
              _getTabWidget(1, buttonWidth, tab),
              _getTabWidget(2, buttonWidth, tab),
            ],
          );
        });
  }
}

const _tabs = PprTab.values;

Widget _getTabWidget(
  int index,
  double width,
  PprTab selectedTab,
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
