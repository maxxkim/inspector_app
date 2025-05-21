import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String title;

  const Description({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    return Text(title,
        softWrap: true,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ));
  }
}
