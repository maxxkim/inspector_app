import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/audit/redux/audit_thunks.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/ppr/redux/ppr_thunks.dart';
import 'package:path_provider/path_provider.dart';

enum CameraMode {
  checklist,
  ppr,
  rz,
  claim,
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.wonum,
    required this.checklistWoId,
    required this.mode,
  });

  final String wonum;
  final int? checklistWoId;
  final CameraMode mode;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  double _zoom = 1.0;
  double _scaleFactor = 1.0;
  double _maxScale = 10;
  double _maxCamScale = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initCamera();
  }

  Future<void> initCamera() async {
    _controller = CameraController(
      appCamera,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller.initialize();
    _maxCamScale = await _controller.getMaxZoomLevel();
    _maxScale = _maxCamScale > _maxScale ? _maxScale : _maxCamScale;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Txt.takeAPicture)),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onScaleStart: (details) {
                _zoom = _scaleFactor;
              },
              onScaleUpdate: (details) {
                _scaleFactor = _zoom * details.scale;
                if (_scaleFactor <= _maxScale) {
                  _controller.setZoomLevel(_scaleFactor);
                }
              },
              child: CameraPreview(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'camera',
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          await takeAndSavePhoto(context,
              controller: _controller,
              wonum: widget.wonum,
              id: widget.checklistWoId,
              mode: widget.mode);
        },
      ),
    );
  }
}

Future<void> takeAndSavePhoto(
  BuildContext context, {
  required CameraController controller,
  required String wonum,
  required int? id,
  required CameraMode mode,
}) async {
  try {
    final XFile image = await controller.takePicture();

    final imageFile = File(image.path);
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final fileFormat = imageFile.path.split('.').last;

    final appDocumentsDir = await getApplicationDocumentsDirectory();

    final dirPath = appDocumentsDir.path;
    final separator = Platform.pathSeparator;

    final dir = await Directory(
            '$dirPath$separator$wonum${id != null ? '$separator$id' : ''}')
        .create(recursive: true);
    final imagePath = '${dir.path}$separator$timeStamp.$fileFormat';
    // /var/mobile/Containers/Data/Application/25592E34-5A15-438B-87BF-4BCA0FB5CB51/Documents/7141877/1729976570953.jpg

    await image.saveTo(imagePath);

    if (image.path.isNotEmpty) {
      if (id != null) {
        await insertChlwoImagePath(
            checklistwoid: id, wonum: wonum, path: imagePath);
      } else {
        await insertWtmImagePath(wonum: wonum, path: imagePath);
      }
    }

    if (!context.mounted) return;
    switch (mode) {
      case CameraMode.checklist:
        context.store
            .dispatch(findAndUpdateWoInLevels(checklistwoid: id ?? -1));
        break;
      case CameraMode.ppr:
        context.store.dispatch(readSelectedPprFromDbAction(wonum));
        break;
      case CameraMode.rz:
        context.store.dispatch(readSelectedRzFromDbAction(wonum));
        break;
      case CameraMode.claim:
        context.store.dispatch(readSrListFromDbAction());
        break;
    }

    context.pop();
  } catch (e) {
    debugPrint(e.toString());
  }
}
