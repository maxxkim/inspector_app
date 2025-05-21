import 'dart:convert';

import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/data/models/claims/site_respose.dart';

class PrefsKey {
  static const creds = 'creds';
  static const user = 'user';
  static const dev = 'dev';
  static const host = 'host';
  static const sites = 'sites';
}

void saveHost(String url) {
  prefs.setString(PrefsKey.host, url);
}

String? readHost() {
  return prefs.getString(PrefsKey.host);
}

void saveSites(SitesResponse sites) {
  final sitesMap = sites.toJson();
  prefs.setString(PrefsKey.sites, jsonEncode(sitesMap));
}

List<Site> readSites() {
  final sitesString = prefs.getString(PrefsKey.sites);
  if (sitesString == null) return [];
  final sites = SitesResponse.fromJson(jsonDecode(sitesString));
  return sites.member;
}

bool get areSitesLoaded => readSites().isNotEmpty;

void saveDev(bool dev) {
  prefs.setBool(PrefsKey.dev, dev);
}

bool isDev() {
  final dev = prefs.getBool(PrefsKey.dev);
  return dev ?? false;
}
