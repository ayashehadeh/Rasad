import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart'; 

class SignInUseCase {
  final AuthRepository _repository;
  const SignInUseCase(this._repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
