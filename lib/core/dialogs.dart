import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/audit/redux/audits_state.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/audit/rs_defect_comment.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';

void infoDialog(BuildContext context, {required String message}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.ok)),
      ],
    ),
  );
}

void displayPhotoDialog(BuildContext context, String path,
    {int? id, String? wonum, required CameraMode mode}) {
  final image = File(path);
  showDialog(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      insetAnimationDuration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          const Spacer(),
          Image.file(image),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    await deletePhoto(context,
                        id: id, wonum: wonum, path: path, mode: mode);
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: Text(Txt.deletePhoto)),
              TextButton(onPressed: context.pop, child: Text(Txt.ok)),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}

void deleteAuditDialog(BuildContext context, WorkTaskMobile audit) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Txt.deleteAuditDialogTitle),
      content: Text(
          Txt.deleteAuditDialogContent('${audit.wonum} ${audit.description}')),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () {
              context.store.dispatch(deleteAuditAction(audit.wonum ?? ''));
              context.pop();
              context.go(AppRoute.audit.route);
            },
            child: Text(Txt.delete)),
      ],
    ),
  );
}

void sentChecklistsResultDialog(
  BuildContext context,
  String wonum,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state.auditsState),
        builder: (context, vm) {
          return AlertDialog(
            title: Text(Txt.sendingAuditToMaximoDialogTitle),
            content: Text(Txt.sentAuditToMaximoResultDialogContent(
                vm.count, wonum, vm.total)),
            actions: [
              if (vm.showCloseButton)
                TextButton(
                    onPressed: () {
                      context.store.dispatch(SendingAuditCountAction(null));
                      context.store.dispatch(TotalToUploadingAction(0));
                      context.pop();
                    },
                    child: Text(Txt.ok)),
            ],
          );
        }),
  );
}

class _VM extends Equatable {
  final AuditsState state;

  const _VM(this.state);

  int get count => state.sendingAuditCount;

  int get total => state.totalToUploading;

  bool get showCloseButton => !state.showSendingDialog;

  @override
  List<Object?> get props => [count, showCloseButton];
}

void addRsDefectComment(BuildContext context, ChecklistWo wo) {
  // final TextEditingController controller =
  //     TextEditingController(text: wo.goal ?? '');
  final TextEditingController controller = TextEditingController();
  // final bool hasComment = wo.goal != null && wo.goal!.isNotEmpty;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Txt.addComment),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${wo.number}'),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: 999,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () async {
              final comment = controller.text.trim();
              final wonum = wo.woNum;
              final id = wo.checklistWoId;
              final checklistOperationId = wo.checklistOperationId;
              if (comment.isNotEmpty &&
                  wonum != null &&
                  id != null &&
                  checklistOperationId != null) {
                context.store.dispatch(
                  addCommentAction(
                    wonum: wonum,
                    checklistwoid: id,
                    checklistOperationId: checklistOperationId,
                    parentId: wo.parentId ?? -1,
                    comment: comment,
                    siteId: wo.siteId ?? '',
                  ),
                );
              }
              context.pop();
            },
            child: Text(Txt.save)),
      ],
    ),
  );
}

void deleteRsDefectCommentDialog(
    BuildContext context, RsDefectComment comment, ChecklistWo wo) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Txt.deleteRsDefectCommentDialogTitle),
      content: Text(comment.comment ?? ''),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () {
              context.store.dispatch(deleteRsDefectCommentAction(
                  comment: comment,
                  parentId: wo.parentId ?? -1,
                  checklistwoid: wo.checklistWoId ?? -1));
              context.pop();
            },
            child: Text(Txt.delete)),
      ],
    ),
  );
}

void addPprCommentDialogWithAction(
  BuildContext context,
  WorkTaskMobile ppr, {
  bool reportEquipmentFailure = false,
  bool reject = false,
  required bool isPhotoComment,
}) {
  final TextEditingController controller = TextEditingController();
  final title = isPhotoComment
      ? Txt.addCommentToAttachedPhoto
      : '${Txt.addComment} ${ppr.wonum}';
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: _accCommentTitleStyle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ppr.description ?? ''),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: 999,
            ),
          ],
        ),
      ),
      actions: [
        if (!isPhotoComment)
          TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(Txt.cancel)),
        TextButton(
          onPressed: () async {
            final comment = controller.text.trim();
            if (comment.isEmpty) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(Txt.shouldAddComment)));
              return;
            }
            if (reportEquipmentFailure) {
              context.store.dispatch(reportEquipmentFailureWithCommentAction(
                  ppr.wonum!, ppr.href, comment, ppr.doclinks?.href));
            } else if (reject) {
              context.store.dispatch(cancelPprAction(
                  ppr.wonum!, ppr.href, comment, ppr.doclinks?.href));
            } else {
              context.store.dispatch(addCommentToPprAction(
                  wonum: ppr.wonum!, comment: controller.text.trim()));
              if (appStore.state.isConnected) {
                appStore.dispatch(
                  sendCommentToMaximoAction(
                      ppr.wonum ?? '', ppr.href, ppr.doclinks?.href,
                      isPpr: true),
                );
              }
            }
            context.pop();
          },
          child: Text(
            _getActionButtonText(
              report: reportEquipmentFailure,
              reject: reject,
              isPhotoComment: isPhotoComment,
            ),
          ),
        ),
      ],
    ),
  );
}

String _getActionButtonText(
    {required bool report,
    required bool reject,
    required bool isPhotoComment}) {
  if (report) return Txt.report;
  if (reject) return Txt.rejectPpr;
  bool isConnected = appStore.state.isConnected;
  if (isPhotoComment && isConnected) return Txt.sendPhotoWithComment;
  return Txt.save;
}

const _accCommentTitleStyle = TextStyle(fontSize: 15, color: accent);

void addJobCommentDialog(BuildContext context, Woactivity job) {
  final TextEditingController controller = TextEditingController()
    ..text = job.pprcomment ?? '';
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        Txt.addComment,
        style: _accCommentTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${job.description}'),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: 250,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () {
              context.store.dispatch(addJobtaskCommentAction(
                wonum: job.wonum!,
                wosequence: job.wosequence ?? -1,
                comment: controller.text.trim(),
              ));

              context.pop();
            },
            child: Text(Txt.save)),
      ],
    ),
  );
}

// rz

void addRzCommentDialog(BuildContext context, WorkTaskMobile rz) {
  final TextEditingController controller = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title:
          Text('${Txt.addComment} ${rz.wonum}', style: _accCommentTitleStyle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rz.description ?? ''),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              maxLength: 999,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () async {
              final comment = controller.text.trim();
              if (comment.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Txt.shouldAddComment)));
                return;
              }

              context.store.dispatch(addCommentToRzAction(
                  wonum: rz.wonum!, comment: controller.text.trim()));
              context.pop();
            },
            child: Text(Txt.save)),
      ],
    ),
  );
}

void downloadAssetsDialog(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(Txt.assets),
            content: Text(Txt.downloadAssets),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(Txt.cancel)),
              TextButton(
                  onPressed: () {
                    context.pop();
                    context.store.dispatch(downloadAssetsCatalogAction());
                  },
                  child: Text(Txt.download)),
            ],
          ));
}

void deleteClaimDialog(BuildContext context, Sr sr) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Txt.deleteClaimDialogTitle),
      content: Text(Txt.deleteClaimDialogContent),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(Txt.cancel)),
        TextButton(
            onPressed: () {
              context.store.dispatch(deleteSrAction(sr));
              context.pop();
            },
            child: Text(Txt.delete)),
      ],
    ),
  );
}
