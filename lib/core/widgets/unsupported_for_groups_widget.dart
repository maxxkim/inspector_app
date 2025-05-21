import 'package:flutter/material.dart';

class UnsupportedForGroupsWidget extends StatelessWidget {
  const UnsupportedForGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Недоступно для ваших групп доступа'),
    ));
  }
}
