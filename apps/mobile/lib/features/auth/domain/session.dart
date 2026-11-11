import 'dart:convert';

import 'package:belle_biens/core/api/generated/belle_api.dart';

/// The signed-in customer: tokens plus the profile returned with them.
class Session {
  const new({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory fromAuth(AuthSessionDto dto) => Session(
    accessToken: dto.accessToken,
    refreshToken: dto.refreshToken,
    user: dto.user,
  );

  factory fromJson(String source) {
    final json = jsonDecode(source) as Map<String, Object?>;
    return Session(
      accessToken: json['accessToken']! as String,
      refreshToken: json['refreshToken']! as String,
      user: MeDto.fromJson(json['user']! as Map<String, Object?>),
    );
  }

  final String accessToken;
  final String refreshToken;
  final MeDto user;

  Session copyWith({String? accessToken, String? refreshToken, MeDto? user}) =>
      Session(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        user: user ?? this.user,
      );

  String toJson() => jsonEncode({
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'user': user.toJson(),
  });
}
