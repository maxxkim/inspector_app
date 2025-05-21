// Base Action
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

sealed class AuditsAction {}

class SelectedAuditAction extends AuditsAction {
  final WorkTaskMobile audit;

  SelectedAuditAction(this.audit);
}

class SetAuditsAction extends AuditsAction {
  final List<WorkTaskMobile>? audits;

  SetAuditsAction(this.audits);
}

class ReadChecklistAction extends AuditsAction {
  final List<ChecklistWo> checklist;

  ReadChecklistAction(this.checklist);
}

class NextAction extends AuditsAction {
  final List<ChecklistWo> checklist;

  NextAction({required this.checklist});
}

class PreviousAction extends AuditsAction {}

class CrumbAction extends AuditsAction {
  final String crumb;

  CrumbAction({required this.crumb});
}

class BackCrumbAction extends AuditsAction {}

class UpdateLastLevelAction extends AuditsAction {
  final List<ChecklistWo> last;

  UpdateLastLevelAction(this.last);
}

class UpdateLevelsAction extends AuditsAction {
  UpdateLevelsAction(this.levels);

  final List<List<ChecklistWo>> levels;
}

// Action to add an audit to the list
class AddAuditAction extends AuditsAction {
  final WorkTaskMobile audit;

  AddAuditAction(this.audit);
}

// Action to remove an audit from the list
class RemoveAuditAction extends AuditsAction {
  final WorkTaskMobile audit;

  RemoveAuditAction(this.audit);
}

class TotalToUploadingAction extends AuditsAction {
  final int? total;

  TotalToUploadingAction(this.total);
}

class SendingAuditCountAction extends AuditsAction {
  final int? count;

  SendingAuditCountAction(this.count);
}

class ShowSendingDialogAction extends AuditsAction {
  final bool show;

  ShowSendingDialogAction(this.show);
}

class ClearAuditsStateAction extends AuditsAction {}

class ShowUncheckedOnly extends AuditsAction {
  final bool uncheckedOnly;

  ShowUncheckedOnly(this.uncheckedOnly);
}
