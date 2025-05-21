// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      description: json['description'] as String?,
      assetnum: json['assetnum'] as String?,
      locationDescription: json['locationDescription'] as String?,
      classstructureDescription: json['classstructureDescription'] as String?,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'description': instance.description,
      'assetnum': instance.assetnum,
      'locationDescription': instance.locationDescription,
      'classstructureDescription': instance.classstructureDescription,
    };
