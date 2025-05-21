
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_actions.dart';
import 'package:inspector_tps/ppr/view/ppr_card.dart';

class PprsList extends StatelessWidget {
  const PprsList({super.key, required this.pprs});

  final List<WorkTaskMobile> pprs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Scrollbar(
        child: ListView.builder(
          itemCount: pprs.length,
          itemBuilder: (context, index) {
            final ppr = pprs[index];
            return InkWell(
              child: PprCard(ppr: ppr),
              onTap: () {
                debugPrint(ppr.toString());
                context.store.dispatch(SelectedPprAction(ppr));
                context.go(AppRoute.pprDetailed.route);
              },
            );
          },
        ),
      ),
    );
  }
}
