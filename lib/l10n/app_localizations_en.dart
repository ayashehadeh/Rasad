// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rasad';

  @override
  String get appTagline => 'Jordan Eye';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '07XXXXXXXX';

  @override
  String get nationalNumber => 'National Number';

  @override
  String get nationalNumberHint => 'Enter your 10-digit national number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get welcomeBackSub => 'Sign in to continue exploring Jordan';

  @override
  String get joinRasad => 'Join Rasad';

  @override
  String get joinRasadSub => 'Create your account to start your journey';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordWeak =>
      'Password must be at least 8 characters with uppercase and numbers';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationFullNameRequired => 'Full name is required';

  @override
  String get validationFullNameShort => 'Name must be at least 3 characters';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationPhoneInvalid =>
      'Please enter a valid Jordanian number (07XXXXXXXX)';

  @override
  String get validationNationalNumberRequired => 'National number is required';

  @override
  String get validationNationalNumberInvalid =>
      'National number must be 10 digits starting with 1 or 2';

  @override
  String get termsAgreement => 'By creating an account, you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorEmailAlreadyExists =>
      'An account with this email already exists.';

  @override
  String get exploreJordan => 'Explore Jordan';

  @override
  String get discoverHiddenGems => 'Discover hidden gems across the Kingdom';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';
}
