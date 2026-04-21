import 'package:get_it/get_it.dart';
import 'features/auth/data/repositories/user_repo_imp.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/use cases/sign_in_usecase.dart';
import 'features/auth/domain/use cases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/rewards/presentation/bloc/rewards_bloc.dart';
import 'features/trip_planner/presentation/bloc/trip_planner_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(signInUseCase: sl(), signUpUseCase: sl()));
  sl.registerFactory(TripPlannerBloc.new);
  sl.registerFactory(RewardsBloc.new);
}
