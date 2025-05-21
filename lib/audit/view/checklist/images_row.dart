import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspector_tps/core/camera/camera_screen.dart';
import 'package:inspector_tps/core/dialogs.dart';

class ImagesRow extends StatelessWidget {
  const ImagesRow(
      {super.key,
      required this.images,
      this.checklistWoId,
      this.wonum,
      required this.mode});

  final List<String> images;
  final int? checklistWoId;
  final String? wonum;
  final CameraMode mode;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...images.map((e) => Preview(
            path: e,
            checklistWoId: checklistWoId,
            wonum: wonum,
            cameraMode: mode,
          ))
    ]);
  }
}

class Preview extends StatelessWidget {
  const Preview(
      {super.key,
      required this.path,
      this.checklistWoId,
      this.wonum,
      required this.cameraMode});

  final String path;
  final int? checklistWoId;
  final String? wonum;
  final CameraMode cameraMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        displayPhotoDialog(
          context,
          path,
          id: checklistWoId,
          wonum: wonum,
          mode: cameraMode,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(5),
          height: 50,
          width: 50,
          child: Image.file(File(path), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
