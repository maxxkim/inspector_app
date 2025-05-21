import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

@immutable
class AuditsState {
  final List<WorkTaskMobile>? audits;
  final WorkTaskMobile? selectedAudit;
  final List<List<ChecklistWo>> checkListLevels;
  final List<String> breadcrumbs;
  final int sendingAuditCount;
  final bool showSendingDialog;
  final int totalToUploading;
  final bool showUncheckedOnly;

  const AuditsState._({
    this.selectedAudit,
    this.audits,
    required this.checkListLevels,
    required this.breadcrumbs,
    required this.showSendingDialog,
    required this.sendingAuditCount,
    required this.totalToUploading,
    required this.showUncheckedOnly,
  });

  factory AuditsState.initial() => const AuditsState._(
        checkListLevels: [],
        breadcrumbs: [],
        sendingAuditCount: -1,
        totalToUploading: 0,
        showSendingDialog: false,
        showUncheckedOnly: false,
      );

  AuditsState copyWith({
    List<WorkTaskMobile>? audits,
    WorkTaskMobile? selectedAudit,
    List<List<ChecklistWo>>? checkListLevels,
    List<String>? breadcrumbs,
    bool? isTechExploitation,
    bool? showSendingDialog,
    int? sendingAuditCount,
    int? totalToUploading,
    bool? showUncheckedOnly,
  }) {
    return AuditsState._(
      audits: audits ?? this.audits,
      selectedAudit: selectedAudit ?? this.selectedAudit,
      checkListLevels: checkListLevels ?? this.checkListLevels,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      showSendingDialog: showSendingDialog ?? this.showSendingDialog,
      sendingAuditCount: sendingAuditCount ?? this.sendingAuditCount,
      totalToUploading: totalToUploading ?? this.totalToUploading,
      showUncheckedOnly: showUncheckedOnly ?? this.showUncheckedOnly,
    );
  }
}
