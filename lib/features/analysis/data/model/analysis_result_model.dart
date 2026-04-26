class AnalysisResult {
  final String sentiment; // positive | negative | neutral
  final String category; // infrastructure | safety | environment | etc.
  final String urgency; // high | medium | low

  const AnalysisResult({
    required this.sentiment,
    required this.category,
    required this.urgency,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      sentiment: (json['sentiment'] as String? ?? 'neutral').toLowerCase(),
      category: (json['category'] as String? ?? '').toLowerCase(),
      urgency: (json['urgency'] as String? ?? 'low').toLowerCase(),
    );
  }

  // Helpers used by the UI
  bool get isHighUrgency => urgency == 'high';
  bool get isNegative => sentiment == 'negative';
}
