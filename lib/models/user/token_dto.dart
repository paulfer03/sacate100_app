// lib/models/user/token_dto.dart

class TokenDto {
  final String token;

  TokenDto({required this.token});

  factory TokenDto.fromJson(Map<String, dynamic> json) {
    return TokenDto(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}