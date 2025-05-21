import 'package:flutter/foundation.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

enum PprFilter {
  shift,
  outdated,
  completed,
  all,
}

enum PprTab {
  info(0, 'ИНФО'),
  operations(1, 'ОПЕРАЦИИ'),
  comments(2, 'КОММЕНТАРИИ');

  const PprTab(this.i, this.value);

  final String value;
  final int i;
}

@immutable
class PprState {
  final List<WorkTaskMobile>? pprs;
  final WorkTaskMobile? selectedPpr;
  final PprFilter filter;
  final PprTab selectedTab;

  const PprState._({
    this.pprs,
    this.selectedPpr,
    this.selectedTab = PprTab.info,
    this.filter = PprFilter.all,
  });

  factory PprState.initial() => const PprState._();

  PprState copyWith({
    List<WorkTaskMobile>? pprs,
    WorkTaskMobile? selectedPpr,
    PprFilter? filter,
    PprTab? selectedTab,
  }) {
    return PprState._(
      pprs: pprs ?? this.pprs,
      selectedPpr: selectedPpr ?? this.selectedPpr,
      filter: filter ?? this.filter,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
