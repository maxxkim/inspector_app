import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';

class RoundCountWidget extends StatelessWidget {
  const RoundCountWidget({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(count.toString(),
            style: const TextStyle(
                color: primary, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
