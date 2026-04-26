import 'package:get_it/get_it.dart';
import 'features/auth/data/repositories/user_repo_imp.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/use cases/sign_in_usecase.dart';
import 'features/auth/domain/use cases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/rewards/presentation/bloc/rewards_bloc.dart';
import 'features/trip_planner/data/datasources/trip_planner_local_datasource.dart';
import 'features/trip_planner/data/repositories/trip_planner_repository_impl.dart';
import 'features/trip_planner/domain/repositories/trip_planner_repository.dart';
import 'features/trip_planner/domain/use_cases/get_trip_planner_suggestions_usecase.dart';
import 'features/trip_planner/domain/use_cases/send_trip_planner_message_usecase.dart';
import 'features/trip_planner/presentation/bloc/trip_planner_bloc.dart';
import 'features/explore/data/repositories/explore_repository_impl.dart';
import 'features/explore/domain/repositories/explore_repository.dart';
import 'features/explore/domain/use_cases/get_explore_places_usecase.dart';
import 'features/explore/domain/use_cases/get_place_details_usecase.dart';
import 'features/explore/presentation/bloc/explore_bloc.dart';
import 'features/explore/presentation/bloc/place_details_bloc.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/use_cases/get_nearby_places_usecase.dart';
import 'features/home/domain/use_cases/get_trending_places_usecase.dart';
import 'features/home/presentation/Bloc/home_bloc.dart';
// FIX: register the review feature's dependencies so ReviewBloc
// can be resolved from the service locator (sl) in the router.
import 'package:rasad/features/review/data/repositories/review_repositories_impl.dart';
import 'package:rasad/features/review/domain/repositories/review_repositories.dart';
import 'features/review/domain/use_cases/submit_review_usecase.dart';
import 'features/review/presentation/bloc/review_bloc.dart';
import 'features/analysis/data/datasources/analysis_remote_datasource.dart';
import 'features/analysis/data/model/analysis_result_model.dart';
import 'features/analysis/domain/repositories/analysis_repository.dart';
import 'features/analysis/domain/usecases/analyze_usecase.dart';
import 'features/analysis/presentation/bloc/analysis_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerFactory(() => AuthBloc(signInUseCase: sl(), signUpUseCase: sl()));
  sl.registerFactory(RewardsBloc.new);

  // Trip planner
  sl.registerLazySingleton(() => TripPlannerLocalDataSource());
  sl.registerLazySingleton<TripPlannerRepository>(
    () => TripPlannerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTripPlannerSuggestionsUseCase(sl()));
  sl.registerLazySingleton(() => SendTripPlannerMessageUseCase(sl()));
  sl.registerFactory(
    () => TripPlannerBloc(
      getSuggestionsUseCase: sl(),
      sendMessageUseCase: sl(),
    ),
  );

  // ── Home ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerLazySingleton(() => GetTrendingPlacesUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyPlacesUseCase(sl()));
  sl.registerFactory(
    () => HomeBloc(
      getTrendingPlacesUseCase: sl(),
      getNearbyPlacesUseCase: sl(),
    ),
  );

  // ── Explore ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ExploreRepository>(() => ExploreRepositoryImpl());
  sl.registerLazySingleton(() => GetExplorePlacesUseCase(sl()));
  sl.registerLazySingleton(() => GetPlaceDetailsUseCase(sl()));
  sl.registerFactory(() => ExploreBloc(getExplorePlacesUseCase: sl()));
  sl.registerFactory(() => PlaceDetailsBloc(getPlaceDetailsUseCase: sl()));

  // ── Review ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl());
  sl.registerLazySingleton(() => SubmitReviewUseCase(sl()));
  sl.registerFactory(() => ReviewBloc(submitReviewUseCase: sl()));

  //analyze 
  sl.registerLazySingleton(() => AnalysisRemoteDatasource());
  sl.registerLazySingleton<AnalysisRepository>(
    () => AnalysisRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => AnalyzeUseCase(sl()));
  sl.registerFactory(() => AnalysisBloc(sl()));
}
