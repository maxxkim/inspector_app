import 'package:flutter/material.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/audit/redux/audits_actions.dart';
import 'package:inspector_tps/audit/view/checklist/images_row.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';

class ChecklistCard extends StatelessWidget {
  const ChecklistCard(
      {super.key, required this.wo, required this.isTechExploitation});

  final ChecklistWo wo;
  final bool isTechExploitation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final downloadedComments = wo.rsDefectcomment
            ?.where((c) => c.rsDefectCommentId != null)
            .toList() ??
        [];
    final bool hasDownloadedComments = downloadedComments.isNotEmpty;
    final myComments = wo.rsDefectcomment
            ?.where((c) => c.rsDefectCommentId == null)
            .toList() ??
        [];
    final bool hasMyComments = myComments.isNotEmpty;
    final wonum = wo.woNum;
    final id = wo.checklistWoId;
    final parentId = wo.parentId;
    final isLeaf = wo.checklist.isEmpty && !(wo.hasChildren ?? false);
    return GestureDetector(
      onTap: () async {
        final asMap = wo.toMap();
        debugPrint(asMap.toString());
        debugPrint('isLeaf: $isLeaf');
        debugPrint(
            'comments: ${wo.rsDefectcomment?.fold('', (agr, e) => '$agr ${e.comment};')}');
        setVisited(wo.checklistWoId!);
        if (context.mounted) {
          context.store
              .dispatch(visitInLevels(checklistwoid: wo.checklistWoId!));
        }
        final next = wo.checklist;
        if (next.isNotEmpty) {
          context.store.dispatch(NextAction(checklist: next));
          context.store.dispatch(CrumbAction(crumb: wo.description ?? ''));

          if (next.first.checklist.isEmpty) {
            for (var wo in next) {
              context.store.dispatch(
                  findAndUpdateWoInLevels(checklistwoid: wo.checklistWoId!));
            }
          }
        }
      },
      child: Card(
        color: (wo.hasChildren ?? false) && (wo.visited ?? false)
            ? Colors.deepPurple.withOpacity(0.1)
            : null,
        key: ValueKey<int>(wo.checklistWoId!),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (wo.number != null)
                      Text(
                        wo.number!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Text(
                      wo.description ?? '',
                    ),
                    if (isLeaf)
                      // if (_showTeReportData(wo))
                      //   Text(
                      //     Txt.teReportData,
                      //   )
                      // else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton(
                              value: ChecklistWo
                                  .statusMap[int.parse(wo.chlistStatus ?? '0')],
                              items: getStatuses
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (status) {
                                final wonum = wo.woNum;
                                final id = wo.checklistWoId;
                                final parentId = wo.parentId;
                                if (status != null &&
                                    wonum != null &&
                                    id != null &&
                                    parentId != null) {
                                  context.store.dispatch(updateStatusAction(
                                      wonum: wonum,
                                      checklistwoid: id,
                                      parentId: parentId,
                                      status: ChecklistWo
                                          .statusDescriptionMap[status]!));
                                }
                              }),
                          // Значение фактора
                          if (wo.hasFactor)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Txt.factorValue,
                                  style: TextStyle(color: colorScheme.primary),
                                ),
                                DropdownButton(
                                    value: wo.numberof ?? 1.0,
                                    items: factors
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.toInt().toString())))
                                        .toList(),
                                    onChanged: (factor) {
                                      final wonum = wo.woNum;
                                      final id = wo.checklistWoId;
                                      final parentId = wo.parentId;
                                      if (factor != null &&
                                          wonum != null &&
                                          id != null &&
                                          parentId != null) {
                                        context.store
                                            .dispatch(updateFactorAction(
                                          wonum: wonum,
                                          checklistwoid: id,
                                          parentId: parentId,
                                          factor: factor,
                                        ));
                                      }
                                    }),
                              ],
                            ),
                          if (hasDownloadedComments) ...[
                            Text(
                              '${Txt.downloadedComments}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...downloadedComments.map(
                              (comment) => Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  comment.comment ?? '',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                          if (hasMyComments) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                '${Txt.myComments}:',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...myComments.map(
                              (comment) => Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: InkWell(
                                  onTap: () {
                                    deleteRsDefectCommentDialog(
                                        context, comment, wo);
                                  },
                                  child: Text(
                                    comment.comment ?? '',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: accent),
                                  ),
                                ),
                              ),
                            )
                          ],
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () =>
                                        addRsDefectComment(context, wo),
                                    child: Text(
                                      Txt.addComment,
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                      ),
                                    )),
                                if (wo.images.length < 6)
                                  IconButton(
                                      onPressed: () {
                                        if (wonum != null && id != null) {
                                          attachPhoto(context,
                                              wonum: wonum,
                                              checklistwoid: wo.checklistWoId,
                                              mode: CameraMode.checklist);
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.camera_alt_outlined)),
                                Checkbox(
                                  value: wo.rsMasterpoint,
                                  onChanged: (value) {
                                    if (wonum != null &&
                                        id != null &&
                                        parentId != null) {
                                      context.store.dispatch(
                                        updateCheckedAction(
                                          wonum: wonum,
                                          checklistwoid: id,
                                          parentId: parentId,
                                          checked: (value ?? false) ? 1 : 0,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (id != null && wonum != null)
                            ImagesRow(
                              images: wo.images,
                              checklistWoId: wo.checklistWoId!,
                              mode: CameraMode.checklist,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> get getStatuses {
    final statuses = ChecklistWo.statusMap.values.toList();
    return isTechExploitation ? statuses : statuses.sublist(1);
  }

  List<double> get factors => List.generate(100, (i) => i + 1, growable: false);

  bool _showTeReportData(ChecklistWo wo) {
    return wo.classid != null &&
        wo.classid!.isNotEmpty &&
        (wo.number?.startsWith('k') ?? false);
  }
}

// void attachChecklistPhoto(
//   BuildContext context, {
//   required String wonum,
//   required int id,
// }) {
//   context.push(AppRoute.camera.route,
//       extra: PhotoParams(checklistwoid: id, wonum: wonum, isPpr: false));
// }
