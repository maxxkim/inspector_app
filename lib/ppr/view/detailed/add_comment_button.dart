import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            SvgPicture.asset('assets/add_comment.svg'),
            span10,
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: primary),
            ),
            span10,
          ],
        ),
      ),
    );
  }
}
