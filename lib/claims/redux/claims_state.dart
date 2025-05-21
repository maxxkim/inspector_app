import 'package:flutter/foundation.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

enum RzFilter {
  all,
}

enum ClaimsTab {
  rzList(0, 'СПИСОК РЗ'),
  createClaim(1, 'СОЗДАТЬ ЗАЯВКУ');

  const ClaimsTab(this.i, this.value);

  final String value;
  final int i;
}

enum RzTab {
  info(0, 'Информация'),
  comments(1, 'Комментарии');

  const RzTab(this.i, this.value);

  final String value;
  final int i;
}

@immutable
class ClaimsState {
  final List<WorkTaskMobile>? rzList;
  final WorkTaskMobile? selectedRz;
  final RzFilter rzFilter;
  final ClaimsTab selectedTab;
  final RzTab selectedRzTab;

  final List<Sr>? srList;

  final List<Asset> assets;

  final String? pickedSite;

  const ClaimsState._({
    this.rzList,
    this.srList,
    this.selectedRz,
    this.selectedTab = ClaimsTab.rzList,
    this.selectedRzTab = RzTab.info,
    this.rzFilter = RzFilter.all,
    this.pickedSite,
    this.assets = const [],
    // this.selectedAsset,
  });

  factory ClaimsState.initial() => const ClaimsState._();

  ClaimsState copyWith({
    List<WorkTaskMobile>? rzList,
    List<Sr>? srList,
    WorkTaskMobile? selectedRz,
    RzFilter? rzFilter,
    ClaimsTab? selectedTab,
    RzTab? selectedRzTab,
    List<Asset>? assets,
    bool clearSelectedAsset = false,
    String? pickedSite,
  }) {
    return ClaimsState._(
      rzList: rzList ?? this.rzList,
      srList: srList ?? this.srList,
      selectedRz: selectedRz ?? this.selectedRz,
      rzFilter: rzFilter ?? this.rzFilter,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedRzTab: selectedRzTab ?? this.selectedRzTab,
      assets: assets ?? this.assets,
      pickedSite: pickedSite ?? this.pickedSite,
    );
  }
}
