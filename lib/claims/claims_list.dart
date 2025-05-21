import 'package:flutter/material.dart';
import 'package:inspector_tps/claims/claim_card.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';

class ClaimsList extends StatelessWidget {
  const ClaimsList({super.key, required this.srList, required this.user});

  final List<Sr> srList;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: srList.length,
      itemBuilder: (context, index) {
        final sr = srList[index];
        return InkWell(
          child: ClaimCard(sr: sr, user: user),
          onTap: () {
            debugPrint(sr.toString());
          },
        );
      },
    );
  }
}
