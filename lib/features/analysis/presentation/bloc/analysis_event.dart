abstract class AnalysisEvent {}

class AnalyzeTextRequested extends AnalysisEvent {
  final String text;
  AnalyzeTextRequested(this.text);
}

class AnalysisReset extends AnalysisEvent {}
