import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'ApiException.dart';
import 'ApiResponse.dart';
import 'Loading.dart';
import 'RequestConfig.dart';
import 'cache.dart';

RequestClient requestClient = RequestClient();

class RequestClient {
  late Dio _dio;

  RequestClient() {
    _dio = Dio(
      BaseOptions(
          baseUrl: RequestConfig.baseUrl,
          connectTimeout: RequestConfig.connectTimeout),
    );
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true),
    );
  }

  Future<T?> request<T>(
    String url, {
    String method = "GET",
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool Function(ApiException)? onError,
    Function()? onRequestComplete,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      Loading().showLoading();
    }
    try {
      data = _convertRequestData(data);
      Options options = Options()
        ..method = method
        ..headers = headers;
      // 发起请求
      Response response = await _dio.request(url,
          queryParameters: queryParameters, data: data, options: options);
      // 处理响应
      T? result = _handleResponse<T>(response);
      // 调用请求完成后的自定义回调
      onRequestComplete?.call();
      return result;
    } catch (e) {
      var exception = ApiException.from(e);
      // 捕获异常后执行 onError 回调
      if (onError?.call(exception) != true) {
        handleException(exception);
      }
    } finally {
      if (showLoading) {
        Loading().dismissLoading();
      }
    }
    return null;
  }

  Future<T?> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        queryParameters: queryParameters, headers: headers, onError: onError);
  }

  Future<T?> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool Function(ApiException)? onError,
  }) {
    return request(url,
        method: "POST",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError);
  }

  _convertRequestData(data) {
    if (data != null) {
      data = jsonDecode(jsonEncode(data));
    }
    return data;
  }

  bool handleException(ApiException exception) {
    Loading()
        .showErrorLoading(exception.message ?? ApiException.unknownException);
    return false;
  }

  T? _handleResponse<T>(Response response) {
    if (response.statusCode == 200) {
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => json as T,
      ); // 作为 fromJsonT 参数传入
      return _handleBusinessResponse<T>(apiResponse);
    } else {
      throw ApiException(response.statusCode, ApiException.unknownException);
    }
  }

  T? _handleBusinessResponse<T>(ApiResponse<T> response) {
    if (response.code == RequestConfig.successCode) {
      return response.data;
    } else {
      return null;
    }
  }
}

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = Cache.getToken();
    options.headers["Authorization"] = "Bearer $token";
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}
