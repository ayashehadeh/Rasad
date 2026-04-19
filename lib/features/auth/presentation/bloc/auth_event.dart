import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String nationalNumber;

  SignUpRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.nationalNumber,
  });

  // FIX: password was missing from props, meaning two SignUpRequested events
  // with the same fields but different passwords would have been treated as
  // equal by Equatable — causing the BLoC to de-duplicate and skip the
  // second emission.
  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    phoneNumber,
    nationalNumber,
  ];
}

class SignOutRequested extends AuthEvent {}

class OtpVerifyRequested extends AuthEvent {
  final String otp;

  OtpVerifyRequested({required this.otp});

  @override
  List<Object?> get props => [otp];
}
