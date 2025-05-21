import 'package:inspector_tps/core/camera/camera_screen.dart';

class PhotoParams {
  final int? checklistwoid;
  final String wonum;
  final CameraMode mode;

  PhotoParams({
    this.checklistwoid,
    required this.wonum,
    required this.mode,
  });
}
