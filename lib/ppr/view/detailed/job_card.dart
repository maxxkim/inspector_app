import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:inspector_tps/ppr/view/detailed/description.dart';

class JobCard extends StatelessWidget {
  final Woactivity job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            color: grayMiddle,
            width: 1,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Description(title: job.description ?? '-'),
            gap5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      addJobCommentDialog(context, job);
                    },
                    icon: SvgPicture.asset('assets/add_comment.svg',
                        width: 44, height: 36)),
                _Jptask(job.wosequence?.toString() ?? '-'),
                ResultDropdown(job: job),
              ],
            ),
            if (job.pprcomment != null) ...[
              Text(
                '${Txt.comment}:',
                style: const TextStyle(fontSize: 10, color: primary),
              ),
              Text(
                job.pprcomment!,
                style: const TextStyle(fontSize: 10, color: accent),
              ),
            ],
            Text('${Txt.estDur} ${((job.estdur ?? 0.15) * 60).toInt()}',
                style: const TextStyle(fontSize: 10))
            // IconButton(
            //     onPressed: () async {
            // final sent = sl<MaximoRepository>().updateWoactivity(job);
            // final sent = await sl<MaximoRepository>().getTestwoactivityHref(job);
            // print(sent);
            // },
            // icon: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}

class ResultDropdown extends StatelessWidget {
  const ResultDropdown({super.key, required this.job});

  final Woactivity job;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: job.pprresult,
      items: jobResults
          .map((result) => DropdownMenuItem<String>(
                value: result,
                child: Text(result),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          context.store.dispatch(updateJobtaskResultAction(
            wonum: job.wonum!,
            wosequence: job.wosequence ?? -1,
            result: value,
          ));
        }
      },
    );
  }
}

class _Jptask extends StatelessWidget {
  final String opNumber;

  const _Jptask(this.opNumber);

  @override
  Widget build(BuildContext context) {
    return Text(opNumber,
        style: const TextStyle(
          color: primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ));
  }
}
