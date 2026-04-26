import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/analyze_usecase.dart';
import 'analysis_event.dart';
import 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalyzeUseCase _useCase;

  AnalysisBloc(this._useCase) : super(AnalysisInitial()) {
    on<AnalyzeTextRequested>((event, emit) async {
      emit(AnalysisLoading());
      final result = await _useCase(event.text);
      result.fold(
        (failure) => emit(AnalysisFailure(failure)),
        (data) => emit(AnalysisSuccess(data)),
      );
    });

    on<AnalysisReset>((_, emit) => emit(AnalysisInitial()));
  }
}
