import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../data/repositories/user_repo_imp.dart';
class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<Either<String, UserEntity>> call({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String nationalNumber,
  }) {
    return _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      nationalNumber: nationalNumber,
    );
  }
}
