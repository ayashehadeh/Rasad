import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_explore_places_usecase.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetExplorePlacesUseCase _getExplorePlaces;

  ExploreBloc({required GetExplorePlacesUseCase getExplorePlacesUseCase})
    : _getExplorePlaces = getExplorePlacesUseCase,
      super(ExploreInitial()) {
    on<ExploreFetchRequested>(_onFetch);
    on<ExploreRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetch(
    ExploreFetchRequested event,
    Emitter<ExploreState> emit,
  ) async {
    emit(ExploreLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    ExploreRefreshRequested event,
    Emitter<ExploreState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<ExploreState> emit) async {
    final result = await _getExplorePlaces();
    result.fold(
      (error) => emit(ExploreFailure(error)),
      (places) => emit(ExploreLoaded(places: places)),
    );
  }
}
