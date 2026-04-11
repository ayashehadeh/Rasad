import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (email == 'test@rasad.jo' && password == 'Test1234') {
        return Right(
          UserModel(
            id: '1',
            fullName: 'Ahmad Al-Khalidi',
            email: email,
            phoneNumber: '0791234567',
            nationalNumber: '1234567890',
            createdAt: DateTime.now(),
          ),
        );
      }
      return const Left('Invalid email or password.');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String nationalNumber,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Right(
        UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          nationalNumber: nationalNumber,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity?>> getCurrentUser() async {
    return const Right(null);
  }
}
