import 'package:dartz/dartz.dart';
import '../../data/datasources/analysis_remote_datasource.dart';
import '../../data/model/analysis_result_model.dart';

abstract class AnalysisRepository {
  Future<Either<String, AnalysisResult>> analyze(String text);
}

class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisRemoteDatasource _datasource;
  AnalysisRepositoryImpl(this._datasource);

  @override
  Future<Either<String, AnalysisResult>> analyze(String text) async {
    try {
      final result = await _datasource.analyze(text);
      return Right(result);
    } catch (e) {
      return Left('فشل التحليل: ${e.toString()}');
    }
  }
}
