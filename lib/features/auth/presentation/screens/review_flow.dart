import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/widgets/widgets.dart';

class AddReviewScreen extends StatefulWidget {
  final String placeName;
  final VoidCallback onSubmitSuccess;

  const AddReviewScreen({
    super.key,
    required this.placeName,
    required this.onSubmitSuccess,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _selectedStars = 0;
  bool _isLoading = false;

  void _submit() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // replace with real call
    setState(() => _isLoading = false);

    widget.onSubmitSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JordanBackgroundDecoration(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),

                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: _isLoading ? null : () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const RasadBrandHeader(showTagline: false, logoSize: 36),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 40),

                // Place name
                Text('Rate Your Visit', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  widget.placeName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.accentGold,
                  ),
                ),

                const Spacer(),

                // Stars — centered, large
                Center(
                  child: Column(
                    children: [
                      Text(
                        _starLabel(_selectedStars),
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: _selectedStars > 0
                              ? AppColors.accentGold
                              : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final active = i < _selectedStars;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedStars = i + 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(
                                active
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 48,
                                color: active
                                    ? AppColors.accentGold
                                    : AppColors.border,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                AuthPrimaryButton(
                  label: 'Submit Rating',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _starLabel(int stars) {
    switch (stars) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent!';
      default: return 'Tap to rate';
    }
  }
}