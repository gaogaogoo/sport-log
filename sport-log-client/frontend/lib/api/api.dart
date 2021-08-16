
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:result_type/result_type.dart';
import 'package:sport_log/api/backend_routes.dart';
import 'package:sport_log/api/api_error.dart';
import 'package:http/http.dart' as http;
import 'package:sport_log/config.dart';
import 'package:sport_log/models/all.dart';

part 'movement_api.dart';
part 'metcon_api.dart';
part 'cardio_api.dart';
part 'diary_api.dart';
part 'wod_api.dart';
part 'strength_api.dart';
part 'user_api.dart';
part 'platform_api.dart';
part 'action.dart';

typedef ApiResult<T> = Future<Result<T, ApiError>>;

class Api {

  static final Api instance = Api._();
  Api._();

  String? _urlBaseOptional;
  String get _urlBase {
    assert(_urlBaseOptional != null, 'forget to call Api().init()');
    return _urlBaseOptional!;
  }

  final _client = http.Client();
  User? _currentUser;

  Future<void> init() async {
    _urlBaseOptional = await Config.apiUrlBase;
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  void removeCurrentUser() {
    _currentUser = null;
  }

  User? get currentUser => _currentUser;

  Uri _uri(String route) => Uri.parse(_urlBase + route);

  void _logError(String message) {
    log(message, name: "API");
  }

  void _handleUnknownStatusCode(http.Response response) {
    _logError("${response.statusCode}\n${response.body}");
  }

  Map<String, String> _makeAuthorizedHeader(String username, String password) {
    final basicAuth = 'Basic '
        + base64Encode(utf8.encode('$username:$password'));
    return {
      'authorization': basicAuth
    };
  }

  Map<String, String> get _authorizedHeader {
    assert(_currentUser != null);
    final username = _currentUser!.username;
    final password = _currentUser!.password;
    return _makeAuthorizedHeader(username, password);
  }

  Map<String, String> get _jsonContentTypeHeader => {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Map<String, String> get _defaultHeaders => {
    ..._authorizedHeader,
    ..._jsonContentTypeHeader,
  };

  Future<Result<T, ApiError>> _request<T>(
      Future<Result<T, ApiError>> Function(http.Client client) req) async {
    try {
      return req(_client);
    } on SocketException {
      return Failure(ApiError.noInternetConnection);
    } catch (e) {
      _logError("Unhandled error: " + e.toString());
      return Failure(ApiError.unhandled);
    }
  }

  Future<Result<T, ApiError>> _get<T>(String route, {
    ApiError? Function(int)? mapBadStatusToApiError,
    Map<String, String>? headers,
  }) async {
    return _request<T>((client) async {
      final response = await client.get(
        _uri(route),
        headers: headers ?? _authorizedHeader,
      );
      if (response.statusCode <= 200 && response.statusCode < 300) {
        final T result = jsonDecode(response.body);
        return Success(result);
      }
      if (mapBadStatusToApiError != null) {
        final ApiError? e = mapBadStatusToApiError(response.statusCode);
        if (e != null) {
          return Failure(e);
        }
      }
      _handleUnknownStatusCode(response);
      return Failure(ApiError.unknown);
    });
  }

  Future<Result<void, ApiError>> _post(String route, Object body, {
    ApiError? Function(int)? mapBadStatusToApiError,
    Map<String, String>? headers,
  }) async {
    return _request((client) async {
      final response = await client.post(
        _uri(route),
        headers: headers ?? _defaultHeaders,
        body: jsonEncode(body),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Success(null);
      }
      if (mapBadStatusToApiError != null) {
        final ApiError? e = mapBadStatusToApiError(response.statusCode);
        if (e != null) {
          return Failure(e);
        }
      }
      if (response.statusCode == 409) {
        return Failure(ApiError.conflict);
      }
      _handleUnknownStatusCode(response);
      return Failure(ApiError.unknown);
    });
  }

  Future<Result<void, ApiError>> _put(String route, Object body, {
    ApiError? Function(int)? mapBadStatusToApiError,
  }) async {
    return _request((client) async {
      final response = await client.put(
        _uri(route),
        headers: _defaultHeaders,
        body: jsonEncode(body),
      );
      if (response.statusCode <= 200 && response.statusCode < 300) {
        return Success(null);
      }
      if (mapBadStatusToApiError != null) {
        final ApiError? e = mapBadStatusToApiError(response.statusCode);
        if (e != null) {
          return Failure(e);
        }
      }
      _handleUnknownStatusCode(response);
      return Failure(ApiError.unknown);
    });
  }
}