import 'package:inspector_tps/ppr/redux/ppr_actions.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';

PprState pprReducer(PprState state, dynamic action) {
  if (action is SetPprAction) {
    return state.copyWith(pprs: action.pprs);
  } else if (action is SelectedPprAction) {
    return state.copyWith(selectedPpr: action.ppr);
  } else if (action is ClearPprStateAction) {
    return PprState.initial();
  } else if (action is SetPprFilterAction) {
    return state.copyWith(filter: action.filter);
  } else if (action is SetPprTabAction) {
    return state.copyWith(selectedTab: action.tab);
  }
  return state;
}
