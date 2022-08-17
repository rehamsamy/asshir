import 'package:dio/dio.dart';

class VerifyPageArgs {
  final String userName;
  final String? pass;
  final String? phone;
  final int? otpCode;
  final CancelToken? cancelToken;
  final bool? isNeedVerify;
  final String? verifyUrl;
  final String? resendCodeUrl;
  final int? caseOfResendCode;

  VerifyPageArgs({
    this.phone,
    required this.userName,
    this.pass,
    this.otpCode,
    this.cancelToken,
    this.verifyUrl,
    this.resendCodeUrl,
    this.caseOfResendCode,
    this.isNeedVerify = false,
  });
}
