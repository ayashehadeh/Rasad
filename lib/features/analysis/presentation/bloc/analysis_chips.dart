import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../data/model/analysis_result_model.dart';

/// Three compact chips: urgency · category · sentiment
/// Drop this anywhere — report card, submit preview, admin list.
class AnalysisChips extends StatelessWidget {
  final AnalysisResult result;
  final bool compact; // true = smaller text, used inside cards

  const AnalysisChips({super.key, required this.result, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _Chip(
          label: _urgencyLabel(result.urgency),
          color: _urgencyColor(result.urgency),
          icon: _urgencyIcon(result.urgency),
          compact: compact,
        ),
        _Chip(
          label: _categoryLabel(result.category),
          color: AppColors.accentGold,
          icon: Icons.category_outlined,
          compact: compact,
        ),
        _Chip(
          label: _sentimentLabel(result.sentiment),
          color: _sentimentColor(result.sentiment),
          icon: _sentimentIcon(result.sentiment),
          compact: compact,
        ),
      ],
    );
  }

  // ── Urgency ──────────────────────────────────────────────────────────────
  String _urgencyLabel(String u) => switch (u) {
    'high' => 'عاجل',
    'medium' => 'متوسط',
    _ => 'منخفض',
  };

  Color _urgencyColor(String u) => switch (u) {
    'high' => AppColors.error,
    'medium' => AppColors.warning,
    _ => AppColors.success,
  };

  IconData _urgencyIcon(String u) => switch (u) {
    'high' => Icons.priority_high_rounded,
    'medium' => Icons.remove_rounded,
    _ => Icons.arrow_downward_rounded,
  };

  // ── Category ─────────────────────────────────────────────────────────────
  String _categoryLabel(String c) {
    if (c.isEmpty) return 'عام';
    // Capitalize first letter, keep rest
    return c[0].toUpperCase() + c.substring(1);
  }

  // ── Sentiment ────────────────────────────────────────────────────────────
  String _sentimentLabel(String s) => switch (s) {
    'positive' => 'إيجابي',
    'negative' => 'سلبي',
    _ => 'محايد',
  };

  Color _sentimentColor(String s) => switch (s) {
    'positive' => AppColors.success,
    'negative' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  IconData _sentimentIcon(String s) => switch (s) {
    'positive' => Icons.sentiment_satisfied_alt_rounded,
    'negative' => Icons.sentiment_dissatisfied_rounded,
    _ => Icons.sentiment_neutral_rounded,
  };
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool compact;

  const _Chip({
    required this.label,
    required this.color,
    required this.icon,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = compact ? 10.0 : 12.0;
    final iconSize = compact ? 11.0 : 13.0;
    final hPad = compact ? 7.0 : 10.0;
    final vPad = compact ? 3.0 : 5.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
