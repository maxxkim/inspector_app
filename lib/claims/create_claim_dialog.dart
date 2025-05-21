import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/claims/redux/claims_actions.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

void createClaimDialog(BuildContext context, UserModel user) {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  // void dispose() {
  //   descriptionController.dispose();
  //   locationController.dispose();
  // }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => StoreConnector<AppState, (bool, String)>(
        converter: (store) => (
              store.state.isConnected,
              store.state.claimsState.pickedSite ?? user.defaultSite ?? '',
            ),
        builder: (context, vm) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: Column(
              children: [
                Text(Txt.newClaim),
                if (user.isCo)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Txt.pickSite,
                        style: const TextStyle(fontSize: 13),
                      ),
                      DropdownButton(
                          value: vm.$2,
                          items: readSites()
                              .map((site) => DropdownMenuItem(
                                  value: site.value,
                                  child: Text(
                                    '${site.value} ${site.description}',
                                    style: const TextStyle(fontSize: 13),
                                  )))
                              .toList(),
                          onChanged: (site) {
                            context.store
                                .dispatch(PickedSiteAction(site ?? ''));
                          }),
                    ],
                  ),
              ],
            ),
            content: CreateClaimContent(
              descriptionController: descriptionController,
              locationController: locationController,
            ),
            actions: [
              TextButton(
                child: Text(Txt.cancel),
                onPressed: () {
                  context.pop();
                },
              ),
              TextButton(
                child: Text(
                  Txt.saveNewClaim,
                  style: TextStyle(color: !vm.$1 ? Colors.red : null),
                ),
                onPressed: () {
                  if (locationController.text.length < 3) {
                    infoDialog(context, message: Txt.enterLocation);
                    return;
                  } else if (descriptionController.text.length < 3) {
                    infoDialog(context, message: Txt.enterDescription);
                    return;
                  }
                  context.store.dispatch(createClaimAction(
                    location: locationController.text.trim(),
                    description: descriptionController.text.trim(),
                    pickedSite: vm.$2,
                  ));

                  context.pop();
                },
              ),
            ],
          );
        }),
  );
}

class CreateClaimContent extends StatelessWidget {
  const CreateClaimContent(
      {super.key,
      required this.descriptionController,
      required this.locationController});

  final TextEditingController descriptionController;
  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    final user = context.store.state.userState.user;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Txt.from} ${user?.displayName ?? user?.loginID}'),
            gap40,
            TextField(
              decoration: InputDecoration(
                hintText: Txt.locationDescription,
                hintStyle: _hintStyle,
                border: _border,
              ),
              controller: locationController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 2,
              maxLength: 250,
            ),
            gap20,
            TextField(
              decoration: InputDecoration(
                hintText: Txt.claimText,
                hintStyle: _hintStyle,
                border: _border,
              ),
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }
}

const _hintStyle = TextStyle(color: gray, fontSize: 12);

final _border = OutlineInputBorder(
  borderSide: const BorderSide(color: primary, width: 4),
  borderRadius: BorderRadius.circular(12),
);
