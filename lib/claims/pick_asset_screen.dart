import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/claims/redux/claims_thunk.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/router.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/core/widgets/loader_with_description.dart';
import 'package:inspector_tps/data/models/ppr/asset.dart';
import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';

class PickAssetScreen extends StatelessWidget {
  const PickAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _VM>(
        converter: (store) => _VM(store.state),
        onInit: (store) {
          context.store.dispatch(readAssetsFromDbAction());
        },
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${Txt.assetsCount} ${vm.assets.length}'),
              actions: [
                IconButton(
                    onPressed: () {
                      context.go(AppRoute.rzDetailed.route);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            body: vm.showLoader
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 16),
                    child: LoaderWithDescription(),
                  )
                : vm.assets.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () {
                                downloadAssets(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Txt.downloadAssets,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 5),
                        child: TypeAheadField<Asset>(
                          builder: (context, controller, focusNode) {
                            return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: Txt.searchAsset,
                                ));
                          },
                          itemBuilder: (context, asset) {
                            final description = asset.description ?? '';
                            final num = asset.assetnum ?? '';
                            final location = asset.locationDescription ?? '';
                            final equipment =
                                asset.classstructureDescription ?? '';
                            return InkWell(
                              onTap: () {
                                context.store.dispatch(updateRzAssetnumAction(
                                    wonum: vm.selectedRz.wonum!,
                                    assetnum: asset.assetnum!));
                                context.go(AppRoute.rzDetailed.route);
                              },
                              child: ListTile(
                                title: Text('$num $description'),
                                subtitle: Text('$location $equipment'),
                              ),
                            );
                          },
                          onSelected: (asset) {},
                          suggestionsCallback: (pattern) =>
                              suggestionsCallback(pattern, vm.assets),
                        ),
                      ),
          );
        });
  }

  Future<List<Asset>> suggestionsCallback(
          String pattern, List<Asset> assets) async =>
      Future<List<Asset>>.delayed(
        const Duration(milliseconds: 300),
        () => assets.where((asset) {
          final description = asset.description ?? '';
          final num = asset.assetnum ?? '';
          final location = asset.locationDescription ?? '';
          final equipment = asset.classstructureDescription ?? '';

          final p = pattern.trim().toLowerCase();
          return '$num $description $location $equipment'
              .toLowerCase()
              .contains(p);
        }).toList(),
      );
}

class _VM extends Equatable {
  final AppState state;

  const _VM(this.state);

  List<Asset> get assets => state.claimsState.assets;

  bool get showLoader => state.showLoader;

  WorkTaskMobile get selectedRz => state.claimsState.selectedRz!;

  @override
  List<Object?> get props => [assets, showLoader];
}
