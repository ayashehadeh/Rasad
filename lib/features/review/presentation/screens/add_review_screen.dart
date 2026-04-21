import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';

class AddReviewScreen extends StatefulWidget {
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

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _pickedPhotos = [];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context, int selectedStars) {
    if (selectedStars == 0 || _reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add rating and review text'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    context.read<ReviewBloc>().add(
      ReviewSubmitRequested(
        placeId: widget.placeId,
        userId: widget.userId,
        stars: selectedStars,
        comment: _reviewController.text.trim(),
        photos: _pickedPhotos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          widget.onSubmitSuccess();
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
          backgroundColor: const Color(0xFFF4F4F4),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF4F4F4),
            elevation: 0,
            titleSpacing: 0,
            title: Text(
              'Add Review Flow',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            ),
            leading: IconButton(
              onPressed: isLoading ? null : (widget.onBack ?? () => Navigator.of(context).pop()),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopProfileRow(),
                        const SizedBox(height: 12),
                        Text(
                          'SHARE YOUR EXPERIENCE',
                          style: AppTextStyles.caption.copyWith(letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rasad - Jordan Eye\nReview',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: const Color(0xFF202020),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(width: 32, height: 3, color: AppColors.primary),
                        const SizedBox(height: 16),
                        _SectionCard(
                          title: 'Overall Experience',
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final filled = state.selectedStars > index;
                                  return IconButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => context.read<ReviewBloc>().add(
                                              ReviewStarSelected(index + 1),
                                            ),
                                    icon: Icon(
                                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                                      color: const Color(0xFFF2B642),
                                      size: 30,
                                    ),
                                  );
                                }),
                              ),
                              Text(
                                'Tap to rate your visit',
                                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          title: 'What did you love?',
                          child: TextField(
                            controller: _reviewController,
                            minLines: 4,
                            maxLines: 4,
                            enabled: !isLoading,
                            decoration: InputDecoration(
                              hintText: 'Tell other travelers about your visit to Jordan Eye...',
                              filled: true,
                              fillColor: const Color(0xFFF0F0F0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          title: 'Add Photos',
                          child: Row(
                            children: [
                              Expanded(
                                child: _PhotoButton(
                                  icon: Icons.camera_alt_outlined,
                                  label: 'Take Photo',
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          setState(() => _pickedPhotos.add('camera_photo'));
                                        },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _PhotoButton(
                                  icon: Icons.grid_view_rounded,
                                  label: 'From Gallery',
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          setState(() => _pickedPhotos.add('gallery_photo'));
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_pickedPhotos.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${_pickedPhotos.length} photo(s) selected',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7D0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: isLoading ? null : () => _handleSubmit(context, state.selectedStars),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Review'),
                    ),
                  ),
                ),
                const _BottomNavPreview(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge.copyWith(color: const Color(0xFF444444))),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _TopProfileRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 14, backgroundColor: Color(0xFFCECECE)),
        const SizedBox(width: 8),
        Text('Ahlan, Traveler', style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF444444))),
        const Spacer(),
        Text('1,250 pts', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
      ],
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _PhotoButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _BottomNavPreview extends StatelessWidget {
  const _BottomNavPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(icon: Icons.home_filled, label: 'HOME'),
          _NavItem(icon: Icons.travel_explore, label: 'EXPLORE'),
          _NavItem(icon: Icons.verified, label: 'REVIEW', active: true),
          _NavItem(icon: Icons.card_giftcard, label: 'REWARDS'),
          _NavItem(icon: Icons.person, label: 'PROFILE'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textHint;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption.copyWith(color: color, fontSize: 9)),
      ],
    );
  }
}
