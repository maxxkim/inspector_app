import 'package:inspector_tps/claims/redux/claims_actions.dart';
import 'package:inspector_tps/claims/redux/claims_state.dart';

ClaimsState claimsReducer(ClaimsState state, dynamic action) {
  if (action is SetRzListAction) {
    return state.copyWith(rzList: action.rzList);
  } else if (action is SelectedRzAction) {
    return state.copyWith(selectedRz: action.rz);
  } else if (action is ClearClaimsStateAction) {
    return ClaimsState.initial();
  } else if (action is SetRzFilterAction) {
    return state.copyWith(rzFilter: action.filter);
  } else if (action is SetSrListAction) {
    return state.copyWith(srList: action.srList);
  } else if (action is SetClaimsTabAction) {
    return state.copyWith(selectedTab: action.tab);
  } else if (action is SetRzTabAction) {
    return state.copyWith(selectedRzTab: action.tab);
  } else if (action is SetAssetsAction) {
    return state.copyWith(assets: action.assets);
  } else if (action is PickedSiteAction) {
    return state.copyWith(pickedSite: action.site);
  } else if (action is ClearSelectedAssetAction) {
    return state.copyWith(clearSelectedAsset: true);
  }
  return state;
}
