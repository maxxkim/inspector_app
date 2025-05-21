import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:inspector_tps/data/maximo_repository.dart';
import 'package:inspector_tps/auth/user_controller.dart';
import 'package:inspector_tps/auth/user_repository.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/redux/reducer.dart';
import 'package:inspector_tps/core/services/connectivity_service.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final sl = GetIt.instance;

Future<void> initSl() async {
  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  sl.registerSingleton<MaximoSession>(MaximoSession());
  sl.registerSingleton<UserRepository>(UserRepository(sl()));
  sl.registerSingleton<UserController>(UserController(sl()));
  sl.registerSingleton<MaximoRepository>(MaximoRepository(sl()));

  // db
  sl.registerSingleton<Database>(await openAuditDatabase());

  // redux
  final store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initial(),
    middleware: [
      thunkMiddleware,
    ],
  );
  sl.registerSingleton(store);

  final cameras = await availableCameras();
  if (cameras.isNotEmpty) {
    _camera = cameras.first;
  }
  sl.registerSingleton(ConnectivityService());
}

late final CameraDescription _camera;

SharedPreferences get prefs => sl<SharedPreferences>();

CameraDescription get appCamera => _camera;

Store<AppState> get appStore => sl<Store<AppState>>();

UserController get userController => sl<UserController>();

Database get db => sl<Database>();

MaximoRepository get maximoRepository => sl<MaximoRepository>();

ConnectivityService get connectivityService => sl<ConnectivityService>();
