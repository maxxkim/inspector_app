import 'package:flutter/material.dart';
import 'package:inspector_tps/audit/view/checklist/images_row.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

class ClaimCard extends StatelessWidget {
  const ClaimCard({super.key, required this.sr, required this.user});

  final Sr sr;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(sr.ticketid ?? '', style: _style),
        span10,
        Text(sr.siteid ?? '', style: _style),
        span10,
        if (sr.reportdate != null)
          Text(dateTimeFromIso(sr.reportdate ?? ''), style: _style),
      ],
    );

    return Card(
      elevation: 0,
      color: sr.sent ? Colors.green.withOpacity(0.2) : primary.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sr.sent) header,
                if (sr.sent)
                  Text('${Txt.from} ${sr.fromwho ?? ''}', style: _style),
                Text(
                  sr.locdesc ?? '',
                  style: _style,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    sr.description ?? '',
                    maxLines: 3,
                    style: _style,
                  ),
                ),
                if (!sr.sent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ImagesRow(
                          wonum: sr.changedate,
                          images: sr.images,
                          mode: CameraMode.claim),
                      IconButton(
                          onPressed: () {
                            attachPhoto(context,
                                wonum: sr.changedate ?? '',
                                checklistwoid: null,
                                mode: CameraMode.claim);
                          },
                          icon: const Icon(Icons.photo_camera)),
                      IconButton(
                          onPressed: () {
                            final isConnected = context.store.state.isConnected;
                            if (!isConnected) {
                              infoDialog(context,
                                  message: Txt.internetNeededForDataSending);
                            } else {
                              context.store.dispatch(sendClaimToMaximoAction(
                                  savedSr: sr, user: user));
                            }
                          },
                          icon: const Icon(Icons.send)),
                    ],
                  ),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                    onTap: () {
                      deleteClaimDialog(context, sr);
                    },
                    child: const Icon(Icons.close)))
          ],
        ),
      ),
    );
  }
}

TextStyle _style = const TextStyle(fontSize: 10);
