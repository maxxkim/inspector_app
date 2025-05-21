import 'package:flutter/material.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';

class DownloadChecklistWidget extends StatelessWidget {
  const DownloadChecklistWidget({super.key, required this.href});

  final String href;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(Icons.download_for_offline, size: 100, color: Colors.grey),
          _gap,
          Text(Txt.downloadDescription,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          _gap,
          Text(Txt.downloadDescription2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                context.store.dispatch(downloadAuditCheckListsAction(href));
              },
              child: Text(Txt.downloadChecklist)),
          _gap,
        ],
      ),
    );
  }

  static const _gap = SizedBox(height: 50);
}
