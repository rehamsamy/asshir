import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/errors/base_error.dart';
import 'package:ojos_app/features/user_management/data/api_requests/register_request.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/domain/usecases/register.dart';
import 'package:ojos_app/features/user_management/domain/usecases/resend_code.dart';

import '../../../../main.dart';

abstract class VerifyState extends Equatable {}

class VerifyUninitialized extends VerifyState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'VerifyUninitialized';
}

class VerifyLoading extends VerifyState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'VerifyLoading';
}

class VerifySuccess extends VerifyState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'VerifySuccess';
}

class VerifyFailure extends VerifyState {
  final BaseError error;
  final VoidCallback? callback;

  VerifyFailure({
    required this.error,
    this.callback,
  });

  @override
  List<Object> get props => [error, callback!];

  @override
  String toString() => 'VerifyFailure { error: $error }';
}

class ResendCodeSuccess extends VerifyState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ResendCodeSuccess';
}

class ResendCodeFailure extends VerifyState {
  final BaseError error;
  final VoidCallback? callback;

  ResendCodeFailure({
    required this.error,
    this.callback,
  });

  @override
  List<Object> get props => [error, callback!];

  @override
  String toString() => 'ResendCodeFailure { error: $error }';
}

abstract class BaseVerifyEvent extends Equatable {}

class VerifyEvent extends BaseVerifyEvent {
  final String mobile;
  final String code;
  final CancelToken? cancelToken;
  final String? name;
  final String? password;
  final String? device_token;

  VerifyEvent({
    required this.mobile,
    required this.code,
    this.cancelToken,
    this.name,
    this.password,
    this.device_token,
  });

  @override
  List<Object> get props => [mobile, code, cancelToken!];

  @override
  String toString() => 'VerifyEvent';
}

class ResendCodeEvent extends BaseVerifyEvent {
  final String username;
  final String? device_token;
  final CancelToken? cancelToken;

  ResendCodeEvent({
    required this.username,
    this.cancelToken,
    this.device_token,
  });

  @override
  List<Object> get props => [username, cancelToken!, device_token!];

  @override
  String toString() => 'ResendCodeEvent';
}

class VerifyBloc extends Bloc<BaseVerifyEvent, VerifyState> {
  VerifyBloc() : super(VerifyUninitialized());

  @override
  Stream<VerifyState> mapEventToState(BaseVerifyEvent event) async* {
    if (event is VerifyEvent) {
      yield VerifyLoading();
      // final result = await Verify(locator<UserRepository>())(
      //   VerifyParams(
      //     data: VerifyRequest(
      //       mobile: event.mobile,
      //       code: event.code,
      //     ),
      //     cancelToken: event.cancelToken,
      //   ),
      // );
      final result = await RegisterUseCase(locator<UserRepository>())(
        RegisterParams(
          bodyParam: RegisterRequest(
            name: event.name!,
            mobile: event.mobile,
            password: event.password!,
            device_token: event.device_token!,
          ),
          cancelToken: event.cancelToken!,
        ),
      );

      if (result.hasDataOnly) {
        yield VerifySuccess();
      }
      if (result.hasErrorOnly) {
        yield VerifyFailure(
          error: result.error!,
          callback: () {
            this.add(event);
          },
        );
      }
    }
    if (event is ResendCodeEvent) {
      yield VerifyLoading();
      final result = await ReSendCode(locator<UserRepository>())(
        ReSendCodeParams(
          mobile: event.username,
//          codeType: CODE_CONFIRM_ACCOUNT,
          device_token: event.device_token!,
          cancelToken: event.cancelToken,
        ),
      );
      if (result.hasDataOnly) {
        yield ResendCodeSuccess();
      }
      if (result.hasErrorOnly) {
        yield ResendCodeFailure(
          error: result.error!,
          callback: () {
            this.add(event);
          },
        );
      }
    }
  }
}
