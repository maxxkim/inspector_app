import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';

class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      color: primary.withOpacity(0.75),
    );
  }
}
