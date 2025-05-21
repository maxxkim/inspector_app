import 'package:flutter/material.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/view/detailed/description.dart';

class CommentCard extends StatelessWidget {
  final Worklog worklog;
  final String? href;
  final String? doclinks;
  final bool isPpr;

  const CommentCard({
    super.key,
    required this.worklog,
    this.href,
    this.doclinks,
    this.isPpr = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: bg,
          width: 1,
        ),
        color: worklog.fresh ? primary.withOpacity(0.1) : Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!worklog.fresh)
            Text(
              'От: ${worklog.fromName ?? worklog.createby ?? '-'}',
              style: const TextStyle(fontSize: 10, color: primary),
            ),
          if (!worklog.fresh)
            Text(
              softWrap: true,
              dateTimeFromIso(worklog.createdate ?? '-'),
              style: const TextStyle(fontSize: 10, color: primary),
            ),
          gap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Description(title: worklog.description ?? '-')),
              if (worklog.fresh)
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    context.store.dispatch(sendCommentToMaximoAction(
                        worklog.wonum ?? '', href, doclinks,
                        isPpr: isPpr));
                  },
                ),
              if (worklog.fresh)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (isPpr) {
                      context.store.dispatch(deletePprCommentAction(
                          wonum: worklog.wonum!,
                          comment: worklog.description ?? '---'));
                    } else {
                      context.store.dispatch(deleteRzCommentAction(
                          wonum: worklog.wonum!,
                          comment: worklog.description ?? '---'));
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
