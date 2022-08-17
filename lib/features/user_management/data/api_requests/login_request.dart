 import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String phone;
  final String password;
  final String device_token;

  LoginRequest( {
    required this.phone,
    required this.password,
    required this.device_token,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
