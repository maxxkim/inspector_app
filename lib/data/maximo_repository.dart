import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/core/constants.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/data/local_storages/local_db.dart';
import 'package:inspector_tps/data/models/audit/check_list_wo.dart';
import 'package:inspector_tps/data/models/audit/rs_defect_comment.dart';
import 'package:inspector_tps/data/models/claims/site_respose.dart';
import 'package:inspector_tps/data/models/claims/sr.dart';
import 'package:inspector_tps/data/models/ppr/woactivity.dart';
import 'package:inspector_tps/data/models/user/user_model.dart';
import 'package:inspector_tps/data/models/work_task_mobile/wtm_response.dart';

base class MaximoRepository {
  final MaximoSession _session;

  MaximoRepository(this._session);

  // Audits

  Future<WtmResponse?> downloadAudits() async {
    final user = appStore.state.userState.user;
    final url = Endpoints.downloadAudits(
      siteId: _getSiteId(user),
      workType: _getAuditWorkType(user),
    );

    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final audit = WtmResponse.fromJson(response.data);
        return audit;
      } catch (ex) {
        debugPrint('download audits error: $ex');
        return null;
      }
    }
    return null;
  }

  String _getAuditWorkType(UserModel? user) {
    final userGroups = user?.userGroups ?? [];
    if (userGroups.contains(bdd)) {
      return '["ФНА","ФМА"]';
    }
    if (userGroups.contains(hoemp)) {
      return '["КВОСМ"]';
    }
    if (user?.isItr ?? false) {
      return '["ФНА"]';
    }
    return '["NA"]';
  }

  String? _getSiteId(UserModel? user) {
    if (user?.userGroups?.contains(hoemp) ?? false) {
      return null;
    }
    return user?.defaultSite ?? '';
  }

  Future<List<ChecklistWo>?> downloadAuditChecklists(String href) async {
    final url = '$href${Endpoints.selectChecklistwo}';
    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final data = response.data as Map<String, dynamic>;
        final chlwo = data['checklistwo'] as List<dynamic>;
        final List<ChecklistWo> checkLists = [];

        for (var e in chlwo) {
          final map = e as Map<String, dynamic>;
          final elem = ChecklistWo.fromJson(map);
          checkLists.add(elem);
        }
        return checkLists;
      } catch (ex) {
        debugPrint('download audit error: $url\n$ex');
        return null;
      }
    }
    return null;
  }

  Future<bool> updateChecklistWo({
    required String url,
    String? comment,
    String? status,
    bool? checked,
    double? factor,
  }) async {
    final updateObject = {
      if (comment != null) "goal": comment,
      if (status != null) "chliststatus": status,
      if (checked != null) "rs_masterpoint": checked,
      if (factor != null) "numberof": factor,
    };

    final Response response = await _session.post(
      url,
      headers: {
        'x-method-override': 'PATCH',
        'properties': '*',
      },
      data: updateObject,
    );
    return response.statusCode == 200;
  }

  Future<String?> getWoHref(int id) async {
    final url =
        '$baseUrlOslcOs${Endpoints.checklistWo}?oslc.where=checklistwoid=$id';

    await userController.checkAuthorization();

    final Response response = await _session.get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final member = data['member'] as List<dynamic>;
      final href = member.first['href'];
      return href;
    }

    return null;
  }

  Future<void> uploadImagesToMaximo({
    required List<String> paths,
    required String docLink,
    required String table,
  }) async {
    for (String path in paths) {
      await _uploadImageAttachmentToMaximoResource(path, docLink, table);
    }
  }

  Future<void> _uploadImageAttachmentToMaximoResource(
      String path, String docLink, String table) async {
    var file = File(path);
    if (await file.exists()) {
      final Uint8List data = file.readAsBytesSync();
      var filename = path.split('/').last;
      _session.setFileNameHeader(filename);

      final Response response =
          await _session.post(docLink, data: data, headers: {
        'Content-type': 'image/png',
        'x-document-meta': 'Attachments',
        'slug': filename,
      });

      debugPrint(
          'upload image response: ${response.statusCode} ${response.statusMessage}');

      if (response.statusCode == 201) {
        await markImageAsSent(path, table);
      }
    }
  }

  Future<bool> createRsDefectCommentForChecklistWo({
    required RsDefectComment rsComment,
  }) async {
    const url = Endpoints.createRsDefectComment;

    final payload = '''
    {"checklistoperationid": ${rsComment.checklistOperationId},
    "comment": "${rsComment.comment}",
    "orgid": "TPS",
    "notcreatesr": true,
    "wonum": "${rsComment.woNum}",
    "checklistwoid": ${rsComment.checklistWoId},
    "siteid": "${rsComment.siteId}"}
    ''';

    debugPrint('creating RsDefectComment url: $url\n$payload');

    Response? response;
    try {
      response = await _session.post(
        url,
        data: payload,
      );
      debugPrint(
          'create RsDefectComment response headers: ${response?.headers} status code: ${response?.statusCode}');
      if (response?.statusCode == 201) {
        // final createdSrLink = response?.headers['location']?.first;
        // print('created sr link: $createdSrLink');
        // if (createdSrLink != null && createdSrLink.isNotEmpty) {
        //   final createdSrResponse = await _session.get(createdSrLink);
        //   final sr = Sr.fromJson(createdSrResponse.data);
        //   return sr;
        // }
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint('create RsComment error: $err');
      return false;
    }
  }

  // PPR
  Future<WtmResponse?> downloadPprs({required String date}) async {
    final user = appStore.state.userState.user;

    final url = Endpoints.downloadPpr(
        siteId: _getSiteId(user),
        date: date,
        pprStatuses: _getPprStatuses(user));
    debugPrint(url);

    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final wtmResponse = WtmResponse.fromJson(response.data);
        return wtmResponse;
      } catch (ex) {
        debugPrint('download ppr error: $ex');
        return null;
      }
    }
    return null;
  }

  String _getPprStatuses(UserModel? user) {
    if (user?.isItrAndDutyEng ?? false) {
      return '["$statusApproved","$statusAssigned","$statusRejected","$statusCompleted"]';
    } else if (user?.isItr ?? false) {
      return '["$statusCompleted"]';
    }
    if (user?.isFilManager ?? false) {
      return '["$statusPreApproved"]';
    }
    return '["$statusApproved","$statusAssigned","$statusRejected"]';
  }

  Future<WtmResponse?> downloadWtmByWonum(String wonum) async {
    final url = Endpoints.downloadPprByWonum(wonum);
    debugPrint(url);

    final Response response = await _session.get(url);

    if (response.statusCode == 200) {
      try {
        final wtmResponse = WtmResponse.fromJson(response.data);
        return wtmResponse;
      } catch (ex) {
        debugPrint('download WTM error: $ex');
        return null;
      }
    }
    return null;
  }

  Future<bool> runScript(
    String wonum, {
    required String script,
    String description = '',
  }) async {
    final url = '${Endpoints.script}/$script?VAL=$wonum';

    try {
      final response = await _session.get(url);
      if (response.statusCode == 200) {
        debugPrint('$wonum $description');
      }
    } catch (ex) {
      debugPrint('$description error: $ex');
      return false;
    }
    return true;
  }

  Future<bool> addCommentToWorkTaskMobile(String link, String comment) async {
    _session.setHeadersForUpdatingInnerObject();
    //
    final payload = '{"worklog": [{"description": "$comment"}]}';

    print(link);
    Response? response;
    try {
      response = await _session.post(
        link,
        data: payload,
        headers: {
          'x-method-override': 'PATCH',
          'patchtype': 'MERGE',
          'properties': '*',
        },
      );
    } catch (err) {
      debugPrint('send comment error: $err');
      return false;
    }
    print('response: $response');
    return response?.statusCode == 200;
  }

  Future<bool> updateWoactivity(Woactivity job) async {
    final updateObject = {
      if (job.pprcomment != null && job.pprcomment!.isNotEmpty)
        "pprcomment": '${job.pprcomment}',
      "pprresult": job.pprresult,
    };

    final Response response = await _session.post(
      await getTestwoactivityHref(job) ?? '',
      headers: {
        'x-method-override': 'PATCH',
        'properties': '*',
      },
      data: updateObject,
    );
    print('update woactivity response: $response');
    return response.statusCode == 200;
  }

  String _generateLink(Woactivity job) {
    final link = '$baseUrlOslcOs/ilcwoactivity?lean=1&oslc.where=parent%3D%22'
        '${job.wonum}%22%20and%20taskid%3D${job.taskid}';
    return link;
  }

  Future<String?> getTestwoactivityHref(Woactivity job) async {
    await userController.checkAuthorization();

    final Response response = await _session.get(_generateLink(job));

    if (response.statusCode == 200) {
      final data = response.data;
      final member = data['member'] as List<dynamic>;
      final href = member.first['href'];
      return href;
    }
    return null;
  }

// RZ
  Future<WtmResponse?> downloadRzList() async {
    final user = appStore.state.userState.user;

    final url = Endpoints.downloadRzList(siteId: _getSiteId(user));
    debugPrint(url);

    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final wtmResponse = WtmResponse.fromJson(response.data);
        return wtmResponse;
      } catch (ex) {
        debugPrint('download rz list error: $ex');
        return null;
      }
    }
    return null;
  }

  Future<bool> uploadAssetnumToWorkTaskMobile(
      String link, String assetNum) async {
    _session.setHeadersForUpdatingInnerObject();
    //
    final payload = '{"assetnum": "$assetNum"}';

    print('update assetnum link: ${link}');
    Response? response;
    try {
      response = await _session.post(
        link,
        data: payload,
        headers: {
          'x-method-override': 'PATCH',
          'patchtype': 'MERGE',
          'properties': '*',
        },
      );
    } catch (err) {
      debugPrint('update assetnum link error: $err');
      return false;
    }
    print('update assetnum link response: $response');
    return response?.statusCode == 200;
  }

  Future<List<dynamic>?> downloadAssetsCatalog() async {
    final user = appStore.state.userState.user;

    final url = Endpoints.downloadAssetsCatalog(siteId: _getSiteId(user));
    debugPrint(url);

    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final member = response.data['member'] as List<dynamic>;
        return member;
      } catch (ex) {
        debugPrint('download assets catalog error: $ex');
        return null;
      }
    }
    return null;
  }

  Future<SitesResponse?> downloadSites() async {
    const url = Endpoints.downloadSites;
    debugPrint(url);

    final Response response = await _session.get(url);
    if (response.statusCode == 200) {
      try {
        final sitesResponse = SitesResponse.fromJson(response.data);
        return sitesResponse;
      } catch (ex) {
        debugPrint('download sites error: $ex');
        return null;
      }
    }
    return null;
  }

  Future<Sr?> createSr({
    required String location,
    required String description,
    required String siteId,
  }) async {
    const url = Endpoints.createSr;

    final user = appStore.state.userState.user;

    final payload = '''
    {
    "class": "SR",
    "repcat": "9",
    "type": "8",
    "description": "$description",
    "targetdesc": "${user?.userRole ?? (user?.defaultSite ?? '')}",
    "fromwho": "${user?.displayName ?? (user?.personId ?? '')}",
    "locdesc": "$location",
    "reportedpriority": 3,
    "siteid": "$siteId",
    "classstructureid": "1869"}
    ''';

    debugPrint('creating SR url: $url\n$payload');

    Response? response;
    try {
      response = await _session.post(
        url,
        data: payload,
      );
      if (response?.statusCode == 201) {
        final createdSrLink = response?.headers['location']?.first;
        print('created sr link: $createdSrLink');
        if (createdSrLink != null && createdSrLink.isNotEmpty) {
          final createdSrResponse = await _session.get(createdSrLink);
          final sr = Sr.fromJson(createdSrResponse.data);
          return sr;
        }
      }
    } catch (err) {
      debugPrint('create SR error: $err');
      return null;
    }

    debugPrint(
        'response headers: ${response?.headers} status code: ${response?.statusCode}');
    return null;
  }
}
