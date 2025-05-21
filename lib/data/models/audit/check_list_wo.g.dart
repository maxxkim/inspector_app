// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list_wo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistWo _$ChecklistWoFromJson(Map<String, dynamic> json) => ChecklistWo(
      rsAgr: json['rs_agr'] as bool?,
      checklistOperationId: (json['checklistoperationid'] as num?)?.toInt(),
      locationsCollectionRef: json['locations_collectionref'] as String?,
      rsMpactive: json['rs_mpactive'] as bool?,
      ipcTicketscount: json['ipc_ticketscount'] as String?,
      orderbyNumber: (json['orderbynumber'] as num?)?.toInt(),
      parentId: (json['parentid'] as num?)?.toInt(),
      chlistStatus: json['chliststatus'] as String?,
      woNum: json['wonum'] as String?,
      countLevel: (json['countlevel'] as num?)?.toInt(),
      hasChildren: json['haschildren'] as bool?,
      checklistWoId: (json['checklistwoid'] as num?)?.toInt(),
      description: json['description'] as String?,
      siteId: json['siteid'] as String?,
      rsMasterpoint: json['rs_masterpoint'] as bool?,
      skanned: json['skanned'] as bool?,
      href: json['href'] as String?,
      jpNum: json['jpnum'] as String?,
      rsDefectcommentCollectionRef:
          json['rs_defectcomment_collectionref'] as String?,
      localref: json['localref'] as String?,
      number: json['number'] as String?,
      goal: json['goal'] as String?,
      classid: json['classid'] as String?,
      rsQtypoint: json['rs_qtypoint'] as bool?,
      ipcHasdiag: json['ipc_hasdiag'] as bool?,
      changed: json['changed'] as bool?,
      visited: json['visited'] as bool?,
      doclinks: DocLinks.fromJson(json['doclinks'] as Map<String, dynamic>),
      checklistoperation: (json['checklistoperation'] as List<dynamic>?)
          ?.map((e) => Checklistoperation.fromJson(e as Map<String, dynamic>))
          .toList(),
      rsDefectcomment: (json['rs_defectcomment'] as List<dynamic>?)
          ?.map((e) => RsDefectComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberof: (json['numberof'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChecklistWoToJson(ChecklistWo instance) =>
    <String, dynamic>{
      'rs_agr': instance.rsAgr,
      'checklistoperationid': instance.checklistOperationId,
      'locations_collectionref': instance.locationsCollectionRef,
      'rs_mpactive': instance.rsMpactive,
      'ipc_ticketscount': instance.ipcTicketscount,
      'orderbynumber': instance.orderbyNumber,
      'parentid': instance.parentId,
      'chliststatus': instance.chlistStatus,
      'wonum': instance.woNum,
      'countlevel': instance.countLevel,
      'haschildren': instance.hasChildren,
      'checklistwoid': instance.checklistWoId,
      'description': instance.description,
      'siteid': instance.siteId,
      'rs_masterpoint': instance.rsMasterpoint,
      'skanned': instance.skanned,
      'href': instance.href,
      'jpnum': instance.jpNum,
      'rs_defectcomment_collectionref': instance.rsDefectcommentCollectionRef,
      'localref': instance.localref,
      'number': instance.number,
      'goal': instance.goal,
      'classid': instance.classid,
      'rs_qtypoint': instance.rsQtypoint,
      'doclinks': instance.doclinks,
      'checklistoperation': instance.checklistoperation,
      'rs_defectcomment': instance.rsDefectcomment,
      'numberof': instance.numberof,
      'ipc_hasdiag': instance.ipcHasdiag,
      'changed': instance.changed,
      'visited': instance.visited,
    };
