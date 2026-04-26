import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasad/app_router.dart';
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
  final _commentController = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _selectedPhotos = [];

  @override
  void dispose() {
    _commentController.dispose();
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

  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image == null) return;
    setState(() => _selectedPhotos.add(image));
  }

  Future<void> _pickFromGallery() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;
    setState(() => _selectedPhotos.addAll(images));
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
          backgroundColor: const Color(0xFFF3F3F3),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF3F3F3),
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: isLoading
                  ? null
                  : (widget.onBack ?? () => Navigator.of(context).maybePop()),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF9A9A9A),
              ),
            ),
            title: Text(
              'Add Review Flow',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF9A9A9A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TopTravelerRow(),
                          const SizedBox(height: 18),
                          Text(
                            'SHARE YOUR EXPERIENCE',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFFB4B4B4),
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rasad - Jordan Eye\nReview',
                            style: AppTextStyles.displayMedium.copyWith(
                              color: const Color(0xFF222222),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 34,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _CardSection(
                            title: 'Overall Experience',
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    final active = index < state.selectedStars;
                                    return IconButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => context.read<ReviewBloc>().add(
                                              ReviewStarSelected(index + 1),
                                            ),
                                      icon: Icon(
                                        active
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: const Color(0xFFE0B14A),
                                        size: 34,
                                      ),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tap to rate your visit',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF9E9E9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _CardSection(
                            title: 'What did you love?',
                            child: TextField(
                              controller: _commentController,
                              minLines: 4,
                              maxLines: 4,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                hintText:
                                    'Tell other travelers about your visit to ${widget.placeName}...',
                                hintStyle: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFFC4C4C4),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF7F7F7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE8E8E8),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE8E8E8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDDDDDD),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _CardSection(
                            title: 'Add Photos',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _PhotoActionTile(
                                    icon: Icons.photo_camera_outlined,
                                    label: 'Take Photo',
                                    onTap: isLoading ? null : _pickFromCamera,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _PhotoActionTile(
                                    icon: Icons.video_library_outlined,
                                    label: 'From Gallery',
                                    onTap: isLoading ? null : _pickFromGallery,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedPhotos.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 72,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedPhotos.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_selectedPhotos[index].path),
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 72,
                                              height: 72,
                                              color: const Color(0xFFECECEC),
                                              child: const Icon(Icons.broken_image_outlined),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() => _selectedPhotos.removeAt(index));
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleSubmit(context, state.selectedStars),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Submit Review',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const _ReviewBottomNav(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopTravelerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9D9D9),
          ),
          child: const Icon(Icons.person, size: 16, color: Color(0xFF767676)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Ahlan, Traveler',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '1,250 pts',
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF8D7D55),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF3A3A3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _PhotoActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _PhotoActionTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFEFE),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE8D9D9),
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF666666), size: 20),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF656565),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewBottomNav extends StatelessWidget {
  const _ReviewBottomNav();

  @override
  Widget build(BuildContext context) {
    Widget item({
      required IconData icon,
      required String label,
      required bool active,
      VoidCallback? onTap,
    }) {
      final color = active ? AppColors.primary : const Color(0xFF8E8E8E);
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 58,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            item(
              icon: Icons.home_rounded,
              label: 'HOME',
              active: false,
              onTap: () => context.go(AppRoutes.home),
            ),
            item(
              icon: Icons.explore_rounded,
              label: 'EXPLORE',
              active: false,
              onTap: () => context.go(AppRoutes.explore),
            ),
            item(
              icon: Icons.rate_review_rounded,
              label: 'REVIEW',
              active: true,
            ),
            item(icon: Icons.card_giftcard_rounded, label: 'REWARDS', active: false),
            item(icon: Icons.person_outline_rounded, label: 'PROFILE', active: false),
          ],
        ),
      ),
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
