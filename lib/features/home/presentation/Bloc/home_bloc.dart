import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_trending_places_usecase.dart';
import '../../domain/use_cases/get_nearby_places_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrendingPlacesUseCase _getTrending;
  final GetNearbyPlacesUseCase _getNearby;

  HomeBloc({
    required GetTrendingPlacesUseCase getTrendingPlacesUseCase,
    required GetNearbyPlacesUseCase getNearbyPlacesUseCase,
  }) : _getTrending = getTrendingPlacesUseCase,
       _getNearby = getNearbyPlacesUseCase,
       super(HomeInitial()) {
    on<HomeFetchRequested>(_onFetch);
    on<HomeRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetch(
    HomeFetchRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    // Keep current data visible while refreshing — re-emit loaded with fresh data.
    await _load(emit);
  }

  Future<void> _load(Emitter<HomeState> emit) async {
    // Fetch both in parallel.
    final results = await Future.wait([_getTrending(), _getNearby()]);

    final trendingResult = results[0];
    final nearbyResult = results[1];

    // If either fails, surface the first error.
    String? error;
    trendingResult.fold((l) => error = l, (_) {});
    if (error != null) {
      emit(HomeFailure(error!));
      return;
    }
    nearbyResult.fold((l) => error = l, (_) {});
    if (error != null) {
      emit(HomeFailure(error!));
      return;
    }

    emit(
      HomeLoaded(
        trending: trendingResult.getOrElse(() => []),
        nearby: nearbyResult.getOrElse(() => []),
      ),
    );
  }
}
