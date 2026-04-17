import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';

class OtpScreen extends StatefulWidget {
  /// The phone number or email the OTP was sent to (for display only)
  final String destination;

  /// 'phone' or 'email'
  final String destinationType;

  final VoidCallback onVerified;
  final VoidCallback onBack;

  const OtpScreen({
    super.key,
    required this.destination,
    this.destinationType = 'phone',
    required this.onVerified,
    required this.onBack,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  static const int _otpLength = 6;
  static const int _resendCooldown = 60;

  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int _secondsLeft = _resendCooldown;
  Timer? _timer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _startTimer();

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();
  bool get _isFilled => _otp.length == _otpLength;

  void _onDigitEntered(int index, String value) {
    if (value.isEmpty) return;

    // Accept only the last character if multiple pasted
    final digit = value.isNotEmpty ? value[value.length - 1] : '';
    _controllers[index].text = digit;
    _controllers[index].selection = TextSelection.collapsed(offset: 1);

    setState(() => _hasError = false);

    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
      if (_isFilled) _submit();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submit() {
    if (!_isFilled) return;
    context.read<AuthBloc>().add(OtpVerifyRequested(otp: _otp));
  }

  void _triggerShake() {
    setState(() => _hasError = true);
    _shakeController.forward(from: 0);
  }

  String get _maskedDestination {
    if (widget.destinationType == 'phone') {
      // Show last 4 digits: ****1234
      if (widget.destination.length > 4) {
        return '****${widget.destination.substring(widget.destination.length - 4)}';
      }
      return widget.destination;
    } else {
      // Show first 3 chars + domain: tes***@example.com
      final parts = widget.destination.split('@');
      if (parts.length == 2 && parts[0].length > 2) {
        return '${parts[0].substring(0, 3)}***@${parts[1]}';
      }
      return widget.destination;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthSignUpSuccess) {
          widget.onVerified();
        } else if (state is AuthFailure) {
          _triggerShake();
          // Clear all fields on failure
          for (final c in _controllers) {
            c.clear();
          }
          _focusNodes[0].requestFocus();
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: JordanBackgroundDecoration(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),

                    // ── Top bar ────────────────────────────────────────
                    Row(
                      children: [
                        GestureDetector(
                          onTap: isLoading ? null : widget.onBack,
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

                    const SizedBox(height: 40),

                    // ── Icon ───────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            widget.destinationType == 'phone'
                                ? Icons.sms_outlined
                                : Icons.mark_email_unread_outlined,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Headline ───────────────────────────────────────
                    Center(
                      child: Text(
                        'Verify Your Code',
                        style: AppTextStyles.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                              text: widget.destinationType == 'phone'
                                  ? 'We sent a 6-digit code to\n'
                                  : 'We sent a verification code to\n',
                            ),
                            TextSpan(
                              text: _maskedDestination,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.accentGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── OTP input row ──────────────────────────────────
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        final shake = _shakeAnimation.value;
                        final offset = shake < 0.5
                            ? shake * 20
                            : (1 - shake) * 20;
                        return Transform.translate(
                          offset: Offset(
                            offset * (shake < 0.25 || shake > 0.75 ? -1 : 1),
                            0,
                          ),
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_otpLength, (i) {
                          return _OtpDigitBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            hasError: _hasError,
                            enabled: !isLoading,
                            onChanged: (v) => _onDigitEntered(i, v),
                            onBackspace: () => _onBackspace(i),
                          );
                        }),
                      ),
                    ),

                    // ── Error hint ─────────────────────────────────────
                    AnimatedOpacity(
                      opacity: _hasError ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            'Invalid code. Please try again.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Verify button ──────────────────────────────────
                    _VerifyButton(
                      isFilled: _isFilled,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),

                    const SizedBox(height: 28),

                    // ── Resend ─────────────────────────────────────────
                    Center(
                      child: _secondsLeft > 0
                          ? RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  const TextSpan(text: "Didn't receive it? "),
                                  TextSpan(
                                    text: 'Resend in ${_secondsLeft}s',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: isLoading ? null : _startTimer,
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Didn't receive it? ",
                                    ),
                                    TextSpan(
                                      text: 'Resend Code',
                                      style: AppTextStyles.labelMedium
                                          .copyWith(
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),
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

// ── OTP Digit Box ──────────────────────────────────────────────────────────────

class _OtpDigitBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.enabled,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  State<_OtpDigitBox> createState() => _OtpDigitBoxState();
}

class _OtpDigitBoxState extends State<_OtpDigitBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFill = widget.controller.text.isNotEmpty;

    Color borderColor;
    if (widget.hasError) {
      borderColor = AppColors.error;
    } else if (_isFocused) {
      borderColor = AppColors.primary;
    } else if (hasFill) {
      borderColor = AppColors.accentGold.withOpacity(0.5);
    } else {
      borderColor = AppColors.border;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: _isFocused
            ? AppColors.primary.withOpacity(0.08)
            : hasFill
                ? AppColors.backgroundElevated
                : AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: _isFocused || widget.hasError ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.onBackspace();
          }
        },
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: AppTextStyles.headlineLarge.copyWith(
            color: widget.hasError ? AppColors.error : AppColors.textPrimary,
            fontSize: 22,
          ),
          cursorColor: AppColors.primary,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

// ── Verify Button with fill animation ─────────────────────────────────────────

class _VerifyButton extends StatelessWidget {
  final bool isFilled;
  final bool isLoading;
  final VoidCallback onPressed;

  const _VerifyButton({
    required this.isFilled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isFilled && !isLoading
            ? AppColors.primary
            : AppColors.backgroundSurface,
        boxShadow: isFilled && !isLoading
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFilled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.textOnPrimary,
                    ),
                  )
                : Text(
                    'Verify Code',
                    style: AppTextStyles.button.copyWith(
                      color: isFilled
                          ? AppColors.textOnPrimary
                          : AppColors.textHint,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}