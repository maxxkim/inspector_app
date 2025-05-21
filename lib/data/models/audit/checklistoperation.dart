import 'package:json_annotation/json_annotation.dart';

part 'checklistoperation.g.dart';

@JsonSerializable()
class Checklistoperation {
  final bool? usingfweight;

  Checklistoperation({this.usingfweight});

  factory Checklistoperation.fromJson(Map<String, dynamic> json) =>
      _$ChecklistoperationFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistoperationToJson(this);
}