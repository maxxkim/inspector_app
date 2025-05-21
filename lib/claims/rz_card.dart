import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/core/widgets/card_divider.dart';
import 'package:inspector_tps/core/widgets/unsaved_icon_button.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class RzCard extends StatelessWidget {
  const RzCard({super.key, required this.rz, this.showReady = false});

  final WorkTaskMobile rz;
  final bool showReady;

  @override
  Widget build(BuildContext context) {
    final bool isOutdated = outdated(rz.targcompdate ?? '');
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.bodyMedium?.copyWith(color: primary);
    final dateStyle = textTheme.labelMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: primary);
    final headerStyle = dateStyle?.copyWith(fontSize: 9);
    Widget dateRow = Container(
      color: isOutdated ? accent.withOpacity(0.5) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(Txt.claimFrom, style: dateStyle),
              Text(dateFromIso(rz.reportDate ?? ''), style: dateStyle),
            ],
          ),
          Row(
            children: [
              Text(Txt.finishUntil, style: dateStyle),
              Text(dateTimeFromIso(rz.targcompdate ?? ''), style: dateStyle),
            ],
          ),
        ],
      ),
    );
    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(rz.siteid ?? '', style: dateStyle),
            span5,
            Text(rz.wonum ?? '', style: dateStyle),
          ],
        ),
        Text(rz.worktype ?? '', style: headerStyle),
        Row(
          children: [
            if (rz.offlineScript != null) const UnsavedIconButton(),
            Text(
              rz.statusDescription ?? '',
              style: headerStyle?.copyWith(
                color: primary,
              ),
            ),
          ],
        ),
      ],
    );

    return Card(
      elevation: 1,
      color: rz.status == statusPreApproved
          ? gray
          : rz.status == statusDefecting
              ? redBg
              : white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(rz.priority ?? '',
                    style: headerStyle?.copyWith(color: accent)),
                Text(rz.displayName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: headerStyle?.copyWith(color: accent)),
              ],
            ),
            gap10,
            Text(
              rz.description ?? '',
              style: textStyle,
            ),
            gap10,
            Text(
              rz.asset?.description ?? '',
              style: textStyle,
            ),
            gap10,
            const CardDivider(),
            gap10,
            dateRow,
          ],
        ),
      ),
    );
  }
}
