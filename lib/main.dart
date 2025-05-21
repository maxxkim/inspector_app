import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';

import 'core/redux/app_state.dart';
import 'core/sl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  if (kReleaseMode) {
    debugPrint = (String? _, {int? wrapWidth}) {};
  }
  await initSl();
  await _initApp();
  runApp(const App());
}

Future<void> _initApp() async {
  final dev = isDev();
  appStore.dispatch(IsDevAction(dev));
  final savedHost = readHost();
  if (savedHost == null) {
    saveHost(Endpoints.devHost);
  }
  sl<MaximoSession>().config();
  userController.getUser();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp.router(
        title: Txt.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ).copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.white,
            )
          ),
        ),
        routerConfig: AppNavigator().router,
      ),
    );
  }
}
