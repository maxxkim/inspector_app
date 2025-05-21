import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/audit/view/audit_card.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class AuditsList extends StatelessWidget {
  const AuditsList({super.key, required this.audits});

  final List<WorkTaskMobile> audits;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: ListView.builder(
        itemCount: audits.length,
        itemBuilder: (context, index) {
          final audit = audits[index];
          return InkWell(
            child: AuditCard(audit: audit),
            onTap: () {
              context.store.dispatch(SelectedAuditAction(audit));
              context.go(AppRoute.auditDetailed.route);
            },
          );
        },
      ),
    );
  }
}
