import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constatnts/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onNavigateToSignIn;
  final VoidCallback onSignUpSuccess;

  const SignUpScreen({
    super.key,
    required this.onNavigateToSignIn,
    required this.onSignUpSuccess,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    // FIX: listen to national number changes so the checkmark suffix
    // rebuilds reactively — previously the suffix read
    // _nationalNumberController.text.length inside build() without a
    // listener, so it never updated after the initial render.
    _nationalNumberController.addListener(_onNationalNumberChanged);
  }

  void _onNationalNumberChanged() {
    // Trigger rebuild only when crossing the completion boundary so we
    // don't setState on every keystroke unnecessarily.
    setState(() {});
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // FIX: remove listener before disposing to avoid calling setState
    // on a disposed widget.
    _nationalNumberController.removeListener(_onNationalNumberChanged);
    _nationalNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
          nationalNumber: _nationalNumberController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          widget.onSignUpSuccess();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: JordanBackgroundDecoration(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),

                      // Back button + brand
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isLoading ? null : widget.onNavigateToSignIn,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundElevated,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const RasadBrandHeader(
                            showTagline: false,
                            logoSize: 36,
                          ),
                          const Spacer(),
                          const SizedBox(width: 40),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Text('Join Rasad', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Create your account to start your journey',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 28),

                      _SectionLabel(label: 'Personal Information'),
                      const SizedBox(height: 12),

                      AuthTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.fullName(
                          v,
                          requiredMsg: 'Full name is required',
                          invalidMsg: 'Name must be at least 3 characters',
                        ),
                      ),

                      const SizedBox(height: 14),

                      // FIX: suffix now updates reactively via the listener
                      // added in initState; previously it was stuck at the
                      // initial (empty) value because build() read the
                      // controller length without any setState trigger.
                      AuthTextField(
                        controller: _nationalNumberController,
                        label: 'National Number',
                        hint: 'Enter your 10-digit national number',
                        prefixIcon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        maxLength: AppConstants.nationalNumberLength,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.nationalNumber(
                          v,
                          requiredMsg: 'National number is required',
                          invalidMsg: 'Must be 10 digits starting with 1 or 2',
                        ),
                        suffix:
                            _nationalNumberController.text.length ==
                                AppConstants.nationalNumberLength
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 20,
                              )
                            : null,
                      ),

                      const SizedBox(height: 14),

                      AuthTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: '07XXXXXXXX',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.phoneNumber(
                          v,
                          requiredMsg: 'Phone number is required',
                          invalidMsg:
                              'Please enter a valid Jordanian number (07XXXXXXXX)',
                        ),
                      ),

                      const SizedBox(height: 22),

                      _SectionLabel(label: 'Account Details'),
                      const SizedBox(height: 12),

                      AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.email(
                          v,
                          requiredMsg: 'Email is required',
                          invalidMsg: 'Please enter a valid email',
                        ),
                      ),

                      const SizedBox(height: 14),

                      AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Min 8 chars, uppercase & number',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.password(
                          v,
                          requiredMsg: 'Password is required',
                          weakMsg: 'Min 8 characters with uppercase and number',
                        ),
                      ),

                      const SizedBox(height: 14),

                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => Validators.confirmPassword(
                          v,
                          _passwordController.text,
                          requiredMsg: 'Please confirm your password',
                          mismatchMsg: 'Passwords do not match',
                        ),
                      ),

                      const SizedBox(height: 20),

                      _TermsCheckbox(
                        value: _agreedToTerms,
                        onChanged: isLoading
                            ? null
                            : (v) =>
                                  setState(() => _agreedToTerms = v ?? false),
                      ),

                      const SizedBox(height: 24),

                      AuthPrimaryButton(
                        label: 'Create Account',
                        onPressed: _submit,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 24),

                      const AuthDividerOr(label: 'Or continue with'),
                      const SizedBox(height: 20),

                      SocialSignInButton(
                        label: 'Continue with Google',
                        onPressed: isLoading ? null : () {},
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : widget.onNavigateToSignIn,
                              child: Text(
                                'Sign In',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Local helpers ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: AppColors.border, width: 1.5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'By creating an account, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
