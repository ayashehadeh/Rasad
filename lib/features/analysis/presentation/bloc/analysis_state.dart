import '../../data/model/analysis_result_model.dart';

abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisSuccess extends AnalysisState {
  final AnalysisResult result;
  AnalysisSuccess(this.result);
}

class AnalysisFailure extends AnalysisState {
  final String message;
  AnalysisFailure(this.message);
}
