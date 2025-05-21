import 'package:flutter/material.dart';
import 'package:inspector_tps/claims/claims_list.dart';
import 'package:inspector_tps/claims/create_claim_dialog.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

import '../core/txt.dart';

class CreateClaimView extends StatelessWidget {
  const CreateClaimView(
      {super.key,
      required this.localClaims,
      required this.sentClaims,
      required this.user});

  final List<Sr> localClaims;
  final List<Sr> sentClaims;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () {
          createClaimDialog(context, user);
        },
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          gap10,
          if (localClaims.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(Txt.savedClaims,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ClaimsList(
                srList: localClaims,
                user: user,
              ),
            ),
          ],
          if (sentClaims.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(Txt.sentClaims,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ClaimsList(
                srList: sentClaims,
                user: user,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
