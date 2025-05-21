import 'package:flutter/material.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key, required this.title, required this.subTitle, this.color});

  final String title;
  final String subTitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: bg,
          width: 1,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(title),
          gap5,
          _SubTitle(
            subTitle,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ));
  }
}

class _SubTitle extends StatelessWidget {
  final String subtitle;
  final Color? color;

  const _SubTitle(this.subtitle, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(subtitle,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ));
  }
}
