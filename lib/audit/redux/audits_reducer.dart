import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/audit/redux/audits_state.dart';

AuditsState auditsReducer(AuditsState state, dynamic action) {
  if (action is SetAuditsAction) {
    return state.copyWith(audits: action.audits);
  } else if (action is SelectedAuditAction) {
    return state.copyWith(selectedAudit: action.audit);
  } else if (action is ReadChecklistAction) {
    return state.copyWith(checkListLevels: [action.checklist]);
  } else if (action is NextAction) {
    final next = [...state.checkListLevels];
    next.add(action.checklist);
    return state.copyWith(checkListLevels: next);
  } else if (action is PreviousAction) {
    final previous = [...state.checkListLevels];
    if (previous.isNotEmpty) {
      previous.removeLast();
      return state.copyWith(checkListLevels: previous);
    }
  } else if (action is UpdateLastLevelAction) {
    final levels = [...state.checkListLevels];
    levels.removeLast();
    levels.add(action.last);
    return state.copyWith(checkListLevels: levels);
  } else if (action is UpdateLevelsAction) {
    return state.copyWith(checkListLevels: action.levels);
  } else if (action is CrumbAction) {
    final crumbs = [...state.breadcrumbs];
    crumbs.add(action.crumb);
    return state.copyWith(breadcrumbs: crumbs);
  } else if (action is BackCrumbAction) {
    final previous = [...state.breadcrumbs];
    if (previous.isNotEmpty) {
      previous.removeLast();
      return state.copyWith(breadcrumbs: previous);
    }
  } else if (action is SendingAuditCountAction) {
    return state.copyWith(sendingAuditCount: action.count);
  } else if (action is ShowSendingDialogAction) {
    return state.copyWith(showSendingDialog: action.show);
  } else if (action is TotalToUploadingAction) {
    return state.copyWith(totalToUploading: action.total);
  } else if (action is ClearAuditsStateAction) {
    return AuditsState.initial();
  } else if (action is ShowUncheckedOnly) {
    return state.copyWith(showUncheckedOnly: action.uncheckedOnly);
  }
  return state;
}
