// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _MeClient extends MeClient {
  _MeClient._(this._dio, Dio _transport, {this.baseUrl, this.errorLogger})
    : super._(_transport);

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<MeDto> meControllerGet({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MeDto>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late MeDto _value;
    try {
      _value = MeDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> meControllerRemove({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<MeDto> meControllerUpdate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required UpdateMeDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<MeDto>(
      Options(
            method: 'PATCH',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late MeDto _value;
    try {
      _value = MeDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddressDto> addressesControllerCreate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required AddressInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<AddressDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/addresses',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late AddressDto _value;
    try {
      _value = AddressDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddressDto> addressesControllerUpdate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required AddressInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<AddressDto>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/addresses/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late AddressDto _value;
    try {
      _value = AddressDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> addressesControllerRemove({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/addresses/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<CartDto> savedCartControllerGet({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CartDto>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/cart',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late CartDto _value;
    try {
      _value = CartDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CartDto> savedCartControllerPut({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required SaveCartDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<CartDto>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/cart',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late CartDto _value;
    try {
      _value = CartDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SavedDesignDto> savedDesignsControllerCreate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required SavedDesignInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<SavedDesignDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/designs',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late SavedDesignDto _value;
    try {
      _value = SavedDesignDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SavedDesignDto> savedDesignsControllerUpdate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required SavedDesignInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<SavedDesignDto>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/designs/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late SavedDesignDto _value;
    try {
      _value = SavedDesignDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> savedDesignsControllerRemove({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/designs/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> meControllerRegisterDevice({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required RegisterDeviceDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<void>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/devices',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> meControllerRemoveDevice({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String pushToken,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/devices/${pushToken}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<MeControllerExportDataResponse200> meControllerExportData({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MeControllerExportDataResponse200>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/export',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late MeControllerExportDataResponse200 _value;
    try {
      _value = MeControllerExportDataResponse200.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> favoritesControllerAdd({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String slug,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/favorites/${slug}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> favoritesControllerRemove({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String slug,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/favorites/${slug}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<OccasionReminderDto> occasionsControllerCreate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required OccasionReminderInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<OccasionReminderDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/occasions',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late OccasionReminderDto _value;
    try {
      _value = OccasionReminderDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<OccasionReminderDto> occasionsControllerUpdate({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required OccasionReminderInputDto body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<OccasionReminderDto>(
      Options(
            method: 'PUT',
            headers: _headers,
            extra: _extra,
            contentType: 'application/json',
          )
          .compose(
            _dio.options,
            '/v1/me/occasions/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late OccasionReminderDto _value;
    try {
      _value = OccasionReminderDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> occasionsControllerRemove({
    Map<String, Object?> extra = const {
      "openapi.security": [
        {"bearer": []},
      ],
      "openapi.securitySchemes": {
        "bearer": {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"},
      },
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/v1/me/occasions/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
