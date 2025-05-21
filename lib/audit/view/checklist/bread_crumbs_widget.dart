import 'package:flutter/material.dart';

class BreadCrumbsWidget extends StatelessWidget {
  const BreadCrumbsWidget({
    super.key,
    required this.crumbs,
    required this.tapCrumbCallback,
  });

  final List<String> crumbs;
  final Function(int) tapCrumbCallback;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: generateCrumbs(context, crumbs),
    );
  }

  List<Widget> generateCrumbs(BuildContext context, List<String> input) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final list = <Widget>[];
    for (var i = 0; i < input.length; i++) {
      final isLast = i == input.length - 1;
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Crumb(
            name: input[i],
            index: i,
            color: isLast ? Colors.black : activeColor,
            tapCrumbCallback: tapCrumbCallback,
            isLast: isLast,
          ),
        ),
      );
    }
    return list;
  }
}

class Crumb extends StatelessWidget {
  const Crumb({
    super.key,
    required this.name,
    required this.color,
    required this.index,
    required this.tapCrumbCallback,
    required this.isLast,
  });

  final String name;
  final Color color;
  final int index;
  final Function(int) tapCrumbCallback;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        '$name ${isLast ? '\u{2193}' : '\u{2192}'} ',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        tapCrumbCallback(index);
      },
    );
  }
}
