import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/claims/rz_card.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class RzList extends StatelessWidget {
  const RzList({super.key, required this.rzList});

  final List<WorkTaskMobile> rzList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Scrollbar(
        child: ListView.builder(
          itemCount: rzList.length,
          itemBuilder: (context, index) {
            final rz = rzList[index];
            return InkWell(
              child: RzCard(rz: rz),
              onTap: () {
                debugPrint(rz.toString());
                context.store.dispatch(readSelectedRzFromDbAction(rz.wonum!));
                context.go(AppRoute.rzDetailed.route);
              },
            );
          },
        ),
      ),
    );
  }
}
