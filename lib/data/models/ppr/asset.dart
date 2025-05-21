import 'package:json_annotation/json_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  final String? description;
  final String? assetnum;

  // locations.description
  String? locationDescription;

  // classstructure.description
  String? classstructureDescription;

  Asset({
    this.description,
    this.assetnum,
    this.locationDescription,
    this.classstructureDescription,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'assetnum': assetnum,
      'locationDescription': locationDescription,
      'classstructureDescription': classstructureDescription,
    };
  }

  static Asset fromMap(Map<String, dynamic> map) {
    return Asset(
      description: map['description'] as String?,
      assetnum: map['assetnum'] as String?,
      locationDescription: map['locationDescription'] as String?,
      classstructureDescription: map['classstructureDescription'] as String?,
    );
  }

  static const assetsTable = 'assetsTable';

  static const createAssetsTable = '''
  CREATE TABLE $assetsTable (
      assetnum TEXT,
      description TEXT,
      locationDescription TEXT,
      classstructureDescription TEXT
      );
      ''';

  @override
  String toString() {
    return '${assetnum ?? ''} ${description ?? ''} ${locationDescription ?? ''}'
        ' ${classstructureDescription ?? ''}';
  }
}
