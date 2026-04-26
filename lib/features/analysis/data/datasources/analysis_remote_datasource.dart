import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/analysis_result_model.dart';

class AnalysisRemoteDatasource {
  static const _baseUrl =
      'https://rasad-app-bwcxcjbug5ftfbaw.eastasia-01.azurewebsites.net';

  Future<AnalysisResult> analyze(String text) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/analyze'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'text': text}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AnalysisResult.fromJson(json);
    }

    throw Exception('API error ${response.statusCode}: ${response.body}');
  }
}
