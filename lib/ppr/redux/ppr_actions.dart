import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_state.dart';

sealed class PprAction {}

class SelectedPprAction extends PprAction {
  final WorkTaskMobile ppr;

  SelectedPprAction(this.ppr);
}

class SetPprAction extends PprAction {
  final List<WorkTaskMobile>? pprs;

  SetPprAction(this.pprs);
}

class SetPprFilterAction extends PprAction {
  final PprFilter filter;

  SetPprFilterAction(this.filter);
}

class SetPprTabAction extends PprAction {
  final PprTab tab;

  SetPprTabAction(this.tab);
}

class ClearPprStateAction extends PprAction {}
