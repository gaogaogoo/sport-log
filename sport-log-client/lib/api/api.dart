import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart' as l;
import 'package:result_type/result_type.dart';
import 'package:sport_log/config.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/models/all.dart';
import 'package:sport_log/models/error_message.dart';
import 'package:sport_log/models/server_version/server_version.dart';
import 'package:sport_log/settings.dart';

part 'accessors/account_data_api.dart';
part 'accessors/action_api.dart';
part 'accessors/cardio_api.dart';
part 'accessors/diary_api.dart';
part 'accessors/metcon_api.dart';
part 'accessors/movement_api.dart';
part 'accessors/platform_api.dart';
part 'accessors/strength_api.dart';
part 'accessors/user_api.dart';
part 'accessors/wod_api.dart';

enum ApiErrorType {
  // http error
  badRequest("Request is not valid."), // 400
  unauthorized("User unauthorized."), // 401
  forbidden("Access to resource is forbidden."), // 403
  notFound("Resource not found."), // 404
  conflict("Conflict with resource."), // 409
  internalServerError("Internal server error."), // 500
  // unknown status code != 200, 204, 400, 401, 403, 404, 409, 500 request error
  unknownServerError("Unknown server error."),
  serverUnreachable("Unable to establish a connection with the server."),
  badJson("Got bad json from server."),
  unknownRequestError("Unhandled request error."); // unknown request error

  const ApiErrorType(this.description);

  final String description;
}

class ApiError {
  ApiError(this.errorType, this.errorCode, [this.message]);

  final ApiErrorType errorType;
  final int? errorCode;

  final ErrorMessage? message;

  @override
  String toString() {
    final description = errorType.description;
    final errorCodeStr = errorCode != null ? " (status $errorCode)" : "";
    final messageStr = message != null ? "\n$message" : "";
    return "$description$errorCodeStr$messageStr";
  }
}

typedef ApiResult<T> = Result<T, ApiError>;

extension _ToApiResult on Response {
  ErrorMessage? get _message => HandlerError.fromJson(
        jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>,
      ).message;

  ApiResult<T?> _mapToApiResult<T>(T Function()? fromJson) {
    switch (statusCode) {
      case 200:
        return Success(fromJson?.call());
      case 204:
        return fromJson == null
            ? Success(null)
            : Failure(
                ApiError(ApiErrorType.unknownServerError, statusCode),
              ); // value needed but nothing returned
      case 400:
        return Failure(ApiError(ApiErrorType.badRequest, statusCode, _message));
      case 401:
        return Failure(
          ApiError(ApiErrorType.unauthorized, statusCode, _message),
        );
      case 403:
        return Failure(ApiError(ApiErrorType.forbidden, statusCode, _message));
      case 404:
        return Failure(ApiError(ApiErrorType.notFound, statusCode, _message));
      case 409:
        return Failure(ApiError(ApiErrorType.conflict, statusCode, _message));
      case 500:
        return Failure(
          ApiError(ApiErrorType.internalServerError, statusCode, _message),
        );
      default:
        return Failure(
          ApiError(ApiErrorType.unknownServerError, statusCode, _message),
        );
    }
  }

  ApiResult<void> toApiResult() => _mapToApiResult(null);

  ApiResult<T> toApiResultWithValue<T>(T Function(dynamic) fromJson) {
    final result = _mapToApiResult(
      () => fromJson(jsonDecode(utf8.decode(bodyBytes))),
    );
    return result.isSuccess
        ? Success(result.success as T)
        : Failure(result.failure);
  }
}

extension ApiResultFromRequest<T> on ApiResult<T> {
  static final _ioClient = HttpClient()..connectionTimeout = Config.httpTimeout;
  static final _client = IOClient(_ioClient);

  static Future<ApiResult<T>> _handleError<T>(
    Future<ApiResult<T>> Function() request,
  ) async {
    try {
      return await request();
    } on SocketException {
      return Failure(ApiError(ApiErrorType.serverUnreachable, null));
    } on TypeError {
      return Failure(ApiError(ApiErrorType.badJson, null));
    } catch (e) {
      ApiLogging.logger.e("Unhandled error", e);
      return Failure(ApiError(ApiErrorType.unknownRequestError, null));
    }
  }

  static Future<ApiResult<void>> fromRequest(
    Future<Response> Function(Client client) request,
  ) =>
      _handleError(() async {
        final response = await request(_client);
        return response.toApiResult();
      });

  static Future<ApiResult<T>> fromRequestWithValue<T>(
    Future<Response> Function(Client client) request,
    T Function(dynamic) fromJson,
  ) =>
      _handleError(() async {
        final response = await request(_client);
        return response.toApiResultWithValue(fromJson);
      });
}

abstract class Api<T extends JsonSerializable> with ApiLogging, ApiHelpers {
  static final accountData = AccountDataApi();
  static final user = UserApi();
  static final actions = ActionApi();
  static final actionProviders = ActionProviderApi();
  static final actionRules = ActionRuleApi();
  static final actionEvents = ActionEventApi();
  static final cardioSessions = CardioSessionApi();
  static final routes = RouteApi();
  static final diaries = DiaryApi();
  static final metcons = MetconApi();
  static final metconSessions = MetconSessionApi();
  static final metconMovements = MetconMovementApi();
  static final movements = MovementApi();
  static final platforms = PlatformApi();
  static final platformCredentials = PlatformCredentialApi();
  static final strengthSessions = StrengthSessionApi();
  static final strengthSets = StrengthSetApi();
  static final wods = WodApi();

  static Future<ApiResult<ServerVersion>> getServerVersion() {
    const route = "/version";
    return ApiResultFromRequest.fromRequestWithValue<ServerVersion>(
      (client) => client.get(UriFromRoute.fromRoute(route)),
      (dynamic json) => ServerVersion.fromJson(json as Map<String, dynamic>),
    );
  }

  // things needed to be overridden
  T _fromJson(Map<String, dynamic> json);

  /// everything after version, e. g. '/user'
  String get _route;

  String get _path => "/v${Config.apiVersion}$_route";
  Map<String, dynamic> _toJson(T object) => object.toJson();

  Future<ApiResult<T>> getSingle(Int64 id) async {
    return _getRequest(
      '$_path?id=$id',
      (dynamic json) => _fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<List<T>>> getMultiple() async {
    return _getRequest(
      _path,
      (dynamic json) => (json as List<dynamic>)
          .map((dynamic json) => _fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResult<void>> postSingle(T object) async {
    return ApiResultFromRequest.fromRequest((client) async {
      final body = _toJson(object);
      final headers = _ApiHeaders._basicAuthContentTypeJson;
      _logRequest('POST', _path, headers, body);
      final response = await client.post(
        UriFromRoute.fromRoute(_path),
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    });
  }

  Future<ApiResult<void>> postMultiple(List<T> objects) async {
    if (objects.isEmpty) {
      return Success(null);
    }
    return ApiResultFromRequest.fromRequest((client) async {
      final body = objects.map(_toJson).toList();
      final headers = _ApiHeaders._basicAuthContentTypeJson;
      _logRequest('POST', _path, headers, body);
      final response = await client.post(
        UriFromRoute.fromRoute(_path),
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    });
  }

  Future<ApiResult<void>> putSingle(T object) async {
    return ApiResultFromRequest.fromRequest((client) async {
      final body = _toJson(object);
      final headers = _ApiHeaders._basicAuthContentTypeJson;
      _logRequest('PUT', _path, headers, body);
      final response = await client.put(
        UriFromRoute.fromRoute(_path),
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    });
  }

  Future<ApiResult<void>> putMultiple(List<T> objects) async {
    if (objects.isEmpty) {
      return Success(null);
    }
    return ApiResultFromRequest.fromRequest((client) async {
      final body = objects.map(_toJson).toList();
      final headers = _ApiHeaders._basicAuthContentTypeJson;
      _logRequest('PUT', _path, headers, body);
      final response = await client.put(
        UriFromRoute.fromRoute(_path),
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    });
  }
}

class _ApiHeaders {
  static Map<String, String> _basicAuthFromParts(
    String username,
    String password,
  ) =>
      {
        'authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}'
      };

  static const Map<String, String> _contentTypeJson = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Map<String, String> get _basicAuth => _basicAuthFromParts(
        Settings.instance.username!,
        Settings.instance.password!,
      );

  static Map<String, String> get _basicAuthContentTypeJson => {
        ..._basicAuth,
        ..._contentTypeJson,
      };
}

mixin ApiLogging {
  static final logger = Logger('API');

  String _prettyJson(dynamic json, {int indent = 2}) {
    final spaces = ' ' * indent;
    return JsonEncoder.withIndent(spaces).convert(json);
  }

  void _logRequest(
    String httpMethod,
    String route,
    Map<String, String> headers, [
    dynamic json,
  ]) {
    final headersStr = Config.instance.outputRequestHeaders
        ? "\n${headers.entries.map((e) => '${e.key}: ${e.value}').join('\n')}"
        : "";
    final jsonStr = json != null && Config.instance.outputRequestJson
        ? "\n\n${_prettyJson(json)}"
        : "";
    logger.d(
      "request: $httpMethod ${Settings.instance.serverUrl}$route$headersStr$jsonStr",
    );
  }

  void _logResponse(Response response) {
    final successful = response.statusCode >= 200 && response.statusCode < 300;
    final headerStr = Config.instance.outputResponseHeaders
        ? "\n${response.headers.entries.map((e) => "${e.key}: ${e.value}").join("\n")}"
        : "";
    final body = utf8.decode(response.bodyBytes);
    final bodyStr =
        body.isNotEmpty && (!successful || Config.instance.outputResponseJson)
            ? '\n\n${_prettyJson(jsonDecode(body))}'
            : "";
    logger.log(
      successful ? l.Level.debug : l.Level.error,
      'response: ${response.statusCode}$headerStr$bodyStr',
    );
  }
}

extension UriFromRoute on Uri {
  static Uri fromRoute(String route) =>
      Uri.parse(Settings.instance.serverUrl + route);
}

mixin ApiHelpers on ApiLogging {
  Future<ApiResult<T>> _getRequest<T>(
    String route,
    T Function(dynamic) fromJson,
  ) async {
    return ApiResultFromRequest.fromRequestWithValue<T>(
      (client) async {
        final headers = _ApiHeaders._basicAuth;
        _logRequest('GET', route, headers);
        final response = await client.get(
          UriFromRoute.fromRoute(route),
          headers: headers,
        );
        _logResponse(response);
        return response;
      },
      fromJson,
    );
  }
}
