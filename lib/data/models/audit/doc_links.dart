import 'package:json_annotation/json_annotation.dart';

part 'doc_links.g.dart';

@JsonSerializable()
class DocLinks {
  final String? href;

  DocLinks({this.href});

  factory DocLinks.fromJson(Map<String, dynamic> json) =>
      _$DocLinksFromJson(json);

  Map<String, dynamic> toJson() => _$DocLinksToJson(this);
}
