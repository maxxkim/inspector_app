class SitesResponse {
  List<Site> member;

  SitesResponse({required this.member});

  factory SitesResponse.fromJson(Map<String, dynamic> json) {
    return SitesResponse(
      member:
          (json['member'] as List).map((site) => Site.fromJson(site)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member': member.map((site) => site.toJson()).toList(),
    };
  }
}

class Site {
  String description;
  String value;

  Site({required this.description, required this.value});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      description: json['description'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'site: $value $description';
  }
}
