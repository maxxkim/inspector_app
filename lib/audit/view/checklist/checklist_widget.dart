import 'package:flutter/material.dart';
import 'package:inspector_tps/audit/view/checklist/checklist_card.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';

class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget(
      {super.key, required this.checklist, required this.isTechExploitation});

  final List<ChecklistWo> checklist;
  final bool isTechExploitation;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: checklist.length + 1,
        itemBuilder: (context, index) {
          if (index == checklist.length) {
            return const SizedBox(height: 100);
          }
          final chl = checklist[index];
          return ChecklistCard(
            wo: chl,
            isTechExploitation: isTechExploitation,
          );
        });
  }
}
