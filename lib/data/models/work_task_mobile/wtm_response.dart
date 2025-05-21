import 'package:inspector_tps/data/models/work_task_mobile/work_task_mobile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wtm_response.g.dart';

@JsonSerializable()
class WtmResponse {
  final List<WorkTaskMobile>? member;

  WtmResponse({this.member});

  factory WtmResponse.fromJson(Map<String, dynamic> json) => _$WtmResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WtmResponseToJson(this);
}
