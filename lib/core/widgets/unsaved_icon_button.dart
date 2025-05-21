import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/dialogs.dart';
import 'package:inspector_tps/core/txt.dart';

class UnsavedIconButton extends StatelessWidget {
  const UnsavedIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          infoDialog(context, message: Txt.locallySaved);
        },
        child: const Icon(
          size: 20,
          Icons.save,
          color: accent,
        ));
  }
}
