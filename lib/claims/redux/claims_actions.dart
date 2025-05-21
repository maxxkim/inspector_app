import 'package:inspector_tps/claims/redux/claims_state.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

sealed class ClaimsAction {}

class SelectedRzAction extends ClaimsAction {
  final WorkTaskMobile rz;

  SelectedRzAction(this.rz);
}

class SetRzListAction extends ClaimsAction {
  final List<WorkTaskMobile>? rzList;

  SetRzListAction(this.rzList);
}

class SetAssetsAction extends ClaimsAction {
  final List<Asset>? assets;

  SetAssetsAction(this.assets);
}

class SetRzFilterAction extends ClaimsAction {
  final RzFilter filter;

  SetRzFilterAction(this.filter);
}

// sr

class SetSrListAction extends ClaimsAction {
  final List<Sr>? srList;

  SetSrListAction(this.srList);
}

class SetClaimsTabAction extends ClaimsAction {
  final ClaimsTab tab;

  SetClaimsTabAction(this.tab);
}

class PickedSiteAction extends ClaimsAction {
  final String site;

  PickedSiteAction(this.site);
}

class SetRzTabAction extends ClaimsAction {
  final RzTab tab;

  SetRzTabAction(this.tab);
}

class ClearSelectedAssetAction extends ClaimsAction {}

class ClearClaimsStateAction extends ClaimsAction {}
