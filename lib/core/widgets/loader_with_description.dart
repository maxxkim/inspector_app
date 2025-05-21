import 'package:flutter/material.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/txt.dart';

class LoaderWithDescription extends StatelessWidget {
  const LoaderWithDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          gap40,
          Text(Txt.doNotCloseSendingPpr,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
