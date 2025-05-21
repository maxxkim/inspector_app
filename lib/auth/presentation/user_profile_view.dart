import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/auth/redux/actions.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/colors.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/ppr/utils.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserModel?>(
        converter: (store) => store.state.userState.user,
        distinct: true,
        builder: (context, user) {
          final groups = user?.userGroups ?? [];
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: FutureBuilder(
                future: getAppInfo(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(snapshot.data ?? '',
                          style: const TextStyle(fontSize: 14))
                      : const SizedBox.shrink();
                },
              ),
              actions: [
                TextButton.icon(
                    onPressed: () {
                      context.store.dispatch(logoutThunk);
                      context.go(AppRoute.login.route);
                    },
                    icon: const Icon(Icons.exit_to_app_rounded, color: gray),
                    label:
                        const Text(Txt.logout, style: TextStyle(color: gray)))
              ],
            ),
            body: Stack(
              children: [
                Image.asset(
                  "assets/splash.png",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                Container(color: Colors.white.withOpacity(0.85)),
                StoreConnector<AppState, bool>(
                    converter: (store) => store.state.isDev,
                    builder: (context, dev) {
                      return Column(
                        children: [
                          gap20,
                          tile(
                              '${user?.displayName ?? ''} (${user?.loginID ?? ''})',
                              Icons.account_circle),
                          tile(user?.email ?? '', Icons.email),
                          tile(user?.userRole ?? '',
                              Icons.person_pin_circle_outlined),
                          tile(getHost, Icons.network_ping),
                          tile(
                              '${(user?.defaultOrg ?? '')} ${(user?.defaultSite ?? '')}',
                              Icons.domain),
                          tile(Txt.groups, Icons.groups),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              height: 255,
                              child: ListView.builder(
                                itemCount: groups.length,
                                itemBuilder: (context, index) => Text(
                                  groups[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          gap10,
                        ],
                      );
                    }),
              ],
            ),
          );
        });
  }

  Widget tile(String text, IconData icon) => ListTile(
        leading: Icon(icon),
        title: Text(text),
      );
}
