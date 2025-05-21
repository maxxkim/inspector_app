import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inspector_tps/core/api/dio_interceptor.dart';
import 'package:inspector_tps/core/api/endpoints.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/error/models/maximo_error_response.dart';

class MaximoSession {
  void config() {
    debugPrint('setting dio base url: $getBaseUrl');
    _dio = Dio(
      BaseOptions(
        baseUrl: getBaseUrl,
        responseType: ResponseType.json,
        queryParameters: {...Endpoints.lean},
      ),
    )..interceptors.addAll([
        CookieManager(CookieJar()),
        CustomInterceptors(),
      ]);
    // accept self-signed certificate
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
  }

  late Dio _dio;
  final Map<String, String> headers = {
    'Content-type': 'application/json',
  };

  void addHeaders(Map<String, String> newHeaders) {
    headers.addAll(newHeaders);
  }

  void removeHeaders(Iterable<String> keys) {
    for (var k in keys) {
      headers.remove(k);
    }
  }

  void resetCookie() {
    _dio.interceptors.clear();
    _dio.interceptors.add(CookieManager(CookieJar()));
  }

  void _somethingWentWrong() {
    appStore.dispatch(
        AppErrorAction(MaximoErrorResponse(message: Txt.somethingWentWrong)));
  }

  Future<dynamic> get(
    String url, {
    Map<String, String> headers = const {},
    bool dispatchError = true,
  }) async {
    debugPrint('get dio: ${_dio.options.baseUrl}\nheaders: $headers');
    debugPrint('get url: $url');
    try {
      final options = Options(headers: headers);
      final getResponse = await _dio.get(url, options: options);
      return getResponse;
    } on DioException catch (ex) {
      if (dispatchError) {
        final data = ex.response?.data;
        if (data == '') {
          if (ex.response?.statusCode == 401) {
            appStore.dispatch(AppErrorAction(MaximoErrorResponse(
                message: Txt.unauthorizedMessage,
                statusCode: ex.response?.statusCode.toString())));
          } else {
            _somethingWentWrong();
          }
        } else {
          debugPrint('error data: $data');
          try {
            final map = ex.response?.data?['Error'];
            appStore
                .dispatch(AppErrorAction(MaximoErrorResponse.fromJson(map)));
          } catch (err) {
            _somethingWentWrong();
          }
        }
      }
    } catch (err) {
      if (dispatchError) {
        _somethingWentWrong();
      }
    } finally {
      removeHeaders(headers.keys);
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String> headers = const {},
    Object? data,
  }) async {
    debugPrint('post dio: ${_dio.options.baseUrl}');
    debugPrint('post url: $url');
    debugPrint('post headers: $headers');
    if (data is List<num>) {
      debugPrint('post data: length = ${data.length}');
    } else {
      debugPrint('post data: $data');
    }
    try {
      final options = Options(headers: headers);
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      return response;
    } on DioException catch (ex) {
      debugPrint('Dio post error: $ex');
    } finally {
      removeHeaders(headers.keys);
    }
  }

  void setHeadersForUploadingAttachment() {
    headers['Content-type'] = 'image/png';
    headers['x-document-meta'] = 'Attachments';
  }

  void setHeadersForUpdatingObject() {
    headers['x-method-override'] = 'PATCH';
    headers['properties'] = '*';
  }

  void setHeadersForUpdatingInnerObject() {
    headers['x-method-override'] = 'PATCH';
    headers['patchtype'] = 'MERGE';
    headers['properties'] = '*';
  }

  void setHeadersForUpdatingMaximoObject() {
    headers['x-method-override'] = 'PATCH';
    headers['properties'] = '*';
  }

  void setFileNameHeader(String filename) {
    headers['slug'] = filename;
  }

  void setHeadersForOrdinalRequests() {
    headers['Content-type'] = 'application/json';
    headers.remove('slug');
    headers.remove('x-document-meta');
    // remove from updateClaimRequest
    headers.remove('x-method-override');
    headers.remove('patchtype');
    headers.remove('properties');
  }
}
