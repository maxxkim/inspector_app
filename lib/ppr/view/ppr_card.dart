import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/core/widgets/card_divider.dart';
import 'package:inspector_tps/core/widgets/unsaved_icon_button.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/utils.dart';

class PprCard extends StatelessWidget {
  const PprCard({super.key, required this.ppr, this.showReady = false});

  final WorkTaskMobile ppr;
  final bool showReady;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.bodyMedium?.copyWith(color: primary);
    final dateStyle = textTheme.labelMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: primary);
    final headerStyle = dateStyle?.copyWith(fontSize: 10);
    Widget dateRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dateTimeFromIso(ppr.targstartdate ?? ''), style: dateStyle),
        Text(dateTimeFromIso(ppr.targcompdate ?? ''), style: dateStyle),
      ],
    );
    final bool assigned = ppr.status == statusAssigned;
    final bool preApproved = ppr.status == statusPreApproved;
    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ppr.wonum.toString(), style: headerStyle),
        Text(ppr.worktype ?? '', style: headerStyle),
        Row(
          children: [
            if (assigned && !ppr.pprTakenInMaximo) const UnsavedIconButton(),
            Row(
              children: [
                if (isPprReady(ppr)) const ReadyIcon(),
                Text(
                  ppr.statusDescription?.toUpperCase() ?? '',
                  style: headerStyle?.copyWith(
                    color: assigned || preApproved ? positive : primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return Card(
      elevation: 1,
      color: ppr.status == statusCompleted || ppr.status == statusFullyCompleted
          ? grayMiddle
          : ppr.status == statusRejected
              ? redBg
              : white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            gap10,
            Text(
              ppr.description ?? '',
              style: textStyle,
            ),
            gap10,
            Text(
              ppr.asset?.description ?? '',
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

class ReadyIcon extends StatelessWidget {
  const ReadyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.check, color: accent);
  }
}
