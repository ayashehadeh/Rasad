import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme.dart';
import '../../../auth/presentation/widgets/auth_primary_button.dart';
import '../../../auth/presentation/widgets/jordan_background_decoration.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';
import '../widgets/widgets.dart';

class AddReviewScreen extends StatelessWidget {
  final String placeId;
  final String placeName;
  final String userId;
  final VoidCallback onSubmitSuccess;
  final VoidCallback? onBack;

  const AddReviewScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.userId,
    required this.onSubmitSuccess,
    this.onBack,
  });

  void _handleSubmit(BuildContext context, int selectedStars) {
    if (selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    context.read<ReviewBloc>().add(
      ReviewSubmitRequested(
        placeId: placeId,
        userId: userId,
        stars: selectedStars,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          onSubmitSuccess();
        } else if (state is ReviewFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ReviewLoading;

        return Scaffold(
          body: JordanBackgroundDecoration(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),

                    ReviewScreenHeader(
                      onBack: isLoading ? null : (onBack ?? () => Navigator.of(context).pop()),
                    ),

                    const SizedBox(height: 40),

                    Text('Rate Your Visit', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      placeName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.accentGold,
                      ),
                    ),

                    const Spacer(),

                    // Star selector — dispatches ReviewStarSelected
                    StarRatingWidget(
                      selectedStars: state.selectedStars,
                      enabled: !isLoading,
                      onStarTapped: (stars) => context.read<ReviewBloc>().add(
                        ReviewStarSelected(stars),
                      ),
                    ),

                    const Spacer(),

                    AuthPrimaryButton(
                      label: 'Submit Rating',
                      isLoading: isLoading,
                      onPressed: () =>
                          _handleSubmit(context, state.selectedStars),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
