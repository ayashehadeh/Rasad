import 'package:dartz/dartz.dart';
import '../repositories/analysis_repository.dart';
import '../../data/model/analysis_result_model.dart';

class AnalyzeUseCase {
  final AnalysisRepository _repo;
  const AnalyzeUseCase(this._repo);

  Future<Either<String, AnalysisResult>> call(String text) =>
      _repo.analyze(text);
}
