// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResultModel _$LoginResultModelFromJson(Map<String, dynamic> json) {
  return LoginResultModel(
    phone: json['phone'] ??"",
    name: json['name'] ??"",
    id: json['id'] ??0,
    tokenType: json['token_type']??"",
    balance: json['balance']??"",
    credit: json['credit']??"",
    debit: json['debit']??"",
    expiresAt: json['expires_at'] ??"",
    otpCode: json['otp_code']??0,
    photo: json['photo'] ??"",
    status: json['status'],
    aboutMe: json['about_me'] ??"",
    address: json['address']??"",
    accessToken: json['access_token']??"",
    email: json['email'] ??"",
  );
}

Map<String, dynamic> _$LoginResultModelToJson(LoginResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo': instance.photo,
      'status': instance.status,
      'phone': instance.phone,
      'otp_code': instance.otpCode,
      'address': instance.address,
      'about_me': instance.aboutMe,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_at': instance.expiresAt,
      'credit': instance.credit,
      'debit': instance.debit,
      'balance': instance.balance,
    };
