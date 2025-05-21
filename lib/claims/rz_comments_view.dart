import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:inspector_tps/ppr/view/detailed/add_comment_button.dart';
import 'package:inspector_tps/ppr/view/detailed/comment_card.dart';

class RzCommentsView extends StatelessWidget {
  const RzCommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        builder: (context, vm) {
          return Expanded(
            child: Column(
              children: [
                AddCommentButton(
                  text: Txt.addRzComment,
                  onTap: () => _addComment(context, vm.selectedRz),
                ),
                gap10,
                if (vm.freshComments.isNotEmpty)
                  Text(
                    Txt.fresh,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                gap10,
                if (vm.freshComments.isNotEmpty)
                  SizedBox(
                      height: min(vm.freshComments.length * 70, 250),
                      child: ListView.builder(
                          itemCount: vm.freshComments.length,
                          itemBuilder: (context, index) {
                            final comment = vm.freshComments[index];
                            return CommentCard(
                              worklog: comment,
                              href: vm.selectedRz.href,
                              doclinks: vm.selectedRz.doclinks?.href,
                              isPpr: false,
                            );
                          })),
                gap10,
                if (vm.downloadedComments.isNotEmpty)
                  Text(
                    Txt.downloaded,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                gap10,
                SizedBox(
                    height: min(vm.downloadedComments.length * 60, 250),
                    child: ListView.builder(
                        itemCount: vm.downloadedComments.length,
                        itemBuilder: (context, index) {
                          final comment = vm.downloadedComments[index];
                          return CommentCard(worklog: comment);
                        })),
              ],
            ),
          );
        });
  }

  void _addComment(BuildContext context, WorkTaskMobile rz) {
    addRzCommentDialog(context, rz);
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  WorkTaskMobile get selectedRz => appState.claimsState.selectedRz!;

  List<Worklog> get comments => selectedRz.worklog ?? [];

  List<String> get images => selectedRz.images;

  List<Worklog> get downloadedComments =>
      comments.where((c) => !c.fresh).toList();

  List<Worklog> get freshComments => comments.where((c) => c.fresh).toList();

  @override
  List<Object?> get props => [
        downloadedComments,
        freshComments,
      ];
}
