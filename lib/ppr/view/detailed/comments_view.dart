import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:inspector_tps/data/models/worklog/worklog.dart';
import 'package:inspector_tps/ppr/view/detailed/add_comment_button.dart';
import 'package:inspector_tps/ppr/view/detailed/comment_card.dart';

class CommentsView extends StatelessWidget {
  const CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
      converter: (store) => _VM(store.state),
      builder: (context, vm) {
        // if (vm.selectedPpr.status == statusCompleted) {
        //   return const PprCompletedWidget();
        // }

        if (vm.showLoader) {
          return const LoaderWithDescription();
        }
        // final images = vm.selectedPpr.images;
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // if (images.length < 6)
                //   IconButton(
                //       onPressed: () {
                //         attachPhoto(context,
                //             wonum: vm.selectedPpr.wonum!, isPpr: true);
                //       },
                //       icon: const Icon(Icons.camera_alt_outlined)),
                // gap10,
                // ImagesRow(
                //   images: images,
                //   wonum: vm.selectedPpr.wonum,
                //   isPpr: true,
                // ),
                gap10,
                AddCommentButton(
                  text: Txt.addPprComment,
                  onTap: () => _addComment(context, vm.selectedPpr),
                ),
                gap10,
                if (vm.freshComments.isNotEmpty) Text(Txt.fresh),
                ...vm.freshComments.map((comment) => Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CommentCard(
                        worklog: comment,
                        href: vm.selectedPpr.href,
                        doclinks: vm.selectedPpr.doclinks?.href,
                      ),
                    )),
                gap10,
                if (vm.downloadedComments.isNotEmpty) Text(Txt.downloaded),
                ...vm.downloadedComments.map((comment) => Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CommentCard(
                        worklog: comment,
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addComment(BuildContext context, WorkTaskMobile ppr) {
    addPprCommentDialogWithAction(context, ppr, isPhotoComment: false);
  }
}

class _VM extends Equatable {
  const _VM(this.appState);

  final AppState appState;

  WorkTaskMobile get selectedPpr => appState.pprState.selectedPpr!;

  List<Worklog> get comments => selectedPpr.worklog ?? [];

  List<Worklog> get downloadedComments =>
      comments.where((c) => !c.fresh).toList();

  List<Worklog> get freshComments => comments.where((c) => c.fresh).toList();

  bool get showLoader => appState.showLoader;

  @override
  List<Object?> get props => [
        selectedPpr.worklog?.length ?? 0,
        selectedPpr.images,
        showLoader,
      ];
}
