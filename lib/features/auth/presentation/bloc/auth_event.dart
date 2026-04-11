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

  @override
  List<Object?> get props => [fullName, email, phoneNumber, nationalNumber];
}

class SignOutRequested extends AuthEvent {}
