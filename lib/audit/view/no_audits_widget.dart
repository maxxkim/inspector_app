import 'package:flutter/material.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';

class NoAuditsWidget extends StatelessWidget {
  const NoAuditsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Text(Txt.noAudits),
          const SizedBox(height: 100),
          ElevatedButton(
              onPressed: () {
                context.store.dispatch(downloadAuditsAction());
              },
              child: Text(Txt.downloadAudits)),
          const Spacer(),
        ],
      ),
    );
  }
}