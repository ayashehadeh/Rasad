import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_place_details_usecase.dart';
import 'place_details_event.dart';
import 'place_details_state.dart';

class PlaceDetailsBloc extends Bloc<PlaceDetailsEvent, PlaceDetailsState> {
  final GetPlaceDetailsUseCase _getPlaceDetailsUseCase;

  PlaceDetailsBloc({required GetPlaceDetailsUseCase getPlaceDetailsUseCase})
    : _getPlaceDetailsUseCase = getPlaceDetailsUseCase,
      super(PlaceDetailsInitial()) {
    on<PlaceDetailsFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(
    PlaceDetailsFetchRequested event,
    Emitter<PlaceDetailsState> emit,
  ) async {
    emit(PlaceDetailsLoading());
    final result = await _getPlaceDetailsUseCase(event.placeId);
    result.fold(
      (error) => emit(PlaceDetailsFailure(error)),
      (details) => emit(PlaceDetailsLoaded(details: details)),
    );
  }
}
