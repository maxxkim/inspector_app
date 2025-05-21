import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/auth/redux/actions.dart';
import 'package:inspector_tps/auth/redux/user_state.dart';
import 'package:inspector_tps/core/change_contour_dialog.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/connection_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  bool _passwordVisible = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    final creds = userController.getCreds();
    usernameController = TextEditingController(text: creds.$1);
    passwordController = TextEditingController(text: creds.$2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return StoreConnector<AppState, bool>(
        converter: (store) => store.state.hasError,
        distinct: true,
        onDidChange: (_, hasError) {
          if (hasError) {
            context.go(AppRoute.error.route);
          }
        },
        builder: (context, vm) {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.deepPurple,
                Colors.black,
              ],
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  _page(),
                  const Positioned(
                      top: 16, left: 10, child: ConnectionIndicator()),
                ],
              ),
            ),
          );
        });
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ..._logo(),
          const SizedBox(height: 20),
          if (!_keyboardVisible) _avatar(),
          const SizedBox(height: 30),
          _inputField(Txt.login, usernameController),
          const SizedBox(height: 30),
          _inputField(Txt.pwd, passwordController, isPassword: true),
          const SizedBox(height: 50),
          _loginBtn(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _avatar() {
    return GestureDetector(
      onLongPress: _changeContour,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle),
        child: const Icon(Icons.person, color: Colors.white, size: 60),
      ),
    );
  }

  List<Widget> _logo() {
    return [
      const Text(Txt.tps, style: TextStyle(fontSize: 28, color: Colors.white)),
      const Text(Txt.estate,
          style: TextStyle(fontSize: 18, color: Colors.white)),
    ];
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
      obscureText: isPassword && !_passwordVisible,
    );
  }

  Widget _loginBtn() {
    return SizedBox(
      height: 56,
      child: StoreConnector<AppState, _VM>(
          converter: (store) => _VM(
              showLoader: store.state.showLoader,
              userState: store.state.userState),
          onDidChange: (_, vm) {
            if (vm.isAuthorized) {
              context.go(getInitialHomeRoute(vm.userState.user));
            }
          },
          distinct: true,
          builder: (context, vm) {
            return vm.showLoader
                ? const SizedBox(
                    height: 56, width: 56, child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      final user = usernameController.text.trim();
                      final pwd = passwordController.text.trim();
                      if (user.isEmpty || pwd.isEmpty) {
                        return;
                      }
                      context.store.dispatch(loginThunk(user, pwd));
                      debugPrint('$user:$pwd');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          Txt.enter,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        )),
                  );
          }),
    );
  }

  void _changeContour() {
    changeContourDialog(context);
  }
}

class _VM extends Equatable {
  final bool showLoader;
  final UserState userState;

  const _VM({required this.showLoader, required this.userState});

  bool get isAuthorized => userState.isAuthorized;

  @override
  List<Object?> get props => [showLoader, userState];
}
