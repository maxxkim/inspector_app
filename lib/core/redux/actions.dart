import 'package:flutter/foundation.dart';
import 'package:inspector_tps/error/app_error.dart';

@immutable
abstract class AppStateAction {}

class ShowLoader implements AppStateAction {}

class HideLoader implements AppStateAction {}

class IsDevAction implements AppStateAction {
  final bool isDev;

  IsDevAction(this.isDev);
}

class AppErrorAction implements AppStateAction {
  final AppError error;

  AppErrorAction(this.error);
}

class ClearErrorAction implements AppStateAction {}

class ClearStateAction implements AppStateAction {}

class TabIndexAction extends AppStateAction {
  final int index;

  TabIndexAction(this.index);
}

class IsConnectedAction extends AppStateAction {
  final bool connected;

  IsConnectedAction(this.connected);
}
