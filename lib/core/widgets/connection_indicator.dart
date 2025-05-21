import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:inspector_tps/core/redux/app_state.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state.isConnected),
        builder: (context, vm) {
          return Container(
            decoration: BoxDecoration(
              color: vm.isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            height: 10,
            width: 10,
          );
        });
  }
}

class _VM extends Equatable {
  final bool isConnected;

  const _VM(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
