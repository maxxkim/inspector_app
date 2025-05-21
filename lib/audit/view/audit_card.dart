import 'package:flutter/material.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class AuditCard extends StatelessWidget {
  const AuditCard({super.key, required this.audit});

  final WorkTaskMobile audit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateStyle =
        textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold);
    Widget dateRow;

    if (audit.isKvosm) {
      dateRow = Row(
        children: [
          Text(audit.quarterDescription ?? '', style: dateStyle),
          const Spacer(),
          Text(audit.yearDescription ?? '', style: dateStyle),
        ],
      );
    } else {
      dateRow = Row(
        children: [
          if (audit.weekDescription != null) ...[
            Text((audit.weekDescription ?? ''), style: dateStyle),
            _minSpan
          ],
          Text((audit.monthDescription ?? ''), style: dateStyle),
          _minSpan,
          Text((audit.yearDescription ?? ''), style: dateStyle),
        ],
      );
    }
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(audit.wonum ?? '', style: dateStyle),
            _minGap,
            Text(
              audit.description ?? '',
              style: textTheme.bodyMedium,
            ),
            _minGap,
            dateRow,
          ],
        ),
      ),
    );
  }
}

const _minGap = SizedBox(height: 10);
const _minSpan = SizedBox(width: 20);
