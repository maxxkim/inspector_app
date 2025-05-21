import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/error/app_error.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        distinct: true,
        builder: (context, vm) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/oops.png",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                Container(color: Colors.white.withOpacity(0.8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 150),
                    const Text(
                      Txt.errorTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.red,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        vm.error?.message ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50,
                  left: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.store.dispatch(ClearErrorAction());
                      context.go(AppRoute.getRouteByIndex(vm.tabIndex).route);
                    },
                    child: const Text(Txt.close),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _VM extends Equatable {
  final AppError? error;
  final int tabIndex;

  _VM(AppState state)
      : error = state.error,
        tabIndex = state.tabIndex;

  @override
  List<Object?> get props => [error, tabIndex];
}
